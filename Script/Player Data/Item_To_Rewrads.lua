local itemHolder = {} ; ITEM_SHOP = {}; ITEM_SHOP.REGISTER_NEW_ITEM = function(itemid,func)         itemHolder[itemid]=func ; end ; ITEM_SHOP.GET_ITEM = function(itemid)     return itemHolder[itemid];  end ; ScriptSupportEvent:registerEvent([[Player.AddItem]],function (e)   if(ITEM_SHOP.GET_ITEM(e.itemid))then  ITEM_SHOP.GET_ITEM(e.itemid)(e); end ; end)
-- Write The Registered Item Like Diz : 
-- local itemDummyID = 12003;
-- ITEM_SHOP.REGISTER_NEW_ITEM(itemDummyID,function(e) print("ItemID : ",e); end);

-- Money Items
ITEM_SHOP.REGISTER_NEW_ITEM(4104,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,100); 
    Player:removeBackpackItem(playerid, 4104, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4105,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,500); 
    Player:removeBackpackItem(playerid, 4105, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4114,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,5000); 
    Player:removeBackpackItem(playerid, 4114, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4108,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,50000); 
    Player:removeBackpackItem(playerid, 4108, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4106,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,10000); 
    Player:removeBackpackItem(playerid, 4106, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4107,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,100000); 
    Player:removeBackpackItem(playerid, 4107, 1);
end );

-- EXP ITEMS 
ITEM_SHOP.REGISTER_NEW_ITEM(4111,function(e)  local playerid = e.eventobjid; Actor:addBuff(playerid,50000011,1,12000)
    Player:removeBackpackItem(playerid, 4111, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4112,function(e)  local playerid = e.eventobjid; Actor:addBuff(playerid,50000012,1,12000)
    Player:removeBackpackItem(playerid, 4112, 1);
end );
ITEM_SHOP.REGISTER_NEW_ITEM(4113,function(e)  local playerid = e.eventobjid; Actor:addBuff(playerid,50000013,1,12000)
    Player:removeBackpackItem(playerid, 4113, 1);
end );
--  DOuble Money Buff 
ITEM_SHOP.REGISTER_NEW_ITEM(4115,function(e)  local playerid = e.eventobjid; Actor:addBuff(playerid,50000015,1,12000)
    Player:removeBackpackItem(playerid, 4115, 1);
end );