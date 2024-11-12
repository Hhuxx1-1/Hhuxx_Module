local function openUIDefault(playerid)
    local uiid = [[7418405533454637298]];
    
    Player:openUIView(playerid,uiid);
end 

local function CurrentTeam(playerid)
    -- obtain team id  from player data
    local r, val = VarLib2:getPlayerVarByName(playerid,3,"TEAM_ID");
    if r == 0 then return val end 
end

local function isEven(number)
    return number % 2 == 0
end

local items_for_police = {
    {itemid=4102,num=1},{itemid=4100,num=1},{itemid=4101,num=1},{itemid=4109,num=1}
}
local items_for_prisoner = {
    {itemid=4117,num=1},{itemid=4118,num=1}
}

local function Reset_Init(playerid)
    if Backpack:clearAllPack(playerid)==0 then return true else return false end
end

local INIT_ITEM = function(playerid,team)
    if Reset_Init(playerid) then 
        if team == 2 then 
            -- this is Police 
            for i,v in ipairs(items_for_police) do 
                if Player:gainItems(playerid,v.itemid,v.num,1) == 0 then 
                    if Player:setItemAttAction(playerid,v.itemid,1,true) == 0 and Player:setItemAttAction(playerid,v.itemid,2,true) then 
                        -- return true; Pass
                    else 
                        return false 
                    end 
                else 
                    return false;
                end 
            end 
            return true;
        elseif team == 1 then  
            for i,v in ipairs(items_for_prisoner) do 
                if Player:gainItems(playerid,v.itemid,v.num,1) == 0 then 
                    if Player:setItemAttAction(playerid,v.itemid,1,true) == 0 and Player:setItemAttAction(playerid,v.itemid,2,true) then 
                        -- return true; Pass 
                    else 
                        return false 
                    end 
                else 
                    return false;
                end 
            end 
            return true;
        else 
            print("Error: Player is not in a team")
            return false;
        end 
    end 
end

local function CheckTeam(playerid)
    local team = 0 ;
    if CurrentTeam(playerid) ~= 0 then 
        team = CurrentTeam(playerid);
    else 
        local n = "";
        if isEven(playerid) then 
            team = 2;
            n = "#c86CEFA POLICE TEAM "
        else   
            team = 1;
            n = "#cFF8C00 PRISON TEAM "
        end 

        local r = VarLib2:setPlayerVarByName(playerid,3,"TEAM_ID",team);
        if r==0 then
            Chat:sendSystemMsg("You Are "..n);
        end
    end 
    if Player:setTeam(playerid,team) == 0 then 
        if INIT_ITEM(playerid,team) then 
            RUNNER.NEW(function()
                local r = Actor:killSelf(playerid);
            end,{},5);
        end 
    end 
end 

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e) 
    for i=0,2 do 
        RUNNER.NEW(function()
            openUIDefault(e.eventobjid)
        end,{},10*i);
    end
    RUNNER.NEW(function()
        CheckTeam(e.eventobjid);
    end,{},30)
end)


ITEM_SHOP.REGISTER_NEW_ITEM(4120,function(e)  local playerid = e.eventobjid;
    if Player:removeBackpackItem(playerid, 4120, 1) == 0 then 
        if VarLib2:setPlayerVarByName(playerid,3,"TEAM_ID",1) == 0 then 
            CheckTeam(playerid)
            Chat:sendSystemMsg("You Are Now #cFF8C00 PRISON TEAM ");
        end 
    end 
end );

ITEM_SHOP.REGISTER_NEW_ITEM(4119,function(e)  local playerid = e.eventobjid;
    if Player:removeBackpackItem(playerid, 4119, 1) == 0 then 
        if VarLib2:setPlayerVarByName(playerid,3,"TEAM_ID",2) == 0 then 
            CheckTeam(playerid)
            Chat:sendSystemMsg("You Are Now #c86CEFA POLICE TEAM ");
        end 
    end 
end );

-- [[ Handle Prisson Arrested ]]

local ARRESTED_BUFF = 50000006;

ScriptSupportEvent:registerEvent([[Player.AddBuff]],function(e)
    local playerid = e.eventobjid ;  local buffid= e.buffid;
    if buffid == ARRESTED_BUFF then  
        local team = CurrentTeam(playerid);
        if INIT_ITEM(playerid,team) then 
            RUNNER.NEW(function()
                local r = Actor:killSelf(playerid);
            end,{},5);
        end 
    end 
end)