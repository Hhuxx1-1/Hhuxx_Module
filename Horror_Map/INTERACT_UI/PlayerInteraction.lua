local function playSoundOnPos(x,y,z,whatsound,volume) 
    World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, 1, false)
end 
local function exact(d1)
    return d1.playerid,d1.obj,d1.IDs,d1.state;
end

local function playerIsKnock(obj)
    local buffKnock =   50000005;
    local r , bool = Actor:hasBuff(obj,buffKnock)
    if r == 0 then return true else return false end 
end

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    local player = e.eventobjid; 
    print("Registering : "..player)
    INTERACT_DATA_NAME.SET(player,"Player");INTERACT_DATA(player,function(d1,d2) 
        local playerid,obj,IDs,state = exact(d1);
        local player = d2.player;
        if playerIsKnock(player) then 
            PLAYER_REVIVE.ADD_REVIVER(player,playerid);
        else 
            if Player:HasFriend(playerid,player) == 0 then 

            else
                Player:SendFriendApply(playerid, player) 
            end
        end 
    end,{player=player});
end)