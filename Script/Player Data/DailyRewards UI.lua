local UIElement = {};
UIElement.uiid = "7393695998190229746"; 
local UIElement_mt = {__index = function(self,key)
    return self.uiid .."_"..key
end};
local UIElement = setmetatable(UIElement,UIElement_mt);
-- Init Rewards Login 
local RewardsLogin = {
    200,400,600,800,1000
}
local TemporaryPlayerReward = {};
local DoubleUp = 4103;
local StorageName = "LoginStreak";

local CalculateStreak = function(t)
    local streak = 1;
    for i=1,4 do 
        local c = t[i] - t[i+1];
        if c == 1 then streak = streak + 1 else return streak end
    end 
    return streak;
end
local function GetTodayValue()
    local now = os.date("%y%m%d")
    return tonumber(now);
end

local function GetLastLogin(playerid)
    local t = {}
    for i = 1 , 5 do 
       local r,v = Valuegroup:getValueNoByName(17, StorageName, i, playerid)
       if r == 0 then t[i] = v; end 
    end 
    return t;
end

local function checkIsAlreadyLoginToday(playerid)
    local today = GetTodayValue();
    local LastestLogin =  GetLastLogin(playerid)[1];
    --print("Today is ",today , " Last Login is ", LastestLogin);
    if today == LastestLogin then 
        -- Player already login Today 
        return true;
    else 
        return false;
    end 
end


local initUI = function(playerid,s)
    local ement = {UIElement[6],UIElement[11],UIElement[16],UIElement[21],UIElement[26]}
    local iment = {
        {base = UIElement[4],pic= UIElement[5],sd=UIElement[8]},
        {base = UIElement[9],pic= UIElement[10],sd=UIElement[12]},
        {base = UIElement[14],pic= UIElement[15],sd=UIElement[17]},
        {base = UIElement[19],pic= UIElement[20],sd=UIElement[22]},
        {base = UIElement[24],pic= UIElement[25],sd=UIElement[27]},
    }
    for i,a in ipairs(ement) do 
        Customui:setText(playerid,UIElement.uiid,a,"$"..RewardsLogin[i])
    end 
    local C = {on = "0xffffff",off="0x8f9190",specoff="0xfff319",specon="0xffee00"} 
    if(s == nil) then 
        s = CalculateStreak(GetLastLogin(playerid));
    elseif(s<0)then 
        s = math.abs(s);
        local ss = s-1;
    end 
    for i = 1 , 5 do 
        if i ~= s then 
            if i == 5 then 
                Customui:setColor(playerid,UIElement.uiid,iment[i].base,C.specoff)
                else
                Customui:setColor(playerid,UIElement.uiid,iment[i].base,C.off)
            end
            Customui:setColor(playerid,UIElement.uiid,iment[i].pic,C.off)
            Customui:setColor(playerid,UIElement.uiid,iment[i].sd,C.off)
        else 
            if i == 5 then 
                Customui:setColor(playerid,UIElement.uiid,iment[i].base,C.specon)
                Customui:setColor(playerid,UIElement.uiid,iment[i].sd,C.specon)
                else
                Customui:setColor(playerid,UIElement.uiid,iment[i].base,C.on)
                Customui:setColor(playerid,UIElement.uiid,iment[i].sd,C.on)
            end
            Customui:setColor(playerid,UIElement.uiid,iment[i].pic,C.on)
 
        end 
        if i < s then --Install Checkmark On Streak Before 
            Customui:showElement(playerid,UIElement.uiid,UIElement[40+i])
        else 
            Customui:hideElement(playerid,UIElement.uiid,UIElement[40+i])
        end 
        if checkIsAlreadyLoginToday(playerid) then 
            -- Already Login Today 
            Customui:showElement(playerid,UIElement.uiid,UIElement[40+s])
            Customui:setColor(playerid,UIElement.uiid,UIElement[1],"0x8f9190")
            -- Show UI ELEMENT CLAIMED
        else 
            Customui:setColor(playerid,UIElement.uiid,UIElement[1],"0xffffff")
        end 
    end 
    -- Hide Overlay by Default
    Customui:hideElement(playerid,UIElement.uiid,UIElement[30])
end
-- Check for Player Condition after opening the UI 


local function SetLastLogin(playerid,t)
    local rs = {}
    for i = 1 , 5 do 
        local r = Valuegroup:setValueNoByName(17, StorageName, i, t[i],playerid)
        rs[i]=r;
    end 
    return rs;
end

local function setTodayLogin(playerid)
    local now = GetTodayValue();
    local playerDailyLoginData = GetLastLogin(playerid)
    local rs = {};
    rs[1]=now; for i=2,5 do
        rs[i]=playerDailyLoginData[i-1];
    end 
    SetLastLogin(playerid,rs)
end  


ScriptSupportEvent:registerEvent("UI.Show",function(e)
    local playerid = e.eventobjid;
    local uiid = e.CustomUI;
    if(uiid == UIElement.uiid)then 
    initUI(playerid);
    end 
end)

local AddCurrencyToPlayer = function(playerid,vv)
        local r , v = VarLib2:getPlayerVarByName(playerid, 3,"Currency");
        if ( r == 0 ) then 
            local val = v + vv;
            VarLib2:setPlayerVarByName(playerid, 3, "Currency", tonumber(val))
            Player:notifyGameInfo2Self(playerid,"#G + $"..vv.." ")
            return true;
        end 
        return false;
end

local function ClaimLogin(playerid)
    if checkIsAlreadyLoginToday(playerid)~=true then 
        local now = GetTodayValue();
        local playerDailyLoginData = GetLastLogin(playerid)
        local whichRewards = CalculateStreak(playerDailyLoginData);
        if (AddCurrencyToPlayer(playerid,RewardsLogin[whichRewards]))then 
            -- save to last Login Player Data;
            setTodayLogin(playerid)
        end 
        return true,RewardsLogin[whichRewards];
    else 
        Player:notifyGameInfo2Self(playerid,"You Already Claim, Come Back Tomorrow");
        return false;
    end 
end

local function ShowOverLay(playerid,reward)
    Customui:showElement(playerid,UIElement.uiid,UIElement[30])
    Customui:setText(playerid,UIElement.uiid,UIElement[35],"$"..reward);
    TemporaryPlayerReward[playerid]=reward;
end

ScriptSupportEvent:registerEvent("Player.AddItem",function(e)
    local itemid = e.itemid;
    local playerid = e.eventobjid;
    if(itemid == DoubleUp)then 
        if(TemporaryPlayerReward[playerid]~=nil)then 
        AddCurrencyToPlayer(playerid,TemporaryPlayerReward[playerid]);
        else 
        Player:notifyGameInfo2Self(playerid,"Something is Not Right :(");
        AddCurrencyToPlayer(playerid,100);
        end 
    end 
    Player:hideUIView(playerid,UIElement.uiid);
end)

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)

    local playerid = e.eventobjid;
    local uiid = e.CustomUI;
    local btnid = e.uielement;
    if(uiid == UIElement.uiid)then 
        if btnid == UIElement[1] then 
           -- Claim Button 
           local r,rrw = ClaimLogin(playerid);initUI(playerid);
           if(r)then
            ShowOverLay(playerid,rrw);
           end 
           
        end 

        if btnid == UIElement[36] then 
            local r = Player:openDevGoodsBuyDialog(playerid,4103,"Recieve 2x Daily Rewards")
        end 
    end 
    
end)