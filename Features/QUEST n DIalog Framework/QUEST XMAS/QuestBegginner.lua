
local arrowe = {}

local smallestRange = {};

HX_Q:CREATE_QUEST(0,{
    name = "Captain_Tom_Location", dialog="",
    hint = {x=-3,y=7,z=18},
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local p = playerid;
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = -3 , 7 , 18; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if smallestRange[playerid] == nil then 
            smallestRange[playerid] = dis ;
        else 
            if smallestRange[playerid] + 3 < dis then 
                -- player is moving away from designated location and has to be told to move back
                if  HINT_IS_CREATED(playerid) then 
                    HINT_ARROW:Show(playerid)
                end 
            else 
                if dis < smallestRange[playerid] then 
                    -- record the smallest Range
                    if not HINT_IS_CREATED(playerid) then 
                        HINT_ARROW:Hide(playerid)
                    end 
                    smallestRange[playerid] = dis ;
                end 
            end 
        end 

        if dis <= 9 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            smallestRange[playerid] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Talk to Captain Tom" , pic = [[5000004]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        HX_Q.CURRENT_NPC[playerid] = nil;
        -- Show how to Interact with NPC 
        local UIHINT = "7438421395313989874";
        Player:openUIView(playerid,UIHINT);
        MYTOOL.ADD_EFFECT(-1,8,19,1024,1);
        MYTOOL.ADD_EFFECT(-1,11,19,1025,2);
        RUNNER.NEW(function()
            MYTOOL.DEL_EFFECT(-1,8,19,1024,1);
            MYTOOL.DEL_EFFECT(-1,11,19,1025,2);
        end,{},1000)
    end 
});

local function UI_TUTORIAL(playerid)
    local varName = "UI_Is_Available";
    local varType = 5 ; --Boolean;
    if VarLib2:setPlayerVarByName(playerid, varType, varName,true) == 0 then 
        -- refresh the UI by Reopening it
        local UI = {
            UI = "7418405533454637298",
            Backdrop = "7418405533454637298_57",
            MissionDesc = "7418405533454637298_54",
            DescText = "7418405533454637298_56",
            Backdrop_2 = "7438620754810968306"
        }

        local text = [[Here You can Manage Acquired Mission and Get Reward]]

        if Player:openUIView(playerid,UI.UI) == 0 then 
            -- Successfully reopen the UI;
            Player:openUIView(playerid,UI.Backdrop_2);
            Customui:showElement(playerid,UI.UI,UI.MissionDesc);

            if T_Text then --Check for Translation Feature
                text = T_Text(text);
            end 

            Customui:setText(playerid,UI.UI,UI.DescText,text);
        end 
    end 
end

HX_Q:CREATE_QUEST(28,{
    name = "none",dialog="I’ve been waiting for you, Agent. Santa’s rescue was a big step, but there’s still a lot to do. Check your mission Tab",
    [1] = function(p)
        if HX_Q:GET_CurQuest(p) == "none" then 
            return true; 
        else 
            return false 
        end 
    end, 
    [2] = function(p)
        if HX_Q:GET_CurQuest(p) == "none" then 
            HX_Q:SET_CurQuest(p,"Starter");
        else 
            return true;
        end 
    end,
    [3] = function(p)
        -- Guide to Open Diary Book to track Quest
        RUNNER.NEW(function()
            UI_TUTORIAL(p);
        end,{},10)
    end
});

HX_Q:CREATE_QUEST(28,{
    name = "Quest1", dialog = "You Need to Talk with Chief, So he can Guide you",
    [1] = function(p)
        if HX_Q:GET_CurQuest(p) == "Starter" then 
            return true; 
        else 
            return false 
        end 
    end
})

HX_Q:CREATE_QUEST(28,{
    name = "Quest2", dialog = "I will Stay Here and Wait",
    [1] = function(p)
        return true;
    end
})

HX_Q:CREATE_QUEST(0,{
    name = "INTO_CAFETARIA", dialog = "This Triggered after Cutscene from Tutorial UI that Guide player into Cafetaria",
    hint = {x=-39,y=8,z=142} , 
    [1] = function(p)
        return true 
    end,
    [2] = function(playerid)
        local p = playerid;
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = -39 , 8 , 142; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if smallestRange[playerid] == nil then 
            smallestRange[playerid] = dis ;
        else 
            if smallestRange[playerid] + 3 < dis then 
                -- player is moving away from designated location and has to be told to move back
                if  HINT_IS_CREATED(playerid) then 
                    HINT_ARROW:Show(playerid)
                end 
            else 
                if dis < smallestRange[playerid] then 
                    -- record the smallest Range
                    if not HINT_IS_CREATED(playerid) then 
                        HINT_ARROW:Hide(playerid)
                    end 
                    smallestRange[playerid] = dis ;
                end 
            end 
        end 

        if dis <= 9 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            smallestRange[playerid] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Talk to Chief" , pic = [[3000059]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
       Chat:sendSystemMsg("Tips: You can use the Map to Navigate and Explore Location that Hasn't Explored",p);
    end 
})

local function getDistance2Target(p,x,y,z)
    local r,px,py,pz = Actor:getPosition(p)
    local calculate_distance = function(px, py, pz, x, y, z)
        return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
    end
    return math.floor(calculate_distance(px,py,pz,x,y,z)); 
end

local function DisValidator(playerid,dis)
    if smallestRange[playerid] == nil then 
        smallestRange[playerid] = dis ;
    else 
        if smallestRange[playerid] + 3 < dis then 
            -- player is moving away from designated location and has to be told to move back
            if  HINT_IS_CREATED(playerid) then 
                HINT_ARROW:Show(playerid)
                smallestRange[playerid] = dis + 1;
            end 
        else 
            if dis < smallestRange[playerid] then 
                -- record the smallest Range
                if not HINT_IS_CREATED(playerid) then 
                    HINT_ARROW:Hide(playerid)
                end 
                smallestRange[playerid] = dis ;
            end 
        end 
    end 
end

HX_Q:CREATE_QUEST(0,{
    name = "GUIDED_BY_KARIN", dialog ="",
    hint = {x=-50,y=8,z=39},
    [1] = function(p)
       --  Special Quest Triggered by Cutscene Karin 
    end,
    [2] = function(p)
        local x,y,z = -50 , 8 , 39; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 9 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Visit Black Cat" , pic = [[3000003]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        CUTSCENE:start(p,"GUIDED_BY_KARIN_1");        
    end
})


HX_Q:CREATE_QUEST(0,{
    name = "GUIDED_BY_KARIN_2", dialog ="",
    hint = {x=56,y=7,z=116},
    [1] = function(p)
       --  Special Quest Triggered by Cutscene Karin 
    end,
    [2] = function(p)
        local x,y,z = 56 , 7 , 116; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 9 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Visit Weapon Shop" , pic = [[3000053]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        CUTSCENE:start(p,"GUIDED_BY_KARIN_3");        
    end
})