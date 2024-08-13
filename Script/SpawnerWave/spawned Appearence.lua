MOD_APPEARENCE = true ;

local exclude = {
    4,2,3,5,6,7,8,9,10,11,12,13,14,15
}

local invincible = {
    4,5,6,8,9,10,11,12,13
}

MOD_APPEARENCE_SKIN={
    [[skin_1]],[[skin_2]],[[skin_3]],[[skin_4]],[[skin_5]],[[skin_6]],[[skin_7]],[[skin_8]],[[skin_9]],[[skin_10]],
        [[skin_18]],[[skin_19]],[[skin_20]],[[skin_21]],[[skin_22]],[[skin_23]],[[skin_24]],[[skin_25]],[[skin_63]]
}

local function randomModel()
    local skin = MOD_APPEARENCE_SKIN;
    return skin[math.random(1,#skin)];
end 

local function setModel(id,mid)
    Actor:changeCustomModel(id,mid)
end 

local function getCreature(id)
    local r, res = Creature:getActorID(id)
    if r==0 then return res end 
end 

local function isIN (array, valueToCheck)
    for _, value in ipairs(array) do
        if value == valueToCheck then
            return true
        end
    end
    return false
end

local function makeHuman(id)
    local r = math.random(2,6);
    Creature:setAttr(id,10, 340)
    Creature:setAttr(id,1,r*100);
    Creature:setAttr(id,2,r*100);
end 

local function setInvincible(id)
    Actor:setActionAttrState(id,1,false);
    Actor:setActionAttrState(id,8,false);
    Actor:setActionAttrState(id,64,false);
    Actor:setActionAttrState(id,128,false);
end 

ScriptSupportEvent:registerEvent("Actor.Create",function(e)
    local actorid = e.eventobjid;
    local creatureid = getCreature(actorid);
    if(MOD_APPEARENCE)then 
        if(isIN(exclude,creatureid)==false)then 
            local isDayTime =World:isDaytime();
            setModel(actorid,randomModel())
        end 
        if(isIN(invincible,creatureid))then
            setInvincible(actorid)
        end 
    end 
end)