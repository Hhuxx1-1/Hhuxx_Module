-- Date Created : 2022-04-20
-- mini: 1029380338
-- Last Update : 2024-06-28
-- Hhuxx1 is Drunk , This is used to store Skill Action
-- REQUIRE Multirunner.lua framework
local tile = {	fireball = 15508,	Rain = 11670,	thunder = 11588 }
local soundEffect = { explosion = 10538 }
local second = 20;
local specialEffect = { explosion1 = 1311, danger = 1605,explosion2 = 1334,fire=1653 }

-- =====================================
-- ========== List of Function =========
-- =====================================

local function getPos(obj) 	local r,x,y,z = Actor:getPosition(obj);  	if(r) then return x,y,z end end
local function getAimPos(obj)	local r,x,y,z = Player:getAimPos(obj); 	if(r) then return x,y,z  end end
local function addEffect(x,y,z,effectid,scale)     World:playParticalEffect(x,y,z,effectid,scale); end 
local function cancelEffect(x,y,z,effectid,scale)     World:stopEffectOnPosition(x,y,z,effectid,scale); end
local function dealsDamage(playerid,x,y,z,dx,dy,dz,amount,dtype)     local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz});    Actor:playerHurtArea(playerid, areaid, amount, dtype);    Area:destroyArea(areaid); end
local function dealsDamageButNotHost(playerid,x,y,z,dx,dy,dz,amount,dtype) 
    local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz});    
    local r1,p = Area:getAreaPlayers(areaid);
    local r2,c = Area:getAreaCreatures(areaid);    
    for i,a in ipairs(p) do
        if a~=playerid then 
            Actor:playerHurt(playerid, a, amount, dtype);
        end 
    end 
    for i,a in ipairs(c) do 
        Actor:playerHurt(playerid, a, amount, dtype);
    end 
    Area:destroyArea(areaid);
end 
local function dealsDamageWithBuff(playerid,x,y,z,dx,dy,dz,amount,dtype,buffid,bufflv, customticks)
    dealsDamageButNotHost(playerid,x,y,z,dx,dy,dz,amount,dtype);
    local r,areaid = Area:createAreaRect({x=x,y=y,z=z},{x=dx,y=dy,z=dz});    local r1,p = Area:getAreaPlayers(areaid);
    local r2,c = Area:getAreaCreatures(areaid);    for i,a in ipairs(p) do
        if a~=playerid then 
            Actor:addBuff(a, buffid, bufflv, customticks)
        end 
    end 
    for i,a in ipairs(c) do 
        Actor:addBuff(a, buffid, bufflv, customticks)
    end 
    Area:destroyArea(areaid);
end 
local function dash(playerid,x,y,z) Actor:appendSpeed(playerid,x,y,z) end 
local function checkBlockisSolid(x,y,z) local r,b = Block:isSolidBlock(x, y, z) return b end 
local function addBlock(blockid,x,y,z)
    if(checkBlockisSolid(x,y,z)==false)then 
         Block:placeBlock(blockid,x,y,z);
    end 
end 
local function healsDamage(playerid,dmg) 
    local r,HP = Player:getAttr(playerid, 2)
    Player:setAttr(playerid, 2,HP+dmg)    
end 
local function getDir(playerid)
        local pX, pY, pZ = getPos(playerid)
        local dX, dY, dZ = getAimPos(playerid)
        
        local dirX,dirY,dirZ = dX - pX , dY - pY , dZ - pZ
        
        local magnitude = math.sqrt(dirX^2 + dirY^2 + dirZ^2)
        -- Normalize the direction vector
        return dirX / magnitude,dirY / magnitude,dirZ / magnitude
end 
local function addTemporaryBlockOnGround(x,y,z,blockid) 
    local rY = y;
    for i=y+5,y-15 do 
        rY=i;
        if(checkBlockisSolid(x,i-1,z))then 
           break;
        end 
    end 
    addBlock(blockid,x,rY,z);
end 
local function playSoundOnPos(x,y,z,whatsound,volume)     World:playSoundEffectOnPos({x=x,y=y,z=z}, whatsound, volume, 1, false) end 
-- list of local function

-- =========================================
-- ================ [ ACT ] ================
-- =========================================
-- act as holder for skill set with named index of the skill name without space and seperate the word with capital alphabet 
act={
    FireBall={
        CD		=	13,
		Cost	=	20,
        main 	= 	function(playerid) 
		   local x,y,z = getPos(playerid);
		   local dx,dy,dz = getAimPos(playerid);
		   local lavaball = 15508;
		   local maxi = 50;
		   for i=1,maxi do 
		        local r = math.min((maxi/2)-(i/2),maxi/5);
		        local cX,cY,cZ = dx+(math.random(-r,r)/2),y,dz+(math.random(-r,r)/2);
				

		        RUNNER.NEW(function(playerid,cX,cY,cZ)
		            addEffect(cX,cY,cZ,specialEffect.danger,2);
					--Add Effect Danger to Target Position					
		        end,							 {playerid,cX,cY,cZ},
				(math.fmod(i,5)/2));
		        
		        RUNNER.NEW(function(playerid,x,y,z,cX,cY,cZ)
    		        local re,projectileID = World:spawnProjectile(playerid,15508 , cX,cY+10,cZ, cX,cY,cZ , 60);
    		        Actor:changeCustomModel(projectileID, [[item_15519]]);
    		        Actor:playBodyEffectById(projectileID, 1003,1);
    		        Creature:setAttr(projectileID,21, 10);
					-- Summon Projectile with Custom Model and add Special Effect of Flame
    		    end,							 {playerid,x,y,z,cX,cY,cZ},
				(math.fmod(i,5)/2)*5);
		        
		        RUNNER.NEW(function(playerid,cX,cY,cZ)
		            cancelEffect(cX,cY,cZ,specialEffect.danger,1);
		            dealsDamage(playerid,cX,cY,cZ,1,1,1,30,3);
		            playSoundOnPos(cX,cY,cZ,soundEffect.explosion,100);
					--Clear Effect of Danger and deals damage to surrounding area by dimension of 1
		        end,							 {playerid,cX,cY,cZ},
				((math.fmod(i,5)/2)+2)*5);
		        
		        RUNNER.NEW(function(playerid,cX,cY,cZ)
		           addEffect(cX,cY,cZ,specialEffect.explosion1,2);
				   -- Create Explosion of Special Effect
		        end,							 {playerid,cX,cY,cZ},
				((math.fmod(i,5)/2)+2.5)*5);
		        
		        RUNNER.NEW(function(playerid,cX,cY,cZ)
		           cancelEffect(cX,cY,cZ,specialEffect.explosion1,2);
				   -- Clean Special Effect of the Explosion
		        end,							 {playerid,cX,cY,cZ},
				((math.fmod(i,10)/2)+4.5)*5);
		   end 
        end
    },
	FireBird={
		CD		=	9,
		Cost	=	10,
		main 	= 	function(playerid)
		   local lavaball = 15508;
		   local maxi = 10;
		   for i=1,maxi do 
		       local dX,dY,dZ = getAimPos(playerid);
		       dX,dY,dZ = dX+math.random(-3,3),dY+math.random(0,3),dZ+math.random(-3,3);
		       
		    	RUNNER.NEW(function(playerid,dX,dY,dZ)
					local re,projectileID = World:spawnProjectile(playerid,15508 , dX,dY,dZ, dX,dY+2,dZ, 10);
    		        Actor:changeCustomModel(projectileID, [[block_5]]);
    		        Creature:setAttr(projectileID,21, 10);
    		        Actor:playBodyEffectById(projectileID, 1018,1);
    		    end,							 {playerid,dX,dY,dZ},
				math.fmod(i,5)+2*5);
				
		    	RUNNER.NEW(function(playerid,dX,dY,dZ)
					dealsDamage(playerid,dX,dY,dZ,3,3,3,30,5);
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
		end
	},
	FireDash={
		CD		=	7,
		Cost	=	4,
		main 	= 	function(playerid)
            local x,y,z =getDir(playerid)
            -- Call the dash function with the normalized direction
            local power = 8;
            Player:setImmuneType(playerid,3,true);
            for i=0,power do 
                
                RUNNER.NEW(function(playerid,x,z)
                    local px,py,pz = getPos(playerid);
                    dash(playerid, x, 0, z);
                    Player:setImmuneType(playerid,3,true);
                    dealsDamage(playerid,px,py,pz,2,2,2,20,3);
                    addEffect(px,py,pz,specialEffect.fire,0.5)
                    healsDamage(playerid,20);
                    for ii=1,40,5 do 
                        RUNNER.NEW(function(playerid,px,py,pz)
                            dealsDamageButNotHost(playerid,px,py,pz,2,2,2,20,3);
                        end,{playerid,px,py,pz},10+ii);
                    end 
                	RUNNER.NEW(function(playerid,px,py,pz)
    					cancelEffect(px,py,pz,specialEffect.fire,1);
    				end,							 {playerid,px,py,pz},
    				40);
    				
                end,{playerid,x,z},i)
            end 
            
            RUNNER.NEW(function(playerid)
    		    Player:setImmuneType(playerid,3,false);
    		end,							 {playerid},
    		40+2*power);
        end

	},
    IceLance={
        CD=4,
		Cost=5,
        main = function(playerid) 
            for i=5,30,3 do 
                RUNNER.NEW(function(playerid) 
                
                    local x,y,z = getPos(playerid);
            		local dx,dy,dz = getAimPos(playerid);    
                    local dirx,diry,dirz = getDir(playerid)
                    local re,projectileID = World:spawnProjectile(playerid,15507 , x+(dirx*1.5),y+(diry*1.5),z+(dirz*1.5), dx+(math.random(-2,2)/2),dy+0.5,dz+(math.random(-2,2)/2), 240);
                    local re,projectileID = World:spawnProjectile(playerid,15507 , x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5), dx+(math.random(-2,2)/2),dy+1.5,dz+(math.random(-2,2)/2), 260);
                    local re,projectileID = World:spawnProjectile(playerid,15507 , x+(dirx*1.5),y+(diry*1.5),z+(dirz*1.5), dx,dy+0.5,dz, 280);
                    local re,projectileID = World:spawnProjectile(playerid,15507 , x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5), dx,dy+1.5,dz, 200);
    		        Actor:changeCustomModel(projectileID,[[block_32]] );
    		        playSoundOnPos(x+(dirx*2.5),y+(diry*1.5),z+(dirz*2.5),10536,100)
    		        Creature:setAttr(projectileID,21, 10);
                end,{playerid},i)
            end 
        end
    },
    IceBreath={
        CD=8, 
        Cost=5,
        main = function(playerid)
            for i=2,18,2 do 
                RUNNER.NEW(function(playerid)
                    local x,y,z=getPos(playerid);
                    local dirx,diry,dirz = getDir(playerid);
                    local cx,cy,cz = x+(dirx*i),y+(diry*i),z+(dirz*i);
                    addEffect(cx,cy,cz,1233,2);
                    for ii=1,3 do 
                        RUNNER.NEW(function(playerid,cx,cy,cz)
                        dealsDamageButNotHost(playerid,cx,cy,cz,2,2,2,10,4);
                        end,{playerid,cx,cy,cz},ii*2);
                    end 
                    RUNNER.NEW(function(playerid,cx,cy,cz)
                        dealsDamageWithBuff(playerid,cx,cy,cz,2,2,2,50,4,1050,5, 40);
                    end,{playerid,cx,cy,cz},4*2);
                    RUNNER.NEW(function(cx,cy,cz)
                        cancelEffect(cx,cy,cz,1233);    
                    end,{cx,cy,cz},40);
                    
                end,{playerid},i)
            end 
        end 
    },
IceGlacier={
    CD=60,
    Cost=20,
    main=function(playerid)
       RUNNER.NEW(function(playerid)
           Actor:addBuff(playerid,2010,1,260);
           Actor:addBuff(playerid,50000009,1,60);
       end,{playerid},1); 
       
    end
},
    ThunderStorm={
        CD=16,
		Cost=10,
        main = function(playerid)
            for i=5,10,5 do 
                RUNNER.NEW(function(playerid)
                    local x,y,z = getPos(playerid);
                    local ax,ay,az = getAimPos(playerid);
                    addEffect(ax,y,az,1620,3);
                    playSoundOnPos(ax,y,az,10660,200);
                    dealsDamageButNotHost(playerid,ax,y,az,5,5,5,i*25,4);
                    RUNNER.NEW(function(ax,y,z)
                         cancelEffect(ax,y,az,1620);
                    end,{ax,y,z},20);
                    
                end,{playerid},i)
            end
        end
    },
    ThunderDash={
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
                                    World:spawnProjectile(playerid, tile.thunder, tx, ty, tz, tx, ty+1, tz, 20);    
                                end 
                            end 
                            for i,a in ipairs(c) do 
                                local tx,ty,tz = getPos(a);
                                World:spawnProjectile(playerid, tile.thunder, tx, ty, tz, tx, ty+1, tz, 20);
                            end 
                            Area:destroyArea(areaid);
							
                end,{playerid},i)
            
            end 
            
        end 
    },
    ThunderBuff={
        CD=20,
        Cost=1,
        main=function(playerid)
            for i=1,10 do 
                RUNNER.NEW(function(playerid) 
                    local x,y,z = getPos(playerid);
                    local r,mana = Player:getAttr(playerid,PLAYERATTR.CUR_HUNGER)
                    Player:setAttr(playerid,PLAYERATTR.CUR_HUNGER,mana+10);
                    Actor:playBodyEffectById(playerid,1308,2);
                    playSoundOnPos(x,y,z,10175,100);
                    Actor:removeBuff(playerid, skill.cooldown[1+math.fmod(i,2)]);
                end,{playerid},i*second);
            end 
        end 
    },
	PowerUp={
		CD=80,
		Cost=20,
		main=function(playerid)
			local ammountPowerUp = 600;
			local dur = 10;
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
					playSoundOnPos(x,y,z,10966,100);
					Actor:removeBuff(playerid, skill.cooldown[2]);
				end,{playerid},i*second)
					
				
			end 
			
				RUNNER.NEW(function(playerid,InitMaxHealth) 
				
					Player:setAttr(playerid,1,InitMaxHealth);
					
				end,{playerid,InitMaxHealth},(dur+10)*second)
		end
	},
	PowerDash={
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
    					local x,y,z=getPos(playerid);
    					Actor:setActionAttrState(playerid, 1, false)
    					dealsDamageButNotHost(playerid,x,y,z,5,5,5,350,1);
    					addEffect(x,y,z,1700,2);
    					playSoundOnPos(x,y,z,10110,300);
    					RUNNER.NEW(function(playerid) Actor:setActionAttrState(playerid, 1, true) end,{playerid},5)
    					RUNNER.NEW(function(x,y,z)
    						cancelEffect(x,y,z,specialEffect.explosion2);	
    					end,{x,y,z},30);
    				end,{playerid},3);
    			else
    			    --Chat:sendSystemMsg("Not In Air");
    				local x,y,z=getPos(playerid);
    				Actor:setActionAttrState(playerid, 1, false)
    				dealsDamageButNotHost(playerid,x,y,z,5,5,5,250,1);
    				addEffect(x,y,z,1700,2);
    				playSoundOnPos(x,y,z,10110,300);
    				RUNNER.NEW(function(playerid) Actor:setActionAttrState(playerid, 1, true) end,{playerid},5)
    				RUNNER.NEW(function(x,y,z)
    					cancelEffect(x,y,z,specialEffect.explosion2);	
    				end,{x,y,z},30);
    			end
			end,{playerid},18)

		end
	},PowerPunch={
		CD=6,
		Cost=4,
		main=function(playerid)
			RUNNER.NEW(function(playerid)
				local x,y,z = getPos(playerid);
				local dx,dy,dz = getDir(playerid);
				local sEffect = 1182;
				local soEffect = 10110;
				local cx,cy,cz = x+(dx*2.5),y+(dy*2.5),z+(dz*2.5)
				dealsDamageButNotHost(playerid,cx,cy,cz,2,2,2,250,1);
				addEffect(cx,cy,cz,sEffect,2);
				playSoundOnPos(cx,cy,cz,soEffect,200);
				
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
				end,{cx,cy,cz},20)
				
			end,{playerid},5)
		end 
	},
    empty={
        CD=0.1,
        Cost=0,
        main=function(playerid)
        Player:openUIView(playerid,"7382967083985475826");          
        end
    }
}


ScriptSupportEvent:registerEvent("Player.MotionStateChange",function(e)
	local playerid=e.eventobjid;
   	local x,y,z = getPos(playerid);
  	--Player:changeViewMode(playerid,1,false)
end)
