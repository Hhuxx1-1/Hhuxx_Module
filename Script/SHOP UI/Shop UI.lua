-- version: 2022-04-20
-- mini: 1029380338
-- uipacket: 7229175948772055282
local currencyNameStoredOnTrigger = "Currency";
-- CONFIGURATION 
local uiid = "7229175948772055282"
local dat = {};local sel = {};local QQ = {};local Con = {};local Sts = {};local Hmoney = 4097
local function tr (playerid,id) return "NEW_METHOD" end;
local function ld (ID) return uiid.."_"..tostring(ID) end
local Spart = {"Base","BaseIcon","IconID","Name","Btn","CostIcod","Cost"};local nm = 0;
for i=1,6 do local n = "S"..i;local j = i ; for i,a in ipairs(Spart) do local m = n..a ; nm=nm+1 ; dat[m] = ld(nm) end ; end
dat["DefaultWindow"] = ld(43) ; dat["BaseName"] = ld(51) ; dat["DialogBase"] = ld(55) ; dat["CharICon"] = ld(56) ; dat["DialogText"] = ld(57) ;
dat["Page"] = ld(58) ; dat["PrevP"] = ld(59) ; dat["Next"] = ld(60) ; dat["ConfirmWindow"] = ld(61) ; dat["ConfirmedItemIconBase"] = ld(62) ; 
dat["ConfirmedItem"] = ld(63) ; dat["ConfirmedItemName"] = ld(64) ; dat["ItemDesc"] = ld(65) ; dat["BaseCount"] = ld(66)
dat["QuantityBase"] = ld(67) ; dat["QText"] = ld(68) ; dat["LowerQ"] = ld(69) ; dat["IncreaseQ"] = ld(70) ; dat["MaxQ"] = ld(71)
dat["FixedQT"] = ld(72) ; dat["ConfirmBuy"] = ld(73) ; dat["MoneyIcon"] = ld(74) ; dat["TotalCost"] = ld(75) ; dat["Switch"] = ld(76)
dat["SwitchIcon"] = ld(77) ; dat["SwitchText"] = ld(78) ;dat["plusten"] = ld(79); dat["minten"] = ld(81); dat["unconfirm"] = ld(83);

local function GetCurrency(p) local result,Currency = VarLib2:getPlayerVarByName(p,3,currencyNameStoredOnTrigger) ; return(Currency) end
local function setCurrency(p,Cur) VarLib2:setPlayerVarByName(p,3,currencyNameStoredOnTrigger,Cur) ; end
local function GetTarget(p) local NPC = SHOP.PLAYER_GET(p) return NPC,SHOP.ACCESS_ICON(NPC),SHOP.ACCESS_NAME(NPC),SHOP.ACCESS_DIALOG(NPC),SHOP.ACCESS_DATA(NPC) end
local function getItemData(i,ShopData) 
    local itemid = ShopData[i].id;            local price = ShopData[i].price;                  local stock = ShopData[i].stock;
    return itemid,price,stock 
end 
local function getStore(p) 
    local npcstore = SHOP.PLAYER.GET(p);
    return SHOP.ACCESS_DATA(npcstore)
end 
local function updateSlot(p,i,itemid,stock,price)
		local result,name=Item:getItemName(itemid);		local result,iconid = Customui:getItemIcon(itemid) ;		Customui:showElement(p,uiid,dat["S"..i.."Base"]) ;		Customui:setText(p,uiid,dat["S"..i.."Name"],name.." \n "..stock.." Items Left");		Customui:setTexture(p, uiid, dat["S"..i.."IconID"], iconid);		Customui:setText(p, uiid, dat["S"..i.."Cost"], "$"..price);
        if(stock<1)then 
            Customui:hideElement(p,uiid,dat["S"..i.."Btn"]);
            else 
            Customui:showElement(p,uiid,dat["S"..i.."Btn"]);
        end 
end 
local function hideSlot(p,slotid)
    Customui:hideElement(p,uiid,dat["S"..slotid.."Base"]) 
end 
local function update(ShopData,p) 
    local maks = math.ceil(#ShopData/6) ;
    local a = (sel[p]-1)*6;
    for i=1,6 do  
        if(ShopData[i+a]~=nil)then 
            local itemid,price,stock = getItemData(i+a,ShopData); 
            updateSlot(p,i,itemid,stock,price);
        else 
            hideSlot(p,i)
        end 
    end 
    Customui:setText(p,uiid,dat["Page"],"["..sel[p].."/"..maks.."]");
end 

local function resetStat(p,icd,name) 
    Customui:hideElement(p,uiid,dat["ConfirmWindow"]) --Hide Dialog Window 
    Customui:showElement(p,uiid,dat["DefaultWindow"])
    Customui:setTexture(p, uiid, dat["CharICon"], icd)
    Customui:setText(p,uiid,dat["BaseName"],name)
end 

local function loadDialog(p,txtx)
    for i=1,string.len(txtx) do
        threadpool:wait(0.02)
        Customui:setText(p,uiid,dat["DialogText"],string.sub(txtx,1,i))
    end 
end 

local function loadItemDesc(p,txtx)
    for i=1,string.len(txtx) do
        threadpool:wait(0.02)
        Customui:setText(p,uiid,dat["ItemDesc"],string.sub(txtx,1,i))
    end 
end 

local function inits(p)
    local NPC,icd,name,dialog,ShopData = GetTarget(p); QQ[p]=1; 
    resetStat(p,icd,name) ; update(ShopData,p); loadDialog(p,dialog) ;
end 

local function Show (e) --Show Function
    local playerid = e.eventobjid; sel[playerid] = 1;  Con[playerid] = 1; Sts[playerid] = 1; inits(playerid)
end

local function setTotal(p,total)
    Customui:setText(p,uiid,dat["TotalCost"],"$"..total)
end 

local function unconfirm(p) 
    Customui:hideElement(p,uiid,dat["ConfirmWindow"]); 
end 

local function Confirm (p,s)
Con[p] = s ;local NPC,icd,name,dialog,ShopData = GetTarget(p);
-- if Sts[p] == 1 then --Buy Section
local maks = math.ceil(#ShopData/6) ;       local a = (sel[p]-1)*6 ;
local itemid,price,stock = getItemData(s+a,ShopData);
local result,name=Item:getItemName(itemid); local result,iconid = Customui:getItemIcon(itemid)

-- Switch Window 
Customui:showElement(p,uiid,dat["ConfirmWindow"]);          Customui:showElement(p,uiid,dat["DefaultWindow"]);
Customui:setTexture(p, uiid, dat["ConfirmedItem"],iconid);
Customui:setText(p,uiid,dat["ConfirmedItemName"],name.." \n "..stock.." Items Left")

-- Display Selection Quantity into Player ;
Customui:setText(p,uiid,dat["QText"],QQ[p]);local total = tonumber(QQ[p])*tonumber(price);

-- Display Total Cost of Prudct Multiplied By Quantity Of Selection Of Player ;
    setTotal(p,total)
    
-- Set Item Descritpion
local r,desc = Item:getItemDesc(itemid)
loadItemDesc(p,desc)
end

local function Qcontrol(playerid,ElementID,PlayerMoney,Price,itemnum)
    if ElementID == dat["LowerQ"] and QQ[playerid] > 1 and QQ[playerid] <= itemnum then QQ[playerid] = QQ[playerid] - 1 
        local total = tonumber(QQ[playerid])*tonumber(Price) ;        Customui:setText(playerid,uiid,dat["QText"],QQ[playerid]);        setTotal(p,total);
    end 
    if ElementID == dat["IncreaseQ"] and QQ[playerid] > 0 and QQ[playerid] < itemnum then QQ[playerid] = QQ[playerid] + 1 
        local total = tonumber(QQ[playerid])*tonumber(Price) ;        Customui:setText(playerid,uiid,dat["QText"],QQ[playerid]);       setTotal(p,total);
    end 
    if ElementID == dat["MaxQ"] then 
        local maxAfford = math.floor(PlayerMoney/Price); if maxAfford >= itemnum then QQ[playerid] = itemnum ; else QQ[playerid] = maxAfford; end Customui:setText(playerid,uiid,dat["QText"],QQ[playerid]) ;local total = tonumber(QQ[playerid])*tonumber(Price) ; setTotal(p,total); 
    end 
    if ElementID == dat["minten"] and QQ[playerid] > 10 and QQ[playerid]-10 <= itemnum then QQ[playerid] = QQ[playerid] - 10 
        local total = tonumber(QQ[playerid])*tonumber(Price) ;        Customui:setText(playerid,uiid,dat["QText"],QQ[playerid]);        setTotal(p,total);
    end 
    if ElementID == dat["plusten"] and QQ[playerid] > 0 and QQ[playerid]+10 <= itemnum then QQ[playerid] = QQ[playerid] + 10
        local total = tonumber(QQ[playerid])*tonumber(Price) ;        Customui:setText(playerid,uiid,dat["QText"],QQ[playerid]);       setTotal(p,total);
    end 
end 

local function doBuy(playerid,PlayerMoney,itemid,itemnum,Price,key,NPC)
local afterbuy = itemnum - QQ[playerid];
local total = Price*QQ[playerid];

if PlayerMoney >= total then
Player:gainItems(playerid,itemid,QQ[playerid],1); Player:notifyGameInfo2Self(playerid,"Successfully Bought ") ;
SHOP.UPDATE_ITEMKEY_STOCK(NPC,key,afterbuy);
setCurrency(playerid,PlayerMoney-total) ; sel[playerid] = 1; Con[playerid] = 1; inits(playerid)
else 
Player:notifyGameInfo2Self(playerid,"Not Enough Money ")
end

end 

local function Click(e)
    local playerid,ElementID = e.eventobjid,e.uielement
    local NPC,icd,name,dialog,ShopData = GetTarget(playerid);  local maks = math.ceil(#ShopData/6); local a = (sel[playerid]-1)*6 ;
    -- Click on Item Slot will Open Confirmation Window :  
    for i=1,6 do if ElementID == dat["S"..i.."Btn"] then Confirm(playerid,i) end end
    local itemid,price,stock = getItemData(Con[playerid]+a,ShopData);
    local PlayerMoney = GetCurrency(playerid); Qcontrol(playerid,ElementID,PlayerMoney,price,stock); --check Q Control 
    -- Next Page Things
    if ElementID == dat["PrevP"] and sel[playerid] > 1 and sel[playerid] < maks+1 then sel[playerid] = sel[playerid] - 1;    update(ShopData,playerid) ; end 
    if ElementID == dat["Next"] and sel[playerid] > 0 and sel[playerid] < maks then sel[playerid] = sel[playerid] + 1;    update(ShopData,playerid);    end 

    if ElementID == dat["ConfirmBuy"] then doBuy(playerid,PlayerMoney,itemid,stock,price,Con[playerid]+a,NPC);  end
    if ElementID == dat["unconfirm"] then unconfirm(playerid) end 
end 

ScriptSupportEvent:registerEvent([=[UI.Button.Click]=],Click)
ScriptSupportEvent:registerEvent([=[UI.Show]=],Show)
ScriptSupportEvent:registerEvent([=[UI.Hide]=],Hide)
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=],PlayerEnter)
