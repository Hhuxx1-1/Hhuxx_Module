-- Date Created : 2022-04-20
-- mini: 1029380338
-- Last Update : 2024-06-28
-- Hhuxx1 is Drunk , This is used to store Skill Action
-- REQUIRE Multirunner.lua framework
local tile = {	fireball = 15508,	Rain = 11670,	thunder = 11588 }
local soundEffect = { explosion = 10538 }
local buffStuned = 1070;
local second = 20;
local specialEffect = { explosion1 = 1311, danger = 1605,explosion2 = 1334,fire=1653 }

-- =====================================
-- ========== List of Function =========
-- =====================================
-- List of local function v1 
local function getPos(obj) 	                                                                        local r,x,y,z = Actor:getPosition(obj);  	if(r) then return x,y,z end end
local function getAimPos(obj)	                                                                    local r,x,y,z = Player:getAimPos(obj); 	if(r) then return x,y,z  end end
local function addEffect(x,y,z,effectid,scale)                                                      World:playParticalEffect(x,y,z,effectid,scale); end 
local function cancelEffect(x,y,z,effectid,scale)                                                   World:stopEffectOnPosition(x,y,z,effectid,scale); end
local function dealsDamage(playerid,x,y,z,dx,dy,dz,amount,dtype)                                    local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz});    Actor:playerHurtArea(playerid, areaid, amount, dtype);    Area:destroyArea(areaid); end
local function dealsDamageButNotHost(playerid,x,y,z,dx,dy,dz,amount,dtype)                          local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz}); local r1,p = Area:getAreaPlayers(areaid);    local r2,c = Area:getAreaCreatures(areaid); for i,a in ipairs(p) do if a~=playerid then Actor:playerHurt(playerid, a, amount, dtype); end end for i,a in ipairs(c) do Actor:playerHurt(playerid, a, amount, dtype); end Area:destroyArea(areaid); end 
local function dealsDamageWithBuff(playerid,x,y,z,dx,dy,dz,amount,dtype,buffid,bufflv, customticks) dealsDamageButNotHost(playerid,x,y,z,dx,dy,dz,amount,dtype); local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz});    local r1,p = Area:getAreaPlayers(areaid); local r2,c = Area:getAreaCreatures(areaid);    for i,a in ipairs(p) do if a~=playerid then Actor:addBuff(a, buffid, bufflv, customticks) end end for i,a in ipairs(c) do Actor:addBuff(a, buffid, bufflv, customticks) end Area:destroyArea(areaid); end 
local function dash(playerid,x,y,z)                                                                 Actor:appendSpeed(playerid,x,y,z) end 
local function checkBlockisSolid(x,y,z)                                                             local r,b = Block:isSolidBlock(x, y, z) return b end 
local function addBlock(blockid,x,y,z)                                                              if(checkBlockisSolid(x,y,z)==false)then                      Block:placeBlock(blockid,x,y,z); end end 
local function healsDamage(playerid,dmg)                                                            local r,HP = Player:getAttr(playerid, 2)                   Player:setAttr(playerid, 2,HP+dmg) end 
local function getDir(playerid)               
    local pX, pY, pZ = getPos(playerid);
    local dX, dY, dZ = getAimPos(playerid); 
    local dirX,dirY,dirZ = dX - pX , dY - pY , dZ - pZ; 
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2); 
    return dirX / magnitude,dirY / magnitude,dirZ / magnitude
end
local function CalculateDirBetween2Pos(t1,t2)
    local pX, pY, pZ = t1.x,t1.y,t1.z;
    local dX, dY, dZ = t2.x,t2.y,t2.z; 
    local dirX,dirY,dirZ = dX - pX , dY - pY , dZ - pZ; 
    local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2); 
    return dirX / magnitude,dirY / magnitude,dirZ / magnitude
end 
local function addTemporaryBlockOnGround(x,y,z,blockid)                                             local rY = y; for i=y+5,y-15 do rY=i; if(checkBlockisSolid(x,i-1,z))then break; end end addBlock(blockid,x,rY,z); end 
local function playSoundOnPos(x,y,z,whatsound,volume,pitch)               if(pitch==nil)then pitch=1 end                                World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, pitch, false) end 
-- list of local function v2 
local function getStat(playerid) return PLAYER_DAT.OBTAIN_STAT(playerid); end
local function getObj_Area(playerid,x,y,z,dx,dy,dz) --[[1=Player,2=Creature,3=DropItem,4=Missile]]
    local res = {};
    for i=1,4 do 
        local r , t = Area:getAllObjsInAreaRange({x=x-dx,y=y-dy,z=z-dz}, {x=x+dx,y=y+dy,z=z+dz}, i);
        res[i]=t;
    end 
    return res;
end
local function filterObj(i,t)
    local k = {Player = 1 , Creature = 2 , DropItem = 3 , Projectile = 4};
    return t[k[i]];
end
local function notObj(playerid, t)
    local newTable = {}
    if(t~=nil)then 
    for i = 1, #t do
        if t[i] ~= playerid then
            table.insert(newTable, t[i])
        end
    end
    end 
    return newTable
end
local function PAttackObj(playerid,a,amount,dtype)
    local r = Actor:playerHurt(playerid, a, amount, dtype);
end
local function in2per(o,p)
    return math.max(1,math.floor(o*p/100));
end 
local function Vector3(x, y, z)
    return {x = x, y = y, z = z}
end

local function length(v)
    return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

local function normalize(v)
local len = length(v)
    return Vector3(v.x / len, v.y / len, v.z / len)
end

local function crossProduct(a, b)
return Vector3(
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x
)
end

local function getRightDirection(forward)
    local up = Vector3(0, 1, 0)
    local right = crossProduct(forward, up)
    return normalize(right)
end

local function getLeftDirection(forward)
    local right = getRightDirection(forward)
    return Vector3(-right.x, -right.y, -right.z)
end
  
local function playSoundOnActor(actorid,soundId,volume,pitch)
    if(pitch==nil)then pitch = 1 end 
    return  Actor:playSoundEffectById(actorid, soundId, volume, pitch, false);
end
local function mergeTables(table1, table2)
    local mergedTable = {}
    local index = 1
    if(table1~=nil)then     
        -- Insert all elements from table1
        for _, value in ipairs(table1) do
            mergedTable[index] = value
            index = index + 1
        end
    end 
    if(table2~=nil)then 
        -- Insert all elements from table2
        for _, value in ipairs(table2) do
            mergedTable[index] = value
            index = index + 1
        end
    end 
    return mergedTable
end
-- List of Constant 
local Constants = {};
Constants.Projectile_Bullet = 15003;
local DmgType = {   MELEE   = 0 ,   RANGE = 1 , EXPLOSION   = 2 ,
                    BURNING = 3 ,   TOXIN = 4 , WITHER      = 5 , 
                    MAGIC   = 6 ,   FALL  = 7 , SPIKE       = 8 , 
                    COLLIDE = 9 ,   DROWN = 10, SUFFOCATE   = 11 , 
                    ANTIINJURY = 12 , LASER = 13
                }
-- =========================================
-- ================ [ ACT ] ================
-- =========================================
-- act as holder for skill set with named index of the skill name without space and seperate the word with capital alphabet 
act={};
act.FireBall={
    CD		=	6,
    Cost	=	7,
    main 	= 	function(playerid) 
       local x,y,z = getPos(playerid);       local dx,dy,dz = getAimPos(playerid);
       local maxi = 20; for i=1,maxi,3 do 
       local r = math.min((maxi/2)-(i/2),maxi/5); local cX,cY,cZ = dx+(math.random(-r,r)/4),dy,dz+(math.random(-r,r)/4);
            
            RUNNER.NEW(function(playerid,x,y,z,cX,cY,cZ) --[[ Register New Running Function ]]
                local Px,Py,Pz = getPos(playerid);local dx,dy,dz = getDir(playerid);
                -- Summon Projectile 
                playSoundOnPos(Px+math.random(-1,1)+dx,Py+math.random(-1,1)+dy,Pz+math.random(-1,1)+dz,10640,30);
                local re,projectileID = World:spawnProjectile(playerid, Constants.Projectile_Bullet , Px+dx,1+Py+dy,Pz+dz, cX+(dx*4),cY+(dy*4),cZ+(dz*4) , 160);
                -- Set Projectile Owner 
                RUNNER.Obj_REGISTER(projectileID,playerid);
                -- Attach Function to Run after Projectile Hits 
                RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                    local x,y,z = e.x,e.y,e.z 
                    local playerid = RUNNER.Obj_OF(projectileID);
                    local dmg = getStat(playerid).M_ATK;
                    addEffect(x,y,z,1403,1); 
                    playSoundOnPos(x,y,z,soundEffect.explosion,70);
                    dealsDamageButNotHost(playerid,x,y,z,3,3,3,in2per(dmg,110),DmgType.BURNING)
                    addEffect(x,y-1,z,1653,0.5);
                    for i=2,60,6 do 
                        RUNNER.NEW(function(x,y,z,playerid) 
                            dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,10),DmgType.BURNING)
                        end,{x,y,z,playerid},i);
                    end 
                    RUNNER.NEW(function(x,y,z)
                        cancelEffect(x,y-1,z,1653)
                    end,{x,y,z},62);
                    RUNNER.NEW(function(x,y,z)
                        cancelEffect(x,y,z,1403)
                    end,{x,y,z},20)

                end)
                -- Change the Appearence of Projectile 
                -- Summon Projectile with Custom Model and add Special Effect of Flame
                Actor:changeCustomModel(projectileID, [[item_15519]]);
                Actor:playBodyEffectById(projectileID, 1003,1);

            end,							 {playerid,x,y,z,cX,cY,cZ},
            (math.fmod(i,5)/2)*5);
            
       end 
    end
}
act.FireBird={
    CD		=	9,
    Cost	=	10,
    main 	= 	function(playerid)
       local lavaball = 15508;
       local maxi = 30;
       local dmg = getStat(playerid).M_ATK;
       local dX,dY,dZ = getAimPos(playerid);

        RUNNER.NEW(function(playerid,dX,dY,dZ)
            playSoundOnPos(dX,dY,dZ,10175,50);
            addEffect(dX,dY+1,dZ,1220,1)
        end,{playerid,dX,dY,dZ},3);

        RUNNER.NEW(function(playerid,dX,dY,dZ)
            cancelEffect(dX,dY+1,dZ,1220)     
            for i=maxi,maxi+15 do 
                    dX,dY,dZ = dX+math.random(-1,1),dY+(math.random(0,1)/2),dZ+math.random(-1,1);
                    RUNNER.NEW(function(playerid,dX,dY,dZ)
                        local re,projectileID = World:spawnProjectile(playerid,15508 , dX,dY,dZ, dX,dY+3,dZ, math.random(30,50));
                        Actor:changeCustomModel(projectileID, [[block_5]]);
                        Creature:setAttr(projectileID,21, 10);
                        Actor:playBodyEffectById(projectileID, 1018,1);
                        RUNNER.Obj_REGISTER(projectileID,playerid); 
                        RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                            local x,y,z = e.x,e.y,e.z 
                            local playerid = RUNNER.Obj_OF(projectileID);
                            local dmg = getStat(playerid).M_ATK;
                            addEffect(x,y,z,1403,1); 
                            playSoundOnPos(x,y,z,soundEffect.explosion,70);
                            dealsDamageButNotHost(playerid,x,y,z,3,3,3,in2per(dmg,110),DmgType.BURNING)
                            addEffect(x,y-1,z,1653,2);
                            for i=2,90,15 do 
                                RUNNER.NEW(function(x,y,z,playerid) 
                                    dealsDamageButNotHost(playerid,x,y,z,3,2,3,in2per(dmg,80),DmgType.BURNING)
                                end,{x,y,z,playerid},i);
                            end 
                            RUNNER.NEW(function(x,y,z)
                                cancelEffect(x,y-1,z,1653)
                            end,{x,y,z},62);
                            RUNNER.NEW(function(x,y,z)
                                cancelEffect(x,y,z,1403)
                            end,{x,y,z},20)
                        end)

                    end,							 {playerid,dX,dY,dZ},
                    math.fmod(i,5)+2*5);
                    
                    RUNNER.NEW(function(playerid,dX,dY,dZ)
                        dealsDamageButNotHost(playerid,dX,dY-2,dZ,3,5,3,in2per(dmg,130),DmgType.EXPLOSION);
                        playSoundOnPos(dX,dY,dZ,soundEffect.explosion,100);
                        addEffect(dX,dY,dZ,specialEffect.explosion2,2);
                        addTemporaryBlockOnGround(dX,dY,dZ,500); 
                    end,							 {playerid,dX,dY,dZ},
                    (math.fmod(i,5)+1)*5);
                    
                    RUNNER.NEW(function(playerid,dX,dY,dZ)
                        cancelEffect(dX,dY,dZ,specialEffect.explosion2,1);
                    end,							 {playerid,dX,dY,dZ},
                    (math.fmod(i,5)+5)*5);
            end

        end,{playerid,dX,dY,dZ},maxi);
    end
}
act.FireDash={
    CD		=	7,
    Cost	=	4,
    main 	= 	function(playerid)
        local x,y,z =getDir(playerid)
        -- Call the dash function with the normalized direction
        local power = 8;
        Player:setImmuneType(playerid,3,true);
        for i=0,power do 
            
            RUNNER.NEW(function(playerid,x,z,i)
                local px,py,pz = getPos(playerid);
                if(i==0)then 
                    playSoundOnPos(px,py,pz,10208,70)
                end 
                local dmg = getStat(playerid).M_ATK;
                dash(playerid, x, 0, z);
                Player:setImmuneType(playerid,3,true);
                dealsDamageButNotHost(playerid,px,py,pz,2,2,2,in2per(dmg,180),DmgType.RANGE);
                addEffect(px,py,pz,specialEffect.fire,0.5)
                healsDamage(playerid,in2per(dmg,50));
                for ii=1,40,5 do 
                    RUNNER.NEW(function(playerid,px,py,pz)
                        dealsDamageButNotHost(playerid,px,py,pz,2,2,2,in2per(dmg,110),DmgType.BURNING);
                    end,{playerid,px,py,pz},10+ii);
                end 
                RUNNER.NEW(function(playerid,px,py,pz)
                    cancelEffect(px,py,pz,specialEffect.fire,1);
                end,							 {playerid,px,py,pz},
                40);
                
            end,{playerid,x,z,i},i)
        end 

        RUNNER.NEW(function(playerid)
            Actor:removeBuff(playerid, skill.cooldown[2]);
        end,{playerid},2);

        RUNNER.NEW(function(playerid)
            Player:setImmuneType(playerid,3,false);
        end,							 {playerid},
        40+2*power);
    end
}
act.IceLance={
    CD=4,
    Cost=5,
    main = function(playerid) 
        for i=5,25,3 do 
            RUNNER.NEW(function(playerid) 
            
                local x,y,z = getPos(playerid);
                local dx,dy,dz = getAimPos(playerid);    
                local dirx,diry,dirz = getDir(playerid)
                local re,projectileID1 = World:spawnProjectile(playerid,15507 , x+(dirx*1.5),y+(diry*1.5),z+(dirz*1.5), dx+(dirx*(math.random(-2,2)/2)),dy+0.5,dz+(dirz*(math.random(-2,2)/2)), 240);
                local re,projectileID2 = World:spawnProjectile(playerid,15507 , x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5), dx+(dirx*(math.random(-2,2)/2)),dy+1.5,dz+(dirz*(math.random(-2,2)/2)), 60);
                local re,projectileID3 = World:spawnProjectile(playerid,15507 , x+(dirx*1.5),y+(diry*1.5),z+(dirz*1.5), dx,dy,dz, 280);
                local re,projectileID4 = World:spawnProjectile(playerid,15507 , x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5), dx,dy+0.5,dz, 200);
                Actor:changeCustomModel(projectileID1,[[item_15507]] );Actor:changeCustomModel(projectileID2,[[item_15507]] );
                Actor:changeCustomModel(projectileID3,[[item_15507]] );Actor:changeCustomModel(projectileID4,[[item_15507]] );
                playSoundOnPos(x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5),10536,100);
                local projectileIDs = {projectileID1,projectileID2,projectileID3,projectileID4};
                for i,a in ipairs(projectileIDs) do 
                    RUNNER.Obj_REGISTER(a,playerid); 
                    RUNNER.ATTACH_Func_Obj(a,function(projectileID,e)
                        local x,y,z = e.x,e.y,e.z; 
                        local playerid = RUNNER.Obj_OF(projectileID);
                        local dmg = getStat(playerid).M_ATK;

                        addEffect(x,y,z,1417,1); RUNNER.NEW(function(x,y,z)
                            cancelEffect(x,y,z,1417);
                        end,{x,y,z},40)
                        dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,90));
                    end)
                end 
            end,{playerid},i)
        end 
    end
}
act.IceBreath={
    CD=8, 
    Cost=5,
    main = function(playerid)
        for i=2,20,3 do 
            RUNNER.NEW(function(playerid)
                local x,y,z=getPos(playerid);
                local dirx,diry,dirz = getDir(playerid);
                local cx,cy,cz = x+(dirx*i),y+(diry*i),z+(dirz*i);
                addEffect(cx,cy,cz,1233,2);
                -- TODO : add Sound 
                playSoundOnPos(cx,cy,cz,10094,20);
                for ii=0,9,3 do 
                    RUNNER.NEW(function(playerid,cx,cy,cz)
                    local dmg = getStat(playerid).M_ATK;
                    dealsDamageButNotHost(playerid,cx,cy,cz,2,2,2,in2per(dmg,30),4);
                    end,{playerid,cx,cy,cz},ii*2);
                end 
                RUNNER.NEW(function(playerid,cx,cy,cz)
                    local dmg = getStat(playerid).M_ATK;
                    dealsDamageWithBuff(playerid,cx,cy,cz,2,2,2,in2per(dmg,110),4,1050,5, 40);
                end,{playerid,cx,cy,cz},10);
                RUNNER.NEW(function(cx,cy,cz)
                    cancelEffect(cx,cy,cz,1233);    
                end,{cx,cy,cz},40);
                
            end,{playerid},i)
        end 
    end 
}
act.IceGlacier={
CD=40,
Cost=20,
main=function(playerid)
   RUNNER.NEW(function(playerid)
       Actor:addBuff(playerid,2010,1,260);
       Actor:addBuff(playerid,50000009,1,70);
       Actor:addBuff(playerid, skill.cooldown[2],1,80);
       Actor:addBuff(playerid, skill.cooldown[1],1,80);
   end,{playerid},1); 
end}
act.ThunderStorm={
    CD=16,
    Cost=10,
    main = function(playerid)
        for i=5,10,5 do 
            RUNNER.NEW(function(playerid)
                local x,y,z = getPos(playerid);
                local ax,ay,az = getAimPos(playerid);
                local dmg = getStat(playerid).M_ATK;
                addEffect(ax,y,az,1620,3);
                playSoundOnPos(ax,y,az,10660,200);
                dealsDamageButNotHost(playerid,ax,y,az,5,5,5,50+in2per(dmg,400),DmgType.MAGIC);
                RUNNER.NEW(function(ax,y,z)
                     cancelEffect(ax,y,az,1620);
                end,{ax,y,z},20);
                
            end,{playerid},i)
        end
    end
}
act.ThunderDash={
    CD=6,
    Cost=5,
    main=function(playerid)
        local dur = 10;
        RUNNER.NEW(function(playerid) Actor:playBodyEffectById(playerid,1479,2); Actor:changeCustomModel(playerid, [[fullycustom_10293803381609044203]]); end,{playerid},0);
        RUNNER.NEW(function(playerid) Actor:stopBodyEffectById(playerid,1479); Actor:recoverinitialModel(playerid); end,{playerid},dur+10);
        for i=1,dur,2 do 
            RUNNER.NEW(function(playerid)
                local x,y,z    = getPos(playerid);
                local dx,dy,dz = getDir(playerid);
                local cx,cz =(dx*2), (dz*2);
                addEffect(x-cx,y,z-cz,1291);
                dash(playerid,cx,0,cz);
                
                        local r ,areaid = Area:createAreaRect({x=x-cx,y=y,z=z-cz},{x=3,y=3,z=3});
                        local r1,p = Area:getAreaPlayers(areaid);
                        local r2,c = Area:getAreaCreatures(areaid);    
                        for i,a in ipairs(p) do
                            if a~=playerid then 
                                local tx,ty,tz = getPos(a);
                                local r,projectileID = World:spawnProjectile(playerid, tile.thunder, tx-0.5, ty+1, tz+0.5, tx+0.5, ty-1, tz-0.5, 200);    
                                RUNNER.Obj_REGISTER(projectileID,playerid);
                                RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                                    local x,y,z = e.x,e.y,e.z; local playerid = RUNNER.Obj_OF(projectileID);
                                    local dmg = getStat(playerid).M_ATK;
                                    dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,50),DmgType.LASER);
                                end)
                            end 
                        end 
                        for i,a in ipairs(c) do 
                            local tx,ty,tz = getPos(a);
                            local r,projectileID =  World:spawnProjectile(playerid, tile.thunder, tx-0.5, ty+1, tz+0.5, tx+0.5, ty-1, tz-0.5, 200);    
                            RUNNER.Obj_REGISTER(projectileID,playerid);
                            RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                                local x,y,z = e.x,e.y,e.z; local playerid = RUNNER.Obj_OF(projectileID);
                                local dmg = getStat(playerid).M_ATK;
                                dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,50),DmgType.LASER);
                            end)
                        end 
                        Area:destroyArea(areaid);
                        
            end,{playerid},i)
        
        end 
        
    end 
}
act.ThunderBuff={
    CD=40,
    Cost=1,
    main=function(playerid)
        for i=1,10 do 
            RUNNER.NEW(function(playerid) 
                local x,y,z = getPos(playerid);
                local r,mana = Player:getAttr(playerid,PLAYERATTR.CUR_HUNGER)
                Player:setAttr(playerid,PLAYERATTR.CUR_HUNGER,mana+5);
                Actor:playBodyEffectById(playerid,1308,2);playSoundOnPos(x,y,z,10175,100);
                Actor:removeBuff(playerid, skill.cooldown[1+math.fmod(i,2)]);
                    local r ,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=4,y=3,z=4});
                        local r1,p = Area:getAreaPlayers(areaid);
                        local r2,c = Area:getAreaCreatures(areaid);    
                        for i,a in ipairs(p) do
                            if a~=playerid then 
                                local tx,ty,tz = getPos(a);
                                local r,projectileID = World:spawnProjectile(playerid, tile.thunder, tx-0.5, ty+1, tz+0.5, tx+0.5, ty-1, tz-0.5, 200);    
                                RUNNER.Obj_REGISTER(projectileID,playerid);
                                RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                                    local x,y,z = e.x,e.y,e.z; local playerid = RUNNER.Obj_OF(projectileID);
                                    local dmg = getStat(playerid).M_ATK;
                                    dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,50),DmgType.LASER);
                                end)
                            end 
                        end 
                        for i,a in ipairs(c) do 
                            local tx,ty,tz = getPos(a);
                            local r,projectileID =  World:spawnProjectile(playerid, tile.thunder, tx-0.5, ty+1, tz+0.5, tx+0.5, ty-1, tz-0.5, 200);    
                            RUNNER.Obj_REGISTER(projectileID,playerid);
                            RUNNER.ATTACH_Func_Obj(projectileID,function(projectileID,e)
                                local x,y,z = e.x,e.y,e.z; local playerid = RUNNER.Obj_OF(projectileID);
                                local dmg = getStat(playerid).M_ATK;
                                dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(dmg,50),DmgType.LASER);
                            end)
                        end 
                        Area:destroyArea(areaid);
            end,{playerid},i*1.5*second);
        end 
    end 
}
act.PowerUp={
    CD=60,
    Cost=20,
    main=function(playerid)
        local ammountPowerUp = getStat(playerid).HP/2;
        local dur = 8;
        local r,InitMaxHealth = Player:getAttr(playerid,1); 
        for i=1,dur do 
            
            RUNNER.NEW(function(playerid) 
                local x,y,z = getPos(playerid);
                local r,maxhealth = Player:getAttr(playerid,1); 
                if(r==0)then
                      Player:setAttr(playerid,1,maxhealth+(ammountPowerUp/dur));
                end
                local r,curHealth = Player:getAttr(playerid,2); 
                if(r==0)then
                    Player:setAttr(playerid,2,curHealth+(ammountPowerUp/dur));
                end
                playSoundOnPos(x,y,z,10966,50);
                local r,mana = Player:getAttr(playerid,PLAYERATTR.CUR_HUNGER)
                Player:setAttr(playerid,PLAYERATTR.CUR_HUNGER,mana+6);
                -- add special effect 
                Actor:removeBuff(playerid, skill.cooldown[2]);
                Actor:removeBuff(playerid, skill.cooldown[1]);
            end,{playerid},i*second)
                
            
        end 
        
            RUNNER.NEW(function(playerid,InitMaxHealth) 
            
                Player:setAttr(playerid,1,InitMaxHealth);
                
            end,{playerid,InitMaxHealth},(dur+5)*second)
    end
}
act.PowerDash={
    CD=7,
    Cost=2,
    main=function(playerid)
        local dirx,diry,dirz = getDir(playerid);
        RUNNER.CALL(function(playerid)
            local x,y,z = getPos(playerid);
            Actor:playBodyEffectById(playerid,1186);
            playSoundOnPos(x,y,z,10472,100);
        end,{playerid})
        
        for i=10,12 do 
            RUNNER.NEW(function(playerid,dirx,diry,dirz)
                dash(playerid,dirx,diry,dirz);
            end,{playerid,dirx,diry,dirz},i)
        end 
        
        RUNNER.NEW(function(playerid)
            local px,py,pz=getPos(playerid);
            local r1,r2,r3=Block:isAirBlock(px,py-1,pz),Block:isAirBlock(px,py-2,pz),Block:isAirBlock(px,py-3,pz)
        
            if(r1==0 or r2==0 or r3==0)then
                --Chat:sendSystemMsg("In Air");
                    dash(playerid,0,-10,0);
                RUNNER.NEW(function(playerid)
                    local x,y,z=getPos(playerid); local dmg = getStat(playerid).P_ATK; local dmg2 = getStat(playerid).HP;
                    Actor:setActionAttrState(playerid, 1, false)
                    dealsDamageButNotHost(playerid,x,y,z,5,5,5,in2per(dmg,350)+in2per(dmg2,80),1);
                    addEffect(x,y,z,1700,2);
                    playSoundOnPos(x,y,z,10110,300);
                    RUNNER.NEW(function(playerid) Actor:setActionAttrState(playerid, 1, true) 
                    
                        local r , tick = Actor:getBuffLeftTick(playerid,skill.cooldown[3]);
                        if(r==0)then Actor:addBuff(playerid,skill.cooldown[3],1,math.max(1,tick-60)) end;

                    end,{playerid},5)
                    RUNNER.NEW(function(x,y,z)
                        cancelEffect(x,y,z,specialEffect.explosion2);	
                    end,{x,y,z},30);
                end,{playerid},3);
            else
                --Chat:sendSystemMsg("Not In Air");
                local x,y,z=getPos(playerid); local dmg = getStat(playerid).P_ATK;local dmg2 = getStat(playerid).HP;
                Actor:setActionAttrState(playerid, 1, false)
                dealsDamageButNotHost(playerid,x,y,z,5,5,5,in2per(dmg,200)+in2per(dmg2,60),1);
                addEffect(x,y,z,1700,2);
                playSoundOnPos(x,y,z,10110,300);
                RUNNER.NEW(function(playerid) Actor:setActionAttrState(playerid, 1, true);
                    local r , tick = Actor:getBuffLeftTick(playerid,skill.cooldown[3]);
                    if(r==0)then Actor:addBuff(playerid,skill.cooldown[3],1,math.max(1,tick-20)) end;
                end,{playerid},5)
                RUNNER.NEW(function(x,y,z)
                    cancelEffect(x,y,z,specialEffect.explosion2);	
                end,{x,y,z},30);
            end
        end,{playerid},18)

    end
}
act.PowerPunch={
    CD=6,
    Cost=4,
    main=function(playerid)
        RUNNER.NEW(function(playerid)
            local x,y,z = getPos(playerid); --Get Player Position 
            local dx,dy,dz = getDir(playerid); -- Get Vector3 Facing Direction 
            local sEffect = 1182; 
            local soEffect = 10110;
            local cx,cy,cz = x+(dx*2.5),y+(dy*2.5),z+(dz*2.5) -- Insert Vector 3 Facing Direction into Player Position with Distance of 2.5 Block
            local dmg = getStat(playerid).P_ATK;local dmg2 = getStat(playerid).HP; -- Get Current Attribute damage 
            dealsDamageButNotHost(playerid,cx,cy,cz,2,2,2,in2per(dmg,300)+in2per(dmg2,40),1); -- Calculate Damage and Deals to Notself 
            addEffect(cx,cy,cz,sEffect,2);            playSoundOnPos(cx,cy,cz,soEffect,200);
            
            local r , tick = Actor:getBuffLeftTick(playerid,skill.cooldown[3]);
            if(r==0)then Actor:addBuff(playerid,skill.cooldown[3],1,math.max(1,tick-60)) end;

            local r,areaid = Area:createAreaRect({x=cx,y=cy,z=cz},{x=2,y=2,z=2});
            local r1,p = Area:getAreaPlayers(areaid);
            local r2,c = Area:getAreaCreatures(areaid);    
            for i,a in ipairs(p) do
                if a~=playerid then 
                    dash(a,dx*3,dy/2,dz*3);    
                end 
            end 
            for i,a in ipairs(c) do 
                dash(a,dx*3,dy/2,dz*3);
            end 
            Area:destroyArea(areaid);
            
            RUNNER.NEW(function(cx,cy,cz)
                cancelEffect(cx,cy,cz,sEffect,2);
            end,{cx,cy,cz},20);
            
        end,{playerid},5)
    end 
}

act.Sword100={
    CD = 6,    Cost = 5, main = function(playerid)
        RUNNER.NEW(function(playerid) 
            for i=1,41,5 do RUNNER.NEW(function(playerid)
                local x,y,z = getPos(playerid); local dirx,diry,dirz = getDir(playerid); local aimx,aimy,aimz = getAimPos(playerid); 
                local sEffect = 1249; local soEffect = 10635;
                local lx,ly,lz = -dirz,diry,dirx; --left
                local rx,ry,rz = dirz,diry,-dirx; --right
                local cx1,cy1,cz1 = x+(lx*3),y+3,z+(lz*3);
                local cx2,cy2,cz2 = x+(rx*3),y+3,z+(rz*3);
                addEffect(cx1,cy1-1,cz1,sEffect,2);
                addEffect(cx2,cy2-1,cz2,sEffect,2);
                RUNNER.NEW(function(playerid,cx1,cx2,cy1,cy2,cz1,cz2,aimx,aimy,aimz)
                    local mdl = {[[fullycustom_10293803381722387686]],[[fullycustom_10293803381722387686]]}
                    local re,P1 = World:spawnProjectile(playerid,15003 , cx1,cy1,cz1, aimx,aimy,aimz, 200);
                    local re,P2 = World:spawnProjectile(playerid,15003 , cx2,cy2,cz2, aimx,aimy,aimz, 200);
                    -- change the Appearence
                    playSoundOnActor(P1,10471,100,1);
                    playSoundOnActor(P2,10471,100,1);
                    Actor:changeCustomModel(P1, mdl[math.random(1,2)]);
                    Actor:changeCustomModel(P2, mdl[math.random(1,2)]);
                    -- Attach function to Projectiles 
                    RUNNER.Obj_REGISTER(P1,playerid);RUNNER.Obj_REGISTER(P2,playerid); 
                    RUNNER.ATTACH_Func_Obj(P1,function(projectileID,e)
                        local x,y,z = e.x,e.y,e.z; local playerid = RUNNER.Obj_OF(projectileID);
                        local dmg1 = PLAYER_DAT.OBTAIN_STAT(playerid).M_ATK; local dmg2 = PLAYER_DAT.OBTAIN_STAT(playerid).P_ATK;
                        dealsDamageButNotHost(playerid,x,y,z,2,2,2,in2per(dmg1,120)+in2per(dmg2,80),DmgType.MELEE); 
                        -- playSoundEffect 
                        addEffect(x,y+0.6,z,1226,4);
                        playSoundOnPos(x,y,z,10641,100);
                        RUNNER.NEW(function(x,y,z)
                            cancelEffect(x,y+0.6,z,1226,1)
                        end,{x,y,z},50)
                    end) 
                end,{playerid,cx1,cx2,cy1,cy2,cz1,cz2,aimx,aimy,aimz},5)
                RUNNER.NEW(function(cx1,cy1,cz1,cx2,cy2,cz2,sEffect)
                    cancelEffect(cx1,cy1-1,cz1,sEffect);cancelEffect(cx2,cy2-1,cz2,sEffect);
                end,{cx1,cy1,cz1,cx2,cy2,cz2,sEffect},25)
            end,{playerid},i) end 
        end,{playerid},10)
    end
};
act.HighAndLow={CD=26,Cost=5,main = function(playerid)

    RUNNER.NEW(function(playerid)
        -- get obj on Radius 
        local x,y,z = getPos(playerid); local ax,ay,az = getAimPos(playerid);
        local anyObject = getObj_Area(playerid,ax,ay,az,12,12,12);
        --print(anyObject);
        local ObjPlayer = notObj(playerid,filterObj("Player",anyObject));
        --print("ObjPlayer",ObjPlayer);
        local ObjCreature = filterObj("Creature",anyObject);
        --print("ObjCreature",ObjCreature);
        local theObject = mergeTables(ObjPlayer,ObjCreature); 
        --print("The Object",theObject);
        for i,a in ipairs(theObject) do 
            RUNNER.NEW(function(playerid,a)
                -- Before doing this make sure that the target is alive
                local r , hp = Actor:getHP(a)
                if(r==0)then if(hp>0)then--r==0 means successfully get hp 
                local tx,ty,tz = getPos(a);
                local dirx,diry,dirz = getDir(playerid);
                Player:setPosition(playerid,tx-(dirx*5),ty+0.4,tz-(dirz*5));
                dealsDamageButNotHost(playerid,tx,ty,tz,1,1,1,in2per(PLAYER_DAT.OBTAIN_STAT(playerid).P_ATK,450));
                -- TODO add Sound Effect and Special Effect 
                Actor:playBodyEffectById(playerid, 1356, 5)
                playSoundOnPos(tx-dirx,ty+0.4,tz-dirz,10641,100,2.5)
                -- Reduce Cooldown from its own Skill by 2 seconds each target hits in radius 
                local r , tick = Actor:getBuffLeftTick(playerid,skill.cooldown[2]);
                if(r==0)then Actor:addBuff(playerid,skill.cooldown[2],1,math.max(1,tick-40)) end;
                end end
            end,{playerid,a},i*7)
        end RUNNER.NEW(function(playerid,ax,ay,az)
            Player:setPosition(playerid,ax,ay,az);
        end,{playerid,x,y,z},(#theObject*7)+5);
    end,{playerid},5);
end}

act.ExtraSlash={CD = 20, Cost = 10, main = function(playerid)
    local x,y,z = getPos(playerid); 
    local anyObject = getObj_Area(playerid,x,y,z,12,12,12);
    local ObjPlayer = notObj(playerid,filterObj("Player",anyObject));
    local ObjCreature = filterObj("Creature",anyObject);
    local theObject = mergeTables(ObjPlayer,ObjCreature); 
    for i,a in ipairs(theObject) do 
        for si = 2,20,2 do RUNNER.NEW(function(playerid,a)
            local r,hp = Actor:getHP(a);
            if(r==0)then if(hp>0)then
                local x,y,z = getPos(playerid);local tx,ty,tz = getPos(a);
                local dx,dy,dz = CalculateDirBetween2Pos({x=tx,y=ty,z=tz},{x=x,y=y,z=z});
                dash(a,dx,0,dz); 
                dealsDamageButNotHost(playerid,tx,ty,tz,1,1,1,in2per(PLAYER_DAT.OBTAIN_STAT(playerid).P_ATK,30)+in2per(PLAYER_DAT.OBTAIN_STAT(playerid).M_ATK,30),0);
            end end 
        end,{playerid,a},si)end 
        Actor:playBodyEffectById(playerid,1366,4);
        RUNNER.NEW(function(a)
            local r = Actor:isPlayer(a,playerid) ;
            if(r==0)then 
            Actor:addBuff(a,buffStuned,1,60);
            else 
            Actor:addBuff(a,buffStuned-1,1,60);
            end 
            local x,y,z = getPos(a);
            dealsDamageButNotHost(playerid,x,y,z,1,1,1,in2per(PLAYER_DAT.OBTAIN_STAT(playerid).P_ATK,120)+in2per(PLAYER_DAT.OBTAIN_STAT(playerid).M_ATK,120),0);
        end,{a,playerid},25);
    end 
    end
}

act.empty={
    CD=0.1,    Cost=0,    main=function(playerid)
    Player:openUIView(playerid,"7382967083985475826");          
    end
}


ScriptSupportEvent:registerEvent("Player.MotionStateChange",function(e)
	local playerid=e.eventobjid;
   	local x,y,z = getPos(playerid);
  	--Player:changeViewMode(playerid,1,false)
end)
