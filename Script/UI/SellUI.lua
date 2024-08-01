-- version: 2022-04-20
-- mini: 1029380338
local uiid = "7378748279344535794";

local selected = {};

local slot = {}
for i = 60, 2, -2 do
    table.insert(slot, uiid .. "_" .. i)
end

local pic = {}
for i = 61, 3, -2 do
    table.insert(pic, uiid .. "_" .. i)
end

local sid = {} 
for i = 73,87,2 do 
    table.insert(sid,uiid.."_"..i);
end 

local sidpic = {} 
for i = 74,88,2 do 
    table.insert(sidpic,uiid.."_"..i);
end 

local popup = "7378748279344535794_64";

function updateUI_new(playerid,closes)
    for i=1,30 do 
        local itemicon = [[8_1029380338_1711289202]];
        local r,itemid = Backpack:getGridItemID(playerid, i-1);
        if itemid ~= 0 then 
            local r_,item = Customui:getItemIcon(itemid);
            itemicon = item;
        end 
        Customui:setTexture(playerid,uiid,pic[i],itemicon);
    end 
    if closes then 
    Customui:hideElement(playerid, uiid, popup);
    end 
    for i=1000,1007 do 
        local itemicon = [[8_1029380338_1711289202]];
        local r,itemid = Backpack:getGridItemID(playerid, i);
        if itemid ~= 0 then 
            local r_,item = Customui:getItemIcon(itemid);
            itemicon = item;
        end 
        Customui:setTexture(playerid,uiid,sidpic[i-999],itemicon);
    end 
end 

ScriptSupportEvent:registerEvent("UI.Show", function(e) 
    local playerid = e.eventobjid;
    updateUI_new(playerid,true);
end)

function getitsKey(v) 
    for i,a in ipairs(slot) do if a == v then
            return i-1;
    end end
    for i,a in ipairs(sid) do if a == v then 
        return i+999 
    end end
end 

local function getItemNum(playerid,itemid)
        local r,number1 = Backpack:getItemNumByBackpackBar(playerid, 1, itemid);
        local r,number2 = Backpack:getItemNumByBackpackBar(playerid, 2, itemid);
    return number1+number2
end 

local itemname_holder= "7378748279344535794_67";
local itemicon_holder= "7378748279344535794_66";
local itemnum_holder = "7378748279344535794_69";
local itemCost = "7378748279344535794_68";

function setSelected(playerid,key)
    selected[playerid] = key ;
    
    local r,itemid = Backpack:getGridItemID(playerid,key);
    local r,itemname = Item:getItemName(itemid);
    local r_,itemicon = Customui:getItemIcon(itemid);
    local number = getItemNum(playerid,itemid);
    local cost = getItemCost(itemid);
    if(itemid ~= 0 )then 
    Customui:showElement(playerid, uiid, popup);
    Customui:setText(playerid,uiid,itemname_holder,itemname)
    Customui:setTexture(playerid,uiid,itemicon_holder,itemicon);
    Customui:setText(playerid,uiid,itemnum_holder," You Have : "..number.." Total Items");
    Customui:setText(playerid,uiid,itemCost," This Item Can Be Sell for : $"..cost);
    else 
        updateUI_new(playerid,true);
        Player:notifyGameInfo2Self(playerid," Item Cannot be Empty ");
    end 
end 

local buttonSell = "7378748279344535794_70";

function getCurrency(playerid)
    local r,v = VarLib2:getPlayerVarByName(playerid, 3, "Currency");
    return v;
end 

function addCurrency(playerid,v)
    local current = getCurrency(playerid);
    local ret = current + v;
    local r = VarLib2:setPlayerVarByName(playerid, 3, "Currency",ret);
end 

function sellSelected(playerid)
    local key =  selected[playerid];
    local r,itemid = Backpack:getGridItemID(playerid,key);
    local number = getItemNum(playerid,itemid);
    if number > 0 then 
    local cost = getItemCost(itemid);
    Player:removeBackpackItem(playerid, itemid, 1);
    addCurrency(playerid,cost);
    Player:notifyGameInfo2Self(playerid,"#G +$"..cost);
    else 
        Player:notifyGameInfo2Self(playerid," Not Enough Items ");
    end 
    setSelected(playerid,key); 
    updateUI_new(playerid,false);
end 

ScriptSupportEvent:registerEvent("UI.Button.Click", function(e) 
    local uiids = e.CustomUI;
    local playerid = e.eventobjid;
    local uie = e.uielement;
    if uiid == uiids then 
    local key = getitsKey(uie);
    --Chat:sendSystemMsg("Key : "..key);
        if key ~= nil then 
            setSelected(playerid,key);    
        else 
            if uie == buttonSell then 
                sellSelected(playerid);
            end 
        end 
    end 
end)