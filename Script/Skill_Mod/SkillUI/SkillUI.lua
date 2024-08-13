--[[Skill_Mod]]
local Position = {};
local skill = {
	active = {
		50000000,50000001,50000002
	},
	cooldown ={
		50000003,50000004,50000005
	}
}
local uiid = "7352431270965221618"

local function element(ID) 
    return(uiid.."_"..ID)
end 
local sb1,sb2,sb3   = element(9),element(10),element(11)
local sk1,sk2,sk3   = element(12),element(13),element(14)
local st1,st2,st3   = element(15),element(16),element(17)
local cdd1,cdd2,cdd3= element(37),element(38),element(39)

local function getPlayerSkill(playerid)--get Skill Name Correspond from Skill Set Owned by Player Name
    local result,ret=Valuegroup:getAllGroupItem(18,"SkillSet", playerid)
    local s1,s2,s3 = ret[1],ret[2],ret[3];
    return s1,s2,s3 ;
end

ScriptSupportEvent:registerEvent("UI.Show",function(e) 
    local playerid=e.eventobjid;
    local ns1,ns2,ns3 = getPlayerSkill(playerid);
    if(url[ns1]==nil)then ns1= "empty"; end ;
    if(url[ns2]==nil)then ns2= "empty"; end ;
    if(url[ns3]==nil)then ns3= "empty"; end ;
    Customui:setTexture(playerid, uiid, sk1, url[ns1])
    Customui:setTexture(playerid, uiid, sk2, url[ns2])
    Customui:setTexture(playerid, uiid, sk3, url[ns3])
end)

local function whatSkillCD(buffid)
local SKILL = 0;
for i,a in ipairs(skill.cooldown) do 
	if(a==buffid)then
		SKILL=i;
		break;
	end 
end
return SKILL;
end

local thickPerSecond = 20;

local function Thick2Second(thick)
    --print("Thick = ",type(thick));
    if thick ~= nil then 
        if type(thick) ~= "number" then
            return "Invalid" -- Handle invalid input
        end

        return math.ceil(thick / thickPerSecond),thick;
    else 
        return "Invalid";
    end 
end

local function getSec(playerid,buffid)
    local r = Actor:hasBuff(playerid,buffid);
    if r==0 then 
        local result,ticks=Actor:getBuffLeftTick(playerid,buffid)
        --print( "getting Actor from ", r, result, "ticks = ", ticks );
        if result==0 then 
            local second,thk = Thick2Second(ticks);
            --print(type(second),"Is Second Type");
            if type(second) ~= "number" then
                return false;
            else
                return tonumber(second),thk;
            end
        else 
            return false;
        end 
    else 
        return false;
    end 
end
local eCD  = { st1,st2,st3	};
local eDis = { sk1,sk2,sk3	};
local eB   = { sb1,sb2,sb3  };
local ecd  = {cdd1,cdd2,cdd3};

local function startAnimateFinishCd(playerid,n)
    Customui:showElement(playerid,uiid,ecd[n]);
    --local code  = Customui:SmoothRotateBy(playerid, uiid, ecd[n], 1, 90);
end 
local function finishAnimateFinishCd(playerid,n)
    Customui:hideElement(playerid,uiid,ecd[n]);
    Player:playMusic(playerid,10952 , 10, 8.5, false)
end 


local function setDisplayCD(playerid,n,i,thk) 
	local text = i.."s";
	Customui:setText(playerid, uiid, eCD[n], text);
	Customui:setAlpha(playerid, uiid, eDis[n], 10);
	Customui:setColor(playerid, uiid, eB[n], "0x222222");
    if(thk<10)then startAnimateFinishCd(playerid,n) end 
end

local function unsetDisplayCD(playerid,n,ithk) 
	local text = " ";
	local r1 = Customui:setText(playerid, uiid, eCD[n], text);
	local r2 = Customui:setAlpha(playerid, uiid, eDis[n], 100);
	local r3 = Customui:setColor(playerid, uiid, eB[n], "0xFFFFFF");
    finishAnimateFinishCd(playerid,n);
end

-- local doSleep = function(n)
--     return threadpool:wait(n);
-- end

-- local countCD = function(buffid,n,playerid) 
--     if (n ~= 0) then
--         local sts, err = pcall(function()
--             local i = getSec(playerid, buffid); 

--             while (type(i)=="number") do
--                 setDisplayCD(playerid, n, i);
--                 print(i , "type = ",type(i));
--                 i =  getSec(playerid, buffid);
--                 if i == nil then
--                     print("Succesfully Break out of the loop");
--                     break
--                 end
--                 doSleep(0.5);
--             end
            
--             local r = unsetDisplayCD(playerid,tonumber(n));
--             if r then print( "Success reset Display CD ") else print("Unsuccessful unsetDisplayCd") end ;
--             return Position;
--         end)
        
--         if not sts then
--             print("Error: " , err)
--         end
--     end
-- end
local indicatorOnCD_mt = {
    _index = function(t,k)
        t[k] = {};
        return t[k]
    end
}
local indicatorOnCD = setmetatable({}, indicatorOnCD_mt)

local showOnCD = function(playerid,n,buffid)
    if indicatorOnCD[playerid]==nil then indicatorOnCD[playerid]={} end 
    indicatorOnCD[playerid][n]=buffid;
end

ScriptSupportEvent:registerEvent([[Player.AddBuff]], function(e)
    local buffid = e.buffid;
    local n = whatSkillCD(buffid);
    local playerid = e.eventobjid;
    showOnCD(playerid,n,buffid);
end)

ScriptSupportEvent:registerEvent([[Game.RunTime]],function(e)
    --print("From Skill UI : ",e);
    local result,num,array=World:getAllPlayers(-1)
    for i,a in ipairs(array)do 
        if indicatorOnCD[a] ~= nil then 
            for di,da in pairs(indicatorOnCD[a]) do 
                local s,thk = getSec(a,da);
                if type(s)~="number"then 
                    indicatorOnCD[a][di] = nil;
                    unsetDisplayCD(a,tonumber(di));
                else 
                    setDisplayCD(a,di,s,thk)
                end 
            end 
        end 
    end 
end)