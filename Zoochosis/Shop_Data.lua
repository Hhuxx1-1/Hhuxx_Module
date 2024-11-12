 
-- -- You Need to Create the Catalog 
-- -- Avoid using Auto for description becuz it is too long 
GLOBAL_SHOP:AddCatalogItem(
    378,"Arbor Fruit",
    [[Can be Used to Feed Herbivora Animals, Give 50 Food]],
    "AUTO",5,0);
GLOBAL_SHOP:AddCatalogItem(
    12601,"Peach Fruit",
    [[Can be Used to Feed Herbivora Animals, Give 40 Food]],
    "AUTO",4,0);
GLOBAL_SHOP:AddCatalogItem(
    12505,"Sliced Cucumber",
    [[Can be Used to Feed Herbivora Animals, Give 120 Food]],
    "AUTO",12,0);
GLOBAL_SHOP:AddCatalogItem(
    241,"Sweet Potato",
    [[Can be Used to Feed Herbivora Animals, Give 10 Food]],
    "AUTO",1,0);
GLOBAL_SHOP:AddCatalogItem(
    236,"Cucumber Fruit",
    [[Can be Used to Feed Herbivora Animals, Give 10 Food]],
    "AUTO",1,0)
GLOBAL_SHOP:AddCatalogItem(
    12500,"Cherry Fruit",
    [[Can be Used to Feed Herbivora Animals, Give 10 Food]],
    "AUTO",1,0)
GLOBAL_SHOP:AddCatalogItem(
    12515,"Giant Buru Stripe",
    [[Can be Used to Feed Herbivora Animals, Give 120 Food]],
    "AUTO",12,0);
GLOBAL_SHOP:AddCatalogItem(
    12508,"Scaly Slices",
    [[Can be Used to Feed Herbivora Animals, Give 20 Food]],
    "AUTO",2,0);
GLOBAL_SHOP:AddCatalogItem(
    11600,"Good Banana",
    [[Can be Used to Feed Herbivora Animals, Give 120 Food. (Gorrila Loves This Food)]],
    "AUTO",12,0);
GLOBAL_SHOP:AddCatalogItem(
    11599,"Banana",
    [[Can be Used to Feed Herbivora Animals, Give 40 Food.]],
    "AUTO",4,0);

-- Carnivora 
GLOBAL_SHOP:AddCatalogItem(
    12516,"Meat",
    [[Can be Used to Feed Carnivora Animals, Give 100 Food]],
    "AUTO",10,0);
GLOBAL_SHOP:AddCatalogItem(
    12530,"Fat Meat Lamb",
    [[Can be Used to Feed Carnivora Animals, Give 180 Food]],
    "AUTO",18,0);
GLOBAL_SHOP:AddCatalogItem(
    11659,"Dried Fish",
    [[Can be Used to Feed Carnivora Animals, Give 120 Food. (Penguin Love This Food)]],
    "AUTO",12,0);
GLOBAL_SHOP:AddCatalogItem(
    12535,"Deluxe Meat",
    [[Can be Used to Feed Carnivora Animals, Give 280 Food]],
    "AUTO",28,0);
GLOBAL_SHOP:AddCatalogItem(
    200422,"Void Meat",
    [[Can be Used to Feed Carnivora Animals, Give 300 Food]],
    "AUTO",30,0);

--Catalog for Medicine Item  
GLOBAL_SHOP:AddCatalogItem(
    12594,"First Aid-Kit",
    [[Can be Used to Cure Animal, Give 40 HP]],
    "AUTO",20,0);
GLOBAL_SHOP:AddCatalogItem(
    12610,"Healing Flower",
    [[Can be Used to Cure Animal, Give 60 HP]],
    "AUTO",30,0);
GLOBAL_SHOP:AddCatalogItem(
    12626,"Bandage", 
    [[Can be Used to Cure Animal, Give 20 HP]],
    "AUTO",20,0);
GLOBAL_SHOP:AddCatalogItem(
    12606,"Hemostats",
    [[Can be Used to Cure Animal, Give 80 HP]], 
    "AUTO",40,0);

-- Catalog for Weapons Item
for weapon = 15013,15019 do 
    GLOBAL_SHOP:AddCatalogItem(
        weapon,"AUTO",
        [[A Fire Weapon, Infinite Magazine]],
        "AUTO",100,0);
end 
-- ID 1 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(1,{
    {id = 378, stock = 30}, --[[Arbor Fruit ]]
    {id = 12601, stock = 40}, --[[Peach Fruit ]]
    {id = 241, stock = 120}, --[[Sweet Potato]]
    {id = 12500, stock = 210}, --[[Cherry Fruit]]
});
-- ID 2 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(2,{
    {id = 236, stock = 210}, -- [[Cucumber Fruit]]
    {id = 12505, stock = 40}, --[[Sliced Cucumber]]
    {id = 12515, stock = 120}, --[[Giant Buru Stripe]]
    {id = 12508, stock = 210}, --[[Scaly Slices]]
});
-- ID 3 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(3,{
    {id = 12505, stock = 40}, --[[Sliced Cucumber]]
    {id = 12508, stock = 210}, --[[Scaly Slices]]
    {id = 12601, stock = 40}, --[[Peach Fruit ]]
    {id = 12500, stock = 210}, --[[Cherry Fruit]]
});
-- ID 4 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(4,{
    {id = 236, stock = 210}, -- [[Cucumber Fruit]]
    {id = 11599, stock = 210}, --[[Banana]]
    {id = 11600, stock = 40}, --[[Good Banana]]
    {id = 241, stock = 120}, --[[Sweet Potato]]
});
-- ID 5 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(5,{
    {id = 12516, stock = 20}, -- [[Meat]]
    {id = 11659, stock = 20}, --[[Dried Fish]]
    {id = 12530, stock = 10}, --[[Fat Meat Lamb]]
    {id = 12535, stock = 20}, --[[Deluxe Meat]]
});
-- ID 6 Shoplist to be Attached to NPC
GLOBAL_SHOP:InitiateShopList(6,{
    {id = 12516, stock = 20}, -- [[Meat]]
    {id = 11659, stock = 20}, --[[Dried Fish]]
    {id = 12530, stock = 10}, --[[Fat Meat Lamb]]
    {id = 12535, stock = 20}, --[[Deluxe Meat]]
    {id = 200422, stock = 5}, --[[Void Meat]]
});

-- ID 7 Shoplist to Attached to NPC 
GLOBAL_SHOP:InitiateShopList(7,{
    {id = 12594, stock = 20},
    {id = 12610, stock = 30},
    {id = 12626, stock = 40},
    {id = 12606, stock = 50},
});

GLOBAL_SHOP:InitiateShopList(8,{
    {id = 15013, stock =  2},
    {id = 15014, stock =  2},
    {id = 15015, stock =  2},
    {id = 15016, stock =  2},
    {id = 15017, stock =  2},
    {id = 15018, stock =  2},
    {id = 15019, stock =  2}
});
-- Creating NPC should be When Game.Start 
-- not Before Game Start 
-- This to Avoid bug
ScriptSupportEvent:registerEvent("Game.Start",function(e) 
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-6},
        3217,
        {shopid = 1,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-18},
        3206,
        {shopid = 2,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );        
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-30},
        3216,
        {shopid = 3,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );    
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-42},
        3207,
        {shopid = 4,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );    
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-54},
        3217,
        {shopid = 5,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );           
    GLOBAL_SHOP:CreateNPCShop(
        {x=-119,y=29,z=-66},
        3206,
        {shopid = 6,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );           
    GLOBAL_SHOP:CreateNPCShop(
        {x=-87,y=29,z=-19},
        13,
        {shopid = 7,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );
    GLOBAL_SHOP:CreateNPCShop(
        {x=-82,y=29,z=-19},
        13,
        {shopid = 7,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );
    GLOBAL_SHOP:CreateNPCShop(
        {x=-77,y=29,z=-19},
        13,
        {shopid = 7,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    );
    GLOBAL_SHOP:CreateNPCShop(
        {x=84,y=30,z=-58},
        21,
        {shopid = 8,typeShop = GLOBAL_SHOP.TYPE.Dynamic}
    )
end)
