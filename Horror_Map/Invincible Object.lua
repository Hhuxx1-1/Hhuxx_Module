local invincible = {};INVINC_SET = function(creatureid)
    table.insert(invincible,creatureid);
end;local function getCreature(id)
    local r, res = Creature:getActorID(id)
    if r==0 then return res end 
end ; local function isIN (array, valueToCheck)
    for _, value in ipairs(array) do
        if value == valueToCheck then
            return true
        end
    end
    return false
end ; local function setInvincible(id)
    Actor:setActionAttrState(id,1,false);
    Actor:setActionAttrState(id,8,false);
    Actor:setActionAttrState(id,64,false);
    Actor:setActionAttrState(id,128,false);
end ; ScriptSupportEvent:registerEvent("Actor.Create",function(e)
    local actorid = e.eventobjid;
    local creatureid = getCreature(actorid);
    if(isIN(invincible,creatureid))then
        setInvincible(actorid)
    end 
end)
-- [[ SET IT HERE ]]
INVINC_SET(3)