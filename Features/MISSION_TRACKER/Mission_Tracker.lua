MISSION_TRACKER = {} -- Global mission tracker object
MISSION_TRACKER.DATA = {} -- Stores mission logic and conditions

-- Create a new mission with a condition function and results
function MISSION_TRACKER:NEW(key, data)
    if data then 

        local condition = data.f;
        local resultFalse,resultTrue = data.isFalse or "_FALSE",data.isTrue or "_TRUE";
        local name = data.name or key;
        local fullname = data.fullname or key;
        self.DATA[key] = {
            key = key;
            name = name,
            fullname = fullname,
            isTrue = condition,
            status = data.status or nil,
            results = {resultFalse, resultTrue} -- False: [1], True: [2]
        }
    end 
end

function MISSION_TRACKER:IS_UNLOCKED(playerid,key)
    if tostring(HX_Q:GET(playerid,key)) == "MISSION_UNLOCKED" then 
        return true;
    else 
        return false;
    end 
end

-- Function to set a Mission is Unlocked 
function MISSION_TRACKER:SET_UNLOCKED(playerid,key)
    HX_Q:SET(playerid,key,"MISSION_UNLOCKED")
    -- additionally Show Notification Animation;
    local r,err = pcall(function()
        local UI_NOTIF_NEW_QUEST = "7440924240261093618";
        Player:openUIView(playerid,UI_NOTIF_NEW_QUEST);
        Customui:showElement(playerid,"7418405533454637298","7418405533454637298_67");
    end)
end

-- Read mission data for the given player and mission index
function MISSION_TRACKER:READ(playerid, index)
    local keys = {}
    
    -- Step 1: Gather all unlocked missions
    for key in pairs(self.DATA) do
        if self:IS_UNLOCKED(playerid, key) then
            table.insert(keys, key)
        end
    end
    
    -- Step 2: Sort keys based on custom mission status logic
    table.sort(keys, function(a, b)
        local missionA = self.DATA[a]
        local missionB = self.DATA[b]

        -- Determine status of mission A
        local conditionMetA, _ = missionA.isTrue(playerid)
        local claimedA = MISSION_REWARD:IS_CLAIMED(playerid, a)

        -- Determine status of mission B
        local conditionMetB, _ = missionB.isTrue(playerid)
        local claimedB = MISSION_REWARD:IS_CLAIMED(playerid, b)

        -- Priority:
        -- 1. Incomplete (conditionMet == false)
        -- 2. Complete but not claimed (conditionMet == true, claimed == false)
        -- 3. Claimed (claimed == true)
        
        if not conditionMetA and conditionMetB then
            return true
        elseif conditionMetA and not conditionMetB then
            return false
        elseif conditionMetA and not claimedA and claimedB then
            return true
        elseif conditionMetA and claimedA and not claimedB then
            return false
        end
        
        -- Fall back to alphabetical order of keys for consistency
        return a < b
    end)
    
    -- Step 3: Fetch the mission at the specified index
    local key = keys[index]
    if not key then
        return nil
    end

    local mission = self.DATA[key]
    local conditionMet, resultMessage = mission.isTrue(playerid)

    -- Default result message if none is provided
    if resultMessage == nil then 
        resultMessage = mission.results[conditionMet and 2 or 1]
    end 

    return {
        key = key,
        short_name = mission.name,
        full_name = mission.fullname, -- Can replace with key or a more descriptive field
        description = resultMessage,
        status = mission.status or (conditionMet and "Complete" or "Pending")
    }
end


-- Handle UI updates
local playerSelectedIndex = {}
local btnSlot = {32, 33, 34, 35}
local slotShortTitle = {7, 9, 11, 13}
local btnPage = {Next = 5, Back = 4}
local selectedText = {title = 26, desc = 27, status = 29}
local notif = {15,16,17,18}

local reward = {Btn = 39, text =40 ,icon_btn = 41 , list = 42};

local function readCurrentPage(playerid)
    local index = playerSelectedIndex[playerid] or 1
    local data = {}
    for i = 0, 3 do
        local missionIndex = index + i
        local mission = MISSION_TRACKER:READ(playerid, missionIndex)
        if mission then
            table.insert(data, mission)
        end
    end
    return data
end

local function UPDATE_MISSION_TRACKER(playerid)
    local ui = "7438450833019836658" -- Your UI ID
    if not playerSelectedIndex[playerid] then
        playerSelectedIndex[playerid] = 1
    end

    local index = playerSelectedIndex[playerid]
    local data = readCurrentPage(playerid)

    -- Update slots for missions
    for i, slot in ipairs(btnSlot) do
        local mission = data[i];
        if mission then
            HX_UI:SET_TEXT(playerid, ui, slotShortTitle[i], mission.short_name);
            HX_UI:SET_BUTTON(playerid, ui, slot, "SELECT_MISSION_" .. (index + i - 1));

            if mission.status ~= "Complete" then
                -- hide or show the thing and color the thing 
                HX_UI:SET_COLOR(playerid,ui,slotShortTitle[i]-1,0xba0000);
                HX_UI:SHOW(playerid,ui,notif[i])
            else 
                HX_UI:SET_COLOR(playerid,ui,slotShortTitle[i]-1,0x00ff04);
                if MISSION_REWARD:IS_CLAIMED(playerid, mission.key) then
                    HX_UI:HIDE(playerid,ui,notif[i])
                else
                    HX_UI:SHOW(playerid,ui,notif[i]) 
                end 
                
            end 
        else
            HX_UI:SET_TEXT(playerid, ui, slotShortTitle[i], "")
            HX_UI:SET_BUTTON(playerid, ui, slot, "")
            HX_UI:HIDE(playerid,ui,notif[i])
            HX_UI:SET_COLOR(playerid,ui,slotShortTitle[i]-1,0xffffff);
        end
    end

    -- Update selected mission details
    if #data > 0 then
        local selectedMission = data[1] -- Assume the first mission is selected initially
        HX_UI:SET_TEXT(playerid, ui, selectedText.title, selectedMission.full_name)
        HX_UI:SET_TEXT(playerid, ui, selectedText.desc, selectedMission.description)
        HX_UI:SET_TEXT(playerid, ui, selectedText.status, selectedMission.status)

        -- update the Mission List Reward 
        HX_UI:SET_TEXT(playerid, ui, reward.list,"Reward : "..MISSION_REWARD:READ_REWARD(playerid,selectedMission.key));
        HX_UI:SHOW(playerid,ui,reward.Btn);
        -- check for current Mission Reward 
        if selectedMission.status == "Complete" then
            -- check is already Claimed or not 
            if MISSION_REWARD:IS_CLAIMED(playerid, selectedMission.key) then
                HX_UI:SET_TEXT(playerid,ui,reward.text,"Claimed");
                HX_UI:SET_COLOR(playerid,ui,reward.Btn,0x8f9190);
                HX_UI:SET_COLOR(playerid,ui,reward.Btn,0x8f9190);
                HX_UI:SET_BUTTON(playerid, ui, reward.Btn, "");
            else 
                HX_UI:SET_TEXT(playerid,ui,reward.text,"Claim");
                HX_UI:SET_COLOR(playerid,ui,reward.Btn,0xffffff);
                HX_UI:SET_COLOR(playerid,ui,reward.Btn,0xffffff);
                HX_UI:SET_BUTTON(playerid, ui, reward.Btn, "CLAIM_"..selectedMission.key);
            end 
        else 
            HX_UI:SET_TEXT(playerid,ui,reward.text,"Not Yet");
            HX_UI:SET_COLOR(playerid,ui,reward.Btn,0x8f9190);
            HX_UI:SET_COLOR(playerid,ui,reward.Btn,0x8f9190);
        end 
    else
        HX_UI:SET_TEXT(playerid, ui, selectedText.title, "No Missions")
        HX_UI:SET_TEXT(playerid, ui, selectedText.desc, "")
        HX_UI:SET_TEXT(playerid, ui, selectedText.status, "")
        HX_UI:HIDE(playerid,ui,reward.Btn);
    end
end

-- UI Show Event
ScriptSupportEvent:registerEvent("UI.Show", function(e)
    local playerid = e.eventobjid
    UPDATE_MISSION_TRACKER(playerid)
end)

-- Pagination logic for Next and Back buttons
ScriptSupportEvent:registerEvent("UI.Button.Click", function(e)
    local playerid = e.eventobjid
    local button = e.uielement
    local ui = "7438450833019836658" -- Your UI ID

    if button == ui.."_"..btnPage.Next or button == ui.."_"..btnPage.Back then 
        if button == ui.."_"..btnPage.Next then
            playerSelectedIndex[playerid] = playerSelectedIndex[playerid] + 1
        elseif button == ui.."_"..btnPage.Back then
            playerSelectedIndex[playerid] = math.max(1, playerSelectedIndex[playerid] - 1)
        end
    elseif button == ui.."_"..reward.Btn then
        local actionName = HX_UI.BTN_STRING[ui.."_"..reward.Btn];
        -- print("Action Name : ",actionName);
        local missionKey = actionName:match("CLAIM_(.+)")
        -- print("missionKey : ",missionKey);
        if missionKey then
            -- Grant reward
            -- print("trying to grant reward")
            local success, message = MISSION_REWARD:GRANT(playerid, missionKey);

            if success then 
                Player:notifyGameInfo2Self(playerid,message)
            else 
                Player:notifyGameInfo2Self(playerid,"Failed : "..message or "Unknown")
            end 
        end
    else 
        for i,a in ipairs(btnSlot) do
            -- if it is a btnSlot then do 
                -- print(a,button);
                local full_string_ui = ui.."_"..a
            if button == full_string_ui then
                -- get action btn 
                -- print("it is same");
                local indexNamed = HX_UI.BTN_STRING[full_string_ui];
                if indexNamed and indexNamed ~= "" then 
                    local index = tonumber(indexNamed:match("SELECT_MISSION_(%d+)"));
                    --set selected index 
                    -- print("indexNamed : ",indexNamed , "index : ", index);
                    playerSelectedIndex[playerid] = index;
                else  
                    -- print("Not Found Index Data");
                end 
                break;
            end 
        end 
    end 

    UPDATE_MISSION_TRACKER(playerid)
end)
