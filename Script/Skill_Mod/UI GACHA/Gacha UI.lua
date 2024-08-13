-- version: 2022-04-20
-- mini: 1029380338
local currencyNameStoredOnTrigger = "Currency";
local elements = {};
local uiid = "7382967083985475826" ;local function el(i) return uiid.."_"..i end;local function regELEMENT(name,i) elements[name] = el(i) end; 
local function ELEMENTS(name) return elements[name] end ; local imin,imax = 14,46 ; local playerStateUI = {};
for i=imin,imax do if i ~= 26 and i~=44 and i~=45 and i~=46 then regELEMENT("ITEM"..i,i) end end 

local function GetCurrency(p) local result,Currency = VarLib2:getPlayerVarByName(p,3,currencyNameStoredOnTrigger) ; return(Currency) end
local function setCurrency(p,Cur) VarLib2:setPlayerVarByName(p,3,currencyNameStoredOnTrigger,Cur) ; end
local CostToSpin = 5000;
local soundEffect = {
    spin = 10968, reward = 10957
};

local function isFreeSpin(playerid)
    local r,v = Valuegroup:getValueNoByName(18, "SkillSet", 1, playerid)
    if type(v) == "string" and string.find(v, "empty") then
        return true;
        else 
        return false;
    end 
end 

local function playSound(playerid,music,bool)
    Player:playMusic(playerid, music, 100,1,bool);
end 

regELEMENT("SpinButton",4);

function getIndexNum(array)
    local count = 0
    for _, value in ipairs(array) do
            count = count + 1
    end
    return count
end

function LoadGachaDisplay(playerid,extra)
    if isFreeSpin(playerid) then 
        Customui:setText(playerid,uiid,ELEMENTS("TextButton"),"Free Spin x1");        
    else 
        Customui:setText(playerid,uiid,ELEMENTS("TextButton"),"$"..CostToSpin);
    end 
    local count = 1 ;
    local res = 0;
    --print(GACHA);
    for i=imin,imax do 
        if i ~= 26 and i ~= 45 and i ~= 44 and i ~=46 then 
            local rindex = math.max(math.fmod(count+ extra,getIndexNum(GACHA))+1,1);
            if count == 3 then res = rindex ; end ;
            Customui:setTexture(playerid,uiid,ELEMENTS("ITEM"..i),GACHA.GETICON(rindex));
            count = count + 1 ;
        end 
    end  
    return res;
end 
    
math.randomseed(os.time());

local function spinAnimation(playerid,i)
    local itemHolder = "7382967083985475826_6";
    local initX,finishX = -3015,233;
    Customui:setPosition(playerid, uiid, itemHolder, initX, 0);
    local code  = Customui:SmoothMoveTo(playerid, uiid, itemHolder, i, finishX, 0);
    threadpool:wait(i);
    local code  = Customui:StopAnim(playerid, uiid, itemHolder);
end 

local function reqUpdateUI(playerid) 
    local data = {playerid=playerid}
    local ok, json = pcall(JSON.encode, JSON, data);
    print("Result JSONing : ",ok," json is : ",json);
    local r = Game:dispatchEvent("UPDATE_ACCROS_UI",{json,data=json});
    print("Result dispatchEvent",r)
end 

local function hideIndicator(playerid)    local Indicator = "7382967083985475826_10";Customui:hideElement(playerid, uiid, Indicator) end 
local function showIndicator(playerid)    local Indicator = "7382967083985475826_10";Customui:showElement(playerid, uiid, Indicator) end 
function doSpin(playerid)
    playSound(playerid,soundEffect.spin);
    local m = math.random(1,1000);
    local reward = LoadGachaDisplay(playerid,m);
    --print("reward : "..reward);
    hideIndicator(playerid);
    spinAnimation(playerid,5);
    GACHA.EXECUTE(reward,playerid);
    playSound(playerid,soundEffect.reward);
    reqUpdateUI(playerid);
    for i=1,10 do showIndicator(playerid); threadpool:wait(0.1); hideIndicator(playerid); threadpool:wait(0.1); showIndicator(playerid) end 
end 

regELEMENT("TextButton",5);

ScriptSupportEvent:registerEvent("UI.Show",function(e) 
    local playerid = e.eventobjid ; 
    LoadGachaDisplay(playerid,0);
end)

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e) 
    local playerid,ElementID = e.eventobjid,e.uielement;
    if ElementID == ELEMENTS("SpinButton") then 
        local isTrue = false; 
        if isFreeSpin(playerid) then
            isTrue = true 
            else 
                if(GetCurrency(playerid)>=CostToSpin)then 
                    setCurrency(playerid,GetCurrency(playerid)-CostToSpin);
                    isTrue = true;
                else 
                    isTrue = false;
                end 
        end 
        --Chat:sendSystemMsg("Lets Spin");
        if(isTrue)then 
            Customui:hideElement(playerid, uiid,ELEMENTS("SpinButton"));
            doSpin(playerid);
            Customui:showElement(playerid, uiid,ELEMENTS("SpinButton"));
                if isFreeSpin(playerid) then 
                    Customui:setText(playerid,uiid,ELEMENTS("TextButton"),"Free Spin x1");        
                else 
                    Customui:setText(playerid,uiid,ELEMENTS("TextButton"),"$"..CostToSpin);
                end 
        else 
            Player:notifyGameInfo2Self(playerid,"Need $"..CostToSpin.." to Spin x1 ");
        end 
    end 
end)