-- CREATE THE CATALOG 
GLOBAL_SHOP:AddCatalogItems({
    {4102,"AUTO","AUTO","AUTO",600,0},
    {4097,"AUTO","AUTO","AUTO",3000,0},
    {4121,"AUTO","AUTO","AUTO",1400,0},
    {4122,"AUTO","AUTO","AUTO",1600,0},
    {4123,"AUTO","AUTO","AUTO",2500,0},
    {4124,"AUTO","AUTO","AUTO",2000,0},
    {4125,"AUTO","AUTO","AUTO",6000,0},
    {4126,"AUTO","AUTO","AUTO",12000,0},
    {4127,"AUTO","AUTO","AUTO",2900,0},
    {4128,"AUTO","AUTO","AUTO",4000,0},
    {4129,"AUTO","AUTO","AUTO",3600,0},
    {4130,"AUTO","AUTO","AUTO",2400,0}
});

GLOBAL_SHOP:InitVSHOP(2,{
    {id = 4102,     stock = 4},
    {id = 4097,     stock = 4},
    {id = 4121,     stock = 4},
    {id = 4122,     stock = 4},
    {id = 4123,     stock = 4},
    {id = 4124,     stock = 4},
    {id = 4125,     stock = 4},
    {id = 4126,     stock = 4},
    {id = 4127,     stock = 4},
    {id = 4128,     stock = 4},
    {id = 4129,     stock = 4},
    {id = 4130,     stock = 4}
})

GLOBAL_SHOP:AssignVSHOP(10,2,GLOBAL_SHOP.TYPE.Dynamic,0);