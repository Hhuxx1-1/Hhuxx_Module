-- version: 2022-04-20
-- mini: 1029380338
local RakeSpawned={};
SpawnerStart = false;
local function rakeSetSpawned(a)
    table.insert(RakeSpawned,a);
end 

local spawnCooldown = {};
local SpawnInterval = 360;

function SPAWNER_SET_INTERVAL(v)
    SpawnInterval = v;
end
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

local monsters = {
    2,5,21,2
}

local function summonMonster(x,y,z)
   local angle = math.random() * 2 * math.pi

    -- Convert polar coordinates to Cartesian coordinates
    local rx = x + 28 * math.cos(angle)
    local rz = z + 28 * math.sin(angle)
    local sEffect = {11004, 10320};
    if(isEmptySpace(rx,y,rz))then 
        --Chat:sendSystemMsg("Rake Spawned")
        local r , rake = World:spawnCreature(rx,y,rz, monsters[math.random(1,#monsters)],1);
        rakeSetSpawned(rake[1]);
    else 
        threadpool:wait(0.1);
        World:playSoundEffectOnPos({x=rx,y=y+1,z=rz}, sEffect[math.random(1,2)], 100, 1, false)
        summonMonster(x,y+math.random(0,1),z);
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
            spawnCooldown[a]=spawnCooldown[a]-math.random(1,2);
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
    if SpawnerStart then 
    local s = e.second
    if(s)then
        isMonsterTime() ;
    end 
    end 
end)
