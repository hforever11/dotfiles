return {
  "b0o/incline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    local palette = require("catppuccin.palettes").get_palette("frappe")
    local devicons = require("nvim-web-devicons")

    local fg_active = palette.mauve
    local fg_inactive = palette.overlay0
    local diag_icons = { error = "󰅚 ", warn = "󰀪 ", hint = "󰌶 ", info = " " }

    -- index.tsx, init.lua など一般的すぎるファイル名
    local generic_names = {
      index = true, init = true, main = true,
      mod = true, lib = true, utils = true,
    }

    local function get_diagnostic_label(props)
      local label = {}
      for severity, icon in pairs(diag_icons) do
        local n = #vim.diagnostic.get(props.buf, {
          severity = vim.diagnostic.severity[string.upper(severity)],
        })
        if n > 0 then
          table.insert(label, {
            icon .. n .. " ",
            group = props.focused and ("DiagnosticSign" .. severity) or "NonText",
          })
        end
      end
      if #label > 0 then
        table.insert(label, { "┊ ", guifg = fg_inactive })
      end
      return label
    end

    local function get_display_name(buf)
      local fullpath = vim.api.nvim_buf_get_name(buf)
      local fname = vim.fn.fnamemodify(fullpath, ":t")
      local stem = vim.fn.fnamemodify(fname, ":r")
      local dirname = generic_names[stem]
        and vim.fn.fnamemodify(fullpath, ":h:t")
        or nil
      return fname, dirname
    end

    local function render(props)
      local fname, dirname = get_display_name(props.buf)
      if fname == "" then return "" end

      local ft_icon, ft_color = devicons.get_icon_color(fname)
      local has_error = #vim.diagnostic.get(props.buf, {
        severity = vim.diagnostic.severity.ERROR,
      }) > 0
      local is_readonly = vim.bo[props.buf].readonly

      local fg_name_active = has_error and palette.red
        or (is_readonly and palette.overlay0 or fg_active)
      local fg_name = props.focused and fg_name_active or fg_inactive

      return {
        { get_diagnostic_label(props) },
        { ft_icon and (ft_icon .. " ") or "", guifg = props.focused and ft_color or fg_inactive },
        { is_readonly and " " or "", guifg = fg_name },
        { dirname and (dirname .. "/") or "", guifg = fg_inactive },
        { fname, guifg = fg_name, gui = props.focused and "bold" or "" },
        { vim.bo[props.buf].modified and " ●" or "", guifg = props.focused and palette.peach or fg_inactive },
      }
    end

    return {
      highlight = {
        groups = {
          InclineNormal = { guibg = palette.mantle, guifg = fg_active },
          InclineNormalNC = { guibg = "none", guifg = fg_inactive },
        },
      },
      window = {
        options = { winblend = 0 },
        placement = { horizontal = "right", vertical = "bottom" },
        margin = { horizontal = 0, vertical = 0 },
        padding = 2,
      },
      render = render,
    }
  end,
}
