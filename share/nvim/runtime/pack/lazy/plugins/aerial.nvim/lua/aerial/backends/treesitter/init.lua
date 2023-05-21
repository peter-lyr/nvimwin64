local backends = require("aerial.backends")
local config = require("aerial.config")
local util = require("aerial.backends.util")

---@type aerial.Backend
local M = {}

-- Custom capture groups:
-- type: Used to determine the SymbolKind (via language_kind_map)
-- name (optional): The text of this node will be used in the display
-- start (optional): The location of the start of this symbol (default @type)
-- end (optional): The location of the end of this symbol (default @start)

M.is_supported = function(bufnr)
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false, "nvim-treesitter not found"
  end
  local lang = parsers.get_buf_lang(bufnr)
  if not parsers.has_parser(lang) then
    return false, string.format("No treesitter parser for %s", lang)
  end
  local query = require("nvim-treesitter.query")
  if not query.has_query_files(lang, "aerial") then
    return false, string.format("No query file for '%s'", lang)
  end
  return true, nil
end

M.fetch_symbols_sync = function(bufnr)
  bufnr = bufnr or 0
  local extensions = require("aerial.backends.treesitter.extensions")
  local parsers = require("nvim-treesitter.parsers")
  local query = require("nvim-treesitter.query")
  local get_node_text
  if vim.treesitter and vim.treesitter.get_node_text then
    get_node_text = vim.treesitter.get_node_text
  else
    local ts_utils = require("nvim-treesitter.ts_utils")
    get_node_text = function(node, buf)
      return ts_utils.get_node_text(node, buf)[1]
    end
  end
  local include_kind = config.get_filter_kind_map(bufnr)
  local parser = parsers.get_parser(bufnr)
  local items = {}
  if not parser then
    backends.set_symbols(bufnr, items, { backend_name = "treesitter", lang = "unknown" })
    return
  end
  local lang = parser:lang()
  local syntax_tree = parser:parse()[1]
  if not query.has_query_files(lang, "aerial") or not syntax_tree then
    backends.set_symbols(
      bufnr,
      items,
      { backend_name = "treesitter", lang = lang, syntax_tree = syntax_tree }
    )
    return
  end
  -- This will track a loose hierarchy of recent node+items.
  -- It is used to determine node parents for the tree structure.
  local stack = {}
  local ext = extensions[lang]
  for match in query.iter_group_results(bufnr, "aerial", syntax_tree:root(), lang) do
    local name_node = (match.name or {}).node
    local type_node = (match.type or {}).node
    -- The location capture groups are optional. We default to the
    -- location of the @type capture
    local start_node = (match.start or {}).node or type_node
    local end_node = (match["end"] or {}).node or start_node
    local parent_item, parent_node, level = ext.get_parent(stack, match, type_node)
    -- Sometimes our queries will match the same node twice.
    -- Detect that (type_node == parent_node), and skip dupes.
    if not type_node or type_node == parent_node then
      goto continue
    end
    local kind = match.kind
    if not kind then
      vim.api.nvim_err_writeln(
        string.format("Missing 'kind' metadata in query file for language %s", lang)
      )
      break
    elseif not vim.lsp.protocol.SymbolKind[kind] then
      vim.api.nvim_err_writeln(
        string.format("Invalid 'kind' metadata '%s' in query file for language %s", kind, lang)
      )
      break
    end
    local row, col = start_node:start()
    local end_row, end_col = end_node:end_()
    local name
    if name_node then
      name = get_node_text(name_node, bufnr) or "<parse error>"
    else
      name = "<Anonymous>"
    end
    ---@type aerial.Symbol
    local item = {
      kind = kind,
      name = name,
      level = level,
      parent = parent_item,
      lnum = row + 1,
      end_lnum = end_row + 1,
      col = col,
      end_col = end_col,
    }
    if ext.postprocess(bufnr, item, match) == false or not include_kind[item.kind] then
      goto continue
    end
    local ctx = {
      backend_name = "treesitter",
      lang = lang,
      syntax_tree = syntax_tree,
      match = match,
    }
    if config.post_parse_symbol and config.post_parse_symbol(bufnr, item, ctx) == false then
      goto continue
    end
    if item.parent then
      if not item.parent.children then
        item.parent.children = {}
      end
      table.insert(item.parent.children, item)
    else
      table.insert(items, item)
    end
    table.insert(stack, { node = type_node, item = item })

    ::continue::
  end
  ext.postprocess_symbols(bufnr, items)
  backends.set_symbols(
    bufnr,
    items,
    { backend_name = "treesitter", lang = lang, syntax_tree = syntax_tree }
  )
end

M.fetch_symbols = M.fetch_symbols_sync

M.attach = function(bufnr)
  util.add_change_watcher(bufnr, "treesitter")
end

M.detach = function(bufnr)
  util.remove_change_watcher(bufnr, "treesitter")
end

return M
