-- Set up a global quest
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end
local r , gateAreaID = Area:createAreaRect({x=220,y=10,z=-20},{x=25,y=7,z=25});
local function getPos(obj) 	                                                                        local r,x,y,z = Actor:getPosition(obj);  	if(r) then return x,y,z end end
local function addEffect(x,y,z,effectid,scale)                                                      World:playParticalEffect(x,y,z,effectid,scale); end 
local function cancelEffect(x,y,z,effectid,scale)                                                   World:stopEffectOnPosition(x,y,z,effectid,scale); end
local function playSoundOnPos(x,y,z,whatsound,volume,pitch)               if(pitch==nil)then pitch=1 end                                World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, pitch, false) end 
-- function to display Quest Text to Every Player 
local  function displayGlobalQuestText(text,num)
    if(num == nil) then num = "" end 
    local uiid = "7405783316061427954"
    local elementText = uiid.."_10";
    for i , a in ipairs(GetAllPlayer()) do 
        local r = Customui:setText(a,uiid,elementText,T_Text(a,text)..num);
    end 
end 

-- function to hide/show the Proggress Bar 
local function toogleProggressBarQuest(bool)
    local uiid = "7405783316061427954"
    local bar = uiid.."_24";
    for i , a in ipairs(GetAllPlayer()) do 
        if bool then 
            Customui:showElement(a,uiid,bar)
        else 
            Customui:hideElement(a,uiid,bar)
        end 
    end 
end 

local function updateProggressBarQuest(v1,v2)
    local uiid = "7405783316061427954"
    local bar = uiid.."_25";
    local maxLength = 320;
    for i , a in ipairs(GetAllPlayer()) do 
        Customui:setSize(a,uiid,bar,v1/v2*maxLength,23)
    end 
end 

local function hideGameplayUI(playerid)
    local uilist = {
        "7399693898544257266",
        "7401846042231773426",
        "7405783316061427954",
        "7401028950473513202"
    }
    local noInGameUI = "7415474213980150002"
    for i,uiid in ipairs(uilist) do 
        Player:hideUIView(playerid,uiid)
    end 
    Player:openUIView(playerid,noInGameUI);
end


local function openGameplayUI(playerid)
    local uilist = {
        "7399693898544257266",
        "7401846042231773426",
        "7405783316061427954",
        "7401028950473513202"
    }
    local noInGameUI = "7415474213980150002"
    for i,uiid in ipairs(uilist) do 
        Player:openUIView(playerid,uiid)
    end 
    Player:hideUIView(playerid,noInGameUI);
end

local function Subtitle2(playerid,txt,duration)
    local uiid= "7415474213980150002";
    local ui_text_id = uiid.."_3";
    RUNNER.NEW(function()
        Customui:setText(playerid,uiid,ui_text_id,T_Text(playerid,txt));
        RUNNER.NEW(function()
            Customui:setText(playerid,uiid,ui_text_id,"");
        end,{},duration*20)
    end,{},0)
end

local function do_standby()
    QUEST_GLOBAL().New(0,function()
            displayGlobalQuestText(" ");
            toogleProggressBarQuest(false);
            return false;
    end,function()
        
    end)
end

local function winGame()
    local x,y,z = 223,11,-26;
    local lithiumblock = 415 ;
    local tx,ty,tz = 245,7,-20;
    -- place lithium block to power it 
    Block:placeBlock(lithiumblock,x,y,z)
    RUNNER.NEW(function()
        hideGameplayUI()
        for i,a in ipairs(GetAllPlayer()) do 
            Actor:tryNavigationToPos(a,tx+10,ty,tz, false, false)
            local code  = Player:SetCameraMountPos(a, {x=tx,y=ty+1,z=tz});
            local code  = Player:SetCameraRotTransformTo(a,{x=90,y=-15},1,2)
            RUNNER.NEW(function()
                local code  = Player:SetCameraRotTransformTo(a,{x=89,y=-16},1,8)
                RUNNER.NEW(function()
                    Player:setGameResults(a,1);
                    Game:doGameEnd();
                end,{},220)
            end,{},40)
        end 
    end,{},5)
end

local function doLastQuest()
    QUEST_GLOBAL().New(0,function()
        local TimeNow = MYWORLD.Second;
        if QUEST_GLOBAL().Var("IntoTheGate") == "unset" then 
            QUEST_GLOBAL().Var("IntoTheGate",TimeNow,"SET");
        end 
        local sss = TimeNow  - tonumber(QUEST_GLOBAL().Var("IntoTheGate"));
        local expectedEnd = 260;
        if sss >  expectedEnd then 
            -- Time out HQ lost Connection forever to the Agent and they abandoned 
            displayGlobalQuestText("HQ Lost Connection to the Agent and they abandoned the mission");
            for i , playerid  in ipairs(GetAllPlayer()) do 
                Chat:sendSystemMsg("#RYou Lose. HQ Lost Connection and Agents are being Lost Forever in Eternal Hell")
            end 
            toogleProggressBarQuest(false);
            RUNNER.NEW(function()
                Game:doGameEnd()
            end,{},40)
        else 
            -- check number of player on area gateAreaID
            local result,playerlist=Area:getAreaPlayers(gateAreaID)
            if result == 0 then 
                local n = #playerlist;
                local allplayers = GetAllPlayer();
                if n == #allplayers then 
                    return true;
                else 
                    displayGlobalQuestText("Escape Now! Run into The Gate!","( "..n.."/"..#allplayers.." Players : Time Remaining "..(expectedEnd-sss).." Seconds Left )");
                    toogleProggressBarQuest(true);
                    updateProggressBarQuest(n,#allplayers);
                    for x,playerid in ipairs(allplayers) do 
                        generateGuideArrow (playerid,{x=250,y=7,z=-20})
                    end 
                    return false 
                end 
            end 
        end 
    end,function ()
        winGame();
        do_standby();
    end)
end

local function intoTheGate()
    local HQ_cue = {"Alright We can Open the Gate anytime",
    "But we Don't want to drag those Creature into Our World",
    "Go Closer to The Gate and We will Open it.",
    "Good Luck"
    }
    for i = 1 , 4 do 
        RUNNER.NEW(function()
            for _,a in ipairs(GetAllPlayer()) do
                Chat:sendSystemMsg("#GHQ : "..T_Text(a,HQ_cue[i]),a);
                if i == 4 then 
                    Chat:sendSystemMsg("#Y#b"..T_Text(a,"New Objective"),a);
                    doLastQuest();
                end 
            end 
        end,{},i*40)
     end 
end

local function do_4rd_quest ()
    QUEST_GLOBAL().New(0,function()
        local TimeNow = MYWORLD.Second;
        if QUEST_GLOBAL().Var("TimeSurviveLast") == "unset" then 
            QUEST_GLOBAL().Var("TimeSurviveLast",TimeNow,"SET");
        end 
        local proggress = TimeNow  - tonumber(QUEST_GLOBAL().Var("TimeSurviveLast"));
        local expectedEnd = 60*2 -- 5 Minutes

        if proggress > expectedEnd then 
            return true 
        else 
            displayGlobalQuestText("Survive Blood Hour for 2 minutes","  (  " .. math.floor(proggress/60) .. "/2 minutes )");
            toogleProggressBarQuest(true);
            SPAWNER_SET_INTERVAL(40);
            -- set the bar 
            updateProggressBarQuest(proggress,expectedEnd)
            return false 
        end 
    end,function()
        intoTheGate();
        do_standby();
    end)
end 

local function LastMinute()
 local HQ_cue = {
    "It’s not over…",
    "the anomaly is peaking...",
    "two more minutes...",
    "they’re coming for you.",
    "Stay alive until the gate fully opens!"
 }
 for i = 1 , 5 do 
    RUNNER.NEW(function()
        for _,a in ipairs(GetAllPlayer()) do
            Chat:sendSystemMsg("#GHQ : "..T_Text(a,HQ_cue[i]),a);
            if i == 5 then 
                Chat:sendSystemMsg("#Y#b"..T_Text(a,"New Objective"),a);
                VarLib2:setGlobalVarByName(5, "IS_BLOOD_HOUR", true);
                do_4rd_quest();
            end 
        end 
    end,{},i*40)
 end 
end

local function do3rd_quest()
    QUEST_GLOBAL().New(0,function()
        local TimeNow = MYWORLD.Second;
        if QUEST_GLOBAL().Var("TimeSurvive") == "unset" then 
            QUEST_GLOBAL().Var("TimeSurvive",TimeNow,"SET");
        end 
        local proggress = TimeNow  - tonumber(QUEST_GLOBAL().Var("TimeSurvive"));
        local expectedEnd = 60*5 -- 5 Minutes

        if proggress > expectedEnd then 
            return true 
        else 
            displayGlobalQuestText("Survive for 5 minutes","  (  " .. math.floor(proggress/60) .. "/5 minutes )");
            toogleProggressBarQuest(true);
            -- set the bar 
            updateProggressBarQuest(proggress,expectedEnd)
            return false 
        end 
    end,function()
        LastMinute();
        do_standby();
    end)
end

local function wait4WestGateOpened()
    local HQ_cue = {
        "Signal received…",
        "but something’s coming your way…",
        "you need to survive for a few minutes until the gate opens…",
        "stay sharp!"
    }
    local gatePos = {x=200,y=7,z=-21}
    local gateAngle = 90;
    for i = 1 , #HQ_cue do 
        RUNNER.NEW(function()
            for k , a in ipairs(GetAllPlayer()) do 
                if i == 1 then 
                    MYWORLD.Second = 278;-- Set it to day time ;
                    hideGameplayUI(a)
                    local code  = Player:SetCameraMountPos(a, {x=gatePos.x,y=gatePos.y+2,z=gatePos.z});
                    local code  = Player:SetCameraRotTransformTo(a,{x=gateAngle,y=-14},1,2)
                end 
                Chat:sendSystemMsg("#GHQ : #W"..T_Text(a,HQ_cue[i]),a);
                Subtitle2(a,HQ_cue[i],1.5);
                if i == #HQ_cue then 
                    openGameplayUI(a)
                    Player:ResetCameraAttr(a);
                    Chat:sendSystemMsg("#Y#b"..T_Text(a,"New Objective"),a);
                    -- set forever night 
                    MYWORLD.TIME_TO_SET_DAY = -1 ;
                    MYWORLD.TIME_TO_SET_NIGHT = -1 ;
                    -- this way both of this are never true 
                    MYWORLD.SET_NIGHT();
                    RUNNER.NEW(function()
                        MYWORLD.SET_PAUSE();
                        SPAWNER_SET_INTERVAL(70);
                        Chat:sendSystemMsg("#R#b"..T_Text(a,"NEW ANOMALI DETECTED : DON'T STAY AT HEIGHT BUILDING"),a);
                    end,{},80);
                    do3rd_quest();
                end 
            end 
        end,{},80*i);
    end 
end

local function do_2nd_quest()
    QUEST_GLOBAL().New(0,function()
        local proggress = QUEST_GLOBAL().Var("Switch")
        if proggress == "unset" then 
            proggress = 0 ;
        end 
        if(proggress < 2)  then
            QUEST_GLOBAL().Var("LeverSwitch","TRUE","SET")
            displayGlobalQuestText("Turn on Both Main Generator and Tower","  ( "..proggress.." / 2 )");
            toogleProggressBarQuest(true);
            updateProggressBarQuest(proggress,2)
            return false;
        else 
            return true;
        end 
    end,function()
        wait4WestGateOpened();
        do_standby();
    end)
end

local generatorQuestCompleted = function()
    local HQ_cue = {"Good, you’ve recovered the Electric Power",
    "toggle the main switch and tower…",
    "it should send a signal...",
    "stay alert."}
    local cam = {
        {x=104,y=7,z=6,a=325},
        {x=148,y=7,z=93,a=255},
        {x=27,y=7,z=121,a=70},
        {x=65,y=7,z=164,a=35},
        {x=-57,y=3,z=-91,a=345},
        {x=-185,y=7,z=-42,a=305},
    }
    for k , a in ipairs(GetAllPlayer()) do
        Chat:sendSystemMsg(T_Text(a,"All Generator is Recovered"),a);
    end 
    for i = 1 , #cam+1 do
        RUNNER.NEW(function()
            for k , a in ipairs(GetAllPlayer()) do
                if i <= #cam then 
                    hideGameplayUI(a);
                    local code  = Player:SetCameraMountPos(a, {x=cam[i].x,y=cam[i].y+2,z=cam[i].z});
                    local code  = Player:SetCameraRotTransformTo(a,{x=cam[i].a,y=math.random(0,14)},1,2)
                    if(HQ_cue[i])then 
                        Chat:sendSystemMsg("#GHQ : #W"..T_Text(a,HQ_cue[i]),a);
                        Subtitle2(a,HQ_cue[i],1.5);
                    end 
                else 
                    Player:ResetCameraAttr(a);
                    Chat:sendSystemMsg("#Y#b"..T_Text(a,"New Objective"),a);
                    openGameplayUI(a);
                    do_2nd_quest();
                end 
            end 
        end,{},i*40)
    end 
end

local function do_1stQuest()
    QUEST_GLOBAL().New(0,function()
        local proggressNow = 0
        local Diesels =  QUEST_GLOBAL().Var("DieselOn") ;
        if Diesels ~= "unset" then 
            for i,a in ipairs(Diesels) do 
                -- check each diesel Value 
                -- if it has 100 means it is done 
                if QUEST_GLOBAL().Var(a) == 100 then 
                    -- print(QUEST_GLOBAL().Var(a));
                    proggressNow  = proggressNow + 1;
                end 
            end 
        end 
        -- Check Total Player Number 
        -- if player is less than 3 Diesel Generator Required is just 5 
        local diesel_Required = 5
        if #GetAllPlayer() > 2 then
            diesel_Required = 10;
        end 
        if(proggressNow < diesel_Required)  then
            displayGlobalQuestText("Use mechanical parts to fix the generator ","  ( "..proggressNow.." / "..diesel_Required.." Generator )");
            toogleProggressBarQuest(true);
            updateProggressBarQuest(proggressNow,diesel_Required)
            return false;
        else 
            return true;
        end 
        if proggressNow > 3 then 
            SPAWNER_SET_INTERVAL(120-(proggressNow*8));
        end 
    end,function()
        generatorQuestCompleted();
        do_standby();
    end)
end

local fireCampCutscene = function()
    local data = {
        {pos = {x=0 ,y=8,z=-22} , facing = 0},
        {pos = {x=-1,y=8,z=-22}  , facing = 0},
        {pos = {x=-2,y=8,z=-22}  , facing = 0},
        {pos = {x=-3,y=8,z=-22}  , facing = 270},
        {pos = {x=-4,y=8,z=-22}  , facing = 270},
        {pos = {x=-6,y=8,z=-18}  , facing = 270},
        {pos = {x=-6,y=8,z=-17}  , facing = 270},
        {pos = {x=-6,y=8,z=-16}  , facing = 270},
        {pos = {x=-6,y=8,z=-15}  , facing = 270},
        {pos = {x=4,y=7,z=-21}  , facing = 90},
        {pos = {x=4,y=8,z=-20}  , facing = 90},
        {pos = {x=4,y=8,z=-19}  , facing = 90},
    }
    local dialogue = {
        "Ugh, the Teleportation Device is like Sleeping in a Dream",
        "Yeah it is Dark and Suddenly We are here",
        "By The Way where are we,again? Sorry but i forgot",
        "I think we are in the Fire Camp, but i am not sure",
        "This place feels... wrong. Too quiet. The forest seems alive, but not in a way you’d expect",
        "I heard this forest has been abandoned for decades. Some say it’s haunted.",
        "Maybe this is where the urban legend of ‘The Rake’ came from…",
        "Ghosts and monsters? You can’t be serious. HQ wouldn’t send us here if it wasn’t safe",
        "Still… it’s weird how quiet it is. You’d think there’d be more wildlife around",
        "What... what was that?",
        "HQ said to get out. We need to move!"
    }
    local HQ_Broadcast = {
        "...Agents...",
        "you need to listen...",
        "we’ve detected... anomaly!",
        "Abort the mission...",
        "the place...dangerous!",
        "Get out...now...",
        "repeat...escape immediately!"
    }
    local firecampPos = {x=-1,y=10,z=-17}
    local outfirecampPos = {x=4,y=8,z=-12}
    local anomalyPos = {x=-2,y=9,z=-8}
    local spawnPos = {x=0,y=8,z=0}
    local screamSoundId = 10480;
    local effectExplosion = 1034;
    local soundExplosion = 10660;
    local chatPopUpMusic = 10956;
    local HQsound = 10166;
    local narator = "The forest has changed. Something has woken up. Escape before it’s too late.";
    local afterSceneCue = {"Agents… we’ve lost your coordinates.",
    "The anomaly… it’s affecting everything.",
    "We can’t bring you back, but you might be able to fix the situation.",
    "There’s an emergency generator nearby...",
    "parts scattered across the area… it’s your only hope.",
    "Power it up and send a rescue signal before the creatures find you.",
    "...defend yourselves…","something nearby…","check the tent…"}
    -- Load data cutscene to individually players
    for i,a in  ipairs(GetAllPlayer()) do
        local ix = math.fmod(i,#data);
        if(ix == 0)then ix = #data end 
        local x,y,z = data[ix].pos.x,data[ix].pos.y,data[ix].pos.z;
        local angle = data[ix].facing;
        RUNNER.NEW(function()
            hideGameplayUI(a);
            Player:setActionAttrState(a,1,false)
            Actor:setPosition(a,x+0.5,y,z+0.5);
            Player:playAct(a,14);
            Player:rotateCamera(a,angle,0)
            RUNNER.NEW(function()
                local code  = Actor:setFaceDirection(a,firecampPos.x,firecampPos.y,firecampPos.z);
                local code  = Player:SetCameraRotMode(a,1);
                local code  = Player:SetCameraMountPos(a, firecampPos);
            end,{},10);

            RUNNER.NEW(function()
                local code  = Player:SetCameraAttrState(a, 4, true);
            end,{},20)
            RUNNER.NEW(function()
                MYWORLD.IsStarted = true;
                local code  = Player:SetCameraRotTransformTo(a,{x=245,y=10},1,7)
            end,{},25)
            RUNNER.NEW(function()
                local code  = Player:SetCameraMountPos(a, outfirecampPos);
            end,{},25+(7*20))
            RUNNER.NEW(function()
                local code  = Player:SetCameraRotTransformTo(a,{x=215,y=-15},1,10)
            end,{},35+(7*20))
            RUNNER.NEW(function()
                local code  = Player:SetCameraRotTransformTo(a,{x=205,y=-10},1,70)
            end,{},35+(17*20))
        end,{},0)
    end 

    for i = 1 , 9 do  
        local txt = dialogue[i];
        RUNNER.NEW(function()
            local players = GetAllPlayer(); local player = players[math.random(1,#players)];
            local x,y,z = getPos(player);  playSoundOnPos(x,y,z,chatPopUpMusic,100,1);
            local graphinfo = Graphics:makeGraphicsText(txt,16,100,i);
            local r,grphid = Graphics:createGraphicsTxtByActor(player, graphinfo, {x=0,y=1,z=0}, 120, 0,0);
            RUNNER.NEW(function()
                Graphics:removeGraphicsByObjID(player, i, 1);
            end,{},120);
            for i,a in ipairs(players) do 
                Subtitle2(a,txt,4);
            end 
        end,{},155+40*i+((i-1)*130))
    end 
    RUNNER.NEW(function()
        for i,a in  ipairs(GetAllPlayer()) do
            local code  = Player:SetCameraMountPos(a, anomalyPos);
            local code  = Player:SetCameraRotTransformTo(a,{x=20,y=5},1,3)
            RUNNER.NEW(function()
                local code  = Player:SetCameraRotTransformTo(a,{x=5,y=10},1,2)
            end,{},80)
        end 
    end,{},1800)
    RUNNER.NEW(function()
        playSoundOnPos(spawnPos.x,spawnPos.y,spawnPos.z,soundExplosion,120,0.9);
        addEffect(spawnPos.x,spawnPos.y,spawnPos.z,effectExplosion,2);
        RUNNER.NEW(function()
            cancelEffect(spawnPos.x,spawnPos.y,spawnPos.z,effectExplosion);
            local txt = dialogue[10];
            RUNNER.NEW(function()
                local players = GetAllPlayer(); local player = players[math.random(1,#players)];
                local x,y,z = getPos(player);  playSoundOnPos(x,y,z,chatPopUpMusic,100,1);
                local graphinfo = Graphics:makeGraphicsText(txt,16,100,i);
                local r,grphid = Graphics:createGraphicsTxtByActor(player, graphinfo, {x=0,y=1,z=0}, 120, 0,0);
                RUNNER.NEW(function()
                    Graphics:removeGraphicsByObjID(player, i, 1);
                end,{},120);
                for i,a in ipairs(players) do 
                    Subtitle2(a,txt,5.5);
                end 
            end,{},10);
        end,{},40)
    end,{},1930)
    RUNNER.NEW(function()
        for ki = 1,7 do 
            RUNNER.NEW(function()
                for i,a in ipairs(GetAllPlayer()) do 
                    Chat:sendSystemMsg("HQ : #G "..T_Text(a,HQ_Broadcast[ki]),a);
                    playSoundOnPos(0,8,0,HQsound,200,0.1);
                    Subtitle2(a,"HQ : "..T_Text(a,HQ_Broadcast[ki]),2);
                end 
            end,{},ki*60);
        end 
    end,{},2000);
    RUNNER.NEW(function()
        for i,a in ipairs(GetAllPlayer())do 
            Player:ResetCameraAttr(a)
            SpawnerStart = true;
            Subtitle2(a,"#Y"..T_Text(a,narator),3);
        end 
        RUNNER.NEW(function()
            for ki=1,9 do 
                RUNNER.NEW(function()
                    for i,a in ipairs(GetAllPlayer()) do 
                    Player:setActionAttrState(a,1,true);
                    Chat:sendSystemMsg("HQ : #G"..T_Text(a,afterSceneCue[ki]),a);
                    playSoundOnPos(0,8,0,HQsound,200,0.1);
                        if ki > 1 then 
                            openGameplayUI(a);
                            local r = VarLib2:setGlobalVarByName(5,"GameStarted",true);
                        end 
                    end 
                end,{},40+(ki*80));
            end 
            RUNNER.NEW(function()
                for i,a in ipairs(GetAllPlayer()) do 
                Chat:sendSystemMsg("#Y#b"..T_Text(a,"New Objective"),a);
                local x,y,z = getPos(a)
                playSoundOnPos(x,y,z,10954,50,1);
                end 
                do_1stQuest();
            end,{},50+580);
        end,{},80)
    end,{},2180);
end

if QUEST_GLOBAL then 

QUEST_GLOBAL().New(0, function()
    -- Check for QUEST GLOBAL VARIABLE is True or not ?
    -- Reference Data.lua  file for more information about this Quest 
    if(QUEST_GLOBAL().Var("Lit_Fire")==true)then 
    return true 
    else 
       displayGlobalQuestText("Lit Campfire to Start the Game")
       toogleProggressBarQuest(false)
    return false 
    end 
end, function()
    -- Action to take when the global quest condition is true
    RUNNER.NEW(function()
        fireCampCutscene()
        for i,a in ipairs(GetAllPlayer()) do 
            generateGuideArrow(a,{clear=true})
        end 
    end,{},1);
    do_standby();
end)


else 

    print("RunTime ERROR, QUEST GLOBAL IS NOT DEFINED YET!")
end 
