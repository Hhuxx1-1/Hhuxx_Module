local IS_MODE_DEBUG = true ;
-- modify if necessary 
local police  = 2;
local KeyCard = 4109;--[[id of item key card]]
local test = function(...)
    if IS_MODE_DEBUG then 
        print(...)
    end 
end

GLOBAL_LEVER = { DATA = {} }
GLOBAL_LEVER.TYPE = {
    Lever = 358 ,
    Sand_Plate = 362 ,
    Stone_Plate = 360 ,
    Wooden_Plate = 359 , 
    Stone_Button = 364 , 
    Wooden_Button = 363 , 
}
-- function to Encode coordinate into storeable coordinate into single string key 
GLOBAL_LEVER.ENCODE = function(x,y,z,b)
    -- convert x,y,z that could have negatif number into readable single string without losing the information 
    local x = "X"..string.gsub(tostring(x),"-","N")
    local y = "Y"..string.gsub(tostring(y),"-","N")
    local z = "Z"..string.gsub(tostring(z),"-","N")
    -- convert those redeclared x,y,z as string into single string 
    return x.." "..y.." "..z.." B"..b;
end

-- function to Decode the stored coordinate string into  usable coordinate resulting on table contain x,y,z 
GLOBAL_LEVER.DECODE = function(encoded_str)
    -- Split the string into x, y, z, and b components
    local x_str, y_str, z_str, b_str = string.match(encoded_str, "(X[^ ]*) (Y[^ ]*) (Z[^ ]*) B([^ ]*)")
    
    -- Remove the prefixes 'X', 'Y', 'Z' and revert 'N' back to '-' for negative numbers
    local x = tonumber(string.gsub(string.sub(x_str, 2), "N", "-"))
    local y = tonumber(string.gsub(string.sub(y_str, 2), "N", "-"))
    local z = tonumber(string.gsub(string.sub(z_str, 2), "N", "-"))
    
    -- Convert 'b' to its appropriate type (number, boolean, etc.)
    local b = tonumber(b_str) or b_str -- assuming 'b' could be a string or number
    
    -- Return the decoded values as a table
    return {x = x, y = y, z = z, b = b}
end
    
-- function to initiate  the global lever object 
GLOBAL_LEVER.REGISTER = function(x,y,z,b,f,arg) 
    local id = GLOBAL_LEVER.ENCODE(x,y,z,b);
    GLOBAL_LEVER.DATA[tostring(id)] = { f = f , arg = arg}
end 

GLOBAL_LEVER.UNRAVEL = function(e)
    return e.x,e.y,e.z,e.blockid,e.eventobjid,e.msgStr;
end

GLOBAL_LEVER.OPEN_DOOR = function(x, y, z, id)

    local circuit = {
        blue_cable = 706,
        red_cable = 1009,
        power = 415,
        powerOff = 408,
    }
    local result, blockID = Block:getBlockID(x, y, z)
    -- Assuming result 0 means success (the block exists and we can modify it)
    local dup,dbt = 0,0;
    local dy = 0;
    if result == 0 and blockID == id then
        -- Check the block below (y - 1) to see if it's the same door block
        local result_below, blockID_below = Block:getBlockID(x, y - 1, z)
        
        if result_below == 0 and blockID_below == id then
            -- The current block is the top part, so set the bottom part (y - 1)
            dy = y - 1
        else
            -- If the block below isn't the same door, it's already the bottom part
            dy = y ;
        end
        -- check what block were there
        local r, blockid_a = Block:getBlockID(x,dy+2,z) 
        if blockid_a == circuit.powerOff then 
            Block:setBlockAllForUpdate(x,dy+2,z, circuit.power)
            RUNNER.NEW(function()
                Block:setBlockAllForUpdate(x,dy+2,z, circuit.powerOff)
            end,{},50)
        else 
            -- Block:setBlockAllForUpdate(x,dy+2,z, circuit.powerOff)
            -- Ignore;
        end 
    end
end

local function checkCard(playerid)
    for i=1,30 do 
        local r,itemid = Backpack:getGridItemID(playerid, i-1);
        if itemid == KeyCard then 
            return true 
        end 
    end 
    for i=1000,1007 do 
        local r,itemid = Backpack:getGridItemID(playerid, i-1);
        if itemid == KeyCard then 
            return true 
        end 
    end 
    return false;
end

function IF_HAS_ACCESS_CARD(playerid)
    local r , team = Player:getTeam(playerid)
    if r == 0 then 
        -- success obtain team id 
        if team == police then 
            -- this is police team doesnt need key card to open door 
            return true 
        else 
            -- check if it has keycard 
            if checkCard(playerid) then 
                return true
            else
                Player:notifyGameInfo2Self(playerid,"KeyCard is Required")
                return false
            end 
        end 
    end 
end

function TRY_SPAWN_CAR(x,y,z)
    local r , blockid = Block:getBlockID(x, y-2, z)
    local rr , data = Block:getBlockData(x, y, z)
    if blockid == 40 then 
        local r, itemid , n = WorldContainer:getStorageItem(x,y-3,z,0);
        if r == 0 then 
            local mobid = n ;
            local offset = 7;
            local LastCreated=0;
            if data == 8 then 
                local code,obj = World:spawnCreature(x+offset,y-1,z,mobid,1);
                Actor:setFaceYaw(obj[1],90)
            elseif data == 9 then
                local code,obj = World:spawnCreature(x-offset,y-1,z,mobid,1);
                Actor:setFaceYaw(obj[1],0)
            elseif data == 10 then
                local code,obj = World:spawnCreature(x,y-1,z+offset,mobid,1);
                Actor:setFaceYaw(obj[1],180)
            elseif data == 11 then
                local code,obj = World:spawnCreature(x,y-1,z-offset,mobid,1);
                Actor:setFaceYaw(obj[1],270)
            end 
        end 
        local r = Block:setBlockAll(x,y-2,z,1)
        RUNNER.NEW(function()
            local r = Block:setBlockAll(x,y-2,z,40)
        end,{},100)
    end 
end 

-- Register a Script Api 
-- Event for  the lever to be activated 
ScriptSupportEvent:registerEvent("Block.Trigger",function(e)
--    test("Testing : ", e);
    --[=[ Result 
        y = 22,    x =- 139,    z = 46 ,
        selectuiid = [[7417481922212468978]] ,
        CurEventParam = {
            EventShortCutldx = 5,
            SelectUIID = [[7417481922212468978]],
            EventTargetBuff = {
            Ivl = 1
            }
            EventTargetBlock = 358,
            TriggerByPlayer = 1029380338,
            EventTargetPos = {
            y = 22,
            x= -139,
            z= 46
            msgStr = [[Block.Trigger]] 
        },
        blockid = 358 , -- A Lever 
        eventobjid = 1029380338 , 
        msgStr = [[Block.Trigger]]
    --]=]
    local x,y,z,b,ev,uiid,msgStr = GLOBAL_LEVER.UNRAVEL(e);
    local id = GLOBAL_LEVER.ENCODE(x,y,z,b)   
    -- Chat:sendSystemMsg(id);
    -- print(id);
    -- check if GLOBAL_LEVER.DATA[id] is not nil 
    if GLOBAL_LEVER.DATA[id] then
        -- check if it has function stored with key f and pass it args
        if GLOBAL_LEVER.DATA[id].f then
            GLOBAL_LEVER.DATA[id].f({arg=GLOBAL_LEVER.DATA[id].arg,playerid = ev})
        else 
            Player:notifyGameInfo2Self(ev,"Nothing Happen");
        end 
    else
        if b == GLOBAL_LEVER.TYPE.Stone_Button then 
            if IF_HAS_ACCESS_CARD(ev) then 
                for ox = -2 , 2 do 
                    for oz = -2 , 2 do 
                        GLOBAL_LEVER.OPEN_DOOR(x+ox,y,z+oz,1101)
                    end 
                end 
            end 
        end 
        if b == GLOBAL_LEVER.TYPE.Wooden_Button then 
            TRY_SPAWN_CAR(x,y,z);
        end 
        -- Player:notifyGameInfo2Self(1029380338,"x = "..x.." y = "..y.." z = "..z.." is Not Set");
    end 

    
end)
