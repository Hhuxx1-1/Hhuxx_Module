local function Attack_1(playerid)
    local x,y,z = MYTOOL.GET_POS(playerid);
    for s = 1, 10 , 2 do
        -- clear all projectile for 20 tick duration execution 0.1 Seconds 
        RUNNER.NEW(function()
        
            local OBJ = MYTOOL.getObj_Area(x,y,z,2,2,2)
            for i,Projectiles in ipairs(MYTOOL.filterObj("Projectile",OBJ)) do 
                Actor:killSelf(Projectiles)                
            end 
            local vx,vy,vz = MYTOOL.GET_DIR_ACTOR(playerid)
            MYTOOL.DEALS_DAMAGE_2_AREA(playerid,x+(vx*3),y+(vy*3),z+(vz*3),1,1,1,math.random(100,200),1);
        end,{},s)
    end 
end 

local SaberV2 = {}


local function Attack_2 (playerid) 
    local x,y,z = MYTOOL.GET_POS(playerid);
    local dx,dy,dz = MYTOOL.GET_DIR_ACTOR(playerid);
    local projectile = MYTOOL.SHOOT_PROJECTILE(playerid,4236,{x=x,y=y+1.5,z=z},{x=x+(dx*10),y=y+1.6,z=z+(dz*10)},60);
end 

WEAPON_PASSIVE:ADD_ATTACK(4154,function(playerid)
    Attack_1(playerid)

    if SaberV2[playerid] == nil then 
        SaberV2[playerid] = 0
    end 
    local x,y,z = MYTOOL.GET_DIR_ACTOR(playerid)
    SaberV2[playerid] = SaberV2[playerid] + 1 ;
    if SaberV2[playerid] > 2 then
        
        MYTOOL.dash(playerid,x/1.2,y,z/1.2);
    else 
        Attack_2(playerid)
    end 
    
    if SaberV2[playerid] >= 4 then 
        SaberV2[playerid] = 0 ;
    end 
end)
