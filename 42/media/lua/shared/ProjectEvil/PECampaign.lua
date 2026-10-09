ProjectEvil = ProjectEvil or {}
ProjectEvil.Campaign = ProjectEvil.Campaign or {}

local Campaign = ProjectEvil.Campaign
Campaign.VERSION = 2
Campaign.MISSION_ID = "village_opening"

local function playerData(player)
    if not player then return nil end
    local md = player:getModData()
    md.PECampaign = md.PECampaign or {
        version = Campaign.VERSION,
        missionId = Campaign.MISSION_ID,
        stage = 1,
        openingStartWorldAgeHours = nil,
        nearbyKills = 0,
        foundSupplies = false,
        completed = false
    }
    local d = md.PECampaign
    d.version = Campaign.VERSION
    d.missionId = d.missionId or Campaign.MISSION_ID
    d.stage = d.stage or 1
    d.nearbyKills = d.nearbyKills or 0
    d.foundSupplies = d.foundSupplies or false
    d.completed = d.completed or false

    -- Persist an in-game-time anchor so progression is not tied to frame rate.
    if d.openingStartWorldAgeHours == nil then
        local gameTime = getGameTime()
        if gameTime then
            d.openingStartWorldAgeHours = gameTime:getWorldAgeHours()
        end
    end
    return d
end

function Campaign.getState(player)
    return playerData(player)
end

function Campaign.getObjective(player)
    local d = playerData(player)
    if not d then return "Waiting for Leon..." end
    if d.completed then return "Village secured. Next objective unlocked." end
    if d.stage == 1 then return "Investigate the village and survive the first attack." end
    if d.stage == 2 then return "Scavenge food plus medical supplies or ammunition." end
    if d.stage == 3 then return "Hold your ground: clear 5 nearby threats." end
    return "Reach the next objective."
end

local function hasAny(player, types)
    local inv = player:getInventory()
    for i = 1, #types do
        if inv:contains(types[i]) then return true end
    end
    return false
end

local function hasScavengedSupplies(player)
    local food = hasAny(player, {
        "Base.CannedCorn", "Base.CannedBeans", "Base.CannedSoup",
        "Base.TinnedSoup", "Base.Crisps", "Base.Pop"
    })
    local medical = hasAny(player, {
        "Base.Bandage", "Base.BandageDirty", "Base.Pills",
        "Base.Disinfectant", "Base.AlcoholWipes"
    })
    local ammunition = hasAny(player, {
        "Base.Bullets9mm", "Base.Bullets45", "Base.Bullets38",
        "Base.Bullets44", "Base.BulletsShotgun"
    })
    return food and (medical or ammunition)
end

function Campaign.onPlayerUpdate(player)
    if not player or player:isDead() then return end
    local d = playerData(player)
    if not d or d.completed then return end

    -- The opening beat lasts five in-game hours, independent of FPS.
    if d.stage == 1 and d.openingStartWorldAgeHours ~= nil then
        local gameTime = getGameTime()
        if gameTime and (gameTime:getWorldAgeHours() - d.openingStartWorldAgeHours) >= 5 then
            d.stage = 2
        end
    end

    if d.stage == 2 and hasScavengedSupplies(player) then
        d.foundSupplies = true
        d.stage = 3
    end

    if d.stage == 3 and d.nearbyKills >= 5 then
        d.stage = 4
        d.completed = true
    end
end

function Campaign.onZombieDead(zombie)
    if not zombie or not zombie:getSquare() then return end
    local zx, zy, zz = zombie:getX(), zombie:getY(), zombie:getZ()
    for i = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if player and not player:isDead() then
            local dx, dy = player:getX() - zx, player:getY() - zy
            if player:getZ() == zz and (dx * dx + dy * dy) <= (18 * 18) then
                local d = playerData(player)
                if d and not d.completed and d.stage >= 3 then
                    d.nearbyKills = d.nearbyKills + 1
                end
            end
        end
    end
end

Events.OnPlayerUpdate.Add(Campaign.onPlayerUpdate)
Events.OnZombieDead.Add(Campaign.onZombieDead)
