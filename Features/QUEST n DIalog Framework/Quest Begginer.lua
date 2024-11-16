HX_Q:CREATE_QUEST(0,{
    name = "none", dialog = "",
    hint = {x=-151,y=7,z=-153},
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = -151 , 7 , -153; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Move Forward ("..dis.."  Block Away ) " , detail="Tap for Hint"});
            -- create Graphic info on Location 
            
        end 
    end,
    [3] = function(playerid)    
        Chat:sendSystemMsg("Talk to Mini Captain");
        HX_Q.CURRENT_NPC[playerid] = nil;
    end 
})

local function set2FarPosition(playerid,x,y,z)
    if Actor:killSelf(playerid) == 0 then 
        Player:reviveToPos(playerid,x,y,z)
    end 
end

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    local playerid = e.eventobjid;
    if HX_Q.CURRENT_QUEST[playerid]  == nil then
        if HX_Q:GET_CurQuest(playerid) == "none" then 
            set2FarPosition(playerid,-156,7,-102)
            CUTSCENE:start(playerid,"FIRST_START")
        end 
    end 
end)