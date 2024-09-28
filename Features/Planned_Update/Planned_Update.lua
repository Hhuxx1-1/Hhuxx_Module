local uiid = "7419048636087736562"

local expectedDead = {
    d = 27,
    m = 9,
    y = 2024
}

local byPassCode = 1111

-- Function to get the current server date in string format (yyyy-mm-dd HH:MM:SS)
local function getNowDate()
    local code, timestr = World:getServerDateString()
    if code == 0 then 
        return timestr
    end 
    return nil
end

-- Function to check if the current date is past the expected dead date
local function isDead(timestr)
    -- Split the date string (yyyy-mm-dd HH:MM:SS) into its components
    local currentYear, currentMonth, currentDay = string.match(timestr, "(%d+)-(%d+)-(%d+)")
    
    -- Convert extracted strings to numbers for comparison
    currentYear = tonumber(currentYear)
    currentMonth = tonumber(currentMonth)
    currentDay = tonumber(currentDay)

    -- Compare current date with the expected dead date
    if currentYear > expectedDead.y then
        return true -- Year has passed
    elseif currentYear == expectedDead.y then
        if currentMonth > expectedDead.m then
            return true -- Month has passed
        elseif currentMonth == expectedDead.m then
            if currentDay > expectedDead.d then
                return true -- Day has passed
            end
        end
    end
    return false -- Still alive
end

ScriptSupportEvent:registerEvent([[Game.AnyPlayer.EnterGame]], function(e) 
    local nowDateStr = getNowDate()
    local playerid = e.eventobjid;
    if nowDateStr then
        print("Current date: " .. nowDateStr)
        if isDead(nowDateStr) then
            Player:openUIView(playerid,uiid)
            -- You can add more logic here to handle what happens when the player is "dead"
            print(" Map is Die ")
        else
            -- Pass
            --  Do Nothing
            print(" Map is Alive ")
        end
    else
        Player:OpenUIView(playerid,uiid);
        Chat:sendSystemMsg("Failed to retrieve the current date.")
    end
end)
