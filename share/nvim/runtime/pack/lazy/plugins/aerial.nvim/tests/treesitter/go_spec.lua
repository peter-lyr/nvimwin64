local util = require("tests.test_util")

describe("treesitter go", function()
  it("parses all symbols correctly", function()
    util.test_file_symbols("treesitter", "./tests/treesitter/go_test.go", {
      {
        kind = "Function",
        name = "fn_1",
        level = 0,
        lnum = 3,
        col = 0,
        end_lnum = 3,
        end_col = 14,
      },
      {
        kind = "Struct",
        name = "st_1",
        level = 0,
        lnum = 5,
        col = 0,
        end_lnum = 5,
        end_col = 18,
      },
      {
        kind = "Method",
        name = "(st_1) Meth_1",
        level = 0,
        lnum = 7,
        col = 0,
        end_lnum = 7,
        end_col = 23,
      },
      {
        kind = "Interface",
        name = "MyInterface",
        level = 0,
        lnum = 9,
        col = 0,
        end_lnum = 9,
        end_col = 28,
      },
    })
  end)
end)
