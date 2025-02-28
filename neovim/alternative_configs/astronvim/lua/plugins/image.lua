return {
  "3rd/image.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "markdown", "markdown_inline" })
        end
      end,
    },
    -- cond = not MarkdownMode(),
    dependencies = "https://github.com/leafo/magick",
  },
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        -- only_render_image_at_cursor_mode = "popup",
        filetypes = { "markdown", "vimwiki", "quarto" }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "norg" },
      },
    },
    max_width = 100,
    max_height = 8,
    max_width_window_percentage = nil, -- math.huge,
    max_height_window_percentage = 30, -- math.huge,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "scrollview", "scrollview_sign" },
    kitty_method = "normal",
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
  },

  -- plot diagrams liker mermaid
  { "3rd/diagram.nvim", dependencies = { "image.nvim" }, enabled = false, opts = {} },

  -- Save plot with a command
  {
    "benlubas/image-save.nvim",
    -- enabled = false,
    -- dev = true,
    cmd = "SaveImage",
    opts = {
      enable_mouse = true,
    },
  },
}
