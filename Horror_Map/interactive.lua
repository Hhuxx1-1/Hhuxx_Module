BONFIRE = {};
BONFIRE.POS = {x=-1,y=7,z=-16};

local function setInvincible(id)
    Actor:setActionAttrState(id,1,false);
    Actor:setActionAttrState(id,8,false);
    Actor:setActionAttrState(id,64,false);
    Actor:setActionAttrState(id,128,false);
end 

ScriptSupportEvent:registerEvent("Game.Start",function()
    local r , w = World:spawnCreature(BONFIRE.POS.x,BONFIRE.POS.y,BONFIRE.POS.z,3803,1)
    local r = Actor:changeCustomModel(w[1], [[fullycustom_10293803381723370252]])
    setInvincible(w[1]);
end)