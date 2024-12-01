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
    [40]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFaceYaw(santa,270)
        Actor:setFacePitch(santa,15)
        local text = "Thank You for Rescuing Santa";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [135]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,25)
        local text = "Anyway Someone is Waiting you";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [200]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,5)
        local text = "He Call himself Captain Tom";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [290]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,25)
        local text = "Just Move Straight Forward";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [380]=function(p)
        local santa = CUTSCENE.DOLLS[p][1];
        Actor:setFacePitch(santa,5)
        local text = "He is Already Waiting For you";
        CUTSCENE:showChat(santa,text,1,3,230);
        CUTSCENE:setText(p,"Santa's Minion : "..text);
    end,
    [470] = function(p)
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