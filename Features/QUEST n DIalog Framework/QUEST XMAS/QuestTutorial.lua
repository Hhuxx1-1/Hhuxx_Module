local arrowe = {};
HX_Q:CREATE_QUEST(0,{
    name = "none", dialog = "",
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = -151 , 7 , -190; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if dis <= 36 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            HX_Q:DeletePointingArrowForPlayer(playerid,arrowe[playerid])
            arrowe[playerid] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Follow the Path " , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[playerid] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(playerid,x,y,z,1);
                arrowe[playerid] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)    
        Player:setRevivePoint(playerid,-151 , 7 , -190);
        HX_Q.CURRENT_NPC[playerid] = nil;
        HX_Q:SET(playerid,"1MISSION_TUTORIAL","MISSION_UNLOCKED");
        CUTSCENE:start(playerid,"FIGHT_TUTORIAL")
    end 
})

HX_Q:CREATE_QUEST(0,{
    name = "hellHound_Tutorial", dialog = "",
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local x,y,z = -151 , 7 , -153; 
        -- calculate number of Hellhound from center within 80 block Radius from center 
        local OBJ = MYTOOL.getObj_Area(x,y,z,80,10,80);
        local count = 0;
        local idHound = 48;
        local Objids = MYTOOL.filterObj("Creature",OBJ); 
        for i,objid in ipairs(Objids) do
            -- check modelID 
            local r,modelID = Creature:getActorID(objid);
            if modelID == idHound then 
                count = count + 1;
            end 
        end 
        if count > 0 then 
        HX_Q:SHOW_QUEST(playerid, { open=true,text = " Defeat All Hellhound " , detail=count.." Enemies Left "});
        else 
            HX_Q:SHOW_QUEST(playerid, { open=false});
            return true;
        end 
    end,
    [3] = function(playerid)    
        Player:setRevivePoint(playerid,-151 , 7 , -153);
        HX_Q.CURRENT_NPC[playerid] = nil;
        CUTSCENE:start(playerid,"FIGHT_TUTORIAL_COMPLETE")
    end 
});

HX_Q:CREATE_QUEST(0,{
    name = "hellHoundBOSS_Tutorial", dialog = "",
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local x,y,z = 21 , 7 , -225; 
        -- calculate number of Hellhound from center within 80 block Radius from center 
        local OBJ = MYTOOL.getObj_Area(x,y,z,80,10,80);
        local count = 0;
        local idHound = 50;
        local Objids = MYTOOL.filterObj("Creature",OBJ); 
        for i,objid in ipairs(Objids) do
            -- check modelID 
            local r,modelID = Creature:getActorID(objid);
            if modelID == idHound then 
                count = count + 1;
            end 
        end 
        if count > 0 then 
            -- pass ignore 
        else 
            -- finished Boss Quest 
            return true;
        end 
    end,
    [3] = function(playerid)    
        Player:setRevivePoint(playerid,21 , 7 , -235);
        HX_Q.CURRENT_NPC[playerid] = nil;
        CUTSCENE:start(playerid,"TUTORIAL_FINISHED")
    end 
});



HX_Q:CREATE_QUEST(0,{
    name = "Tutorial_Part1", dialog="",
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = -151 , 7 , -248; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if dis <= 10 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            HX_Q:DeletePointingArrowForPlayer(playerid,arrowe[playerid])
            arrowe[playerid] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Follow the Path " , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[playerid] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(playerid,x,y,z,1);
                arrowe[playerid] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        HX_Q.CURRENT_NPC[playerid] = nil;
        CUTSCENE:start(playerid,"FIGHT_TUTORIAL_PART_1")
    end 
});

HX_Q:CREATE_QUEST(0,{
    name = "Tutorial_Part2", dialog="",
    [1] = function()
        return true;
    end,
    [2] = function(playerid)
        local r,px,py,pz = Actor:getPosition(playerid)
        local x,y,z = 8 , 7 , -255; 
        local calculate_distance = function(px, py, pz, x, y, z)
            return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
        end
        local dis = math.floor(calculate_distance(px,py,pz,x,y,z));
        
        if dis <= 10 then
            HX_Q:SHOW_QUEST(playerid, { open = false});
            HX_Q:DeletePointingArrowForPlayer(playerid,arrowe[playerid])
            arrowe[playerid] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(playerid, { open=true,text = "Follow the Path " , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[playerid] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(playerid,x,y,z,1);
                arrowe[playerid] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        HX_Q.CURRENT_NPC[playerid] = nil;
        CUTSCENE:start(playerid,"FIGHT_BOSS_TUTORIAL")
    end 
});

local function set2FarPosition(playerid,x,y,z)
    if Actor:killSelf(playerid) == 0 then 
        Player:reviveToPos(playerid,x,y,z)
    end 
end

local startBuff = 50000009;

-- Check for Start Button 
ScriptSupportEvent:registerEvent("Player.AddBuff",function(e)
    -- Obtain Buff id and Check 
    local buffid = e.buffid;
    local playerid = e.eventobjid;
    if buffid == startBuff then 

        if HX_Q:GET_CurQuest(playerid) == "none" then 
            local tutorialStatus = tonumber(HX_Q:GET(playerid,"TUTORIAL"));
            if tutorialStatus ~= 3 then 
                if HX_Q.CURRENT_QUEST[playerid]  == nil then
                
                        HX_Q:SET(playerid,"TUTORIAL",0);
                        set2FarPosition(playerid,-156,7,-102)
                        CUTSCENE:start(playerid,"FIRST_START")
                    
                end 
            else 
                -- start on Santa's House 
                set2FarPosition(playerid,106,8,34);
            end  
        elseif HX_Q:GET_CurQuest(playerid) == "Cafetaria" then
            -- this means that Player has Started the Cafetaria Quest and need to finish the whole tutorial. 
            CUTSCENE:start(playerid,"Going Arround the Village");
        elseif HX_Q:GET_CurQuest(playerid) == "Adventurer" then             
            -- start on Weapon Shop Second Floor
            -- check if player has Home Point Set 
            local x = HX_Q:GET(playerid,[[X_HOME]]);
            local y = HX_Q:GET(playerid,[[Y_HOME]]);
            local z = HX_Q:GET(playerid,[[Z_HOME]]);
            if x ~= "Empty" and y ~= "Empty" and z ~= "Empty" then
                -- Player has Home Point Set, so start on Home Point
                Player:setRevivePoint(playerid,tonumber(x),tonumber(y),tonumber(z));
                set2FarPosition(playerid,tonumber(x),tonumber(y),tonumber(z));
            else
                Player:setRevivePoint(playerid,52,16,145);
                set2FarPosition(playerid,52,16,145);
            end 
            RUNNER.NEW(function()
                HX_Q:PLAY_MUSIC(playerid,10);
            end,{},20)
        end 
    elseif buffid == 50000014 then
        if HX_Q:GET_CurQuest(playerid) == "Starter" then 
            -- this means that player is Actually just finished the Captain Tom Mission Tutorial UI.
            -- Continue Guiding the player into Cafetaria 
            if HX_Q:GET(playerid,"BEFORE_INTO_CAFETARIA") ~= "TRUE" then  
                CUTSCENE:start(playerid,"INTO_CHIEF");
            end 
        end 
    end
end)

ScriptSupportEvent:registerEvent("Player.ChangeAttr",function(e)
    local playerid = e.eventobjid;
    local playerattr = e.playerattr;
    -- local val = e.playerattrval;
    local r, val = Player:getAttr(playerid,2);
    local isTutorial = HX_Q:GET(playerid,"TUTORIAL");
    if isTutorial == 0 then 
        if playerattr == 2 and val < 1 then 
            
            -- Chat:sendSystemMsg("Player is Died?")
            CUTSCENE:start(playerid,"DEFEATED_ON_TUTORIAL")
        end 
    elseif isTutorial == 1 then
        -- lost by Boss 
        if playerattr == 2 and val < 1 then 
            
            -- Chat:sendSystemMsg("Player is Died?")
            CUTSCENE:start(playerid,"DEFEATED_ON_TUTORIAL_BOSS")
        end 
    end 
end)

-- Chief Quest 
HX_Q:CREATE_QUEST(59,{
    name = "Quest1", dialog ="Santa has Mentioned you. Before we discuss your mission, take a moment to meet the villagers."
    ,
    [1] = function(p)
        if HX_Q:GET_CurQuest(p) == "Starter" then 
            return true; 
        else 
            return false; 
        end 
    end,
    [2] = function(p)
        if HX_Q:GET_CurQuest(p) == "Starter" then 
            HX_Q:SET_CurQuest(p,"Beginner"); 
        else 
            return true; 
        end 
    end,
    [3] = function(p)
        CUTSCENE:start(p,[[Going Arround the Village]]);
    end
})