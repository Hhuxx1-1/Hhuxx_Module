GLOBAL_SHOP:AddCatalogItems(
    { 
        {
            12005 , 
            "Diamond Sword",
            [[AUTO]],[[AUTO]],
            600,0
        },
        {
            12010 , 
            "Hammer",
            [[Weapon Skill is Capable of Slamming Ground and Stun Target for 2 Seconds]],[[AUTO]],
            1200,0
        },
        {
            12009 , 
            "Reaper",
            [[Weapons Skill Passive is Reducing Target Armor by 2 ]],[[AUTO]],
            1000,0
        },
        {
            12009 , 
            "Reaper",
            [[Weapons Skill Passive is Reducing Target Armor by 2 ]],[[AUTO]],
            1000,0
        },
        {
            540435 , 
            "Double Energy Spear",
            [[Can be Thrown and Deals Massive Ranged Damage]],[[AUTO]],
            3400,0
        },
        {
            12013 , 
            "Energy Spear",
            [[Can be Thrown and Deals Ranged Damage]],[[AUTO]],
            1800,0
        },
        {
            540391 , 
            "Sword and Shield",
            [[Block and Attack Very Durable Fight]],[[AUTO]],
            1500,0
        },
        {
            540355 , 
            "Double Hammer",
            [[Slam the Ground and Stun Target for 2 Seconds. While Dealing Massive Damage]],[[AUTO]],
            2500,0
        },
        {
            540438 , 
            "Energy Spear and Shield",
            [[Block and Attack Very Durable Fight. Longer Range Attack]],[[AUTO]],
            2400,0
        },
        {
            540389 , 
            "Double Energy Sword",
            [[Dash and Slash. While Dealing Massive Damage]],[[AUTO]],
            1500,0
        },
        {
            4153 , 
            "Saber V1",
            [[Saber Sword can be Upgraded into V2 version for Powerful]],[[AUTO]],
            3500,0
        },
        {
            4156 , 
            "Big Dagger", 
            [[Weapon Skill : Jump Forward then Slash Ground to Stun]],[[AUTO]],
            5000,0
        },
        {
            4158 , 
            "Anchor Axe", 
            [[Weapons Skill : Throw a Anchor into Target and Drag them]],[[AUTO]],
            12000,0
        },
        {
            4161 , 
            "Big Sword" , 
            [[Slash Damage and Stun Target for 2 Seconds]],[[AUTO]],
            15000,0
        },
        {
            4135 , 
            "War Axe" , 
            [[Speed Up and Stun Target for 2 Seconds]],[[AUTO]],
            150000,0
        },
        {
            4163 , 
            "Solo Dagger" , 
            [[Break Target Ressilience and Stun for 1 Second then Dash and Slash Target (More Damage when Attacking From Behind)]],[[AUTO]],
            30000,0
        },
        {
            4162 , 
            "Enchanted Big Sword" , 
            [[Big Sword but Deals 300 Damage, 2 Times Stronger]],[[AUTO]],
            165000,0
        },
        {
            12241 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            2400,0
        },
        {
            12242 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            2400,0
        },
        {
            12243 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            2400,0
        },
        {
            12244 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            2400,0
        },
        {
            4171 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            300,0
        },
        {
            4172 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            100,0
        },
        {
            4173 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            200,0
        },
        {
            4170 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            200,0
        },
        {
            4148 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            350,0
        },
        {
            4174 , 
            [[AUTO]], 
            [[AUTO]],[[AUTO]],
            800,0
        }
    }
)

GLOBAL_SHOP:InitVSHOP(2,{
    {id = 12005 , stock = 80},
    {id = 12010 , stock = 40},
    {id = 12009 , stock = 40},
    {id = 12013 , stock = 10},
    {id = 540435, stock = 5}    
});
GLOBAL_SHOP:InitVSHOP(3,{
    {id = 540391 , stock = 10},
    {id = 540355 , stock = 10},
    {id = 540438 , stock = 10},
    {id = 540389 , stock = 10},
});
GLOBAL_SHOP:InitVSHOP(4,{
    {id = 4153 , stock = 2},
    {id = 4156 , stock = 2},
    {id = 4158 , stock = 2},
    {id = 4161 , stock = 2},
    {id = 4135 , stock = 2},    
    {id = 4163 , stock = 2},    
    {id = 4162 , stock = 2},    
});

GLOBAL_SHOP:InitVSHOP(5,{
    {id = 12241 , stock = 20},
    {id = 12242 , stock = 20},
    {id = 12243 , stock = 20},
    {id = 12244 , stock = 20},
});

GLOBAL_SHOP:InitVSHOP(6,{
    {id = 4171 , stock = 20},
    {id = 4172 , stock = 20},
    {id = 4173 , stock = 20},
    {id = 4170 , stock = 20},
});

GLOBAL_SHOP:InitVSHOP(7,{
    {id = 4148 , stock = 20},
    {id = 4148 , stock = 20},
    {id = 4174 , stock = 20},
    {id = 4174 , stock = 20},
});

--[[
51
52
53
54
55
56
]]

GLOBAL_SHOP:AssignVSHOP(51,2,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(52,7,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(53,3,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(54,4,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(55,5,GLOBAL_SHOP.TYPE.Dynamic,0);
GLOBAL_SHOP:AssignVSHOP(56,6,GLOBAL_SHOP.TYPE.Dynamic,0);


