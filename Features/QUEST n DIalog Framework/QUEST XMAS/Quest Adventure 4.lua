
HX_Q:CREATE_QUEST(78,{
    name = "Light_Journey_1" , dialog = "You Looks Stronger. You Are Ready for Next Mission.", 
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_1]])     == "DONE" 
        and HX_Q:GET(p,[[IS_QUEST_MISSION_2]])     == "DONE" 
        and HX_Q:GET(p,[[IS_QUEST_MISSION_3]])     == "DONE"
        and HX_Q:GET(p,[[Swordman_3]])             == "DONE"
        and HX_Q:GET(p,[[Light_Warrior_Cutscene]]) == "Empty"
        then 
            return true;
        else
            return false;
        end 
    end,["END"] = function(p)
        CUTSCENE:start(p,"Light_Journey_1_Cutscene")
    end
})

CUTSCENE:CREATE("Light_Journey_1_Cutscene",{
    [1] = function(p)
        CUTSCENE:setText(p,"")
        CUTSCENE:setCamera(107,21,300,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(276,15,1,p);
        CUTSCENE:createDoll(p,[[mob_78]],104,21,302);
    end,
    [20] = function(p)
        local text = "You Seems Ready";
        CUTSCENE:DialogSay(1,"Captain Wolf",p,text,2,180,14);
    end,
    [100] = function(p)
        local text = "To Continue Your Mission Defeating Dark Lord";
        CUTSCENE:DialogSay(1,"Captain Wolf",p,text,2,180,14);
    end,
    [190] = function(p)
        local text = "Go Find Light Warrior Near The Lumina Gate";
        CUTSCENE:DialogSay(1,"Captain Wolf",p,text,2,180,14);
    end,
    [290] = function(p)
        local text = "Talk to Him and He Will Give You Access to Places You Should Go";
        CUTSCENE:DialogSay(1,"Captain Wolf",p,text,2,180,14);
    end,
    [390] = function(p)
        local text = "Thank You Very Much for Everything";
        CUTSCENE:DialogSay(1,"Captain Wolf",p,text,2,180,14);
    end,
    [490] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,[[Captain_Wolf_Last_Cutscene]],"DONE");
        RUNNER.NEW(function()
            RunQuest(p,"Find_Warrior_Light",78);
        end,{},1)
    end
})



local function getDistance2Target(p,x,y,z)
    local r,px,py,pz = Actor:getPosition(p)
    local calculate_distance = function(px, py, pz, x, y, z)
        return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
    end
    return math.floor(calculate_distance(px,py,pz,x,y,z)); 
end


HX_Q:CREATE_QUEST(78,{
    name = "Find_Warrior_Light", dialog = "Non Dialog",
    hint = {x=-18,y=8,z=465},
    [1] = function(p)
        return false;
    end ,
    [2] = function(p)
        local x,y,z = -18,8,465; 
        local dis = getDistance2Target(p,x,y,z);
    
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Talk to Light Warrior" , pic =  [[3000060]] , detail="Click For Hint"});
            -- create Graphic info on Location  
        end 
    end , 
    [3] = function(p)
        RUNNER.NEW(function()
            MYTOOL.ADD_EFFECT(-17.5,8,464.5,1024,1);
            MYTOOL.ADD_EFFECT(-17.5,11,464.5,1025,2);
            RUNNER.NEW(function()
                MYTOOL.DEL_EFFECT(-17.5,8,464.5,1024,1);
                MYTOOL.DEL_EFFECT(-15.5,11,464.5,1025,2);
            end,{},2000)    
        end,{},1)
    end 
})

HX_Q:CREATE_QUEST(60,{
    name = "A_Mission", dialog = "So You Are The Choosen One?",
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_3]])     == "DONE"
        and HX_Q:GET(p,[[Swordman_3]])             == "DONE"
        and HX_Q:GET(p,[[Light_Warrior_Cutscene]]) == "Empty"
        then 
            return true;
        else
            return false;
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"The_Light_Warrior_Cutscene")
        end,{},1)
    end
})

local checkRequirementTungstenFullset = function(playerid)
    local result = {title = "Requirements",desc = "Wear Full-Set of Tungsten Armor"}
    local sResult = true;
    for resid = 1,4 do 
        local itemid = resid + 12240
        local R = Player:isEquipByResID(playerid, itemid)
        local r,iconid = Customui:getItemIcon(itemid)
        if R == 0 then 
            result[resid] = {
                url = iconid,
                check = true,
                text = "Equipped"
            }
        else 
            result[resid] = {
                url = iconid,
                check = false,
                text = "Not Equipped"
            }
            sResult = false; --One of the Thing is Not Equipped
        end 
    end 

    if not sResult then 
        REQUIREMENT_UI:open(playerid,result);
    else 
        return true;
    end 

end

CUTSCENE:CREATE("The_Light_Warrior_Cutscene",{
    [1] = function(p)
        CUTSCENE:setCamera(-21,7,465,p)
        CUTSCENE:setrotCamera(270,15,1,p)
        CUTSCENE:createDoll(p,[[mob_30]],-19,7,465,5)
    end,
    [20] = function(p)
        local text = "Let's Be Clear"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end,
    [100] = function(p)
        local text = "I Cannot Open This Gate"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end ,
    [180] = function(p)
        local text = "Only If You Have The Key"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end ,
    [260] = function(p)
        local text = "Only Those Accepted by Lumina the Guardian Angel Can Pass"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end ,
    [340] = function(p)
        local text = "I Will Give you The Access to Lumina Room"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end ,
    [420] = function(p)
        local text = "Only If You Has Full Tungsten Armor Equipped On"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end ,
    [500] = function(p)
        local text = "Talk to Me. When You Are Ready"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240);
    end , 
    [580] = function(p)
        return true;
    end , 
    ["END"] = function(p)
        HX_Q:SET(p,[[Light_Warrior_Cutscene]],"DONE");
    end
})


HX_Q:CREATE_QUEST(60,{
    name = "B_Mission", dialog = "Do You Think You Are Ready?",
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_3]])     == "DONE"
        and HX_Q:GET(p,[[Swordman_3]])             == "DONE"
        and HX_Q:GET(p,[[Light_Warrior_Cutscene]]) == "DONE"
        and HX_Q:GET(p,[[Going_To_Lumina_Cutscene]]) == "Empty"
        then 
            return true;
        else
            return false;
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            if checkRequirementTungstenFullset(p) then 
                CUTSCENE:start(p,"So_You_Are_Ready");
            end 
        end,{},1);
    end
})

CUTSCENE:CREATE("So_You_Are_Ready",{
    [1] = function(p)
        CUTSCENE:setCamera(-21,7,465,p)
        CUTSCENE:setrotCamera(270,15,1,p)
        CUTSCENE:createDoll(p,[[mob_30]],-19,7,465,5)
    end,
    [20] = function(p)
        local text = "Alright So You Are Ready"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end,
    [100] = function(p)
        local text = "Here is The Key To Access Lumina the Guardian Angel Room"
        CUTSCENE:DialogSay(1,"Light Warrior",p,text,3,90,5,240)
    end,
    [200] = function(p)
        return true;
    end , 
    ["END"] = function(p)    
        HX_Q:SET(p,[[Going_To_Lumina_Cutscene]],"DONE");
        RUNNER.NEW(function()
            if VarLib2:setPlayerVarByName(p,5, "Accepted_By_Fate", true) == 0 then 
                HX_Q:SET(p,"Have_Access_Lumina_Room","TRUE");
                HX_Q:ShowReward(p,[[1004218]],"Access Lumina's Room","Can be Used to Open Door on Lumina's Room.");
            end
            RUNNER.NEW(function()
                RunQuest(p,"Going_To_Lumina_Room",60)
            end,{},1)
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(60,{
    name = "Going_To_Lumina_Room", dialog = "Go Hero! Get Your Key!",
    hint = {x=-658,y=8,z=461},
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_3]])     == "DONE"
        and HX_Q:GET(p,[[Swordman_3]])             == "DONE"
        and HX_Q:GET(p,[[Light_Warrior_Cutscene]]) == "DONE"
        and HX_Q:GET(p,[[Have_Access_Lumina_Room]]) == "TRUE"
        and HX_Q:GET(p,[[Going_To_Lumina_Cutscene]]) == "DONE"
        and HX_Q:GET(p,"LUMINA_CHEST") ~= "OBTAINED" 
        then 
            return true;
        else 
        return false;
        end 
    end ,
    [2] = function(p)
        local x,y,z = -658,8,461; 
        local dis = getDistance2Target(p,x,y,z);
    
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Into Lumine Room" , pic =  [[3000060]] , detail="Click For Hint"});
            -- create Graphic info on Location  
        end 
    end , 
    [3] = function(p)
        RUNNER.NEW(function()
            MYTOOL.ADD_EFFECT(-18,8,465,1024,1);
            MYTOOL.ADD_EFFECT(-18,11,465,1025,2);
            RUNNER.NEW(function()
                MYTOOL.DEL_EFFECT(-18,8,465,1024,1);
                MYTOOL.DEL_EFFECT(-18,11,465,1025,2);
            end,{},2000)    
        end,{},1)
    end 
})


HX_Q:CREATE_QUEST(60,{
    name = "Finished_Lumina", dialog = "Good Job Hero. You Are Good To Go",
    hint = {x=-658,y=8,z=461},
    [1] = function(p)
        if  HX_Q:GET(p,[[IS_QUEST_MISSION_3]])     == "DONE"
        and HX_Q:GET(p,[[Swordman_3]])             == "DONE"
        and HX_Q:GET(p,[[Light_Warrior_Cutscene]]) == "DONE"
        and HX_Q:GET(p,[[Have_Access_Lumina_Room]]) == "TRUE"
        and HX_Q:GET(p,[[Going_To_Lumina_Cutscene]]) == "DONE"
        and HX_Q:GET(p,"LUMINA_CHEST") == "OBTAINED" 
        then 
            return true;
        else 
        return false;
        end 
    end
})