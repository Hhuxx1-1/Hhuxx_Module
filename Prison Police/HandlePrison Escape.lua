local r,prisonArea = Area:createAreaRectByRange({x=-109,y=21,z=-57},{x=71,y=36,z=68})

local function CurrentTeam(playerid)
    -- obtain team id  from player data
    local r, val = VarLib2:getPlayerVarByName(playerid,3,"TEAM_ID");
    if r == 0 then return val end 
end

local isPrisoner = 50000002;

local function setEscaped(playerid)
    -- get team 
    local team = CurrentTeam(playerid);
    if team == 1 then 
        -- now check for the buff 
        if Actor:hasBuff(playerid,isPrisoner) == 0 or true then 
            if VarLib2:setPlayerVarByName(playerid, 4, "Place Now" , " YOU ESCAPED !")  == 0 then 
                Actor:removeBuff(playerid,isPrisoner);
                Player:openUIView(playerid,[[7429610334330755314]]);
            end 
        end 
    end
end

ScriptSupportEvent:registerEvent([=[Player.AreaOut]=],function(e)
    local playerid = e.eventobjid; 
    local areaid = e.areaid;
    if prisonArea == areaid then 
        setEscaped(playerid)
    end 
end)