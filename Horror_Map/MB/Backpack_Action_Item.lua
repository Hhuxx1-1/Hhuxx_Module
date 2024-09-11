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