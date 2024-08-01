local function addEffect(x,y,z,effectid,scale)     World:playParticalEffect(x,y,z,effectid,scale); end 
local function cancelEffect(x,y,z,effectid,scale)     World:stopEffectOnPosition(x,y,z,effectid,scale); end

ScriptSupportEvent:registerEvent("Block.Add",function(e) 
    if(e.blockid == 113)then
        local r,areaid = Area:createAreaRect({x=e.x,y=e.y,z=e.z},{x=2,y=2,z=2});
        threadpool:wait(2);
        local r ,c = Area:getAreaCreatures(areaid);
        local r ,p = Area:getAreaPlayers(areaid);

        if(#c > 0)then 
            for i,a in ipairs(c) do 
                Actor:addBuff(a, 1050,5, 60);
            end 
        end 
        if(#p > 0)then 
            for i,a in ipairs(p) do 
                Actor:addBuff(a, 1050,5, 60);
            end 
        end 
        addEffect(e.x,e.y,e.z,3033,1);
        World:playSoundEffectOnPos({x=e.x,y=e.y,z=e.z}, 10006, 300, 1.2, false);
        Block:destroyBlock(e.x,e.y,e.z,false);
        threadpool:wait(1);
        cancelEffect(e.x,e.y,e.z,3033);
        Area:destroyArea(areaid)
    end 
end)

local before = {};

-- ice bug 
-- THIS part is to Fix Ice Bug

ScriptSupportEvent:registerEvent("Actor.AddBuff",function(e) 
    if(e.buffid == 1050)then 
        if(before[e.eventobjid]==nil)then 
        local r,model= Actor:getActorFacade(e.eventobjid)
        before[e.eventobjid]=model;
        end 
    end    
end )

ScriptSupportEvent:registerEvent("Actor.RemoveBuff",function(e) 
    if(e.buffid == 1050)then 
        Actor:changeCustomModel(e.eventobjid,[[skin_33]])
        threadpool:wait(0.5);
        --Chat:sendSystemMsg("Restoring Model ");
        Actor:changeCustomModel(e.eventobjid,before[e.eventobjid])
    end    
end)

ScriptSupportEvent:registerEvent("Player.AddBuff",function(e) 
     if(e.buffid == 1050)then 
        if(before[e.eventobjid]==nil)then 
        local r,model= Actor:getActorFacade(e.eventobjid)
        --Chat:sendSystemMsg("Model before is = "..model , e.eventobjid);
        before[e.eventobjid]=model;
        end 
     end    
end )

ScriptSupportEvent:registerEvent("Player.RemoveBuff",function(e) 
    if(e.buffid == 1050)then 
        Actor:changeCustomModel(e.eventobjid,[[skin_33]])
        threadpool:wait(0.5);
        --Chat:sendSystemMsg("Restoring Model ");
        Actor:changeCustomModel(e.eventobjid,before[e.eventobjid])
    end    
end)