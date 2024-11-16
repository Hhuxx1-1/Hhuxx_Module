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
function CUTSCENE:createDoll(playerid, skin_ID , x,y,z)
    if CUTSCENE.DOLLS[playerid] == nil then 
        CUTSCENE.DOLLS[playerid] = {};
    end     
    local cameraman = 34;
    local r,obj = World:spawnCreature(x,y,z,cameraman,1) 
    table.insert(CUTSCENE.DOLLS[playerid],obj[1]);
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

function CUTSCENE:rotCamera(x,y,t,playerid)
    Player:SetCameraRotTransformBy(playerid,{x=x,y=y}, 1,t);
end

function CUTSCENE:setrotCamera(x,y,t,playerid)
    Player:SetCameraRotTransformTo(playerid,{x=x,y=y}, 1,t);
end

function CUTSCENE:setText(playerid,text)
    if T_Text then 
        -- translation function available 
        text = T_Text(playerid,text);
    end 
    Customui:setText(playerid,CUTSCENE.UI,CUTSCENE.UI.."_3",text);
end

-- Runtime Execution (Called every 1/20s or 0.05s)
ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    if getTableLength(CUTSCENE.ACTIVE) > 0 then 
        for playerid, data in pairs(CUTSCENE.ACTIVE) do
            local success, err = pcall(function()
                -- Execute function for current tick, increment time if cutscene not ended
                local funx = data[NowTick(playerid)]
                if funx and funx(playerid) then
                    -- If function returns true, cutscene is complete
                    CUTSCENE:endCutscene(playerid)
                    if data["END"] then 
                        threadpool:delay(1,function()
                            data["END"](playerid)    
                        end);
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
