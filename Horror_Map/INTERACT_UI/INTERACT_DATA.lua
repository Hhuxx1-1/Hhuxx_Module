local interact_data_mt = {
    __index = function(self, index)
        if type(index) ~= "string" then
            local key = tostring(index)
            -- Use rawget to avoid calling __index again
            local data = rawget(self, key)
            if data ~= nil then
                return {f = data.f or false, a = data.a or {}}
            else
                print("index "..key.."Data unset")
                return {f = false, a = {}}
            end
        end 
    end,    
    __call = function(self,id,func,args)
        -- add into table 
        self[tostring(id)] = {f= func,a = args};
    end 
}
INTERACT_DATA = setmetatable({},interact_data_mt);
INTERACT_DATA_NAME = { DATA = {} };
INTERACT_DATA_NAME.SET = function(id,name)
    INTERACT_DATA_NAME.DATA[id] = name;
    end
INTERACT_DATA_NAME.GET = function(id)
        if INTERACT_DATA_NAME.DATA[id] == nil then 
            print("Interaction Name Not Set");
            return "Interact";
        else 
            return INTERACT_DATA_NAME.DATA[id]
        end
    end
--------------[end]

ScriptSupportEvent:registerEvent("UI.Button.TouchBegin",function(e)
    local playerid = e.eventobjid;
    local elementid = e.uielement;
    if elementid == INTERACTIVE_UI["btn"] then 
        local state,obj = getPlayerState(playerid);
        if state == "M" then 
            local r ,IDs=Creature:getActorID(obj);
            
            local data = INTERACT_DATA[IDs]
            if data ~= nil then
                local f,a = data.f,data.a
                if f ~= false then 
                    local r,err = pcall(f,{playerid=playerid,state=state,obj=obj,IDs=IDs},a)
                    if not r then 
                        print("#RError when ["..playerid.."] Interacting with :",obj,"as [",IDs,"] Error :",err);
                    end 
                end 
            else    
                Player:notifyGameInfo2Self(playerid,"Object Interaction Not Set")
            end 

        elseif state == "P" then

            local data = INTERACT_DATA[obj]
            if data ~= nil then
                local f,a = data.f,data.a
                if f ~= false then 
                    local r,err = pcall(f,{playerid=playerid,state=state,obj=obj,IDs=IDs},a)
                    if not r then 
                        print("#RError when ["..playerid.."] Interacting with :",obj,"as [",IDs,"] Error :",err);
                    end 
                end 
            else    
                Player:notifyGameInfo2Self(playerid,"Object Interaction Not Set")
            end 
        end 
    end 
end)