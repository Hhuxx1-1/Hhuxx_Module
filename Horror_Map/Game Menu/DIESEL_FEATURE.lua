-- Diesel local function 
    local function getPos(obj) 	                                                                        local r,x,y,z = Actor:getPosition(obj);  	if(r) then return x,y,z end end
    local function addEffect(x,y,z,effectid,scale)                                                      World:playParticalEffect(x,y,z,effectid,scale); end 
    local function cancelEffect(x,y,z,effectid,scale)                                                   World:stopEffectOnPosition(x,y,z,effectid,scale); end
    local function playSoundOnPos(x,y,z,whatsound,volume,pitch)               if(pitch==nil)then pitch=1 end                                World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, pitch, false) end 
-- Function to update the progress bar in the UI for a player
local function updateDieselBarUI(playerid, repairStatus)
    -- Calculate the percentage of the repair progress
    local percentage = repairStatus / 100

    local uiid = "7415845561147529458"
    local mainBar = uiid .. "_2"
    -- Send this percentage value to the UI (adjust this function to match your game engine)
    Customui:setSize(playerid,uiid,mainBar,percentage*498,18);

    if repairStatus == 100 then 
        Player:hideUIView(playerid,uiid);
        Player:notifyGameInfo2Self(playerid,"#Y Generator is Fully Repaired");
    end 
end

-- Function to open the repair progress bar UI and lock the player's movement
local function setOpenDieselBar(playerid, repairStatus)
    local uiid = "7415845561147529458"
    local mainBar = uiid .. "_2"

    -- Open the UI 
    Player:openUIView(playerid,uiid);

    -- Prevent the player from moving while repairing
    Player:setActionAttrState(playerid,1,false);

    -- disable Interactive UI 
    FORCE_INTERACTIVITY_CLOSED(playerid,true);
    Player:hideUIView(playerid,INTERACTIVE_UI.uiid)--hide the interface for the player
    -- Initialize the UI with the current repair status
    updateDieselBarUI(playerid, repairStatus)
end

-- Holder if the thing is Boost Able;
IS_BOOST_ABLE = {};
IS_BOOSTING_ENABLED = {};
PLAYER_GENERATOR = {}; -- store playerid and its obj here ;
local function cancelBoostEvent(playerid,obj)
    local uiid = "7415845561147529458"
    local boostUI = uiid.."_11";
    local elementid = uiid.."_13";
    local code  = Customui:StopAnim(playerid, uiid, elementid);
    local r = Customui:hideElement(playerid,uiid,boostUI);  
    if IS_BOOST_ABLE[obj] then 
        IS_BOOST_ABLE[obj] = false;
    end 
    IS_BOOSTING_ENABLED[playerid] = false ;
    PLAYER_GENERATOR[playerid] = nil;
end

-- Function to generate either 1 or -1 randomly
function randomSign()
    return math.random(0, 1) == 0 and -1 or 1
end

local function minigameBoostUI(playerid,obj)
    
    local center = {x=7,y=7};
    local uiid = "7415845561147529458";
    local elementid = uiid.."_13";
    local offset = 500+math.random(50,150);

    Customui:setColor(playerid, uiid, uiid.."_11", "0xffffff");
    Customui:setColor(playerid, uiid, elementid, "0xffffff");
    local code  = Customui:StopAnim(playerid, uiid, elementid);
    Customui:setPosition(playerid, uiid, elementid, center.x + (offset * randomSign()), center.y+math.random(-20,10));
    -- this function inside will be executed based on delay on last param 
    local delay = math.random(2,4)
    RUNNER.NEW(function()
        local code  = Customui:StopAnim(playerid, uiid, elementid);
        local code  = Customui:SmoothMoveTo(playerid, uiid, elementid, delay + 0.4, center.x, center.y);    
        -- Set the Event to true 
        RUNNER.NEW(function()
            IS_BOOST_ABLE[obj] = true; 
            Player:playMusic(playerid, 10984, 80, 1, false);
            Customui:setColor(playerid, uiid, uiid.."_11", "0xa2ee4f");
            Customui:setColor(playerid, uiid, elementid, "0xa2ee4f");
            RUNNER.NEW(function()
                if IS_BOOST_ABLE[obj] == true then 
                    cancelBoostEvent(playerid,obj);
                    Player:notifyGameInfo2Self(playerid,"#RFailed to Boost")
                end 
            end,{},20*2)    
        end,{},20*delay)    
    end,{},1)
    

end

-- function to display Minigame to Boost the repair speed  
local function openBoostUI(playerid,obj)
    local uiid = "7415845561147529458"
    local boostUI = uiid.."_11";
    local r = Customui:showElement(playerid,uiid,boostUI);
    PLAYER_GENERATOR[playerid] = obj;
    minigameBoostUI(playerid,obj);
    IS_BOOSTING_ENABLED[playerid] = true ;
end
-- Diesel Generator System
DIESEL_GENERATOR = {
    DATA = {},  -- Store generator data (repair status, etc.)
    
    -- Check if the generator is fully repaired
    ALIVE = function(obj)

        if not DIESEL_GENERATOR.DATA[obj] then
            DIESEL_GENERATOR.DATA[obj] = {
                repair_status = 0,    -- Initial repair status
                repairmen = {},       -- Players working on the generator
                repair_speed = 1      -- Default repair speed
            }
        end

        if DIESEL_GENERATOR.DATA[obj].repair_status >= 100 then
            return true  -- Generator is fully operational
        else
            return false -- Still needs repairs
        end
    end,

    -- Add a player to repair the generator (increases repair speed)
    ADD_REPAIRMAN = function(obj, playerid)
        -- Initialize generator data if not set
        if not DIESEL_GENERATOR.DATA[obj] then
            DIESEL_GENERATOR.DATA[obj] = {
                repair_status = 0,    -- Initial repair status
                repairmen = {},       -- Players working on the generator
                repair_speed = 1      -- Default repair speed
            }
        end
        
        -- Add the player to the repair team
        if not DIESEL_GENERATOR.DATA[obj].repairmen[playerid] then
            DIESEL_GENERATOR.DATA[obj].repairmen[playerid] = true
            -- Increase repair speed based on number of players
            DIESEL_GENERATOR.DATA[obj].repair_speed = DIESEL_GENERATOR.DATA[obj].repair_speed + 0.5
            
            -- Open the Diesel Repair UI for the player (show progress bar)
            setOpenDieselBar(playerid, DIESEL_GENERATOR.DATA[obj].repair_status)
        end
    end,

    -- Remove a player from the repair team (cancel repair)
    REMOVE_REPAIRMAN = function(obj, playerid)
        if DIESEL_GENERATOR.DATA[obj] and DIESEL_GENERATOR.DATA[obj].repairmen[playerid] then
            -- Remove the player from the repair team
            DIESEL_GENERATOR.DATA[obj].repairmen[playerid] = nil
            -- Decrease repair speed as fewer players are working on it
            DIESEL_GENERATOR.DATA[obj].repair_speed = DIESEL_GENERATOR.DATA[obj].repair_speed - 0.5
        end
    end,

    -- Apply damage to the generator, reducing repair status
    DAMAGE = function(obj, dmg)
        if DIESEL_GENERATOR.DATA[obj] then
            DIESEL_GENERATOR.DATA[obj].repair_status = DIESEL_GENERATOR.DATA[obj].repair_status - dmg
            if DIESEL_GENERATOR.DATA[obj].repair_status < 0 then
                DIESEL_GENERATOR.DATA[obj].repair_status = 0 -- No negative repair values
            end
        end
    end,
    -- Speed Up the Generator 
    BOOST = function(obj)
        if DIESEL_GENERATOR.DATA[obj] then
            DIESEL_GENERATOR.DATA[obj].repair_speed = DIESEL_GENERATOR.DATA[obj].repair_speed + 0.5 ;
        end
    end,
    -- Update generator repair status every frame
    UPDATE = function(obj)
        if DIESEL_GENERATOR.DATA[obj] then
            -- Only repair if there are players working on it
            local num_repairmen = 0
            for i,_ in pairs(DIESEL_GENERATOR.DATA[obj].repairmen) do
                num_repairmen = num_repairmen + 1
            end

            -- Increase the repair status based on repair speed and number of players
            if num_repairmen > 0 then
                DIESEL_GENERATOR.DATA[obj].repair_status = DIESEL_GENERATOR.DATA[obj].repair_status + 
                    (DIESEL_GENERATOR.DATA[obj].repair_speed * num_repairmen * 0.02)

                -- Cap the repair status at 100
                if DIESEL_GENERATOR.DATA[obj].repair_status > 100 then
                    DIESEL_GENERATOR.DATA[obj].repair_status = 100
                    -- this is where the Diesel Indicates it is Fixed 
                    QUEST_GLOBAL().Var("D"..obj,100,"SET");
                    -- set the Generator to Play Animation:
                    local x,y,z = getPos(obj);
                    local r = Block:placeBlock(2004,x,y+1,z)
                    Actor:playAct(obj,14);
                    World:playSoundEffectOnPos({x=x,y=y,z=z}, 10809, 150, 0.2, true)
                else
                    local prs  = math.floor(DIESEL_GENERATOR.DATA[obj].repair_status*100)
                    if math.fmod(prs,45) == 0 then 
                        local x,y,z = getPos(obj); 
                        playSoundOnPos(x,y,z,10795,50,1);
                    end 
                    if math.fmod(prs,370) == 0 then 
                        local x,y,z = getPos(obj); 
                        playSoundOnPos(x,y,z,10175,50,1);
                        addEffect(x,y+1,z,1308,1)
                        RUNNER.NEW(function()
                            cancelEffect(x,y+1,z,1308,1)
                        end,{},20)
                    end 
                end

                -- Update the UI for each repairman (player) based on the current repair progress
                for playerid,_ in pairs(DIESEL_GENERATOR.DATA[obj].repairmen) do
                    updateDieselBarUI(playerid, DIESEL_GENERATOR.DATA[obj].repair_status)
                    if DIESEL_GENERATOR.DATA[obj].repair_status > 10 then 
                        if math.random(1,200) < 5 then 
                            if IS_BOOSTING_ENABLED[playerid] == nil or IS_BOOSTING_ENABLED[playerid] == false then 
                                if IS_BOOST_ABLE[obj] ~= true then 
                                Player:playMusic(playerid, 10794, 80, 1, false);
                                openBoostUI(playerid,obj);
                                end 
                            end 
                        end 
                    end 
                end
            end
        end
    end
}

-- Event handler to run every frame (0.02 seconds)
ScriptSupportEvent:registerEvent("Game.RunTime", function()
    for obj, _ in pairs(DIESEL_GENERATOR.DATA) do
        DIESEL_GENERATOR.UPDATE(obj)  -- Update each generator
    end
end)

-- when the UI is closed 
ScriptSupportEvent:registerEvent("UI.Hide",function(e)
    local playerid = e.eventobjid;
    local uiid = "7415845561147529458";
    if e.CustomUI == uiid then 
        -- set player capable to move 
        Player:setActionAttrState(playerid,1,true);
        -- remove player from all generator since idk which one 
        for obj, _ in pairs(DIESEL_GENERATOR.DATA) do
            DIESEL_GENERATOR.REMOVE_REPAIRMAN(obj,playerid);
        end 

        -- Enable back interactive UI 
        FORCE_INTERACTIVITY_CLOSED(playerid,false)
        cancelBoostEvent(playerid,PLAYER_GENERATOR[playerid]);
    end 
end)

-- Boost Event 
ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid = e.eventobjid;
    local uiid = "7415845561147529458";
    local btn = uiid.."_12";
    if e.CustomUI == uiid then 
        if e.uielement == btn then 
            if PLAYER_GENERATOR[playerid] then 
                if IS_BOOST_ABLE[PLAYER_GENERATOR[playerid]] then 
                    DIESEL_GENERATOR.BOOST(PLAYER_GENERATOR[playerid]);
                    IS_BOOSTING_ENABLED[playerid] = false;
                    cancelBoostEvent(playerid,PLAYER_GENERATOR[playerid]);
                    Player:notifyGameInfo2Self(playerid,"#GSuccessfully Boost")
                    Player:playMusic(playerid, 10797, 80, 1, false);
                else 
                    cancelBoostEvent(playerid,PLAYER_GENERATOR[playerid]);
                    Player:notifyGameInfo2Self(playerid,"#RFailed Boost")
                end 
            end 
        end 
    end 
end)