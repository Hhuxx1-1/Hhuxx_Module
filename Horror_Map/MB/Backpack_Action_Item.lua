-- Fire Match 
ITEM_BACKPACK.New(4101,function(playerid,itemid)
    Player:notifyGameInfo2Self(playerid,"Firematch can be used to lit fire")
end)

--Handgun 
ITEM_BACKPACK.New(4106,function(playerid,itemid)
    -- Equip  handgun
    for i = 1000 , 1008 do 
        Backpack:setGridItem(playerid,i,itemid,1,nil)
    end 
end)

--M4A1 Rifle  
ITEM_BACKPACK.New(4112,function(playerid,itemid)
    -- Equip  handgun
    for i = 1000 , 1008 do 
        Backpack:setGridItem(playerid,i,itemid,1,nil)
    end 
end)

--Barret
ITEM_BACKPACK.New(4113,function(playerid,itemid)
    -- Equip  handgun
    for i = 1000 , 1008 do 
        Backpack:setGridItem(playerid,i,itemid,1,nil)
    end 
end)

--RPG 
ITEM_BACKPACK.New(4115,function(playerid,itemid)
    -- Equip  handgun
    for i = 1000 , 1008 do 
        Backpack:setGridItem(playerid,i,itemid,1,nil)
    end 
end)

--Javelin 
ITEM_BACKPACK.New(4119,function(playerid,itemid)
    -- Equip  handgun
    for i = 1000 , 1008 do 
        Backpack:setGridItem(playerid,i,itemid,1,nil)
    end 
end)

--Mechanical Part 
ITEM_BACKPACK.New(4128,function(playerid,itemid)
    Player:notifyGameInfo2Self(playerid,"Mechanical Part used to Repair Generator")
end)

--Medkit  
ITEM_BACKPACK.New(4131,function(playerid,itemid)
    -- Equip Medkit 
    local r, hp = Player:getAttr(playerid, 2)	
    local r, maxhp = Player:getAttr(playerid, 1)	
    local hpnow  = hp + 50

    if hp  < maxhp-20 then
        if GLOBAL_BACKPACK.RemoveItemFromBackpack(playerid,itemid) then
            local r     = Player:setAttr(playerid, 2, hpnow);
            Player:notifyGameInfo2Self(playerid,"#GHP Recovered")
            GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid)
        end 
    else 
        Player:notifyGameInfo2Self(playerid,"#YHP is Not Low")
    end 
end)