local UIElement = {};
UIElement.uiid = "7386694522892916978"; 
local UIElement_mt = {__index = function(self,key)    return self.uiid .."_"..key
end};   local UIElement = setmetatable(UIElement,UIElement_mt);


local ftoexec = {};

local btn = {
    HP_UP = UIElement[17],
    MP_UP = UIElement[21],
    PA_UP = UIElement[25],
    MA_UP = UIElement[29],
}


local IncreaseStat = function(playerid,WhichStat,increment)
    if increment == nil then increment = 1 end 
    if(PLAYER_DAT.CONSUME_SKILLPOINT(playerid,increment))then 
        local currentStat = PLAYER_DAT.TYPE[WhichStat].get(playerid);
        --print("Increasing ",playerid,WhichStat,"by",increment," Current stat is : ",currentStat);
        local afterUpdate = currentStat + increment;
        PLAYER_DAT.TYPE[WhichStat].f(playerid,afterUpdate);
        return true ;
    else 
        return false;
    end 
end

local function askforBoostExp(playerid)
    local itemidsbuff = {4111,4112,4113};
    Player:openDevGoodsBuyDialog(playerid, itemidsbuff[math.random(1,3)], "Boost Exp Rewards by Watching Ads")
end 

ftoexec.HP_UP = function(playerid)
    if(IncreaseStat(playerid,"SKILL_HP_POINT",1))then 
        Player:notifyGameInfo2Self(playerid,"Succesfully Upgrade Max HP");
        return true ;
    else 
        Player:notifyGameInfo2Self(playerid,"Not Enough Skill Point to Upgrade Max HP");
        askforBoostExp(playerid);
        return false ;
    end 
end;
ftoexec.MP_UP = function(playerid)
    if(IncreaseStat(playerid,"SKILL_MP_POINT",1))then 
        Player:notifyGameInfo2Self(playerid,"Succesfully Upgrade Max Mana");
        return true ;
    else 
        Player:notifyGameInfo2Self(playerid,"Not Enough Skill Point to Upgrade Max Mana");
        askforBoostExp(playerid);
        return false ;
    end 
end;
ftoexec.PA_UP = function(playerid)
    if(IncreaseStat(playerid,"SKILL_ATK_POINT",1))then 
        Player:notifyGameInfo2Self(playerid,"Succesfully Upgrade Physical Atk");
        return true ;
    else 
        Player:notifyGameInfo2Self(playerid,"Not Enough Skill Point to Upgrade Physical Atk");
        askforBoostExp(playerid);
        return false ;
    end 
end;
ftoexec.MA_UP = function(playerid)
    if(IncreaseStat(playerid,"SKILL_MATK_POINT",1))then 
        Player:notifyGameInfo2Self(playerid,"Succesfully Upgrade Magic Atk");
        return true ;
    else 
        Player:notifyGameInfo2Self(playerid,"Not Enough Skill Point to Upgrade Magic Atk");
        askforBoostExp(playerid);
        return false ;
    end 
end;

local function LoadStat(playerid)
    local stat = PLAYER_DAT.OBTAIN_STAT(playerid);
    PLAYER_DAT.TYPE.MAX_HP.f(playerid,stat.HP);PLAYER_DAT.TYPE.CUR_HP.f(playerid,stat.HP);
    PLAYER_DAT.TYPE.MAX_HUNGER.f(playerid,stat.Mana);PLAYER_DAT.TYPE.CUR_HUNGER.f(playerid,stat.Mana);
    PLAYER_DAT.TYPE.ATK_MELEE.f(playerid,stat.P_ATK);PLAYER_DAT.TYPE.ATK_REMOTE.f(playerid,stat.P_ATK);
end



ScriptSupportEvent:registerEvent([[UI.Button.Click]],function(e)
    local ebtn = e.uielement;
    -- print(e);
    local playerid = e.eventobjid;  
    for i,a in pairs(btn) do 
        -- print(btn);
        if a == ebtn then
            if(ftoexec[i](playerid))then 
                LoadStat(playerid);
            end 
        end 
    end 
    -- Test if local UI script can call global variables or not
    --print("Trying to Call PLAYER_DAT",PLAYER_DAT); --Returned Nil 
    -- Result Unable to Call Global From Script 
    -- Must use Local Defined 
end)