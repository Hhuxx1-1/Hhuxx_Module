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

HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_1",dialog=[[Hi New Adventurer, I'm here just to Greet you... You Can Meet Me at the Guild House for Quest (Go into Guild House)]]
    ,hint={x=55,y=8,z=125},
    [1] = function(playerid)
        if HX_Q:GET(playerid,"FIRST_TIME_CAPTAIN_WOLF_MEET") == "Empty" then 
            HX_Q:SET(playerid,"FIRST_TIME_CAPTAIN_WOLF_MEET","TRUE");
            return HX_Q:GET(playerid,"GUILD_VISITED") == "Empty"
        else 
            return false;
        end 
    end,
    [2] = function(p)
        local x,y,z = 55 , 8 , 125; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (0/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_2",11)
        end,{},1)
        -- RunQuest(playerid,"CHAIN_QUEST_2",11)
    end
})


HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_2",dialog=[[Continues Quest Chain From CHAIN_QUEST_1]]
    ,hint={x=50,y=7,z=115},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 50 , 7 , 115; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (1/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_3",11)
        end,{},1)
        -- RunQuest(playerid,"CHAIN_QUEST_3",11)
    end
})


HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_3",dialog=[[Continues Quest Chain From CHAIN_QUEST_2]]
    ,hint={x=13,y=7,z=116},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 13 , 7 , 116; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (2/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_4",11)
        end,{},1)
        -- RunQuest(playerid,"CHAIN_QUEST_4",11)
    end
})

HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_4",dialog=[[Continues Quest Chain From CHAIN_QUEST_3]]
    ,hint={x=21,y=10,z=251},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 21 , 10 , 251; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (3/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_5",11)    
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_5",dialog=[[Continues Quest Chain From CHAIN_QUEST_4]]
    ,hint={x=101,y=8,z=299},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 101 , 8 , 299; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (4/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_6",11)    
        end,{},1)
        --  RunQuest(playerid,"CHAIN_QUEST_6",11);
    end
})

HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_6",dialog=[[Continues Quest Chain From CHAIN_QUEST_5]]
    ,hint={x=121,y=15,z=310 },
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 121 , 15 , 310; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (5/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        RUNNER.NEW(function()
            RunQuest(playerid,"CHAIN_QUEST_7",11)    
        end,{},1)
        --  RunQuest(playerid,"CHAIN_QUEST_7",11);
    end
})


HX_Q:CREATE_QUEST(11,{
    name="CHAIN_QUEST_7",dialog=[[Continues Quest Chain From CHAIN_QUEST_6]]
    ,hint={x=116,y=21,z=298},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 116 , 21 , 298; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Guild House (6/7)" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        CUTSCENE:start(playerid,"CAPTAIN_WOLF_CUTSCENE_HOUSE_SECOND_FLOOR");
    end
})


HX_Q:CREATE_QUEST(1,{
    name="Talk to Captain Wolf",dialog=[[none]]
    ,hint={x=104,y=21,z=302},
    [1] = function(playerid)
        return false 
    end,
    [2] = function(p)
        local x,y,z = 104,21,302; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 6 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Talk to Captain Wolf" , pic = [[3000078]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(playerid)
        -- Do Nothing
        HX_Q:SET(playerid,"FIRST_TIME_TALK_TO_CAPTAIN_WOLF","TRUE");
    end
})


CUTSCENE:CREATE("CAPTAIN_WOLF_CUTSCENE_HOUSE_SECOND_FLOOR",{
    [1] = function(p)
        CUTSCENE:setText(p,"")
        CUTSCENE:setCamera(107,21,300,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(276,15,1,p)
        CUTSCENE:setText(p,"Speak to Captain Wolf");
    end,
    [40] = function(p)
        CUTSCENE:setText(p,"");
        return true;
    end,
    ["END"] = function(p)
        RunQuest(p,"Talk to Captain Wolf",1);
        MISSION_TRACKER:SET_UNLOCKED(p,"TALK_CAPTAIN_WOLF_ON_GUILD");
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Mission_1" , dialog = "We Got a Quest to Hunt Wolves. Because They are Way too Many and Attacking Nearby Peoples. Are You In?", 
    hint = {x=121,y=20,z=301},
    [1] = function(p)
        if HX_Q:GET(p,[[IS_QUEST_MISSION_1]]) == "Empty" then  
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
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Forest(0/4)" , pic = [[3000032]] , detail=dis.." Block Away"});
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
            RunQuest(p,"Mission_1_Part_1",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_1_Part_1" , dialog = "Continues_Part_Quest_1", 
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
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Forest(1/4)" , pic = [[3000032]] , detail=dis.." Block Away"});
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
            RunQuest(p,"Mission_1_Part_2",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_1_Part_2" , dialog = "Continues_Part_Quest_2", 
    hint = {x=97,y=7,z=298},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 97,7,298; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Forest(2/4)" , pic = [[3000032]] , detail=dis.." Block Away"});
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
            RunQuest(p,"Mission_1_Part_3",78)    
        end,{},1)
    end
})


HX_Q:CREATE_QUEST(78,{
    name = "Mission_1_Part_3" , dialog = "Continues_Part_Quest_2", 
    hint = {x=13,y=7,z=298},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 13,7,298; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        
        if dis <= 4 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Forest(3/4)" , pic = [[3000032]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
       CUTSCENE:start(p,"Wolves_Habitat");
    end
})

CUTSCENE:CREATE("Wolves_Habitat",{
    [1] = function(p)
        CUTSCENE:setText(p,"");
        CUTSCENE:setCamera(12,7,308,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(200,15,1,p);
    end,
    [50] = function(p)
        CUTSCENE:setText(p,"There Are So Many Wolves Here");
        CUTSCENE:setrotCamera(250,15,1,p)
    end ,
    [100] = function(p)
        CUTSCENE:setText(p,"I Need to Defeat These Wolves");
    end ,
    
    [160] = function(p)
        CUTSCENE:setText(p,"");
        return true;
    end ,
    ["END"] = function(p)
        MISSION_TRACKER:SET_UNLOCKED(p,[[Defeat_10_wolves]]);
        RunQuest(p,[[Defeat_10_Wolves]],78)
    end
})

HX_Q:CREATE_QUEST(78,{
    name = "Defeat_10_Wolves" , dialog = "Non Dialog Quest", 
    hint = {x=-6,y=7,z=298},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        if HX_Q:GET(p,"WOLVES_10") == "Empty" then 
            -- set into number 0 ;
            HX_Q:SET(p,"WOLVES_10",0);
        end 
        local Proggress = tonumber(HX_Q:GET(p,"WOLVES_10"));
        local maks = 10;
        if Proggress < maks then
            HX_Q:SHOW_QUEST(p, { open=true,text = "Defeat Wolves" , pic = [[3000032]] , detail="( "..Proggress.."/"..maks..") Defeated"});
        else
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end 
    end,
    [3] = function(p)
        Player:playMusic(p, 10954, 100,1,false);
        RUNNER.NEW(function()
            RunQuest(p,"Report_Back_to_Agent_Wolf",78);    
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(78,{
    name = "Report_Back_to_Agent_Wolf" , dialog = "Non Dialog Quest",
    hint = {x=99,y=8,z=299},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 99,8,299; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back To Captain Wolf(0/4)" , detail=dis.." Block Away"});
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
            RunQuest(p,"Report_Back_to_Agent_Wolf_1",78)        
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(78,{
    name = "Report_Back_to_Agent_Wolf_1" , dialog = "Non Dialog Quest",
    hint = {x=112,y=8,z=310},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 112,8,310; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back To Captain Wolf(1/4)" , detail=dis.." Block Away"});
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
            RunQuest(p,"Report_Back_to_Agent_Wolf_2",78)        
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(78,{
    name = "Report_Back_to_Agent_Wolf_2" , dialog = "Non Dialog Quest",
    hint = {x=122,y=16,z=307},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 122,16,307; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back To Captain Wolf(2/4)" ,detail=dis.." Block Away"});
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
            RunQuest(p,"Report_Back_to_Agent_Wolf_3",78)        
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(78,{
    name = "Report_Back_to_Agent_Wolf_3" , dialog = "Non Dialog Quest",
    hint = {x=118,y=21,z=299},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 118,21,299; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back To Captain Wolf(3/4)" , detail=dis.." Block Away"});
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
        RunQuest(p,"Report_Back_to_Agent_Wolf_4",78)        
        end,{},1)
    end
});


HX_Q:CREATE_QUEST(78,{
    name = "Report_Back_to_Agent_Wolf_4" , dialog = "Non Dialog Quest",
    hint = {x=109,y=21,z=301},
    [1] = function(p)
        return false;
    end,
    [2] = function(p)
        local x,y,z = 109,21,301; 
        local dis = getDistance2Target(p,x,y,z);
        DisValidator(p,dis);
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            smallestRange[p] = nil;
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Deliver Report To Captain Wolf"  , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end,
    [3] = function(p)
        CUTSCENE:start(p,"1stQuestWolf_Completed");
    end
});


ScriptSupportEvent:registerEvent("Player.DefeatActor",function(e)
    local playerid = e.eventobjid;
    local actorid = e.targetactorid;
    if HX_Q:GET(playerid,"WOLVES_10") ~= "Empty" then 
        local Wolves = 32;
        if actorid == Wolves then 
            local Proggress = tonumber(HX_Q:GET(playerid,"WOLVES_10"));
            local maks = 10;
            HX_Q:SET(playerid,"WOLVES_10",math.min(Proggress + 1,maks));
        end 
    end 
end)


local function DialogSay(p,text,dur,yaw,pitch)
    local Karin = CUTSCENE.DOLLS[p][1];
    Actor:setFaceYaw(Karin,yaw)
    Actor:setFacePitch(Karin,pitch)
    CUTSCENE:showChat(Karin,text,1,dur,230);
    CUTSCENE:setText(p,"Captain Wolf : "..text);
end

CUTSCENE:CREATE("1stQuestWolf_Completed",{
    [1] = function(p)
        CUTSCENE:setText(p,"")
        CUTSCENE:setCamera(107,21,300,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(276,15,1,p);
        CUTSCENE:createDoll(p,[[mob_78]],104,21,302);
    end,
    [40] = function(p)
        local text = "Thank You Adventurer";
        DialogSay(p,text,2,180,14);
    end,
    [130] = function(p)
        local text = "You has completed the request";
        DialogSay(p,text,2,180,14);
    end,
    [250] = function(p)
        local text = "To Recieve Quest Rewards. Check Your Mission Tab.";
        DialogSay(p,text,2,180,14);
    end,
    [320] = function(p)
        local text = "When You Are Ready. Talk to Me Again to Continue Your Mission.";
        DialogSay(p,text,2,180,14);
    end,
    [400] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,[[IS_QUEST_MISSION_1]],"DONE");
    end
})

HX_Q:CREATE_QUEST(81,{
    name = "Checkpoint",dialog = "Successfully set Home Point",
    [1] = function(playerid)
        local x,y,z = MYTOOL.GET_POS(playerid);
        local r = Player:setRevivePoint(playerid,x,y,z);
        HX_Q:SET(playerid,[[X_HOME]],x);
        HX_Q:SET(playerid,[[Y_HOME]],y);
        HX_Q:SET(playerid,[[Z_HOME]],z);
        return true;
    end
})