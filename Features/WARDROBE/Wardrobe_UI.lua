local uiid = [[7418777786860116210]] 
local UI = { 
    Btn = {

    left = uiid..[[_4]] , 
    right = uiid..[[_5]],
    wear = uiid..[[_1]],
    close = uiid..[[_9]],
    prevpg = uiid..[[_29]],
    nextpg = uiid..[[_27]]
    },
    selector = {
        [1] = uiid..[[_12]],
        [2] = uiid..[[_14]],
        [3] = uiid..[[_16]],
        [4] = uiid..[[_18]],
        [5] = uiid..[[_20]],
        [6] = uiid..[[_22]],
        [7] = uiid..[[_24]]
    },
    icon_selector = {
        [1] = uiid..[[_13]],
        [2] = uiid..[[_15]],
        [3] = uiid..[[_17]],
        [4] = uiid..[[_19]],
        [5] = uiid..[[_21]],
        [6] = uiid..[[_23]],
        [7] = uiid..[[_25]]
    }
}

local playerSelection = {}

local function getskinIco (i)
    return tostring(6000000+i)
end 

local function SpecialEffect4Player(playerid,effectid,size)
    if size > 0 then 
        Actor:playBodyEffectById(playerid,effectid,size)
    else
        Actor:stopBodyEffectById(playerid,effectid)
    end 
end

local originalskin  = {}
-- before attempting  to change the skin, we need to save the original skin of player

local function loadSkin(playerid,i)
    -- store its original skin if not yet
    if originalskin[playerid] == nil then 
        local r,model = Actor:getActorFacade(playerid)
        originalskin[playerid] = model;
    end 
    SpecialEffect4Player(playerid,1253,1)
    Actor:changeCustomModel(playerid,GLOBAL_WARDOBE.SKIN_DATA[i].id)
    Player:playAct(playerid,math.random(1,5)*2)
end

local function cancelSkin(playerid)
    Actor:changeCustomModel(playerid,originalskin[playerid])
end

local function loadForPlayer(playerid)
    if #GLOBAL_WARDOBE.SKIN_DATA < playerSelection[playerid]+7 then 
        for  i = #GLOBAL_WARDOBE.SKIN_DATA , playerSelection[playerid] + 14 do 
            GLOBAL_WARDOBE.RENDER_DATA(i);
            --print("loading more skin ["..#GLOBAL_WARDOBE.SKIN_DATA.."]");
        end 
        
    end 
    -- Calculate page and index range for the current selection
    local page = math.floor((playerSelection[playerid] - 1) / 7) + 1
    local startIndex = (page - 1) * 7 + 1

    -- Loop through the 7 slots (or however many you have on a page)
    for i = 1, 7 do
        local currentIndex = startIndex + i - 1 -- Calculate the actual index based on page and loop
        
        -- Set the texture for the current slot
        local r = Customui:setTexture(playerid, uiid, UI.icon_selector[i], getskinIco(currentIndex))
        if r ~= 0 then Chat:sendSystemMsg("Something is not  right with the icon selector", playerid) end

        -- Set the color: Highlight if currentIndex matches playerSelection, otherwise default color
        if currentIndex == playerSelection[playerid] then
            Customui:setColor(playerid, uiid, UI.selector[i], 0xf1ca1f)  -- Highlight color
        else
            Customui:setColor(playerid, uiid, UI.selector[i], 0xffffff)  -- Default color
        end
    end

    if page > 1 then 
        Customui:showElement(playerid, uiid, UI.Btn.prevpg)
    else 
        Customui:hideElement(playerid, uiid, UI.Btn.prevpg)
    end 

end

ScriptSupportEvent:registerEvent([[UI.Show]],function(e)
    --print("A UI Opened",e);
    local playerid = e.eventobjid; 
    if uiid == e.CustomUI then 
        HIDE_GIMMICK_BTN(playerid) ;
        -- change the camera to front view
        Player:changeViewMode(playerid, 2, false)
        if playerSelection[playerid] == nil then 
            playerSelection[playerid] = 1 ;
        end 
        loadForPlayer(playerid);
        loadSkin(playerid,playerSelection[playerid]);
    end 
end)

ScriptSupportEvent:registerEvent([[UI.Hide]],function(e)
    --print("A UI Opened",e);
    local playerid = e.eventobjid; 
    if uiid == e.CustomUI then 
        SHOW_GIMMICK_BTN(playerid) ;
    end 
end)

ScriptSupportEvent:registerEvent([[UI.Button.Click]],function(e)
    local playerid,uiids,element = e.eventobjid,e.CustomUI,e.uielement;
    if uiid == uiids then 
        if element == UI.Btn.wear then 
            -- close the UI without reverting  the skin to original
            Player:hideUIView(playerid,uiid)--Hide the interface for the player
        end 
        if element == UI.Btn.close then 
            Player:hideUIView(playerid,uiid)--Hide the interface for the player
            -- revert it back 
            cancelSkin(playerid);
        end 
        if element  == UI.Btn.right or  element == UI.Btn.left then 
            if element == UI.Btn.right then 
                playerSelection[playerid] = playerSelection[playerid] + 1;
            end 

            if element == UI.Btn.left then 
                if playerSelection[playerid] > 1 then 
                playerSelection[playerid] = playerSelection[playerid] - 1;
                end 
            end 
            loadSkin(playerid,playerSelection[playerid]);
            loadForPlayer(playerid);
        end 
        -- page btn 
        if element == UI.Btn.nextpg or element == UI.Btn.prevpg then 
            local page = math.floor((playerSelection[playerid] - 1) / 7) + 1
            local startIndex = (page - 1) * 7 + 1

            if  element == UI.Btn.nextpg then 
                playerSelection[playerid] = startIndex + 7;
            end 

            if element == UI.Btn.prevpg then 
                if startIndex - 7 > 0 then 
                playerSelection[playerid] = startIndex - 7;
                end 
            end 

            loadSkin(playerid,playerSelection[playerid]);
            loadForPlayer(playerid);
        end 
        -- selector
        for i = 1 , 7 do 
            if element == UI.selector[i] then 
                -- Calculate page and index range for the current selection
            local page = math.floor((playerSelection[playerid] - 1) / 7) + 1
            local startIndex = (page - 1) * 7 + 1
            playerSelection[playerid] = startIndex + i - 1;
            loadSkin(playerid,playerSelection[playerid]);
            loadForPlayer(playerid);

            end 
        end 
    end 
end)

