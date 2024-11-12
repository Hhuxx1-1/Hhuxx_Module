--[[ The Idea is to Check for Each Player if there is a specific block nearby that determine what data to load ]]
--[[ the Data is Stored on a Storage Box Chest just like How to Spawn a car ]]
--[[ This method allowing dynamic and easy way to create Spawner and reduce memory for the Game Significantly ]]
--[[ The storage block is stored -3 block from the block spawner ]]
--[[ After the Block spawned the Spawner Block changed to Cooldown block which has different worker that handle the respawning logic ]]

local encodesxyz =  function(x,y,z)
    -- convert x,y,z that could have negatif number into readable single string without losing the information 
    local x = "X"..string.gsub(tostring(x),"-","N")
    local y = "Y"..string.gsub(tostring(y),"-","N")
    local z = "Z"..string.gsub(tostring(z),"-","N")
    -- convert those redeclared x,y,z as string into single string 
    return x.." "..y.." "..z;
end

local decodesxyz = function(encoded_str)
    -- Match the encoded string pattern
    local x_str, y_str, z_str = string.match(encoded_str, "X([N%d]+) Y([N%d]+) Z([N%d]+)")
    
    -- Check if match was successful; otherwise, handle as an error
    if not x_str or not y_str or not z_str then
        error("Invalid encoded string format")
    end
    
    -- Remove 'N' to convert back to negative numbers
    local x = tonumber((x_str:gsub("N", "-")))
    local y = tonumber((y_str:gsub("N", "-")))
    local z = tonumber((z_str:gsub("N", "-")))
    
    return x, y, z
end

local SpawnedCreature={};

-- define Load Data Storage 
local LoadDataStorage = function(x,y,z)
    y = 1 ; --One Block Above Flamas Ultra Stone 
    -- Method Changed to Allow Call Big ID we need big number 
    local data = 0;
    for  i=0,29 do 
        local r1, _ , d = WorldContainer:getStorageItem(x,y,z,i);
        --print(r1 , d )
        if r1 == 0 then 
            data = data + d 
        end 
    end 
    -- if data == 0 then 
    --     Chat:sendSystemMsg("Data for x : "..x.." y : "..y.." z : "..z.." is #Rnot set "..data);
    -- else
    --     Chat:sendSystemMsg("Data for x : "..x.." y : "..y.." z : "..z.." is "..data);
    -- end 
    return data 
end

-- Handle Finding block logic 
local findNearbySpawner = function(playerid)
    local SpawnerBlockId = 2006;
    local SearchRange = 28;
    local r , decx, decy ,decz = Actor:findNearestBlock(tonumber(playerid), SpawnerBlockId, SearchRange);
    if r == 0 then 
        return {x=math.floor(decx*100),y=math.floor(decy*100),z=math.floor(decz*100)}
    end 
end

-- Set into Cooldown 
local setBlockIntoCooldown = function(x,y,z)
    local r = Block:destroyBlock(x,y,z,false);
    if r==0 then
        return true;
    end
end
-- Set After Cooldown end 
local setBlockIntoCooldownEnd = function(x,y,z)
    local SpawnerBlockIdCD = 2006;
    local r = Block:setBlockAll(x,y,z,SpawnerBlockIdCD,1);
    if r==0 then
        return true;
    else
        --print("Failure of Setting Block Into Cooldown "); 
        return false;
    end
end

-- Spawn the Creature Into World 
local createActor = function(id,x,y,z)
    local r,obj = World:spawnCreature(x,y,z,id);
    if r == 0 then 
        return obj[1]
    end 
end

-- Get All Player  
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end

local calculate_distance = function(px, py, pz, x, y, z)
    return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
end

ScriptSupportEvent:registerEvent([=[Game.RunTime]=],function(e)
    for i,a in ipairs(GetAllPlayer()) do 
        -- Chat:sendSystemMsg(""..a);-- Yes it is Executing 
        local r , c = pcall(function()
            if findNearbySpawner(a) then 
                -- Chat:sendSystemMsg(""..a.." Found a Spawner")
                local S = findNearbySpawner(a); 
                -- print(S)
                if S and setBlockIntoCooldown(S.x,S.y,S.z) then  
                    local d = LoadDataStorage(S.x,S.y,S.z)
                    -- print(d);
                    if d then 
                        local ids = encodesxyz(S.x,S.y,S.z);
                        --Chat:sendSystemMsg("Detected Ids : "..ids);
                        --print("Spawned Creature : ",SpawnedCreature);
                        if SpawnedCreature[ids] == nil then 
                            SpawnedCreature[ids] = createActor(d,S.x,S.y,S.z);
                        else 
                            -- check it's current HP 
                            local r = Creature:getAttr(SpawnedCreature[ids],2);
                            -- print("Getting : attribute  of creature = ",r );

                            if r ~= 0 then 
                                SpawnedCreature[ids] = nil;
                            end 
                        end 
                        RUNNER.NEW(function()
                            setBlockIntoCooldownEnd(S.x,S.y,S.z);
                        end,{},100);
                    end  
                end 
            end     
        end)
        if not r then print("Error When Finding Block Respawn ",c); end 
    end 

    -- we need to also check for Spawned Creature[ids]
    if e.second then 
        for i , a in pairs(SpawnedCreature) do 
            
            local r = Creature:getAttr(a,2);
            local x,y,z = decodesxyz(i);
            if r ~= 0 then
                -- creature is not exist but still there 
                --Chat:sendSystemMsg("Cooldown reset for  "..x.." "..y.." "..z);
                setBlockIntoCooldownEnd(x,y,z);
                -- once the block reset it will be fixed automatically 
            else 
                local r,ax,ay,az = Actor:getPosition(a);
                if calculate_distance(ax,ay,az,x,y,z) > 20 then 
                    Actor:setPosition(a,x,y,z);
                end 
            end 
        end 
    end 
end)