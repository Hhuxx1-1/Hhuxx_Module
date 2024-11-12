local leaderboard = {};leaderboard.data = {};
leaderboard.name = "ranking_9103A10363_k";

local UI_ID = "7420438251353696718";
local Slot = {
    {
        name ="11" , score = "87"
    },
    {
        name ="84" , score = "88"
    },
    {
        name ="85" , score = "89"
    },
    {
        name ="86" , score = "90"
    }
}

-- Function to get all players from the game API
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end
local top4LeaderBoard = {}
local GameLeaderboard = {}


local function UpdateLeaderBoard(playerId)
    for i,a in ipairs(Slot) do 
        if top4LeaderBoard and top4LeaderBoard[i] then 
            local data = top4LeaderBoard[i] or false;
            print("Found Data for ["..i.."]",data)
            local r, name = Player:getNickname(data.playerid)
            local score = data.score;
            if r == 0 then 
                local r  = Customui:setText(playerId,UI_ID,UI_ID.."_"..a.name,name);
                local r2 = Customui:setText(playerId,UI_ID,UI_ID.."_"..a.score,score);
            end 
        else
            print("data is empty");
            Customui:setText(playerId,UI_ID,UI_ID.."_"..a.name,"-");
            Customui:setText(playerId,UI_ID,UI_ID.."_"..a.score,"-");
        end 
    end 
end

ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    if e.second then
        print("Checking Leaderboard");
        GameLeaderboard = {};
        -- Step 1: Populate the GameLeaderboard with player data
        for i, playerId in ipairs(GetAllPlayer()) do
            print("loading data player : ",playerId)
            local r, modelSize = Player:getAttr(playerId, 21)
            modelSize = math.floor(tonumber(modelSize) * 10) -- Remove the decimal point
            GameLeaderboard[i] = { playerid = playerId, score = modelSize }
        end
        print("LeaderBoard : ",GameLeaderboard)

        -- Step 2: Sort GameLeaderboard from highest to lowest score
        table.sort(GameLeaderboard, function(a, b)
            return a.score > b.score
        end)

        -- Step 3: Store top 4 players in top4LeaderBoard
        top4LeaderBoard = {}
        for i = 1, math.min(4, #GameLeaderboard) do
            table.insert(top4LeaderBoard, GameLeaderboard[i])
        end
        print(top4LeaderBoard)
        for i, playerId in ipairs(GetAllPlayer()) do
            local r , err = pcall(function()
                UpdateLeaderBoard(playerId);
            end)
        end 
        if not r then 
            Chat:sendSystemMsg("Error Leader Board : "..err)
        end 
    end
end)
