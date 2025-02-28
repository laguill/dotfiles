-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.python-ruff" },

  { import = "astrocommunity.snippet.mini-snippets" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.toml" },

  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.nightfox-nvim" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.everforest" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.keybinding.hydra-nvim" },

  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.recipes.heirline-mode-text-statusline" },

  { import = "astrocommunity.workflow.bad-practices-nvim" },
  { import = "astrocommunity.workflow.precognition-nvim" },
}
