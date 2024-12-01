GLOBAL_SHOP:AddCatalogItems({
    {12502,"Noodle","You Need to Eat and Keep your Stamina Well","AUTO",10,0},
    {12550,"Noodle with Egg","This Noodle is Delicious and Blessed","AUTO",25,0},
    {12573,"Juicy Buble","Makes you want to jump high","AUTO",15,0},
    {12594,"Medkit","Use Medkit when you got injured","AUTO",30,0},
})

GLOBAL_SHOP:InitVSHOP(0,{
    { id = 12502, stock = 100 },
    { id = 12550, stock = 100 },
    { id = 12573, stock = 100 },
    { id = 12594, stock = 100 }
})


GLOBAL_SHOP:AssignVSHOP(57,0,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(7,0,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(8,0,GLOBAL_SHOP.TYPE.Dynamic,0);

GLOBAL_SHOP:AddCatalogItems({
    {11013,"Iron Pickaxe","Nice Mining Tool to Collect Some Crystal Ores","AUTO",50,0},
    {11014,"Titanium Pickaxe","Best Mining Tool to Collect Ores","AUTO",150,0},
    {11015,"Diamond Drill","Found Hard Ores? Use This!","AUTO",500,0},
    {11016,"Stone Golem Piercer","I Don't See Them near here.... But this Drill can Pierce Stone Golem","AUTO",3000,0},
})

GLOBAL_SHOP:InitVSHOP(1,{
    { id = 11013, stock = 100 },
    { id = 11014, stock = 50 },
    { id = 11015, stock = 10 },
    { id = 11016, stock = 1 }
})


GLOBAL_SHOP:AssignVSHOP(40,1,GLOBAL_SHOP.TYPE.Dynamic,0);


GLOBAL_SHOP:AddCatalogItems({
    {4184,"AUTO","AUTO","AUTO",5,0},
    {4185,"AUTO","AUTO","AUTO",5,0},
    {4186,"AUTO","AUTO","AUTO",5,0},
    {4187,"AUTO","AUTO","AUTO",10,0},
    {4189,"AUTO","AUTO","AUTO",20,0},
    {4190,"AUTO","AUTO","AUTO",30,0},
})

GLOBAL_SHOP:InitVSHOP(8,{
    {id = 4184, stock = 150},
    {id = 4185, stock = 150},
    {id = 4186, stock = 150},
    {id = 4187, stock = 100},
    {id = 4189, stock = 200},
    {id = 4190, stock = 300},
})


GLOBAL_SHOP:AssignVSHOP(3,8,GLOBAL_SHOP.TYPE.Dynamic,0);