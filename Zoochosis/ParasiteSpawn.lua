-- version: 2022-04-20
-- mini: 1029380338
local MonsSpawned={};
SpawnerStart = true;
local function SetSpawned(a)
    table.insert(MonsSpawned,a);
end 

local monsters = {
    11,11,9
}

local spawnCooldown = {};
local SpawnInterval = 20;

function SPAWNER_SET_INTERVAL(v)
    SpawnInterval = v;
end

function SPAWNER_ADD_MODELID(v)
    table.insert(monsters,v)
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


local function summonMonster(x,y,z)
   local angle = math.random() * 2 * math.pi

    -- Convert polar coordinates to Cartesian coordinates
    local rx = x + 8 * math.cos(angle)
    local rz = z + 8 * math.sin(angle)
    local sEffect = {11004, 10320};
    if(isEmptySpace(rx,y,rz))then 
        local r , rake = World:spawnCreature(rx,y,rz, monsters[math.random(1,#monsters)],1);
        SetSpawned(rake[1]);
    else 
        threadpool:wait(0.1);
        World:playSoundEffectOnPos({x=rx,y=y+1,z=rz}, sEffect[math.random(1,2)], 100, 1, false)
        summonMonster(x,y+math.random(0,1),z);
    end 
end 

-- Function to get all players from the game API
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end

local function set_notifier(t1,t2)
    local uiid = "7427861672755927282"
    local main_text = uiid.."_1";
    local sub_text = uiid.."_2";
    for i,playerid in ipairs(GetAllPlayer()) do 
        local r= Player:openUIView(playerid,uiid);
        if r == 0 then 
            if t1 ~= nil then 
                local r = Customui:setText(playerid,uiid,main_text,tostring(t1));
            end 
            if t2 ~= nil then 
                local r = Customui:setText(playerid,uiid,sub_text,tostring(t2));
            end 
        end 
    end 
end

local function isMonsterTime() 
    local r = World:isDaytime();

    if(r==1001)then 
        set_notifier("Night Time","Careful Monster");
        local r,n,p = World:getAllPlayers(1);
        for i,a in ipairs(p)do 
            if(spawnCooldown[a]==nil)then 
                spawnCooldown[a]=math.floor(SpawnInterval/4)+math.random(1,5);
            end 
            if(spawnCooldown[a]>0)then 
                spawnCooldown[a]=spawnCooldown[a]-1
            else 
                local r,x,y,z = Actor:getPosition(a);
                summonMonster(x,y,z);
                spawnCooldown[a]=SpawnInterval;
            end 
        end 
    else 
        for i , a in pairs(MonsSpawned) do 
            Actor:killSelf(a);
        end 
        MonsSpawned={};
        set_notifier("Day Time","Take Care of Animal Zoo");
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
