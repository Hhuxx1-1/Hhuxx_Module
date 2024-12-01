HX_Q = {} ; 
--[[Init the HX_Q to Hold Quest Functions And Mechanism]]
HX_Q.LOADED_DATA = {};HX_Q.CURRENT_QUEST={};HX_Q.CURRENT_NPC = {};
local SelectedQuest = {};

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
    Player:openUIView(playerid,"7438156314227448050")
    if HX_Q.LOADED_DATA[playerid] == nil then 
        -- create empty table 
        HX_Q.LOADED_DATA[playerid] = {}
    end 
    local log = "";
    local count = 1 
    for i,encoded in ipairs(datas) do 
        local key,val = HX_Q:DECODEKEY(encoded);
        count = count + 1;
        -- save it to  the HQ_Q.LOADED_DATA[playerid]
        HX_Q.LOADED_DATA[playerid][key] = val;
        RUNNER.NEW(function()
            log = log .."Loading ".. encrypt_to_hex(key, "MYKEY").."-"..encrypt_to_hex(val,"MYVAL").." \n";
            Customui:setText(playerid,"7438156314227448050","7438156314227448050_31",log)
        end,{},i*5)
    end 
    RUNNER.NEW(function()
    log = log.."\n" .. " Loading Complete "
    Customui:setText(playerid,"7438156314227448050","7438156314227448050_31",log)
    end,{},20+count*5)
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
        HX_Q.CURRENT_QUEST[playerid] = HX_Q.NPC_QUEST_DATA[npc][id];
        Player:playMusic(playerid, 10954, 100,1,false);
    else 
        print("Error Quest is Not Exist : ",id);
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
        -- if not exist yet then create  a new table
        if not HX_Q.NPC_QUEST_DATA[npc] then   HX_Q.NPC_QUEST_DATA[npc] = {};  end 
        local name,dialog = data.name, data.dialog;

        if name and dialog then HX_Q.NPC_QUEST_DATA[npc][name] = data else print("ERROR :",npc,data) end 
    end 
end 

function HX_Q:SHOW_QUEST(playerid,data)
    local c,r = pcall(function()
            
        local name = data.name;         local text = data.text;
        local pic = data.pic;           local reward = data.reward_text;
        local detail = data.detail;     local uiid = "7431847660104653042";
        local open = data.open;
        local bar = data.bar;

        if open then    Player:openUIView(playerid,uiid);
        else            Player:hideUIView(playerid,uiid);
        end 

        if name then    Customui:setText(playerid,uiid,uiid.."_3","QUEST : "..name);
        else            Customui:setText(playerid,uiid,uiid.."_3","QUEST");
        end 

        if text then    Customui:setText(playerid,uiid,uiid.."_6",text);
        else            Customui:setText(playerid,uiid,uiid.."_6","");
        end 

        if pic then     Customui:showElement(playerid,uiid,uiid.."_8"); Customui:setTexture(playerid,uiid,uiid.."_9",pic);
        else            Customui:hideElement(playerid,uiid,uiid.."_8");
        end 

        if reward then  Customui:setText(playerid,uiid,uiid.."_7","Reward : "..reward);
        else            if detail then    Customui:setText(playerid,uiid,uiid.."_7",detail);
                        else              Customui:setText(playerid,uiid,uiid.."_7"," ");
                        end 
        end 

        if bar then 
            local n,m = bar.v1,bar.v2;  local percentage = n/m;
            local bar_color = bar.color;
            local width,height = 230,28;
            Customui:showElement(playerid,uiid,uiid.."_10");
            Customui:setSize(playerid, uiid, uiid.."_11", width*percentage, height)
        else            Customui:hideElement(playerid,uiid,uiid.."_10");
        end 
    end)
    if not c then print("Error when Displaying Quest",r) end 
end

function HX_Q:CreatePointingArrowForPlayer(playerid,x,y,z,id ,colr)
	local size=1;local color = colr or 0x00ffff;

	local info=Graphics:makeGraphicsLineToPos(x, y, z, size, color, id);
	local r,data = Graphics:createGraphicsLineByActorToPos(playerid, info, {x=0,y=0,z=0}, 0);
    local info2=Graphics:makeGraphicsArrowToPos(x, y, z, size, color, id);
	Graphics:createGraphicsArrowByActorToPos(playerid, info2, {x=0,y=0.5,z=0}, 10);
    if r == 0 then return {line=info,arrow=info2} end
end 

function HX_Q:DeletePointingArrowForPlayer(playerid,data)
    for i,dat in pairs(data) do 
        Graphics:removeGraphicsByObjID(playerid, dat.id, dat.Type)
    end 
end 

local function checkForAvailableQuest(playerid)
    local CURRENT_NPC = HX_Q.CURRENT_NPC[playerid];
    if CURRENT_NPC then 
        local actorid,id = CURRENT_NPC.id , CURRENT_NPC.npc;
        if HX_Q.NPC_QUEST_DATA[actorid] then
            local LOADED_QUEST_FROM_NPC = HX_Q.NPC_QUEST_DATA[actorid]
            -- print("Accessing Quest Data from NPC["..actorid.."]",LOADED_QUEST_FROM_NPC);
            for _,QUESTNOW in pairs(LOADED_QUEST_FROM_NPC) do 
            -- check for it's requirement
                -- print("Executing : ",QUESTNOW)
                if QUESTNOW[1](playerid) == true then 
                    -- print("It is True")
                    local DIALOG_UI = "7431848836925692146";
                    Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_3", QUESTNOW.dialog or "...",40001 ,1,0);
                    Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", QUESTNOW.Action or "OK");
                    SelectedQuest[playerid] = QUESTNOW;
                    return true,QUESTNOW;
                end 
            end 
            return false;
        end 
    end 
end

local function loadDefaultDialog(NPC)
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

    return desc,name,modelID;
end 

local function CheckActionButton(playerid,hide,text)
    local DIALOG_UI = "7431848836925692146";
    local code , err = pcall(function()
        if not CURRENT_VSHOP[playerid] then 
            Customui:hideElement(playerid,DIALOG_UI,DIALOG_UI.."_9")
        else 
            Customui:showElement(playerid,DIALOG_UI,DIALOG_UI.."_9")
        end 
        -- check if npc has quest set 
        if hide then 
            Customui:hideElement(playerid,DIALOG_UI,DIALOG_UI.."_5")
        else 
            Customui:showElement(playerid,DIALOG_UI,DIALOG_UI.."_5")
        end 
        if text == nil then 
            Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", "Talk");
        else 
            Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", text);
        end 
    end)
end

local function OpenDialog(playerid,NPC)
    local DIALOG_UI = "7431848836925692146";
    local desc,name,modelID = loadDefaultDialog(NPC);
    local hide = false;
    local text = nil;
    -- Check if it has Dialog set Up;
    if desc ~= "" then 

        -- get Player Current Quest 
        local currenctQuest = getCurQUEST(playerid);
        local dataQuest = HX_Q.NPC_QUEST_DATA[modelID];
        local activeQuest = {};
        -- print("Current Quest : ",currenctQuest," Data Quest : ", dataQuest);
        if dataQuest then 
            activeQuest = dataQuest[currenctQuest];
            -- Quest is Active and When Player Click on That NPC it Directly Loads Quest Dialog instead of Default Dialog
            if activeQuest then
                desc = activeQuest.dialog;
                text =  activeQuest.ActionTitle or "OK";
                SelectedQuest[playerid] = dataQuest[currenctQuest];
            else 
                SelectedQuest[playerid] = nil;
            end 
        else 
            -- Quest is not in Currently Active;
            SelectedQuest[playerid] = nil;
        end 
        -- not a continue quest interactiion 
        local r1 = VarLib2:setPlayerVarByName(playerid, 4, "DIALOG_NOW", desc);
        local r2 = VarLib2:setPlayerVarByName(playerid, 4, "NPC_NAME", name);
        local r3 = VarLib2:setPlayerVarByName(playerid, 10, "CURRENT_NPC", NPC);

        if r1 == 0 and r2 == 0 and r3 == 0 then 
            Player:openUIView(playerid,DIALOG_UI);
            HX_Q.CURRENT_NPC[playerid] = {id = modelID , npc = NPC};
        end 

        CheckActionButton(playerid,hide,text);
    end 
end

-- register when player click the NPC 
ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid , NPC = e.eventobjid , e.toobjid 
    -- forgot to check NPC is player or not 
    RUNNER.NEW(function()
        if Actor:isPlayer(NPC) ~= 0 then 
            OpenDialog(playerid,NPC);    
        end     
    end,{},1)
    
end)

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid,uiid,elementid =  e.eventobjid,e.CustomUI,e.uielement 
    if elementid == "7431848836925692146_5" then 
        -- it is talk button 
        if SelectedQuest[playerid] == nil then 
            if not checkForAvailableQuest(playerid) then 
                local DIALOG_UI = "7431848836925692146";
                -- HX_Q.CURRENT_QUEST[playerid] = nil; -- Don't Need to Clear Current Quest at All
                SelectedQuest[playerid] = nil;
                Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_3", ". . .",40001 ,1,0);
                Customui:hideElement(playerid ,DIALOG_UI, DIALOG_UI.."_5")
                Customui:setText(playerid, DIALOG_UI, DIALOG_UI.."_6", " ");
                RUNNER.NEW(function()
                    Player:hideUIView(playerid,uiid);
                end,{},40)
            end 
        else 
            --before attempting to insert the quest check if it has executeable function 1,2,3
            -- if not then don't add 
            if SelectedQuest[playerid][2] and SelectedQuest[playerid][3] then 
                HX_Q.CURRENT_QUEST[playerid] = SelectedQuest[playerid];
            end 

            if SelectedQuest[playerid]["END"] then 
                local r,err = pcall(function()
                    return SelectedQuest[playerid]["END"](playerid)    
                end)
                if not r then print("Error Executing ['END']",err); end 
            end 
            
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
        local r,err = pcall(function()
            if playerid_Quest[2](playerid) then 
                playerid_Quest[3](playerid);
                HX_Q.CURRENT_QUEST[playerid] = nil;
            end 
        end)
        if not r then 
            -- clear the Error 
            HX_Q.CURRENT_QUEST[playerid] = nil;
        end 
    end 
end)

function HX_Q:ShowReward(playerid,pictureurl,name,desc)
    local r , er = pcall(function()
        local REWARD_UI = "7434584486280108274";
        Customui:setText(playerid,REWARD_UI,REWARD_UI.."_6",name)
        Customui:setText(playerid,REWARD_UI,REWARD_UI.."_12",desc)
        Customui:setTexture(playerid,REWARD_UI,REWARD_UI.."_4",pictureurl)
        local r = Player:openUIView(playerid,REWARD_UI);    
    end)
    if not r then print("Show REWARD : ",er) end;
end 

function HX_Q:PLAY_MUSIC(playerid,code)
    local r = VarLib2:setPlayerVarByName(playerid,3,"Music Code",code)
    if r == 0 then Actor:addBuff(playerid,50000007,1,180*20); end 
end

function HX_Q:STOP_MUSIC(playerid)
    Actor:removeBuff(playerid,50000007)
end

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    print("Initiating Player Data for playerid : "..e.eventobjid);
    HX_Q:LOAD_DATA(e.eventobjid)
end)
