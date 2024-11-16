-- version: 2022-04-20
-- mini: 1029380338
-- uipacket: 7378436039517083890
-- Constants and Settings
local hpbar = {}
local le = {}
local color = {}
local Symbol = "▀"
local thresholds = {100, 300, 800, 1200, 2800, 5600, 14600, 39000, 90000}
local le_divisors = {20, 50  , 100 , 150  , 300 , 500 , 1000  , 2500 ,6000 }
local colors = {"#c8DFF7E", "#c8DFF7E", "#c008324", "#cA79800", "#cF4FF3E", "#c9B000A", "#cFF0900", "#c0004FF", "#c000000"}

local BossHP = {
    UI = "7378436039517083890",
    MainBar = "7378436039517083890_6",
    MainTextBar = "7378436039517083890_4",
    MainName = "7378436039517083890_3",
    MainNameHolder = "7378436039517083890_1",
    DelayedMainBar = "7378436039517083890_7"
}

-- Functions
local function getHPBarLengthAndColor(v2)
    local length, hp_color = 5, "#c00FFFC"
    for i, threshold in ipairs(thresholds) do
        if v2 >= threshold then
            length = math.floor(v2 / le_divisors[i])
            hp_color = colors[i]
        end
    end
    return length, hp_color
end

local function createHPBar(v1, v2, length, hp_color)
    local filled_length = math.floor(v1 / v2 * length)
    local empty_length = length - filled_length
    local hp_bar = ""

    -- Filled part
    for _ = 1, filled_length do
        hp_bar = hp_bar .. Symbol
    end

    -- Empty part with a gray color
    for _ = 1, empty_length do
        hp_bar = hp_bar .. "#c555555" .. Symbol
    end

    return hp_bar, filled_length >= 0
end

local lastUpdateTime = {}

local function updateNickname(obj_id, name, hp_bar, color, current_hp)
    -- Update nickname display
    Actor:setnickname(obj_id, "#W▶" .. name .. " #R♥" .. current_hp .. "#W\n╚" .. "#b" ..  hp_bar .. "\n\n", true)
    threadpool:wait(0.3)
    Actor:setnickname(obj_id, "#W▶" .. name .. " #R♥" .. current_hp .. "#W\n╚" .. color .. " " .. hp_bar .. "\n\n")
    -- Update last hit timestamp
    lastUpdateTime[obj_id] = os.time()

    -- Delay clearing nickname only if not hit again
    threadpool:delay(3, function()
        if os.time() - lastUpdateTime[obj_id] >= 3 then
            Actor:setnickname(obj_id, "") -- Clear nickname after 3 seconds of no updates
        end
    end)
end

local function getPlayerNearby(objid)
    local r,x,y,z = Actor:getPosition(objid)
    if r == 0 then 
        -- create Area with dimension 64,10+y,64 and center is Objid position 
        local r,areaid = Area:createAreaRect({x=x,y=y+10,z=z},{x=64,y=20,z=64});
        local r,players = Area:getAreaPlayers(areaid);
        -- destroy unused Area 
        if Area:destroyArea(areaid) == 0 then 
            -- return the playerlist after area is destroyed 
            return players
        end 
    end 
end

local function updateBossHPBar(objid, name, currentHP, maxHP)
    local players = getPlayerNearby(objid)
    local percentage = currentHP / maxHP

    local h, w = 35, 600
    for _, playerid in ipairs(players) do
        -- Update the main (real-time) HP bar
        Player:openUIView(playerid, BossHP.UI)
        Customui:SmoothScaleTo(playerid, BossHP.UI, BossHP.MainBar, 0.5, w * percentage, h)
        Customui:setText(playerid, BossHP.UI, BossHP.MainTextBar, math.floor(currentHP))
        Customui:setText(playerid, BossHP.UI, BossHP.MainName, name)
    end
    lastUpdateTime[objid] = os.time()
    -- Delay clearing nickname only if not hit again
    threadpool:delay(1, function()
        if os.time() - lastUpdateTime[objid] >= 1 then
            for _, playerid in ipairs(players) do
                Customui:SmoothScaleTo(playerid, BossHP.UI, BossHP.DelayedMainBar, 0.5, w * percentage, h)
            end
        
        end
    end)
end




local function handleAttackEvent(e, obj_id)
    local r,team = Creature:getTeam(obj_id)
    
    local r1, v1 = Creature:getAttr(obj_id, 2)
    local r2, v2 = Creature:getAttr(obj_id, 1)
    local rr , actorid = Creature:getActorID(obj_id)
    if team == 0  or team == 2 then 
        if v1 > 1 then 
            local r3, name = Creature:getActorName(obj_id)
            local r4, real_name = Creature:GetMonsterDefName(actorid)
            --print("handling Attack event name : ",name," real Name = ",real_name)
            if name == nil then 
                name = real_name;
            end 
            -- Calculate HP bar length and color
            le[obj_id], color[obj_id] = getHPBarLengthAndColor(v2)
            
            -- Create HP bar
            local hp_bar, has_hp = createHPBar(v1, v2, le[obj_id], color[obj_id])
            local current_hp = math.floor(v1)
        
            -- Update nickname with HP bar
            if has_hp then
                Actor:shownickname(obj_id, true)
                updateNickname(obj_id, name, hp_bar, color[obj_id], current_hp)
            else 
                Actor:setnickname(obj_id, "")
            end
        end 
    end 

    if team == 3 then 
        -- Big Boss
        local r4, real_name = Creature:GetMonsterDefName(actorid)
        -- get All Player in Area radius of 64 Block and Open UI 
        updateBossHPBar(obj_id,real_name,v1,v2);
    end 
end

ScriptSupportEvent:registerEvent("Actor.ChangeAttr", function(e)
    local atr_type = e.actorattr;
    -- Chat:sendSystemMsg("Atr Change : "..atr_type);
    if atr_type ~= 6 then 
        handleAttackEvent(e,e.eventobjid);
    end 
end)
ScriptSupportEvent:registerEvent("Player.AttackHit", function(e)
    handleAttackEvent(e,e.toobjid);
end)
