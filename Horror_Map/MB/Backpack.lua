-- When Player Leave all Items Drops
-- Items Drop as Actor Entity
GLOBAL_BACKPACK = {} --[[ Store Player Backpack Data ]]
GLOBAL_BACKPACK.DATA = {};
GLOBAL_BACKPACK.Settings = {
    maxCapacity = 5,
    -- This is Corresponding UI Holder for Picture and Buttons 
    -- Length Must Equals to maxCapacity
    UI_HOLDER_EMPTY_ICON = [[8_1029380338_1711289202]],
    UI_HOLDER = {
        [1] = {
            pict = "7405783316061427954_18" , btn = "7405783316061427954_4"
        },
        [2] = {
            pict = "7405783316061427954_19" , btn = "7405783316061427954_5"
        },
        [3] = {
            pict = "7405783316061427954_20" , btn = "7405783316061427954_6"
        },
        [4] = {
            pict = "7405783316061427954_21" , btn = "7405783316061427954_7"
        },
        [5] = {
            pict = "7405783316061427954_22" , btn = "7405783316061427954_8"
        },
        uiid = "7405783316061427954",
        activeInventory = "7405783316061427954_23";
    }
}

ITEM_BACKPACK = {}
ITEM_BACKPACK.Data = {}
ITEM_BACKPACK.New = function(itemid,func)
    -- store execute able function 
        ITEM_BACKPACK.Data[itemid] = func
end
ITEM_BACKPACK.Run = function(itemid, playerid)
    -- Retrieve the stored function from the table
    local func = ITEM_BACKPACK.Data[itemid]
    
    -- Check if the retrieved item is a function before executing it
    if type(func) == "function" then
        -- Use pcall to execute the function safely and catch any errors
        local success, err = pcall(func, playerid, itemid)
        if not success then
            print("Error running function for itemid [" .. itemid .. "] with playerid [" .. playerid .. "]:", err)
        end
    else
        print("No valid function found for itemid [" .. itemid .. "]")
    end
end


-- When Player Leave all Items Drops
-- This function only make the Entity Drop.
local function makeDropItem(playerid,itemid,actorid)
    local r,x,y,z = Actor:getPos(playerid);
    -- To Do Later 
end

GLOBAL_BACKPACK.DROP_ITEM_By_LEAVE = function(playerid,x,y,z)
    if not GLOBAL_BACKPACK.DATA[playerid] then
        return false -- No items in the player's backpack yet
    end
    -- store the player data before removing it from the table to be used as drop Item.
    local playerData = GLOBAL_BACKPACK.DATA[playerid]
    for _ , item in ipairs(playerData) do 
        -- create actorid for each player Data 
        local r , obj = World:spawnCreature(x,y,z,item.actorid,1) 
    end 
    -- clear  the player data from the table
    GLOBAL_BACKPACK.DATA[playerid] = nil;
    return true;  -- Item dropped successfully
end

GLOBAL_BACKPACK.IsItemInBackpack = function(playerid, itemid)
    if not GLOBAL_BACKPACK.DATA[playerid] then
        return false -- No items in the player's backpack yet
    end

    for _, item in ipairs(GLOBAL_BACKPACK.DATA[playerid]) do
        if item.itemid == itemid then
            return true -- Item found in the backpack
        end
    end

    return false -- Item not found in the backpack
end

GLOBAL_BACKPACK.RemoveItemFromBackpack = function(playerid, itemid)
    if not GLOBAL_BACKPACK.DATA[playerid] then
        return false -- No items in the player's backpack
    end

    for index, item in ipairs(GLOBAL_BACKPACK.DATA[playerid]) do
        if item.itemid == itemid then
            table.remove(GLOBAL_BACKPACK.DATA[playerid], index)
            return true -- Item successfully removed
        end
    end

    return false -- Item not found in the backpack
end


-- Since The Function is Becoming One for the Interaction UI, Store the actorid into data for Drop.
GLOBAL_BACKPACK.ADD_DATA = function(playerid,itemid,actorid,pictureid)

    if GLOBAL_BACKPACK.IsItemInBackpack(playerid, itemid) then
        Player:notifyGameInfo2Self(playerid, "Item already exists in inventory!")
        return -- Exit the function as the item is already in the backpack
    end

    if(pictureid == nil )then 
        -- Obtain Picture id from itemid
        local r , picid =Customui:getItemIcon(itemid)
        if r == 0 then pictureid = picid end 
    end 
    GLOBAL_BACKPACK.DATA[playerid] = GLOBAL_BACKPACK.DATA[playerid] or {};
    -- Check the Length if less than maxCapacity
    if #GLOBAL_BACKPACK.DATA[playerid] < GLOBAL_BACKPACK.Settings.maxCapacity then
    table.insert(GLOBAL_BACKPACK.DATA[playerid],{itemid=itemid,actorid=actorid,pictureid = pictureid});
    else
        -- If the Length is Max, Remove the First Item
        -- and Drop it 
        Player:notifyGameInfo2Self(playerid,"Inventory Full!");
    end 
    -- return Succeed 
end

local function UpdateSlotDisplay(playerid,slot,display)
    -- Update the Slot Display
    local displayID = GLOBAL_BACKPACK.Settings.UI_HOLDER[slot]
    Customui:setTexture(playerid,
    GLOBAL_BACKPACK.Settings.UI_HOLDER.uiid,
    displayID.pict,display
    );
end

GLOBAL_BACKPACK.UPDATE_FOR_PLAYER = function(playerid)
    local PlayerData = GLOBAL_BACKPACK.DATA[playerid] or {}
    for i = 1 , GLOBAL_BACKPACK.Settings.maxCapacity do 
        if PlayerData[i] ~= nil then
            UpdateSlotDisplay(playerid,i,PlayerData[i].pictureid);
        else 
            UpdateSlotDisplay(playerid,i,GLOBAL_BACKPACK.Settings.UI_HOLDER_EMPTY_ICON);
            -- If the Slot is Empty, Display Empty 
        end 
    end 
end

ScriptSupportEvent:registerEvent("UI.Show",function(e)
    local UIID = e.CustomUI; local playerid = e.eventobjid;
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end)

-- INVENTORY INTERACTION LOGIC
-- function to retrive Data on Specific Slot 
local function GetSlotData(playerid,slot)
    -- Retrieve the Slot Data
    local PlayerData = GLOBAL_BACKPACK.DATA[playerid] or {}
    return PlayerData[slot]
end 

local configUISelector = {
    {x=10,y=13},{x=90,y=13},{x=172,y=13},{x=254,y=13},{x=336,y=13}
}

local function checkInventoryInteraction(playerid,element)
    local a = 0;
    -- check what  button inventory slot does it click ?
    if(type(element)=="string")then 
        for i=1, GLOBAL_BACKPACK.Settings.maxCapacity do 
            if element == GLOBAL_BACKPACK.Settings.UI_HOLDER[i].btn then
                print("index: ",i,"Is Clicked");
                a = i ;
                break;
            end
        end 
    elseif(type(element)=="number")then  
        a = element+1;
    end 

    if ( a ~= 0 ) then 
        Customui:showElement(playerid, GLOBAL_BACKPACK.Settings.UI_HOLDER.uiid, GLOBAL_BACKPACK.Settings.UI_HOLDER.activeInventory)
        Customui:setPosition(playerid, GLOBAL_BACKPACK.Settings.UI_HOLDER.uiid, GLOBAL_BACKPACK.Settings.UI_HOLDER.activeInventory,
        configUISelector[a].x , configUISelector[a].y 
        );

        -- check the data
        local slotdata = GetSlotData(playerid,a);

        if(slotdata)then 
            local actorid , itemid = slotdata.actorid, slotdata.itemid
            -- load action for backpack action when used 
            ITEM_BACKPACK.Run(itemid,playerid);
        else 
            -- Empty Backpack Bar 
            for i = 1000 , 1008 do 
            Backpack:setGridItem(playerid,i,4100,1,nil)
            end 
        end  
    else 
        Customui:hideElement(playerid, GLOBAL_BACKPACK.Settings.UI_HOLDER.uiid, GLOBAL_BACKPACK.Settings.UI_HOLDER.activeInventory)
    end 
end

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local UIID = e.CustomUI; local playerid = e.eventobjid; local element = e.uielement;
    local cd , err = pcall(checkInventoryInteraction,playerid,element);
    threadpool:wait(0.3)
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end)

ScriptSupportEvent:registerEvent("Player.SelectShortcut",function(e)
    local playerid = e.eventobjid;
    local shotcutidx = e.CurEventParam.EventShortCutIdx;
    local cd , err = pcall(checkInventoryInteraction,playerid,shotcutidx);
end) 