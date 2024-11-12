local Car_Mounted, Car_Rided, isReversing, Accel, currentCar_State , isBoosting = {}, {}, {}, {}, {}, {}
local maxAccel, sens,tolerate, airBoost = 12, 30, 5 ,0.0083

-- Register Car Mount
ScriptSupportEvent:registerEvent("Player.ClickActor", function(e)
    local playerid, objid, actorid = e.eventobjid, e.toobjid, e.targetactorid
    local r, name = Creature:GetMonsterDefName(actorid)
    if r == 0 and string.find(name, "Car") and not Car_Rided[objid] then
        Player:mountActor(playerid, objid, 1, true)
        Car_Mounted[playerid], Car_Rided[objid] = {playerid = playerid, obj = objid, actor = actorid}, {playerid = playerid}
    end
end)

-- Get Player Direction and Car Direction Difference
local function getDirectionAndAngleDiff(playerid, car)
    local _,px, py, pz = Actor:getPosition(playerid) 
    local _,dx, dy, dz = Player:getAimPos(playerid)
    local dirX, dirZ = (dx - px)*10, (dz - pz)*10;
    -- print("Playerid : ",playerid," Dir x :"..dirX," Dir z :"..dirZ);
    -- after some debuging i found out there is difference between mobile player and pc player 
    -- ON PC get Aim pos can give very far depending on render distancce 
    -- while on mobile it is less than a 10 block 
    -- do you have any idea to fix this ? 
    local mag = math.sqrt(dirX^2 + dirZ^2)
    dirX, dirZ = dirX / mag, dirZ / mag -- this is the player facing direction 
    -- Chat:sendSystemMsg("Dir X :"..dirX);
    -- Chat:sendSystemMsg("Dir Z :"..dirZ);
    Actor:setFacePitch(car, 0)--[[ Keep the Car unaffected by player camera angel]]
    local _, carX, _, carZ = Actor:getFaceDirection(car) --this is where the car facing direction 
    local dot, det = carX * dirX + carZ * dirZ, carX * dirZ - carZ * dirX
    -- Chat:sendSystemMsg("Car X :"..carX);
    -- Chat:sendSystemMsg("Car Z :"..carZ);
    return dirX, dirZ, math.atan2(det, dot) * (180 / math.pi), carX, carZ

    -- you know that you should compare car facing direction and player facing direction 
end

-- Apply Acceleration and Adjust Yaw
local nowSpeed = {};

local function applyAccelerationAndYaw(car, playerid, dirX, dirZ, angleDiff , carX, carZ ,IgnoreIncrement)
    local _,maxspeed = Creature:getAttr(car, 17)

    if not IgnoreIncrement then 
        if nowSpeed[car] == nil then nowSpeed[car] = 1 end 
        if nowSpeed[car] <= maxspeed then nowSpeed[car] = math.min(nowSpeed[car] + 2,maxspeed); end 
    end 

    local speed = nowSpeed[car];
    if not speed then return end

    -- local acel = Accel[car] or 2
    local accelSpeed = speed 
    if isBoosting[playerid]  then
        accelSpeed  = accelSpeed + isBoosting[playerid];
    end 
    -- print("X Speed : ", carX * accelSpeed * airBoost , " Z Speed : ",  carZ * accelSpeed * airBoost)
    local r , err = pcall(function()
        Customui:setText(playerid,"7430301033791428850","7430301033791428850_2",math.floor(accelSpeed/1.5).."mps")
    end);
    Actor:appendSpeed(car, carX * accelSpeed * airBoost, 0, carZ * accelSpeed * airBoost)
    
    -- if acel < maxAccel - 1 then Accel[car] = acel + 2 else Accel[car] = maxAccel end

    -- Adjust yaw if angle difference exceeds sensitivity
    if math.abs(angleDiff) > tolerate then
        local yawAdjustment = angleDiff / (360 / sens)
        if math.abs(angleDiff) < 120 then
            Actor:turnFaceYaw(car, -yawAdjustment)
        else 
            --don't Turn if too much 
        end
    end
end

-- Visual and Sound Effects
local function playEffects(ax, ay, az)
    World:playParticalEffect(ax, ay - 0.5, az, 1226, 0.5)
    local soundID = 10810;
    local volume = 200;
    World:playSoundEffectOnPos({x = ax, y = ay, z = az}, soundID, volume, 1, false)
end

-- Key Actions for Car Control
local kvey = {
    ["W"] = function(playerid)
        local car = Car_Mounted[playerid].obj
        if not car then return end
        isReversing[playerid] = 1

        local dirX, dirZ, angleDiff , carX, carZ = getDirectionAndAngleDiff(playerid, car)
        local r , err = pcall(function() 
            return applyAccelerationAndYaw(car, playerid, dirX, dirZ, angleDiff , carX, carZ , false)
        end)
        if r then 
            -- Effects and Elevation Adjustment
            local _, ax, ay, az = Actor:getPosition(car)
            playEffects(ax, ay, az);
            if Block:isAirBlock(ax + dirX * 2, ay, az + dirZ * 2) ~= 0 and Block:isAirBlock(ax + dirX * 2, ay + 1, az + dirZ * 2) == 0 then
                Actor:setPosition(car, ax, ay + 1, az);
            end
        end 
    end,
    ["S"] = function(playerid)
        local car = Car_Mounted[playerid].obj
        if not car then return end
        isReversing[playerid] = -1

        local _,speed = Creature:getAttr(car, 17)
        if not speed then return end
        local _,dirX, _, dirZ = Actor:getFaceDirection(car)
        -- local acel = Accel[car] or 2
        local accelSpeed = speed 

        Actor:appendSpeed(car, -dirX * accelSpeed * 0.004, 0.00001, -dirZ * accelSpeed * 0.004)
        -- if acel < maxAccel - 1 then Accel[car] = acel + 1 end

        -- Adjust Yaw
        local playerDirX, playerDirZ, angleDiff = getDirectionAndAngleDiff(playerid, car)
        if math.abs(angleDiff) > 15 then
            Actor:turnFaceYaw(car, angleDiff / (360 / sens))
        end
    end
}

-- Key Event Handlers
ScriptSupportEvent:registerEvent("Player.InputKeyDown", function(e)
    if Car_Mounted[e.eventobjid] and kvey[e.vkey] then
        if currentCar_State[e.eventobjid] == nil then 
            currentCar_State[e.eventobjid] = kvey[e.vkey]
            -- print(e.eventobjid, " Key Down " , e.vkey);
        end 
    end
    -- if e.vkey then 
    --     Chat:sendSystemMsg("Key Pressed : "..e.vkey );
    -- end 
end)

ScriptSupportEvent:registerEvent("Player.InputKeyUp", function(e)
    if Car_Mounted[e.eventobjid] and kvey[e.vkey] and currentCar_State[e.eventobjid] == kvey[e.vkey] then
        currentCar_State[e.eventobjid] = nil;
        -- print(e.eventobjid, " Key Up " , e.vkey);
    end
    if e.vkey == "SPACE" then 
        isBoosting[e.eventobjid] = 0
    end 
end)

ScriptSupportEvent:registerEvent("Player.InputKeyOnPress", function(e)
    if Car_Mounted[e.eventobjid] then
        if e.vkey == "SPACE" then 
            if isBoosting[e.eventobjid] == nil then isBoosting[e.eventobjid] = 0 end 
            local _,speed = Creature:getAttr(Car_Mounted[e.eventobjid].obj , 17)
            if isBoosting[e.eventobjid] < speed then 
                isBoosting[e.eventobjid] = isBoosting[e.eventobjid] + speed/20;
            end 
        end 
    end 
end)

ScriptSupportEvent:registerEvent("Player.DismountActor", function(e)
    local playerid = e.eventobjid
    Car_Rided[Car_Mounted[playerid].obj],nowSpeed[Car_Mounted[playerid].obj], Car_Mounted[playerid], currentCar_State[playerid] = nil,nil, nil, nil;
end)

-- Main Runtime Loop
ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    for _, carData in pairs(Car_Mounted) do
        local playerid = carData.playerid
        if currentCar_State[playerid] then
            local success, error = pcall(currentCar_State[playerid], playerid)
            if not success then print("Error [Car]: #R" .. error) end
        else 
            -- gradually decrease now carspeed 
            if nowSpeed[carData.obj] then
                if nowSpeed[carData.obj] > 1 then 
                    nowSpeed[carData.obj] = math.max(nowSpeed[carData.obj] - 2,0);
                    
                    local dirX, dirZ, angleDiff , carX, carZ = getDirectionAndAngleDiff(playerid, carData.obj)
                    local IgnoreIncrement = true;
                    local r , err = pcall(function() 
                        return applyAccelerationAndYaw(carData.obj, playerid, dirX, dirZ, angleDiff , carX, carZ , IgnoreIncrement)
                    end)
                end 
                local r , err = pcall(function()
                    Customui:setText(playerid,"7430301033791428850","7430301033791428850_2",math.floor(nowSpeed[carData.obj]/1.5).."mps")
                end);
            end 
        end
    end
end)
