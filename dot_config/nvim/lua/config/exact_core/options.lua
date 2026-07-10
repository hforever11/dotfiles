local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.scrolloff = 8

opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true
opt.diffopt:append({ "algorithm:histogram", "linematch:60" })
opt.fillchars:append({ diff = " " })

opt.swapfile = false
opt.cmdheight = 0
opt.laststatus = 0

opt.autoread = true
opt.updatetime = 200

local checktime_group = vim.api.nvim_create_augroup("checktime_on_focus", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = checktime_group,
  callback = function()
    if vim.fn.mode() == "c" then
      return
    end

    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    if buftype ~= "" then
      return
    end

    vim.cmd("checktime")
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = checktime_group,
  callback = function()
    vim.notify("Reloaded from disk")
  end,
})
