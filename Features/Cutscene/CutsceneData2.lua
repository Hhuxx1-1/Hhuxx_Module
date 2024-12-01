local r , leaving_Santa_house = Area:createAreaRectByRange({x=89,y=8,z=22},{x=88,y=14,z=15});
local r , bugFailTeleport =  Area:createAreaRectByRange({x=-148,y=7,z=-193},{x=-154,y=11,z=-195});

local function set2FarPosition(playerid,x,y,z)
    if Actor:killSelf(playerid) == 0 then 
        Player:reviveToPos(playerid,x,y,z)
    end 
end

CUTSCENE:CREATE("LEAVING_SANTA_HOUSE_PART_1",{
    [1] = function(p)
        CUTSCENE:createDoll(p,[[mob_2]],78,7,18.5);
        CUTSCENE:setText(p," ");
    end,
    [10] = function(p)
        CUTSCENE:setCamera(79,7,18.5,p);
        CUTSCENE:setrotCamera(270,15,1,p);
    end,
    [60]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(santa,270)
        Actor:setFacePitch(santa,15)
        local text = "Thank You for Rescuing Santa";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [155]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,25)
        local text = "Anyway Someone is Waiting you";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [220]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,5)
        local text = "He Call himself Captain Tom";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [310]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,25)
        local text = "Just Move Straight Forward";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [400]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,5)
        local text = "He is Already Waiting For you";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [490] = function(p)
       return true; 
    end,
    ["END"] = function(p)
        HX_Q:SET(p,"LVSQ","TRUE");
        local x,y,z = MYTOOL.GET_POS(p);
        MYTOOL.playSoundOnPos(x,y,z,10956,100,1);
        RunQuest(p,"Captain_Tom_Location",0);
    end
})

ScriptSupportEvent:registerEvent("Player.AreaIn",function(e)
    local playerid,areaid = e.eventobjid,e.areaid;
    -- Chat:sendSystemMsg("Player : "..playerid.." leave areaid : "..areaid);
    if areaid == leaving_Santa_house then 
        if HX_Q:GET(playerid,"LVSQ") == "Empty" then 
            CUTSCENE:start(playerid,"LEAVING_SANTA_HOUSE_PART_1")
        end 
    end 
    if areaid == bugFailTeleport then 
        if HX_Q:GET(playerid,"DEFEATED_HOUND") == "TRUE" then
            set2FarPosition(playerid,-151,7,-206)
        end 
    end 
end)

-- CUTSCENE TO GUIDE TELL PLAYER TO FOLLOW Captain Wolf to Meet Chief of the Village. 
--[[
-- Alright, here’s the situation
-- Santa’s magic is crucial to keeping the Christmas spirit alive
-- but it been weakened
-- weakened by the dark energy.
-- spreading from the Dark Land.
-- The Born of the Darkness.
]]

--[[
-- This mission won’t be easy
-- The Dark Land is far from here 
-- the path is filled with all sorts of dangers. 
-- However, 
-- there’s someone who might be able to help us
]]

--[[
-- The chief of this village
-- he has dealt with these kinds of threats before
-- You’ll find him in the cafeteria, 
-- just down the path cross the bridge
-- Go speak with him
he’ll know how to guide you
]]

CUTSCENE:CREATE("INTO_CHIEF",{
    [1] = function(p)
        Actor:setPosition(p,-21,7,17);
        CUTSCENE:createDoll(p,[[mob_28]],-24,7,18.5);
        CUTSCENE:setText(p," ");
    end , 
    [10] = function(p)
        CUTSCENE:setCamera(-20,7,18.5,p);
        CUTSCENE:setrotCamera(270,15,1,p);
    end,
    [40]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,260)
        Actor:setFacePitch(Captain,15)
        local text = "Alright";
        CUTSCENE:showChat(Captain,text,1,2,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [100] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [120]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "here’s the situation";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [220]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "Santa’s magic is crucial";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [320]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "keeping the Christmas spirit alive";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [420]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "but it been weakened";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [520]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "weakened by the dark energy.";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [620]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "spreading from the Dark Land.";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [720]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "The Born of the Darkness.";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [820]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "This mission won’t be easy";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [920]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "The Dark Land is far from here";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1020]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "the path is filled with all sorts of dangers.";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1120]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "However";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1220]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "There is Still Hope";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1320]=function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "I know Someone who can guide you";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1420] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,290)
        Actor:setFacePitch(Captain,25)
        local text = "The chief of this village";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1520] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "he has dealt with these kinds of threats before";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1620] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "You’ll find him in the cafeteria";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1720] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "just down the path cross the bridge";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1820] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "Go speak with him";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [1920] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(Captain,270)
        Actor:setFacePitch(Captain,15)
        local text = "he’ll know how to guide you";
        CUTSCENE:showChat(Captain,text,1,3,230);
        CUTSCENE:setText(p,"Captain Tom : "..text);
    end,
    [2060] = function(p)
        local Captain = CUTSCENE.DOLLS[p][1];
        Actor:tryNavigationToPos(p,-43,7,20,true)
        Actor:tryMoveToPos(Captain,-43,7,20)
    end,
    [2120] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,"BEFORE_INTO_CAFETARIA","TRUE");
        -- RunQuest that guide player into Cafetaria.
        RunQuest(p,"INTO_CAFETARIA",0);
    end
})

local function KarinSay(p,text,dur,yaw,pitch)
    local Karin = CUTSCENE.DOLLS[p][1];
    Actor:setFaceYaw(Karin,yaw)
    Actor:setFacePitch(Karin,pitch)
    CUTSCENE:showChat(Karin,text,1,dur,230);
    CUTSCENE:setText(p,"Karin : "..text);
end

CUTSCENE:CREATE("Going Arround the Village",{
    [1] = function(p)
        CUTSCENE:setCamera(-34,8,134,p);
        Player:setPosition(p,-34,8,134);
    end,
    [20] = function(p)
        -- set the Camera 
        CUTSCENE:setrotCamera(150,10,1,p); 
        CUTSCENE:createDoll(p,[[mob_58]],-34,8,132);
    end,
    [60] = function(p)
        local text = "Hello, Adventurer! I am Karin.";
        KarinSay(p,text,2,135,0);
    end,
    [110] = function(p)
        local text = "My Dad asked me to Show you the Village";
        KarinSay(p,text,2,146,0);
    end,
    [190] = function(p)
        local text = "Follow Me";
        KarinSay(p,text,2,136,0);
    end,
    [240] = function(p)
        local Karin = CUTSCENE.DOLLS[p][1];
        Actor:tryMoveToPos(Karin,-37,8,128);
    end,
    [245] = function(p)
        CUTSCENE:TRANSITION(p,2);
        
    end,
    [250] = function(p)
        CUTSCENE:setrotCamera(180,15,1,p)
    end,
    [275] = function(p)
        Player:setPosition(p,-40,7,118);
        local Karin = CUTSCENE.DOLLS[p][1];
        Actor:setPosition(Karin,-45,7,114);
        CUTSCENE:setCamera(-39,7,119,p);
    end,
    [280] = function(p)
        CUTSCENE:setrotCamera(190,10,1,p);
    end, 
    [300] = function(p)
        local text = "I Love Black Cat";
        KarinSay(p,text,2,146,0);
    end,
    [380] = function(p)
        local text = "Let's Visit Him 1st";
        KarinSay(p,text,2,146,0);
    end,
    [420] = function(p)
        return true ;
    end,
    ["END"] = function(p)
        HX_Q:STOP_MUSIC(p);
        HX_Q:SET_CurQuest(p,"Cafetaria");
        RUNNER.NEW(function()
            HX_Q:PLAY_MUSIC(p,10)
            RunQuest(p,"GUIDED_BY_KARIN",0);
        end,{},5)
    end
})

CUTSCENE:CREATE("GUIDED_BY_KARIN_1",{
    [1] = function(p)
        CUTSCENE:createDoll(p,[[mob_58]],-47,7,43);
    end,
    [10] = function(p)
        CUTSCENE:setCamera(-47,7,43,p);
        CUTSCENE:setrotCamera(270,15,2,p);
    end,
    [80] = function(p)
        local text = "This is the Black Cat House.";
        KarinSay(p,text,2,90,0);
    end,
    [140] = function(p)
        local text = "Black Cat sell Some Goods";
        KarinSay(p,text,2,90,0);
    end,
    [190] = function(p)
        local text = "You Can Visit him Later";
        KarinSay(p,text,2,90,0);
    end,
    [240] = function(p)
        local text = "Let's Continue to Weapon Shop";
        KarinSay(p,text,2,90,0);
    end,
    [280] = function(p)
        return true;    
    end,
    ["END"] = function(p)
        RUNNER.NEW(function()
        RunQuest(p,"GUIDED_BY_KARIN_2",0); 
        end,{},5)
    end
})


CUTSCENE:CREATE("GUIDED_BY_KARIN_3",{
    [1] = function(p)
        CUTSCENE:setCamera(51,7,116,p);
        CUTSCENE:createDoll(p,[[mob_58]],51,7,116);
    end,
    [10] = function(p)
        CUTSCENE:setrotCamera(370,15,2,p);
    end,
    [80] = function(p)
        local text = "This is Weapon Shop";
        KarinSay(p,text,2,300,0);
    end,
    [140] = function(p)
        local text = "Place Where You Can Buy Weapons and Stuff";
        KarinSay(p,text,2,320,0);
    end,
    [190] = function(p)
        local text = "I Have Finished my Guide Here";
        KarinSay(p,text,2,290,0);
    end,
    [240] = function(p)
        local text = [[For More Guide Find ("Captain Wolf")]];
        KarinSay(p,text,2,300,0);
    end,
    [320] = function(p)
        return true;    
    end,
    ["END"] = function(p)
        HX_Q:SET_CurQuest(p,"Adventurer");
        RUNNER.NEW(function()
            Actor:tryNavigationToPos(p,55,8,125,true);
            RUNNER.NEW(function()
                MISSION_TRACKER:SET_UNLOCKED(p,"FIND_CAPTAIN_WOLF");
                -- create Special Effect Above That Npc 
                MYTOOL.ADD_EFFECT(30.5,8,135.5,1024,1);
                MYTOOL.ADD_EFFECT(30.5,11,135.5,1025,2);
                RUNNER.NEW(function()
                    MYTOOL.DEL_EFFECT(30.5,8,135.5,1024,1);
                    MYTOOL.DEL_EFFECT(30.5,11,135.5,1025,2);
                end,{},2000)    
            end,{},15)
        end,{},5)
    end
})