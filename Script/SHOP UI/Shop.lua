SHOP = { _PLAYER = {}};
SHOP.CREATE                 = function(Name,actorid)     table.insert(SHOP,actorid,{name=Name,data={},dialog="Hey There!",icon=[[3003010]]}); end 
SHOP.INSERT                 = function(actorid,itemid,itemprice,itemstock)     table.insert(SHOP[actorid].data,{id=itemid,price=itemprice,stock=itemstock}); end 
SHOP.SETDIALOG              = function(actorid,text)     SHOP[actorid].dialog = text; end 
SHOP.SETICON                = function(actorid,text)     SHOP[actorid].icon = text; end 
SHOP.SETDATA                = function(actorid,new_data)     SHOP[actorid].data = new_data;  end
SHOP.ACCESS                 = function(actorid)     return SHOP[actorid]; end 
SHOP.ACCESS_NAME            = function(actorid)     return SHOP[actorid].name; end 
SHOP.ACCESS_DATA            = function(actorid)     return SHOP[actorid].data; end 
SHOP.ACCESS_DIALOG          = function(actorid)     return SHOP[actorid].dialog;  end 
SHOP.ACCESS_ICON            = function(actorid)     return SHOP[actorid].icon;  end 
SHOP.ACCESS_ITEMKEY         = function(actorid,key) return SHOP[actorid].data[key]; end 
SHOP.UPDATE_ITEMKEY         = function(actorid,k,v) SHOP[actorid].data[k] = v; end 
SHOP.CHECK                  = function(actorid)     if(SHOP[actorid]~=nil)then return true else return false end end 
SHOP.PLAYER_SET             = function(playerid,actorid)    SHOP._PLAYER[playerid]=actorid; end 
SHOP.PLAYER_UNSET           = function(playerid)            SHOP._PLAYER[playerid]=nil; end 
SHOP.PLAYER_GET             = function(playerid)            return SHOP._PLAYER[playerid]; end 
SHOP.OPEN                   = function(playerid)            Player:openUIView(playerid,"7229175948772055282") end 
SHOP.UPDATE_ITEMKEY_STOCK   = function(actorid,k,v) SHOP[actorid].data[k].stock = v; end 
SHOP.UPDATE_ITEMKEY_PRICE   = function(actorid,k,v) SHOP[actorid].data[k].price = v; end 
SHOP.UPDATE_ITEMKEY_ID      = function(actorid,k,v) SHOP[actorid].data[k].id = v; end 

-- Debug Purpose 
--print(SHOP);

-- Initiate The Script Function  

ScriptSupportEvent:registerEvent([=[Player.ClickActor]=],function(e)
    local actorid = e.targetactorid; local playerid = e.eventobjid;
    if(SHOP.CHECK(actorid))then 
        SHOP.PLAYER_SET(playerid,actorid);
        SHOP.OPEN(playerid);
    else 
        
    end 
end)