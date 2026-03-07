local M = {
  name = "catppuccin",
  variant = "frappe",
  transparent_background = false,
}

function M.palette()
  if M.name == "catppuccin" then
    return require("catppuccin.palettes").get_palette(M.variant)
  end

  error("No palette provider configured for theme: " .. M.name)
end

return M
