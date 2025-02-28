return {
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- quick save
          ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
          -- vertical ipython terminal
          -- ["<Leader>ti"] = { ":vsplit term://ipython<cr>", desc = "ToggleTerm vertical ipython" },
          -- ["<Leader>tp"] = { ":vsplit term://python<cr>", desc = "ToggleTerm vertical python" },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
}
