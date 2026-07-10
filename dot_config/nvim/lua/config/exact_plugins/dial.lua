return {
  "monaqa/dial.nvim",
  -- stylua: ignore
  keys = {
    { "<C-a>",     function() return require("dial.map").inc_normal() end,  expr = true, mode = "n", desc = "Increment" },
    { "<C-x>",     function() return require("dial.map").dec_normal() end,  expr = true, mode = "n", desc = "Decrement" },
    { "<leader>+", function() return require("dial.map").inc_normal() end,  expr = true, mode = "n", desc = "Increment" },
    { "<leader>-", function() return require("dial.map").dec_normal() end,  expr = true, mode = "n", desc = "Decrement" },
    { "<C-a>",     function() return require("dial.map").inc_visual() end,  expr = true, mode = "x", desc = "Increment" },
    { "<C-x>",     function() return require("dial.map").dec_visual() end,  expr = true, mode = "x", desc = "Decrement" },
    { "g<C-a>",    function() return require("dial.map").inc_gvisual() end, expr = true, mode = "x", desc = "Increment sequence" },
    { "g<C-x>",    function() return require("dial.map").dec_gvisual() end, expr = true, mode = "x", desc = "Decrement sequence" },
  },
  config = function()
    local augend = require("dial.augend")

    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal, -- 10進（負号は別単語として扱う）
        augend.integer.alias.hex,     -- 0xff
        augend.semver.alias.semver,   -- v1.2.3
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%H:%M"],
        augend.constant.alias.bool,   -- true <-> false
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
        augend.constant.new({ elements = { "and", "or" } }),
        augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),
      },
    })
  end,
}
