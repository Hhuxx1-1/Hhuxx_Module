GLOBAL_ANIMAL = {} -- Store function and Data for Animal Logic
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
    print("Max HR : "..maxHR, " CurHr : "..curHR);
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
            return print("position is not set");
        end 
        -- check if has table index modelID included inside animal 
        if not animal.modelID then 
            return print("modelID is not set");
        end 
        -- check if has name
        if not animal.name then
            return print("name is not set");
        end 

        -- if pass all above then start spawn  animal
        local r, obj = World:spawnCreature(animal.position.x,animal.position.y,animal.position.z,animal.modelID,1);
        if r == 0 then --check if success 
            -- store spawned animal
            -- check for its Attr 
            if type(animal.Attr) == "table" then 
                print(animal.Attr)
                for i,a in pairs(animal.Attr) do 
                    print(i,a);
                   local r = Creature:setAttr(obj[1], CREATUREATTR[i] , a);
                   if r == 0 then 
                        print(" Successfully setting Attribute ",CREATUREATTR[i],a)
                   else
                        print(" Failed setting Attribute ",CREATUREATTR[i],a)
                   end 
                end 
            end 

            table.insert(GLOBAL_ANIMAL.SPAWNED,{ids = obj[1],data = animal});

            return print("Animal Spawned",GLOBAL_ANIMAL.SPAWNED);
        else 
            print("Something is Wrong when trying to Spawn Creature : ",animal.ID,animal);
        end 
    else
        print("Unable to create animal : Animal is not Correct Data Type ")
    end 
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
            local result,graphid = Graphics:createGraphicsProgressByActor(ids, HPBar, {x=0,y=1.7,z=0}, 90+ScaleSize*100,30,0)
            -- Now Create Display Icon
            if e.second then 
                local HPIcon = Graphics:makeGraphicsImage([[8_1029380338_1727255972]], scale*2.5, color, 1);
                local HRIcon = Graphics:makeGraphicsImage([[8_1029380338_1728229367]], scale, color, 2);
                -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> There is Hidden Parameter here offset x , y
                local r , Graphdata1 = Graphics:createGraphicsImageByActor(ids,HRIcon, {x=0,y=1.3,z=0}, 90+(ScaleSize*100),-150,0);
                local r , Graphdata2 = Graphics:createGraphicsImageByActor(ids,HPIcon, {x=0,y=1.7,z=0}, 90+(ScaleSize*100),-150,10);

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
            end 
        else 
            -- print("Animal is not in Actor Table");
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
        {id = 378 , name = "Peach" , val = 50},
    },
    ["karnivora"] = {
        -- foods 
        {id = 12516 , name = "Meat" , val = 100},
        {id = 12530 , name = "Fat Meat Lamb" , val = 180},
        {id = 200422 , name = "Void Meat" , val = 300},
        {id = 12535 , name = "Biggest Meat" , val = 280},
        {id = 11659 , name = "Dried Fish" , val = 120}
    }
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
            print("Animal type : ",type)
            local idfood = {};
            type = string.lower(type);
            -- get player current holding item 
            local r , itemid = Player:getCurToolID(playerid);
            print("Item Holding is ",itemid);
            -- iterate the food based type 
            for i ,a in ipairs(GLOBAL_ANIMAL.ANIMAL_TYPE[type]) do 
                print("Checking ... ", i,a)
                if itemid == a.id then idfood = {id=a.id,val=a.val,n=a.name} break end 
            end 
            print("idfood is : ",idfood);
            if idfood.id == nil then 
                -- not holding correct food 
                print("not it's food");
                Player:notifyGameInfo2Self(playerid," Not It's Food ");
                return false 
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
                    GLOBAL_ANIMAL.FUNC.INCREASE_HUNGER(obj,idfood.val,maxhr)
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


    end 
end)

ScriptSupportEvent:registerEvent("Game.Start",function()

    local animal = GLOBAL_ANIMAL:New();
    -- set animal Data
        animal.position = {x=10,y=30,z=10};
        animal.modelID = 2 ;
        animal.name = "Gorrila";
        animal.Attr = {
            MAX_HP = 700,
            CUR_HP = 500,
            HP_RECOVER = 0,
            MAX_HUNGER = 200,
            CUR_HUNGER = 180,
        };
        animal.type = "Herbivora";
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(animal);

    local penguin_1 = GLOBAL_ANIMAL:New();
        penguin_1.position = {x=-26,y=29,z=-54};
        penguin_1.modelID = 3 ;
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
    -- Spawn the Animal 
        GLOBAL_ANIMAL:Create(penguin_3);
end)

