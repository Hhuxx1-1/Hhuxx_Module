local ID = 42

BOSS.INIT(ID,"Lumina, The Protector Of Light");

local function createLaserCharge(nx,ny,nz,id,dur)

    MYTOOL.ADD_EFFECT(nx,ny,nz,1738,1.2);
    MYTOOL.playSoundOnPos(nx,ny,nz,10796,100,1);
    RUNNER.NEW(function()
        MYTOOL.DEL_EFFECT(nx,ny,nz,1738,1.2);
        MYTOOL.playSoundOnPos(nx,ny,nz,10244,50,2);
        
        MYTOOL.ADD_EFFECT(nx,ny-1,nz,1293,4);
        for s = 2,dur,6 do 
            RUNNER.NEW(function()
                BOSS.TOOL.ATTACk(id,{x=nx,y=ny,z=nz},{x=2,y=12,z=2},{dmg=10,type=1},{x=0,y=0.3,z=0});
                MYTOOL.playSoundOnPos(nx,ny,nz,10244,50,2);
                MYTOOL.ADD_EFFECT(nx,ny+1,nz,1021,3);
            end,{},s)
        end 
        RUNNER.NEW(function()
            MYTOOL.DEL_EFFECT(nx,ny-1,nz,1293,2);
            MYTOOL.DEL_EFFECT(nx,ny+1,nz,1021,1);
        end,{},dur+2);
    end,{},15)

end 

BOSS.ADD_ACTION(ID,function(id)
    -- Save Spawned Position 
    local x,y,z = MYTOOL.GET_POS(id);
    BOSS.COUNTER(ID,"XPOS","SET",x);
    BOSS.COUNTER(ID,"YPOS","SET",y);
    BOSS.COUNTER(ID,"ZPOS","SET",z);
    local r = Creature:setAttr(id,21,1.2);
    BOSS.COUNTER(ID,"SIZE","SET",1.2);
end,BOSS.HOOK_Type.OnSpawn)

local function Attack1(id)
    -- Light Beam to Anyone in Front of it 
    local x,y,z = MYTOOL.GET_POS(id); 
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    -- now you have that direction 
    local OBJ = MYTOOL.getObj_Area(x+(ex*10),y,z+(ez*10),35,25,35); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 

    local nearestPlayer = nil;

    -- now for each player 
    for i , playerid in ipairs(playerObj)do 
        -- calculate distance 
        local px,py,pz = MYTOOL.GET_POS(playerid)
        local distance = MYTOOL.calculate_distance(px,py,pz,x,y,z);
        -- Chat:sendSystemMsg("Distance : "..distance);
        if nearestPlayer == nil then
            nearestPlayer = {playerid=playerid,distance=distance};
        else
            if distance < nearestPlayer.distance then
                nearestPlayer = {playerid=playerid,distance=distance};
            end 
        end 
    end 
    -- now we have one nearest player 
    RUNNER.NEW(function()
        -- Create Indicator on player position 
        local nx,ny,nz = MYTOOL.GET_POS(nearestPlayer.playerid);
        ny = math.min(y,8);
        createLaserCharge(nx,ny,nz,id,80);
    end,{},1)
end

local function DragInto(x,y,z)
    local OBJ = MYTOOL.getObj_Area(x,y,z,8,8,8); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 

    for i,playerid in ipairs(playerObj) do 
        local px,py,pz = MYTOOL.GET_POS(playerid);
        local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=px,y=py,z=pz},{x=x,y=y,z=z})
        MYTOOL.dash(playerid,dx/2,dy/2,dz/2);
    end 

end

local function Attack2(id)
    -- get Position Originally from Counter data
    local x,y,z = BOSS.COUNTER(ID,"XPOS","GET"),BOSS.COUNTER(ID,"YPOS","GET"),BOSS.COUNTER(ID,"ZPOS","GET")
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    Actor:setPosition(id,x+0.5,y+4,z+0.5);
    RUNNER.NEW(function()
        MYTOOL.SET_ACTOR(id,"MOVE",false)
    end,{},2)
    -- get All Player in Area 
    local OBJ = MYTOOL.getObj_Area(x+(ex*10),y,z+(ez*10),35,25,35); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 
    -- now for each player
    for i , playerid in ipairs(playerObj)do
        -- directly shoot projectile to player
        for s=1,5 do 
            RUNNER.NEW(function()
                 local px,py,pz = MYTOOL.GET_POS(playerid);
                -- shoot projectile 
                MYTOOL.playSoundOnPos(x,y+2,z,10471,100,1);
                MYTOOL.ADD_EFFECT(x,y+2,z,1338,1);
                local projectileID = MYTOOL.SHOOT_PROJECTILE(id,4147,{x=x,y=y+2,z=z},{x=px,y=py-math.random(-1,2),z=pz},120);
                RUNNER.Obj_REGISTER(projectileID,id);
                RUNNER.ATTACH_Func_Obj(projectileID,function(projectile,e)
                    -- owner of projectile
                    local ownerID =  RUNNER.Obj_OF(projectile);
                    local x,y,z = e.x,e.y,e.z;
                    for s = 5,60,10 do 
                        RUNNER.NEW(function()
                            DragInto(x,y,z);    
                            MYTOOL.ADD_EFFECT(x,y+1,z,1211,1);
                            MYTOOL.playSoundOnPos(x,y,z,10471,100,1);
                        end,{},s)                        
                    end 
                    RUNNER.NEW(function()
                        Actor:killSelf(projectileID);
                        MYTOOL.DEL_EFFECT(x,y+1,z,1211,1);
                    end,{},65)
                end)
                MYTOOL.ADD_EFFECT_TO_ACTOR(projectileID,1210,2);
                MYTOOL.ADD_EFFECT_TO_ACTOR(projectileID,1212,2);
            end,{},s*15)
        end 
        RUNNER.NEW(function()
            MYTOOL.DEL_EFFECT(x,y+2,z,1338,1);
        end,{},5*15+5);
    end 
    RUNNER.NEW(function()
        MYTOOL.SET_ACTOR(id,"MOVE",true);
    end,{},80)
end

local function Defend1(id)
    local x,y,z = BOSS.COUNTER(ID,"XPOS","GET"),BOSS.COUNTER(ID,"YPOS","GET"),BOSS.COUNTER(ID,"ZPOS","GET")
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    Actor:setPosition(id,x+0.5,y+2,z+0.5);
    MYTOOL.SET_ACTOR(id,"MOVE",false);
    local r = Actor:addBuff(id,50000008,1,200);
    RUNNER.NEW(function()
        MYTOOL.SET_ACTOR(id,"MOVE",true);
    end,{},200)
end

local function AttackULT(id)

    local x,y,z = BOSS.COUNTER(ID,"XPOS","GET"),BOSS.COUNTER(ID,"YPOS","GET"),BOSS.COUNTER(ID,"ZPOS","GET")
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    Actor:setPosition(id,x+0.5,y+1,z+0.5);
    MYTOOL.SET_ACTOR(id,"MOVE",false);
    -- set the size to bigger a bit 
    for isize = 1,5 do 
        RUNNER.NEW(function()
            Creature:setAttr(id,21,1+isize*0.3);
        end,{},isize*10)
    end 
    RUNNER.NEW(function()
        local x,y,z = MYTOOL.GET_POS(id); 
        local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
        -- now you have that direction 
        local OBJ = MYTOOL.getObj_Area(x+(ex*10),y,z+(ez*10),45,25,45); 
        local playerObj = MYTOOL.filterObj("Player",OBJ);
        for i,playerid in ipairs(playerObj) do 
            RUNNER.NEW(function()
                -- Create Indicator on player position 
                local nx,ny,nz = MYTOOL.GET_POS(playerid);
                ny = math.min(y,8);
                createLaserCharge(nx,ny,nz,id,80);
                if math.random(1,2) == 1 then 
                    for offset = -8, 8, 4 do
                        createLaserCharge(nx + offset, ny, nz + offset, id, 80) -- Top-left to bottom-right
                        createLaserCharge(nx - offset, ny, nz + offset, id, 80) -- Top-right to bottom-left
                    end
                else
                    for ns = -8,8,4 do
                        createLaserCharge(nx+ns,ny,nz,id,80)
                        createLaserCharge(nx,ny,nz+ns,id,80)
                    end 
                end 
            end,{},20)
        end 
    end,{},65)

    RUNNER.NEW(function()
        MYTOOL.SET_ACTOR(id,"MOVE",true);
        Creature:setAttr(id,21,1.2);
    end,{},120)

end 

BOSS.ADD_ACTION(ID,function(id)
    local atkPattern = BOSS.COUNTER(ID,"ATK_PATTERN","GET"); 
    local atkTemplate = BOSS.COUNTER(ID,"ATK_TEMPLATE","GET");
    -- Chat:sendSystemMsg("atk Template is : "..atkTemplate);
    BOSS.COUNTER(ID,"ATK_PATTERN","ADD",1)
    if atkTemplate == 0 then
        atkPattern = math.fmod(atkPattern,11)+1
        if atkPattern == 1 then
            Attack1(id)
        elseif atkPattern == 4 then
            Attack2(id)
        elseif  atkPattern == 7 then
            Attack1(id)
        elseif atkPattern == 10 then 
            Defend1(id)
        end 
    elseif atkTemplate == 1 then  
        atkPattern = math.fmod(atkPattern,30)+1
        if atkPattern == 1 then
            Defend1(id)
        elseif atkPattern == 4 then
            Attack2(id)
        elseif  atkPattern == 7 then
            Attack1(id)
        elseif atkPattern == 10 then 
            Defend1(id)
        elseif atkPattern == 15 then 
            Attack2(id);
            for s = 10,60,20 do 
                RUNNER.NEW(function()
                    Attack1(id);    
                end,{},s)
            end 
        elseif atkPattern == 20 then 
            Defend1(id)
        elseif atkPattern == 25 then 
            AttackULT(id)
        end 
    end 
end,BOSS.HOOK_Type.OnAttack)

BOSS.ADD_ACTION(ID,function()
    -- change atk Template to 1
    BOSS.COUNTER(ID,"ATK_TEMPLATE","SET",1)
end,BOSS.HOOK_Type.OnHpLow)