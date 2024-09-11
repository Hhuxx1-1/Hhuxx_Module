-- version: 2022-04-20
-- mini: 1029380338
-- uipacket: 7404398618605197554
--[[ REQUIRE MYTOOL FRAMEWORK --------------------------]]
local StatePlayer = {};--Store the player State here 

function setPlayerState(player,state,obj)
    StatePlayer[player] = {state = state, obj = obj};
end
function getPlayerState(player)
    return StatePlayer[player].state,StatePlayer[player].obj;
end
local function GetAllPlayer()
    -- Call API from Miniworld to get All Player 
    -- return array only 
    local result,num,array=World:getAllPlayers(-1)
    if(result==0)then 
        if num > 0 then 
            return array
        end 
    end
end

local function OPEN_UI(a)
    Player:openUIView(a,INTERACTIVE_UI.uiid)--Open the interface for the player
end
local function CLOSE_UI(a)
    Player:hideUIView(a,INTERACTIVE_UI.uiid)--Open the interface for the player
end

local function checkInteractivity(playerid)
    
    local x,y,z = FUNCX.GET_POS(playerid)
    if x~=nil and y~=nil and z~=nil then 
        local dx,dy,dz = FUNCX.GET_DIR(playerid);
        local d = 2;
        local obj = FUNCX.GET_OBJ_AREA(playerid,x+(dx*d),y+(dy),z+(dz*d),1,1,1);
        local pobj = FUNCX.NOT_OBJ(playerid,FUNCX.FILTER_OBJ("PLAYER",obj))
        local mobj = FUNCX.FILTER_OBJ("MOB",obj)

        if StatePlayer[playerid] == nil then 
            setPlayerState(playerid,"I");
        end 
        if #mobj>=1 then 
            local r2, creatureid =Creature:getActorID(mobj[1]);
            if(r2==0)then 
                --print("Get Info",r2,creatureid)
                --print("Try Fetch Data : ");
                --print(INTERACT_DATA[creatureid]);
                if(INTERACT_DATA[creatureid]~=nil)then 
                local r = type(INTERACT_DATA[creatureid].f);
                    if r == "function" then 
                        if(StatePlayer[playerid].state~="M")then  
                        setPlayerState(playerid,"M",mobj[1]);
                        OPEN_UI(playerid);
                        else 
                            --print("Already in M State");
                            -- Compare the Existing Object on state 
                            -- if not same then update it 
                                if(StatePlayer[playerid].obj~=mobj[1])then
                                    setPlayerState(playerid,"M",mobj[1]);
                                    OPEN_UI(playerid)
                                end 
                        end 
                    else 
                        if(StatePlayer[playerid].state~="T")then
                            setPlayerState(playerid,"T",mobj[1])
                            OPEN_UI(playerid);
                        else 
                            if(StatePlayer[playerid].obj~=mobj[1])then
                                setPlayerState(playerid,"T",mobj[1]);
                                OPEN_UI(playerid)
                            end 
                        end 
                    end 
                else 
                    if(StatePlayer[playerid].state~="N")then  
                        CLOSE_UI(playerid);
                        setPlayerState(playerid,"N",nil);
                    end 
                end 
            end 
        else 
            if #pobj >= 1 then
                if(StatePlayer[playerid].state~="P")then  
                OPEN_UI(playerid);
                setPlayerState(playerid,"P",pobj[1]);
                end 
            else
                if(StatePlayer[playerid].state~="N")then  
                CLOSE_UI(playerid);
                setPlayerState(playerid,"N",nil);
                end 
            end 
        end 
    end 
end

local function getObjDesc(objid)
    local r, creatureid =Creature:getActorID(objid)
    if r == 0 then 
        local r , name = Creature:GetMonsterDefName(creatureid)
        local r , desc = Creature:GetMonsterDefDesc(creatureid)
        return  creatureid , (name or "unknown").." : "..(desc or "unset description");
        else 
           --print("Failed to Obtain Creature ID")
    end 
end

local function unsetDisplay(level,data)
    local playerid = data.p;
    if level == 1 then
        Customui:setText(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI["desc"], "")
        Customui:setText(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI["btndes"], "")
    end 
    if level == 2 then 
        Customui:hideElement(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI.btn)
    end 
    if level == 3 then 
        Customui:showElement(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI.btn)
    end 
end 

local function getInteractivity(playerid)
    if(StatePlayer[playerid]~=nil)then 
    local stateInfo = StatePlayer[playerid];
    local status = stateInfo.state;
    local obj = stateInfo.obj;
    if status == "M" then
        -- load info of object mob 
        local OBc , stdesc = getObjDesc(obj);
        local nameInteract = INTERACT_DATA_NAME.GET(OBc);
        --print("Checking Name : ",nameInteract);
        if nameInteract ~= nil or nameInteract ~= "EMPTY" then 
            --print("Checking M data",INTERACT_DATA[OBc],type(INTERACT_DATA[OBc].f));
            if type(INTERACT_DATA[OBc].f) == "function" then 
            Customui:setText(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI["desc"], stdesc)
            Customui:setText(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI["btndes"], nameInteract)
            unsetDisplay(3,{p=playerid});
            else 
                unsetDisplay(2,{p=playerid});
                unsetDisplay(1,{p=playerid});
            end 
        else 
            unsetDisplay(1,{p=playerid});
        end 
    end 
    if status == "P" then 
        -- load info of player 
    end 
    if status == "N" then 
        unsetDisplay(1,{p=playerid});
    end 
    if status == "T" then 
        unsetDisplay(2,{p=playerid});
        local OBc , stdesc = getObjDesc(obj);
        Customui:setText(playerid, INTERACTIVE_UI.uiid, INTERACTIVE_UI["desc"], stdesc);
    end 
end
end

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    -- local second = e.second;
    local players = GetAllPlayer();
    for i,a in ipairs(players) do 
        local r,err = pcall(checkInteractivity,a);
        if not r  then 
            print("Error INTERACTIVE",err)
        end 
        local r1,err1 = pcall(getInteractivity,a);
        if not r1 then print("Error Interactiveity",err1) end 
    end 
end)