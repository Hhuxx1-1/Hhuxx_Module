CUTSCENE:CREATE("FIRST_START",{
    [1] = function(playerid)
        
    end,
    [40] = function(playerid)
        CUTSCENE:moveCamera(5,0,5,playerid)
    end,
    [200] = function(playerid)
        return true;
    end,
    ["END"] = function()
        -- this function is executed when skipped or all the things ended 
            -- this is where you could continue adding QUEST 
    end
})