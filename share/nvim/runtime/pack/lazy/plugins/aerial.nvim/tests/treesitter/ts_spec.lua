local util = require("tests.test_util")

describe("treesitter ts", function()
  it("parses all symbols correctly", function()
    util.test_file_symbols("treesitter", "./tests/treesitter/ts_test.ts", {
      {
        kind = "Function",
        name = "fn_1",
        level = 0,
        lnum = 1,
        col = 0,
        end_lnum = 1,
        end_col = 18,
      },
      {
        kind = "Function",
        name = "fn_2",
        level = 0,
        lnum = 3,
        col = 0,
        end_lnum = 3,
        end_col = 22,
      },
      {
        kind = "Interface",
        name = "Iface_1",
        level = 0,
        lnum = 5,
        col = 0,
        end_lnum = 5,
        end_col = 20,
      },
      {
        kind = "Class",
        name = "Cl_1",
        level = 0,
        lnum = 7,
        col = 0,
        end_lnum = 10,
        end_col = 1,
        children = {
          {
            kind = "Method",
            name = "meth_1",
            level = 1,
            lnum = 8,
            col = 2,
            end_lnum = 8,
            end_col = 13,
          },
          {
            kind = "Method",
            name = "cl_fn_3",
            level = 1,
            lnum = 9,
            col = 2,
            end_lnum = 9,
            end_col = 20,
          },
        },
      },
      {
        kind = "Variable",
        name = "Type1",
        level = 0,
        lnum = 12,
        col = 0,
        end_lnum = 12,
        end_col = 16,
      },
      {
        kind = "Function",
        name = "fn_3",
        level = 0,
        lnum = 14,
        col = 0,
        end_lnum = 14,
        end_col = 22,
      },
      {
        kind = "Variable",
        name = "const_var",
        level = 0,
        lnum = 16,
        col = 0,
        end_lnum = 16,
        end_col = 26,
      },
      {
        kind = "Variable",
        name = "let_var",
        level = 0,
        lnum = 17,
        col = 0,
        end_lnum = 17,
        end_col = 22,
      },
      {
        kind = "Function",
        name = "describe UnitTest",
        level = 0,
        lnum = 19,
        col = 0,
        end_lnum = 31,
        end_col = 2,
        children = {
          {
            kind = "Function",
            name = "afterAll",
            level = 1,
            lnum = 20,
            col = 2,
            end_lnum = 20,
            end_col = 20,
          },
          {
            kind = "Function",
            name = "afterEach",
            level = 1,
            lnum = 21,
            col = 2,
            end_lnum = 21,
            end_col = 21,
          },
          {
            kind = "Function",
            name = "beforeAll",
            level = 1,
            lnum = 22,
            col = 2,
            end_lnum = 22,
            end_col = 21,
          },
          {
            kind = "Function",
            name = "beforeEach",
            level = 1,
            lnum = 23,
            col = 2,
            end_lnum = 23,
            end_col = 22,
          },
          {
            kind = "Function",
            name = "test should describe the test",
            level = 1,
            lnum = 24,
            col = 2,
            end_lnum = 24,
            end_col = 44,
          },
          {
            kind = "Function",
            name = "it is an alias for test",
            level = 1,
            lnum = 25,
            col = 2,
            end_lnum = 25,
            end_col = 38,
          },
          {
            kind = "Function",
            name = "test.skip skip this test",
            level = 1,
            lnum = 26,
            col = 2,
            end_lnum = 26,
            end_col = 39,
          },
          {
            kind = "Function",
            name = "test.todo this is a todo",
            level = 1,
            lnum = 27,
            col = 2,
            end_lnum = 27,
            end_col = 29,
          },
          {
            kind = "Function",
            name = "describe.each Test Suite",
            level = 1,
            lnum = 28,
            col = 2,
            end_lnum = 30,
            end_col = 4,
            children = {
              {
                kind = "Function",
                name = "test.each runs multiple times",
                level = 2,
                lnum = 29,
                col = 4,
                end_lnum = 29,
                end_col = 50,
              },
            },
          },
        },
      },
    })
  end)
end)
