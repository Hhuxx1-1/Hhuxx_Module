local itemHolder = {} ; ITEM_SHOP = {}; ITEM_SHOP.REGISTER_NEW_ITEM = function(itemid,func)         itemHolder[itemid]=func ; end ; ITEM_SHOP.GET_ITEM = function(itemid)     return itemHolder[itemid];  end ; ScriptSupportEvent:registerEvent([[Player.AddItem]],function (e)   if(ITEM_SHOP.GET_ITEM(e.itemid))then  ITEM_SHOP.GET_ITEM(e.itemid)(e); end ; end)
-- Write The Registered Item Like Diz : 
-- local itemDummyID = 12003;
-- ITEM_SHOP.REGISTER_NEW_ITEM(itemDummyID,function(e) print("ItemID : ",e); end);

-- Money Items
ITEM_SHOP.REGISTER_NEW_ITEM(4104,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,100); 
    Player:removeBackpackItem(playerid, 4104, 1);
end );