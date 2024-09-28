-- This is Wardrobe Framework Lua Called As Wardrobe
GLOBAL_WARDOBE = {} -- Initiate GLOBAL table named Wardrobe 
-- Require Trigger Save to Save Player data as Group of String 
--[[ 
    Please Name A Group of String Private Variable as "GLOBAL_WARDROBE_VAR"
]]
-- This will save what skin player already Unlocked on the Map 

-- STORE RENDERED DATA HERE 
GLOBAL_WARDOBE.SKIN_DATA = {

}

GLOBAL_WARDOBE.LOAD_DATA = function(playerid)
    local stringGroupName = "GLOBAL_WARDROBE_VAR";
    local stringGroup = 18;
    local r , data = Valuegroup:getAllGroupItem(stringGroup, stringGroupName, playerid);
    -- print(data);
    -- -- Check if it is an Empty table
    -- if data == {} then 

    -- end 
    if r == 0 then 
        return data;
    else 
        print("ERROR FAILED AT GETTING INFORMATION FROM GROUP ITEM STRING GROUP [GLOBAL_WARDOBE_VAR]") ;
        return false;
    end
end

GLOBAL_WARDOBE.RENDER_DATA = function(i)
    local prefix = [[skin_]]
    local skin = prefix .. i
    GLOBAL_WARDOBE.SKIN_DATA[i] = { id = skin }
end

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame", function(e)
   local playerid = e.eventobjid;
   local r, err = pcall(GLOBAL_WARDOBE.LOAD_DATA,playerid);
   if not r then print("[Wardrobe] ",err) end
end)