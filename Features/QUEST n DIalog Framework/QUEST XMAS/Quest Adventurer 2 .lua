local arrowe = {};
local smallestRange = {};

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

HX_Q:CREATE_QUEST(78,{
    name = "Mission_2" , dialog = "Our Supply For Red Mushroom is Only Few. Can You Help Us Harvest Red Mushroom?", 
    hint = {x=121,y=20,z=301},
    [1] = function(p)
        if HX_Q:GET(p,[[IS_QUEST_MISSION_1]]) == "DONE" and HX_Q:GET(p,[[IS_QUEST_MISSION_2]]) == "Empty" then  
            return true;
        end 
    end,
    [2] = function(p)
        local x,y,z = 121,20,301; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Mushroom Cave(0/5)" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_2_Part_1",78)    
        end,{},1)
    end
})



HX_Q:CREATE_QUEST(78,{
    name = "Mission_2_Part_1" , dialog = "Continues_Part_Quest_1", 
    hint = {x=120,y=15,z=310},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 120,15,310; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Mushroom Cave(1/5)" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_2_Part_2",78)    
        end,{},1)
    end
})



HX_Q:CREATE_QUEST(78,{
    name = "Mission_2_Part_2" , dialog = "Continues_Part_Quest_2", 
    hint = {x=95,y=7,z=298},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 95,7,298; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Mushroom Cave(2/5)" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_2_Part_3",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_2_Part_3" , dialog = "Continues_Part_Quest_3", 
    hint = {x=96,y=7,z=356},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 96,7,356; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Mushroom Cave(3/5)" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_2_Part_4",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_2_Part_4" , dialog = "Continues_Part_Quest_4", 
    hint = {x=144,y=7,z=389},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 144,7,389; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Mushroom Cave(4/5)" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"RED_MUSHROOM");
        end,{},1)
    end
})

CUTSCENE:CREATE("RED_MUSHROOM",{
    [1] = function(p)
        CUTSCENE:setCamera(156,7,390,p);
    end,
    [5] = function(p)
        CUTSCENE:setrotCamera(80,15,1,p);
    end,
    [20] = function(p)
        CUTSCENE:setText(p,"There is So Many Mushroom Here");
        Actor:tryMoveToActor(CUTSCENE.PLAYER_CAMERA[p],p,1);
    end,
    [60] = function(p)
        return true;
    end,
    ["END"] = function(p)
        MISSION_TRACKER:SET_UNLOCKED(p,[[COLLECT_20_RED_MUSHROOM]]);
        RunQuest(p,"COLLECT_RED_MUSHROOM",78)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "COLLECT_RED_MUSHROOM", dialog = "non dialog",
    hint = {158,7,387},
    [1] = function(p)
        return false; 
        -- unavailable by clicking default; 
    end,
    [2] = function(p)
        if HX_Q:GET(p,"RED_MUSHROOM_20") == "Empty" then 
            -- set into number 0 ;
            HX_Q:SET(p,"RED_MUSHROOM_20",0);
        end 
        local mushroom = 4210;
        local Proggress = MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(p,mushroom)
        HX_Q:SET(p,"RED_MUSHROOM_20",Proggress);
        local maks = 20;
        if Proggress < maks then
            HX_Q:SHOW_QUEST(p, { open=true,text = "Collect Red Mushroom" , pic = [[1004210]] , detail="( "..Proggress.."/"..maks..") Harvested"});
        else
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"RED_MUSHROOM_COMPLETED_PART_1",78);    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "RED_MUSHROOM_COMPLETED_PART_1" , dialog = "Part1", 
    hint = {x=124,y=7,z=387},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 124,7,387; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"RED_MUSHROOM_COMPLETED_PART_2",78);    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "RED_MUSHROOM_COMPLETED_PART_2" , dialog = "Part2", 
    hint = {x=115,y=21,z=299},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 115,21,299; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Quest2_WOLF_CAPTAIN_COMPLETED");
        end,{},1)
    end
})

local function DialogSay(p,text,dur,yaw,pitch)
    local Karin = CUTSCENE.DOLLS[p][1];
    Actor:setFaceYaw(Karin,yaw)
    Actor:setFacePitch(Karin,pitch)
    CUTSCENE:showChat(Karin,text,1,dur,230);
    CUTSCENE:setText(p,"Captain Wolf : "..text);
end

CUTSCENE:CREATE("Quest2_WOLF_CAPTAIN_COMPLETED",{
    [1] = function(p)
        CUTSCENE:setText(p,"")
        CUTSCENE:setCamera(107,21,300,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(276,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],104,21,302);
    end,
    [40] = function(p)
        local text = "Thank You Adventurer";
        DialogSay(p,text,2,180,14);
    end,
    [130] = function(p)
        local text = "You Have Helped us Collecting Red Mushroom";
        DialogSay(p,text,2,180,14);
    end,
    [250] = function(p)
        local text = "To Recieve Quest Rewards. Check Your Mission Tab.";
        DialogSay(p,text,2,180,14);
    end,
    [320] = function(p)
        local text = "When You Are Ready. Talk to Me Again to Recieve Your Next Mission.";
        DialogSay(p,text,2,180,14);
    end,
    [400] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,[[IS_QUEST_MISSION_2]],"DONE");
    end
})

-- Mining Quest 
HX_Q:CREATE_QUEST(78,{
    name = "Mission_3" , dialog = "Santa's Magic is Weakened. Minion Cannot Mine the Red Crystal. Can you Help Us?", 
    hint = {x=121,y=20,z=301},
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_1]])     == "DONE" 
            and HX_Q:GET(p,[[IS_QUEST_MISSION_2]]) == "DONE" 
            and HX_Q:GET(p,[[IS_QUEST_MISSION_3]]) == "Empty"
        then  
            return true;
        end 
    end,
    [2] = function(p)
        local x,y,z = 121,20,301; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(0/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_3_Part_1",78)    
        end,{},1)
    end
})



HX_Q:CREATE_QUEST(78,{
    name = "Mission_3_Part_1" , dialog = "Continues_Part_Quest_1", 
    hint = {x=120,y=15,z=310},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 120,15,310; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(1/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_3_Part_2",78)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Mission_3_Part_2" , dialog = "Continues_Part_Quest_2", 
    hint = {x=95,y=7,z=298},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 95,7,298; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(2/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_3_Part_3",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_3_Part_3" , dialog = "Continues_Part_Quest_3", 
    hint = {x=7,y=7,z=158},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 7,7,158; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <=10 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(3/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_3_Part_4",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_3_Part_4" , dialog = "Continues_Part_Quest_4", 
    hint = {x=50,y=7,z=0},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 50,7,0; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <=5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(4/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mission_3_Part_5",78)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Mission_3_Part_5" , dialog = "Continues_Part_Quest_5", 
    hint = {x=107,y=7,z=-41},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 107,7,-41; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <=5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Red Crystal Cave(5/6)" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Buy_Pickaxe_From_Martin",78)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Buy_Pickaxe_From_Martin", dialog ="Non Dialog Quest",
    hint = {x=97,y=7,z=-58},
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local tools = {11016,11015,11014,11013};
        local result = false;
        
        for i,a in ipairs(tools) do 
            if MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(p,a) > 0 then
                result = true;
                break;
            end 
        end

        if not result then 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Buy Pickaxe from Martin" , pic = [[3000040]] , detail="Click for Hint"});
        else 
            HX_Q:SET(p,"Have_Pickaxe","TRUE");
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end;
    end , 
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Get_In_To_Red_Crystal_Cave",78)    
        end,{},1)
    end 
})

HX_Q:CREATE_QUEST(78,{
    name="Get_In_To_Red_Crystal_Cave",dialog="Non Dialog Quest",
    hint = {x=160,y=7,z=-62},
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 161,7,-62; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <=5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go to Red Crystal Cave Enterance" , pic = [[3000035]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Mining_Red_Crystal_Cave",78)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Mining_Red_Crystal_Cave",dialog ="Non Dialog Quest",
    hint = {x=160,y=7,z=-62},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        if HX_Q:GET(p,"RED_CRYSTAL_40") == "Empty" then 
            -- set into number 0 ;
            HX_Q:SET(p,"RED_CRYSTAL_40",0);
        end 
        local red_crystal = 4139;
        local Proggress = MYTOOL.GET_NUM_OF_ITEMS_OF_PLAYER(p,red_crystal)
        HX_Q:SET(p,"RED_CRYSTAL_40",Proggress);
        local maks = 40;
        if Proggress < maks then
            HX_Q:SHOW_QUEST(p, { open=true,text = "Collect Red Crystal" , pic = [[1004139]] , detail="( "..Proggress.."/"..maks..") Collected"});
        else
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Finish_Mining_Red_Crystal_Cave",78)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name="Finish_Mining_Red_Crystal_Cave",dialog="Non Dialog Quest",
    hint = {x=115,y=7,z=-57},
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 115,7,-57; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <=5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Talk to Martin and Sell Red Crystal", detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal]],78);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(40,{

    name = "Checky" , dialog = "Do you want to Sell Red Crystal?",
    [1] = function(p)
        return true; 
    end,["END"] = function(p)
        -- open Redeem Exhange item Red Crystal.
        local red_crystal = 4139;
        REDEEM_ITEM:OPEN(p,red_crystal,20);
    end

})

HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        if HX_Q:GET(p,"RED_CRYSTAL_40_SELL") == "Empty" then 
            HX_Q:SET(p,"RED_CRYSTAL_40_SELL",0);
        end 

        local proggres = tonumber(HX_Q:GET(p,"RED_CRYSTAL_40_SELL"));
        local maks = 40
        if proggres < maks then 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Sell Red Crystal to Martin", detail="( "..proggres.. "/"..maks.." ) Sold"});
        else
            HX_Q:SHOW_QUEST(p, { open=false})
            return true;
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete]],78);
        end,{},1)
    end 
})


HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 24,7,31; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete_1]],78);
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete_1]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 6,7,176; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 12 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete_2]],78);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete_2]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 100,8,299; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete_3]],78);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete_3]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 116,13,312; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete_4]],78);
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete_4]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 124,19,304; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,[[Sell_Red_Crystal_Complete_5]],78);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = [[Sell_Red_Crystal_Complete_5]] , dialog = "non dialog",
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = 109,21,301; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Captain Wolf" , pic = [[1004210]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        CUTSCENE:start(p,"Complete_Red_Crystal_Tutorial");
    end
})

CUTSCENE:CREATE("Complete_Red_Crystal_Tutorial",{
    [1] = function(p)
        CUTSCENE:setText(p,"")
        CUTSCENE:setCamera(107,21,300,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(276,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],104,21,302);
    end,
    [20] = function(p)
        local text = "Great Job Adventurer";
        DialogSay(p,text,2,180,14);
    end,
    [100] = function(p)
        local text = "You Have Helped us Collecting Red Crystal";
        DialogSay(p,text,2,180,14);
    end,
    [190] = function(p)
        local text = "To Continue Your Journey You Need to Find Master of Sword";
        DialogSay(p,text,2,180,14);
    end,
    [290] = function(p)
        local text = "His name is Xuyou and Should Live inside the Village";
        DialogSay(p,text,2,180,14);
    end,
    [390] = function(p)
        local text = "Come Back here When You Have Trained";
        DialogSay(p,text,2,180,14);
    end,
    [490] = function(p)
        return true;
    end,
    ["END"] = function(p)
        -- unlock Mission 
        MISSION_TRACKER:SET_UNLOCKED(p,[[Find_Xuyou]]);
        HX_Q:SET(p,[[IS_QUEST_MISSION_3]],"DONE");
    end
})

ScriptSupportEvent:registerEvent("REDEEM_ITEM",function (e)
    local playerid = e.eventobjid;
    local itemid = e.itemid;
    if HX_Q:GET(playerid ,"RED_CRYSTAL_40_SELL") ~= "Empty" then
        local red_crystal = 4139;
        if itemid == red_crystal then
            -- if it is redeeming red crystal 
            local proggres = tonumber(HX_Q:GET(playerid,"RED_CRYSTAL_40_SELL"));
            local maks = 40;
            local num = e.itemnum ;
            if proggres < maks then
                HX_Q:SET(playerid,"RED_CRYSTAL_40_SELL",math.min(proggres+num,40))
            end
        end 
    end 
end)

-- Finishing Quest;
HX_Q:CREATE_QUEST(78,{
    name = "Mission_4" , dialog = "You Need To Find Xuyou he Can Help you about the Darkness", 
    hint = {x=-87,y=15,z=151},
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_1]])     == "DONE" 
            and HX_Q:GET(p,[[IS_QUEST_MISSION_2]]) == "DONE" 
            and HX_Q:GET(p,[[IS_QUEST_MISSION_3]]) == "DONE"
            and HX_Q:GET(p,[[Swordman_3]]) == "Empty"
        then  
            return true;
        end 
    end,
    [2] = function(p)
        local x,y,z = -87,15,151; 
        local dis = getDistance2Target(p,x,y,z);
    
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Find Xuyou" , pic = [[3000013]] , detail="Click For Hint"});
            -- create Graphic info on Location  
        end 
    end,
    [3] = function(p)
        
    end 
})
