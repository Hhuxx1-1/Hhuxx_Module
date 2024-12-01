local markHit = {}

local function showMark(creatureid,n)
    local size = 0.3;
    local r, high = Creature:getAttr(creatureid,21);
    high = 60 + (tonumber(high)*200);
    Chat:sendSystemMsg("High : "..high);
    Graphics:removeGraphicsByObjID(creatureid, 1, 10)
    Graphics:removeGraphicsByObjID(creatureid, 2, 10)
    Graphics:removeGraphicsByObjID(creatureid, 3, 10)
    Graphics:removeGraphicsByObjID(creatureid, 4, 10)
    if n then 
        if n == 1 then 
            local graphid = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 1);
            Graphics:createGraphicsImageByActor(creatureid, graphid, {x=0,y=1,z=0}, high,0,40)
        end 
        if n == 2 then 
            local graphid1 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 1);
            local graphid2 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 2);
            Graphics:createGraphicsImageByActor(creatureid, graphid1, {x=0,y=1,z=0}, high,-50,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid2, {x=0,y=1,z=0}, high,50,40)
        end 
        if n == 3 then 
            local graphid1 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 1);
            local graphid2 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 2);
            local graphid3 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 3);
            Graphics:createGraphicsImageByActor(creatureid, graphid1, {x=0,y=1,z=0}, high,-75,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid2, {x=0,y=1,z=0}, high,0,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid3, {x=0,y=1,z=0}, high,75,40)
        end 
        if n == 4 then 
            local graphid1 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 1);
            local graphid2 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 2);
            local graphid3 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 3);
            local graphid4 = Graphics:makeGraphicsImage([[8_1029380338_1727255980]], size, 0xffffff, 4);
            Graphics:createGraphicsImageByActor(creatureid, graphid1, {x=0,y=1,z=0}, high,-150,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid2, {x=0,y=1,z=0}, high,-50,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid3, {x=0,y=1,z=0}, high,50,40)
            Graphics:createGraphicsImageByActor(creatureid, graphid4, {x=0,y=1,z=0}, high,150,40)
        end 
    end 
    
end

local function Attack_1(playerid)
    local x,y,z = MYTOOL.GET_POS(playerid);
    local OBJ = MYTOOL.getObj_Area(x,y,z,7,5,7)
    for i,creatureid in ipairs(MYTOOL.filterObj("Creature",OBJ)) do 
        if markHit[creatureid] == nil then
            markHit[creatureid] = 0;
        end 
            markHit[creatureid] = markHit[creatureid] + 1;
        if markHit[creatureid] > 4 then 
            MYTOOL.playSoundOnActor(creatureid,10078,300,1)
            RUNNER.NEW(function()
                Actor:addBuff(creatureid,1069,1,40)
                MYTOOL.playSoundOnActor(creatureid,10538,100,1)
                MYTOOL.ADD_EFFECT_TO_ACTOR(creatureid,1620,3)
            end,{},4)
            markHit[creatureid] = nil;
            showMark(creatureid,0)
        else 
            showMark(creatureid,markHit[creatureid])
        end 
    end 
end 

WEAPON_PASSIVE:ADD_ATTACK(4196,function(playerid)
    local x,y,z = MYTOOL.GET_DIR_ACTOR(playerid)
    MYTOOL.dash(playerid,x,y,z);

    Attack_1(playerid)
end)
