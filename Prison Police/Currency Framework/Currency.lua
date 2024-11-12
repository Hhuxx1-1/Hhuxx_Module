GLOBAL_CURRENCY = {} -- Initiate The Currency Global Table to Store Function and Much More! 
-- If you peeking my script Make sure to Subscribe on my Youtube Channel https://youtube.com/hhuxx1
--  Even i don't have really time to create good quality content
--   Becuz i spent must of my time Learning to Code Lua and Making Features for Miniworld
--    And I accept Donation but Rupiah Currency only on https://saweria.com/hhuxx1 
--     i Share my Script on https://hhuxx1-1/github.io/miniworld/
--      But the time i write this Message the Webiste is Not Done Yet 
-- ============================== Thank you for your Respect ==========]]] 
GLOBAL_CURRENCY.DATA = {}

--[[ Adding Method to Create New Currency and Store it  
name is string , id must be number and must index , description is string , type is string ]]
function GLOBAL_CURRENCY:CreateCurrency(name, id , description , type)
    -- initiate new Table with exact Name of  Currency and store its id, description and type
    self.DATA[name] = {name=name,id=id,description=description,type=type}
end 

-- Adding Method to Get Player Currency Data by Name and return it Ammount 
function GLOBAL_CURRENCY:GetCurrency(playerid,name)
    -- String Group 
    local r,datas = Valuegroup:getAllGroupItem(18, "CURRENCY_DATA",playerid)
    if r == 1001 then 
        Player:notifyGameInfo2Self(playerid,"CURRENCY DATA NOT FOUND!")
    end 
    return datas[GLOBAL_CURRENCY.DATA[name].id] or 0 ;
end 

function GLOBAL_CURRENCY:PrettyDisplay(amount)
    amount = tonumber(amount)
    local formatted = ""
    if amount >= 1e12 then
        formatted = string.format("%.1fT", amount / 1e12) -- Display in Trillions
    elseif amount >= 1e9 then
        formatted = string.format("%.1fB", amount / 1e9) -- Display in Billions
    elseif amount >= 1e6 then
        formatted = string.format("%.1fM", amount / 1e6) -- Display in Millions
    elseif amount >= 1e3 then
        formatted = string.format("%.1fk", amount / 1e3) -- Display in Thousands
    else
        formatted = tostring(amount) -- If less than 1000, display the full amount
    end
    return formatted
end

-- Add Methods for Updating UI 
GLOBAL_CURRENCY.UI_DATA={}

-- This is Telling what UI element should be updated when calling UpdateUI for player
function GLOBAL_CURRENCY:AddUI2Update(name,uiid,elementid)
    if GLOBAL_CURRENCY.UI_DATA[name] == nil then 
        -- initiate an Empty table if it is nil
        GLOBAL_CURRENCY.UI_DATA[name] = {}
    end 
    table.insert(GLOBAL_CURRENCY.UI_DATA[name],{uiid=uiid,elementid=elementid});
end

-- Can Be Called  from any UI element to update the UI
function GLOBAL_CURRENCY:UpdateUI(playerid,name)
    if GLOBAL_CURRENCY.UI_DATA[name] == nil then 
        print("FAILED TO UPDATE UI : NO ELEMENTID WERE ADDED")
        return false 
    end 
    local ammountPretty = GLOBAL_CURRENCY:PrettyDisplay(GLOBAL_CURRENCY:GetCurrency(playerid,name))
    for i,a in ipairs(GLOBAL_CURRENCY.UI_DATA[name]) do
        Customui:setText(playerid,a.uiid,a.elementid,ammountPretty)
    end 
end

-- Adding Method to Add Currency to Player Data 
function GLOBAL_CURRENCY:AddCurrency(playerid, name, v_ammount)
    -- Get Player Data 
    local ammount = GLOBAL_CURRENCY:GetCurrency(playerid,name)
    -- handle if ammount is empty 
    if ammount == nil then
        -- Player currency is not set Yet ! STUPID
        ammount = 0 
    end 
    if type(ammount) == "String" then 
        ammount = tonumber(ammount);
    end 
    ammount = ammount + v_ammount;

    local id = GLOBAL_CURRENCY.DATA[name].id;
    -- Add Amount to Player Data
    local r = Valuegroup:setValueNoByName(18, "CURRENCY_DATA", id, tostring(ammount), playerid)
    if r == 0 then 
        -- Automatically Update all UI for player 
        GLOBAL_CURRENCY:UpdateUI(playerid,name)
        return  true;
    else 
        print("ERROR WHEN TRYING TO ADD CURRENCY TO PLAYER DATA")
        return false;
    end 
end

-- Adding Method to Decrease Currency to Player Data 
-- This Allowing a Negatif Currency data
function GLOBAL_CURRENCY:DecreaseCurrency(playerid, name, v_ammount)
    -- Get Player Data 
    local ammount = GLOBAL_CURRENCY:GetCurrency(playerid,name)
    -- handle if ammount is empty 
    if ammount == nil then
        -- Player currency is not set Yet ! STUPID
        ammount = 0 
    end 
    if type(ammount) == "String" then 
        ammount = tonumber(ammount);
    end 
    ammount = ammount - v_ammount;

    local id = GLOBAL_CURRENCY.DATA[name].id;
    -- Add Amount to Player Data
    local r = Valuegroup:setValueNoByName(18, "CURRENCY_DATA", id, tostring(ammount), playerid)
    if r == 0 then 
        -- Automatically Update All UI for player
        GLOBAL_CURRENCY:UpdateUI(playerid,name)
        return true 
    else 
        print("ERROR WHEN TRYING TO DECREASE VALUE ON PLAYER SAVE CURRENCY_DATA")
        return false
    end 
end 

local function tryOfferCoins(ammount, playerid)
    ammount = math.abs(ammount);
    local availableOffer = {
        [1] = {itemid = 4135, stringOffer = "Would you buy 200 coins?"  ,Val =  200},
        [2] = {itemid = 4136, stringOffer = "Would you buy 1000 coins?" ,Val =  1000},
        [3] = {itemid = 4137, stringOffer = "Would you buy 2000 coins?" ,Val =  2000},
        [4] = {itemid = 4138, stringOffer = "Would you buy 4000 coins?" ,Val =  4000},
        [5] = {itemid = 4139, stringOffer = "Would you buy 9000 coins?" ,Val =  9000},
    }

    -- Choose the smallest offer that fulfills the player's need or the closest available
    local selectedOffer = nil

    if ammount >= 9000 then
        -- If the required amount is above or equal to 9000, offer the highest available package
        selectedOffer = availableOffer[#availableOffer]
    else
        -- Otherwise, find the smallest offer that meets or exceeds the player's need
        for offerAmount, offerData in ipairs(availableOffer) do
            if offerData.Val >= ammount then
                selectedOffer = offerData
                break
            end
        end

        -- If no offer is sufficient, default to the largest available option (9000)
        if not selectedOffer then
            selectedOffer = availableOffer[#availableOffer]
        end
    end

    -- Call the dialog API with the selected offer
    if selectedOffer then
        Player:openDevGoodsBuyDialog(playerid, selectedOffer.itemid, selectedOffer.stringOffer)
    else
        print("No suitable offer available.")
    end
end

-- Adding Method to Spend Currency on Player Data Currency
-- This Not Allowing Negatif Currency and return false or true 
function GLOBAL_CURRENCY:SpendCurrency(playerid, name, v_ammount)
    -- Get Player Data 
    local ammount = GLOBAL_CURRENCY:GetCurrency(playerid,name)
    -- handle if ammount is empty 
    if ammount == nil then
        -- Player currency is not set Yet ! STUPID
        ammount = 0 
    end 
    if type(ammount) == "String" then 
        ammount = tonumber(ammount);
    end 
    ammount = ammount - v_ammount;
    if ammount >= 0 then 
    local id = GLOBAL_CURRENCY.DATA[name].id;
    -- Add Amount to Player Data
    local r = Valuegroup:setValueNoByName(18, "CURRENCY_DATA", id, tostring(ammount), playerid)
        if r == 0 then 
            -- Automatically Update All UI for player
            GLOBAL_CURRENCY:UpdateUI(playerid,name)
            return true 
        else 
            print("ERROR WHEN TRYING TO UPDATE VALUE ON PLAYER SAVE CURRENCY_DATA")
            return false
        end 
    else 
        Player:notifyGameInfo2Self(playerid,"Not Enough "..name.." Need "..ammount.." of "..name);
        if name == "Coin" then 
            tryOfferCoins(ammount,playerid);
        end 
        return false;
    end 
end 


-- ============= [[ CREATE CURRENCY HERE ]] ====================

GLOBAL_CURRENCY:CreateCurrency(
    "Coin",1,
    [[Currency That is Used for Ingame Items and Shop, Can Be Obtained for Free or Via Top Up or Ads]],
    "C")

-- Example of Usage 
-- print(GLOBAL_CURRENCY:GetCurrency(1029380338,"Coin"))
-- -- adding Player Coin Currency
-- GLOBAL_CURRENCY:AddCurrency(1029380338,"Coin",10);
-- -- Check Player Coin Currency After Adding 
-- print("After Adding " , GLOBAL_CURRENCY:GetCurrency(1029380338,"Coin"))
-- -- Trying to do a transaction 
-- local function SomeTransactionExample()
--     local pid = 1029380338;
--     local price  = 5;
--     if GLOBAL_CURRENCY:SpendCurrency(pid,"Coin",price) then 
--         print("Successfully Bought The Item");
--     else 
--         print("Failed Bought The Item");
--     end 
-- end
-- -- do Transaction Test
-- SomeTransactionExample()
-- print("After Transaction " , GLOBAL_CURRENCY:GetCurrency(1029380338,"Coin"))
-- SomeTransactionExample()
-- print("After Transaction 2x " , GLOBAL_CURRENCY:GetCurrency(1029380338,"Coin"))
-- SomeTransactionExample()
-- print("After Transaction 3x " , GLOBAL_CURRENCY:GetCurrency(1029380338,"Coin"))