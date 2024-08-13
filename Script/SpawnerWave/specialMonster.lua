--_VERSION = 5.1
BOSS = {} -- Holder for Global calling 
BOSS.ID = {}    -- Save actorid here 
BOSS.OnSpawn = {} -- save creatureid here 
-- Function to init actorid to be loaded when boss spawned 
BOSS.NONHOOKCD = {};
BOSS.NONHOOKCD_RESET = {};
BOSS.INIT = function(id, name)
    BOSS.ID[id] = {name = name , nonhook = {} , hook = {}}
end

-- Function to add Action based on hook or non hook 
-- [[Hook will be activated according to the Event Hook  ]]
-- [[Non hook will be activated randomly between 4-9 seconds ]]

BOSS.ADD_ACTION = function(id, func, hook)
    if hook == nil then
        table.insert(BOSS.ID[id].nonhook, func)
    else
        BOSS.ID[id].hook[hook] = func
    end
end

BOSS.unsetNonHook = function(id)
    BOSS.ID[id].nonhook = {}
end

BOSS.addNonHook = function(id,func) 
    table.insert(BOSS.OnSpawn[id].nonhook,func);
end 

BOSS.LOAD_ACTION = function(creatureId, actorid)
    -- Load actorid from BOSS.ID
    local data_id = BOSS.ID[actorid]
    local name = data_id.name;
    -- Load non hook action
    for i, v in ipairs(data_id.nonhook) do
        BOSS.OnSpawn[creatureId].nonhook[i]=v;
    end 
    -- Load Hook Action
    for i, v in pairs(data_id.hook) do
        BOSS.OnSpawn[creatureId].hook[i]=v;
    end 
end

BOSS.HOOK_Type = {
    OnSpawn = "OnSpawn", OnAttack = "OnAttack", OnDefeat = "OnDefeat", OnHpLow = "OnHpLow" , OnDamaged = "OnDamaged"
}

BOSS.SET_SPAWNED = function(modelId,CreatureId)
    BOSS.OnSpawn[CreatureId] = { creatureId = CreatureId,
        modelId = modelId , 
        nonhook = {},
        hook = {}
    };
    -- LOAD HOOK and Non Hook
    BOSS.LOAD_ACTION(CreatureId, modelId);
    BOSS.NONHOOKCD[CreatureId]=math.random(6,9);
    return threadpool:wait(0.1);
end


ScriptSupportEvent:registerEvent("Actor.Attack",function(e)
    local creatureId = e.eventobjid
    local modelId = e.actorid
    -- check if exist on the Boss 
    if BOSS.OnSpawn[creatureId] ~= nil then
        -- to avoid error check before calling the function 
        if BOSS.OnSpawn[creatureId].hook.OnAttack ~= nil then 
        -- Load Hook Action
        BOSS.OnSpawn[creatureId].hook.OnAttack(creatureId);
        end 
    end 
end)

ScriptSupportEvent:registerEvent("Actor.BeHurt",function(e)
    local creatureId = e.eventobjid
    local modelId = e.actorid
    if BOSS.OnSpawn[creatureId] ~= nil then
        -- to avoid error check before calling the function 
        if BOSS.OnSpawn[creatureId].hook.OnDamaged ~= nil then
        -- Load Hook Action
        BOSS.OnSpawn[creatureId].hook.OnDamaged(creatureId);
        end
    end 
end)

ScriptSupportEvent:registerEvent("Actor.Die",function(e)
    local creatureId = e.eventobjid
    local modelId = e.actorid
    -- check if exist on the Boss 
    if BOSS.OnSpawn[creatureId] ~= nil then
        -- to avoid error check before calling the function 
        if BOSS.OnSpawn[creatureId].hook.OnDefeat ~= nil then
        -- Load Hook Action
        BOSS.OnSpawn[creatureId].hook.OnDefeat(creatureId);
        end
    end 
end)

ScriptSupportEvent:registerEvent("Actor.ChangeAttr",function(e)
    local creatureId = e.eventobjid
    local modelId = e.actorid;
    local actorattr = e.actorattr;
    local change = e.actorattrval;
    -- check if exist on the Boss
    if BOSS.OnSpawn[creatureId] ~= nil then
        -- Load Hook Actio  
        -- get Max HP 
        local ret,MaxHP = Actor:getMaxHP(creatureId);
        local ret, HP = Actor:getHP(creatureId);
        -- check if HP is low
        if HP <= MaxHP * 0.5 then
            -- Load Hook Action
            -- Check if function exist before calling to make sure no failing 
            if BOSS.OnSpawn[creatureId].hook.OnHpLow ~= nil then
                BOSS.OnSpawn[creatureId].hook.OnHpLow(creatureId);
                -- unset it so it doesn't triggered again 
                BOSS.OnSpawn[creatureId].hook.OnHpLow = nil;
            end 
        end 
    end 
end)

local function isAlive(creatureId)
    local r,HP = Actor:getHP(creatureId);
    if r==0 and HP>0 then return HP end --Success
    return 0; 
end

ScriptSupportEvent:registerEvent("Actor.Create", function(e)
    local creatureId = e.eventobjid
    local modelId = e.actorid
    if BOSS.ID[modelId] ~= nil then
        BOSS.SET_SPAWNED(modelId,creatureId);
        if BOSS.OnSpawn[creatureId] then 
            -- check if hook exist 
            if BOSS.OnSpawn[creatureId].hook.OnSpawn ~= nil then
                -- Load Hook Action
                BOSS.OnSpawn[creatureId].hook.OnSpawn(creatureId);
            end 
        end 
    end
end)

local Gcounter = {}

ScriptSupportEvent:registerEvent("Game.RunTime",function(as)
    if as.second == nil then return end 

    for i,e in pairs(BOSS.OnSpawn) do 
    local creatureId = e.creatureId 
    if Gcounter[creatureId] == nil then  Gcounter[creatureId]=1 end 
    local counter = Gcounter[creatureId];
    if isAlive(creatureId) > 0 then 
        if BOSS.OnSpawn[creatureId].nonhook ~= nil then 
            if BOSS.NONHOOKCD[creatureId] > 0 then 
                BOSS.NONHOOKCD[creatureId] = BOSS.NONHOOKCD[creatureId] - 1
                -- get non hook length ;
            else 
                local lenth = #BOSS.OnSpawn[creatureId].nonhook;
                -- check if greater than 0 
                if lenth > 0 then 
                    -- Load nonHook Action
                    local r, e = pcall(function()
                        BOSS.OnSpawn[creatureId].nonhook[1 + math.fmod(counter, lenth)](creatureId);
                    end)
                    if not r then print(e) end 
                    counter = counter + 1;
                    Gcounter[creatureId] = counter;
                end 
                -- CD Non Hook
                if BOSS.NONHOOKCD_RESET[creatureId] == nil then 
                    BOSS.NONHOOKCD[creatureId] = math.random(6, 9);
                else 
                    BOSS.NONHOOKCD[creatureId] = BOSS.NONHOOKCD_RESET[creatureId];    
                end 
            end 
        end
    else 
        -- Clear unused space 
        Gcounter[creatureId] = nil;
        BOSS.OnSpawn[creatureId] = nil;
    end 
    end 
end)

-- Example Usage:
-- BOSS.INIT(1, "Dragon")
-- BOSS.ADD_ACTION(1, function() print("Dragon spawned") end, "OnSpawn")

BOSS.TOOL = {};
BOSS.TOOL.ATTACk = function(id,tablePos,tableDim,dmgData)
    local x,y,z      = tablePos.x,tablePos.y,tablePos.z;
    local dx,dy,dz   = tableDim.x,tableDim.y,tableDim.z;
    local dmg        = dmgData.dmg or 5 ;
    local dmgType    = dmgData.type or 1;
    local OBJ = MYTOOL.getObj_Area(x,y,z,dx,dy,dz);
    local playerObj = MYTOOL.filterObj("Player",OBJ);
    local actorObj = MYTOOL.filterObj("Creature",OBJ);
    actorObj = MYTOOL.notObj(id,actorObj);
    OBJ = MYTOOL.mergeTables(playerObj,actorObj);
    for i ,a in ipairs(OBJ) do 
        MYTOOL.ActorDmg2Player(id,a,dmg,dmgType);
    end 
end