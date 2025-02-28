return {
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "quarto", "markdown", "python" },
  config = function()
    local quarto = require "quarto"
    quarto.setup {
      lspFeatures = {
        -- NOTE: put whatever languages you want here:
        languages = { "python", "rust", "lua" },
        chunks = "all", -- 'curly' or 'all'
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
      },
      codeRunner = {
        enabled = true,
        ft_runners = {
          bash = "slime",
        },
        default_method = "iron",
      },
    }

    local runner = require "quarto.runner"
    vim.keymap.set("n", "<leader>rqc", runner.run_cell, { desc = "Quarto: run cell", silent = true })
    vim.keymap.set("n", "<leader>rqb", function()
      runner.run_cell()
      vim.cmd "normal ]b"
    end, { desc = "Quarto: run cell and goto next", silent = true })
    vim.keymap.set("n", "<leader>rqu", runner.run_above, { desc = "Quarto: run cell and above", silent = true })
    vim.keymap.set("n", "<leader>rqa", runner.run_all, { desc = "Quarto: run all cells", silent = true })
    vim.keymap.set("n", "<leader>rql", runner.run_line, { desc = "Quarto: run line", silent = true })
    vim.keymap.set("v", "<leader>rq", runner.run_range, { desc = "Quarto: run visual range", silent = true })
    vim.keymap.set(
      "n",
      "<leader>rQA",
      function() runner.run_all(true) end,
      { desc = "Quarto: run all cells of all languages", silent = true }
    )

    -- special key maps
    local is_code_chunk = function()
      local current, _ = require("otter.keeper").get_current_language_context()
      if current then
        return true
      else
        return false
      end
    end
    --- Insert code chunk of given language
    --- Splits current chunk if already within a chunk
    --- @param lang string
    local insert_code_chunk = function(lang)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
      local keys
      if is_code_chunk() then
        keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
      else
        keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
      end
      keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end

    local insert_r_chunk = function() insert_code_chunk "r" end

    local insert_py_chunk = function() insert_code_chunk "python" end

    --show kepbindings with whichkey
    --add your own here if you want them to
    --show up in the popup as well
    local wk = require "which-key"
    -- normal mode
    wk.add({
      { "<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
      { "<c-q>", "<cmd>q<cr>", desc = "close buffer" },
      { "<cm-i>", insert_py_chunk, desc = "python code chunk" },
      { "<esc>", "<cmd>noh<cr>", desc = "remove search highlight" },
      { "<m-I>", insert_py_chunk, desc = "python code chunk" },
      { "<m-i>", insert_r_chunk, desc = "r code chunk" },
      { "[q", ":silent cprev<cr>", desc = "[q]uickfix prev" },
      { "]q", ":silent cnext<cr>", desc = "[q]uickfix next" },
      { "gN", "Nzzzv", desc = "center search" },
      { "gf", ":e <cfile><CR>", desc = "edit file" },
      { "gl", "<c-]>", desc = "open help link" },
      { "n", "nzzzv", desc = "center search" },
      { "z?", ":setlocal spell!<cr>", desc = "toggle [z]pellcheck" },
      { "zl", ":Telescope spell_suggest<cr>", desc = "[l]ist spelling suggestions" },
    }, { mode = "n", silent = true })

    -- visual mode
    wk.add {
      {
        mode = { "v" },
        { ".", ":norm .<cr>", desc = "repat last normal mode command" },
        { "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z", desc = "move line down" },
        { "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z", desc = "move line up" },
        { "q", ":norm @q<cr>", desc = "repat q macro" },
      },
    }

    -- visual with <leader>
    wk.add({
      { "<leader>d", '"_d', desc = "delete without overwriting reg", mode = "v" },
      { "<leader>p", '"_dP', desc = "replace without overwriting reg", mode = "v" },
    }, { mode = "v" })

    -- insert mode
    wk.add({
      {
        mode = { "i" },
        { "<c-x><c-x>", "<c-x><c-o>", desc = "omnifunc completion" },
        { "<cm-i>", insert_py_chunk, desc = "python code chunk" },
        { "<m-->", " <- ", desc = "assign" },
        { "<m-I>", insert_py_chunk, desc = "python code chunk" },
        { "<m-i>", insert_r_chunk, desc = "r code chunk" },
        { "<m-m>", " |>", desc = "pipe" },
      },
    }, { mode = "i" })
  end,
}
