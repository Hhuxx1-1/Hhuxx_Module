MYTOOL = {}

MYTOOL.GET_POS = function(actorid)
    local r, x, y, z = Actor:getPosition(actorid)
    if r then return x, y, z end
end

MYTOOL.getAimPos = function(obj)
    local r, x, y, z = Player:getAimPos(obj)
    if r then return x, y, z end
end

MYTOOL.addEffect = function(x, y, z, effectid, scale)
    World:playParticalEffect(x, y, z, effectid, scale)
end

MYTOOL.cancelEffect = function(x, y, z, effectid, scale)
    World:stopEffectOnPosition(x, y, z, effectid, scale)
end

MYTOOL.dealsDamageButNotHost = function(playerid, x, y, z, dx, dy, dz, amount, dtype)
    local r, areaid = Area:createAreaRect({x=x, y=y, z=z}, {x=dx, y=dy, z=dz})
    local r1, p = Area:getAreaPlayers(areaid)
    local r2, c = Area:getAreaCreatures(areaid)
    for i, a in ipairs(p) do
        if a ~= playerid then
            Actor:playerHurt(playerid, a, amount, dtype)
        end
    end
    for i, a in ipairs(c) do
        Actor:playerHurt(playerid, a, amount, dtype)
    end
    Area:destroyArea(areaid)
end

MYTOOL.dealsDamageWithBuff = function(playerid, x, y, z, dx, dy, dz, amount, dtype, buffid, bufflv, customticks)
    MYTOOL.dealsDamageButNotHost(playerid, x, y, z, dx, dy, dz, amount, dtype)
    local r, areaid = Area:createAreaRect({x=x, y=y, z=z}, {x=dx, y=dy, z=dz})
    local r1, p = Area:getAreaPlayers(areaid)
    local r2, c = Area:getAreaCreatures(areaid)
    for i, a in ipairs(p) do
        if a ~= playerid then
            Actor:addBuff(a, buffid, bufflv, customticks)
        end
    end
    for i, a in ipairs(c) do
        Actor:addBuff(a, buffid, bufflv, customticks)
    end
    Area:destroyArea(areaid)
end

MYTOOL.dash = function(playerid, x, y, z)
    Actor:appendSpeed(playerid, x, y, z)
end

MYTOOL.checkBlockisSolid = function(x, y, z)
    local r, b = Block:isSolidBlock(x, y, z)
    return b
end

MYTOOL.addBlock = function(blockid, x, y, z)
    if not MYTOOL.checkBlockisSolid(x, y, z) then
        Block:placeBlock(blockid, x, y, z)
    end
end

MYTOOL.healsDamage = function(playerid, dmg)
    local r, HP = Player:getAttr(playerid, 2)
    Player:setAttr(playerid, 2, HP + dmg)
end

MYTOOL.getDir = function(playerid)
    local pX, pY, pZ = MYTOOL.GET_POS(playerid)
    local dX, dY, dZ = MYTOOL.getAimPos(playerid)
    local dirX, dirY, dirZ = dX - pX, dY - pY, dZ - pZ
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
    return dirX / magnitude, dirY / magnitude, dirZ / magnitude
end

MYTOOL.CalculateDirBetween2Pos = function(t1, t2)
    local pX, pY, pZ = t1.x, t1.y, t1.z
    local dX, dY, dZ = t2.x, t2.y, t2.z
    local dirX, dirY, dirZ = dX - pX, dY - pY, dZ - pZ
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
    return dirX / magnitude, dirY / magnitude, dirZ / magnitude
end

MYTOOL.calculate_distance = function(px, py, pz, x, y, z)
    return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
end

MYTOOL.addTemporaryBlockOnGround = function(x, y, z, blockid)
    local rY = y
    for i = y + 5, y - 15, -1 do
        rY = i
        if MYTOOL.checkBlockisSolid(x, i - 1, z) then
            break
        end
    end
    MYTOOL.addBlock(blockid, x, rY, z)
end

MYTOOL.playSoundOnPos = function(x, y, z, whatsound, volume, pitch)
    if not pitch then pitch = 1 end
    World:playSoundEffectOnPos({x=x, y=y, z=z}, whatsound, volume, pitch, false)
end

MYTOOL.getStat = function(playerid)
    return PLAYER_DAT.OBTAIN_STAT(playerid)
end

MYTOOL.getObj_Area = function(playerid, x, y, z, dx, dy, dz)
    local res = {}
    for i = 1, 4 do
        local r, t = Area:getAllObjsInAreaRange({x=x-dx, y=y-dy, z=z-dz}, {x=x+dx, y=y+dy, z=z+dz}, i)
        res[i] = t
    end
    return res
end

MYTOOL.filterObj = function(i, t)
    local k = {Player = 1, Creature = 2, DropItem = 3, Projectile = 4}
    return t[k[i]]
end

MYTOOL.notObj = function(playerid, t)
    local newTable = {}
    if t then
        for i = 1, #t do
            if t[i] ~= playerid then
                table.insert(newTable, t[i])
            end
        end
    end
    return newTable
end

MYTOOL.PAttackObj = function(playerid, a, amount, dtype)
    Actor:playerHurt(playerid, a, amount, dtype)
end

MYTOOL.in2per = function(o, p)
    return math.max(1, math.floor(o * p / 100))
end

MYTOOL.Vector3 = function(x, y, z)
    return {x = x, y = y, z = z}
end

MYTOOL.length = function(v)
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

MYTOOL.normalize = function(v)
    local len = MYTOOL.length(v)
    return MYTOOL.Vector3(v.x / len, v.y / len, v.z / len)
end

MYTOOL.crossProduct = function(a, b)
    return MYTOOL.Vector3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    )
end

MYTOOL.getRightDirection = function(forward)
    local up = MYTOOL.Vector3(0, 1, 0)
    local right = MYTOOL.crossProduct(forward, up)
    return MYTOOL.normalize(right)
end

MYTOOL.getLeftDirection = function(forward)
    local right = MYTOOL.getRightDirection(forward)
    return MYTOOL.Vector3(-right.x, -right.y, -right.z)
end

MYTOOL.playSoundOnActor = function(actorid, soundId, volume, pitch)
    if not pitch then pitch = 1 end
    return Actor:playSoundEffectById(actorid, soundId, volume, pitch, false)
end

MYTOOL.mergeTables = function(table1, table2)
    local mergedTable = {}
    local index = 1
    if table1 then
        for _, value in ipairs(table1) do
            mergedTable[index] = value
            index = index + 1
        end
    end
    if table2 then
        for _, value in ipairs(table2) do
            mergedTable[index] = value
            index = index + 1
        end
    end
    return mergedTable
end
