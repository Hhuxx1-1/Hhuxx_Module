ScriptSupportEvent:registerEvent("Game.Start",function()
    HX_Q:CREATE_QUEST(40,{
        name = "conditionX", dialog = "Do you Have Crystal Ore?",
        [1] = function(playerid)
            return true; 
        end,
        [2] = function(playerid)
            return true ;
        end,
        [3] = function(playerid)
            return true ;
        end
    });
end)
