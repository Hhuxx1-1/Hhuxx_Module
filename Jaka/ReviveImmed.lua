ScriptSupportEvent:registerEvent("Player.Die",function(e)
    local playerid = e.eventobjid; 
    local x,y,z = 1000,10,-1000
    Player:reviveToPos(playerid, x ,y ,z )
end)