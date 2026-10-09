require "ISUI/ISPanel"

ProjectEvil = ProjectEvil or {}
ProjectEvil.HUD = ProjectEvil.HUD or {}

local PEHUD = ISPanel:derive("PEHUD")
PEHUD.instance = nil

function PEHUD:new()
    local o = ISPanel:new(20, 45, 420, 112)
    setmetatable(o, self)
    self.__index = self
    o.background = true
    o.backgroundColor = { r = 0.035, g = 0.045, b = 0.05, a = 0.86 }
    o.borderColor = { r = 0.65, g = 0.12, b = 0.09, a = 0.95 }
    o.moveWithMouse = false
    return o
end

function PEHUD:initialise()
    ISPanel.initialise(self)
end

function PEHUD:render()
    ISPanel.render(self)
    local player = getSpecificPlayer(0)
    if not player or not ProjectEvil.Campaign then return end
    local d = ProjectEvil.Campaign.getState(player)
    if not d then return end

    self:drawText("PROJECT EVIL  /  THE VILLAGE", 12, 8, 0.92, 0.20, 0.16, 1, UIFont.Medium)
    self:drawText("LEON KENNEDY  •  SURVIVAL CAMPAIGN", 12, 30, 0.82, 0.82, 0.78, 1, UIFont.Small)
    self:drawText("OBJECTIVE: " .. ProjectEvil.Campaign.getObjective(player), 12, 52, 1, 1, 1, 1, UIFont.Small)
    self:drawText("THREATS CLEARED: " .. tostring(d.nearbyKills) .. " / 5", 12, 76, 0.92, 0.72, 0.63, 1, UIFont.Small)
end

local function createHUD()
    if PEHUD.instance then return end
    local panel = PEHUD:new()
    panel:initialise()
    panel:addToUIManager()
    PEHUD.instance = panel
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    if playerIndex == 0 then createHUD() end
end)

Events.OnGameStart.Add(function()
    createHUD()
end)

ProjectEvil.HUD.Panel = PEHUD
