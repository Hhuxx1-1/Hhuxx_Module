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
local LastCachedTime = {};
local Cache_Data = {};
local Cache_Data_mt = {
    __call = function(t, key)
        return t[key]
    end 
}
local Cache_Data = setmetatable(Cache_Data,Cache_Data_mt);

local setCacheData = function(data,key)
    Cache_Data[key] = data;
    LastCachedTime[key] = os.time();
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
    -- check Last Cached Time for playerid  
    if LastCachedTime["S:" .. playerid] and (LastCachedTime["S:" .. playerid] + 20 < os.time()) then
        -- Load data from server
        loadLastRanking(playerid)
        threadpool:wait(retryPolicy);
    end
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

local function showCrown(playerid,streak)
local info = Graphics:makeGraphicsImage([[8_1029380338_1722530669]], 0.15, 0xff0000, 2);
local result = Graphics:createGraphicsImageByActor(playerid,info,{x=0,y=3,z=0},30,0,40);
local infoStreak = Graphics:makeGraphicsText(tostring(streak),32,0,3);
local restult2 = Graphics:createGraphicsTxtByActor(playerid,infoStreak,{x=0,y=4,z=0},35,0,40)
end 

local function removeCrown(playerid)
    Graphics:removeGraphicsByObjID(playerid, 2, 10)
    Graphics:removeGraphicsByObjID(playerid, 3, 1)
end 

local function checkRanking(playerid)
    local streak = playerStreaks[playerid].getStreak()
    if streak >= 5 then
        -- Show KillStreak On Player Head 
        -- API from Miniworld
        if(isHighestKillStreak(playerid,streak))then 
            showCrown(playerid,streak);
        else 
            removeCrown(playerid);
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