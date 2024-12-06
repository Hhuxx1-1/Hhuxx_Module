MISSION_REWARD:ADD("1MISSION_TUTORIAL", {
    {type = "CURRENCY", amount = 500}     
})

MISSION_TRACKER:NEW("1MISSION_TUTORIAL", {
    f = function(playerid)
        return tostring(HX_Q:GET(playerid, "TUTORIAL")) == "3" 
    end,
    isFalse = [[Find a way to the village and rescue Santa. 
The forest is dangerous, but your perseverance will lead you to success.]],
    isTrue = [[Congratulations! You successfully found and rescued Santa. 
Despite being lost in the forest, your bravery and determination saved the day.]],
    name = "Rescue Santa",
    fullname = "Mission: Rescue Santa"
})

MISSION_TRACKER:NEW("X_MISSION_LAST_BOSS", {
    f = function(playerid)
        return HX_Q:GET(playerid, "DEFEAT_LAST_BOSS") == "TRUE" 
    end,
    isFalse = [[Santa's magic has weakened due to the Dark Lord's influence in the Dark Land. 
Gather your strength, face the Dark Lord, and restore the magic to save Christmas!

Hint : Talk to NPCs and Do Quest to Get More Clue and Guide]],
    isTrue = [[Well done! You restored Santa's magic by defeating the Dark Lord in the Dark Land. 
Christmas is saved, and your heroic efforts will be remembered!]],
    name = "Santa's Magic",
    fullname = "Recover Santa's Magic by Defeating the Dark Lord"
})

MISSION_REWARD:ADD("CAPTAIN_TOM_REQUEST", {
    {type = "CURRENCY", amount = 1000}
})

MISSION_TRACKER:NEW("CAPTAIN_TOM_REQUEST",{
    f = function(playerid)
        local cond = HX_Q:GET(playerid,"CAPTAIN_TOM_REQUEST");
        if  cond == "NOT_DONE" then 
            return false , [[There is Still Task to Do from Chief Village. Try To Talk with Chief Village.]]
        elseif cond == "DONE" then
            return true; 
        else 
            return false;
        end 
    end,
    isFalse = [[Before You Heading to Dark Land. I Hope You can Help this Village. Talk to Chief Village what do they Need. Chief Village location is On Hill Inside Village]],
    isTrue = [[You Successfully Helped Santa's Village]],
    name = "Village Need",
    fullname = "Help Chief Village"
})

MISSION_REWARD:ADD("FIND_CAPTAIN_WOLF", {
    {type = "CURRENCY", amount = 100}     
})

MISSION_TRACKER:NEW("FIND_CAPTAIN_WOLF", {
    f = function(playerid)
        return HX_Q:GET(playerid,"FIRST_TIME_CAPTAIN_WOLF_MEET") ~= "Empty"
    end,
    isFalse = [[Find Captain Wolf at The Weapon Shop. (He Should be Standing Near The Stair inside the Weapon Shop)]],
    isTrue = [[You Already Meet Captain Wolf! Congrats For Finishing Your First Mission Puzzle! ]],
    name = "Captain Wolf",
    fullname = "Find Captain Wolf"
})

MISSION_REWARD:ADD("TALK_CAPTAIN_WOLF_ON_GUILD",{
    {type = "CURRENCY", amount = 100}
});

MISSION_TRACKER:NEW("TALK_CAPTAIN_WOLF_ON_GUILD",{
    f = function(playerid)
        return HX_Q:GET(playerid,"FIRST_TIME_TALK_TO_CAPTAIN_WOLF") ~= "Empty"
    end,
    isFalse = [[Talk to Captain Wolf at The Guild. He Should be on Second Floor at Guild House]],
    isTrue = [[You Already Talk to Captain Wolf! Congrats For Finishing Mission]],
    name = "Captain Wolf 2",
    fullname = "Talk to Captain Wolf at The Guild"
})

MISSION_REWARD:ADD("Defeat_10_wolves",{
    {type = "CURRENCY", amount = 500}
});

MISSION_TRACKER:NEW("Defeat_10_wolves",{
    f = function(playerid)
        if HX_Q:GET(playerid,"WOLVES_10") == "Empty" then 
            return false;
        end 
        local proggress = tonumber(HX_Q:GET(playerid,"WOLVES_10"));
        if  proggress >= 10 then 
            return true 
        else 
            return false , [[You Need to Defeat 10 Wolves. You Can Find Them at The Forest]].." Current Proggress : \n( "..proggress.." / 10 ) Defeated";
        end 
        print("Defeat_10_wolves Proggress : ",proggress);
    end,
    isFalse = [[You Need to Defeat 10 Wolves. You Can Find Them at The Forest]],
    isTrue = [[You Successfully Defeat 10 Wolves! and Report it Back! ]],
    name = "Captain Wolf 3",
    fullname = "Defeat 10 Wolves"
})


MISSION_REWARD:ADD("COLLECT_20_RED_MUSHROOM",{
    {type = "CURRENCY", amount = 500}
});

MISSION_TRACKER:NEW("COLLECT_20_RED_MUSHROOM",{
    f = function(playerid)
        if HX_Q:GET(playerid,"RED_MUSHROOM_20") == "Empty" then 
            return false;
        end 
        local proggress = tonumber(HX_Q:GET(playerid,"RED_MUSHROOM_20"));
        if  proggress >= 20 then 
            return true 
        else 
            return false , [[You Need to Collect Red Mushroom. You Can Find Them at Red Mushroom Cave]].." Current Proggress : \n ( "..proggress.." / 20 ) Harvested";
        end 
        print("Defeat_10_wolves Proggress : ",proggress);
    end,
    isFalse = [[You Need to Collect Red Mushroom. You Can Find Them at Red Mushroom Cave]],
    isTrue = [[You Successfully Collect Red Mushroom! ]],
    name = "Captain Wolf 4",
    fullname = "Collect Red Mushroom Supply!"
})

MISSION_REWARD:ADD("Find_Xuyou",{
    {type = "CURRENCY", amount = 100}
})

MISSION_TRACKER:NEW("Find_Xuyou",{
    f = function(p)
        return HX_Q:GET(p,"Talked_With_Xuyou") == "Done"
    end,
    isFalse = [[You Need to Find Xuyou to Learn Master of Sword Technique in Order to Continue Your Journey on Defeating the Darkness. You Can Find Him inside The Village]],
    isTrue = [[You Successfully Find Xuyou!]],
    name = "Find Xuyou",
    fullname = "Find Xuyou at The Village"
})

MISSION_REWARD:ADD("Find_5_Creata_Core",{
    {type = "CURRENCY", amount = 100}
})

MISSION_TRACKER:NEW("Find_5_Creata_Core",{
    f=function(p)
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
            return true
        else
            return false , [[You Need to Find 5 Creata Core. You Can Find Them Hidden in Frozen Lake Village]].." You Already Found ( "..count.."/5 )";
        end 
    end,
    isFalse = [[You Need to Find 5 Creata Core. You Can Find Them Hidden in Frozen Lake Village]],
    isTrue = [[You Successfully Find 5 Creata Core! You Can Now Continue to Talk With Swordman Xuyou]],
    name = "Xuyou 1",
    fullname = "Find 5 Creata Core"
})

MISSION_REWARD:ADD("The_5_Minosour",{
    {type = "CURRENCY", amount = 5000}
})

MISSION_TRACKER:NEW("The_5_Minosour",{
    f = function(p)
        return HX_Q:GET(p,"MINOSOUR_5_QUEST") == "DONE"
    end,
    isFalse = [[You Need to Defeat 5 Minosour to Pass the Sword Master Xuyou Exam. You Can Find Them in Red Crystal Cave]],
    isTrue = [[You Successfully Defeat 5 Minosour. Now You Can Pass the Sword Master Xuyou Exam]],
    name = "Minosour",
    fullname = "Find 5 Minosour in Red Crystal Cave and Defeat Them!"
})

MISSION_REWARD:ADD("Talk_To_Chief",{
    {type = "CURRENCY", amount = 100}
})

MISSION_TRACKER:NEW("Talk_To_Chief",{
    f = function(p)
        return HX_Q:GET(p,"CHIEF_TALK") == "DONE"
    end,
    isFalse = [[You Need to Talk to Chief to Get Objective on How to Defeat the Dark Lord]],
    isTrue = [[You Successfully Talk to Chief. And Finished to Walk Around The Village Guided by Karin. Now You Just Need to Find Captain Wolf for More Info About The Dark Lord]],
    name = "Find Chief",
    fullname = "Talk to Chief to Get Objective on How to Defeat the Dark Lord"
})


MISSION_TRACKER:NEW("FIND_LOST_REINDEER",{
    f= function(p)
        local FOUND_RUN_AWAY_REINDEER = HX_Q:GET(p,"FOUND_RUN_AWAY_REINDEER")  
        if FOUND_RUN_AWAY_REINDEER == "Empty" then 
            FOUND_RUN_AWAY_REINDEER = 0;
        end 

        return tonumber(FOUND_RUN_AWAY_REINDEER) >= 4
    end,
    isFalse = [[Find Run Away Reindeer]],
    isTrue = [[You Successfully Helped Santa Find Their Runaway Reindeer]],
    name = "Lost Reindeer",
    fullname = "Help Santa Find Reindeer"
});

MISSION_TRACKER:NEW("GET_BACK_50_GIFT_FROM_GRINCH",{
    f= function(p)
        local RECOVERED_GIFT_PROGGRESS = HX_Q:GET(p,"RECOVERED_GIFT_PROGGRESS")  
        if RECOVERED_GIFT_PROGGRESS == "Empty" then 
            RECOVERED_GIFT_PROGGRESS = 0;
        end 
        return tonumber(RECOVERED_GIFT_PROGGRESS) >= 50
    end,
    isFalse = [[Find Lost Gift for Santa. (You Can Find Them by Defeating Grinch)]],
    isTrue = [[You Successfully Helped Santa Find Their Lost Gift due to Stolen by Grinch]],
    name = "Missing Gift",
    fullname = "Help Santa Find Missing Gift"
})

MISSION_TRACKER:NEW("DEFEAT_150_BANDIT",{
    f= function(p)
        local DEFEAT_150_BANDIT_FROM_NOW = HX_Q:GET(p,"DEFEAT_150_BANDIT_FROM_NOW")  
        if DEFEAT_150_BANDIT_FROM_NOW == "Empty" then 
            DEFEAT_150_BANDIT_FROM_NOW = 0;
        end 

        return  tonumber(DEFEAT_150_BANDIT_FROM_NOW) >= 150 
    end,
    isFalse = [[You Need To Gift Bandit a Lesson to Not Attacking Santa's Minion. By Defeating Them!]],
    isTrue = [[You Successfully Drawed The Border and Bring Safety to Santa's Minion]],
    name = "The Bandit",
    fullname = "Show the Bandit What is Scary"
})