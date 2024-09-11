FUNCX = {}

FUNCX.GET_POS = function(actorid)
    local r, x, y, z = Actor:getPosition(actorid)
    if r then return x, y, z end
end

FUNCX.GET_AIM_POS = function(obj)
    local r, x, y, z = Player:getAimPos(obj)
    if r then return x, y, z end
end

FUNCX.GET_DIR = function(playerid)
    local pX, pY, pZ = FUNCX.GET_POS(playerid)
    local dX, dY, dZ = FUNCX.GET_AIM_POS(playerid)
    local dirX, dirY, dirZ = dX - pX, dY - pY, dZ - pZ
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
    return dirX / magnitude, dirY / magnitude, dirZ / magnitude
end


FUNCX.GET_OBJ_AREA = function(playerid, x, y, z, dx, dy, dz)
    local res = {}
    for i = 1, 4 do
        local r, t = Area:getAllObjsInAreaRange({x=x-dx, y=y-dy, z=z-dz}, {x=x+dx, y=y+dy, z=z+dz}, i)
        res[i] = t
    end
    return res
end

FUNCX.FILTER_OBJ = function(i, t)
    local k = {PLAYER = 1, MOB = 2, DROP = 3, PROJ = 4}
    return t[k[i]]
end

FUNCX.NOT_OBJ = function(n, t)
    local newTable = {}
    if t then
        for i = 1, #t do
            if t[i] ~= n then
                table.insert(newTable, t[i])
            end
        end
    end
    return newTable
end
