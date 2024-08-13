
BOSS.INIT(14,"Level 1 Boss")

BOSS.ADD_ACTION(14,function(id)
    -- Set The Model Size 
    Creature:setAttr(id,21, 2)
    -- Show message 
    --Chat:sendSystemMsg("#WHello World")
    -- Set Attribute of Max HP and Current HP 
    Creature:setAttr(id,1, 5000) -- 1 = Max Hp 
    Creature:setAttr(id,2, 5000) -- 2 = Cur HP 
end,BOSS.HOOK_Type.OnSpawn);

BOSS.ADD_ACTION(14,function(id)
    local x,y,z = MYTOOL.GET_POS(id)
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    ey = math.max(ey,1);
    local r = math.random(-1,1);
    for offset = 2 ,38, 4 do 
        local cx,cy,cz = x+((r*2)+ex*offset),y+ey,z+((r*2)+ez*offset);
        RUNNER.NEW(function(cx,cy,cz)
            MYTOOL.ADD_EFFECT(cx,cy-1,cz,1604,3);
        end,{cx,cy,cz},2)
        RUNNER.NEW(function(id,cx,cy,cz)
            MYTOOL.ADD_EFFECT(cx,cy,cz,1350,1);
            MYTOOL.playSoundOnPos(cx,cy,cz,10632,50)
            BOSS.TOOL.ATTACk(id,{x=cx,y=cy,z=cz},{x=1,y=1,z=1},{dmg=145,type=0});
            MYTOOL.DEL_EFFECT(cx,cy-1,cz,1604,1);
        end,{id,cx,cy,cz},15+(offset/4))
    end 
end,BOSS.HOOK_Type.OnAttack)

BOSS.ADD_ACTION(14,function(id)
    local x,y,z = MYTOOL.GET_POS(id)
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    --local r = (math.random(0, 1) * 2) - 1;
    local r = math.random(1,3)
    local ofs=2;
    if r  == 1 then 
    Actor:appendSpeed(id,-ez*ofs,0.3,ex*ofs);
    else 
    Actor:appendSpeed(id,ez*ofs,0.3,-ex*ofs);
    end 
end)

BOSS.ADD_ACTION(14,function(id)
    local x,y,z = MYTOOL.GET_POS(id)

    local OBJ = MYTOOL.getObj_Area(x,y,z,10,10,10); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 
    -- check long from playerOBJ table is 0 
    if #playerObj == 0 then
        -- if no one is nearby  
        -- find player on larger area 
        OBJ = MYTOOL.getObj_Area(x,y,z,64,28,64);
        playerObj = MYTOOL.filterObj("Player",OBJ);
        -- if someone is nearby 
        if #playerObj > 0 then
            for i,a in pairs(playerObj) do 
                local xx,yy,zz = MYTOOL.GET_POS(a)
                Actor:tryMoveToPos(id, xx, yy, zz, 1)
            end 
        else 
            return --[[End]]
        end 
    end 

    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    ey = math.max(ey,1);
    for r = -2 , 2 do 
    for offset = 2 ,36,4 do 
        local cx,cy,cz = x+((r*2)+ex*offset),y+ey,z+((r*2)+ez*offset);
        RUNNER.NEW(function(cx,cy,cz)
            MYTOOL.ADD_EFFECT(cx,cy-1,cz,1604,3);
        end,{cx,cy,cz},2)
        RUNNER.NEW(function(id,cx,cy,cz)
            MYTOOL.ADD_EFFECT(cx,cy,cz,1350,2);
            MYTOOL.playSoundOnPos(cx,cy,cz,10632,50)
            BOSS.TOOL.ATTACk(id,{x=cx,y=cy,z=cz},{x=1,y=1,z=1},{dmg=145,type=0});
            MYTOOL.DEL_EFFECT(cx,cy-1,cz,1604,1);
            RUNNER.NEW(function(cx,cy,cz)
                MYTOOL.DEL_EFFECT(cx,cy,cz,1350);
            end,{cx,cy,cz},25);
        end,{id,cx,cy,cz},15+(offset/4))
    end 
    end 
end)

BOSS.ADD_ACTION(14,function(id)
    BOSS.NONHOOKCD_RESET[id]=2;
    --Chat:sendSystemMsg("CD Reduced to 0"..BOSS.NONHOOKCD_RESET[id]);
    BOSS.addNonHook(id,function(id)
       -- print(id , "added new hook");
        local x,y,z = MYTOOL.GET_POS(id);
        local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id)
        local osf = 5;
        if math.random(1,2) == 1 then 
        World:spawnCreature(x+(osf*ez),y,z+(osf*ex),15,1); 
        World:spawnCreature(x-(osf*ez),y,z+(osf*ex),15,1); 
        else 
        World:spawnCreature(x+(osf*ez),y,z-(osf*ex),15,1); 
        World:spawnCreature(x-(osf*ez),y,z-(osf*ex),15,1); 
        end 
    end)
    BOSS.addNonHook(id,function(id)
        local x,y,z = MYTOOL.GET_POS(id)
        local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
        --local r = (math.random(0, 1) * 2) - 1;
        local r = math.random(1,3)
        local ofs=2;
        for i=5,30,15 do 
        RUNNER.NEW(function()
        if r  == 1 then 
        Actor:appendSpeed(id,-ez*ofs,0.1,ex*ofs);
        else 
        Actor:appendSpeed(id,ez*ofs,0.1,-ex*ofs);
        end 
        end,{},i) 
        end 
    end)
end,BOSS.HOOK_Type.OnHpLow)

BOSS.ADD_ACTION(14,function(id)
    -- half the cooldown 
    BOSS.NONHOOKCD[id] = math.floor(BOSS.NONHOOKCD[id]/2);
    -- check every player object in area less than of 18 block
    local x,y,z = MYTOOL.GET_POS(id)
    local OBJ = MYTOOL.getObj_Area(x,y,z,10,10,10); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 
    -- check long from playerOBJ table is 0 
    if #playerObj == 0 then
        --Chat:sendSystemMsg("No one is near")
        -- if no one is nearby  
        -- find player on larger area 
        OBJ = MYTOOL.getObj_Area(x,y,z,64,28,64);
        playerObj = MYTOOL.filterObj("Player",OBJ);
        -- if someone is nearby 
        if #playerObj > 0 then
            --Chat:sendSystemMsg("someone in away")
            for i,a in pairs(playerObj) do 
                local xx,yy,zz = MYTOOL.GET_POS(a)
                Actor:tryMoveToPos(id, xx, yy, zz, 1)
            end 
        else 
            --Chat:sendSystemMsg("No one is Anywhere")
        end 
    end 
end,BOSS.HOOK_Type.OnDamaged)


BOSS.INIT(13,"Ice Magician Thundra")

BOSS.ADD_ACTION(13,function(id)
        -- Set The Model Size 
        Creature:setAttr(id,21, 2)
        -- Show message 
        -- Chat:sendSystemMsg("#WHello World")
        -- Set Attribute of Max HP and Current HP 
        Creature:setAttr(id,1, 20000) -- 1 = Max Hp 
        Creature:setAttr(id,2, 20000) -- 2 = Cur HP 
        MOD_APPEARENCE = false;
end,BOSS.HOOK_Type.OnSpawn)

BOSS.ADD_ACTION(13,function(id)
    MOD_APPEARENCE = true;

end,BOSS.HOOK_Type.OnDefeat)

BOSS.ADD_ACTION(13,function(id)
    -- Chat:sendSystemMsg("Attacking")
    local pre = {mist=11672,frigirdOrb=11670,IceSpike=11671}
    local x,y,z = MYTOOL.GET_POS(id); 
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    local OBJ = MYTOOL.getObj_Area(x,y,z,35,25,35); 
    local playerObj = MYTOOL.filterObj("Player",OBJ); 
    local ratk = math.random(1,6);
    if ratk==1 then 
        for i , a in ipairs(playerObj)do 
            for ds = 10,30,10 do 
            RUNNER.NEW(function(id,ds,a,pre)
                local xx,yy,zz = MYTOOL.GET_POS(a)
                local projectile = MYTOOL.SHOOT_PROJECTILE(id,pre.frigirdOrb,{x=xx,y=yy+10,z=zz},{x=xx,y=yy,z=zz},120);
            end,{id,ds,a,pre},ds)
            end 
        end 
    elseif (ratk==2) then 
        for i , a in ipairs(playerObj)do
            -- calculate direction between boss and player 
            local px,py,pz = MYTOOL.GET_POS(a);
            local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=x,y=y,z=z},{x=px,y=py,z=pz})
            -- shoot projectile to each players
            for ofs = 2,32 , 3 do 
            local cx,cy,cz = x+(dx*ofs),y+(dy*ofs),z+(dz*ofs);
            RUNNER.NEW(function(cx,cy,cz)
                -- Create Warning effect 
                MYTOOL.ADD_EFFECT(cx,cy-1,cz,1604,3);
            end,{cx,cy,cz,id},2)
            RUNNER.NEW(function(cx,cy,cz,id,pre)
                local projectile = MYTOOL.SHOOT_PROJECTILE(id,pre.mist,{x=cx,y=cy+2,z=cz},{x=cx,y=cy,z=cz},220);
                BOSS.TOOL.ATTACk(id,{x=cx,y=cy,z=cz},{x=2,y=2,z=2},{dmg=110,type=1});
                MYTOOL.DEL_EFFECT(cx,cy-1,cz,1604);
            end,{cx,cy,cz,id,pre},15+(ofs/3))
            end 
        end 
    else 
        for i , a in ipairs(playerObj)do
            -- calculate direction between boss and player 
            local px,py,pz = MYTOOL.GET_POS(a);
            local dx,dy,dz = MYTOOL.CalculateDirBetween2Pos({x=x,y=y,z=z},{x=px,y=py,z=pz})
            -- shoot projectile to each players
            for ofs = 2,32 , 3 do 
            local cx,cy,cz = x+(dx*ofs),y+(dy*ofs),z+(dz*ofs);
            RUNNER.NEW(function(cx,cy,cz)
                -- Create Warning effect 
                MYTOOL.ADD_EFFECT(cx,cy-1,cz,1604,2);
            end,{cx,cy,cz,id},1)
            RUNNER.NEW(function(cx,cy,cz,id,pre,x,y,z)
                local projectile = MYTOOL.SHOOT_PROJECTILE(id,pre.IceSpike,{x=x,y=y+6,z=z},{x=cx,y=cy,z=cz},220);
                RUNNER.Obj_REGISTER(projectile,id);
                RUNNER.ATTACH_Func_Obj(projectile,function(projectile,e)
                    -- owner of projectile
                    local ownerID =  RUNNER.Obj_OF(projectile);
                    local x,y,z = e.x,e.y,e.z;
                    BOSS.TOOL.ATTACk(ownerID,{x=x,y=y,z=z},{x=1,y=1,z=1},{dmg=75,type=7});
                end)
                MYTOOL.DEL_EFFECT(cx,cy-1,cz,1604);
            end,{cx,cy,cz,id,pre,x,y,z},3+(ofs/3))
            end 
        end 

    end 
end,BOSS.HOOK_Type.OnAttack);

BOSS.ADD_ACTION(13,function(id)
    --print("Non hook called")
    local pre = {mist=11672,frigirdOrb=11670,IceSpike=11671}
    -- Check if there is player nearby 
    local x,y,z = MYTOOL.GET_POS(id);
    local OBJ = MYTOOL.getObj_Area(x,y,z,32,28,32)
    local playerObj = MYTOOL.filterObj("Player",OBJ);
    -- if someone is nearby
    if #playerObj > 0 then
        -- fly self 
        MYTOOL.dash(id,0,2,0);
        RUNNER.NEW(function(id)
            Actor:setActionAttrState(id, 1, false)
        end,{id},5);
        -- shoot projectile
        for i,a in ipairs(playerObj)do 
            RUNNER.NEW(function(id,a,pre)
                local x,y,z = MYTOOL.GET_POS(id);
                local xx,yy,zz = MYTOOL.GET_POS(a);
                local projectile = MYTOOL.SHOOT_PROJECTILE(id,pre.mist,{x=x,y=y,z=z},{x=xx,y=yy,z=zz},100);
            end,{id,a,pre},10)
        end 
        RUNNER.NEW(function(id)
            Actor:setActionAttrState(id, 1, true)
        end,{id},20);
    end 
end)

BOSS.ADD_ACTION(13,function()
    BOSS.addNonHook(id,function(id)
        --print(id , "added new hook");
        local x,y,z = MYTOOL.GET_POS(id);
        local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id)
        local osf = 5;
        if math.random(1,2) == 1 then 
        World:spawnCreature(x+(osf*ez),y,z+(osf*ex),3915,1); 
        World:spawnCreature(x-(osf*ez),y,z+(osf*ex),3915,1); 
        else 
        World:spawnCreature(x+(osf*ez),y,z-(osf*ex),3135,1); 
        World:spawnCreature(x-(osf*ez),y,z-(osf*ex),3135,1); 
        end 
    end)
end,BOSS.HOOK_Type.OnHpLow)
-- BOSS.INIT(7, "Iron Golem")
-- BOSS.ADD_ACTION(7, function() print("Iron Golem Spawned") end, BOSS.HOOK_Type.OnSpawn)
-- BOSS.ADD_ACTION(7, function() print("Iron Golem Attacking") end, BOSS.HOOK_Type.OnAttack)
-- BOSS.ADD_ACTION(7, function() print("Iron Golem Defeated") end, BOSS.HOOK_Type.OnDefeat)
-- BOSS.ADD_ACTION(7, function() print("Iron Golem Low Hp") end, BOSS.HOOK_Type.OnHpLow)