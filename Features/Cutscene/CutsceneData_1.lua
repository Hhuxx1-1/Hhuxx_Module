function set2FarPosition(playerid,x,y,z)
    if Actor:killSelf(playerid) == 0 then 
        Player:reviveToPos(playerid,x,y,z)
    end 
end

local items_for_begginer = {
    {itemid=12005,num=1},{itemid=4148,num=10}
}

local function Reset_Init(p)
    if Backpack:clearAllPack(p)==0 then return true else return false end
end

local INIT_ITEM = function(p,team)
    if Reset_Init(p) then 
        for i,v in ipairs(items_for_begginer) do 
            if Player:gainItems(p,v.itemid,v.num,1) ~= 0 then  
                return false;
            end 
        end 
    end 
end 


CUTSCENE:CREATE("FIRST_START",{
    -- Numbered key is tick of when a function should be executed 
    -- at the end of cutscene will execute ["END"] key 
    [1] = function(p)
        HX_Q:PLAY_MUSIC(p,0);
        -- Clear Player Backpack 
        INIT_ITEM(p);
    end,
    [20] = function(p)
       
        CUTSCENE:setrotCamera(180,0,2,p);
        CUTSCENE:moveCamera(0,0,3,p);
    end,
    [60] = function(p)
        CUTSCENE:setText(p,"Looks Like I Got Lost...");
    end,
    [120] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [140] = function(p)
        CUTSCENE:setText(p,"Let's Follow the Path ");
    end,
    [200] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [220] = function(p)
        CUTSCENE:setText(p,"Maybe Someone is Around");
    end,
    [280] = function(p)
        return true;
    end,
    ["END"] = function(p)
        -- Chat:sendSystemMsg("End");
        Player:SetCameraRotTransformTo(p,{x=180,y=0}, 1,2);
        RUNNER.NEW(function()
            -- play sound effect using mytool 
            local x,y,z = MYTOOL.GET_POS(p);
            MYTOOL.playSoundOnPos(x,y,z,10956,100,1);
            -- add Quest
            RunQuest(p,"none",0);
        end,{},1)
        HX_Q:PLAY_MUSIC(p,0);
    end
});

local HellHoundSpawnLocation = {
    {x=-156,y=7,z=-171},{x=-153,y=7,z=-173},
    {x=-150,y=7,z=-175},{x=-147,y=7,z=-173},
    {x=-144,y=7,z=-171},
}

local soundHoundEffect = {
    10415,10416,10417,
    R = function(self)
        -- return random index from self 
        return self[math.random(1,3)]
    end
}

CUTSCENE:CREATE("FIGHT_TUTORIAL",{
    [1] = function(p)
        HX_Q:STOP_MUSIC(p);

        RUNNER.NEW(function()
            HX_Q:PLAY_MUSIC(p,15);    
        end,{},10)
        
        --Pass 
        CUTSCENE:setText(p," ");--Refresh UI setText Manually 
    end,
    [10] = function(p)
        CUTSCENE:setCamera(-150,7,-163,p);
        CUTSCENE:moveCamera(0,0.5,-4,p);
    end,
    [20] = function(p)
        CUTSCENE:setrotCamera(180,0,2,p);
    end, 
    [40] = function(p)
        -- spawn 5 Doll 
        for i,ps in ipairs(HellHoundSpawnLocation) do 
            RUNNER.NEW(function()
                
            local x,y,z = ps.x,ps.y,ps.z;
            local doll = CUTSCENE:createDoll(p,[[mob_48]],x,y,z);
            MYTOOL.ADD_EFFECT(x,y,z,1505,2);
            MYTOOL.playSoundOnActor(doll,11074,100,1)
            RUNNER.NEW(function()
                MYTOOL.DEL_EFFECT(x,y,z,1505,2);
            end,{},15)
            -- set the doll facing angle 
            local px,py,pz = MYTOOL.GET_POS(p);
            local drx,dry,drz = MYTOOL.CalculateDirBetween2Pos({x=x,y=y,z=z},{x=px,y=py,z=pz});
            local yaw = math.atan2(drx, drz);
            -- Convert yaw angle from radians to degrees
            yaw = yaw * 180 / math.pi
            Actor:setFaceYaw(doll,yaw-180);


            end,{},i*3)
        end 
        
        CUTSCENE:setrotCamera(200,35,1,p);
    end,
    [62] = function(p)
        CUTSCENE:setrotCamera(150,35,1,p);
    end,
    [72] = function(p)
        for s = 1 , 5 do 
            RUNNER.NEW(function()
                local doll = CUTSCENE.DOLLS[p][s];
                MYTOOL.playSoundOnActor(doll,soundHoundEffect:R(),100,1)    
            end,{},s*10)
        end 
    end,
    [82] = function(p)
        CUTSCENE:setrotCamera(180,25,1,p);
    end,
    [120] = function(p)
        CUTSCENE:moveCamera(0,0,-4,p);
        CUTSCENE:setText(p,"There is Hellhound Blocking the Path");
    end,
    [132] = function(p)
        for s = 1 , 5 do 
            RUNNER.NEW(function()
                local doll = CUTSCENE.DOLLS[p][s];
                MYTOOL.playSoundOnActor(doll,soundHoundEffect:R(),100,1)    
            end,{},s*10)
        end 
    end,
    [160] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [172] = function(p)
        for s = 1 , 5 do 
            RUNNER.NEW(function()
                local doll = CUTSCENE.DOLLS[p][s];
                MYTOOL.playSoundOnActor(doll,soundHoundEffect:R(),100,1)    
            end,{},s*10)
        end 
    end,
    [200] = function(p)
        CUTSCENE:setText(p,"I must Defeat them");
    end,
    [240] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [260] = function(p)
        return true;
    end,
    ["END"] = function(p)
        
        HX_Q:PLAY_MUSIC(p,15);
        local count = 0;
        local idHound = 48;
        local cx,cy,cz = HellHoundSpawnLocation[3].x,HellHoundSpawnLocation[3].y,HellHoundSpawnLocation[3].z
        local OBJ = MYTOOL.getObj_Area(cx,cy,cz,50,15,50); 
        local Objids = MYTOOL.filterObj("Creature",OBJ); 
        for i,objid in ipairs(Objids) do
            -- check modelID 
            local r,modelID = Creature:getActorID(objid);
            if modelID == idHound then 
                count = count + 1;
            end 
        end 
        -- calculate how many hound is needed to spawned 
        local houndNeed = 5-count;
        for i = 1 , houndNeed do 
            local ps = HellHoundSpawnLocation[i];
            local r,obj = World:spawnCreature(ps.x,ps.y,ps.z,idHound,1) 
        end 

        RunQuest(p,"hellHound_Tutorial",0);
    end
});



CUTSCENE:CREATE("FIGHT_TUTORIAL_COMPLETE",{
    [1] = function(p)
        -- set Player Automatic Pathfanding
        CUTSCENE:setText(p," ");
        CUTSCENE:moveCamera(1,1,0,p);
    end,
    [40] = function(p)
        CUTSCENE:setText(p,"I Defeated them");
    end,
    [80] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [100] = function(p)
        CUTSCENE:setrotCamera(180,5,1.5,p);
    end,
    [140] = function(p)
        CUTSCENE:setText(p," I Have to Keep Moving ");
    end,
    [160] = function(p)
        Actor:tryMoveToPos(p,-151,7,-191,1);
    end,
    [200] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [230] = function(p)
        CUTSCENE:TRANSITION(p,2);
    end,
    [290] = function(p)
        local r = Actor:setPosition(p,-151,7,-205);
        local r = Actor:setPosition(CUTSCENE.PLAYER_CAMERA[p],-151,7,-205);
    end,
    [320] = function(p)
        return true;
    end,
    ["END"] = function(p)
        -- set Player Automatic Pathfanding
        HX_Q:STOP_MUSIC(p);
        HX_Q:SET(p,"DEFEATED_HOUND","TRUE");
        RUNNER.NEW(function()
            HX_Q:PLAY_MUSIC(p,0);
        end,{},20)
        local r = Actor:setPosition(p,-151,7,-205);
        RunQuest(p,"Tutorial_Part1",0);
    end,
})


CUTSCENE:CREATE("FIGHT_TUTORIAL_PART_1",{
    [1] = function(p)
        
    end,
    [20] = function(p)
        CUTSCENE:setText(p,"I can Slide using this Ice");
    end,
    [60] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [80] = function(p)
        return true; 
    end,
    ["END"] = function(p)
        Player:openUIView(p,"7437883429185329394");
        RunQuest(p,"Tutorial_Part2",0);
    end
})

CUTSCENE:CREATE("FIGHT_BOSS_TUTORIAL",{
    [1] = function(p)
        HX_Q:STOP_MUSIC(p)
        CUTSCENE:setText(p," ");
    end,
    [10] = function(p)
        HX_Q:PLAY_MUSIC(p,17);
        local doll_trex = CUTSCENE:createDoll(p,[[mob_50]],23,7,-228,2);
        local doll_santa = CUTSCENE:createDoll(p,[[mob_29]],19,7,-215,1);
        -- set size of the DOLL 
        CUTSCENE:moveCamera(4,2,1,p);
    end,
    [20] = function(p)
        local trex = CUTSCENE.DOLLS[p][1];
        local santa = CUTSCENE.DOLLS[p][2];
        Creature:setAttr(trex,21,40);
        Creature:setAttr(santa,21,20);
        Actor:setFaceYaw(trex,180);
        Actor:setFaceYaw(santa,0);
        local tx,ty,tz = 16,7,-254;
        Actor:tryMoveToPos(p,tx,ty,tz);
    end,
    [80] = function(p)
        CUTSCENE:setrotCamera(20,15,1,p);
    end,
    [100] = function(p)
        CUTSCENE:setCamera(17,7,-235,p)
        CUTSCENE:setText(p,"Oh No Santa in Danger!");
    end,
    [160] = function(p)
        CUTSCENE:setText(p,"  ");
    end,
    [200] = function(p)
        CUTSCENE:setText(p,"I have to Save Santa!");
    end,
    [260] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [300] = function(p)
        CUTSCENE:setText(p,"Hey! ");
    end,
    [320] = function(p)
        local trex = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(trex,0);
    end,
    [350] = function(p)
        CUTSCENE:setText(p,"....");
    end,
    [390] = function(p)
        CUTSCENE:setText(p," ");
        CUTSCENE:TRANSITION(p,2);
    end,
    [420] = function(p)
        Actor:setPosition(p,21,7,-244);
    end,
    [460] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:STOP_MUSIC(p);
        HX_Q:SET(p,"TUTORIAL",1);
        Actor:setPosition(p,21,7,-244);
        set2FarPosition(p,21,7,-244);

        RUNNER.NEW(function()
            HX_Q:PLAY_MUSIC(p,7)    
        end,{},40)
        
        local count = 0 ;
        local idHound = 50;
        local cx,cy,cz = 21,7,-225;
        local OBJ = MYTOOL.getObj_Area(cx,cy,cz,50,15,50); 
        local Objids = MYTOOL.filterObj("Creature",OBJ); 
        for i,objid in ipairs(Objids) do
            -- check modelID 
            local r,modelID = Creature:getActorID(objid);
            if modelID == idHound then 
                count = count + 1;
            end 
        end 
        -- calculate how many hound is needed to spawned 
        local houndNeed = 1-count;
        for i = 1 , houndNeed do 
            local r,obj = World:spawnCreature(cx,cy,cz,idHound,1) 
        end 
        RunQuest(p,"hellHoundBOSS_Tutorial",0);
    end
})

local santaPos = {
    x=22,y=7,z=-202
}

local santaNow = {};

CUTSCENE:CREATE("TUTORIAL_FINISHED",{
    [1] = function(p)
        -- pass 
        HX_Q:STOP_MUSIC(p)
    end,
    [5] = function(p)
        HX_Q:PLAY_MUSIC(p,20)
        local santa = CUTSCENE:createDoll(p,"mob_29",santaPos.x,santaPos.y,santaPos.z,20);
        santaNow[p] = santa;
    end,
    [10] = function(p)
        local tx,ty,tz = 22,7,-207;
        local santa = santaNow[p];
        Actor:setFaceYaw(santa,0);
        Actor:setFacePitch(santa,0);
        Actor:setPosition(p,tx,ty,tz);
        CUTSCENE:setCamera(tx+3,ty,tz+3,p);
    end,
    [25] = function(p)
        local tx,ty,tz = 22,7,-207;
        CUTSCENE:moveCamera(-5,0.5,8);
        CUTSCENE:setrotCamera(-55,15,1,p);
    end, 
    [30] = function(p)
        local santa = santaNow[p];
        CUTSCENE:showChat(santa,"#cffffff Thank You   ",1,3,260);
    end, 
    [35] = function(p)
        CUTSCENE:setText(p,"Santa : Thank You");
    end,
    [100] = function(p)
        local santa = santaNow[p];
        CUTSCENE:showChat(santa,"#cffffff You Saved Me ",1,3,250);
    end, 
    [110] = function(p)
        CUTSCENE:setText(p,"Santa : You Saved Me");
    end,
    [160] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [180] = function(p)
        CUTSCENE:showChat(p,"#cffffff You are Welcome           ",1,3,140);
        CUTSCENE:setText(p," You are Welcome");
    end,
    [220] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [240] = function(p)
        CUTSCENE:showChat(p,"#cffffff Actually I Got Lost...           ",1,3,140);
        CUTSCENE:setText(p," Actually I Got Lost...");
    end,
    [260] = function(p)
        local santa = santaNow[p];
        CUTSCENE:showChat(santa,"#cffffff Don't Worry I Know the Way ",1,3,240);
    end, 
    [265] = function(p)
        CUTSCENE:setText(p,"Santa : Don't Worry I Know the Way");
    end,
    [325] = function(p)
        CUTSCENE:setText(p," ");
    end,
    [355] = function(p)
        
        CUTSCENE:showChat(p,"#cffffff Great       ",1,3,140);
        CUTSCENE:setText(p,"Great");
    end,
    [370] = function(p)
        local santa = santaNow[p];
        CUTSCENE:showChat(santa,"#cffffff Let's Go ",1,3,260);
    end, 
    [375] = function(p)
        CUTSCENE:setText(p,"Santa : Let's Go");
    end,
    [410] = function(p)
        CUTSCENE:TRANSITION(p,2);
        Actor:setPosition(p,108,8,8);
    end,
    [470] = function(p)
        return true ;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,"TUTORIAL",3)

        set2FarPosition(p,108,8,8);
        RUNNER.NEW(function()
            if HX_Q:GET_CurQuest(p) == "none" then 
                CUTSCENE:start(p,"LAST_TUTORIAL");
            end 
        end,{},10)
    end
})

CUTSCENE:CREATE("DEFEATED_ON_TUTORIAL",{
    [1] = function(playerid)
       
    end,
    [20] = function(p)
        CUTSCENE:TRANSITION(p,2); 
    end,
    [60] = function(playerid)
        return true;
    end,
    ["END"] = function(playerid)
        local function set2FarPosition(playerid,x,y,z)
            if Actor:killSelf(playerid) == 0 then 
                Player:reviveToPos(playerid,x,y,z)
            end 
        end
        RUNNER.NEW(function()
            if HX_Q:GET_CurQuest(playerid) == "none" then 
                set2FarPosition(playerid,-156,7,-102)
                CUTSCENE:start(playerid,"FIRST_START")
            end 
        end,{},10)
    end
})


CUTSCENE:CREATE("DEFEATED_ON_TUTORIAL_BOSS",{
    [1] = function(playerid)
       
    end,
    [20] = function(p)
        CUTSCENE:TRANSITION(p,2); 
    end,
    [60] = function(playerid)
        return true;
    end,
    ["END"] = function(playerid)
        
        RUNNER.NEW(function()
            if HX_Q:GET_CurQuest(playerid) == "none" then 
                set2FarPosition(playerid,-4,7,-256)
                CUTSCENE:start(playerid,"FIGHT_BOSS_TUTORIAL")
            end 
        end,{},10)
    end
})

local LAST_SANTA = {} --Store Santa Model Temporary 
-- This is where Santa tells the story
CUTSCENE:CREATE("LAST_TUTORIAL", {
    [1] = function(p)
        -- Initial setup or camera transition can be added here if necessary
        HX_Q:PLAY_MUSIC(p,20);
    end,
    [20] = function(p)
        -- Create Doll using Santa Model and store it
        local x, y, z = 111, 8, 11 -- Coordinates for Santa's position
        local doll = CUTSCENE:createDoll(p, "mob_29" --[[is Santa model]], x, y, z)
        LAST_SANTA[p] = doll
    end,
    [50] = function(p)
        -- Santa welcomes the player to his house
        Actor:setFaceYaw(LAST_SANTA[p],0)
        local text = "Welcome to my house!" 
        local duration = 2
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240) -- Display chat above Santa
        CUTSCENE:setText(p, text) -- Display as subtitle text
    end,
    [100] = function(p)
        -- Player responds to Santa
        local text = "Thank you, Santa!"
        local duration = 2
        CUTSCENE:showChat(p, text, 1, duration, 140) -- Display chat above the player
        CUTSCENE:setText(p, text) -- Display as subtitle text
    end,
    [200] = function(p)
        -- Santa begins telling a story
        local text = "Listen..." 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240) -- Display chat above Santa
        CUTSCENE:setText(p, "Santa : "..text) -- Display as subtitle text
    end,
    [300] = function(p)
        -- Santa shares more details
        local text = "Long ago,Christmas spirit was lost..." 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240) -- Display chat above Santa
        CUTSCENE:setText(p, "Santa : "..text) -- Display as subtitle text
    end,
    [400] = function(p)
        -- Santa continues the story
        local text = "But with courage and kindness, it was saved!" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240) -- Display chat above Santa
        CUTSCENE:setText(p, "Santa : "..text) -- Display as subtitle text
    end,
    [500] = function(p)
        -- Santa reveals his weakened magic
        local text = "However, my magic has grown weak..." 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [600] = function(p)
        -- Santa explains the reason
        local text = "Power of Darkness far away has cursed me" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p,"Santa : "..text)
    end,
    [700] = function(p)
        -- Santa tasks the player
        local text = "You must defeat the Dark Lord to restore Christmas!" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [800] = function(p)
        -- Santa tasks the player
        local text = "I will give you Key to This House" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [900] = function(p)
        -- Santa tasks the player
        local text = "So you can Comeback here When ever you need" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [1000] = function(p)
        -- Santa tasks the player
        local text = "Please Save this Christmas!" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [1100] = function(p)
        -- Santa tasks the player
        local text = "Defeat that Dark Lord!" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [1200] = function(p)
        -- Santa tasks the player
        local text = "If you Need Something, Meet Me On Second Floor" 
        local duration = 3
        CUTSCENE:showChat(LAST_SANTA[p], text, 1, duration, 240)
        CUTSCENE:setText(p, "Santa : "..text)
    end,
    [1300] = function(p)
        return true -- End of cutscene
    end,
    ["END"] = function(p)
        -- Actions to execute when the cutscene ends or is skipped
        Player:setRevivePoint(p,52,16,145);
        HX_Q:SET(p,"X_MISSION_LAST_BOSS","MISSION_UNLOCKED");
        HX_Q:SET(p,"1MISSION_TUTORIAL","MISSION_UNLOCKED");
        LAST_SANTA[p] = nil;
        HX_Q:ShowReward(p,[[1004125]],"Santa's House Key","Item Obtained After Helping Santa's From Hellhound, Can be Used to Enter Santa's House.");
    end
})


ScriptSupportEvent:registerEvent("Player.NewInputContent",function(e)
    local playerid = e.eventobjid;
    local content = e.content;
    -- print("playerid :"..playerid.." Entering Content : "..content);
    if content == "C0001" then 
        HX_Q:SET(playerid,"TUTORIAL",3)
    end 
end)