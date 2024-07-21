-- version: 2022-04-20
-- mini: 1029380338
-- version: 2022-04-20
-- mini: 1029380338
local center = {x=0,y=5,z=0}
local dimension = {x=32,y=10,z=32}
local _,main_area = Area:createAreaRect(center, dimension);

local function spawnEffect(objid)
    --disabled reduced lag 
end 
local setting = {
DEBUG_MODE = false    
}


function sysay(text)
    if(setting.DEBUG_MODE)then 
    print("System : "..text);
    -- Chat:sendSystemMsg("System : #W "..text);
    end 
end 

LEVEL ={};

function GIC(Cost,try) --This function do Recursion to Get Available Monsters randomly 
    local i = math.random(1,#M);
    if(M[i].Cost<=Cost)then 
        return  M[i].ID,M[i].Cost,M[i].n;
    else 
        try = try + 1 ;
        if(try<20)then 
            return GIC(Cost,try);
            else 
            return  M[i].ID,M[i].Cost,M[i].n;        
        end 
    end 
end 

local lastCost = 0;

function setBoss()
    local i = math.random(1,#Boss);
    return {Boss[i].ID};
end 

function setLevel(im,ix)
    for i=im,ix do 
        sysay(" Initiating Level "..i);
        if math.fmod(i,10) == 0 then 
            LEVEL[i]=setBoss();
            sysay(" Bos Level Set");
        else 
        local capacity = 2 + math.ceil(i/7);
        if capacity > 10 then capacity = 10 end 
        local Cost = lastCost + (i*50); --Capability of Monsters to Spawned Adjusting Level Difficulty
        sysay("Starting Cost is "..Cost.." max capacity : "..capacity);
        -- Chat:sendSystemMsg("Set New Cost to "..Cost);
        local lm = {}
        for n=1,capacity do 
            local ID,C,N = GIC(Cost,0);
            if Cost > C then 
                Cost = Cost-C;
                table.insert(lm,ID);
                sysay(" added "..N.." with cost : "..C.." Current Cost is : "..Cost);
            else 
                sysay(" Cost : "..Cost.." - "..C.." huff");
                break;
            end 
        end 
        LEVEL[i]=lm;
        sysay("Level "..i.." is Done set ");
        lastCost = Cost;
        sysay(" Last Cost is "..Cost);
        end 
    end 
end 

function isRemaining (array)
    local c = 0;
    for i,a in pairs(array) do
        c=c+1;
    end 
    return c; 
end 

local function echo (msg)
    Chat:sendSystemMsg(msg)
end 

function updateDisplay(level)
    local current = isRemaining(oncur);
    local waves="Wave "..level;
    local wave_holder = "7378436039517083890_3";
    local remaining = "7378436039517083890_4";
    local r,n,players = World:getAllPlayers(1);
    local uiid = "7378436039517083890";
    if n>0 then 
    for i,a in ipairs(players) do 
        Customui:setText(a, uiid, wave_holder, waves);
        Customui:setText(a, uiid, remaining, T_Text(a,"Monsters Remaining : ")..current);
    end 
    end 
end 

function setDisplayWaiting(Counter)
    local remaining = "7378436039517083890_4";
    local r,n,players = World:getAllPlayers(1);
    local uiid = "7378436039517083890";
    if n>0 then 
    for i,a in ipairs(players) do 
        Customui:setText(a, uiid, remaining, T_Text(a,"Next Wave in ")..Counter);
        Player:openUIView(a,uiid)
    end 
    end 
end 
function setDisplayWaitingforPlayer()
    local remaining = "7378436039517083890_4";
    local r,n,players = World:getAllPlayers(1);
    local uiid = "7378436039517083890";
    if n>0 then 
    for i,a in ipairs(players) do 
        Customui:setText(a, uiid, remaining, T_Text(a,"Waiting For Players Join Arena"));
        Player:openUIView(a,uiid)
    end 
    end 
end 

local Counter = 0;

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    local second = e.second;
    if second ~= nil then 
    local r,playerlist = Area:getAreaPlayers(main_area);

    if(r==0 and #playerlist >0 )then 
        if(isRemaining(oncur)==0)then 
                -- do Next Level
                if(Counter <= 0)then 
                    NextLevel();
                    Counter = 20; 
                else
                    setDisplayWaiting(Counter);
                    Counter = Counter - 1 ;
                end 
            else
                -- Update Enemies Remaining On UI             
                CheckOnLevel();
            updateDisplay(Level);
        end 
        else 
        setDisplayWaitingforPlayer()
    end 
    end 
end)