local UI = {
    ui                  = "7437039996392642802",
    title               = "7" ,
    iconimage         = "3" ,
    quantity            = "15",
    inputQuantity       = "22",
    currencyIcon        = "5" ,
    currencyText        = "6" ,
    decreaseQuantityBtn = "11",
    increaseQuantityBtn = "13",
    quantityHave        = "16",
    confirmButton       = "8",
    closeBtn         = "17"
}

function EncodeCustomData(tableData)
    local encodedString = ""
    for key, value in pairs(tableData) do
        -- Append each key-value pair in the format "key=value;"
        encodedString = encodedString .. tostring(key) .. "=" .. tostring(value) .. ";"
    end
    return encodedString
end

function DecodeCustomData(encodedString)
    local decodedTable = {}
    -- Split the string by ';' to get individual key-value pairs
    for pair in string.gmatch(encodedString, "([^;]+)") do
        -- Split each pair by '=' to separate the key and value
        local key, value = pair:match("([^=]+)=([^=]+)")
        if key and value then
            -- Convert numeric values back to numbers, if applicable
            if tonumber(value) then
                value = tonumber(value)
            end
            decodedTable[key] = value
        end
    end
    return decodedTable
end

REDEEM_ITEM = {} -- Global Event Holder ;

local setText = function(text,playerid,d)
    local uiid      = d[1];
    local elementid = d[1].."_"..d[2];
    Customui:setText(playerid,uiid,elementid,text)
end 

local setImage = function(url,playerid,d)
    local uiid      = d[1];
    local elementid = d[1].."_"..d[2];
    Customui:setTexture(playerid,uiid,elementid,url)
end

REDEEM_ITEM.DATA = {};

local function UpdateFromData(playerid,data)
    local itemid = data.itemid;
    local quantity = data.quantity;
    local pre = "Do You Want to Sell "
    if T_Text then 
        pre = T_Text(playerid,pre);
    end;
    local r,itemName  = Item:getItemName(itemid);
    if r == 0 then 
        local title = pre..itemName.."?"
        setText(title,playerid,{UI.ui,UI.title});
    end;
    setText(quantity,playerid,{UI.ui,UI.quantity});
    -- set Item Icon 
    local r,iconitemid = Customui:getItemIcon(itemid)
    if r == 0 then 
        setImage(iconitemid,playerid,{UI.ui,UI.iconimage});
    end 


    -- Get Price Item 
    local priceInTotal = data.currencyAmount * data.quantity;
    setText(priceInTotal..data.currencyText,playerid,{UI.ui,UI.currencyText});
    -- Set Quantity
    setText(quantity,playerid,{UI.ui,UI.quantity});
    -- Show howmany thing player has
    local maxCap = MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(playerid,itemid);
    local pre = "You Have"
    -- check if translation function accessible
    if T_Text then
        pre = T_Text(playerid,pre);
    end 
    setText(pre.." "..maxCap,playerid,{UI.ui,UI.quantityHave});
end

function REDEEM_ITEM:OPEN(playerid,itemid,currencyAmount)
    REDEEM_ITEM.DATA[playerid] = {
        itemid = itemid,
        quantity = 1,
        currencyText = " Coins",
        currencyAmount = currencyAmount,
    };
    Player:openUIView(playerid,UI.ui);
end

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid = e.eventobjid;
    local CustomUI = e.CustomUI;
    local uielement = e.uielement;

    if CustomUI == UI.ui then 
        if uielement == UI.ui.."_"..UI.increaseQuantityBtn then 
            -- increase QTY by max Cap item Owned 
            local itemid = REDEEM_ITEM.DATA[playerid].itemid;
            local maxCap = MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(playerid,itemid);
            local quantity = REDEEM_ITEM.DATA[playerid].quantity;
            if quantity < maxCap then
                REDEEM_ITEM.DATA[playerid].quantity = quantity + 1;
                UpdateFromData(playerid,REDEEM_ITEM.DATA[playerid]);
            end
        end 

        if uielement == UI.ui.."_"..UI.decreaseQuantityBtn then
            -- decrease QTY by 1
            local quantity = REDEEM_ITEM.DATA[playerid].quantity;
            if quantity > 1 then
                REDEEM_ITEM.DATA[playerid].quantity = quantity - 1;
                UpdateFromData(playerid,REDEEM_ITEM.DATA[playerid]);
            end 
        end 
        -- confirm button 
        if uielement == UI.ui.."_"..UI.confirmButton then
            --redeem item 
            local itemid = REDEEM_ITEM.DATA[playerid].itemid;
            local quantity = REDEEM_ITEM.DATA[playerid].quantity;
            local currencyAmount = REDEEM_ITEM.DATA[playerid].currencyAmount;
            -- check how many item owned and atleast not supprass it 
            local itemOwned = MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(playerid,itemid);
            if itemOwned >= quantity then
                -- it sells it item
                if Player:removeBackpackItem(playerid, itemid, quantity) == 0 then 
                    local total = quantity*currencyAmount;
                    GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",total)
                    REDEEM_ITEM.DATA[playerid].quantity = 1;
                    UpdateFromData(playerid,REDEEM_ITEM.DATA[playerid]);
                    Game:dispatchEvent("REDEEM_ITEM",{eventobjid=playerid,itemid = itemid,itemnum = quantity,customdata = EncodeCustomData({price = currencyAmount,total = total,quantity = quantity})});
                end 
            end 
        end 
        -- close button 
        if uielement == UI.ui.."_"..UI.closeBtn then
            Player:hideUIView(playerid,UI.ui);
        end 
    end 

end);

ScriptSupportEvent:registerEvent("UI.Hide",function(e)
    local playerid = e.eventobjid;
    local CustomUI = e.CustomUI;

    if CustomUI == UI.ui then 
        REDEEM_ITEM.DATA[playerid] = nil;
    end 

end)

ScriptSupportEvent:registerEvent("UI.Show",function(e)
    local playerid = e.eventobjid;
    local CustomUI = e.CustomUI;

    if CustomUI == UI.ui then 
        UpdateFromData(playerid,REDEEM_ITEM.DATA[playerid]);
    end 

end)