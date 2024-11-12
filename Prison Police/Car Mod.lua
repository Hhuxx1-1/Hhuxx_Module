local Car_Mounted = {};
local Car_Rided = {};
ScriptSupportEvent:registerEvent([[Player.ClickActor]],function(e)
    -- print(e);
    local playerid  = e.eventobjid; 
    local objid = e.toobjid;
    local actorid = e.targetactorid;
    -- obtain the name 
    local r , name = Creature:GetMonsterDefName(actorid);
    if r ~= 0 then print("Error Failed to get Name from Actorid") end
    -- check if name contain word "Car"
    if string.find(name,"Car") then
        -- it is a car 
        if Car_Rided[objid] == nil then 
            Player:mountActor(playerid,objid,1,true);
            Car_Mounted[playerid] = {playerid=playerid,obj=objid,actor=actorid};
            Car_Rided[objid] = {playerid=playerid};
        end 
    end 
end)

local getAim = function(obj)
    local r, x, y, z = Player:getAimPos(obj)
    if r==0 then return x, y, z end
end

local getPos = function(actorid)
    local r, x, y, z = Actor:getPosition(actorid)
    if r then return x, y, z end
end

local getDirP = function(playerid)
    local pX, pY, pZ = getPos(playerid);
    local dX, dY, dZ = getAim(playerid);
    local dirX, dirY, dirZ = dX - pX, dY - pY, dZ - pZ
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
    return dirX / magnitude, dirY / magnitude, dirZ / magnitude
end

local getSpeed = function(objid)
    local r , atr = Creature:getAttr(objid,17)
    if r == 0 then return atr end 
end

local getDir = function(obj)
    local r,x,y,z = Actor:getFaceDirection(obj)
    if r == 0 then return x,y,z end
end

local function getAngleDiff(car, playerid)
    local carX, _, carZ = getDir(car)
    local playerX, _, playerZ = getDirP(playerid)
    local dot = carX * playerX + carZ * playerZ
    local det = carX * playerZ - carZ * playerX
    return math.atan2(det, dot) * (180 / math.pi)  -- Angle difference in degrees
end

local isReversing = {};

local Accel = {};

local SFX =  function(x, y, z, whatsound, volume, pitch)
    if not pitch then pitch = 1 end
    World:playSoundEffectOnPos({x=x, y=y, z=z}, whatsound, volume, pitch, false)
end

local kvey = {
    ["W"] = function(playerid)
        local car = Car_Mounted[playerid].obj;
        isReversing[playerid] = 1;
        if car then 
            local speed = getSpeed(car);
            -- Chat:sendSystemMsg("Speed : "..speed)
            if speed == nil then 
                Car_Mounted[playerid] = nil; 
                return;
            end 
            local x,y,z = getDir(car);
            local acel = Accel[car] or 2;
            if acel < 2 then acel = 2 end 
            local maxacel = 12;
            for i=1,acel do 
                -- check is it on air 
                RUNNER.NEW(function()
                    local onAir = Actor:isInAir(car) 
                    if onAir == 0 then 
                        
                    else 
                        if acel < maxacel - 1 then 
                            Accel[car]  = acel + 1;
                        end 
                        -- Chat:sendSystemMsg("Accel : "..acel);
                        Actor:appendSpeed(car,x*((speed/(maxacel-acel))/120),0,z*((speed/(maxacel-acel))/120))
                        -- check for movement camera 
                        local faceA = getAngleDiff(car,playerid);
                        -- Chat:sendSystemMsg("Xr = "..(x-px).." Zr = "..(z-pz));                    
                        -- Chat:sendSystemMsg(" Angle : "..faceA);
                        local sens = 6;
                        local R = faceA/(360/sens);

                        if faceA > sens then 
                            Actor:turnFaceYaw(car, -R);
                            if faceA > 60 then 
                                if Accel[car] > sens then 
                                    Accel[car] = - 1;
                                end 
                            end 
                        elseif faceA < -sens then 
                            Actor:turnFaceYaw(car, -R);
                            if faceA < -60 then 
                                if Accel[car] > sens then 
                                    Accel[car] = - 1;
                                end 
                            end 
                        end 
                        local ax,ay,az = getPos(car);

                        RUNNER.NEW(function()
                            World:playParticalEffect(ax, ay-0.5, az, 1226, 0.5);  
                            RUNNER.NEW(function()
                                World:stopEffectOnPosition(ax, ay-0.5, az, 1226);
                            end,{},15)
                        end,{},3)

                        local tx,ty,tz = ax+(x*2),ay,az+(z*2);
                        if acel <  maxacel - 5 then 
                            SFX(tx,ay,tz,10809,100,1);
                        else 
                            SFX(tx,ay,tz,10810,300/(maxacel - acel),1);
                        end 
                        local r = Block:isAirBlock(tx,ty,tz);
                        local r1 = Block:isAirBlock(tx,ty+1,tz);
                        if r ~= 0 and r1 == 0 then 
                            local r,x,y,z = Actor:getPosition(car)
                            local r = Actor:setPosition(car,x,y+1,z);
                        end 
                    end 
                end,{},i*2)
            end 
        end 
    end,
    ["S"] = function(playerid)
        local car = Car_Mounted[playerid].obj;
        isReversing[playerid] = -1;
        if car then 
            local speed = getSpeed(car);
            if speed == nil then 
                Car_Mounted[playerid] = nil; 
                return;
            end 
            -- Chat:sendSystemMsg("Speed : "..speed)
            local x,y,z = getDir(car);
            local acel = Accel[car] or 2;
            local maxacel = 12;
            for i=1,acel do 
                RUNNER.NEW(function()
                    if acel < maxacel-1 then 
                        Accel[car]  = acel + 1;
                    end 
                    -- Chat:sendSystemMsg("Accel : "..acel);
                    Actor:appendSpeed(car,-x*((speed/(maxacel-acel))/250),0,-z*((speed/(maxacel-acel))/250))

                    local faceA = getAngleDiff(car,playerid);
                    -- Chat:sendSystemMsg("Xr = "..(x-px).." Zr = "..(z-pz));                    
                    local R = math.min(math.ceil(faceA/35),5);
                    if faceA > 15 then 
                        Actor:turnFaceYaw(car, R);
                    elseif faceA < -15 then 
                        Actor:turnFaceYaw(car, R);
                    end 
                end,{},i*3)
            end 
        end 
    end
}

local currentCar_State = {};

ScriptSupportEvent:registerEvent("Player.InputKeyDown",function(e)
    local playerid = e.eventobjid;
    if Car_Mounted[playerid] then 
        local keyp = e.vkey;
        if kvey[keyp]  then 
            currentCar_State[playerid] = kvey[keyp];
        end 
    end 
end)

ScriptSupportEvent:registerEvent("Player.InputKeyUp",function(e)
    local playerid = e.eventobjid;
    if Car_Mounted[playerid] then 
        local keyp = e.vkey;
        if kvey[keyp]  then 
            currentCar_State[playerid] = nil;
        end 
    end 
end)

ScriptSupportEvent:registerEvent("Player.DismountActor",function(e)
    local playerid = e.eventobjid;
    Car_Rided[Car_Mounted[playerid].obj] = nil
    Car_Mounted[playerid] = nil;
    currentCar_State[playerid] = nil;
end)


ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    for i,v in pairs(Car_Mounted) do 
        local playerid = v.playerid;
        if currentCar_State[playerid]~= nil then 
            local ret,error = pcall(currentCar_State[playerid],playerid);
            if not ret then 
                print("Error [Car] : #R"..error);
            end 
        else 
            if e.second then 
                if Accel[v.obj] then 
                    if Accel[v.obj] > 3 then 
                        Accel[v.obj]  = Accel[v.obj]  - 1;
                    end 
                end 
            end 
        end 
    end 
end)