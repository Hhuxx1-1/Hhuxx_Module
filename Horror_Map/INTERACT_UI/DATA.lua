local function exact(d1)
    return d1.playerid,d1.obj,d1.IDs,d1.state;
end
local function playSoundOnPos(x,y,z,whatsound,volume) 
    World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, 1, false)
end 
INTERACT_DATA_NAME.SET(3,"Fire Up"); INTERACT_DATA(3,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local firematch = d2.itemid;
    local lightblock = d2.light;
   if GLOBAL_BACKPACK.IsItemInBackpack(playerid,firematch) then 
    if GLOBAL_BACKPACK.RemoveItemFromBackpack(playerid,firematch) then 
        local r , x , y , z = Actor:getPosition(obj);
        Block:placeBlock(lightblock,x,y,z);
        World:playParticalEffect(x,y-1,z, d2.fire_effect, 3);
        playSoundOnPos(x,y,z,10537,50);
        GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
    end 
   else 
    Player:notifyGameInfo2Self(playerid,"Need Fire Match to Light");
   end 
end,{itemid=4101,light=2004,fire_effect=1395})

INTERACT_DATA_NAME.SET(4,"Pick Up"); INTERACT_DATA(4,function(d1,d2) 
    local playerid,obj,IDs,state = exact(d1);
    local firematch = d2.itemid;
    Player:playMusic(playerid, 10955, 60,1,false)
    Player:notifyGameInfo2Self(playerid,"Obtain Firematch");
    GLOBAL_BACKPACK.ADD_DATA(playerid,firematch,IDs);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end,{itemid=4101});

INTERACT_DATA_NAME.SET(7,"Pick Up"); INTERACT_DATA(7,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local handgun = d2.itemid;
    Player:playMusic(playerid, 10955, 60,1,false);
    Player:notifyGameInfo2Self(playerid,"Obtain Handgun");
    GLOBAL_BACKPACK.ADD_DATA(playerid,handgun,IDs);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end,{itemid=4106})

--[[ NAME : RIFLE M4A1 ]]
INTERACT_DATA_NAME.SET(8,"Buy/Watch Ads"); INTERACT_DATA(8,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Best Weapon To Increase your Survival Rate! Easy to Use");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4116})

--[[ NAME : BARRET ]]
INTERACT_DATA_NAME.SET(9,"Buy/Watch Ads"); INTERACT_DATA(9,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Best Weapon Against Tanky Monster and Horde! Easy to Fight");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4117})

--[[ NAME : RPG ]]
INTERACT_DATA_NAME.SET(10,"Buy/Watch Ads"); INTERACT_DATA(10,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Bring Explosive to The Game and Have Fun! ");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4118})

--[[ NAME : Javelin ]]
INTERACT_DATA_NAME.SET(11,"Buy/Watch Ads"); INTERACT_DATA(11,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Monsters Will Goes Kaboom! So Fun! ");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4120})