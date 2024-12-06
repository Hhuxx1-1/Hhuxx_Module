ADD_COIN_2_PLAYER = function(playerid,v)
    print(" Calling function ")
    if GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",v) then 
        -- play sound effect on player position 
        print(playerid)
        local r,x,y,z = Actor:getPosition(playerid)
        World:playSoundEffectOnPos({x=x,y=y,z=z}, 10963, math.random(4,9)*10, 1, false);
        -- play Particle Effects
        World:playParticalEffect(x,y,z, 1321, 1);
        return true ;
    else 
        return false;
    end 
end

local function Check4Coin(targetid,playerid)
    local coin_id = 67;
    local chest_id = 68;
    local r, actorid = Creature:getActorID(targetid);
    -- print(" b Actorid : ",actorid)
    if actorid == coin_id then
        -- print("Actorid : ",actorid)
       if ADD_COIN_2_PLAYER(playerid,5) then 
        -- delete the current targetid 
        World:despawnActor(targetid) 
       end 
    end 
    
    if actorid == chest_id then
        -- print("Actorid : ",actorid)
       local r , HP = Creature:getAttr(targetid,2);
       if HP > 10 then 
           if ADD_COIN_2_PLAYER(playerid,math.random(20,30)) then 
            -- delete the current targetid
            -- World:despawnActor(targetid) 
            local r = Creature:setAttr(targetid,21,0);
            local r,x,y,z = Actor:getPosition(targetid);
            Creature:setAttr(targetid,HP,9)
            Actor:setPosition(targetid,x,2,z);
           end 
        end 
    end 
end 

-- -- Money Items
ITEM_SHOP.REGISTER_NEW_ITEM(12964,function(e)  local playerid = e.eventobjid;
     if ADD_COIN_2_PLAYER(playerid,100) then 
        Player:removeBackpackItem(playerid, 12964, 1);
     end 
end);

local Coins_Values = {
    [4222] = 1000,
    [4223] = 3000,
    [4224] = 6000,
    [4225] = 10000,
    [4226] = 50000,
    [4227] = 150000,
    [4228] = 400000,
    [4229] = 900000,
    [4230] = 1900000
}
for i,v in pairs(Coins_Values) do 
    ITEM_SHOP.REGISTER_NEW_ITEM(i,function(e)  local playerid = e.eventobjid;
        if ADD_COIN_2_PLAYER(playerid,v) then 
            Player:removeBackpackItem(playerid, i, 1);
        end 
    end);
end 
ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid , targetid = e.eventobjid , e.toobjid;    
    Check4Coin(targetid,playerid)
end)

ScriptSupportEvent:registerEvent("Player.Collide",function(e) 
    local playerid , targetid = e.eventobjid , e.toobjid;
    Check4Coin(targetid,playerid)
end)