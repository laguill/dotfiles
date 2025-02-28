return {
  "GCBallesteros/NotebookNavigator.nvim",
  dependencies = {
    "echasnovski/mini.comment",
    "Vigemus/iron.nvim", -- repl provider
    -- "akinsho/toggleterm.nvim", -- alternative repl provider
    -- "benlubas/molten-nvim", -- alternative repl provider
    "anuvyklack/hydra.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("notebook-navigator").setup {
      show_hydra_hint = false,
      activate_hydra_keys = "<leader>rh",
      hydra_keys = {
        comment = "c",
        run = "x",
        run_and_move = "X",
        move_up = "t",
        move_down = "n",
        add_cell_before = "T",
        add_cell_after = "N",
      },
      repl_provider = "iron",
      cell_markers = {
        -- python = "# %%",
        -- quarto = "```",
      },
    }
  end,
}
