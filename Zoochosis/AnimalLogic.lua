GLOBAL_ANIMAL = {} -- Store function and Data for Animal Logic
    -- I spent so many time on this but wyclover keep saying the map is bad, bruh 
    -- i try my best to make the appearnece appealing and looks fun as much as possible 
    -- while keeping the script reusable for later map 
GLOBAL_ANIMAL.DATA = {}
function GLOBAL_ANIMAL:New() 
    table.insert(GLOBAL_ANIMAL.DATA,{ID=#GLOBAL_ANIMAL.DATA+1,modelID = nil , Stats = {HP = 1 , HR = 1 , CL = 1}});
    return GLOBAL_ANIMAL.DATA[#GLOBAL_ANIMAL.DATA];
end 

GLOBAL_ANIMAL.SPAWNED = {} -- Store Spawned Animal Obj Here to Be Checked Later

GLOBAL_ANIMAL.FUNC ={}

GLOBAL_ANIMAL.FUNC.DMG_ANIMAL = function(ids,dmg)
    local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
    if curHP >= 1 then 
        Actor:actorHurt(ids,ids, dmg, 0);
        -- create floating text to indicate ammount of HP loss 
        local floatext=Graphics:makeflotageText("#R ♥ -"..dmg, 35, 5);
        local x,y,z = MYTOOL.GET_POS(ids);
        local x2,y2=math.random(-5,5)*10,120;
        local result,graphid=Graphics:createflotageTextByPos(x, y+1, z, floatext, x2, y2)
    end
end

GLOBAL_ANIMAL.FUNC.REGEN = function(ids,val)
    local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
    local r,maxHP = Creature:getAttr(ids, CREATUREATTR.MAX_HP);
    if curHP >= 1 and curHP < maxHP then 
        local r,curHR = Creature:getAttr(ids, CREATUREATTR.CUR_HUNGER);
        if curHR >= 0 then 
            local err     = Creature:setAttr(ids, CREATUREATTR.CUR_HUNGER , curHR - 2);
            if err == 0 then 
                if curHP > maxHP then 
                    Creature:setAttr(ids,CREATUREATTR.CUR_HP,maxHP)    
                else 
                    Creature:setAttr(ids,CREATUREATTR.CUR_HP,curHP+val)
                end 
                -- create floating text to indicate ammount of HP loss 
                local floatext=Graphics:makeflotageText("#G ♥ +"..val, 35, 6);
                local x,y,z = MYTOOL.GET_POS(ids);
                local x2,y2=math.random(-5,5)*10,120;
                local result,graphid=Graphics:createflotageTextByPos(x, y+1, z, floatext, x2, y2)
            end 
        end
    end
end

GLOBAL_ANIMAL.FUNC.INCREASE_HUNGER = function(ids,val,maxhr)
    local r,curHR = Creature:getAttr(ids, CREATUREATTR.CUR_HUNGER);
    local maxHR = maxhr;
    --print("Max HR : "..maxHR, " CurHr : "..curHR);
    if curHR <= maxHR then 
        Creature:setAttr(ids,CREATUREATTR.CUR_HUNGER,math.min(curHR+val,maxHR));
        -- create floating text to indicate ammount of HP loss 
        local floatext=Graphics:makeflotageText("#cffa500 +"..val, 35, 6);
        local x,y,z = MYTOOL.GET_POS(ids);
        local x2,y2=math.random(-5,5)*10,120;
        local result,graphid=Graphics:createflotageTextByPos(x, y+1, z, floatext, x2, y2)

        local r,NowcurHR = Creature:getAttr(ids, CREATUREATTR.CUR_HUNGER);
        if NowcurHR == maxHR then 
            Creature:setAttr(ids,CREATUREATTR.CUR_HUNGER,maxHR + 20);
        end 
    end
end

function GLOBAL_ANIMAL:Create(animal) 
    -- check if animal is table 
    if type(animal) == "table" then
        -- check if has table index position included inside animal 
        if not animal.position then 
            return --print("position is not set");
        end 
        -- check if has table index modelID included inside animal 
        if not animal.modelID then 
            return --print("modelID is not set");
        end 
        -- check if has name
        if not animal.name then
            return --print("name is not set");
        end 

        -- if pass all above then start spawn  animal
        local r, obj = World:spawnCreature(animal.position.x,animal.position.y,animal.position.z,animal.modelID,1);
        
        
        if r == 0 then --check if success 
            -- store spawned animal
            -- set Cannot Die (prevent the Animal for Dissappearing)
            local ret = Actor:setActionAttrState(obj[1],128,false);
            if ret == 0 then end 
            -- check for its Attr 
            if type(animal.Attr) == "table" then 
                --print(animal.Attr)
                for i,a in pairs(animal.Attr) do 
                    --print(i,a);
                   local r = Creature:setAttr(obj[1], CREATUREATTR[i] , a);
                   if r == 0 then 
                        --print(" Successfully setting Attribute ",CREATUREATTR[i],a)
                   else
                        --print(" Failed setting Attribute ",CREATUREATTR[i],a)
                   end 
                end 
            end 

            table.insert(GLOBAL_ANIMAL.SPAWNED,{ids = obj[1],data = animal});

            return --print("Animal Spawned",GLOBAL_ANIMAL.SPAWNED);
        else 
            --print("Something is Wrong when trying to Spawn Creature : ",animal.ID,animal);
        end 
    else
        --print("Unable to create animal : Animal is not Correct Data Type ")
    end 
end 

local function showText(objid,title)
	local font=26;	local alpha=30;	local itype=1;
	local graphicsInfo=Graphics:makeGraphicsText("#G  "..title.."#W#W#W#W#W#W" , font, alpha, itype)
	local dir={x=0,y=10,z=0}
	local offset=26
	local x2,y2=0,120
	local result,graphid=Graphics:createGraphicsTxtByActor(objid, graphicsInfo, dir, offset, x2, y2)
end

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    -- Only grab Spawned Animal
    for i,a in ipairs(GLOBAL_ANIMAL.SPAWNED) do 
        local ids = a.ids;
        local data = a.data;
        local MAX_HP,MAX_HUNGER = data.Attr.MAX_HP,data.Attr.MAX_HUNGER;
        -- get Current Attr Using API 
        local r,curHP = Creature:getAttr(ids, CREATUREATTR.CUR_HP);
        local r,curHR = Creature:getAttr(ids, CREATUREATTR.CUR_HUNGER);
        if curHP ~= nil then 
            local isnight = World:isDaytime();

            if (curHP <= 1 or data.mutated) and isnight == 1001 then 
                local actorid = data.mutantID;
                -- get its current actorid of ids 
                local r,actorIDs = Creature:getActorID(ids)
                if actorid ~= nil then 
                    -- only replace when it not same 
                    if actorid ~= actorIDs then 
                        local r = Creature:setTeam(ids, 6);
                        local ret = Actor:setActionAttrState(ids,128,true);
                        if r == 0 and ret == 0 then 
                            local r = Creature:replaceActor(ids, actorid ,data.Attr.MAX_HP*10);
                            GLOBAL_ANIMAL.SPAWNED[i].data.mutated = true;
                            Chat:sendSystemMsg("#RWARNING an ANIMAL HAS BEEN INFECTED!");
                        end 
                    end 
                    -- clear graphic created on animal 
                    local r = Graphics:removeGraphicsByObjID(ids , 1 ,1);
                    local r = Graphics:removeGraphicsByObjID(ids , 3 ,3);
                    local r = Graphics:removeGraphicsByObjID(ids , 4 ,3);
                    local r = Graphics:removeGraphicsByObjID(ids , 1 ,10);
                    local r = Graphics:removeGraphicsByObjID(ids , 2 ,10);
                    --print("Animal Died, Replaced with New Actor");
                else 
                    print("mutantID is Not SET!!!");
                end 
            else 
                -- if animal is still alive 
                -- Chat:sendSystemMsg(" HP : "..curHP.."  Hunger : "..curHR.."");
                local scale = 0.15; local Alpha = 100;local color = 0xffffff;
                local r,ScaleSize = Creature:getAttr(ids,CREATUREATTR.DIMENSION);
                if r == 0 then 
                    --local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(ids); -- value is not being used
                    -- graphic Bar 
                    local HPBar=Graphics:makeGraphicsProgress(curHP, MAX_HP, 0xff1212, 3 , 0.5);
                    local HRBar=Graphics:makeGraphicsProgress(curHR, MAX_HUNGER, 0xffa500, 4, 0.5);
                    -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> There is Hidden Parameter here offset x , y
                    local result,graphid = Graphics:createGraphicsProgressByActor(ids, HRBar, {x=0,y=1.3,z=0}, 90+ScaleSize*100,30,0)
                    local result,graphid = Graphics:createGraphicsProgressByActor(ids, HPBar, {x=0,y=1.7,z=0}, 80+ScaleSize*100,30,0)
                    -- Now Create Display Icon
                    if e.second then 
                        local HPIcon = Graphics:makeGraphicsImage([[8_1029380338_1727255972]], scale*2.5, color, 1);
                        local HRIcon = Graphics:makeGraphicsImage([[8_1029380338_1728229367]], scale, color, 2);
                        -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> There is Hidden Parameter here offset x , y
                        local r , Graphdata1 = Graphics:createGraphicsImageByActor(ids,HRIcon, {x=0,y=1.3,z=0}, 90+(ScaleSize*100),-150,0);
                        local r , Graphdata2 = Graphics:createGraphicsImageByActor(ids,HPIcon, {x=0,y=1.7,z=0}, 80+(ScaleSize*100),-150,10);

                        -- check for hunger and make it damage self 
                        if curHR <= 0 then 
                            GLOBAL_ANIMAL.FUNC.DMG_ANIMAL(ids,math.random(9,12));
                        elseif curHR <= 10 then 
                            GLOBAL_ANIMAL.FUNC.DMG_ANIMAL(ids,2);
                        elseif curHR > MAX_HUNGER/2 then 
                            -- check the data regen value 
                            local regenval = data.Attr.HP_RECOVER;
                            if regenval > 0 then 
                                GLOBAL_ANIMAL.FUNC.REGEN(ids,regenval);
                            end 
                        else 
                            
                        end 
                        -- show nickname 
                        showText(ids,data.nick);
                    end 
                else 
                    --print("Animal is not in Render : ",data);
                    -- or it is died 
                    -- animal wasnt supposed to be despawned
                end 
            end 
        end 
    end 
    -- Update to All Client;
    Graphics:snycGraphicsInfo2Client();
end)

GLOBAL_ANIMAL.ANIMAL_TYPE = {
    ["herbivora"] = {
        -- foods 
        {id = 11599 , name = "Banana" , val = 40},
        {id = 11600 , name = "Perfect Banana" , val = 120},
        {id = 12508 , name = "Scaly Slices" , val = 20},
        {id = 12500 , name = "Cherry" , val = 10},
        {id = 236   , name = "Cucumber" , val = 5},
        {id = 241   , name = "Sweet Potato" , val = 5},
        {id = 12515 , name = "Giant Buru Stripe" , val = 120},
        {id = 12505 , name = "Sliced Cucumber" , val = 120},
        {id = 12601 , name = "Peach" , val = 40},
        {id = 378 , name = "Arbor" , val = 50},
    },
    ["carnivora"] = {
        -- foods 
        {id = 12516 , name = "Meat" , val = 100},
        {id = 12530 , name = "Fat Meat Lamb" , val = 180},
        {id = 200422 , name = "Void Meat" , val = 300},
        {id = 12535 , name = "Deluxe Meat" , val = 280},
        {id = 11659 , name = "Dried Fish" , val = 120}
    }
}

local healing_items = { 
    {id = 12594, name = "First Aid-Kit",    val = 40},
    {id = 12610, name = "Healing Flower",   val = 60},
    {id = 12626, name = "Bandage",          val = 20},
    {id = 12606, name = "Hemostats",        val = 80},
}

function GLOBAL_ANIMAL.FUNC.TRYFEED(playerid,obj)
    -- check if obj is exist on spawned animal 
    for i ,a in ipairs(GLOBAL_ANIMAL.SPAWNED) do 
        local ids = a.ids;
        if obj == ids then 
            -- Try Feed the Object 
            -- check type of obj food 
            local data = a.data;
            local type = data.type;
            --print("Animal type : ",type)
            local idfood = {};
            type = string.lower(type);
            -- get player current holding item 
            local r , itemid = Player:getCurToolID(playerid);
            --print("Item Holding is ",itemid);
            -- iterate the food based type 
            for i ,a in ipairs(GLOBAL_ANIMAL.ANIMAL_TYPE[type]) do 
                --print("Checking ... ", i,a)
                if itemid == a.id then idfood = {id=a.id,val=a.val,n=a.name} break end 
            end 
            --print("idfood is : ",idfood);
            if idfood.id == nil then 
                -- not holding correct food 
                --print("not it's food");
                -- check is it healing item ? 
                for i ,a in ipairs(healing_items) do 
                    --print("Checking ... ", i,a)
                    if itemid == a.id then idfood = {id=a.id,val=a.val,n=a.name} break end 
                end 
                if idfood.id == nil then 
                    Player:notifyGameInfo2Self(playerid," Not It's Food ");
                    return false 
                else 
                    -- it is healing item 
                    local r = Player:removeBackpackItem(playerid,idfood.id,1);
                    if r == 0 then 
                        GLOBAL_ANIMAL.FUNC.REGEN(obj,idfood.val);
                        -- add paycheck to player 
                        GLOBAL_PAYCHECK(playerid,"Add",math.floor(idfood.val/5))
                        return true;
                    end 
                end 
            else 
                -- remove player item 
                local r = Player:removeBackpackItem(playerid,idfood.id,1);
                if r == 0 then 
                    local maxhr = data.Attr.MAX_HUNGER;
                    -- check if has favorite 
                    local fav = data.favorite;
                    if fav then 
                        if  idfood.n == fav then 
                            idfood.val = idfood.val * 2;
                        end
                    end 
                    -- increase Hunger for animal 
                    MYTOOL.playSoundOnActor(obj,10654,100,1);
                    GLOBAL_ANIMAL.FUNC.INCREASE_HUNGER(obj,idfood.val,maxhr);
                    -- add Paycheck to player 
                    GLOBAL_PAYCHECK(playerid,"Add",math.floor(idfood.val/5));
                    return true ;
                end 
            end 
        end 
    end 
    -- Not Feedable Object 
    return false 
end 

ScriptSupportEvent:registerEvent("Player.ClickActor",function(e)
    local playerid = e.eventobjid; 
    local targetid = e.toobjid;
    if GLOBAL_ANIMAL.FUNC.TRYFEED(playerid,targetid) then 
        -- do something such as drop coins/poop
        GLOBAL_PAYCHECK(playerid,"Add",1);
    end 
end)

ScriptSupportEvent:registerEvent("Game.Start",function()

    --[[
    player bullet dmg is around 30-110 
    so player can kill the animal mutated animal arround it's 10x original health  
    ]]
    local gorrila_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    gorrila_1.position = {x=12,y=31,z=-65};
    gorrila_1.modelID = 2 ;
    gorrila_1.name = "Gorrila";
    gorrila_1.Attr = {
            MAX_HP = 700,
            CUR_HP = 500,
            HP_RECOVER = 1,
            MAX_HUNGER = 290,
            CUR_HUNGER = 180,
        };
    gorrila_1.type = "Herbivora";
    gorrila_1.favorite = "Perfect Banana";
    gorrila_1.nick = "Pepper";
    gorrila_1.mutantID = 15;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(gorrila_1);


    local gorrila_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    gorrila_2.position = {x=16,y=31,z=-79};
    gorrila_2.modelID = 2 ;
    gorrila_2.name = "Gorrila";
    gorrila_2.Attr = {
            MAX_HP = 700,
            CUR_HP = 500,
            HP_RECOVER = 1,
            MAX_HUNGER = 290,
            CUR_HUNGER = 200,
        };
    gorrila_2.type = "Herbivora";
    gorrila_2.favorite = "Perfect Banana";
    gorrila_2.nick = "Thor";
    gorrila_2.mutantID = 15;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(gorrila_2);
    
    local gorrila_3 = GLOBAL_ANIMAL:New();
    -- set animal Data
    gorrila_3.position = {x=30,y=29,z=-94};
    gorrila_3.modelID = 2 ;
    gorrila_3.name = "Gorrila";
    gorrila_3.Attr = {
            MAX_HP = 700,
            CUR_HP = 500,
            HP_RECOVER = 1,
            MAX_HUNGER = 290,
            CUR_HUNGER = 290,
        };
    gorrila_3.type = "Herbivora";
    gorrila_3.favorite = "Perfect Banana";
    gorrila_3.nick = "Chief";
    gorrila_3.mutantID = 15;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(gorrila_3);

    local gorrila_4 = GLOBAL_ANIMAL:New();
    -- set animal Data
    gorrila_4.position = {x=20,y=29,z=-85};
    gorrila_4.modelID = 2 ;
    gorrila_4.name = "Gorrila";
    gorrila_4.Attr = {
            MAX_HP = 700,
            CUR_HP = 500,
            HP_RECOVER = 1,
            MAX_HUNGER = 250,
            CUR_HUNGER = 160,
        };
    gorrila_4.type = "Herbivora";
    gorrila_4.favorite = "Perfect Banana";
    gorrila_4.nick = "Dexter";
    gorrila_4.mutantID = 15;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(gorrila_4);

    local penguin_1 = GLOBAL_ANIMAL:New();
        penguin_1.position = {x=-26,y=29,z=-54};
        penguin_1.modelID = 3 ;
        penguin_1.mutantID = 4;
        penguin_1.name = "Penguin";
        penguin_1.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 420,
        };
        penguin_1.type = "Carnivora";
        penguin_1.favorite = "Dried Fish";
        penguin_1.nick = "Daisy";
        penguin_1.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_1);

        local penguin_2 = GLOBAL_ANIMAL:New();
        penguin_2.position = {x=-24,y=29,z=-65};
        penguin_2.modelID = 3 ;
        penguin_2.name = "Penguin";
        penguin_2.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 420,
        };
        penguin_2.type = "Carnivora";
        penguin_2.favorite = "Dried Fish";
        penguin_2.nick = "Luna";
        penguin_2.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_2);
        
        local penguin_3 = GLOBAL_ANIMAL:New();
        penguin_3.position = {x=-33,y=29,z=-82};
        penguin_3.modelID = 3 ;
        penguin_3.name = "Penguin";
        penguin_3.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 220,
        };
        penguin_3.type = "Carnivora";
        penguin_3.favorite = "Dried Fish";
        penguin_3.nick = "Coco";
        penguin_3.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_3);
        
        local penguin_4 = GLOBAL_ANIMAL:New();
        penguin_4.position = {x=-45,y=29,z=-57};
        penguin_4.modelID = 3 ;
        penguin_4.name = "Penguin";
        penguin_4.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 450,
        };
        penguin_4.type = "Carnivora";
        penguin_4.favorite = "Dried Fish";
        penguin_4.nick = "Tinker";
        penguin_4.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_4);

        local penguin_5 = GLOBAL_ANIMAL:New();
        penguin_5.position = {x=-21,y=29,z=-93};
        penguin_5.modelID = 3 ;
        penguin_5.name = "Penguin";
        penguin_5.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 430,
        };
        penguin_5.type = "Carnivora";
        penguin_5.favorite = "Dried Fish";
        penguin_5.nick = "Misty";
        penguin_5.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_5);

        local penguin_6 = GLOBAL_ANIMAL:New();
        penguin_6.position = {x=-44,y=32,z=-65};
        penguin_6.modelID = 3 ;
        penguin_6.name = "Penguin";
        penguin_6.Attr = {
            MAX_HP = 500,
            CUR_HP = 300,
            HP_RECOVER = 5,
            MAX_HUNGER = 450,
            CUR_HUNGER = 410,
        };
        penguin_6.type = "Carnivora";
        penguin_6.favorite = "Dried Fish";
        penguin_6.nick = "Rocky";
        penguin_6.mutantID = 17;
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_6);

    local girrafe_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    girrafe_1.position = {x=-36,y=29,z=6};
    girrafe_1.modelID = 5 ;
    girrafe_1.name = "Girrafe";
    girrafe_1.Attr = {
            MAX_HP = 450,
            CUR_HP = 400,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 560,
        };
    girrafe_1.type = "Herbivora";
    girrafe_1.favorite = "Giant Buru Stripe";
    girrafe_1.nick = "Beau";
    girrafe_1.mutantID = 18;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(girrafe_1);

    local girrafe_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    girrafe_2.position = {x=-20,y=29,z=5};
    girrafe_2.modelID = 5 ;
    girrafe_2.name = "Girrafe";
    girrafe_2.Attr = {
            MAX_HP = 450,
            CUR_HP = 400,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 560,
        };
    girrafe_2.type = "Herbivora";
    girrafe_2.favorite = "Giant Buru Stripe";
    girrafe_2.nick = "Poe";
    girrafe_2.mutantID = 18;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(girrafe_2);

    local girrafe_3 = GLOBAL_ANIMAL:New();
    -- set animal Data
    girrafe_3.position = {x=-27,y=29,z=-18};
    girrafe_3.modelID = 5 ;
    girrafe_3.name = "Girrafe";
    girrafe_3.Attr = {
            MAX_HP = 450,
            CUR_HP = 400,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 560,
        };
    girrafe_3.type = "Herbivora";
    girrafe_3.favorite = "Giant Buru Stripe";
    girrafe_3.nick = "Cleo";
    girrafe_3.mutantID = 18;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(girrafe_3);

    
    local wallaby_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    wallaby_1.position = {x=19,y=30,z=-21};
    wallaby_1.modelID = 4 ;
    wallaby_1.name = "wallaby";
    wallaby_1.Attr = {
            MAX_HP = 450,
            CUR_HP = 300,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 560,
        };
    wallaby_1.type = "Herbivora";
    wallaby_1.favorite = "Giant Buru Stripe";
    wallaby_1.nick = "Penny";
    wallaby_1.mutantID = 16;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(wallaby_1);

    local wallaby_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    wallaby_2.position = {x=18,y=29,z=-7};
    wallaby_2.modelID = 4 ;
    wallaby_2.name = "wallaby";
    wallaby_2.Attr = {
            MAX_HP = 450,
            CUR_HP = 260,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 360,
        };
    wallaby_2.type = "Herbivora";
    wallaby_2.favorite = "Giant Buru Stripe";
    wallaby_2.nick = "Sally";
    wallaby_2.mutantID = 16;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(wallaby_2);

    local wallaby_3 = GLOBAL_ANIMAL:New();
    -- set animal Data
    wallaby_3.position = {x=21,y=30,z=18};
    wallaby_3.modelID = 4 ;
    wallaby_3.name = "wallaby";
    wallaby_3.Attr = {
            MAX_HP = 450,
            CUR_HP = 200,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 660,
        };
    wallaby_3.type = "Herbivora";
    wallaby_3.favorite = "Giant Buru Stripe";
    wallaby_3.nick = "Amy";
    wallaby_3.mutantID = 16;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(wallaby_3);

    local wallaby_4 = GLOBAL_ANIMAL:New();
    -- set animal Data
    wallaby_4.position = {x=19,y=30,z=18};
    wallaby_4.modelID = 4 ;
    wallaby_4.name = "wallaby";
    wallaby_4.Attr = {
            MAX_HP = 450,
            CUR_HP = 200,
            HP_RECOVER = 1,
            MAX_HUNGER = 650,
            CUR_HUNGER = 460,
        };
    wallaby_4.type = "Herbivora";
    wallaby_4.favorite = "Giant Buru Stripe";
    wallaby_4.nick = "Wally";
    wallaby_4.mutantID = 16;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(wallaby_4);

    local zebra_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_1.position = {x=86,y=29,z=17};
    zebra_1.modelID = 6 ;
    zebra_1.name = "Zebra";
    zebra_1.Attr = {
            MAX_HP = 450,
            CUR_HP = 360,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 360,
        };
    zebra_1.type = "Herbivora"
    zebra_1.favorite = "Sliced Cucumber";
    zebra_1.nick = "Pixel";
    zebra_1.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_1);

    local zebra_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_2.position = {x=84,y=29,z=48};
    zebra_2.modelID = 6 ;
    zebra_2.name = "Zebra";
    zebra_2.Attr = {
            MAX_HP = 450,
            CUR_HP = 360,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 360,
        };
    zebra_2.type = "Herbivora"
    zebra_2.favorite = "Sliced Cucumber";
    zebra_2.nick = "Inky";
    zebra_2.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_2);

    local zebra_3 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_3.position = {x=85,y=29,z=35};
    zebra_3.modelID = 6 ;
    zebra_3.name = "Zebra";
    zebra_3.Attr = {
            MAX_HP = 450,
            CUR_HP = 360,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 400,
        };
    zebra_3.type = "Herbivora"
    zebra_3.favorite = "Sliced Cucumber";
    zebra_3.nick = "Tux";
    zebra_3.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_3);

    local zebra_4 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_4.position = {x=98,y=29,z=47};
    zebra_4.modelID = 6 ;
    zebra_4.name = "Zebra";
    zebra_4.Attr = {
            MAX_HP = 450,
            CUR_HP = 400,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 390,
        };
    zebra_4.type = "Herbivora"
    zebra_4.favorite = "Sliced Cucumber";
    zebra_4.nick = "Splotch";
    zebra_4.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_4);

    local zebra_5 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_5.position = {x=97,y=29,z=37};
    zebra_5.modelID = 6 ;
    zebra_5.name = "Zebra";
    zebra_5.Attr = {
            MAX_HP = 450,
            CUR_HP = 400,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 360,
        };
    zebra_5.type = "Herbivora"
    zebra_5.favorite = "Sliced Cucumber";
    zebra_5.nick = "Zee";
    zebra_5.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_5);

    local zebra_6 = GLOBAL_ANIMAL:New();
    -- set animal Data
    zebra_6.position = {x=95,y=29,z=27};
    zebra_6.modelID = 6 ;
    zebra_6.name = "Zebra";
    zebra_6.Attr = {
            MAX_HP = 450,
            CUR_HP = 360,
            HP_RECOVER = 1,
            MAX_HUNGER = 450,
            CUR_HUNGER = 450,
        };
    zebra_6.type = "Herbivora"
    zebra_6.favorite = "Sliced Cucumber";
    zebra_6.nick = "Wira";
    zebra_6.mutantID = 19;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(zebra_6);

    local crocodile_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    crocodile_1.position = {x=-93,y=26,z=-101};
    crocodile_1.modelID = 7 ;
    crocodile_1.name = "Crocodile";
    crocodile_1.Attr = {
            MAX_HP = 850,
            CUR_HP = 200,
            HP_RECOVER = 1,
            MAX_HUNGER = 850,
            CUR_HUNGER = 660,
        };
    crocodile_1.type = "Carnivora"
    crocodile_1.favorite = "Meat";
    crocodile_1.nick = "Croaky";
    crocodile_1.mutantID = 20;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(crocodile_1);

    local crocodile_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    crocodile_2.position = {x=-97,y=29,z=-122};
    crocodile_2.modelID = 7 ;
    crocodile_2.name = "Crocodile";
    crocodile_2.Attr = {
            MAX_HP = 850,
            CUR_HP = 200,
            HP_RECOVER = 1,
            MAX_HUNGER = 850,
            CUR_HUNGER = 360,
        };
    crocodile_2.type = "Carnivora"
    crocodile_2.favorite = "Meat";
    crocodile_2.nick = "Sleepiny";
    crocodile_2.mutantID = 20;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(crocodile_2);


    local hippo_1 = GLOBAL_ANIMAL:New();
    -- set animal Data
    hippo_1.position = {x=99,y=28,z=-119};
    hippo_1.modelID = 8 ;
    hippo_1.name = "Hippo";
    hippo_1.Attr = {
            MAX_HP = 990,
            CUR_HP = 600,
            HP_RECOVER = 1,
            MAX_HUNGER = 900,
            CUR_HUNGER = 760,
        };
    hippo_1.type = "Carnivora"
    hippo_1.favorite = "Fat Meat Lamb";
    hippo_1.nick = "Zoe";
    hippo_1.mutantID = 14;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(hippo_1);

    local hippo_2 = GLOBAL_ANIMAL:New();
    -- set animal Data
    hippo_2.position = {x=95,y=29,z=-98};
    hippo_2.modelID = 8 ;
    hippo_2.name = "Hippo";
    hippo_2.Attr = {
            MAX_HP = 990,
            CUR_HP = 800,
            HP_RECOVER = 1,
            MAX_HUNGER = 900,
            CUR_HUNGER = 860,
        };
    hippo_2.type = "Carnivora"
    hippo_2.favorite = "Fat Meat Lamb";
    hippo_2.nick = "Bubba";
    hippo_2.mutantID = 14;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(hippo_2);

    local hippo_3 = GLOBAL_ANIMAL:New();
    -- set animal Data
    hippo_3.position = {x=87,y=28,z=-115};
    hippo_3.modelID = 8 ;
    hippo_3.name = "Hippo";
    hippo_3.Attr = {
            MAX_HP = 990,
            CUR_HP = 800,
            HP_RECOVER = 1,
            MAX_HUNGER = 900,
            CUR_HUNGER = 800,
        };
    hippo_3.type = "Carnivora"
    hippo_3.favorite = "Fat Meat Lamb";
    hippo_3.nick = "Waffle";
    hippo_3.mutantID = 14;
    -- Spawn the Animal 
    GLOBAL_ANIMAL:Create(hippo_3);
end)

--[[
#GHow to Feed Animal
Click On Them While Holding Their Food! 
(Right Click on PC)
]]