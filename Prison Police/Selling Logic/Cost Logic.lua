-- Initialize the item costs array
local itemCosts = {[0]=0 , [4148] = 50}

-- Function to generate a random cost between 5 and 20
local function generateRandomCost()
    return math.random(1, 5)
end

-- Function to get item cost
function getItemCost(itemID)
    if not itemCosts[itemID] then
        -- get Item Price from GLOBAL_SHOP 
        local itemPrice = GLOBAL_SHOP.CATALOG[tostring(itemID)];
        if not itemPrice then 
            itemCosts[itemID] = generateRandomCost()
        else 
            itemCosts[itemID] = math.floor(itemPrice.price/2);
        end 
    end
    return itemCosts[itemID]
end