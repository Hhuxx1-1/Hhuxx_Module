local Attack = function(playerid,targetid)
    -- check Actorid of target id 
    local bloodlustEffect = 73
    local r,actorid = Creature:getActorID(targetid);

    if actorid ~= bloodlustEffect then 
        local x,y,z = MYTOOL.GET_POS(playerid);
        local tx,ty,tz = MYTOOL.GET_POS(targetid);
        local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=x,y=y,z=z},{x=tx,y=ty,z=tz});
        -- deals Damage 
        local r, obj = World:spawnCreature(tx+(dx*2),ty+3,tz+(dz*2),bloodlustEffect,1) 
        
        RUNNER.NEW(function()
            MYTOOL.DEALS_DAMAGE_2_AREA(playerid,tx,ty,tz,1,2,1,math.random(50,100),0);    
        end,{},5)

        local ran = math.random(4,10)*10
        for i = 1,70 do 
            RUNNER.NEW(function()
                local px,py,pz = MYTOOL.GET_POS(playerid);
                local ttx,tty,ttz = MYTOOL.GET_POS(obj[1]);
                local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=ttx,y=tty,z=ttz},{x=px,y=py+1,z=pz})
                if i < 6 then 
                    MYTOOL.dash(obj[1],-dx/i,0.1,-dz/i);
                else
                    MYTOOL.dash(obj[1],2*dx/i,dy/40,2*dz/i);
                end 

                local distance = MYTOOL.calculate_distance(px,py,pz,ttx,tty,ttz)
                if distance < 3 then 
                    Actor:setPosition(obj[1],px,py,pz);
                    if math.fmod(i,10) == 0 then 
                        MYTOOL.healsDamage(playerid,2);
                        MYTOOL.ADD_EFFECT(px,py+1,pz,1235,0.5)
                        RUNNER.NEW(function()
                            MYTOOL.DEL_EFFECT(px,py+1,pz,1235,0.5)
                        end,{},20)
                    end 
                end 
            end,{},i)
        end 
        RUNNER.NEW(function()
            Actor:killSelf(obj[1]);
        end,{},71)
    end 
end

local BLOODLUST = {}

local LAST_HIT = {}

WEAPON_PASSIVE:ADD_ATTACK_HIT(4194,function(playerid)
    -- Chat:sendSystemMsg("Combo : "..ComboWeapon[playerid]);
    if not BLOODLUST[playerid] then 
        BLOODLUST[playerid] = 0;
    end 

    BLOODLUST[playerid] = math.min(BLOODLUST[playerid] + 0.4,3);

    local x,y,z = MYTOOL.GET_POS(playerid);
    local vx,vy,vz = MYTOOL.GET_DIR_ACTOR(playerid)
    
    local OBJ = MYTOOL.getObj_Area(x+(vx*2),y+(vy*2),z+(vz*2),3,3,3);
    if OBJ then
        for i,targetid in ipairs(MYTOOL.filterObj("Creature",OBJ))do
            for s = 1,math.ceil(BLOODLUST[playerid]) do 
                RUNNER.NEW(function()
                    Attack(playerid,targetid);
                end,{},s*2)
            end 
        end
    end 
    
    LAST_HIT[playerid] = RUNNER.GAME_TICK;

    RUNNER.NEW(function()
        -- if not hit then reset 
        if RUNNER.GAME_TICK - LAST_HIT[playerid] > 100 then
            BLOODLUST[playerid] = 0;
        end 
    end,{},100)

end)