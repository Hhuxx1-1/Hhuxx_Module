SPAWNER_AI  = {};

SPAWNER_AI.LOADED                   = {};           -- Load ID of creatures here when they are going to spawned;
SPAWNER_AI.SPAWNED                  = {};           -- Save Spawned ID here;
SPAWNER_AI.LEVEL                    = 0;            -- Save current Level here;
SPAWNER_AI.POINT                    = 0;            -- Point to Spend;
SPAWNER_AI.POINT_GROWTH             = 10;           -- Increase 10 each wave;
SPAWNER_AI.SPAN_TIME                = 10;            -- Span Time Between Current Wave and Next Wave; 
SPAWNER_AI.SWITCH                   = false;        -- Determine Wave is Paused or Started;
SPAWNER_AI.TIMER                    = 0;            -- Save Current Span here;
SPAWNER_AI.GROWTH_POINT_MULTIPLIER  = 1.15;          -- Growth Multiplier
SPAWNER_AI.SPAWNED_COUNT            = 0 ;           -- Store Spawned Count here;
SPAWNER_AI.SET_MONSTER              = {};           -- Store Set of the Monster here
SPAWNER_AI.SPAWN_POINT              = {};           -- Store SpawnPoing of Monster here
SPAWNER_AI.STATE_UI                 = "NONE";       -- Store State UI here;
SPAWNER_AI.SET_MONSTER_ON_COOLDOWN  = {};           -- Store Set of the Monster that is currently on Cooldown here
SPAWNER_AI.SET_MONSTER_ON_COOLDOWN_DURATION = 7     -- Duration of Cooldown is 2 Wave;
SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT = {}           -- State of Monster Cooldown here;
--a helper function to get Table Length;
local function LEN(t)
    local count = 0;
    for i,a in pairs(t) do 
        count = count + 1;
    end 
    return count;
end

function SPAWNER_AI:START_WAVE()
    -- start the game wave
    SPAWNER_AI.SWITCH = true;
    SPAWNER_AI.POINT = SPAWNER_AI.POINT + math.floor(SPAWNER_AI.POINT_GROWTH);
    SPAWNER_AI.TIMER = SPAWNER_AI.SPAN_TIME;
    -- This Will set The Start 
    -- print("SPAWNER_AI is STARTED");
end 

function SPAWNER_AI:NEXT_WAVE(b)
    SPAWNER_AI:START_WAVE();
    SPAWNER_AI.POINT_GROWTH = SPAWNER_AI.POINT_GROWTH * SPAWNER_AI.GROWTH_POINT_MULTIPLIER;
    if b then 
        SPAWNER_AI.LEVEL = SPAWNER_AI.LEVEL + 1;
    end 
end

local lastPos = {} -- Helper table to store last position of the spawned creature

function SPAWNER_AI:FORCE_TO_ACTIVE_ZONE(monsterid) -- actual spawned id
    -- Check position and compare it. If it is the same, then it will be moved to the active zone.
    local r, x, y, z = Actor:getPosition(monsterid)
    if r == 0 then 
        if lastPos[monsterid] == nil then 
            -- If this is the first time the monster is checked
            lastPos[monsterid] = {x = x, y = y, z = z}
        end 

        -- Compare the position of the monster with the last position
        if lastPos[monsterid].x == x and lastPos[monsterid].y == y and lastPos[monsterid].z == z then
            -- Position hasn't changed, find the nearest player
            local result, num, array = World:getAllPlayers(1) -- Constant 1 is player that is alive
            if num > 0 then 
                local nearestPlayer = nil
                local shortestDistance = 64 --maximum size of the map
                
                -- Get the position and calculate the distance
                for i, playerid in ipairs(array) do 
                    local r2, px, py, pz = Actor:getPosition(playerid)
                    if r2 == 0 then
                        local distance = math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPlayer = {x = px, y = py, z = pz}
                        end 
                    end
                end 

                -- If a nearest player was found, move the monster to the player's position
                if nearestPlayer then
                    Actor:tryMoveToPos(monsterid, nearestPlayer.x, nearestPlayer.y, nearestPlayer.z,0.9);
                else 
                    -- If no player was found, move the monster to the active zone 
                    Actor:tryMoveToPos(monsterid, x, 7, 30,1);
                end
            end 
        end 

        -- Update the last position of the monster
        lastPos[monsterid] = {x = x, y = y, z = z}
    end 
end

local function increaseCounterForMonster(monster)
    if SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] == nil then 
        SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] = 0 ;
    end 
    SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] = SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] + 1;

    local tresshold = 10; -- everytime it spawned more than 10 times;
    -- enter the cooldown 
    if SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] > tresshold then 
        SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] = SPAWNER_AI.SET_MONSTER_ON_COOLDOWN_DURATION;
        -- Chat:sendSystemMsg(monster.id.." Is Now On Cooldown");
    end 
end

function SPAWNER_AI:TRY_SUMMON(priority)
    -- print("TRYING TO SUMMON ");
    local priority_ = priority or "None";
    -- Try to summon a creature
    -- get list 
    local list = SPAWNER_AI.SET_MONSTER; 
    -- id , cost , rare
    -- filter only have rare == priority_ and cost <= point
    local filtered_list = {};
    for i,monster in pairs(list) do
        if monster.rare == priority_ and monster.cost <= SPAWNER_AI.POINT then
            -- add the Cooldown Logic 
            if SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] == nil then
                table.insert(filtered_list,monster);
            elseif SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] > 0 then 
                -- reduce the cooldown
                SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] = SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] - 1 ;
                -- print("COOLDOWN REDUCED");
            else
                SPAWNER_AI.SET_MONSTER_SPAWNED_COUNT[monster.id] = 0 ;
                SPAWNER_AI.SET_MONSTER_ON_COOLDOWN[monster.id] = nil ;
                table.insert(filtered_list,monster);
            end 
        end 
    end
    -- check LEN of the filtered_list 
    if LEN(filtered_list) <= 0 then
        return false; --Don't Spend anything becuz there is no monster to summon and skip to next wave;
    else

        local summon_list = {}
        -- calculate what could be summoned from all the list and still spendable 
        -- calculate each list and probability
        for prob = 1 , 10 do 
            local point_simulation = 0;
            summon_list[prob] = {};
            while point_simulation <= SPAWNER_AI.POINT do 
                local indeks = math.random(1,LEN(filtered_list));
                local monster = filtered_list[indeks];
                point_simulation = point_simulation + monster.cost;
                table.insert(summon_list[prob],monster);
            end 
            summon_list[prob].final_point = point_simulation;
        end 

        -- now from that 10 probability could exist;
        -- that is the one that we will summon
        local max_prob = 0;
        local max_prob_index = 0;
        -- use alghoritm for odd/even level
        if SPAWNER_AI.LEVEL % 2 == 0 then
            -- even level
            -- get the highest Price Spend
            for prob,monster_list in pairs(summon_list) do
                if prob > max_prob and monster_list.final_point > SPAWNER_AI.POINT then
                    max_prob = prob;
                    max_prob_index = prob;
                end
            end 
        else 
            -- odd level
            -- get Most Possible Monster
            for prob,monster_list in pairs(summon_list) do
                if LEN(monster_list) > max_prob then
                    max_prob = LEN(monster_list);
                    max_prob_index = prob;
                end
            end 
        end 

        -- Continue to summon it
        -- get the monster list
        local monster_list = summon_list[max_prob_index];
        -- add the monster id into SPAWNER_AI.LOADED 
        for i,monster in ipairs(monster_list) do 
            -- pick random position from SPAWN_POINT 
             
            local SPAWN_POINT = SPAWNER_AI.SPAWN_POINT;
            local position = SPAWN_POINT[math.random(1,LEN(SPAWN_POINT))];
            if position then 

                if i < 50 then
                    table.insert(SPAWNER_AI.LOADED,{id = monster.id , pos = position});
                else 
                    RUNNER.NEW(function()
                        table.insert(SPAWNER_AI.LOADED,{id = monster.id , pos = position});
                    end,{},math.ceil(i/5)) 
                end 
                -- handle cooldown counter
                increaseCounterForMonster(monster);
            end 
        end 

        -- update the POINT 
        -- Chat:sendSystemMsg("AI POINTS BEFORE SPENDING : "..SPAWNER_AI.POINT.." POINTS");
        -- Chat:sendSystemMsg("AI SPEND : "..summon_list[max_prob_index].final_point.." POINTS");
        SPAWNER_AI.POINT = SPAWNER_AI.POINT - summon_list[max_prob_index].final_point;
        -- Chat:sendSystemMsg("AI POINTS NOW : "..SPAWNER_AI.POINT.." POINTS");
        if SPAWNER_AI.POINT < 0 then 
            SPAWNER_AI.POINT = math.abs(SPAWNER_AI.POINT); -- AI Assume he got bonus point for negatif Point
        end 
    end 
    -- print(SPAWNER_AI); --for debuging

    return true;
end

function SPAWNER_AI:ADD_MONSTER(id,cost,rarity_)
    local rarity = rarity_ or "None"; --default is "None";
    -- add into SET_MONSTER
    table.insert(SPAWNER_AI.SET_MONSTER,{id=id,cost=cost,rare = rarity});
    -- print("MONSTER SET : ",SPAWNER_AI.SET_MONSTER);
end

function SPAWNER_AI:ADJUST_SPAWN(data)
    if data then 
        SPAWNER_AI.SPAWN_POINT = data;
    end 
end

function SPAWNER_AI:ADD_EVENT(func,cost)
    
end

local function showWaveInterface(UI)
    
    local code, n, playerlist = World:getAllPlayers(-1);
    -- get Current Level 
    local Level = SPAWNER_AI.LEVEL;
    local pre_level = "Wave ";
    for i , playerid in ipairs(playerlist) do 
        if T_Text then
            pre_level = T_Text(playerid,"Wave");
        end
        Player:openUIView(playerid,UI);
        Customui:setText(playerid,UI,UI.."_2",pre_level..Level);
    end 
end

function SPAWNER_AI:UPDATE_UI()
    -- function to handle UI update to ALL player in game;
    local State = SPAWNER_AI.STATE_UI;
    local code, n, playerlist = World:getAllPlayers(-1);
    local UI = "7445867180683106546";
    showWaveInterface(UI);

    if State == "SHOW_WAVE" then
        -- update the Counter Down;
        local pre_level = "Next in "
        local count = SPAWNER_AI.TIMER;
        for i , playerid in ipairs(playerlist) do
            Customui:setText(playerid,UI,UI.."_3",pre_level..count);
        end 
    end 

    if State == "SHOW_ENEMIES" then
        local pre_level = " Left"
        local count = SPAWNER_AI.SPAWNED_COUNT;
        for i , playerid in ipairs(playerlist) do
            Customui:setText(playerid,UI,UI.."_3",count..pre_level);
        end 
    end 
    
end

local function doWin()
    
end

-- Listen Event for each tick s/20;
ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    if SPAWNER_AI.SWITCH then 
        -- print("tick run : "..e.ticks);
        if e.second then 

            -- Check For each Spawned Creature 
            local SPAWNED_COUNT = 0;
            if LEN(SPAWNER_AI.SPAWNED) > 0 then 
                for i,id in pairs(SPAWNER_AI.SPAWNED) do 
                    -- get their Attribute of HP 
                    local r,HP = Creature:getAttr(id,2) -- 2 is Constant for HP use API only;
                    -- check if API is successfully Executed 
                    if r == 0 then --check if error code is 0;
                        -- Creature is still exist and still capabble of obtaining their HP
                        SPAWNED_COUNT = SPAWNED_COUNT + 1;
                        SPAWNER_AI:FORCE_TO_ACTIVE_ZONE(id);
                    else
                        -- Creature is dead or not exist
                        -- remove it
                        SPAWNER_AI.SPAWNED[i] = nil;
                    end
                end 
            end 
            -- print("SPAWN COUNT",SPAWNER_AI.SPAWNED_COUNT)
            SPAWNER_AI.SPAWNED_COUNT = SPAWNED_COUNT;
            if SPAWNED_COUNT == 0 then 
                if SPAWNER_AI.TIMER > 0 then 
                    if SPAWNER_AI.TIMER == SPAWNER_AI.SPAN_TIME then 
                        -- Notify players Wave Changes
                        SPAWNER_AI.STATE_UI = "SHOW_WAVE";

                        if SPAWNER_AI.LEVEL == 20 then 
                            SPAWNER_AI.SPAN_TIME = 15;
                        end 
                        if SPAWNER_AI.LEVEL == 40 then 
                            SPAWNER_AI.SPAN_TIME = 20;
                        end 
                        if SPAWNER_AI.LEVEL == 60 then 
                            SPAWNER_AI.SPAN_TIME = 25;
                        end 
                        if SPAWNER_AI.LEVEL > 100 then 
                            doWin();
                        end 
                    end 
                    SPAWNER_AI.TIMER = SPAWNER_AI.TIMER  - 1 ;
                    -- print("Timer is Counted Down ",SPAWNER_AI.TIMER);
                else 
                    SPAWNER_AI.SWITCH = false; -- Pause The Loader for doing such a waste;
                    -- try Summon 
                    SPAWNER_AI.STATE_UI = "SHOW_ENEMIES";
                    SPAWNER_AI:NEXT_WAVE(SPAWNER_AI:TRY_SUMMON());
                end 
            end 

            SPAWNER_AI:UPDATE_UI() --This only update Data of UI for all player in game;
            
        end 

        if LEN(SPAWNER_AI.LOADED)>0 then 
            local count = 0;
            for i,dat in pairs(SPAWNER_AI.LOADED) do 
                local id    = dat.id;
                local pos   = dat.pos;
                local r , array_obj = World:spawnCreature(pos.x,pos.y,pos.z,id,1);
                if r == 0 then --[[r == 0 means API successfully Executed and returning Error Code 0 ]]
                    -- store that id from array_obj  into spawned creature
                    table.insert(SPAWNER_AI.SPAWNED,array_obj[1]); -- only spawn one creature and store the result id from array_obj[1] into SPAWNED;
                    -- remove from SPAWNER_AI.LOADED
                    SPAWNER_AI.LOADED[i] = nil;
                    count = count + 1;
                end 
                if count > 3 then --add delay so it won't lag  
                    break;
                end 
            end 
        end 

    end 
end)

-- Data here
SPAWNER_AI:ADD_MONSTER(2,10); -- Black Normal
SPAWNER_AI:ADD_MONSTER(3,7);  -- Orange Normal
SPAWNER_AI:ADD_MONSTER(4,12); -- Grey Strong 
SPAWNER_AI:ADD_MONSTER(5,24); -- brown 
SPAWNER_AI:ADD_MONSTER(6,26); -- red strong 
SPAWNER_AI:ADD_MONSTER(7,22); -- Grey Normal 
SPAWNER_AI:ADD_MONSTER(8,23); -- Eye Normal
SPAWNER_AI:ADD_MONSTER(9,25); -- Blue Strong
SPAWNER_AI:ADD_MONSTER(10,35); -- Blue Strong
SPAWNER_AI:ADD_MONSTER(11,29); -- Yellow Strong
SPAWNER_AI:ADD_MONSTER(12,59); -- Siul Strong
SPAWNER_AI:ADD_MONSTER(13,150); -- White Strong  
SPAWNER_AI:ADD_MONSTER(14,100); -- Pink Strong  
SPAWNER_AI:ADD_MONSTER(15,50); -- Yellow Strong  
SPAWNER_AI:ADD_MONSTER(16,40); -- Green Strong  
SPAWNER_AI:ADD_MONSTER(17,55); -- Snare Green Strong 
SPAWNER_AI:ADD_MONSTER(18,65); -- Tree Strong  
SPAWNER_AI:ADD_MONSTER(19,225); -- Computer Strong  
SPAWNER_AI:ADD_MONSTER(20,25); -- Computer Normal  
SPAWNER_AI:ADD_MONSTER(21,52); -- Robot Normal  
SPAWNER_AI:ADD_MONSTER(22,52); -- White Normal  

local _data = {}; for i=0,9 do  _data[i] = {x=-23 + (i*5),y=7,z=-24} end 
SPAWNER_AI:ADJUST_SPAWN(_data);
SPAWNER_AI:START_WAVE();