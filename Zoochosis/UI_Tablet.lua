local uiid , uiid_values  = {} , "7425842033104460018" ; -- The base string representation

setmetatable(uiid, {
    __tostring = function()
        return uiid_values  -- When uiid is used as a string
    end,
    __index = function(_, key)
        return uiid_values .. "_" .. tostring(key)  -- When accessing uiid as a table with an index
    end, 
    __call = function(self,arg1,arg2)
        if type(arg1) == "string" and arg2 == nil then 
            return rawget(uiid,arg1);
        elseif type(arg1) == "number" and arg2 ~= nil and type(arg2) == "string" then
            self[arg2] = uiid_values.."_"..arg1;
            return(self[arg2]);
        elseif arg1 == nil and arg2 == nil then 
            return uiid_values
        else 
            Player:notifyGameInfo2Self(0,"WRONG USAGE!");
            print("Wrong Usage at calling UI_Tablet");
        end 
    end
})

-- -- Example usage
-- print(tostring(uiid));     -- Output: 7425842033104460018
-- print(uiid[1]);  -- Output: 7425842033104460018_1
-- uiid(2,"button_1"); -- Output: 7425842033104460018_2
-- print(uiid("button_1")); -- Output: 7425842033104460018_1
-- print(uiid()); -- Output: 7425842033104460018


-- Define UI name 
-- Init SLot 
local i =  1; --[[Initialize slot counter ]] for n = 24 , 101 , 7 do     uiid(n,"slot"..i);         i = i + 1 ; end 
local i =  1; --[[Initialize sloticon     ]] for n = 25 , 102 , 7 do     uiid(n,"sloticon"..i);     i = i + 1 ; end 
local i =  1; --[[Initialize slot nickname]] for n = 26 , 103 , 7 do     uiid(n,"slotnick"..i);     i = i + 1 ; end 
local i =  1; --[[Initialize slot nickname]] for n = 28 , 105 , 7 do     uiid(n,"slothpbar"..i);    i = i + 1 ; end 
local i =  1; --[[Initialize slot nickname]] for n = 30 , 107 , 7 do     uiid(n,"slothrbar"..i);    i = i + 1 ; end 
-- Init Category Image Btn 
local i =  1; --[[Initialize Category Button ]] for n = 4 , 22 , 3 do     uiid(n,"Cat_Btn_Img"..i); i = i + 1 ; end 
local i =  1; --[[Initialize Category Button ]] for n = 3 , 21 , 3 do     uiid(n,"Cat_Btn"..i);     i = i + 1 ; end 
-- print(uiid);
uiid(113,"pagetext");uiid(112,"nextpage_btn");
local category = {
    {icon = [[2002001]], name = "Wallaby"  },
    {icon = [[2002002]], name = "Girrafe"  },
    {icon = [[2002003]], name = "Zebra"    },
    {icon = [[2002004]], name = "Penguin"  },
    {icon = [[2002005]], name = "Gorrila"  },
    {icon = [[2002006]], name = "Hippo"    },
    {icon = [[2002007]], name = "Crocodile"},
}

local function filter_data_type (data,type_filter) 
-- data is a list of table that contain table with specific index {data:table , ids:number}
-- where data:table contain index named type 
    local filtered_data = {};
    for i,v in ipairs(data) do
        -- print(i,v);
        local datas = v.data;
        local ids = v.ids;
        if string.lower(datas.name) == string.lower(type_filter) then 
            table.insert(filtered_data,{data = datas , ids = ids});
        end 
    end 
    return filtered_data;
end 

local player_Category = {};
local player_Page = {};
local maximum_item_per_page = 12;

local iconset = {
    danger  = [[10092]],
    happy   = [[10365]],
    hungry  = [[21007]],
    sad     = [[10361]],
}

local function obtain_player_act_mode(playerid)
    local r , v = VarLib2:getPlayerVarByName(playerid, 4, "Nav_Mode");
    if r == 0 then return v end  ;
end

local function load_info_into_slot(info,slot,playerid)
    -- show the Slot 
    Customui:showElement(playerid,uiid(),uiid("slot"..slot));
    local ids = info.ids;
    local data = info.data;
    -- print(id," : " , data)
    local MAX_HP,MAX_HUNGER = data.Attr.MAX_HP,data.Attr.MAX_HUNGER;
    -- get Current Attr Using API 
    local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
    if curHP ~= nil then 
        
        local r,curHR = Creature:getAttr(ids, CREATUREATTR.CUR_HUNGER);

        local long = 106;
        local height = 21;
        local percentHP = (curHP/MAX_HP)*long;
        local percentHR = (curHR/MAX_HUNGER)*long;

        -- set the length bar 
        Customui:setSize(playerid,uiid(),uiid("slothpbar"..slot),percentHP,height)
        Customui:setSize(playerid,uiid(),uiid("slothrbar"..slot),percentHR,height)
        -- set name 
        Customui:setText(playerid,uiid(),uiid("slotnick"..slot),data.nick);

        -- based on percentage HR
        if percentHP > math.floor(long/1.5) and percentHR > long/2 then 
            -- set color 
            Customui:setColor(playerid,uiid(),uiid("slot"..slot),0xffffff);
            -- set icon 
            Customui:setTexture(playerid,uiid(),uiid("sloticon"..slot),iconset.happy);
        else 
            -- set color to yellow 
            Customui:setColor(playerid,uiid(),uiid("slot"..slot),0xffd83d);

            -- check icon 
            if percentHR < long /2 then 
                Customui:setTexture(playerid,uiid(),uiid("sloticon"..slot),iconset.hungry);
            else 
                Customui:setTexture(playerid,uiid(),uiid("sloticon"..slot),iconset.sad);
            end 
        end 
    else 
        -- set name  
        Customui:setText(playerid,uiid(),uiid("slotnick"..slot),"Missing");
        -- set color 
        Customui:setColor(playerid,uiid(),uiid("slot"..slot),0xc6051c);
        -- set icon 
        Customui:setTexture(playerid,uiid(),uiid("sloticon"..slot),iconset.danger);

        -- set the length bar 
        local long = 106;           local height = 21;
        local percentHP = 0;        local percentHR = 0;
        Customui:setSize(playerid,uiid(),uiid("slothpbar"..slot),percentHP,height)
        Customui:setSize(playerid,uiid(),uiid("slothrbar"..slot),percentHP,height)
        
    end 
end

local function init_ui(playerid)
    -- Init player selection
    if player_Category[playerid] == nil then 
        player_Category[playerid] = 1 
    end 
    if player_Page[playerid] == nil then 
        player_Page[playerid] = 1 
    end 

    -- Hide all slots before loading new data
    for i = 1, maximum_item_per_page do
        Customui:hideElement(playerid, uiid(), uiid("slot" .. i))
    end 

    -- Set category buttons textures
    for i = 1, 7 do  -- Assuming there are 7 categories
        Customui:setTexture(playerid, uiid(), uiid("Cat_Btn_Img" .. i), category[i].icon)

        if i == player_Category[playerid] then 
            Customui:setColor(playerid,uiid(),uiid("Cat_Btn"..i),0xffe88c);
        else 
            Customui:setColor(playerid,uiid(),uiid("Cat_Btn"..i),0xffffff);
        end 
    end 

    -- Get selected category name
    local selectedCategory = category[player_Category[playerid]].name
    print("Selected Category: " .. selectedCategory)

    -- Filter data based on category
    local loadedData = filter_data_type(GLOBAL_ANIMAL.SPAWNED, selectedCategory)
    --print(loadedData) -- Resulting on Correct Data;

    -- Calculate pagination
    local currentPage = player_Page[playerid]
    local startIndex = (currentPage - 1) * maximum_item_per_page + 1
    local endIndex = math.min(startIndex + maximum_item_per_page - 1, #loadedData)
    
    -- Load data into slots
    for i = startIndex, endIndex do
        local dataIndex = i - startIndex + 1  -- Convert to 1-based index for slots
        -- print("Loading Data : ",i,dataIndex);
        load_info_into_slot(loadedData[i], dataIndex, playerid)
    end
end

ScriptSupportEvent:registerEvent("UI.Show",function (e)
    -- print(e) it is CustomUI not e.uiid LOL STUPID
    if e.CustomUI == uiid() then 
        local playerid = e.eventobjid;
        init_ui(playerid);
    end 
end)

local function get_slot_info(i, playerid)
    -- Get the current category and page for the player
    local selectedCategory = player_Category[playerid]
    local currentPage = player_Page[playerid]
    
    -- Get the filtered data based on the selected category
    local loadedData = filter_data_type(GLOBAL_ANIMAL.SPAWNED, category[selectedCategory].name)
    
    -- Calculate the index of the item corresponding to the slot
    local startIndex = (currentPage - 1) * maximum_item_per_page + 1
    local slotIndex = startIndex + (i - 1)  -- i is the slot number, we adjust to get the actual item index

    -- Check if the slot index is within the range of available data
    if slotIndex <= #loadedData then
        -- Return the data for this slot
        return loadedData[slotIndex]
    else
        -- Return nil if no data corresponds to this slot
        return nil
    end
end

local function do_act(info,playerid)
    local ids = info.ids;
    local data = info.data;

    -- obtain player mode 
    local player_mode = obtain_player_act_mode(playerid);

    if player_mode == "1" then 
        -- normal mode show an arrow and close the UI ;
        Player:hideUIView(playerid,uiid());
        -- print("Normal Mode");
        -- try to check for creature HP before obtaining it  
            -- get Current Attr Using API 
        local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
        if curHP ~= nil then 
            -- check for Multirunner 
            if RUNNER then 
                -- create arrow 
                RUNNER.NEW(function()
                    Player:notifyGameInfo2Self("Arrow Created Pointing to Target");
                    local size=0.7;   local color=0xffc800;
                    local info=Graphics:makeGraphicsArrowToActor(ids, size, color,1);
                    local dir={x=0,y=10,z=0};  local offset=10;
                    Graphics:createGraphicsArrowByActorToActor(playerid, info, dir, offset)
                end,{},20);
                RUNNER.NEW(function()
                    Graphics:removeGraphicsByObjID(playerid, 1, 5);
                end,{},20*15);
            else 
                print("Multirunner not found!");
            end 
            
        else

            if RUNNER then 
                -- create arrow 
                RUNNER.NEW(function()
                    Player:notifyGameInfo2Self("Arrow Created Pointing to Last Seen Target");
                    local pos = data.position;
                    local size=0.7;   local color=0xffc800;
                    local info=Graphics:makeGraphicsArrowToPos(pos.x, pos.y, pos.z, size, color, 1)
                    local dir={x=0,y=10,z=0};  local offset=10;
                    Graphics:createGraphicsArrowByActorToPos(playerid, info, dir, offset)
                end,{},20);
                RUNNER.NEW(function()
                    Graphics:removeGraphicsByObjID(playerid, 1, 4);
                end,{},20*15);
            else 
                print("Multirunner not found!");
            end 

        end
    elseif player_mode == "2" then
        Player:hideUIView(playerid,uiid());
        if RUNNER then 
            RUNNER.NEW(function()
                Actor:killSelf(playerid)
            end,{},5)
            RUNNER.NEW(function()
                local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
                if curHP ~= nil then 
                    local x,y,z = MYTOOL.GET_POS(ids);
                    Player:reviveToPos(playerid, x,y,z)
                else
                    local pos = data.position;
                    Player:reviveToPos(playerid, pos.x,pos.y,pos.z)
                end 
            end,{},10)
        else 
            print("Multirunner not found!");
        end 
    end 
end

ScriptSupportEvent:registerEvent("UI.Button.Click",function (e)
    -- print(e) 
    if e.CustomUI == uiid() then 
        local playerid = e.eventobjid;
        local elementid = e.uielement;

        for i=1,7 do 
            -- check for category btn 
            if elementid == uiid("Cat_Btn"..i) then 
                player_Category[playerid] =  i;
                init_ui(playerid);
            end  
        end 

        for i=1,12 do 
            -- check for slot click 
            if elementid == uiid("slot"..i) then 
                -- re-obtain information about  the slot clicked
                local slotInfo = get_slot_info(i, playerid);
                do_act(slotInfo,playerid);
            end 
        end 
    end 
end)