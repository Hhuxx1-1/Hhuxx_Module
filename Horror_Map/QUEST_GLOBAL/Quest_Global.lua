-- Enable or disable debug mode
IS_MODE_DEBUG = false

-- Define the QUEST_GLOBAL table with weak table for Player quests
QUEST_GLOBAL = {
    Player = setmetatable({}, { __mode = "v" }),  -- Weak table to avoid memory bloat
    Global = {}, Var = setmetatable({},{__index=function(self,index)
        if rawget(self,index) == nil then return "unset" else return rawget(self,index) end 
    end});
}

-- Cache the original print function
local original_print = print

-- Override the print function to support debug mode
local print = function(...)
    if IS_MODE_DEBUG then  -- Only print if debug mode is active
        original_print(...)  -- Call the original print function
    end
end

-- Define the NewQuest function once for both global and player-specific quests
local function NewQuest(Type_Quest, CheckFunction, ActionFinishedFunction)
    local quest = { condition = CheckFunction, action = ActionFinishedFunction }
    if Type_Quest == 0 then
        print("This is a Global Quest")
        QUEST_GLOBAL.Global = quest
    else
        print("This is an Individual Player Quest")
        QUEST_GLOBAL.Player[Type_Quest] = quest  -- Assume Type_Quest is always a number for player ID
    end
end

local function AccessVar(VarName,VarValue,Method)
    -- Add/Modify Variable Based on VarName and Its Method to VarValue. 
    -- If Method is SET (string)
    if(Method == "SET")then 
        -- Assign The New VarValue to index named VarName into Var Table 
        QUEST_GLOBAL.Var[VarName] = VarValue
    end 
    -- If Method is GET (string)
    if(Method == "GET" or VarValue  == nil)then 
        -- Return The Value of index named VarName from Var Table 
        return QUEST_GLOBAL.Var[VarName]
    end 
    -- If Method is Not Set or Nil
    if(Method == nil)then
        -- Return The Value of index named VarName from Var Table
        return QUEST_GLOBAL.Var[VarName];
    end 
end

-- Metatable to handle function calls for creating new quests
QUEST_GLOBAL = setmetatable(QUEST_GLOBAL, {
    __call = function()
        return { New = NewQuest , Var = AccessVar}
    end
})

-- Function to check global quest condition and run the action if the condition is met
local function CheckAndRunGlobalQuest()
    local globalQuest = QUEST_GLOBAL.Global

    if globalQuest and type(globalQuest.condition) == "function" and globalQuest.condition() then
        print("Global quest condition met. Executing action...")

        if type(globalQuest.action) == "function" then
            globalQuest.action()  -- Run the action if condition is true
        else
            print("Global quest action is not a function.")
        end
    else
        print("Global quest condition not met or condition is not a function.")
    end
end

-- Function to check player-specific quests
local function CheckAndRunPlayerQuest(playerID)
    local playerQuest = QUEST_GLOBAL.Player[playerID]

    if playerQuest and type(playerQuest.condition) == "function" and playerQuest.condition() then
        print("Player " .. playerID .. " quest condition met. Executing action...")

        if type(playerQuest.action) == "function" then
            playerQuest.action()  -- Run the action if condition is true
        else
            print("Player quest action is not a function.")
        end
    else
        print("Player " .. playerID .. " quest condition not met or condition is not a function.")
    end
end

-- Function to get all players from the game API
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end

-- ScriptSupportEvent to run on game time
ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    if e.second then
        -- Check the global quest (applies to all players)
        CheckAndRunGlobalQuest()

        -- Get all player UIDs and check their individual quests
        -- local players = GetAllPlayer()
        -- if players then  -- If players array is not nil
        --     for _, playerID in ipairs(players) do
        --         -- Check each player's individual quests
        --         CheckAndRunPlayerQuest(playerID)
        --     end
        -- end
    end
end)
