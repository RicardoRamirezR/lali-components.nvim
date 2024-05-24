---@class Lali
local Lali = {}

function Lali.setup()
  if not vim.bo.filetype:find("blade", 1, true) then
    return
  end

  require("lali-components.gf").setup()
  require("lali-components.cmp").setup()
end

return Lali
