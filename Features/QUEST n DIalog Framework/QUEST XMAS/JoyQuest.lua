local SkateBuff = 50000000;

ScriptSupportEvent:registerEvent("Player.MoveOneBlockSize",function (e)
    local playerid,x,y,z = e.eventobjid,e.x,e.y,e.z;
    if y < 52 then 
        if HX_Q:GET(playerid,"Move_Block_Count") == "Empty" then 
            HX_Q:SET(playerid,"Move_Block_Count",0);
        end 
        local proggress = tonumber(HX_Q:GET(playerid,"Move_Block_Count"));
        HX_Q:SET(playerid,"Move_Block_Count",proggress + 1);

        -- check if player is on Skatting buff 
        if Actor:hasBuff(playerid,SkateBuff) == 0 then 
            if HX_Q:GET(playerid,"Skating_Move_Block_Count") == "Empty" then 
                HX_Q:SET(playerid,"Skating_Move_Block_Count",0);
            end 
            local proggress = tonumber(HX_Q:GET(playerid,"Move_Block_Count"));
            HX_Q:SET(playerid,"Skating_Move_Block_Count",proggress + 1);
        end 
    else 
        Player:notifyGameInfo2Self(playerid,"Flying is Illegal");
        Player:setPosition(playerid,x,-1,z);
    end 
end)