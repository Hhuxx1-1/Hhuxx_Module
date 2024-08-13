ScriptSupportEvent:registerEvent("Particle.Pos.OnCreate",function(e)
    local x,y,z,partid = e.x,e.y,e.z,e.effectid
    RUNNER.NEW(function(x,y,z,partid)
        MYTOOL.DEL_EFFECT(x,y,z,partid,1);
    end,{x,y,z,partid},200)
end)


local before = {};
local size_before = {};
-- ice bug 
-- THIS part is to Fix Ice Bug

ScriptSupportEvent:registerEvent("Actor.AddBuff",function(e) 
    if(e.buffid == 1050)then 
        if(before[e.eventobjid]==nil)then 
        local r,model= Actor:getActorFacade(e.eventobjid)
        before[e.eventobjid]=model;
        end 
        if(size_before[e.eventobjid]==nil)then 
        local r, size = Creature:getAttr(e.eventobjid,21);
        size_before[e.eventobjid]=size;
        end 
    end    
end )

ScriptSupportEvent:registerEvent("Actor.RemoveBuff",function(e) 
    if(e.buffid == 1050)then 
        Actor:changeCustomModel(e.eventobjid,[[skin_33]])
        local r, size = Creature:setAttr(e.eventobjid,21,size_before[e.eventobjid]);
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