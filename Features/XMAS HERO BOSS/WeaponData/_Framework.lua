WEAPON_PASSIVE = {};-- Store Passive weapon here 
local function getWeapon(playerid)
    local r,weaponid = Player:getCurToolID(playerid)
    if r == 0 then return weaponid; end 
end
WEAPON_PASSIVE.ATTACK = {};
WEAPON_PASSIVE.ATTACK_HIT = {};
WEAPON_PASSIVE.CONSUME = {};

function WEAPON_PASSIVE:ADD_ATTACK(weaponid,func)
    -- add passive weapon function that is executed when Player Attack 
    WEAPON_PASSIVE.ATTACK[weaponid] = func;
end 

function WEAPON_PASSIVE:ADD_ATTACK_HIT(weaponid,func)
    -- add passive weapon function that is executed when Player Attack 
    WEAPON_PASSIVE.ATTACK_HIT[weaponid] = func;
end 

function WEAPON_PASSIVE:ADD_CONSUME(weaponid,func)
    -- add passive weapon function that is executed when Player Attack 
    WEAPON_PASSIVE.CONSUME[weaponid] = func;
end 

ScriptSupportEvent:registerEvent("Player.Attack",
function(e)
    local r,err = pcall(function()
        if e.eventobjid then 
            local playerid = e.eventobjid;
            local weapon = getWeapon(playerid);
            if weapon then 
                Chat:sendSystemMsg("Attack : "..weapon);
                if WEAPON_PASSIVE.ATTACK[weapon] then
                    WEAPON_PASSIVE.ATTACK[weapon](playerid);
                end 
            end
        end 
    end);
    if not r then print("Error Weapon Attack : ",err); end 
end)

ScriptSupportEvent:registerEvent("Player.AttackHit",
function(e)
    local r,err = pcall(function()
        if e.eventobjid then 
            local playerid = e.eventobjid;
            local weapon = getWeapon(playerid);
            if weapon then 
                Chat:sendSystemMsg("AttackHit : "..weapon);
                -- execute saved function if exist 
                if WEAPON_PASSIVE.ATTACK_HIT[weapon] then
                    WEAPON_PASSIVE.ATTACK_HIT[weapon](playerid);
                end 
            end
        end 
    end)

    if not r then print("Error Weapon Hit : ",err); end 
end)
