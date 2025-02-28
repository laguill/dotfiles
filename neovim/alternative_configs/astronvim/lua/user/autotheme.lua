local function set_colorscheme()
  local now = tonumber(os.date "%H") * 60 + tonumber(os.date "%M") -- Convertir l'heure actuelle en minutes
  local day_start = 7 * 60 + 30 -- 7:30 → 450 minutes
  local night_start = 18 * 60 -- 18:00 → 1080 minutes

  -- Vérifier si on est dans la plage jour (7h30 - 18h)
  if now >= day_start and now < night_start then
    vim.cmd "colorscheme downfox" -- Appliquer downfox
  else
    vim.cmd "colorscheme catppuccin-frappe" -- Appliquer catppuccin-frappe
  end
end

-- Appliquer au démarrage
set_colorscheme()

-- Vérifier l'heure toutes les 5 minutes pour ajuster le thème
vim.defer_fn(function()
  set_colorscheme()
  vim.cmd "echo 'Thème mis à jour selon l’heure'"
end, 300000) -- 300000 ms = 5 minutes
