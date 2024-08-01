-- Create a table to store player streaks
local playerStreaks = {} ; local RankingName = "KillStreak_Hhuxx1_00";
local retryPolicy = 10;
-- Function to initialize or reset a player's streak
local function InitPlayerStreak(playerId)
    -- Check if player streak already exists
    if not playerStreaks[playerId] then
        -- Create a closure to handle the player's streak
        playerStreaks[playerId] = (function()
            local streak = 0
            return {
                increment = function()
                    streak = streak + 1
                    return streak
                end,
                reset = function()
                    streak = 0
                end,
                getStreak = function()
                    return streak
                end
            }
        end)()
    else
        -- Reset the player's streak if it already exists
        playerStreaks[playerId].reset()
    end
end

-- Function to handle a player kill
local function PlayerKill(playerId)
    if playerStreaks[playerId] then
        local newStreak = playerStreaks[playerId].increment()
        --print("Player " .. playerId .. " is on a killstreak of " .. newStreak)
    else
        print("Error: Player streak not initialized for player " .. playerId)
    end
end

-- Function to handle a player death
local function PlayerDeath(playerId)
    if playerStreaks[playerId] then
        playerStreaks[playerId].reset()
        --print("Player " .. playerId .. " streak reset to 0")
    else
        print("Error: Player streak not initialized for player " .. playerId)
    end
end

-- Example usage:
-- InitPlayerStreak("player1")
-- PlayerKill("player1")
-- PlayerKill("player1")
-- PlayerDeath("player1")
-- PlayerKill("player1")

local Cache_Data = {};
local Cache_Data_mt = {
    __call = function(t, key)
        return t[key]
    end 
}
local Cache_Data = setmetatable(Cache_Data,Cache_Data_mt);

local setCacheData = function(data,key)
    Cache_Data[key] = data;
    print(Cache_Data);
end

local obtainLoad = function (ret,k,v,ix) 
    if ret == ErrorCode.OK then
        setCacheData({v=v,ix=ix},k);
    else
        if ret == 2 then 
            local ret = CloudSever:setOrderDataBykey(RankingName,k,1);
            print("Retrying : Result : ",ret)
        else
            print('Connection Failed');
        end
    end
end

local function  loadLastRanking(playerid)
    local ret = CloudSever:getOrderDataByKeyEx(RankingName,"S:"..playerid,obtainLoad)
end

local function setRanking(playerid,v)
    while Cache_Data("S:"..playerid)==nil do 
        if(Cache_Data("S:"..playerid)==nil) then 
            loadLastRanking(playerid);
            threadpool:wait(retryPolicy);
        else 
            break;
        end 
    end 
    -- API from Miniworld
    local lastRecord = Cache_Data("S:"..playerid);
    if(lastRecord.v < v)then 
        local ret = CloudSever:setOrderDataBykey(RankingName,"S:"..playerid,v);
        if ret == ErrorCode.OK then
            print("setRanking success [Playerid : ",playerid,"] with ",v);
            return true;
        else
            print("Error [102] function setRanking : Unable to Set Ranking ");
            return false;
        end
    else 
        print("Killstreak are not Higher than last Record ");
    end 
end

local function isHighestKillStreak(playerid,streak) 
    local result = true ;
    for i,a in pairs(playerStreaks) do 
        if(tonumber(i)~=tonumber(playerid))then 
            local streakPlayer = tonumber(playerStreaks[i].getStreak())
            if streakPlayer > streak then
                result = false ;
                break;
            end 
        end 
    end 
    return result;
end 

local function showCrown(playerid)


end 

local function removeCrown(playerid)


end 

local function checkRanking(playerid)
    local streak = playerStreaks[playerid].getStreak()
    if streak >= 2 then
        -- Show KillStreak On Player Head 
        -- API from Miniworld
        if(isHighestKillStreak(playerid,streak))then 
            showCrown(playerid);
        end 
    end 
    setRanking(playerid,streak);
end 


ScriptSupportEvent:registerEvent("Player.DefeatActor",function(e) 
    local target = e.eventobjid;
    if(Actor:isPlayer(e.toobjid)==0)then 
        PlayerKill(target);
        checkRanking(target);
    end;
end)
ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e) 
    InitPlayerStreak(e.eventobjid);
end)
ScriptSupportEvent:registerEvent("Player.Die",function(e) 
    PlayerDeath(e.eventobjid); removeCrown(e.eventobjid)
end)