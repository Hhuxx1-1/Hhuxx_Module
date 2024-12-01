HX_Q:CREATE_QUEST(13,{
    name = "Swordman_1",dialog="Do You Want to Learn More about Sword Weapon Skill?",
    [1] = function(p)
        HX_Q:SET(p,"Talked_With_Xuyou","Done")
        if HX_Q:GET(p,[[IS_QUEST_MISSION_3]]) ~= "DONE" then 
            return false;
        end 
        if HX_Q:GET(p,"Swordman_1") == "Empty" then 
            local C1 = HX_Q:GET(p,"CREATA_CORE_1");
            local C2 = HX_Q:GET(p,"CREATA_CORE_2");
            local C3 = HX_Q:GET(p,"CREATA_CORE_3");
            local C4 = HX_Q:GET(p,"CREATA_CORE_4");
            local C5 = HX_Q:GET(p,"CREATA_CORE_5");
            local count = 0 ; 
            if C1 == "OBTAINED" then count = count + 1 end
            if C2 == "OBTAINED" then count = count + 1 end
            if C3 == "OBTAINED" then count = count + 1 end
            if C4 == "OBTAINED" then count = count + 1 end
            if C5 == "OBTAINED" then count = count + 1 end
            if count >= 5 then 
                return false;
            else 
                return true;
            end 
        else
            return false;
        end 
    end,["END"] = function(p)
        if HX_Q:GET(p,"Swordman_1_Cutscene_For_First_Time") == "Empty" then 
            RUNNER.NEW(function()
                CUTSCENE:start(p,"Swordman_1_Cutscene_For_First_Time");
            end,{},1)
        else 
            RUNNER.NEW(function()
                CUTSCENE:start(p,"Swordman_1_Cutscene_For_Second_Time");
            end,{},1)
        end 
    end
});

HX_Q:CREATE_QUEST(13,{
    name = "Swordman_0" ,dialog="You Need to Help Captain Wolf First..",
    [1] = function(p)
        if HX_Q:GET(p,[[IS_QUEST_MISSION_3]]) ~= "DONE" then 
            return true;
        else
            return false; 
        end 
    end
})

CUTSCENE:CREATE("Swordman_1_Cutscene_For_First_Time",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Before We can Start to Learn...";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [120] = function(p)
        local text= "You Must Have Obtain 5 Creata Core";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [210] = function(p)
        local C1 = HX_Q:GET(p,"CREATA_CORE_1");
        local C2 = HX_Q:GET(p,"CREATA_CORE_2");
        local C3 = HX_Q:GET(p,"CREATA_CORE_3");
        local C4 = HX_Q:GET(p,"CREATA_CORE_4");
        local C5 = HX_Q:GET(p,"CREATA_CORE_5");
        local count = 0 ; 
        if C1 == "OBTAINED" then count = count + 1 end
        if C2 == "OBTAINED" then count = count + 1 end
        if C3 == "OBTAINED" then count = count + 1 end
        if C4 == "OBTAINED" then count = count + 1 end
        if C5 == "OBTAINED" then count = count + 1 end
        if count == 0 then
            local text= "You Don't Have Any With You";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
        elseif count == 5 then 
            local text= "You Have 5 Creata Core";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
        else 
            local text= "You Already Found "..count.." Creata Core";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
        end 
    end,
    [300] = function(p)
        local text = "Talk to Me again when You Ready";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [390] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        MISSION_TRACKER:SET_UNLOCKED(p,[[Find_5_Creata_Core]]);
        HX_Q:SET(p,"Swordman_1_Cutscene_For_First_Time","DONE");
        RUNNER.NEW(function()
            RunQuest(p,"Find_5_Creata_Core_Quest",13)
        end,{},1)
    end
})

CUTSCENE:CREATE("Swordman_1_Cutscene_For_Second_Time",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [40] = function(p)
        local C1 = HX_Q:GET(p,"CREATA_CORE_1");
        local C2 = HX_Q:GET(p,"CREATA_CORE_2");
        local C3 = HX_Q:GET(p,"CREATA_CORE_3");
        local C4 = HX_Q:GET(p,"CREATA_CORE_4");
        local C5 = HX_Q:GET(p,"CREATA_CORE_5");
        local count = 0 ; 
        if C1 == "OBTAINED" then count = count + 1 end
        if C2 == "OBTAINED" then count = count + 1 end
        if C3 == "OBTAINED" then count = count + 1 end
        if C4 == "OBTAINED" then count = count + 1 end
        if C5 == "OBTAINED" then count = count + 1 end
        if count == 0 then
            local text= "You Don't Have Any With You";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
        elseif count == 5 then 
            local text= "You Have 5 Creata Core";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
        else 
            local text= "You Already Found "..count.." Creata Core";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
        end 
    end,
    [150] = function(p)
        local text = "Talk to Me again when You Ready";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [250] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        MISSION_TRACKER:SET_UNLOCKED(p,[[Find_5_Creata_Core]]);
        HX_Q:SET(p,"Swordman_1_Cutscene_For_First_Time","DONE");
        RUNNER.NEW(function()
            RunQuest(p,"Find_5_Creata_Core_Quest",13)
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(13,{
    name = "Swordman_2",dialog="So You Have Found All The Creata Core. Let's Continue To Train Yourself.",
    [1] = function(p)
        if HX_Q:GET(p,[[IS_QUEST_MISSION_3]]) ~= "DONE" then 
            return false;
        end 
        if HX_Q:GET(p,"Swordman_1") == "Empty" then 
            local C1 = HX_Q:GET(p,"CREATA_CORE_1");
            local C2 = HX_Q:GET(p,"CREATA_CORE_2");
            local C3 = HX_Q:GET(p,"CREATA_CORE_3");
            local C4 = HX_Q:GET(p,"CREATA_CORE_4");
            local C5 = HX_Q:GET(p,"CREATA_CORE_5");
            local count = 0 ; 
            if C1 == "OBTAINED" then count = count + 1 end
            if C2 == "OBTAINED" then count = count + 1 end
            if C3 == "OBTAINED" then count = count + 1 end
            if C4 == "OBTAINED" then count = count + 1 end
            if C5 == "OBTAINED" then count = count + 1 end
            if count >= 5 then 
                return true;
            else 
                return false;
            end 
        else
            return false;
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_1_Explanation");
        end,{},1)
    end
});


CUTSCENE:CREATE("Swordman_1_Explanation",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        if HX_Q:GET(p,"Swordman_1_Cutscene") == "DONE" then 
            local text= "You Need To Train Yourself";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
        else 
            local text= "Alright. Here is Your Training";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
        end 
    end,
    [70] = function(p)
        if HX_Q:GET(p,"TOTAL_CUMULATIVE_DAMAGE") == "Empty" then 
            HX_Q:SET(p,"TOTAL_CUMULATIVE_DAMAGE",0)
        end 
        local damage_currently = tonumber(HX_Q:GET(p,"TOTAL_CUMULATIVE_DAMAGE"));
        if tonumber(damage_currently) < 20000 then 
            local text= "Acumulate 15k  Damage Deals";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
        else 
            local text= "Looks Like You Already Done it";
            CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
            return true;
        end 
    end,
    [160] = function(p)
        local damage_currently = HX_Q:GET(p,"TOTAL_CUMULATIVE_DAMAGE");
        local text= "You Have Done " .. damage_currently .. " Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
    end,
    [200] = function(p)
        local text = "Talk to Me again when You Done";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [300] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        HX_Q:SET(p,"Swordman_1_Cutscene","DONE")
        RUNNER.NEW(function()
            Chat:sendSystemMsg("Game Tips : Better Weapon give Higher Damage",p)
            RunQuest(p,"Cumulative_Damage_15k_Xuyou",13)
        end,{},1)
    end
})

for Core = 83,87 do 
    HX_Q:CREATE_QUEST(Core,{
        name="Collect_Not_Yet", dialog = "Successfully Collected",
        [1] = function(p)
            if HX_Q:GET(p,"CREATA_CORE_"..Core-82) ~= "OBTAINED" then
                return true;
            end 
        end,
        ["END"] = function(p)
            HX_Q:SET(p,"CREATA_CORE_"..Core-82,"OBTAINED")
        end
    })
    HX_Q:CREATE_QUEST(Core,{
        name="Collect_Already", dialog = "You Already Collected This Creata Core",
        [1] = function(p)
            if HX_Q:GET(p,"CREATA_CORE_"..Core-82) == "OBTAINED" then
                return true;
            end 
        end
    })
end 

HX_Q:CREATE_QUEST(13,{
    name = "Find_5_Creata_Core_Quest" , dialog = "Non Dialog",
    [1] = function(p)
        return false;
    end ,
    [2] = function(p)
        local count = 0;
        for core = 1 , 5 do 
            if HX_Q:GET(p,"CREATA_CORE_"..core) == "OBTAINED" then 
                count = count + 1 ;
            end 
        end 
        if count == 5 then
            HX_Q:SHOW_QUEST(p,{
                open=false;
            })
            return true
        else 
            HX_Q:SHOW_QUEST(p,{
                open=true,text = "Find 5 Creata Core " , pic = [[3000084]] , detail="("..count.."/5) Found"
            })
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Go_Back_to_Xuyou",13)
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

HX_Q:CREATE_QUEST(13,{
    name = "Go_Back_to_Xuyou", dialog = "Non Dialog",
    hint = {x=-87,y=15,z=151},
    [1] = function(p)
        return false
    end,
    [2] = function(p)
        local x,y,z = -87,15,151; 
        local dis = getDistance2Target(p,x,y,z);
    
        if dis <= 7 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go Back to Xuyou" , pic = [[3000013]] , detail="Click For Hint"});
            -- create Graphic info on Location  
        end 
    end,
    [3] = function(p)
        -- Pass do Nothing 
    end 
})

HX_Q:CREATE_QUEST(13,{
    name = "Cumulative_Damage_15k_Xuyou", dialog = "Non Dialog",
    [1] = function(p)
        return false ;
    end,
    [2] = function(p)
        local target = 15000; --100k 
        local proggress = tonumber(HX_Q:GET(p,"TOTAL_CUMULATIVE_DAMAGE"));
        if proggress >= target then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Deals ("..proggress.."/15000) Damage" , pic =[[1540372]] ,
            bar = {
                v1 = proggress, v2 = target , color = 0xffa0000
            }
            });
        end 
    end,
    [3] = function(p)
        HX_Q:SET(p,"Swordman_1","DONE");
        RUNNER.NEW(function()
            RunQuest(p,"Go_Back_to_Xuyou",13)
        end,{},1)
    end
})

ScriptSupportEvent:registerEvent("Player.DamageActor",function(e)
    local damage = e.hurtlv;
    local playerid = e.eventobjid;
    if HX_Q:GET(playerid,"TOTAL_CUMULATIVE_DAMAGE") == "Empty" then 
        HX_Q:SET(playerid,"TOTAL_CUMULATIVE_DAMAGE", 0); 
    end 
    local total_cumulative_DAMAGE = tonumber(HX_Q:GET(playerid,"TOTAL_CUMULATIVE_DAMAGE"));
    total_cumulative_DAMAGE = total_cumulative_DAMAGE + damage
    HX_Q:SET(playerid,"TOTAL_CUMULATIVE_DAMAGE", total_cumulative_DAMAGE);

end)


local getSwordSkill = function(p)
    local r , v = VarLib2:getPlayerVarByName(p, 3, "SwordBlessing");
    if r == 0 then return v end ;
end

local setSwordSkill = function(p,v)
    local r = VarLib2:setPlayerVarByName(p, 3, "SwordBlessing",v);
    if r == 0 then return true end ;
end

HX_Q:CREATE_QUEST(13,{
    name = "Swordman_30k_Damage_Done",dialog="So You Ready to Recieve the Sword Skill?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" then 
            if getSwordSkill(p) < 1 then 
                return true;
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_1_Blessing");
        end,{},1)
    end
});


CUTSCENE:CREATE("Swordman_1_Blessing",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Congrats On Full Fill Your Requirements";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "Here is Your Sword Skill Level 1";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [210] = function(p)
        MYTOOL.playSoundOnActor(p,10967,100,1);
        MYTOOL.ADD_EFFECT_TO_ACTOR(p,1253,1);
    end,
    [310] = function(p)
        local text = "Now When You Use Sword Skill. You Deals 50% More Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [410] = function(p)
        local text = "That's Not Yet Powerful. Talk to Me Again When You Ready";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [510] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if setSwordSkill(p,1) then 
            Player:notifyGameInfo2Self(p,"Successfully Upgrade Sword Mastery -> 1");
        end 
    end
});

--[[
        LEVEL 2 SWORD SKILL GO HERE BELLOW 
]]


HX_Q:CREATE_QUEST(13,{
    name = "Learn_Level_2",dialog="Ready To Learn Stronger Power of Sword?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" and HX_Q:GET(p,"Swordman_2") == "Empty" then 
            if getSwordSkill(p) == 1 then 
                return true;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        CUTSCENE:start(p,"Level_2_Sword_Skill");
    end
});

CUTSCENE:CREATE("Level_2_Sword_Skill",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "This Time is Little Bit Easier";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
    end,
    [80] = function(p)
        local text= "I Want You To Use Sword Skill 50 Times";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230); 
    end,
    [170] = function(p)
        local text = "After That Talk to Me Again";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [260] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Level_2_Swordman",13);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(13,{
    name = "Level_2_Swordman",dialog="Non Dialog",
    [1] = function(p)
        return false 
    end,
    [2] = function(p)
        local target = 50;
        if HX_Q:GET(p,"50_SWORD_SKILL_ACTIVATION") == "Empty" then 
            HX_Q:SET(p,"50_SWORD_SKILL_ACTIVATION",0);
        end 
        local proggress = tonumber(HX_Q:GET(p,"50_SWORD_SKILL_ACTIVATION"));
        if proggress >= target then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Use Sword Skill ("..proggress.."/"..target..")" , pic =[[1540372]] ,
            bar = {
                v1 = proggress, v2 = target , color = 0xffa0000
            }
            });
        end 
    end,
    [3] = function(p)
        HX_Q:SET(p,"Swordman_2","DONE");
        RUNNER.NEW(function()
            RunQuest(p,"Go_Back_to_Xuyou",13)
        end,{},1)
    end
})
local weapon_activation_buffid = 50000018;
ScriptSupportEvent:registerEvent("Player.AddBuff",function(e)
    -- Obtain Buff id and Check 
    local buffid = e.buffid;
    local playerid = e.eventobjid;

    if buffid == weapon_activation_buffid then
        if HX_Q:GET(playerid,"50_SWORD_SKILL_ACTIVATION") ~= "Empty" then 
            HX_Q:SET(playerid,"50_SWORD_SKILL_ACTIVATION",math.min(
            tonumber(HX_Q:GET(playerid,"50_SWORD_SKILL_ACTIVATION")) + 1 ),50);
        end 
    end 
end)

-- Recive Level 2 

HX_Q:CREATE_QUEST(13,{
    name = "Level_2_Sword_Recieve",dialog="So You Ready to Recieve the Sword Skill?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" and HX_Q:GET(p,"Swordman_2") == "DONE" then 
            if getSwordSkill(p) < 2 then 
                return true;
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_2_Blessing");
        end,{},1)
    end
});


CUTSCENE:CREATE("Swordman_2_Blessing",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "You Are Doing Good";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "Here is Your Sword Skill Level 2";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [210] = function(p)
        MYTOOL.playSoundOnActor(p,10967,100,1);
        MYTOOL.ADD_EFFECT_TO_ACTOR(p,1253,1);
    end,
    [310] = function(p)
        local text = "Now When You Use Sword Skill. You Deals 100% More Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [410] = function(p)
        local text = "There is more Power to Seek. Talk to Me Again When You Want to Train";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [510] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if setSwordSkill(p,2) then 
            Player:notifyGameInfo2Self(p,"Successfully Upgrade Sword Mastery -> Level 2");
        end 
    end
});

HX_Q:CREATE_QUEST(13,{
    name = "Level_3_Quest_Mission",dialog="So You Ready to Train More?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE"
        and HX_Q:GET(p,"Swordman_3") == "Empty"
        then 
            if getSwordSkill(p) == 2 then 
                return true;
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_3_Mission");
        end,{},1)
    end
});


CUTSCENE:CREATE("Swordman_3_Mission",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Alright. Here is Exam Training";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [115] = function(p)
        local text= "Defeat Minosour 5 Times";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [205] = function(p)
        local text= "You Can Find Them on Red Crystal Cave";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,2,0,math.random(-5,5),230);
    end,
    [200] = function(p)
        local text = "Talk to Me again when You Done";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [300] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        RUNNER.NEW(function()
            MISSION_TRACKER:SET_UNLOCKED(p,"The_5_Minosour");
            RunQuest(p,"Go_To_Red_Crystal_Cave",13)
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(13,{
    name = "Go_To_Red_Crystal_Cave" , dialog = "non dialog",
    hint = { x=360,y=8,z=-33},
    [1] = function(p)
        return false;
    end , 
    [2] = function(p)
        local x,y,z = 360,8,-33; 
        local dis = getDistance2Target(p,x,y,z);
        
        if dis <= 15 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go To Minosour Location" , pic = [[3000082]] , detail=dis.." Block Away"});
            -- create Graphic info on Location  
        end 
    end , 
    [3] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Defeat_5_Minosour",13);
        end,{},1)
    end 
})

HX_Q:CREATE_QUEST(13,{
    name = "Defeat_5_Minosour" , dialog = "non dialog",
    hint = {x=360,y=8,z=-33},
    [1] = function(p)
        return false;
    end , 
    [2] = function(p)
        if HX_Q:GET(p,"Minosour_5") == "Empty" then 
            -- set into number 0 ;
            HX_Q:SET(p,"Minosour_5",0);
        end 
        local Proggress = tonumber(HX_Q:GET(p,"Minosour_5"));
        local maks = 5;
        if Proggress < maks then
            HX_Q:SHOW_QUEST(p, { open=true,text = "Defeat Minosour" , pic = [[3000082]] , detail="( "..Proggress.."/"..maks..") Defeated"});
        else
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            HX_Q:SET(p,"MINOSOUR_5_QUEST","DONE");
            HX_Q:SET(p,"Swordman_3","DONE");
            RunQuest(p,"Go_Back_to_Xuyou",13) 
        end,{},1)
    end
})

ScriptSupportEvent:registerEvent("Actor.AddBuff",function(e)
    local creatureid = e.eventobjid;
    local buffid = e.buffid;
    local actorid = e.actorid;
    local buffEliteDied = 50000004
    local Wolves = 82;
    if actorid == Wolves and buffid == buffEliteDied then 
        local x,y,z = MYTOOL.GET_POS(creatureid);
        local OBJ = MYTOOL.getObj_Area(x,y,z,52,12,52)
        if OBJ then
            -- filter only player 
            for i,playerid in ipairs(MYTOOL.filterObj("Player",OBJ)) do 
                if HX_Q:GET(playerid,"Minosour_5") ~= "Empty" then 
                    local Proggress = tonumber(HX_Q:GET(playerid,"Minosour_5"));
                    local maks = 5;
                    HX_Q:SET(playerid,"Minosour_5",math.min(Proggress + 1,maks));
                end
            end 
        end 
    end 
end)

-- Upgrading to Level 3 


HX_Q:CREATE_QUEST(13,{
    name = "Recive_Sword_Skill_Level_3",dialog="So You Ready to Level Up Your Sword Skill?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE" 
        and HX_Q:GET(p,"Swordman_3") == "DONE" 
        then 
            if getSwordSkill(p) < 3 then 
                return true;
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_3_Blessing");
        end,{},1)
    end
});


CUTSCENE:CREATE("Swordman_3_Blessing",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Very Nice You Pass the Exam";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "Here is Your Sword Skill Level 3";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [210] = function(p)
        MYTOOL.playSoundOnActor(p,10967,100,1);
        MYTOOL.ADD_EFFECT_TO_ACTOR(p,1253,1);
    end,
    [310] = function(p)
        local text = "Now When You Use Sword Skill. You Deals 200% More Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [410] = function(p)
        local text = "One More Step to Become Powerful. Talk to Me Again When You Ready";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [510] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if setSwordSkill(p,3) then 
            Player:notifyGameInfo2Self(p,"Successfully Upgrade Sword Mastery -> Level 3");
        end 
    end
});



HX_Q:CREATE_QUEST(13,{
    name = "Blessing_Quest_Sword_Level_3",dialog="So You Ready to Recieve the Sword Skill Level 3?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE" 
        and HX_Q:GET(p,"Swordman_3") == "DONE" 
        then 
            if getSwordSkill(p) < 3 then 
                return true;
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_3_Blessing");
        end,{},1)
    end
});

-- Level 4 is 1V1 and Must Wait other Player 

CUTSCENE:CREATE("Swordman_4_Strongest_Swordman",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_30]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Very Nice You Pass the Exam";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "Here is Your Sword Skill Level 3";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [210] = function(p)
        MYTOOL.playSoundOnActor(p,10967,100,1);
        MYTOOL.ADD_EFFECT_TO_ACTOR(p,1253,1);
    end,
    [310] = function(p)
        local text = "Now When You Use Sword Skill. You Deals 200% More Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [410] = function(p)
        local text = "One More Step to Become Powerful. Talk to Me Again When You Ready";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [510] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if setSwordSkill(p,3) then 
            Player:notifyGameInfo2Self(p,"Successfully Upgrade Sword Mastery -> Level 3");
        end 
    end
});

-- Mini Boss Xuyou 
local Xuyou = 3929;
local r,Battle_areaid = Area:createAreaRectByRange({x=-68,y=10,z=171},{x=-85,y=17,z=188})
HX_Q:CREATE_QUEST(13,{
    name = "Blessing_Quest_Sword_Level_4",dialog="This is The True Training, Are You Ready?",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE" 
        and HX_Q:GET(p,"Swordman_3") == "DONE" 
        and HX_Q:GET(p,"Swordman_4") == "Empty" 
        then 
            if getSwordSkill(p) == 3 then 
                -- check if there is no player at the Training Area 
                local r, p = Area:getAreaPlayers(Battle_areaid);
                if #p > 0 then 
                    return false
                else 
                    return true;
                end 
            else 
                return false;
            end 
        else 
            return false 
        end 
    end,["END"] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_4_Battle");
        end,{},1)
    end
});

HX_Q:CREATE_QUEST(13,{
    name = "Blessing_Quest_Sword_Level_4_Occupied",dialog="Someone Else is Training, Please Wait Until it is Finished",
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE" 
        and HX_Q:GET(p,"Swordman_3") == "DONE" 
        and HX_Q:GET(p,"Swordman_4") == "Empty" 
        then 
            if getSwordSkill(p) == 3 then 
                -- check if there is no player at the Training Area 
                local r, p = Area:getAreaPlayers(Battle_areaid);
                if #p > 0 then 
                    return true;
                else 
                    return false;
                end 
            else 
                return false;
            end 
        else 
            return false 
        end 
    end
});

CUTSCENE:CREATE("Swordman_4_Battle",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,15,156,p);
        CUTSCENE:setrotCamera(15,15,1,p);
        CUTSCENE:createDoll(p,[[mob_13]],-87,15,156);
    end,
    [20] = function(p)
        local text= "Final Test";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "You Can use All You Got";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [210] = function(p)
        CUTSCENE:TRANSITION(p,4);
    end,
    [310] = function(p)
        Player:setPosition(p,-81,10,175);
        CUTSCENE:setCamera(-76,10,180,p);
        Actor:setPosition(CUTSCENE.DOLLS[p][1],-72,10,184);
        CUTSCENE:setrotCamera(45,15,1,p);
    end,
    [410] = function(p)
        local text = "Let's Begin";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,-45,math.random(-5,5),230);
    end,
    [510] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if Actor:killSelf(p) == 0 then 
            Player:reviveToPos(p,-81,10,175)
        end     
        RUNNER.NEW(function()
            local r,obj = World:spawnCreature(-72,10,184,Xuyou,1);
            HX_Q:STOP_MUSIC(p);
            RUNNER.NEW(function()
                HX_Q:PLAY_MUSIC(p,11);
                RunQuest(p,"Battle_Test",13);
            end,{},5)
        end,{},1)
        
    end
})

local time2DefeatXuyou = {}

HX_Q:CREATE_QUEST(13,{
    name = "Battle_Test" , dialog = "non dialog",
    [1] = function()
        return false;
    end,
    [2] = function(p)
        if HX_Q:GET(p,"XUYOU_BOSS_BATTLE") == "Empty" then 
            -- set into number 0 ;
            HX_Q:SET(p,"XUYOU_BOSS_BATTLE",0);
        end 
        local Proggress = tonumber(HX_Q:GET(p,"XUYOU_BOSS_BATTLE"));
        local maks = 1;
        local time = time2DefeatXuyou[p] or 4800;
        if Proggress < maks then
            
            if time > 0 then
                HX_Q:SHOW_QUEST(p, { open=true,text = "Defeat Xuyou",pic = [[3000013]] , detail=math.floor(time/20).." Seconds Left"});
                time2DefeatXuyou[p] = time - 1;
                local r,HP = Player:getAttr(p,2);
                if HP <= 0 then
                    time2DefeatXuyou[p] = 0;
                end 
            else 
                HX_Q:SHOW_QUEST(p, { open = false});
                HX_Q.CURRENT_QUEST[p] = nil ;
                RUNNER.NEW(function()
                    if Actor:killSelf(p) == 0 then 
                        Player:reviveToPos(p,-87,15,151)
                    end     
                    RUNNER.NEW(function()
                        Player:notifyGameInfo2Self(p,"MISSION FAILED")
                        time2DefeatXuyou[p] = nil;
                    end,{},5)
                end,{},1)
            end 
        else
            HX_Q:SHOW_QUEST(p, { open = false});
            return true;
        end 
    end,
    [3] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Swordman_4_Battle_Win")
        end,{},1)
    end
})

ScriptSupportEvent:registerEvent("Player.DefeatActor",function(e)
    local playerid = e.eventobjid;
    local actorid = e.targetactorid;
    if HX_Q:GET(playerid,"XUYOU_BOSS_BATTLE") ~= "Empty" then 
        if actorid == Xuyou then 
            local Proggress = tonumber(HX_Q:GET(playerid,"XUYOU_BOSS_BATTLE"));
            local maks = 1;
            HX_Q:SET(playerid,"XUYOU_BOSS_BATTLE",math.min(Proggress + 1,maks));
        end 
    end 
end)

CUTSCENE:CREATE("Swordman_4_Battle_Win",{
    [1] = function(p)
        CUTSCENE:setCamera(-75,10,185,p);
        CUTSCENE:setrotCamera(15,10,1,p);
        CUTSCENE:createDoll(p,[[mob_13]],-77,10,184);
    end,
    [20] = function(p)
        local text= "Amazing!";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [110] = function(p)
        local text= "You Pass the Last Exam!";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230); 
    end,
    [160] = function(p)
        CUTSCENE:TRANSITION(p,4);
    end,
    [200] = function(p)
        Player:setPosition(p,-87,15,151);
        CUTSCENE:setCamera(-87,15,149,p);
        Actor:setPosition(CUTSCENE.DOLLS[p][1],-87,15,154);
        CUTSCENE:setrotCamera(15,15,1,p);
    end,
    [250] = function(p)
        local text = "Here's is The True Power of Weapon";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [310] = function(p)
        MYTOOL.playSoundOnActor(p,10967,100,1);
        MYTOOL.ADD_EFFECT_TO_ACTOR(p,1253,1);
    end,
    [410] = function(p)
        local text = "Now When You Use Sword Skill. You Deals 400% More Damage";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [510] = function(p)
        local text = "Now You Are Ready To Continue Your Journey!";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [610] = function(p)
        local text = "Your Training Is Completed";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [710] = function(p)
        local text = "Now Go Back to Captain Wolf and Continue your Journey";
        CUTSCENE:DialogSay(1,"Xuyou",p,text,3,0,math.random(-5,5),230);
    end,
    [810] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        if setSwordSkill(p,4) then 
            HX_Q:SET(p,"Swordman_4","DONE");
            Player:notifyGameInfo2Self(p,"Successfully Upgrade Sword Mastery -> Level 4");
        end 
        RUNNER.NEW(function()
            if Actor:killSelf(p) == 0 then 
                Player:reviveToPos(p,-87,15,151)
            end     
        end,{},1)
    end
})



HX_Q:CREATE_QUEST(13,{
    name = "Swordman_ALL_COMPLETED",dialog="You Have Finished The Training. You Shall Continue Your Journey.",
    hint ={x=108,y=22,z=302} ,
    [1] = function(p)
        if HX_Q:GET(p,"Swordman_1") == "DONE" 
        and HX_Q:GET(p,"Swordman_2") == "DONE" 
        and HX_Q:GET(p,"Swordman_3") == "DONE" 
        and HX_Q:GET(p,"Swordman_4") == "DONE" 
        then 
            return true;
        else 
            return false 
        end 
    end,
    [2] = function(p)
        local x,y,z = 108,22,302; 
        local dis = getDistance2Target(p,x,y,z);
    
        if dis <= 5 then
            HX_Q:SHOW_QUEST(p, { open = false});
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Go to Captain Wolf" , pic =  [[3000078]] , detail="Click For Hint"});
            -- create Graphic info on Location  
        end 
    end,
    [3] = function(p)
        -- Pass do Nothing 
    end 
});