-- This is Where the Tricks happen
--  Load the Whole Data from GLOBAL_SHOP based on What Player do 
-- And Making Sure the NPC is Exist 

-- Since this is for Dynamic Shop 
-- Handle Shop things for NPC / Times to Refresh  the Shop 
local buffid2Refresh = 50000001
local t2s = function(s)
    return 20*s
end
local dynamicNpc_Indices = {};
local stockSelected = {};
local slotSelected = {};
-- register UI.Show for Player when Opening this UI 
local uiid = "7419275534915016946"

local ThisUI = {
    PictureSlot = {
        [1] = uiid.."_"..5,
        [2] = uiid.."_"..23,
        [3] = uiid.."_"..28,
        [4] = uiid.."_"..33,
    },
    ButtonSlot_BG = {
        [1] = uiid.."_"..4,
        [2] = uiid.."_"..22,
        [3] = uiid.."_"..27,
        [4] = uiid.."_"..32,
    },
    ButtonSlot_BT = {
        [1] = uiid.."_"..7,
        [2] = uiid.."_"..24,
        [3] = uiid.."_"..29,
        [4] = uiid.."_"..34,
    },
    PriceSlot_Ico = {
        [1] = uiid.."_"..6,
        [2] = uiid.."_"..25,
        [3] = uiid.."_"..30,
        [4] = uiid.."_"..35,
    },
    PriceSlot_Txt = {
        [1] = uiid.."_"..21,
        [2] = uiid.."_"..26,
        [3] = uiid.."_"..31,
        [4] = uiid.."_"..36,
    },
    DescriptionPic = uiid.."_"..39,
    DescriptionTitle = uiid.."_"..40,
    DescriptionDescCurrency = uiid.."_"..42,
    DescriptionSelector = uiid.."_"..43,
    DescriptionQtyBase = uiid.."_"..46,
    DescriptionBtnBase = uiid.."_"..44,
    DescriptionBtnDesc = uiid.."_"..45,
    DescriptionSlotQty = uiid.."_"..51,
    DescriptionMaxQty = uiid.."_"..52,
    DescriptionUpQty = uiid.."_"..48,
    DescriptionLoQty = uiid.."_"..47,
    DescriptionConfirmBuy = uiid.."_"..44
}

function getRandomUniqueIndices(tbl, numIndices)
    local indices = {}
    local usedIndices = {}

    -- Ensure we don't request more indices than available in the table
    if numIndices > #tbl then
        print("Requested number of indices exceeds the size of the table")
        return tbl
    end

    while #indices < numIndices do
        local randomIndex = math.random(1, #tbl)

        -- Check if this index is already used
        if not usedIndices[randomIndex] then
            table.insert(indices, randomIndex)
            usedIndices[randomIndex] = true
        end
    end

    return indices
end

local  function initSelector(playerid)
-- load default picture 
    local descContent = [[Choose an Item

⬅]];
    local descPic = [[10317]];
    local descPicColor = 0xf1ca1f;
    -- set Desc Content 
    Customui:setText(playerid,uiid,ThisUI.DescriptionSelector,descContent);
    Customui:setFontSize(playerid,uiid,ThisUI.DescriptionSelector,38);
    Customui:setText(playerid,uiid,ThisUI.DescriptionTitle,[[]]);
    Customui:setTexture(playerid,uiid,ThisUI.DescriptionPic,descPic);
    Customui:setColor(playerid,uiid,ThisUI.DescriptionPic,descPicColor);
    Customui:hideElement(playerid,uiid,ThisUI.DescriptionBtnBase);
    Customui:hideElement(playerid,uiid,ThisUI.DescriptionQtyBase);
end 


local function loadIntoSlot(i,data,playerid)
    -- Setting Icon Of Picture 
    Customui:setTexture(playerid,uiid,ThisUI.PictureSlot[i],data.picture)
    Customui:setText(playerid,uiid,ThisUI.PriceSlot_Txt[i],data.price)
    Customui:setTexture(playerid,uiid,ThisUI.PriceSlot_Ico[i],GLOBAL_SHOP.CURRENCY_ICON[data.itemCurrencyType])
end 

local function LoadItemShoplist(itemShop,shopid,npc,playerid)
    -- stock is stored on shoplist and to Modify it GLOBAL_SHOP.ShopLists[shopid][i].stock
    -- Get 4 random Indices 
    -- Add or Condition when it has no Buff 
    if dynamicNpc_Indices[npc] == nil then 
        dynamicNpc_Indices[npc] = getRandomUniqueIndices(itemShop, 4);
        -- add Buff at this step
    end 
    -- only load 4 items from randomIndices 
    -- print(dynamicNpc_Indices)
    for i,a  in ipairs(dynamicNpc_Indices[npc]) do
        local iex = a ;
        -- print(itemShop[iex]);
        -- stock = 20,
        -- desc = [[Can be made into Corolla or Advanced Food, or crafted
        -- into Campanula Seed with the Incomplete Crafting Table. it in
        -- hand can guide the Scarecrow to follow you.]],
        -- name = [[Campanula]],
        -- picture = 1000300,
        -- price = 4,
        -- discount = 0,
        -- itemid = 300,
        -- itemCurrencyType = [[Coin]]
        loadIntoSlot(i,itemShop[iex],playerid)
    end 
end 

local function getShopList(npc)
    local NPC_Data = GLOBAL_SHOP.NPC_DATA[tostring(npc)];
    -- print(NPC_Data);
    -- shopid , typeShop = {Value , UI} , discount 
    local Shoplist = GLOBAL_SHOP.ShopLists[NPC_Data.shopid];
    -- print(Shoplist);
    -- A list with indexed key with value of a table contain key id and stock 
    local ItemShop = GLOBAL_SHOP:LoadShopList(Shoplist);
    for i ,a in ipairs(Shoplist) do 
        -- insert stock to ItemShop 
        ItemShop[i].stock = a.stock;
    end 
    return  ItemShop;

end 

local function LoadDesc(i,playerid)
    local npc = GLOBAL_SHOP.NPCs_Player[tostring(playerid)];
    local iex = dynamicNpc_Indices[npc][i]
    local ItemShop = getShopList(npc)

    if stockSelected[playerid] == nil or slotSelected[playerid] ~= i then 
        if ItemShop[iex].stock  > 0 then 
            stockSelected[playerid] = 1;
        else 
            stockSelected[playerid] = 0;
        end 
    end 

    -- set Slot Selected 
    slotSelected[playerid] = i ;
    --print(ItemShop[iex])
    -- Set Description of Item 
    Customui:setText(playerid,uiid,ThisUI.DescriptionSelector,ItemShop[iex].desc);
    -- Qty Selected 
    Customui:setText(playerid,uiid,ThisUI.DescriptionSlotQty,stockSelected[playerid]);
    -- Font Size for Description 
    Customui:setFontSize(playerid,uiid,ThisUI.DescriptionSelector,19);
    -- Title name of Item
    Customui:setText(playerid,uiid,ThisUI.DescriptionTitle,ItemShop[iex].name);
    -- Picture of Item 
    Customui:setTexture(playerid,uiid,ThisUI.DescriptionPic,ItemShop[iex].picture);
    -- Color of Descrtiption Pic 
    Customui:setColor(playerid,uiid,ThisUI.DescriptionPic,0xffffff);
    -- Base Btn to Buy showen and QTY Base showen 
    Customui:showElement(playerid,uiid,ThisUI.DescriptionBtnBase);
    Customui:showElement(playerid,uiid,ThisUI.DescriptionQtyBase);
    -- Set the Btn Buy Description 
    Customui:setText(playerid,uiid,ThisUI.DescriptionBtnDesc,"Buy "..stockSelected[playerid].."x For ");
    Customui:setText(playerid,uiid,ThisUI.DescriptionDescCurrency,GLOBAL_CURRENCY:PrettyDisplay(ItemShop[iex].price * stockSelected[playerid]));
    -- Show the Maximum Stock can Be bought 
    Customui:setText(playerid,uiid,ThisUI.DescriptionMaxQty,"There is "..ItemShop[iex].stock.." Stock Left")
end 

local function changeStockSelected(playerid,s)
    local i = slotSelected[playerid];
    local npc = GLOBAL_SHOP.NPCs_Player[tostring(playerid)];
    local iex = dynamicNpc_Indices[npc][i]
    local ItemShop = getShopList(npc)

    local afterStockSelected = stockSelected[playerid] + s ;

    if  afterStockSelected < 1 then 
        Player:notifyGameInfo2Self(playerid,"Cannot Select Less than 0 Stock");
        return false;
    end 

    if afterStockSelected >  ItemShop[iex].stock then 
        Player:notifyGameInfo2Self(playerid,"Cannot Select More than Stock Available");
        return false;
    end 

    stockSelected[playerid] = stockSelected[playerid] + s;
    LoadDesc(i,playerid);
    return true ;
end

local function LoadShopDataIntoUI(playerid,npc)
    local ItemShop = getShopList(npc)
    local NPC_Data = GLOBAL_SHOP.NPC_DATA[tostring(npc)];
    -- print(ItemShop);
    -- Output itemid, price , picture , desc , name , discount , itemCurrencyType 
    LoadItemShoplist(ItemShop,NPC_Data.shopid,npc,playerid)
end

local function HandleThisUI(playerid)
    -- Get What is NPCs Player now 
    -- playerid is already string here 
    local npc = GLOBAL_SHOP.NPCs_Player[playerid]
    if npc then
    LoadShopDataIntoUI(playerid,npc)     
    else 
        Player:notifyGameInfo2Self(playerid,"Invalid Action");
        Player:hideUIView(tonumber(playerid),uiid);
    end 
end

local function BuyCurrentSelectedItem(playerid)
    local npc = GLOBAL_SHOP.NPCs_Player[tostring(playerid)];
    local ItemShop = getShopList(npc);
    local i = slotSelected[playerid];
    local iex = dynamicNpc_Indices[npc][i];
    print("Action buying an Item with Data : ",ItemShop[iex])
    local  itemid = ItemShop[iex].itemid;
    local stock2Buy = stockSelected[playerid];
    -- Use Framework GLOBAL_CURRENCY
    local currencyType = ItemShop[iex].itemCurrencyType;
    local price = ItemShop[iex].price * stock2Buy ;
    local discount = ItemShop[iex].discount;
    -- Check the Stock Availablilty
    if stock2Buy <= ItemShop[iex].stock then
        if GLOBAL_CURRENCY:SpendCurrency(playerid,currencyType,price) then 
        -- add ItemID to player 
        local  r = Player:gainItems(playerid, itemid,stock2Buy,1)
        if r == 0 then 
            -- decrease the Stock 
            -- Modify The Full root of this not reference
            GLOBAL_SHOP.ShopLists[GLOBAL_SHOP.NPC_DATA[tostring(npc)].shopid][iex].stock = ItemShop[iex].stock - stock2Buy ;
            -- updateUI 
            Player:notifyGameInfo2Self(playerid,"Bought "..ItemShop[iex].name.." x"..stock2Buy);
            Player:notifyGameInfo2Self(playerid,"Check Bought Item on Backpack");
            LoadDesc(i,playerid);
        end 
        end 
    else
        stockSelected[playerid] = 0; 
        LoadDesc(i,playerid);
        Player:notifyGameInfo2Self(playerid,"Out of Stock")
    end 
end

ScriptSupportEvent:registerEvent([[UI.Show]],function(e)
    local playerid = e.eventobjid;
    local UIid = e.CustomUI;
    
    if UIid == uiid then 
        HIDE_GIMMICK_BTN(playerid) ;
        initSelector(playerid);
        HandleThisUI(tostring(playerid));
    end 

end)

ScriptSupportEvent:registerEvent([[UI.Button.Click]],function(e)
    local playerid,uiids, element = e.eventobjid,e.CustomUI,e.uielement;
    -- print(e);
    if uiids == uiid then
        if element == ThisUI.DescriptionConfirmBuy then 
            -- Buy the Item
            BuyCurrentSelectedItem(playerid);
        elseif element == ThisUI.DescriptionUpQty then 
            changeStockSelected(playerid,1);
        elseif element == ThisUI.DescriptionLoQty then 
            changeStockSelected(playerid,-1);
        else 
            for i , a in ipairs(ThisUI.ButtonSlot_BG) do 
                if a == element then LoadDesc(i,playerid) end 
            end 
            for i , a in ipairs(ThisUI.ButtonSlot_BT) do 
                if a == element then LoadDesc(i,playerid) end 
            end 
        end 
    end 
end)

ScriptSupportEvent:registerEvent([[UI.Hide]],function(e)
    local playerid = e.eventobjid;
    local UIid = e.CustomUI;
    if UIid == uiid then 
        -- set both its NPC and Playerid on GLOBAL_SHOP.NPCs_Player to nil 
        -- both keys are string 
        -- obtain who is playerid's npc before clearing it 
        local npc = GLOBAL_SHOP.NPCs_Player[tostring(playerid)];
        -- set Both Keys to Nil 
        GLOBAL_SHOP.NPCs_Player[tostring(playerid)] = nil;
        GLOBAL_SHOP.NPCs_Player[tostring(npc)] = nil;
        stockSelected[playerid] = nil;
        slotSelected[playerid] = nil ;
        SHOW_GIMMICK_BTN(playerid) ;
    end 
end)