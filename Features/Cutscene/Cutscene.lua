-- Cutscene Module
CUTSCENE = {}           -- Stores global cutscene functions and data
CUTSCENE.DATA = {}      -- Contains predefined cutscene sequences
CUTSCENE.ACTIVE = {}    -- Tracks active cutscenes by player ID
CUTSCENE.TIME = {}      -- Stores time counters for each player’s cutscene
CUTSCENE.PLAYER_CAMERA = {}; --Store Player Cameras here 
CUTSCENE.DOLLS = {}; -- Store Dolls Created here for remove references 
CUTSCENE.UI = "7415474213980150002";
-- Helper: Get dynamic table length
local function getTableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- Helper: Update time tick for player-specific cutscene
local function NowTick(playerid)
    CUTSCENE.TIME[playerid] = (CUTSCENE.TIME[playerid] or 0) + 1
    return CUTSCENE.TIME[playerid]
end

-- Start a cutscene for a player
function CUTSCENE:start(playerid, cutsceneID)
    -- Initialize cutscene data for player
    CUTSCENE.TIME[playerid] = 0
    if CUTSCENE.DATA[cutsceneID] then 
        CUTSCENE.ACTIVE[playerid] = CUTSCENE.DATA[cutsceneID]  -- Reference to predefined sequence

        -- Set up camera and Dolls
        CUTSCENE:createCameraMan(playerid)
        Player:openUIView(playerid,CUTSCENE.UI);
    else 
        Player:notifyGameInfo2Self(playerid,"CUTSCENE"..cutsceneID.." Not Found")
    end 
    -- Additional setup if needed
end

-- End a cutscene for a player, cleaning up Dolls and Camera Man
function CUTSCENE:endCutscene(playerid)
    CUTSCENE.ACTIVE[playerid] = nil
    CUTSCENE.TIME[playerid] = nil
    Player:hideUIView(playerid,CUTSCENE.UI);
    CUTSCENE:removeCameraMan(playerid);
    CUTSCENE:removeDolls(playerid);
end

local function lockCameraAngle(playerid)
    if Player:SetCameraRotMode(playerid, 4) ~= 0 then
        Chat:sendSystemMsg("Failed to set Camera Rot Mode")
    end
end

local function unlockCameraAngle(playerid)
    if Player:SetCameraRotMode(playerid, 1) ~= 0 then
        Chat:sendSystemMsg("Failed to set Camera Rot Mode")
    end
end

-- Create and control the Camera Man actor for the cutscene
function CUTSCENE:createCameraMan(playerid)
    -- Logic to create or position the Camera Man
    local r,x,y,z = Actor:getPosition(playerid);
    local cameraman = 34;
    local r,obj = World:spawnCreature(x,y,z,cameraman,1) 
    CUTSCENE.PLAYER_CAMERA[playerid] = obj[1];
    if Player:SetCameraMountObj(playerid,obj[1]) == 0 then 
        return CUTSCENE.PLAYER_CAMERA[playerid];
    else
        print("Fail to Mount Camera"); 
    end 
end

function CUTSCENE:removeCameraMan(playerid)
    if World:despawnActor(CUTSCENE.PLAYER_CAMERA[playerid]) == 0 then 
        CUTSCENE.PLAYER_CAMERA[playerid] = nil;
        Player:ResetCameraAttr(playerid)
    end 
end

-- Create Dolls based on cutscene needs
function CUTSCENE:createDoll(playerid, skin_ID , x,y,z , size)
    if CUTSCENE.DOLLS[playerid] == nil then 
        CUTSCENE.DOLLS[playerid] = {};
    end     
    local cameraman = 34;
    local r,obj = World:spawnCreature(x,y,z,cameraman,1) 
    Creature:setAttr(obj[1],21,size or 1);--[[Set the Size into Normal Size]]
    Actor:changeCustomModel(obj[1],skin_ID);--[[Set Skin ID]]
    table.insert(CUTSCENE.DOLLS[playerid],obj[1]);
    return obj[1];
end

function CUTSCENE:removeDolls(playerid)
    if CUTSCENE.DOLLS[playerid] then 
        for i,id in ipairs(CUTSCENE.DOLLS[playerid]) do 
            World:despawnActor(id);
        end
    end 
    CUTSCENE.DOLLS[playerid] = nil;
end

-- Skip cutscene for a player without affecting gameplay
function CUTSCENE:skip(playerid)
    CUTSCENE:endCutscene(playerid)
    -- Optionally, provide feedback to the player
end

function CUTSCENE:CREATE(id,data)
    -- a bunch of number index 
    CUTSCENE.DATA[id] = data;  
end

function CUTSCENE:moveCamera(x,y,z,playerid)
    local cam = CUTSCENE.PLAYER_CAMERA[playerid];
    for i=6,5,-1 do 
        Actor:appendSpeed(cam,x/i,y/i,z/i);
        threadpool:wait(0.1);
    end 
end

function CUTSCENE:setCamera(x,y,z,playerid)
    local cam = CUTSCENE.PLAYER_CAMERA[playerid];
    Actor:setPosition(cam,x,y,z)
end

function CUTSCENE:rotCamera(x,y,t,playerid)
    Player:SetCameraRotTransformBy(playerid,{x=x,y=y}, 1,t);
end

function CUTSCENE:setrotCamera(x,y,t,playerid)
    Player:SetCameraRotTransformTo(playerid,{x=x,y=y}, 1,t);
end

function CUTSCENE:TRANSITION(playerid,dur)
    for alpha=1,25 do 
        RUNNER.NEW(function()
            Customui:setAlpha(playerid,CUTSCENE.UI  , CUTSCENE.UI.."_4", alpha*4 )     
        end,{},alpha)
    end 
    RUNNER.NEW(function()
        for alpha=25,0,-1 do 
            RUNNER.NEW(function()
                Customui:setAlpha(playerid,CUTSCENE.UI  , CUTSCENE.UI.."_4", alpha*4 )    
            end,{},25-alpha)
        end 
    end,{},25+dur*20)
end

local ChatPopup = {
    10950,10950,10950,
    R = function(self)
        -- return random index from self 
        return self[math.random(1,3)]
    end
}


function EXPLODE_STRING(text)
    local words = {}

    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end
    return words;
end


function CUTSCENE:setText(playerid, text)
    if T_Text then
        -- Translate text if available
        text = T_Text(playerid, text)
    end
    if text ~= " " then

        local words = EXPLODE_STRING(text) -- Split the text into words
        local cumulativeText = "" -- To store the incrementally built string

        -- Iterate through each word with an increasing delay
        for i, word in ipairs(words) do
            RUNNER.NEW(function()
                cumulativeText = cumulativeText .. (i > 1 and " " or "") .. word -- Append the word with a space if not the first
                if Customui:setText(playerid, CUTSCENE.UI, CUTSCENE.UI .. "_3", cumulativeText) == 0 then
                    Player:playMusic(
                        playerid,
                        ChatPopup:R(),
                        100,
                        1 + (math.random(9, 12) / 10),
                        false
                    )
                end
            end, {}, i * 3)
        end

    else 
        Customui:setText(playerid, CUTSCENE.UI, CUTSCENE.UI .. "_3", "")
    end 
end

function CUTSCENE:showChat(actorid,txt,i,dur,offset)
    local graphinfo = Graphics:makeGraphicsText(txt,17,100,i);
    local r,grphid = Graphics:createGraphicsTxtByActor(actorid, graphinfo, {x=0,y=1,z=0},offset or 120, 0,0);
    RUNNER.NEW(function()
        Graphics:removeGraphicsByObjID(actorid, i, 1);
    end,{},dur*20);
end 

-- Function to calculate and jump to the next tick
function CUTSCENE:JumpToNext(cutscene, currentTick, player)
    -- Step 1: Get all available tick keys
    local availableTicks = {}
    for tick, action in pairs(cutscene) do
        if type(tick) == "number" then -- Only include numeric keys
            table.insert(availableTicks, tick)
        end
    end

    -- Step 2: Sort ticks in ascending order
    table.sort(availableTicks)

    -- Step 3: Find the next tick
    for _, tick in ipairs(availableTicks) do
        if tick > currentTick then
            -- Step 4: Execute the corresponding function for the next tick
            if cutscene[tick] then
                cutscene[tick](player)
                return tick,false; -- Return the new current tick
            end
        end
    end

    -- If no next tick is found, return the current tick (end of cutscene)
    return currentTick,true;
end

function CUTSCENE:DialogSay(index,name,p,text,dur,yaw,pitch,h)
    local DOLL = CUTSCENE.DOLLS[p][index];
    Actor:setFaceYaw(DOLL,yaw)
    Actor:setFacePitch(DOLL,pitch)
    CUTSCENE:showChat(DOLL,text,1,dur,h or 230);
    CUTSCENE:setText(p,name.." : "..text);
end

-- Runtime Execution (Called every 1/20s or 0.05s)
ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    if getTableLength(CUTSCENE.ACTIVE) > 0 then 
        for playerid, data in pairs(CUTSCENE.ACTIVE) do
            local success, err = pcall(function()
                -- Execute function for current tick, increment time if cutscene not ended
                local funx = data[NowTick(playerid)]
                if  funx and funx(playerid)  then
                    -- If function returns true, cutscene is complete
                    CUTSCENE:endCutscene(playerid)
                    if data["END"] then 
                        data["END"](playerid)    
                    end 
                end
            end)
            if not success then
                print("Error in cutscene for player " .. playerid .. ": " .. tostring(err))
                CUTSCENE:endCutscene(playerid)
            end
        end
    end 
end)

ScriptSupportEvent:registerEvent("UI.Hide",function(e)
    local playerid,uiid =  e.eventobjid,e.CustomUI
    local data = CUTSCENE.ACTIVE[playerid];
    if data then 
        if uiid == CUTSCENE.UI then
            if data["END"] then 
                CUTSCENE.ACTIVE[playerid] = nil;
                CUTSCENE.TIME[playerid] = nil
                CUTSCENE:removeCameraMan(playerid);
                CUTSCENE:removeDolls(playerid);
                data["END"](playerid)    
            end 
        end 
    else 
        return;
    end 
end)

ScriptSupportEvent:registerEvent("UI.Button.Click", function(e)
    local playerid, uiid = e.eventobjid, e.CustomUI
    local btn = e.uielement

    if btn == "7415474213980150002_8" then -- Next Button
        local activeCutscene = CUTSCENE.ACTIVE[playerid]
        local currentTime = CUTSCENE.TIME[playerid]

        -- Ensure active cutscene and current time are valid
        if activeCutscene and currentTime then
            local nextTick,isEnd = CUTSCENE:JumpToNext(activeCutscene, currentTime, playerid)
            if nextTick then
                CUTSCENE.TIME[playerid] = nextTick
            else
                print("No next key available for player:", playerid)
            end
            if isEnd then 
                CUTSCENE:endCutscene(playerid)
                if activeCutscene["END"] then 
                    activeCutscene["END"](playerid)    
                end 
            end 
        else
            print("Invalid cutscene state for player:", playerid)
        end
    end
end)
