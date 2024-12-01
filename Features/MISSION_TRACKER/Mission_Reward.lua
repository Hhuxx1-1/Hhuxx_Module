MISSION_REWARD = {} -- Reward module
MISSION_REWARD.DATA = {} -- Store rewards for each mission

HX_PLAYER = {};
-- Method 
function HX_PLAYER:ADD_ITEM(playerid,itemid,amount,prior)
    return Player:gainItems(playerid,itemid,amount,prior or 1)
end

function HX_PLAYER:ADD_XP(playerid,amount)
    -- there is no XP for now i dunno where to store XP leveling things
end

function HX_PLAYER:ADD_CURRENCY(playerid,amount,name)
    if GLOBAL_CURRENCY then 
        return GLOBAL_CURRENCY:AddCurrency(playerid,name or "Coin",amount);
    else 
        print("Error GLOBAL_CURRENCY is not defined");
    end 
end

-- Add rewards for a mission
function MISSION_REWARD:ADD(missionKey, rewardData)
    self.DATA[missionKey] = rewardData
end

-- Check if rewards are already claimed
function MISSION_REWARD:IS_CLAIMED(playerid, missionKey)
    return tostring(HX_Q:GET(playerid, "REWARD_" .. missionKey)) == "CLAIMED"
end

-- Mark rewards as claimed
function MISSION_REWARD:MARK_CLAIMED(playerid, missionKey)
    HX_Q:SET(playerid, "REWARD_" .. missionKey, "CLAIMED")
end

-- Grant rewards for a mission and mark as claimed
function MISSION_REWARD:GRANT(playerid, missionKey)
    print(" Running Granting ");
    if MISSION_REWARD:IS_CLAIMED(playerid, missionKey) then
        return false, "Rewards already claimed!"
    end

    local rewards = self.DATA[missionKey]
    if rewards then
        for _, reward in ipairs(rewards) do
            -- Assume `reward` is a table: {type = "ITEM", id = 123, amount = 1}
            if reward.type == "ITEM" then
                HX_PLAYER:ADD_ITEM(playerid, reward.id, reward.amount)
            elseif reward.type == "XP" then
                HX_PLAYER:ADD_XP(playerid, reward.amount)
            elseif reward.type == "CURRENCY" then
                HX_PLAYER:ADD_CURRENCY(playerid, reward.amount)
            end
        end
        MISSION_REWARD:MARK_CLAIMED(playerid, missionKey)
        return true, "Rewards successfully claimed!"
    else
        return false, "No rewards defined for this mission."
    end
end

function MISSION_REWARD:READ_REWARD(playerid,missionKey)
    local rewards = self.DATA[missionKey] ;
    local reward_title = "";
    if rewards then

        for _, reward in ipairs(rewards) do
            -- Assume `reward` is a table: {type = "ITEM", id = 123, amount = 1}
            if reward.type == "ITEM" then
                local _,itemname = Item:getItemName(reward.id );
                reward_title = reward_title ..itemname .. "x" .. reward.amount .. " "
            elseif reward.type == "XP" then
                HX_PLAYER:ADD_XP(playerid, reward.amount)
                reward_title = reward_title .. reward.amount .. "XP "
            elseif reward.type == "CURRENCY" then
                -- HX_PLAYER:ADD_CURRENCY(playerid, reward.amount)
                reward_title = reward_title .. reward.amount .. "Coins "
            end
        end

    end 
    if reward_title == "" then reward_title = "No Reward" end 
    return reward_title;
end