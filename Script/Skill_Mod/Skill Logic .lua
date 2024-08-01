--[[Configuration Buff of Skill Set]]
skill = {
	active = {
		50000000,50000001,50000002
	},
	cooldown ={
		50000003,50000004,50000005
	}
}

local function whatSkill(buffid)
local SKILL = 0;
for i,a in ipairs(skill.active) do 
	if(a==buffid)then
		SKILL=i;
		break;
	end 
end
return SKILL;
end

local function loadPlayerSkill(n,playerid)
    local result,ret=Valuegroup:getAllGroupItem(18,"SkillSet", playerid);
    return ret[n];
end

local function Second2Thick(seconds)
    if type(seconds) ~= "number" or seconds < 0 then
        return "Invalid input" -- Handle invalid input
    end

    local thickPerSecond = 20
    local thick = seconds * thickPerSecond

    return thick
end

local function setToCooldown(n,cd,playerid)
   Actor:addBuff(playerid,skill.cooldown[n],1,Second2Thick(cd))
end

function ActiveSkill(skillName,n,c,d,playerid)
		local isMP,MP=Player:getAttr(playerid,6)
		local S = act[skillName];
		if(S == nil)then 
		    S = act["empty"];
		end 
		local cd = S["CD"];
		local cost = S["Cost"];
		local afterCost = MP-cost;
		if( afterCost>-1 )then
			local effect = S["main"](playerid);
			setToCooldown(n,cd,playerid);
			Player:setAttr(playerid,6,afterCost);
			return true
		else
			return false
		end
end

ScriptSupportEvent:registerEvent("Player.AddBuff",function(e) 
	local buffid = e.buffid;local n = whatSkill(buffid);local playerid = e.eventobjid;
	if (n~=0)then 
		local result = ActiveSkill(loadPlayerSkill(n,playerid),n,c,d,playerid);
		if(not result)then
			Player:notifyGameInfo2Self(playerid,"#R MP low ")
		end
	end
end)