local actorid_Enabled_Respawn = {}; local function addRespawnActor(actorid,tablePos) actorid_Enabled_Respawn[actorid] = tablePos; end
local RespawnPos = {
    default = {
     x = 5    
    ,y = 10   
    ,z = -5   
    }
}

-- Add the Monster to be respawned 
addRespawnActor(3400,RespawnPos.default);

ScriptSupportEvent:registerEvent("Actor.Die",function(e)
    local creatureID = e.eventobjid;
    local actorid    = e.actorid;
    -- check if Exist on actorid_Enabled_Respawn
    if actorid_Enabled_Respawn[actorid] ~= nil then
        local resPos =actorid_Enabled_Respawn[actorid]
        local _, objids = World:spawnCreature(resPos.x,resPos.y,resPos.z, actorid, 1);   
    end 
end)