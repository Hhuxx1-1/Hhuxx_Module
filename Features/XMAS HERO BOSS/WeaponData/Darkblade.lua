local Darkblade = function(playerid)
    -- check Actorid of target id 
    local DarkBlade = 74

    local x,y,z = MYTOOL.GET_POS(playerid);
    local tx,ty,tz = MYTOOL.GET_AIM_POS_PLAYER(playerid);
    local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=x,y=y,z=z},{x=tx,y=ty,z=tz});
    -- deals Damage 
    local r, obj = World:spawnCreature(x+(dx/2),y+0.2,z+(dz/2),DarkBlade,1) 

    local ran = math.random(4,10)*10
    for i = 1,60 do 
        RUNNER.NEW(function()
            local px,py,pz = MYTOOL.GET_POS(playerid);
            local ttx,tty,ttz = MYTOOL.GET_POS(obj[1]);
            local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=ttx,y=tty,z=ttz},{x=px,y=py+1,z=pz})
            MYTOOL.dash(obj[1],-dx/2.5,0.07,-dz/2.5);
            local dis = MYTOOL.calculate_distance(px,py,pz,ttx,tty,ttz)
            dis = math.min(dis,15);
            MYTOOL.DEALS_DAMAGE_2_AREA(playerid,ttx,tty,ttz,3,3,3,30+(dis*15),0);
            -- get All Creaaturea and Player
            local OBJ = MYTOOL.getObj_Area(ttx,tty+1,ttz,6,6,6)
            for i,targetid in ipairs(MYTOOL.filterObj("Creature",OBJ))do
                local r,actorid = Creature:getActorID(targetid);
                if actorid ~= DarkBlade then 
                    local ax,ay,az = MYTOOL.GET_POS(targetid);
                    MYTOOL.DEALS_DAMAGE_2_AREA(playerid,ax,ay,az,3,3,3,math.random(5,10)*dis,0);
                    local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=ttx,y=tty,z=ttz},{x=ax,y=ay,z=az})
                    MYTOOL.dash(targetid,-2*dx/i,dy,-2*dz)
                    MYTOOL.healsDamage(playerid,5)
                end 
            end 
        end,{},i)
    end 
    RUNNER.NEW(function()
        Actor:killSelf(obj[1]);
    end,{},61)
    
end

local ComboWeapon={};
local stackNeeded = {};


WEAPON_PASSIVE:ADD_ATTACK_HIT(4197,function(playerid)
    if not ComboWeapon[playerid]  then 
        ComboWeapon[playerid] = 0;
    end 
 
    if not stackNeeded[playerid]  then 
        stackNeeded[playerid] = math.random(10,26);
    end 

     ComboWeapon[playerid] = math.min(ComboWeapon[playerid] + 1,stackNeeded[playerid]) ;
end)


WEAPON_PASSIVE:ADD_ATTACK(4197,function(playerid)
    if not ComboWeapon[playerid]  then 
        ComboWeapon[playerid] = 0;
     end 
     ComboWeapon[playerid] = ComboWeapon[playerid] + 1 ;
     
    if not stackNeeded[playerid]  then 
        stackNeeded[playerid] = math.random(10,26);
    end 

    if ComboWeapon[playerid] > stackNeeded[playerid]+1 then 
        Darkblade(playerid,playerid)
        ComboWeapon[playerid] = 0 ;
        stackNeeded[playerid] = nil;
    elseif ComboWeapon[playerid] == stackNeeded[playerid] then
        RUNNER.NEW(function()
            MYTOOL.ADD_EFFECT_TO_ACTOR(playerid,1476,1.5)
            MYTOOL.playSoundOnActor(playerid,11086,200,0.1)
        end,{},1)
    else 
        if math.fmod(ComboWeapon[playerid],2) == 0 then 
            local x,y,z = MYTOOL.GET_DIR_ACTOR(playerid)
            MYTOOL.dash(playerid,x,y,z);
        end 
    end 
end)
