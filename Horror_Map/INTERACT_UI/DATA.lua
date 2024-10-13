local function exact(d1)
    return d1.playerid,d1.obj,d1.IDs,d1.state;
end
-- Set up a global quest
local function GetAllPlayer()
    -- Call API from MiniWorld to get all players
    -- Return array only if successful
    local result, num, array = World:getAllPlayers(-1)  -- Game API to get all players
    if result == 0 and num > 0 then  -- Result Num 0 means success, num > 0 means players exist
        return array
    end
end
local function playSoundOnPos(x,y,z,whatsound,volume) 
    World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, 1, false)
end 

data_guide = {}
function generateGuideArrow (playerid,data)
    -- check if data is table contain x,y,z 
    if(data.x and data.y and data.z)then 
        local graphinfo = Graphics:makeGraphicsArrowToPos(data.x,data.y,data.z, 0.6, 0xff0000, 1);
        local r,graphid = Graphics:createGraphicsArrowByActorToPos(tonumber(playerid), graphinfo, {x=0,y=10,z=0}, 10);
        data_guide[playerid] = {info = graphinfo , graphid = graphid};
    end 
    -- check if data is table contain objectid
    if(data.objectid)then 
        local graphinfo = Graphics:makeGraphicsArrowToActor(data.objectid, 0.6, 0xff0000, 1);
        local r,graphid = Graphics:createGraphicsArrowByActorToActor(tonumber(playerid), graphinfo, {x=0,y=10,z=0}, 10);
        data_guide[playerid] = {info = graphinfo , graphid = graphid};
    end 

    if data.clear then 
        print(data_guide[playerid]);
        Graphics:removeGraphicsByObjID(playerid, 1, data_guide[playerid].info.Type or 4);
    end 
end 
local function generateHintLight(x,y,z,bol)
    if  bol then 
    local info = Graphics:makeGraphicsImage([[8_1029380338_1722857711]], 0.13, 0xff0000, 2);
    local result = Graphics:createGraphicsImageByPos(x,y,z,info,{x=0,y=3,z=0},30,0,40);
    else 
    Graphics:removeGraphicsByPos(x,y,z, 2, 10)
    end 
end

-- [[Name : Camp Fire]]
INTERACT_DATA_NAME.SET(3,"Lit Fire"); INTERACT_DATA(3,function(d1,d2)
    if(QUEST_GLOBAL().Var("Lit_Fire")=="unset")then 
        local playerid,obj,IDs,state = exact(d1);
        local firematch = d2.itemid;
        local lightblock = d2.light;
        if GLOBAL_BACKPACK.IsItemInBackpack(playerid,firematch) then 
            if GLOBAL_BACKPACK.RemoveItemFromBackpack(playerid,firematch) then 
                local r , x , y , z = Actor:getPosition(obj);
                Block:placeBlock(lightblock,x,y,z);
                World:playParticalEffect(x,y-1,z, d2.fire_effect, 3);
                playSoundOnPos(x,y,z,10537,50);
                GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
                -- This is Quest Data to Trigger the Quest is Finished 
                -- QUEST 1 : Lit The Firecamp;
                -- Accessing The Var to Set it; 
                QUEST_GLOBAL().Var("Lit_Fire",true,"SET");
                for i,a in ipairs(GetAllPlayer()) do 
                    generateGuideArrow(a,{clear = true});
                end 
                -- Quest Finished
            end 
        else 
            Player:notifyGameInfo2Self(playerid,"Need Fire Match to Light");
            Chat:sendSystemMsg("Check the Nearby Tent...",playerid);
            -- Show hint to player 
            -- Generate Arrow to player to direct them to light match position 
            local hx,hy,hz = -10,8,-19;
            generateGuideArrow(playerid,{x=hx,y=hy,z=hz});
            generateHintLight(hx+0.5,hy+0.5,hz+0.5,true);
        end 
    else 
        Player:notifyGameInfo2Self(playerid,"Fire Already Lit");
        for i,a in ipairs(GetAllPlayer()) do 
            generateGuideArrow(a,{clear = true});
        end 
    end 
end,{itemid=4101,light=2004,fire_effect=1395})

-- [[Name : Fire Match]]
INTERACT_DATA_NAME.SET(4,"Pick Up"); INTERACT_DATA(4,function(d1,d2) 
    local playerid,obj,IDs,state = exact(d1);
    if(QUEST_GLOBAL().Var("Lit_Fire")=="unset")then 
    local firematch = d2.itemid;
    Player:playMusic(playerid, 10955, 60,1,false)
    Player:notifyGameInfo2Self(playerid,"Obtain Firematch");
    GLOBAL_BACKPACK.ADD_DATA(playerid,firematch,IDs);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
    local hx,hy,hz = d2.hx,d2.hy,d2.hz;
    for i,a in ipairs(GetAllPlayer()) do 
        generateGuideArrow(a,{clear = true});
    end 
    generateHintLight(hx+0.5,hy+0.5,hz+0.5,false);
    else 
        Player:notifyGameInfo2Self(playerid,"This item doesn't needed");
        for i,a in ipairs(GetAllPlayer()) do 
            generateGuideArrow(a,{clear = true});
        end 
    end 
end,{itemid=4101,hx=-11,hy=7,hz=-34});

-- [[ Name : handgun ]]
INTERACT_DATA_NAME.SET(7,"Pick Up"); INTERACT_DATA(7,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local handgun = d2.itemid;
    Customui:setState(playerid, "7405783316061427954", "7405783316061427954-Status2")
    Player:playMusic(playerid, 10955, 60,1,false);
    Player:notifyGameInfo2Self(playerid,"Obtain Handgun");
    GLOBAL_BACKPACK.ADD_DATA(playerid,handgun,IDs);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
end,{itemid=4106})

--[[ NAME : RIFLE M4A1 ]]
INTERACT_DATA_NAME.SET(8,"Buy/Watch Ads"); INTERACT_DATA(8,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Best Weapon To Increase your Survival Rate! Easy to Use");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4116})

--[[ NAME : BARRET ]]
INTERACT_DATA_NAME.SET(9,"Buy/Watch Ads"); INTERACT_DATA(9,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Best Weapon Against Tanky Monster and Horde! Easy to Fight");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4117})

--[[ NAME : RPG ]]
INTERACT_DATA_NAME.SET(10,"Buy/Watch Ads"); INTERACT_DATA(10,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Bring Explosive to The Game and Have Fun! ");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4118})

--[[ NAME : Javelin ]]
INTERACT_DATA_NAME.SET(11,"Buy/Watch Ads"); INTERACT_DATA(11,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local shopid = d2.shopid;
    Player:openDevGoodsBuyDialog(playerid, shopid, "Monsters Will Goes Kaboom! So Fun! ");
    -- Player:openDevGoodsBuyDetailedDialog(playerid,shopid)
end,{shopid = 4120})

-- [[Name : Mechanical Part]]
INTERACT_DATA_NAME.SET(18,"Pick Up"); INTERACT_DATA(18,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local mechpart = d2.itemid;
    if not GLOBAL_BACKPACK.IsItemInBackpack(playerid,mechpart) then 
    Player:playMusic(playerid, 10955, 60,1,false)
    Player:notifyGameInfo2Self(playerid,"#G"..T_Text(playerid,"Picked Up Mechanical Part"));
    GLOBAL_BACKPACK.ADD_DATA(playerid,mechpart,IDs);
    GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
    -- Delete the obj 
    local r = World:despawnActor(obj);
    else 
        Player:notifyGameInfo2Self(playerid,"#Y"..T_Text(playerid,"Cannot Carry More Mechanical Part"));
    end 
end,{itemid=4128})

local function startRepairingDiesel(playerid,obj)
    if DIESEL_GENERATOR.ALIVE(obj) then 
        Player:notifyGameInfo2Self(playerid,"#Y"..T_Text(playerid,"The Diesel is Already Alive"));
    else 
        -- Chat:sendSystemMsg("playerid : "..playerid.." Repairing Obj : "..obj);
        DIESEL_GENERATOR.ADD_REPAIRMAN(obj,playerid);
    end 
end
-- Function to check if a value exists in a table
local function valueExists(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true  -- Value found
        end
    end
    return false  -- Value not found
end

local function registerNewDiesel2Quest(obj)
    -- Inititate If not Initatetd
    if QUEST_GLOBAL().Var("DieselOn") == "unset" then 
        QUEST_GLOBAL().Var("DieselOn",{},"SET") 
    end 

    -- Adjust the Name 
    local name = "D"..obj;

    -- Get Current DieselOn On table 
    local tempData = QUEST_GLOBAL().Var("DieselOn")
    if not valueExists(tempData,name) then 
    -- check if the value is already Exist on tempTable Data 
    table.insert(tempData,name);
    -- Update the Temporary data into Real Data
    QUEST_GLOBAL().Var("DieselOn",tempData,"SET");
    end 
end

-- [[Name  : Diesel Generator ]]
INTERACT_DATA_NAME.SET(16,"Repair"); INTERACT_DATA(16,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local mechpart = d2.itemid;
    local status = QUEST_GLOBAL().Var("D"..obj);
    if(status=="unset")then 
        if GLOBAL_BACKPACK.IsItemInBackpack(playerid,mechpart) then 
            if GLOBAL_BACKPACK.RemoveItemFromBackpack(playerid,mechpart) then 
            QUEST_GLOBAL().Var("D"..obj,1,"SET");
            registerNewDiesel2Quest(obj);
            startRepairingDiesel(playerid,obj);
            GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
            end;
        else 
            Player:notifyGameInfo2Self(playerid,"#R"..T_Text(playerid,"You Need Mechanical Part to Repair Diesel Generator"));
        end 
    else 
        startRepairingDiesel(playerid,obj);
    end 
end,{itemid=4128})

-- [[ Name : Switch ]]

local function switchOn(obj)
     -- Inititate If not Initatetd
     if QUEST_GLOBAL().Var("switchOn") == "unset" then 
        QUEST_GLOBAL().Var("switchOn",{},"SET") 
    end 

    -- Adjust the Name 
    local name = "S"..obj;

    -- Get Current Switch On table 
    local tempData = QUEST_GLOBAL().Var("switchOn")
    if not valueExists(tempData,name) then 
    -- check if the value is already Exist on tempTable Data 
    table.insert(tempData,name);
    QUEST_GLOBAL().Var("switchOn",tempData,"SET");
    end 
end

INTERACT_DATA_NAME.SET(17,"Turn On"); INTERACT_DATA(17,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local dieselProggress = 0;
    local Diesels =  QUEST_GLOBAL().Var("DieselOn") ;
    if Diesels ~= "unset" then 
        for i,a in ipairs(Diesels) do 
            -- check each diesel Value 
            -- if it has 100 means it is done 
            if QUEST_GLOBAL().Var(a) == 100 then 
                print(QUEST_GLOBAL().Var(a));
                dieselProggress  = dieselProggress + 1;
            end 
        end 
    end 
    local diesel_Required = 5
        if #GetAllPlayer() > 2 then
            diesel_Required = 10;
        end 
    if dieselProggress >= diesel_Required or QUEST_GLOBAL().Var("LeverSwitch") == "TRUE" then 
        switchOn(obj);
        local p = QUEST_GLOBAL().Var("switchOn");
        Actor:playAct(obj,18);
        QUEST_GLOBAL().Var("Switch",#p,"SET");
    else 
        Player:notifyGameInfo2Self(playerid,T_Text(playerid,"The Power is Not Restored yet"))
    end 
end,{})


-- [[ Name Paper Hint ]]

INTERACT_DATA_NAME.SET(19,"Read"); INTERACT_DATA(19,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1); 
    HINT_PAPER.OPEN(playerid,obj);
end)

-- [[ Medkit ]]
INTERACT_DATA_NAME.SET(20,"Pick Up"); INTERACT_DATA(20,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    local medkit = d2.itemid;
    if not GLOBAL_BACKPACK.IsItemInBackpack(playerid,medkit) then 
        Player:playMusic(playerid, 10955, 60,1,false);
        Player:notifyGameInfo2Self(playerid,"Obtain Medkit");
        GLOBAL_BACKPACK.ADD_DATA(playerid,medkit,IDs);
        GLOBAL_BACKPACK.UPDATE_FOR_PLAYER(playerid);
     -- Delete the obj 
     local r = World:despawnActor(obj);
    else 
        Player:notifyGameInfo2Self(playerid,"#Y"..T_Text(playerid,"Cannot Carry More Medkit"));
    end 
end,{itemid=4131})

--[[ Laptop ]]
INTERACT_DATA_NAME.SET(23,"Look At Screen"); INTERACT_DATA(23,function(d1,d2)
    local playerid,obj,IDs,state = exact(d1);
    Player:openUIView(playerid,"7420374329283254514")
end,{})

