local maks = {
    x1 = -45 ,x2 = 44 , 
    z1 = 18 , z2 = 86 , 
    y1 =  8 , y2 = 22 
}


local function isValidPlacement(x,y,z)
    -- check if x is between maks x1 and x2 
    if  x < maks.x1 or x > maks.x2 then return false end 
    -- check if z is between maks z1 and z2 
    if  z < maks.z1 or z > maks.z2 then return false end
    -- check if y is between maks y1 and y2 
    if  y < maks.y1 or y > maks.y2 then return false end

    return true;
end 


-- Handle Block Placement from any player 
ScriptSupportEvent:registerEvent([[Block.Add]],function(e)
    local blockid,x,y,z = e.blockid , e.x , e.y , e.z ;
    if not isValidPlacement(x,y,z) then 
        -- break the Block 
        local r = Block:destroyBlock(x, y, z, true)
    end 
end)

local BreakingBlock = {}

local function setBarBreaking(v1,playerid,blockid)
    local uiid = "7421357365692930290";
    Player:openUIView(playerid,uiid)
    local element = uiid.."_"..3;
    local text = uiid.."_"..5;
    local img = uiid.."_"..4;
    local w = v1/6*450;
    local percentage = math.floor(v1/6*100).."%";
    local h = 30 ;
    local color = 0xffffff;
    Customui:setSize(playerid,uiid,element,w,h)
    Customui:setText(playerid,uiid,text,percentage);
    Customui:setColor(playerid,uiid,img,color);
    local result,iconid = Customui:getBlockIcon(blockid);
    Customui:setTexture(playerid,uiid,img,iconid);
end 

local function startBreakingBlock(x,y,z,blockid,playerid)
    if BreakingBlock[playerid] == nil then 
        BreakingBlock[playerid] = 1 ;
    end 
    local mx = 6;
    BreakingBlock[playerid] = BreakingBlock[playerid] + 1;
    setBarBreaking(BreakingBlock[playerid],playerid,blockid);
    threadpool:wait(0.2);
    if BreakingBlock[playerid] >= mx-1 then 
        local r = Block:destroyBlock(x, y, z, true)
    end 
end

local function showInvalidBlock(playerid)
    local uiid = "7421357365692930290";
    Player:hideUIView(playerid,uiid)
end

-- Handle Block Breaking from player 
ScriptSupportEvent:registerEvent([[Block.Dig.Begin]],function(e)
    local blockid,x,y,z = e.blockid , e.x , e.y , e.z ;
    local playerid = e.eventobjid;
    if isValidPlacement(x,y,z) then 
        -- proceed to show proggress bar on breaking block 
        print("Player is Diggin")
        startBreakingBlock(x,y,z,blockid,playerid);
    else 
        -- show invalid block distruction 
        showInvalidBlock(playerid)
    end 
end)

ScriptSupportEvent:registerEvent([[Block.Dig.Cancel]],function(e)
    local playerid = e.eventobjid;
    BreakingBlock[playerid] = nil;
    showInvalidBlock(playerid);
end)