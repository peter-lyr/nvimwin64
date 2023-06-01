vim.cmd([[set runtimepath+=.]])
-- Force load the nvim-treesitter query predicates
require("nvim-treesitter.query_predicates")

vim.o.swapfile = false
vim.bo.swapfile = false
vim.filetype.add({
  extension = {
    norg = "norg", -- Neovim doesn't have built-in norg filetype detection
  },
})

local langs = {}
for lang, _ in vim.fs.dir("queries") do
  table.insert(langs, lang)
end
require("nvim-treesitter.configs").setup({
  ensure_installed = langs,
  sync_install = true,
})
