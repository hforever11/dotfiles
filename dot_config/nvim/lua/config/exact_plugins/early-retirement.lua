return {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
  opts = {
    retirementAgeMins = 20,
    ignoredFiletypes = {
      "gitcommit",
      "gitrebase",
      "help",
      "lazy",
      "mason",
      "neo-tree",
      "qf",
    },
    ignoreAltFile = true,
    minimumBufferNum = 4,
    ignoreUnsavedChangesBufs = true,
    ignoreSpecialBuftypes = true,
    ignoreVisibleBufs = true,
    notificationOnAutoClose = false,
    deleteBufferWhenFileDeleted = true,
    deleteFunction = function(bufnr)
      Snacks.bufdelete(bufnr)
    end,
  },
}
