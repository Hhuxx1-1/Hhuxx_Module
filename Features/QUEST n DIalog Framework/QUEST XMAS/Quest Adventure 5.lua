newline = "\n";
HX_Q:CREATE_QUEST(90,{
    name="Collect_Not_Yet", dialog = "Successfully Collected",
    [1] = function(p)
        if HX_Q:GET(p,"LUMINA_CHEST") ~= "OBTAINED" then
            return true;
        end 
    end,
    ["END"] = function(p)
        if VarLib2:setPlayerVarByName(p,5, "Lumina Blessing", true) == 0 then 
            HX_Q:SET(p,"LUMINA_CHEST","OBTAINED")
            HX_Q:ShowReward(p,[[1004232]],[[ Key of Light Gate]],"Key To Access Light Gate. With This Item Now You Can Pass The Gate Safely.");
        end 
    end
})
HX_Q:CREATE_QUEST(90,{
    name="Collect_Already", dialog = "You Already Collected This Chest",
    [1] = function(p)
        if HX_Q:GET(p,"LUMINA_CHEST") == "OBTAINED" then
            return true;
        end 
    end
})

local r , Story2 =  Area:createAreaRectByRange({x=-22,y=7,z=493},{x=-3,y=31,z=500});

ScriptSupportEvent:registerEvent("Player.AreaIn",function(e)
    local playerid,areaid = e.eventobjid,e.areaid;
    -- -- Chat:sendSystemMsg("Player : "..playerid.." leave areaid : "..areaid);
    if areaid == Story2 then 
        if HX_Q:GET(playerid,"STORY2") == "Empty" then 
            CUTSCENE:start(playerid,"STORY2_SANTA_IS_ATTACKED")
        end 
    end 
    -- if areaid == bugFailTeleport then 
    --     if HX_Q:GET(playerid,"DEFEATED_HOUND") == "TRUE" then
    --         set2FarPosition(playerid,-151,7,-206)
    --     end 
    -- end 
end)

local Santa_is_Attacked_Bandit = {}; -- maximum 3
CUTSCENE:CREATE("STORY2_SANTA_IS_ATTACKED",{
    [1] = function(p)
        HX_Q:STOP_MUSIC(p);
        CUTSCENE:setCamera(-15,7,525,p)
        CUTSCENE:setrotCamera(180,15,1,p)
    end,
    [2] = function(p)
        HX_Q:PLAY_MUSIC(p,15)
    end,
    [5] = function(p)
        
        Actor:tryNavigationToPos(p,-11,7,526)
    end,
    [60] = function(p)
        CUTSCENE:setrotCamera(15,15,3,p)
    end, 
    [100] = function(p)
        CUTSCENE:createDoll(p,[[mob_92]],5,7,544)
        CUTSCENE:createDoll(p,[[mob_92]],5,7,549)
        CUTSCENE:createDoll(p,[[mob_92]],5,7,554)
        CUTSCENE:createDoll(p,[[mob_95]],5,7,550)
    end,
    [110] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][4],-12,7,550);
    end,
    [120] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][3],3,7,554);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][2],3,7,549);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],3,7,544);
    end,
    [160] = function(p)
        CUTSCENE:setCamera(-6,7,557,p);
        CUTSCENE:setrotCamera(170,25,1,p);
        local text = "Ha Ha Ha! There is Nowhere to Run"
        CUTSCENE:DialogSay(1,"Bandit 1",p,text,3,90,15,230);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][4],-17,7,550);
    end,
    [230] = function(p)
        local text = "Help"
        CUTSCENE:DialogSay(4,"???",p,text,2,270,15,230);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][3],-1,7,554);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][2],-1,7,549);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],-1,7,544);
    end,
    [280] = function(p)
        local text = "Get Him Boys"
        CUTSCENE:DialogSay(2,"Bandit 2",p,text,2,90,15,230);
    end,
    [350] = function(p)
        CUTSCENE:setCamera(1,7,525,p);
        CUTSCENE:setrotCamera(-15,15,1,p);
        local text = "Hey Stop!"
        CUTSCENE:DialogSay(0,"You",p,text,2,90,15,230);
    end,
    [370] = function(p)
        CUTSCENE:moveCamera(-3,0.1,2,p);
    end,
    [400] = function(p)
        CUTSCENE:moveCamera(-4,0.1,2,p);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][3],0,7,540);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][2],-3,7,540);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],-6,7,540);
    end,
    [410] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][4],-37,7,570);
    end,
    [420] = function(p)
        CUTSCENE:moveCamera(-2,0.1,3,p);
        local text = "Who Are You?"
        CUTSCENE:DialogSay(1,"Bandit 3",p,text,2,0,15,230);
        Actor:tryNavigationToPos(p,-6,7, 528)
    end,
    [460] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][3],0,7,535);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][2],-3,7,537);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],-6,7,534);
    end,
    [520] = function(p)
        local text = "You Think You can Handle Us?"
        CUTSCENE:DialogSay(3,"Bandit 1",p,text,3,30,15,230);
    end,
    [620] = function(p)
        local text = "Let's Teach This Guy a Lesson!"
        CUTSCENE:DialogSay(2,"Bandit 2",p,text,3,15,15,230);
    end,
    [710] = function(p)
        return true;
    end,
    ["END"] = function(p)
        -- create 3 Enemies;
        for s = 1 , 3 do 
            if Santa_is_Attacked_Bandit[s] == nil then
                local r , obj = World:spawnCreature(3-(s*3),7,534-s,92,1) ;
                Santa_is_Attacked_Bandit[s] = obj[1];
            end 
        end 
        RUNNER.NEW(function()
            HX_Q:SET(p,"STORY2","DONE");
            HX_Q:PLAY_MUSIC(p,15)
            Player:setPosition(p,-6,7, 528)
            RunQuest(p,"DEFEAT_3_F_BANDIT",0);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(0,{
    name = "DEFEAT_3_F_BANDIT" , dialog = "Defeat Bandit" ,
    [1] = function(p)
        return false ; 
    end,
    [2] = function(p)
        local proggress = 3;
        for s = 1 , 3 do 
            local obj = Santa_is_Attacked_Bandit[s] ;
            -- get hp 
            local r , HP = Creature:getAttr(obj,2)
            if r ~= 0 then 
                proggress = proggress - 1 ;
            end 
        end 
        if proggress <= 0 then
            Santa_is_Attacked_Bandit = {};
            HX_Q:SHOW_QUEST(p,{
                open = false})
            return true 
        else 
            -- check player Current HP if it reaches bellow 1 then 
            local r , HPs = Player:getAttr(p, 2);
            if r == 0  then 

                if HPs >= 30 then 
                    HX_Q:SHOW_QUEST(p,{
                        open = true ,
                        text = "Defeat Bandit",
                        pic = [[3000092]],
                        detail = proggress.." Enemies Left"
                    })
                else 
                    HX_Q:SHOW_QUEST(p,{
                        open = false})
                    return true 
                end 
            else 
                HX_Q:SHOW_QUEST(p,{
                    open = false})
                return true 
            end 
        end 
    end, 
    [3] = function(p)
        RUNNER.NEW(function()
            local r , HPs = Player:getAttr(p, 2);
        if r == 0  then 
            if HPs >= 30 then 
                CUTSCENE:start(p,"Bandit_Win_Finished")
            else 
                CUTSCENE:start(p,"Bandit_Lost_Finished")
            end 
        else 
            CUTSCENE:start(p,"Bandit_Lost_Finished")
        end 
        end,{},1)
    end
})


CUTSCENE:CREATE("Bandit_Lost_Finished",{
    [1] = function(p)
        for i,a in ipairs(Santa_is_Attacked_Bandit) do
            local x,y,z = MYTOOL.GET_POS(a);
            CUTSCENE:createDoll(p,[[mob_92]],x,y,z);
            Actor:killSelf(a);
        end 
    end,
    [2] = function(p)
        local r = Player:setAttr(p,2,30) ;
    end,
    [20] = function(p)
        local text = "Haha Loser!"
        CUTSCENE:DialogSay(1,"Bandit 3",p,text,2,0,15,230);
    end,
    [60] = function(p)
        local text = "Bye Loser"
        CUTSCENE:DialogSay(2,"Bandit 2",p,text,2,0,15,230);
    end
    ,
    [80] = function(p)
        local text = "Noob"
        CUTSCENE:DialogSay(3,"Bandit 1",p,text,2,0,15,230);
    end,
    [160] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][3],8,7,555);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][2],7,7,553);
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],6,7,551);
    end,
    [300] = function(p)
        return true;
    end,
    ["END"] = function(p)
        HX_Q:SET(p,"LOSE_TO_BANDIT","TRUE");
        Player:notifyGameInfo2Self(p,"You Lost Some Golds");
        local c = GLOBAL_CURRENCY:GetCurrency(p,"Coin");
        Player:notifyGameInfo2Self(p,"-"..math.floor(c/4).." Coins")
        GLOBAL_CURRENCY:DecreaseCurrency(p,"Coin",math.floor(c/4));
        RUNNER.NEW(function()
            CUTSCENE:start(p,"Bandit_Win_Finished")
        end,{},1)
    end
})

CUTSCENE:CREATE("Bandit_Win_Finished",{
    [1] = function(p)
        Actor:tryNavigationToPos(p,-3,7, 541);
        CUTSCENE:setrotCamera(0,15,1,p);
    end,
    [40] = function(p)
        local text = "I Managed to Defeat Those Bandit"
        -- Chat:sendSystemMsg("HX_Q:GET"..HX_Q:GET(p,"LOSE_TO_BANDIT"))
        if HX_Q:GET(p,"LOSE_TO_BANDIT") ~= "Empty" then 
            text = "I Defeated by Those Bandit"
        end 
        CUTSCENE:DialogSay(0,"You",p,text,3,0,15,230)
    end,
    [130] = function(p)
        local text = "Where Did That Minion Go?"
        CUTSCENE:DialogSay(0,"You",p,text,3,0,15,230)
    end,
    [220] = function(p)
        local text = "I Think He Run Away to the Left"
        CUTSCENE:DialogSay(0,"You",p,text,3,0,15,230)
    end,
    [310] = function(p)
        local text = "I'm Gonna Go Check It Out"
        CUTSCENE:DialogSay(0,"You",p,text,3,0,15,230)
    end, 
    [400] = function(p)
        return true;
    end,
    ["END"] = function(p)
        RUNNER.NEW(function()
            RunQuest(p,"Find_That_Minion",0);
        end,{},1)
    end
})
local arrowe = {};
local smallestRange = {};

local function getDistance2Target(p,x,y,z)
    local r,px,py,pz = Actor:getPosition(p)
    local calculate_distance = function(px, py, pz, x, y, z)
        return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
    end
    return math.floor(calculate_distance(px,py,pz,x,y,z)); 
end

HX_Q:CREATE_QUEST(0,{
    name = "Find_That_Minion" , dialog = "No Dialog",
    [1] = function(p)
        return false; 
    end , 
    [2] = function(p)
        local x,y,z = -83,7,677; 
        local dis = getDistance2Target(p,x,y,z);
        if dis <= 14 then
            HX_Q:SHOW_QUEST(p, { open = false});
            HX_Q:DeletePointingArrowForPlayer(p,arrowe[p])
            arrowe[p] = nil;
            return true 
        else 
            HX_Q:SHOW_QUEST(p, { open=true,text = "Follow That Minion Path" , detail=dis.." Block Away"});
            -- create Graphic info on Location  
            if arrowe[p] == nil then
                local data = HX_Q:CreatePointingArrowForPlayer(p,x,y,z,1);
                arrowe[p] = data;
                -- print("an Arrow Created : ",data);
            end 
        end 
    end , 
    [3] = function(p)
        RUNNER.NEW(function()
            CUTSCENE:start(p,"A_LOT_OF_BANDIT_NEAR_THE_CAMP");
        end,{},1)
    end
})

local Bandit_Near_Camp = {
    {x=-65,y=7,z=656},
    {x=-68,y=7,z=654},
    {x=-71,y=7,z=652},
    {x=-74,y=7,z=644},
    {x=-79,y=7,z=647},
    {x=-78,y=7,z=643},
    {x=-88,y=7,z=646},
    {x=-92,y=7,z=647},
    {x=-94,y=7,z=651},
    {x=-80,y=7,z=654}
}

local Santa_is_Attacked_Bandit_2 = {}
CUTSCENE:CREATE("A_LOT_OF_BANDIT_NEAR_THE_CAMP",{
    [1] = function(p)
        Actor:tryNavigationToPos(p,-83,7, 667)
    end,
    [2] = function(p)
        for i,a in ipairs(Bandit_Near_Camp) do 
            CUTSCENE:createDoll(p,[[mob_92]],a.x,a.y,a.z);
            CUTSCENE:createDoll(p,[[mob_92]],a.x+2,a.y,a.z-2);
            CUTSCENE:createDoll(p,[[mob_92]],a.x-1,a.y,a.z-2);
        end 
    end, 
    [5] = function(p)
        CUTSCENE:setrotCamera(180,13,1,p);
    end,
    [30] = function(p) 
        for i = 1 , #Bandit_Near_Camp*3  do
            local act = CUTSCENE.DOLLS[p][i];
            local x,y,z = MYTOOL.GET_POS(p)
            Actor:tryMoveToPos(act,x,y,z,1);
       end
    end,
    [40] = function(p)
       for i = 1 , #Bandit_Near_Camp*2 , 2 do
            CUTSCENE:DialogSay(i,"Bandit "..i,p,"ATTACK!!!",4,0,0,math.random(230,250));
       end
    end,
    [45] = function(p) 
        for i = 1 , #Bandit_Near_Camp*3  do
            local act = CUTSCENE.DOLLS[p][i];
            local x,y,z = MYTOOL.GET_POS(p)
            Actor:tryMoveToPos(act,x,y,z,1);
       end
    end,
    [48] = function(p)
        CUTSCENE:TRANSITION(p,1)
    end,
    [60] = function(p)
        return true;
    end,
    ["END"] = function(p)
        local c = 1;
        for i,a in ipairs(Bandit_Near_Camp) do 
            if Santa_is_Attacked_Bandit_2[c] == nil then
                local r , obj = World:spawnCreature(a.x,a.y,a.z+4,92,1);
                Santa_is_Attacked_Bandit_2[c] = obj[1];
            end 
            c = c +1
        end 
        for i,a in ipairs(Bandit_Near_Camp) do 
            if Santa_is_Attacked_Bandit_2[c] == nil then
                local r , obj = World:spawnCreature(a.x-1,a.y,a.z+6,92,1);
                Santa_is_Attacked_Bandit_2[c] = obj[1];
            end 
            c = c +1
        end 
        for i,a in ipairs(Bandit_Near_Camp) do 
            if Santa_is_Attacked_Bandit_2[c] == nil then
                local r , obj = World:spawnCreature(a.x+2,a.y,a.z+6,92,1);
                Santa_is_Attacked_Bandit_2[c] = obj[1];
            end 
            c = c +1
        end 

        RUNNER.NEW(function()
            local x,y,z = -97,7,695;
            HX_Q:SET(p,[[X_HOME]],x);
            HX_Q:SET(p,[[Y_HOME]],y);
            HX_Q:SET(p,[[Z_HOME]],z);
            
            -- Player has Home Point Set, so start on Home Point
            if Player:setRevivePoint(p,tonumber(x),tonumber(y),tonumber(z))== 0 then 
                Player:notifyGameInfo2Self(p,"Successfully Updated Respwawn Point Automatically!");
            end 
                
            RunQuest(p,"Defeat_Raid_Tutorial_1",0);
        end,{},1)
    end
})

HX_Q:CREATE_QUEST(0,{
    name = "Defeat_Raid_Tutorial_1" , dialog = "Defeat Bandit" ,
    [1] = function(p)
        return false ; 
    end,
    [2] = function(p)
        local proggress = #Bandit_Near_Camp*3;
        for i,a in ipairs(Santa_is_Attacked_Bandit_2) do 
            -- get hp 
            local r , HP = Creature:getAttr(a,2)
            if r ~= 0 then 
                proggress = proggress - 1 ;
            else 
                local x,y,z = MYTOOL.GET_POS(a);
                local px,py,pz = MYTOOL.GET_POS(p);
                local dist = math.sqrt((x-px)^2+(y-py)^2+(z-pz)^2);
                if dist > 22 then
                    Actor:tryMoveToPos(a,px,py,pz,1);
                end 
            end 
        end 
        if proggress <= 0 then
            Santa_is_Attacked_Bandit_2 = {};
            HX_Q:SHOW_QUEST(p,{
                open = false})
            return true 
        else 
            -- check player Current HP if it reaches bellow 1 then 
            HX_Q:SHOW_QUEST(p,{
                open = true ,
                text = "Defeat Bandit Raid",
                pic = [[3000092]],
                detail = proggress.." Enemies Left"
            })
        end 
    end, 
    [3] = function(p)
        RUNNER.NEW(function()
            HX_Q:SET(p,"DEFEAT_150_BANDIT_FROM_NOW",0);
            CUTSCENE:start(p,"YOUR_FIRST_RAID_SUCCEED");
        end,{},20)
    end
})

local function Phase2_Requirement_Mission(p)
    local data = {title = "Santa's Siege Problem" , desc="Help Santa Recover Lost Gift, Defeat Bandit and Find Run Away Reindeer"}
    local sResult = false;
    -- data[s] = {
    --     url = iconid,
    --     check = true,
    --     text = "Equipped"
    -- }

    local FOUND_RUN_AWAY_REINDEER = HX_Q:GET(p,"FOUND_RUN_AWAY_REINDEER")  
    if FOUND_RUN_AWAY_REINDEER == "Empty" then 
        FOUND_RUN_AWAY_REINDEER = 0;
    end 

    data[1] = {
        url = [[3003403]],
        check = tonumber(FOUND_RUN_AWAY_REINDEER) >= 4 ,
        text = "Find The Lost Deer"..newline.." ( "..FOUND_RUN_AWAY_REINDEER.."/4 Dear Found )"
    }

    local RECOVERED_GIFT_PROGGRESS = HX_Q:GET(p,"RECOVERED_GIFT_PROGGRESS")  
    if RECOVERED_GIFT_PROGGRESS == "Empty" then 
        RECOVERED_GIFT_PROGGRESS = 0;
    end 

    data[2] = {
        url = [[10076]],
        check = tonumber(RECOVERED_GIFT_PROGGRESS) >= 50 ,
        text = "Lost Gift Recovered"..newline.." ( "..RECOVERED_GIFT_PROGGRESS.."/50 Gift )"
    }

    local DEFEAT_150_BANDIT_FROM_NOW = HX_Q:GET(p,"DEFEAT_150_BANDIT_FROM_NOW")  
    if DEFEAT_150_BANDIT_FROM_NOW == "Empty" then 
        DEFEAT_150_BANDIT_FROM_NOW = 0;
    end 

    data[3] = {
        url = [[3000092]],
        check = tonumber(DEFEAT_150_BANDIT_FROM_NOW) >= 150 ,
        text = "Defeat"..newline.." ( "..DEFEAT_150_BANDIT_FROM_NOW.."/150 ) Bandit"
    }

    if tonumber(RECOVERED_GIFT_PROGGRESS) >= 50 
    and tonumber(DEFEAT_150_BANDIT_FROM_NOW) >= 150 
    and tonumber(FOUND_RUN_AWAY_REINDEER) >= 4  then 
        sResult = true ;
    end 

    if not sResult then 
        REQUIREMENT_UI:open(p,data);
    else 
        return true;
    end 

end

HX_Q:CREATE_QUEST(16,{
    name = "Erlang1" , dialog = "You Still Need To Do Something For Us!",
    [1] = function(p)
        if HX_Q:GET(p,"CUTSCENE_ON_BANDIT_RAID") == "DONE" 
        and HX_Q:GET(p,"PHASE_2_PROGGRESS") == "Empty" 
        then 
            return true;
        else 
            return false 
        end 
    end,["END"] = function(p)
        if Phase2_Requirement_Mission(p) then 
            RUNNER.NEW(function()
                HX_Q:ShowReward(p,[[1012709]],"Outsider Gate",[[Can Be Used To Pass Outsider Gate]]);
                HX_Q:SET(p,"PHASE_2_PROGGRESS","DONE");
            end,{},1)
        end 
    end
})

HX_Q:CREATE_QUEST(16,{
    name = "Erlang2" , dialog = "Thank You For Helping Us!, (Current Map is Under Development Version.",
    [1] = function(p)
        if HX_Q:GET(p,"CUTSCENE_ON_BANDIT_RAID") == "DONE" 
        and HX_Q:GET(p,"PHASE_2_PROGGRESS") == "DONE" 
        then 
            return true;
        else 
            return false 
        end 
    end
})

CUTSCENE:CREATE("YOUR_FIRST_RAID_SUCCEED",{
    [1] = function(p)
       CUTSCENE:setCamera(-90,7,700,p);
       CUTSCENE:setrotCamera(270,13,1,p); 
       CUTSCENE:createDoll(p,[[mob_95]],-91,7,699);
    end,
    [10] = function(p)
       Actor:tryNavigationToPos(p,-85,7,698)
    end,
    [40] = function(p)
        local text = "Thank You Very Much Adventurer!"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [125] = function(p)
        local text = "You Helped Us Defeat Those Bandits"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [220] = function(p)
        local text = "We Actually Have a Problem"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [310] = function(p)
        local text = "Because of Those Bandits Attack"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [360] = function(p)
        CUTSCENE:setCamera(-73,7,677,p);
        CUTSCENE:setrotCamera(75,13,1,p); 
    end,
    [405] = function(p)
        local text = "We Lost Our Gift and Reindeer Run Away"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [460] = function(p)
        CUTSCENE:setCamera(-90,7,700,p);
        CUTSCENE:setrotCamera(270,13,1,p); 
    end,
    [500] = function(p)
        local text = "We Really Need Your Help!"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [595] = function(p)
        local text = "We Will Give you The Key to Open Outside Gate"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [685] = function(p)
        local text = "So You Could Continue Your Journey"
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [780] = function(p)
        local text = "You Can Talk to Lord Erlang for What Needed"
        CUTSCENE:setCamera(-92,7,709,p);
        CUTSCENE:setrotCamera(310,13,1,p); 
        CUTSCENE:DialogSay(1,"Santa",p,text,3,270,1,230)
    end,
    [880] = function(p)
        return true;
    end,
    ["END"] = function(p)
        local missionList = {
            "FIND_LOST_REINDEER","DEFEAT_150_BANDIT","GET_BACK_50_GIFT_FROM_GRINCH"
        };
        for i,a in ipairs(missionList) do 
            RUNNER.NEW(function()
                MISSION_TRACKER:SET_UNLOCKED(p,a)    
            end,{},i*41);
        end 
        RUNNER.NEW(function()
            HX_Q:SET(p,"CUTSCENE_ON_BANDIT_RAID","DONE");
        end,{},10)
    end
})

local reindeer_holder = { };

for reindeer = 98 , 101 do 
    HX_Q:CREATE_QUEST(reindeer,{
        name="Collect_Not_Yet", dialog = "Successfully Found The Missing Reindeer. Now You Need to Return it Back. You can Only Get One Reindeer In Single Time.",
        [1] = function(p)
            if HX_Q:GET(p,"REINDEER"..reindeer-97) ~= "OBTAINED" then
                return true;
            end 
        end,
        [2] = function(p)
            if reindeer_holder[p] == nil then 
                -- create one reindeer that will follow player. 
                local x,y,z = MYTOOL.GET_POS(p)
                local r,obj = World:spawnCreature(x,y,z,102,1); --spawn 1 reindeer
                reindeer_holder[p] = obj[1]; -- obj is array contain 
            else 
                -- check if it has hp 
                local r,hp = Creature:getAttr(reindeer_holder[p],2)
                -- Chat:sendSystemMsg("R : "..r.." , HP : "..hp)
                if r == 0 then 
                    if hp > 0 then
                    -- reindeer is still exist;
                    -- obtain player and that object position 
                        local x,y,z = MYTOOL.GET_POS(p);
                        local x2,y2,z2 = MYTOOL.GET_POS(reindeer_holder[p]);
                        -- calculate_distance
                        local distance = MYTOOL.calculate_distance(x,y,z,x2,y2,z2);
                        if distance > 4 then
                            -- make the reindeer move closer to player;
                            Actor:tryMoveToPos(reindeer_holder[p],x,y,z,1+(distance/5));
                        end 
                        -- pathfinder logic;
                        -- based from player position;
                        local tx,ty,tz = -83,7,677; 
                        local distance_2_goal = math.floor(MYTOOL.calculate_distance(x2,y2,z2,tx,ty,tz));
                        if distance_2_goal > 10 then 
                            HX_Q:SHOW_QUEST(p, { open=true,text = "Return the Reindeer Into Santa's Camp" , detail=distance_2_goal.." Block Away"});
                        else
                            HX_Q:SHOW_QUEST(p, { open = false});
                            return true 
                        end 
                    else
                        -- player reindeer is gone; 
                        reindeer_holder[p] = nil;
                    end 
                else
                    -- player reindeer is gone; 
                    reindeer_holder[p] = nil;
                end 
            end 


        end,
        [3] = function(p)
            if World:despawnActor(reindeer_holder[p]) == 0 then 
                reindeer_holder[p] = nil;   

                HX_Q:SET(p,"REINDEER"..reindeer-97,"OBTAINED");
                -- increase the FOUND_RUN_AWAY_REINDEER
                local FOUND_RUN_AWAY_REINDEER = HX_Q:GET(p,"FOUND_RUN_AWAY_REINDEER");
                -- check if it is empty 
                if FOUND_RUN_AWAY_REINDEER == "Empty" then
                    FOUND_RUN_AWAY_REINDEER = 0 ;
                end 
                HX_Q:SET(p,"FOUND_RUN_AWAY_REINDEER",FOUND_RUN_AWAY_REINDEER + 1 );
                CUTSCENE:start(p,"RETURNED_A_REINDEER");
            end 

        end
    })
    HX_Q:CREATE_QUEST(reindeer,{
        name="Collect_Already", dialog = "You Already Found This Reindeer",
        [1] = function(p)
            if HX_Q:GET(p,"REINDEER"..reindeer-97) == "OBTAINED" then
                return true;
            end 
        end
    })
end 

CUTSCENE:CREATE("RETURNED_A_REINDEER",{
    [1] = function(p)
        CUTSCENE:setCamera(-87,7, 672,p);
    end,
    [2] = function(p)
        CUTSCENE:setrotCamera(90,15,1,p);
    end,
    [10] = function(p)
        CUTSCENE:createDoll(p,[[mob_102]],-84,7,654,20);
    end,
    [20] = function(p)
        Actor:tryMoveToPos(CUTSCENE.DOLLS[p][1],-85,7,683,2);
        CUTSCENE:setText(p,"Successfully Returned Reindeer Safely");
    end,
    [80] = function(p)
        return true
    end,
    ["END"] = function(p)
        local FOUND_RUN_AWAY_REINDEER = HX_Q:GET(p,"FOUND_RUN_AWAY_REINDEER");
        Chat:sendSystemMsg("You Already Found "..FOUND_RUN_AWAY_REINDEER.." Reindeer",p);
    end 
})

local bandit = 92;

ScriptSupportEvent:registerEvent("Player.DefeatActor",function(e)
    local playerid = e.eventobjid;
    local actorid = e.targetactorid;
    if HX_Q:GET(playerid,"DEFEAT_150_BANDIT_FROM_NOW") ~= "Empty" then 
        if actorid == bandit then 
            local Proggress = tonumber(HX_Q:GET(playerid,"DEFEAT_150_BANDIT_FROM_NOW"));
            local maks = 150;
            HX_Q:SET(playerid,"DEFEAT_150_BANDIT_FROM_NOW",math.min(Proggress + 1,maks));
        end 
    end 
end)

for gift = 96 , 97 do 
    HX_Q:CREATE_QUEST(gift,{
        name="Collect_Already", dialog = "Collect This Gift?",
        [1] = function(p)
                return true;
        end,["END"] = function(p)
            local npc = HX_Q.CURRENT_NPC[p].npc;
            if Actor:killSelf(npc) == 0 then 
                local Proggress = tonumber(HX_Q:GET(p,"RECOVERED_GIFT_PROGGRESS"));
                local maks = 50;
                HX_Q:SET(p,"RECOVERED_GIFT_PROGGRESS",math.min(Proggress + 1,maks));
            end 
        end
    })
end 