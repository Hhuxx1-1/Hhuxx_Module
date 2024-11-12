local leaderboard = {};leaderboard.data = {};
leaderboard.name = "ranking_9103A10363_k";

leaderboard.insert = function(i,v)
    leaderboard.data[i] = v ; 
end
leaderboard.resetRank = function()
    CloudSever:ClearOrderData(leaderboard.name);
end

local UI_ID = "7420438251353696718";
local Slot = {
    [1] = {
        name ="11" , score = "87"
    },
    [2] = {
        name ="84" , score = "88"
    },
    [3] = {
        name ="85" , score = "89"
    },
    [4] = {
        name ="86" , score = "90"
    }
}

local reqtime = 15;
local function Failure(msg)
    for i,a in ipairs(graph) do 
        -- Graphics:updateGraphicsTextById(a, "#R"..msg, 15, 76);
    end 
end 

leaderboard.loadServerData = function()
    local callback = function (ret,value)
        --print("Callback : ",ret,value) --ret in here is returning boolean 
        if ret and value then
            for ix,  v in pairs(value) do
                leaderboard.insert(ix,v);
            end
        end
    end
    -- Get Top 70 Descending Value order 
    local ret = CloudSever:getOrderDataIndexArea(leaderboard.name,-4,callback);
    --print(ret);
    if ret == ErrorCode.OK then
        --print('Leaderboard data request successful')
    else
        --Failure("[2] Retrying in ")
        --print(ret,"Leaderboard data request failed")
        reqtime = 1200;
    end
end

leaderboard.display = function()
    local ret = 0;
    --print(leaderboard.data);
    for i,a in ipairs(leaderboard.data) do 
        ret=i;
        local playerName,uiid = a.nick,a.k;
        if(playerName==nil)then playerName = "Unknown Player" 
        print(a);
        end;
        local st="#Y[#R"..i.."#Y] #W"..playerName.." : #G"..a.v.." Kills "..[[         
        ]];
        -- Graphics:updateGraphicsTextById(graph[i], st, 15, 76);
        --Chat:sendSystemMsg(st,1029380338);
    end 
    -- Graphics:snycGraphicsInfo2Client();
    return ret;
end

local isGame = true ;

local function  doSleep()
    return threadpool:wait(reqtime);
end

ScriptSupportEvent:registerEvent([=[Game.Start]=]
    ,function(e)

        while isGame do
            doSleep(); 
            -- Safely load server data
        local success, err = pcall(function()
            leaderboard.loadServerData()
        end)
        if not success then
            Failure("[1] Error in loadServerData: " .. err)
            --print(err);
        end

        -- Safely display leaderboard
        local r
        success, err = pcall(function()
            r = leaderboard.display()
        end)
        if not success then
            Failure("[3] Error in display: " .. err)
            --print(err);
        end

        -- Check display result
        if r < 1 then
            --print(r);
            local buffing = "";
            for i=0,math.random(1,4) do buffing= buffing..".";end 
            Failure("#W[4] Loading"..buffing..[[

            ]]);
        end

    end 
end) 

ScriptSupportEvent:registerEvent([=[Game.End]=], function()
    isGame = false;
end)

ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=],function(e)
    local playerid = e.eventobjid;
    local Admin = 1029380338;
    local content = e.content;
    if(playerid==Admin)then 
        if(content=="CODE:RESET_RANK")then 
            leaderboard.resetRank()
        end 
    end 
end)