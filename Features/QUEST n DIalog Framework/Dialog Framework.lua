HX_Q = {} ; 
--[[Init the HX_Q to Hold Quest Functions And Mechanism]]
HX_Q.LOADED_DATA = {}; --[[Store Player Loaded QUEST DATA here]]
HX_Q.CURRENT_QUEST={};
HX_Q.CURRENT_NPC = {};
-- Function to Encode Key and Value into a single string
function HX_Q:ENCODEKEY(Key, Val)
    -- Replace any `:` in Key and Val to prevent parsing issues
    local encodedKey = tostring(Key):gsub(":", "\\:")
    local encodedVal = tostring(Val):gsub(":", "\\:")
    
    -- Concatenate Key and Val with a separator (e.g., ":")
    return encodedKey .. ":" .. encodedVal
end

-- Function to Decode Encoded Key and Value from a single string
function HX_Q:DECODEKEY(EncodedKeyVal)
    -- Split EncodedKeyVal by the first unescaped ":" into Key and Val
    local encodedKey, encodedVal = EncodedKeyVal:match("([^\\:]+):([^\\:]*)")
    
    -- Check for valid encoded format
    if not encodedKey or not encodedVal then
        error("Invalid encoded string format")
    end

    -- Restore original values by replacing escaped `:` back to `:`
    local Key = encodedKey:gsub("\\:", ":")
    local Val = encodedVal:gsub("\\:", ":")
    
    return Key, Val
end

--[[Set Global function to Load player Data from Cloud]]
function HX_Q:LOAD_DATA(playerid)
    local r,datas = Valuegroup:getAllGroupItem(18, "QUEST_DATA",playerid)
    print(datas)
    if HX_Q.LOADED_DATA[playerid] == nil then 
        -- create empty table 
        HX_Q.LOADED_DATA[playerid] = {}
    end 
    for i,encoded in ipairs(datas) do 
        local key,val = HX_Q:DECODEKEY(encoded);
        -- save it to  the HQ_Q.LOADED_DATA[playerid]
        HX_Q.LOADED_DATA[playerid][key] = val;
    end 
end
--[[Set Global function to Save player Data to Cloud]]
function HX_Q:SAVE_DATA(playerid)
    -- Clear Valuegroup 
   if Valuegroup:clearGroupByName(18, "QUEST_DATA",playerid) == 0 then 
    for key,val in pairs(HX_Q.LOADED_DATA[playerid]) do 
        local r = Valuegroup:insertInGroupByName(18, "QUEST_DATA", HX_Q:ENCODEKEY(key,val), playerid);
        if r ~= 0 then 
            print("Something is Error when adding Key : "..key.." val : "..val);
        end 
    end 
   end 
end

-- Now we didnt always Modify the Valuegroup

local function checkData(playerid)
    if not HX_Q.LOADED_DATA[playerid] then 
        -- incase if not loaded yet 
        HX_Q:LOAD_DATA(playerid)
        print("Somehow data is not loaded so will be extracted");
        print("Data Loaded" , HX_Q.LOADED_DATA[playerid])
    end 

    if HX_Q.LOADED_DATA[playerid] then 
        return true 
    else
        print("Data is NOT LOADED");
        return false
    end 
end

-- Instead we Modify the HX_Q.LOADED_DATA[playerid]
-- So we need to Save the Data to Valuegroup when player data change to keep save not lose 
-- Now creating the Method to Set HX_Q Data to Player  Data
function HX_Q:SET(playerid, key, val)
    if checkData(playerid) then 
        -- this function is overide existing loaded data 
        HX_Q.LOADED_DATA[playerid][key] = val;
        -- then save the changes 
        HX_Q:SAVE_DATA(playerid)
    end 
end 
-- Now Creating the Method to Get HX_Q Data from Player Data 
function HX_Q:GET(playerid, key)
    if checkData(playerid) then 
        return HX_Q.LOADED_DATA[playerid][key] or "Empty";
    end 
end

-- I think we already created method to manipulate player save quest data.
-- So we can use it to manipulate the HX_Q.LOADED_DATA[playerid]
-- Now Creating the Method to Delete HX_Q Data from Player Data
function HX_Q:DELETE(playerid, key)
    if checkData(playerid) then
        HX_Q.LOADED_DATA[playerid][key] = nil;
        -- then save the changes
        HX_Q:SAVE_DATA(playerid)
    end
end  
        
-- Now lets Add Method to setting up Quest for player 
-- Such as What NPC and What Quest it has and what rewards
-- The Method is to check 1st Function for condition to get this quest available and 2nd function for quest checking is complete or not and 3rd Function for  Reward
HX_Q.NPC_QUEST_DATA = {}; 
-- We will store the setup  data here
-- Method to setup a QUEST  for NPC
function HX_Q:CREATE_QUEST(npc,data)
    -- check if data is valid 
    -- data must contain 3 function 
    if data then
        -- check if NPC already have quest setup
        if not HX_Q.NPC_QUEST_DATA[npc] then
            -- if not exist yet then create  a new table
            HX_Q.NPC_QUEST_DATA[npc] = {};
        end 
        -- check if data contain 3 function
        if type(data[1]) == "function" and type(data[2]) == "function" and type(data[3]) == "function" then
            -- if yes then add it 
            local name = data.name;
            local dialog = data.dialog;
            if name and dialog then 
                HX_Q.NPC_QUEST_DATA[npc][name] = data;
            else
                print("Error: Quest Data must contain name and dialog",npc,data);
            end 
        end 
    end 

end 

function HX_Q:SHOW_QUEST(playerid,data)
    local c,r = pcall(function()
            
        local name = data.name;
        local text = data.text;
        local pic = data.pic;
        local reward = data.reward_text;
        local detail = data.detail;
        local uiid = "7431847660104653042";
        local open = data.open;

        if open then 
            Player:openUIView(playerid,uiid)
        else
            Player:hideUIView(playerid,uiid)
        end 

        if name then 
            Customui:setText(playerid,uiid,uiid.."_3","QUEST : "..name);
        else
            Customui:setText(playerid,uiid,uiid.."_3","QUEST");
        end 

        if text then 
            Customui:setText(playerid,uiid,uiid.."_6",text);
        else
            Customui:setText(playerid,uiid,uiid.."_6","");
        end 

        if pic then 
            Customui:showElement(playerid,uiid,uiid.."_8")
            Customui:setTexture(playerid,uiid,uiid.."_9",pic)
        else 
            Customui:hideElement(playerid,uiid,uiid.."_8")
        end 

        if reward then 
            Customui:setText(playerid,uiid,uiid.."_7","Reward : "..reward);
        else
            if detail then
                Customui:setText(playerid,uiid,uiid.."_7",detail);
            else 
                Customui:setText(playerid,uiid,uiid.."_7"," ");
            end 
        end 
    end)

    if not c then print("Error when Displaying Quest",r) end 
end

local function getCurQUEST(playerid)
    local r0 , currentQuest = VarLib2:getPlayerVarByName(playerid,4,"QUEST_ACTIVE");
    if r0 == 0 then return currentQuest end 
end 

function HX_Q:GET_CurQuest(playerid)
    return getCurQUEST(playerid);
end

function HX_Q:SET_CurQuest(playerid,val)
    local r0  = VarLib2:setPlayerVarByName(playerid,4,"QUEST_ACTIVE",val);
    if r0 == 0 then return true end 
end 

function RunQuest(playerid,id,npc)
    if HX_Q.NPC_QUEST_DATA[npc][id] then 
        -- this will directly run Quest without needing to check it 1st function 
        HX_Q.CURRENT_QUEST[playerid] = HX_Q.NPC_QUEST_DATA[0][id];
    else 
        print("Error Quest is Not Exist : ",id);
    end 
end

local SelectedQuest = {};

local function checkForAvailableQuest(playerid)
    local CURRENT_NPC = HX_Q.CURRENT_NPC;
    if CURRENT_NPC then 
        local actorid,id = CURRENT_NPC.id , CURRENT_NPC.npc;
        if HX_Q.NPC_QUEST_DATA[actorid] then
            local LOADED_QUEST_FROM_NPC = HX_Q.NPC_QUEST_DATA[actorid]
            for _,QUESTNOW in pairs(LOADED_QUEST_FROM_NPC) do 
            -- check for it's requirement 
                if QUESTNOW[1](playerid) then 
                    local DIALOG_UI = "7431848836925692146";
                    Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_3", QUESTNOW.dialog,40001 ,1,0);
                    Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", "OK");
                    SelectedQuest[playerid] = QUESTNOW;
                    return;
                end 
            end 
        end 
    end 
end

local function OpenDialog(playerid,NPC)
    local DIALOG_UI = "7431848836925692146";
    local r,modelID = Creature:getActorID(tonumber(NPC));
    -- Load Creature Description 
    local r, name = Creature:GetMonsterDefName(modelID);
    local r, desc = Creature:GetMonsterDefDesc(modelID);
    desc = string.gsub(desc, "@item_(%d+)", function(id)
        local r, referencedItemName = Item:getItemName(tonumber(id))
        if r == 0 then
            return referencedItemName
        else
            return "Unknown Item"
        end
    end)

    -- Remove recolorer formats (#R, #G, #Y, and custom colors like #cff0af0)
    desc = string.gsub(desc, "#[%a%d]+", "") 
    if desc ~= "" then 
        
        local currenctQuest = getCurQUEST(playerid)
        local dataQuest = HX_Q.NPC_QUEST_DATA[modelID]
        print("Current Quest : ",currenctQuest," Data Quest : ", dataQuest);
        if  dataQuest and dataQuest[currenctQuest] then 
            local dialog = dataQuest[currenctQuest].dialog;
            desc = dialog;
            Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", "OK");
            SelectedQuest[playerid] = dataQuest[currenctQuest];
        else 
            SelectedQuest[playerid] = nil;
            Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", "Talk");
        end 
            -- not a continue quest interactiion 
        local r1 = VarLib2:setPlayerVarByName(playerid, 4, "DIALOG_NOW", desc);
        local r2 = VarLib2:setPlayerVarByName(playerid, 4, "NPC_NAME", name);
        local r3 = VarLib2:setPlayerVarByName(playerid, 10, "CURRENT_NPC", NPC);

        if r1 == 0 and r2 == 0 and r3 == 0 then 
            Player:openUIView(playerid,DIALOG_UI);
            HX_Q.CURRENT_NPC = {id = modelID , npc = NPC};
        end 
        -- check for quest available 
        local code , err = pcall(function()
            if not CURRENT_VSHOP[playerid] then 
                Customui:hideElement(playerid,"7431848836925692146","7431848836925692146_9")
            else 
                Customui:showElement(playerid,"7431848836925692146","7431848836925692146_9")
            end 
            -- check if npc has quest set 
            if not HX_Q.NPC_QUEST_DATA[modelID] then 
                Customui:hideElement(playerid,"7431848836925692146","7431848836925692146_5")
            else 
                Customui:showElement(playerid,"7431848836925692146","7431848836925692146_5")
            end 
        end)
    end 
end

-- register when player click the NPC 

ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid , NPC = e.eventobjid , e.toobjid 
    OpenDialog(playerid,NPC);    
end)



ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid,uiid,elementid =  e.eventobjid,e.CustomUI,e.uielement 
    if elementid == "7431848836925692146_5" then 
        -- it is talk button 
        if SelectedQuest[playerid] == nil then 
            if not checkForAvailableQuest(playerid) then 
                local DIALOG_UI = "7431848836925692146";
                HX_Q.CURRENT_QUEST[playerid] = nil;
                SelectedQuest[playerid] = nil;
                Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_3", "Thanks for Helping",40001 ,1,0);
                Customui:hideElement(playerid ,DIALOG_UI, DIALOG_UI.."_5")
                Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", " ");
                RUNNER.NEW(function()
                    Player:hideUIView(playerid,uiid);
                end,{},40)
            end 
        else 
            HX_Q.CURRENT_QUEST[playerid] = SelectedQuest[playerid];
            SelectedQuest[playerid] = nil;
            Player:hideUIView(playerid,uiid);
        end 
    end 
end)

ScriptSupportEvent:registerEvent("UI.Show",function (e)
    local playerid,uiid =  e.eventobjid,e.CustomUI
    local DIALOG_UI = "7431848836925692146";
end)

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    for playerid,playerid_Quest in pairs(HX_Q.CURRENT_QUEST) do 
        if playerid_Quest[2](playerid) then 
            playerid_Quest[3](playerid);
            HX_Q.CURRENT_QUEST[playerid] = nil;
        end 
    end 
end)

function HX_Q:ShowReward(playerid,pictureurl,name,desc)
    local r , er = pcall(function()
        local REWARD_UI = "7434584486280108274";
        Customui:setText(playerid,REWARD_UI,REWARD_UI.."_6",name)
        Customui:setText(playerid,REWARD_UI,REWARD_UI.."_11",desc)
        Customui:setTexture(playerid,REWARD_UI,REWARD_UI.."_4",pictureurl)
        local r = Player:openUIView(playerid,REWARD_UI);    
    end)
    if not r then print("Show REWARD : ",er) end;
end 