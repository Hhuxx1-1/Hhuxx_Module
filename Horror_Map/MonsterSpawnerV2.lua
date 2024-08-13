-- version: 2022-04-20
-- mini: 1029380338
RakeSpawned={};

local function rakeSetSpawned(a)
    table.insert(RakeSpawned,a);
end 

local spawnCooldown = {};
local SpawnInterval = 120;
local function isEmptySpace(x,y,z)
    local result = true; 
    for ix=-1,1 do 
        for iz=-1,1 do 
            for iy=0,1 do 
                local r = Block:isAirBlock(x+ix, y+iy, z+iz);
                if(r==1001)then
                    result=false;
                    break;
                end 
            end 
        end 
    end 
    return result;
end 

local function summonMonster(x,y,z)
   local angle = math.random() * 2 * math.pi

    -- Convert polar coordinates to Cartesian coordinates
    local rx = x + 26 * math.cos(angle)
    local rz = z + 26 * math.sin(angle)
    if(isEmptySpace(rx,y,rz))then 
        --Chat:sendSystemMsg("Rake Spawned")
        --Game:dispatchEvent("RAKE_ADD")
        local r , rake = World:spawnCreature(rx,y,rz, 2,1);
        rakeSetSpawned(rake[1]);
    else 
        threadpool:wait(0.1);
        summonMonster(x,y,z);
    end 
end 

local function isMonsterTime() 
    local r = World:isDaytime();

    if(r==1001)then 
    local r,n,p = World:getAllPlayers(1);
    for i,a in ipairs(p)do 
        if(spawnCooldown[a]==nil)then 
            spawnCooldown[a]=math.floor(SpawnInterval/4)+math.random(1,10);
        end 
        if(spawnCooldown[a]>0)then 
            spawnCooldown[a]=spawnCooldown[a]-1;
        else 
            local r,x,y,z = Actor:getPosition(a);
            summonMonster(x,y,z);
            spawnCooldown[a]=SpawnInterval;
        end 
    end 
    else 
        for i , a in pairs(RakeSpawned) do 
            Actor:killSelf(a);
        end 
    end 
    
end 

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    local s = e.second
    if(s)then
        isMonsterTime() ;
    end 
end)
