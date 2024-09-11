-- THIS IS ITEM BOUGHT / COLLECTED WILL EXECUTE FUNCTION ON PLAYER 
local itemHolder = {} ; 
ITEM_SHOP = {}; 
ITEM_SHOP.REGISTER_NEW_ITEM = function(itemid,func)         itemHolder[itemid]=func ; end ; 
ITEM_SHOP.GET_ITEM = function(itemid)     return itemHolder[itemid];  end ; 
ScriptSupportEvent:registerEvent([[Player.AddItem]],function (e)   
    if(ITEM_SHOP.GET_ITEM(e.itemid))then  ITEM_SHOP.GET_ITEM(e.itemid)(e); end ; end)
-- Write The Registered Item Like Diz : 
-- local itemDummyID = 12003;
-- ITEM_SHOP.REGISTER_NEW_ITEM(itemDummyID,function(e) print("ItemID : ",e); end);

-- Money Items
-- ITEM_SHOP.REGISTER_NEW_ITEM(4104,function(e)  local playerid = e.eventobjid; PLAYER_DAT.ADD_MONEY(playerid,100); 
--     Player:removeBackpackItem(playerid, 4104, 1);
-- end );

-- RIFLE 4116 -> 4112
-- SNIPER 4117 -> 4113
-- RPG 4118 -> 4114
-- Javelin 4120 -> 4119
ITEM_SHOP.REGISTER_NEW_ITEM(4116,function(e)  
    local playerid = e.eventobjid;
    local itemid = 4112;
    -- Add into GLOBAL BACKPACK the Itemid
    Player:removeBackpackItem(playerid, 4116, 1);
    GLOBAL_BACKPACK.ADD_DATA(playerid,4112,8);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end) 

ITEM_SHOP.REGISTER_NEW_ITEM(4117,function(e)  
    local playerid = e.eventobjid;
    local itemid = 4113;
    -- Add into GLOBAL BACKPACK the Itemid
    Player:removeBackpackItem(playerid, 4117, 1);
    GLOBAL_BACKPACK.ADD_DATA(playerid,itemid,9);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end) 

ITEM_SHOP.REGISTER_NEW_ITEM(4118,function(e)  
    local playerid = e.eventobjid;
    local itemid = 4115;
    -- Add into GLOBAL BACKPACK the Itemid
    Player:removeBackpackItem(playerid, 4118, 1);
    GLOBAL_BACKPACK.ADD_DATA(playerid,itemid,10);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end) 

ITEM_SHOP.REGISTER_NEW_ITEM(4120,function(e)  
    local playerid = e.eventobjid;
    local itemid = 4119;
    -- Add into GLOBAL BACKPACK the Itemid
    Player:removeBackpackItem(playerid, 4120, 1);
    GLOBAL_BACKPACK.ADD_DATA(playerid,itemid,11);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end) 