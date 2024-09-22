-- Helper functions for PLAYER_REVIVE system
local function getPos(obj)
    local r, x, y, z = Actor:getPosition(obj)
    if r then return x, y, z end
end

local function addEffect(x, y, z, effectid, scale)
    World:playParticalEffect(x, y, z, effectid, scale)
end

local function cancelEffect(x, y, z, effectid, scale)
    World:stopEffectOnPosition(x, y, z, effectid, scale)
end

local function playSoundOnPos(x, y, z, whatsound, volume, pitch)
    if pitch == nil then pitch = 1 end
    World:playSoundEffectOnPos({x = x, y = y, z = z}, whatsound, volume, pitch, false)
end

local function revivePlayer(playerid)
    local buffKnock =   50000005;
    Player:setAttr(playerid,2,50);
    local uiid = "7416366721069160690"  -- New UI ID for revive
RUNNER.NEW(function ()
    PLAYER_REVIVE.DATA[playerid] = nil; 
    Actor:removeBuff(playerid,buffKnock);    
    Player:hideUIView(playerid, uiid)
    Player:notifyGameInfo2Self(playerid, "#GPlayer Revived Successfully!")
end,{},20)
end 

-- Function to update the revive progress bar in the UI for a player
local function updateReviveBarUI(playerid, reviveStatus)
    local percentage = reviveStatus / 100
    local uiid = "7416366721069160690"  -- New UI ID for revive
    local mainBar = uiid .. "_4"

    -- Send the revive progress to the UI
    Customui:setSize(playerid, uiid, mainBar, percentage * 470, 28)

    if reviveStatus == 100 then
        Player:hideUIView(playerid, uiid)
        Player:notifyGameInfo2Self(playerid, "#GPlayer Revived Successfully!")
    end
end

local function openPlayerBeingRevived(playerid,reviveStatus)
    local uiid = "7416366721069160690"  -- New UI ID for revive
    local closebtn = uiid.."_6";
    local txt = uiid.."_5";
    local buffKnock =   50000005;
    -- Open the revive UI
    Player:openUIView(playerid, uiid)
    Customui:hideElement(playerid,uiid,closebtn);
    -- Prevent the player from moving while being revived
    Player:setActionAttrState(playerid, 1, false)
    -- Disable any interactive UI
    FORCE_INTERACTIVITY_CLOSED(playerid, true)
    Player:hideUIView(playerid, INTERACTIVE_UI.uiid)

    -- Prevent the Knock Buff to Kill player by Pausing it 
    local r , buftik = Actor:getBuffLeftTick(playerid,buffKnock);
    local r = Actor:addBuff(playerid, buffKnock, 1 , buftik );
    Customui:setText(playerid,uiid,txt,"You are Being Revived ("..math.floor(buftik/20).." Seconds Left Before Dies ");
    -- Initialize the UI with the current revive status
    updateReviveBarUI(playerid, reviveStatus)
end

-- Function to open the revive progress bar UI and lock player's movement
local function setOpenReviveBar(playerid, reviveStatus)
    local uiid = "7416366721069160690"  -- New UI ID for revive
    local closebtn = uiid.."_6";
    local txt = uiid.."_5";
    -- Open the revive UI
    Player:openUIView(playerid, uiid)

    Customui:showElement(playerid,uiid,closebtn);
    Customui:setText(playerid,uiid,txt,"Reviving Others...");
    -- Prevent the player from moving while being revived
    Player:setActionAttrState(playerid, 1, false)

    -- Disable any interactive UI
    FORCE_INTERACTIVITY_CLOSED(playerid, true)
    Player:hideUIView(playerid, INTERACTIVE_UI.uiid)

    -- Initialize the UI with the current revive status
    updateReviveBarUI(playerid, reviveStatus)
end

-- Revive system
PLAYER_REVIVE = {
    DATA = {},  -- Store player revive data (revive status, etc.)

    -- Check if the player is fully revived
    ALIVE = function(playerid)
        if not PLAYER_REVIVE.DATA[playerid] then
            PLAYER_REVIVE.DATA[playerid] = {
                revive_status = 0,    -- Initial revive status
                revivers = {},        -- Players reviving this player
                revive_speed = 30       -- Default revive speed
            }
        end

        if PLAYER_REVIVE.DATA[playerid].revive_status >= 100 then
            return true  -- Player is fully revived
        else
            return false -- Still needs to be revived
        end
    end,

    -- Add a player to help revive another player (increases revive speed)
    ADD_REVIVER = function(playerid, reviverid)
        -- Initialize revive data if not set
        if not PLAYER_REVIVE.DATA[playerid] then
            PLAYER_REVIVE.DATA[playerid] = {
                revive_status = 0,    -- Initial revive status
                revivers = {},        -- Players helping to revive
                revive_speed = 1       -- Default revive speed
            }
        end

        -- Add the reviver to the team
        if not PLAYER_REVIVE.DATA[playerid].revivers[reviverid] then
            PLAYER_REVIVE.DATA[playerid].revivers[reviverid] = true
            -- Increase revive speed based on number of players helping
            PLAYER_REVIVE.DATA[playerid].revive_speed = PLAYER_REVIVE.DATA[playerid].revive_speed + 5

            -- Open the Revive UI for the reviver (show progress bar)
            setOpenReviveBar(reviverid, PLAYER_REVIVE.DATA[playerid].revive_status)
        end
    end,

    -- Remove a player from the revive team (cancel revive)
    REMOVE_REVIVER = function(playerid, reviverid)
        if PLAYER_REVIVE.DATA[playerid] and PLAYER_REVIVE.DATA[playerid].revivers[reviverid] then
            -- Remove the player from the revive team
            PLAYER_REVIVE.DATA[playerid].revivers[reviverid] = nil
            -- Decrease revive speed as fewer players are helping
            PLAYER_REVIVE.DATA[playerid].revive_speed = PLAYER_REVIVE.DATA[playerid].revive_speed - 0.5
        end
    end,

    -- Apply damage to the revive process (interrupt revive)
    INTERRUPT = function(playerid, dmg)
        if PLAYER_REVIVE.DATA[playerid] then
            PLAYER_REVIVE.DATA[playerid].revive_status = PLAYER_REVIVE.DATA[playerid].revive_status - dmg
            if PLAYER_REVIVE.DATA[playerid].revive_status < 0 then
                PLAYER_REVIVE.DATA[playerid].revive_status = 0 -- No negative revive values
            end
        end
    end,

    -- Update player revive status every frame
    UPDATE = function(playerid)
        if PLAYER_REVIVE.DATA[playerid] then
            -- Only revive if there are players helping
            local num_revivers = 0
            for _, _ in pairs(PLAYER_REVIVE.DATA[playerid].revivers) do
                num_revivers = num_revivers + 1
            end

            -- Increase the revive status based on revive speed and number of players
            if num_revivers > 0 then
                PLAYER_REVIVE.DATA[playerid].revive_status = PLAYER_REVIVE.DATA[playerid].revive_status +
                    (PLAYER_REVIVE.DATA[playerid].revive_speed * num_revivers * 0.1)
                -- Cap the revive status at 100
                if PLAYER_REVIVE.DATA[playerid].revive_status > 100 then
                    PLAYER_REVIVE.DATA[playerid].revive_status = 100
                    -- Call the revive function to actually revive the player
                    revivePlayer(playerid)
                    else 
                        -- While being revived , the player pause its Buff
                    openPlayerBeingRevived(playerid,PLAYER_REVIVE.DATA[playerid].revive_status);
                end
                -- Update the UI for each reviver based on the current revive progress  
                for reviverid, _ in pairs(PLAYER_REVIVE.DATA[playerid].revivers) do
                    updateReviveBarUI(reviverid, PLAYER_REVIVE.DATA[playerid].revive_status)
                end
            end
        end
    end
}

-- Event handler to run every frame (0.02 seconds)
ScriptSupportEvent:registerEvent("Game.RunTime", function()
    for playerid, _ in pairs(PLAYER_REVIVE.DATA) do
        PLAYER_REVIVE.UPDATE(playerid)  -- Update each player's revive status
    end
end)

-- when the UI is closed
ScriptSupportEvent:registerEvent("UI.Hide", function(e)
    local playerid = e.eventobjid
    local uiid = "7416366721069160690"  -- Revive UI ID
    if e.CustomUI == uiid then
        -- Set player capable of moving again
        Player:setActionAttrState(playerid, 1, true)

        -- Remove player from all revive teams since we don't know which one
        for id, _ in pairs(PLAYER_REVIVE.DATA) do
            PLAYER_REVIVE.REMOVE_REVIVER(id, playerid)
        end

        -- Enable back interactive UI
        FORCE_INTERACTIVITY_CLOSED(playerid, false)
    end
end)

ScriptSupportEvent:registerEvent("Player.RemoveBuff",function(e)
    local playerid = e.eventobjid; 
    local buffKnock =   50000005;
    local buffid = e.buffid;
    if buffid == buffKnock then 
    PLAYER_REVIVE.DATA[playerid] = nil;
    end 
end)