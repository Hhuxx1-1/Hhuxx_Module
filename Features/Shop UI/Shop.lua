-- New Shop Feature is Better than Previous One
-- Allowing Same Npc's with Different Id have it's Own store
-- Allowing dynamic store with Discount Item Applied 
-- Allowing Global Data Item Shop to Be Used 
-- [[ If you Somehow Found this , You are a Genius ]]
GLOBAL_SHOP = {} -- Initaite the Global Shop 
-- If you peeking my script Make sure to Subscribe on my Youtube Channel https://youtube.com/hhuxx1
--  Even i don't have really time to create good quality content
--   Becuz i spent must of my time Learning to Code Lua and Making Features for Miniworld
--    And I accept Donation but Rupiah Currency only on https://saweria.com/hhuxx1 
--     i Share my Script on https://hhuxx1-1/github.io/miniworld/
--      But the time i write this Message the Webiste is Not Done Yet 
-- ============================== Thank you for your Respect ==========]]] 
-- Adding Global _ Shop Catalog to Hold Items data 
GLOBAL_SHOP.CATALOG = {}

-- Initiate Currency Icon Here 
GLOBAL_SHOP.CURRENCY_ICON = {
    Coin =  [[8_1029380338_1727255966]]
}
-- Add method to add Item into Catalog 
function GLOBAL_SHOP:AddCatalogItem(itemID, itemName, itemDescription , itemPicture, itemPrice, itemDiscount , itemCurrencyType)
    
    -- item Name must be String can be set to Auto 
    -- item Price must be Number
    -- item Discount must be a Negatif Number if Positif will increase the Price 
    -- item Description must be String and not Too Much can be set to Auto 
    -- item Picture must be a String of Image URL or Local Image Path
    -- item Picture is Optional 

    -- handle AUTO Input for itemName 
    if itemName == "AUTO" then 
        -- Obtain itemname originally using API 
        local r, newItemName = Item:getItemName(itemID)
        if r == 0 then 
            -- only update the itemname when succeed 
            itemName = newItemName;
        else 
            itemName = "ERROR : Failed to Get Auto Name ";
        end 
    end 

    if itemDescription == "AUTO" then 
        -- Obtain itemname originally using API 
        local r, newitemDescription = Item:getItemDesc(itemID)
        if r == 0 then 
            -- only update the item description when succeed 
            itemDescription = newitemDescription
            
            -- Handle @item_ID references and replace with actual item name
            itemDescription = string.gsub(itemDescription, "@item_(%d+)", function(id)
                local r, referencedItemName = Item:getItemName(tonumber(id))
                if r == 0 then
                    return referencedItemName
                else
                    return "Unknown Item"
                end
            end)
    
            -- Remove recolorer formats (#R, #G, #Y, and custom colors like #cff0af0)
            itemDescription = string.gsub(itemDescription, "#[%a%d]+", "") 
    
        else 
            itemDescription = "ERROR: Failed to Get Auto Desc"
        end 
    end 
    
    if itemPicture == nil or itemPicture == "AUTO" then 
        local r,iconid = Customui:getItemIcon(itemID)
        if r == 0 then 
            -- only update when succeed 
            itemPicture = iconid;
        else 
            itemPicture = "ERROR : Failed to Get Auto Picture ";
        end 
    end 

    GLOBAL_SHOP.CATALOG[tostring(itemID)] = {itemid = itemID , name = itemName , price = itemPrice, discount = itemDiscount , itemCurrencyType = itemCurrencyType or "Coin", desc = itemDescription , picture = itemPicture }

    if GLOBAL_SHOP.CATALOG[tostring(itemID)] then 
        return true 
    else 
        return false 
    end 
end 

-- Bulk add Catalog  Item 
-- ITEMID , NAME , DESC , PICTURE ,  PRICE , DISCOUNT , CURRENCY 
function GLOBAL_SHOP:AddCatalogItems(itemList)
    for i,a in ipairs(itemList) do 
        -- call Global_Shop AddCatalogItem and check if it is succeed
        if GLOBAL_SHOP:AddCatalogItem(unpack(a)) then 
            -- for debug purpose print it 
            print("#RAddCatalogItem Success : ",unpack(a))
        else 
            print("#RAddCatalogItem Failed : ",unpack(a))
        end 
    end 
end 

-- -- Example Usage 
-- GLOBAL_SHOP:AddCatalogItem(100,"AUTO","AUTO","AUTO",2,0)

-- print(GLOBAL_SHOP.CATALOG);
-- Working great 


-- === Now lets Working on Shop Logic and Interaction === 

GLOBAL_SHOP.NPC_DATA = {} -- This will Hold Data about NPC and Items it Sell. 
-- Different NPC can have different Price based on Discount General( it has )
--  Some NPC offers only Discount on Specific Items 
--  Some NPC has More Stock on Specific Items 
--  Yes NPC have Stock for each items type they sell 
--  For this type of NPC maximum Items Type they sell is only 4 
--  There is Also NPC with Unlimited Items but limited Stock  
--  So there is 2 type of Shop we will be making 
--  1 is Shop that has Discounted Price Items and Limited Time and Limited Stock but only Selling 4 Different items 
--  And this type of shop allowing features for player to refresh it shop 
--  second Shop is that type of shop that has lot item can become pages displaying 6 items each pages with high stock 
--  and unlimited ammount of time we call the 2nd shop as Constant  Shop  and the other Shop is Dynamic Shop 
GLOBAL_SHOP.TYPE = {
     -- Unlimited Items but Limited Stock
    Constant = {
        Value = "Constant",
        -- store data UI to load with constant  shop
        UI = "7419963747589626098" -- let this blank for now 

    },
    -- Limited Items but Unlimited Stock
    Dynamic = {
        Value = "Dynamic",
        UI = "7419275534915016946" -- let this blank for now 
    }, 
}


--[[For the Dynamic is Using same Logic with Constant 
    which has set of Items but only Display 4 kinds of items from  the set of items 
    list and will randomize after refresh]]

-- So The Way Shop Initiated is same  for both type of shop 

GLOBAL_SHOP.ShopLists = {}

-- 1st Create a Items Shop List to load for NPC later 
function GLOBAL_SHOP:InitiateShopList(shopid,catalogIdList)
    -- itemlist is a list of id Item on Catalog (but just its ID)
    -- Validate itemlist 
    -- itemlist must contain these key id and stock 
    local data = {};
    for i,a in ipairs(catalogIdList) do 
        -- check if name of Catalog is exist 
        -- the key to access catalog is string 
        if GLOBAL_SHOP.CATALOG[tostring(a.id)] ~= nil then 
            data[i] = {
                id = a.id,
                stock = a.stock
            }

        else 
            print("#cD21100","ID of ", a.id , " Is Not Exist on Catalog!");
        end 
    end 
    GLOBAL_SHOP.ShopLists[tostring(shopid)] = data;
end 

-- 2nd Assign the ShopList into ShopNpc 
function GLOBAL_SHOP:AssignNPC(npc,shopid,typeShop,discount)
    npc = tostring(npc)
    shopid = tostring(shopid)
    if  GLOBAL_SHOP.ShopLists[shopid] ~= nil then 
        GLOBAL_SHOP.NPC_DATA[npc] = {shopid = shopid , discount = discount , typeShop = typeShop}
    else 
        print("#cD21100","Shop Id [", shopid , "] Is Not Exist!");
    end 
end

-- 3rd Adding Method to Be Called when Player Interact with NPC 

-- We Also Need a Holder for NPC that is being interacted by player 
-- Only Allowing 1 Player interacting 1 NPC  at a time 
GLOBAL_SHOP.NPCs_Player = {};

local function setInvincible(id)
    Actor:setActionAttrState(id,1,false);
    Actor:setActionAttrState(id,8,false);
    Actor:setActionAttrState(id,64,false);
    Actor:setActionAttrState(id,128,false);
end 
-- This is Special  Function to be called only in this project 
function GLOBAL_SHOP:CreateNPCShop(pos,npcModel,data)
    -- Create Shop
    local x,y,z = pos.x,pos.y,pos.z
    local shopid,typeShop,discount = data.shopid, data.typeShop, data.discount or 0
    -- function to executed to create NPC on the Map 
    local r , obj = World:spawnCreature(x,y,z,npcModel,1)
    -- Assign NPC to Shop
    GLOBAL_SHOP:AssignNPC(obj[1],shopid,typeShop,discount)
    -- Also Make the NPC kinda unAttackable 
    setInvincible(obj[1]);
end

function GLOBAL_SHOP:LoadShopList(shoplist)
    local recon = {};
    if type(shoplist) == "table" then 
        for i , a in ipairs(shoplist) do 
            local id = tostring(a.id)
            -- get Name from Catalog 
            recon[i] = GLOBAL_SHOP.CATALOG[id]
        end 
    end
    return recon 
end 

function GLOBAL_SHOP:IsNPCShop(NPC) 
    if GLOBAL_SHOP.NPC_DATA[tostring(NPC)] ~= nil then 
        return true 
    else 
        return false 
    end 
end 

function GLOBAL_SHOP:LoadShopFromNpc(playerid,npc)
    -- this including Opening UI based on what NPC Shop Type 
    -- This is the main function to be called when player interact with NPC
        
    local NPC_DATA = GLOBAL_SHOP.NPC_DATA[tostring(npc)]
    if NPC_DATA ~= nil then
        -- Check if Player already have Shop UI Opened Before Attempting to Do this and also Check for the NPC 
        if GLOBAL_SHOP.NPCs_Player[tostring(npc)] == nil and GLOBAL_SHOP.NPCs_Player[tostring(playerid)] == nil then 
            GLOBAL_SHOP.NPCs_Player[tostring(npc)]      = playerid
            GLOBAL_SHOP.NPCs_Player[tostring(playerid)] = npc
            -- Obtain its TypeShop
            local typeShop = NPC_DATA.typeShop
            -- load UI based on typeShop
            local r = Player:openUIView(playerid,typeShop.UI);
            if r ~= 0 then print("#R[Error]Please Check if UI is Exist or Not"); end 
        else 
            Player:notifyGameInfo2Self(playerid,"NPC is Busy");
        end 
    else 
        print("Something is not Right")
    end 
end 

-- -- lETS test it 
 
-- -- You Need to Create the Catalog 
-- -- Avoid using Auto for description becuz it is too long 
-- GLOBAL_SHOP:AddCatalogItem(100,"AUTO","AUTO","AUTO",2,0)
-- GLOBAL_SHOP:AddCatalogItem(200,"AUTO","AUTO","AUTO",3,0)
-- GLOBAL_SHOP:AddCatalogItem(300,"AUTO","AUTO","AUTO",4,0)

-- -- We Need to Create the Shoplist and there is only 2 Item are on Catalog ! 

-- GLOBAL_SHOP:InitiateShopList(1,{
--     {id = 100, stock = 10},
--     {id = 200, stock = 20},
--     {id = 300, stock = 20},
-- })

local function makeFace2(playerid,NPC)

    local result, px, py, pz = Actor:getPosition(playerid)
    local result, xa, ya, za = Actor:getPosition(NPC)
    local dx, dy, dz = xa - px, ya - py, za - pz
    local length = math.sqrt(dx * dx + dy * dy + dz * dz)
    if length ~= 0 then
    dx, dy, dz = dx / length, dy / length, dz / length
    end
    local yaw = math.atan2(-dx, -dz)
    -- Convert yaw angle from radians to degrees
    yaw = yaw * 180 / math.pi
    Actor:setFaceYaw(playerid,yaw)
    Actor:setFaceYaw(NPC,yaw+180)

end 

-- -- Creating NPC should be When Game.Start not Before Game Start 
-- -- This to Avoid bug
-- ScriptSupportEvent:registerEvent("Game.Start",function(e) 
--     GLOBAL_SHOP:CreateNPCShop({x=0,y=8,z=0},2,{shopid = 1,typeShop = GLOBAL_SHOP.TYPE.Dynamic})    
-- end)

-- Listen To Player Click on Actor 
ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid , NPC = e.eventobjid , e.toobjid 
    -- make the NPC face to Player 
    makeFace2(playerid,NPC)
    -- Check if NPC has Shop 
    if GLOBAL_SHOP:IsNPCShop(NPC) then
        GLOBAL_SHOP:LoadShopFromNpc(playerid,NPC)
    end 
end)