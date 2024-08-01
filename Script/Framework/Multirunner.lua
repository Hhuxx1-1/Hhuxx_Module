--Multirunner Framework
--[[ 
===================================================================############-------------||||||
###### This is Simple Framework to Handle Multirun Simultaneously Easier                    ######
###### This also Object's Player Ownership; BY Using RUNNER.OBJECT to store it Ownership    ######
###### USE RUNNER.NEW(function to execute,{v1,v2,v3},thick delay)                           ######
###### to Create Action That is Executed After Periods of Time                              ######
###### Acess Documentation                                                                  ######
===================================================================############-------------||||||
]]--
RUNNER  = {};RUNNER.LIB={}; RUNNER.EVENT = {}; RUNNER.OBJECT = {}; RUNNER.DELAYED_EVENT = {};
--[[
===================================================================
*****            This is LIST of Method To Use               ******
===================================================================
]]--
RUNNER.CALL                     = function(f,args)              table.insert(RUNNER.EVENT,{f=f,args=args}); end ;
RUNNER.NEW                      = function(f,args,delay)        local idEvent = #RUNNER.DELAYED_EVENT + 1;  table.insert(RUNNER.DELAYED_EVENT,idEvent,{f=f,args=args,delay=delay});    return idEvent; end;
RUNNER.REVOKE                   = function(idEvent)             table.remove(RUNNER.DELAYED_EVENT,idEvent);end;
RUNNER.Obj_REGISTER             = function(objectid,playerid)   RUNNER.OBJECT[objectid] = playerid; end;
RUNNER.Obj_UNREGISTER           = function(objectid,playerid)   RUNNER.OBJECT[objectid] = nil; end;
RUNNER.Obj_OF                   = function(objectid)            return RUNNER.OBJECT[objectid]; end;          RUNNER.OBj_LFUNC = {}; RUNNER.Obj_Do_Func              = function(objectid,e)    if type(RUNNER.OBj_LFUNC[objectid]) == "function" then        RUNNER.OBj_LFUNC[objectid](objectid,e);    end; end
RUNNER.ATTACH_Func_Obj          = function(objectid,func)       RUNNER.OBj_LFUNC[objectid] = func; end
RUNNER.UNATTACH_Func_Obj        = function(objectid,func)       RUNNER.OBj_LFUNC[objectid] = nil; end
RUNNER.LENGTH                   = function ()                   local c = 0 ; for i in ipairs(RUNNER.EVENT) do c = i; end return c; end ;
RUNNER.DELAY_LENGTH             = function ()                   local c = 0 ; for i in ipairs(RUNNER.DELAYED_EVENT) do c = i; end return c; end ;
RUNNER.SET_NPC_RADIUS           = function (v) RUNNER.NPC_RADIUS = v ;end;
RUNNER.CREATE_NPC               = function (id,x,y,z)

end;
--[[ 
==============================================================
-- This Script Support RUNNER Call on RUNNER EVENT Table    ==
-- RUNNER Use Runner LIB                                    ==]]

RUNNER.EXECUTE_DELAYED_EVENT    = function(idEvent)
    local toExecute = RUNNER.DELAYED_EVENT[idEvent] ;
    if toExecute.delay > 0 then
        RUNNER.DELAYED_EVENT[idEvent].delay = toExecute.delay - 1;
    else
        local success, result = pcall(function() return toExecute.f(unpack(toExecute.args)) end) 
        if success then  
            table.remove(RUNNER.DELAYED_EVENT, idEvent); 
            return result 
        else 
            print("Error executing [",idEvent,"] :", result);
            table.remove(RUNNER.DELAYED_EVENT, idEvent); 
        end 
    end 
end ; 
RUNNER.EXECUTE                  = function(idEvent)    
    local toExecute = RUNNER.EVENT[idEvent];    
    local result = toExecute.f(unpack(toExecute.args));    
    table.remove(RUNNER.EVENT,idEvent);  
    return result; 
end ; 
    
ScriptSupportEvent:registerEvent("Game.RunTime",function(e) 
    if(RUNNER.LENGTH() > 0 )then  
        for i,a in pairs(RUNNER.EVENT) do 
            RUNNER.EXECUTE(i); end end end);
            
ScriptSupportEvent:registerEvent("Game.RunTime",function(e) 
    if(RUNNER.DELAY_LENGTH() > 0 )then 
        for i,a in pairs(RUNNER.DELAYED_EVENT) do 
            RUNNER.EXECUTE_DELAYED_EVENT(i);end end end);
            
RUNNER.NPC_RADIUS               = 10;

ScriptSupportEvent:registerEvent("Actor.Projectile.Hit",function(e)
    local r,code = pcall(function(e) RUNNER.Obj_Do_Func(e.eventobjid,e);        end,e)
    if r ~= true then print("When Executing func on Projectile ["..e.eventobjid.."] : ",r,code) end
    RUNNER.Obj_UNREGISTER(e.eventobjid);RUNNER.UNATTACH_Func_Obj(e.eventobjid);end)
--[[
-- ===========================================================
-- Library Of Block Initiated Here
]]--
RUNNER.LIB.BLOCK={
    Cherry_Wood     = 200
    ,Larch_Wood     = 201
    ,Poplar_Wood    = 202
    ,Red_Wood       = 203
    ,Walnut_Wood    = 204
    --Add More As Needed
}
-- Library Of Items Initatied Here 
RUNNER.LIB.ITEM={
    Energy_Sword    = 12005;
    --Add More As Needed 
}
-- ===========================================================
-- END of This Framework,                                   ==
-- You Can Use As Long this Script Is Initated              ==
--before anything Else                                      ==
-- ===========================================================