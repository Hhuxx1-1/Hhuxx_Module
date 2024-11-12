
-- GLOBAL_LEVER.REGISTER(-141,22,47,814,function()
--     Chat:sendSystemMsg("Hello Door")
--     local r , isActive = Block:getBlockSwitchStatus({x=-141,y=22,z=47});
--     print(" Door is :",r,isActive)
--     -- local r = Block:setBlockSwitchStatus({x=-141,y=22,z=47}, not isActive);
--     -- local r = Block:setBlockSwitchStatus({x=-141,y=21,z=47}, not isActive);
--     if not isActive then 
--         OpenDoor(-141,21,47)
--    end 
-- end)

-- GLOBAL_LEVER.REGISTER(-140,22,46,GLOBAL_LEVER.TYPE.Stone_Button,
-- function(e)
--     local playerid = e.playerid;
--     Chat:sendSystemMsg("Hello From a Button to "..playerid);
--     OpenSideDoor(-140,21,46);
-- end,{})

GLOBAL_LEVER.REGISTER(-146,22,55,GLOBAL_LEVER.TYPE.Lever,function(e)
    local x,y,z = -146,27,60
    local r = Block:isAirBlock(x,y,z);
    if r == 0 then 
        Block:setBlockAll(x,y,z,415);
    else 
        Block:destroyBlock(x,y,z,false);
    end 
end)

local function openPrisonCell(d)
    local jeruji = 2001;
    local x1,x2,y1,y2,z1,z2 = d.x1,d.x2,d.y1,d.y2,d.z1,d.z2;
    local f = d.f;
    -- check first Block 
    local r = Block:isAirBlock(x1,y1,z1);
    if r == 0 then --[[it is air block]]
        for x = x1,x2 do for y = y1,y2 do for z = z1,z2 do 
            -- Block:placeBlock(2001,x,y,z,f,f)
            Block:setBlockAll(x,y,z,jeruji,f)
        end end end 
    else 
        for x = x1,x2 do for y = y1,y2 do for z = z1,z2 do 
            Block:destroyBlock(x,y,z,false);
        end end end 
    end 
end

--[[Prison Cell Button 1]]
GLOBAL_LEVER.REGISTER(15,22,10,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
            x1=16 , x2=16 ,
            y1=21 , y2=25 ,
            z1=12 , z2=18 , f = 1
        });
    end 
end)

GLOBAL_LEVER.REGISTER(15,22,-1,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=21 , y2=25 ,
        z1=1 , z2=7 , f = 1
       });
    end 
end)

GLOBAL_LEVER.REGISTER(15,22,-12,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=21 , y2=25 ,
        z1=-10 , z2=-4 , f = 1
       });
    end 
end)

GLOBAL_LEVER.REGISTER(15,22,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e) 
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
            x1=16 , x2=16 ,
            y1=21 , y2=25 ,
            z1=-21 , z2=-15 , f = 1
        });
    end 
end)

GLOBAL_LEVER.REGISTER(15,31,10,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=30 , y2=34 ,
        z1=12 , z2=18 , f = 1
       });
    end 
end)

GLOBAL_LEVER.REGISTER(15,31,-1,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=30 , y2=34 ,
        z1=1 , z2=7 , f = 1
       });
    end 
end)

GLOBAL_LEVER.REGISTER(15,31,-12,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=30 , y2=34 ,
        z1=-10 , z2=-4 , f = 1
       });
    end 
end)

GLOBAL_LEVER.REGISTER(15,31,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=16 , x2=16 ,
        y1=30 , y2=34 ,
        z1=-21 , z2=-15 , f = 1
       });
    end 
end)

-- Right Side 

GLOBAL_LEVER.REGISTER(-16,22,20,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=21 , y2=25 ,
        z1=12 , z2=18 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,22,9,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=21 , y2=25 ,
        z1=1 , z2=7 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,22,-2,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=21 , y2=25 ,
        z1=-10 , z2=-4 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,22,-13,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=21 , y2=25 ,
        z1=-21 , z2=-15 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,31,20,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=30 , y2=34 ,
        z1=12 , z2=18 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,31,9,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=30 , y2=34 ,
        z1=1 , z2=7 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,31,-2,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=30 , y2=34 ,
        z1=-10 , z2=-4 , f = 0
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-16,31,-13,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-17 , x2=-17 ,
        y1=30 , y2=34 ,
        z1=-21 , z2=-15 , f = 0
       });
    end 
end)

-- Middle Part 
GLOBAL_LEVER.REGISTER(-16,31,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-14 , x2=-8 ,
        y1=30 , y2=34 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-5,31,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-3 , x2=3 ,
        y1=30 , y2=34 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)

GLOBAL_LEVER.REGISTER(6,31,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=8 , x2=14 ,
        y1=30 , y2=34 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)

-- middle bawah 

GLOBAL_LEVER.REGISTER(-16,22,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-15 , x2=-9 ,
        y1=21 , y2=25 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)

GLOBAL_LEVER.REGISTER(-6,22,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=-4 , x2=2 ,
        y1=21 , y2=25 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)

GLOBAL_LEVER.REGISTER(5,22,-23,GLOBAL_LEVER.TYPE.Stone_Button,function(e)
    if IF_HAS_ACCESS_CARD(e.playerid) then  
        openPrisonCell({
        x1=7 , x2=13 ,
        y1=21 , y2=25 ,
        z1=-24 , z2=-24 , f = 2
       });
    end 
end)