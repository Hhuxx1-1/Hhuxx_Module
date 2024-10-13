ADD_COIN_2_PLAYER = function(playerid,v)
    print(" Calling function ")
    if GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",v) then 
        -- play sound effect on player position 
        print(playerid)
        local r,x,y,z = Actor:getPosition(playerid)
        World:playSoundEffectOnPos({x=x,y=y,z=z}, 10963, math.random(4,9)*10, math.random(99,105)/100, false);
        -- play Particle Effects
        World:playParticalEffect(x,y,z, 1321, 1);
        return true ;
    else 
        return false;
    end 
end

local function Check4Coin(targetid,playerid)
    local coin_id = 3;
    local r, actorid = Creature:getActorID(targetid);
    -- print(" b Actorid : ",actorid)
    if actorid == coin_id then
        -- print("Actorid : ",actorid)
       if ADD_COIN_2_PLAYER(playerid,1) then 
        -- delete the current targetid 
        World:despawnActor(targetid) 
       end 
    end 
end 


ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid , targetid = e.eventobjid , e.toobjid;    
    Check4Coin(targetid,playerid)
end)

ScriptSupportEvent:registerEvent("Player.Collide",function(e) 
    local playerid , targetid = e.eventobjid , e.toobjid;
    Check4Coin(targetid,playerid)
end)