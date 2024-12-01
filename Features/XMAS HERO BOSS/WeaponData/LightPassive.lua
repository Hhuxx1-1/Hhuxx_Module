
local function createLaserCharge(playerid,nx,ny,nz,id,dur)

    MYTOOL.ADD_EFFECT(nx,ny,nz,1738,0.8);
    MYTOOL.playSoundOnPos(nx,ny,nz,10797,100,1);
    RUNNER.NEW(function()
        MYTOOL.DEL_EFFECT(nx,ny,nz,1738,1);
        MYTOOL.playSoundOnPos(nx,ny,nz,10244,30,2);
        
        MYTOOL.ADD_EFFECT(nx,ny-1,nz,1293,2);
        for s = 2,dur,6 do 
            RUNNER.NEW(function()
                MYTOOL.DEALS_DAMAGE_2_AREA(playerid,nx,ny,nz,1,1,1,math.random(100,200),1);
                MYTOOL.playSoundOnPos(nx,ny,nz,10244,20,2);
                MYTOOL.ADD_EFFECT(nx,ny+1,nz,1021,2);
            end,{},s)
        end 
        RUNNER.NEW(function()
            MYTOOL.DEL_EFFECT(nx,ny-1,nz,1293,2);
            MYTOOL.DEL_EFFECT(nx,ny+1,nz,1021,1);
        end,{},dur+2);
    end,{},15)

    return true;
end 

local ComboWeapon={};

WEAPON_PASSIVE:ADD_ATTACK_HIT(4195,function(playerid)
    if not ComboWeapon[playerid]  then 
        ComboWeapon[playerid] = 0;
     end 
     ComboWeapon[playerid] = ComboWeapon[playerid] + 1 ;
end)

WEAPON_PASSIVE:ADD_ATTACK(4195,function(playerid)
    -- Chat:sendSystemMsg("Player : "..playerid);
    if not ComboWeapon[playerid]  then 
       ComboWeapon[playerid] = 0;
    end 
    ComboWeapon[playerid] = ComboWeapon[playerid] + 1 ;
    -- Chat:sendSystemMsg("Combo : "..ComboWeapon[playerid]);
    local x,y,z = MYTOOL.GET_POS(playerid);
    local vx,vy,vz = MYTOOL.GET_DIR_ACTOR(playerid)
    
    if ComboWeapon[playerid] < 5 then 
        local OBJ = MYTOOL.getObj_Area(x+(vx*2),y+(vy*2),z+(vz*2),3,3,3);
        if OBJ then
            for i,targetid in ipairs(MYTOOL.filterObj("Creature",OBJ))do
                local tx,ty,tz = MYTOOL.GET_POS(targetid);
                local effectid = 1021;
                RUNNER.NEW(function()
                    MYTOOL.ADD_EFFECT(tx,ty+1,tz,effectid,2);
                    -- deals Damage 
                    MYTOOL.DEALS_DAMAGE_2_AREA(playerid,tx,ty,tz,1,1,1,math.random(50,100),1);
                    RUNNER.NEW(function()
                        MYTOOL.DEL_EFFECT(tx,ty+1,tz,effectid,1);
                    end,{},20)
                end,{},1)
            end
        end 
    else
        createLaserCharge(playerid,x+(vx*3),y+(vy*3),z+(vz*3),1,40);
        ComboWeapon[playerid] = 0;
    end 
end)