-- -- You Need to Create the Catalog 
-- -- Avoid using Auto for description because it is too long 
GLOBAL_SHOP:AddCatalogItem(
    378, "Arbor Fruit",
    [[A juicy, refreshing fruit. Restores 50 hunger.]],
    "AUTO", 5, 0);
GLOBAL_SHOP:AddCatalogItem(
    12601, "Peach Fruit",
    [[A sweet peach to satisfy mild hunger. Restores 40 hunger.]],
    "AUTO", 4, 0);
GLOBAL_SHOP:AddCatalogItem(
    12505, "Sliced Cucumber",
    [[Crisp and hydrating. Great for a quick hunger fix. Restores 120 hunger.]],
    "AUTO", 12, 0);
GLOBAL_SHOP:AddCatalogItem(
    241, "Sweet Potato",
    [[A hearty snack for when you're feeling a bit hungry. Restores 10 hunger.]],
    "AUTO", 1, 0);
GLOBAL_SHOP:AddCatalogItem(
    236, "Cucumber Fruit",
    [[A light, refreshing snack. Restores 10 hunger.]],
    "AUTO", 1, 0);
GLOBAL_SHOP:AddCatalogItem(
    12500, "Cherry Fruit",
    [[Small but satisfying. Restores 10 hunger.]],
    "AUTO", 1, 0);
GLOBAL_SHOP:AddCatalogItem(
    12515, "Giant Buru Stripe",
    [[A filling fruit for big hunger pangs. Restores 120 hunger.]],
    "AUTO", 12, 0);
GLOBAL_SHOP:AddCatalogItem(
    12508, "Scaly Slices",
    [[A savory slice snack. Restores 20 hunger.]],
    "AUTO", 2, 0);
GLOBAL_SHOP:AddCatalogItem(
    11600, "Good Banana",
    [[Delicious and satisfying. Restores 120 hunger.]],
    "AUTO", 12, 0);
GLOBAL_SHOP:AddCatalogItem(
    11599, "Banana",
    [[A classic treat to restore some energy. Restores 40 hunger.]],
    "AUTO", 4, 0);

-- For Protein-Rich Foods
GLOBAL_SHOP:AddCatalogItem(
    12516, "Meat",
    [[A hearty meat portion to fill you up. Restores 100 hunger.]],
    "AUTO", 10, 0);
GLOBAL_SHOP:AddCatalogItem(
    12530, "Fat Meat Lamb",
    [[Rich and filling. Great for strong hunger. Restores 180 hunger.]],
    "AUTO", 18, 0);
GLOBAL_SHOP:AddCatalogItem(
    11659, "Dried Fish",
    [[A savory fish treat. Restores 120 hunger.]],
    "AUTO", 12, 0);
GLOBAL_SHOP:AddCatalogItem(
    12535, "Deluxe Meat",
    [[Premium cut, extremely satisfying. Restores 280 hunger.]],
    "AUTO", 28, 0);
GLOBAL_SHOP:AddCatalogItem(
    200422, "Void Meat",
    [[A mysterious, energy-packed meat. Restores 300 hunger.]],
    "AUTO", 30, 0);

-- Catalog for Healing Items  
GLOBAL_SHOP:AddCatalogItem(
    12594, "First Aid Kit",
    [[A basic aid kit to restore 40 HP.]],
    "AUTO", 20, 0);
GLOBAL_SHOP:AddCatalogItem(
    12610, "Healing Flower",
    [[Natural remedy that restores 60 HP.]],
    "AUTO", 30, 0);
GLOBAL_SHOP:AddCatalogItem(
    12626, "Bandage", 
    [[Simple bandage, restores 20 HP.]],
    "AUTO", 20, 0);
GLOBAL_SHOP:AddCatalogItem(
    12606, "Hemostats",
    [[Stops bleeding and restores 80 HP.]], 
    "AUTO", 40, 0);


-- Catalog for Weapons Item
for weapon = 15013,15019 do 
    GLOBAL_SHOP:AddCatalogItem(
        weapon,"AUTO",
        [[A Fire Weapon, Infinite Magazine]],
        "AUTO",100,0);
end 
-- ID 1 Foods  
GLOBAL_SHOP:InitVSHOP(1,{
    {id = 378,      stock = 30}, --[[Arbor Fruit ]]
    {id = 12601,    stock = 40}, --[[Peach Fruit ]]
    {id = 241,      stock = 120}, --[[Sweet Potato]]
    {id = 12500,    stock = 210}, --[[Cherry Fruit]]
    {id = 236,      stock = 210}, -- [[Cucumber Fruit]]
    {id = 12505,    stock = 40}, --[[Sliced Cucumber]]
    {id = 12515,    stock = 120}, --[[Giant Buru Stripe]]
    {id = 12508,    stock = 210}, --[[Scaly Slices]]
    {id = 12505,    stock = 40}, --[[Sliced Cucumber]]
    {id = 12508,    stock = 210}, --[[Scaly Slices]]
    {id = 12601,    stock = 40}, --[[Peach Fruit ]]
    {id = 12500,    stock = 210}, --[[Cherry Fruit]]
    {id = 236,      stock = 210}, -- [[Cucumber Fruit]]
    {id = 11599,    stock = 210}, --[[Banana]]
    {id = 11600,    stock = 40}, --[[Good Banana]]
    {id = 241,      stock = 120}, --[[Sweet Potato]]
    {id = 12516,    stock = 20}, -- [[Meat]]
    {id = 11659,    stock = 20}, --[[Dried Fish]]
    {id = 12530,    stock = 10}, --[[Fat Meat Lamb]]
    {id = 12535,    stock = 20}, --[[Deluxe Meat]]
    {id = 12516,    stock = 20}, -- [[Meat]]
    {id = 11659,    stock = 20}, --[[Dried Fish]]
    {id = 12530,    stock = 10}, --[[Fat Meat Lamb]]
    {id = 12535,    stock = 20}, --[[Deluxe Meat]]
    {id = 200422,   stock = 5}, --[[Void Meat]]
    {id = 12594,    stock = 20},
    {id = 12610,    stock = 30},
    {id = 12626,    stock = 40},
    {id = 12606,    stock = 50}
});

GLOBAL_SHOP:AssignVSHOP(9,1,GLOBAL_SHOP.TYPE.Dynamic,0);

GLOBAL_SHOP:AddCatalogItems({
    {364,"Stone Button","Stone Button is Used to Open Door (It Requires Key Card to Register )","AUTO",2,0},
    {363,"Wooden Button","Wooden Button is Used to Spawn Car ","AUTO",2,0},
    {813,"Rope Ladder","I Sell Rope Ladder for Somereason","AUTO",2,0},
    {11654,"Pinnaple","Just Some Normla Pinnaple","AUTO",15,0},
})

GLOBAL_SHOP:InitVSHOP(3,{
    {id = 364, stock = 60 },
    {id = 363, stock = 20 },
    {id = 813, stock = 50 },
    {id = 11654, stock = 15 },
})
GLOBAL_SHOP:AssignVSHOP(12,3,GLOBAL_SHOP.TYPE.Dynamic,0);

GLOBAL_SHOP:AddCatalogItems({
    {4143,"Donut Pack"," Very Delicous Donuts ","AUTO",5,0},
});

GLOBAL_SHOP:InitVSHOP(4,{
    {id = 4143, stock = 15 },
    {id = 4143, stock = 14 },
    {id = 4143, stock = 13 },
    {id = 4143, stock = 12 },
})

GLOBAL_SHOP:AssignVSHOP(13,4,GLOBAL_SHOP.TYPE.Dynamic,0);

GLOBAL_SHOP:AddCatalogItems({
    {12284,"Simple Bazooka","This Need Ammo Bazooka","AUTO",1500,0},
    {12285,"Bazooka Rocket","Ammo for Simple Bazooka","AUTO",25,0},
    {12280,"Dynamite","Easiest Explosion (Can Be used to Destroy Bank Entrance)","AUTO",10,0},
    {11672,"Ice Mist","Throw to make Ice Smoke","AUTO",10,0},
})

GLOBAL_SHOP:InitVSHOP(5,{
    { id = 12284, stock = 100 },
    { id = 12285, stock = 100 },
    { id = 12280, stock = 100 },
    { id = 11672, stock = 100 }
})

 
GLOBAL_SHOP:AssignVSHOP(19,5,GLOBAL_SHOP.TYPE.Dynamic,0);