-- Special Aura SkillSet
AURASET = {
    fire    = {"FireBall","FireBird","FireDash"} ,
    ices    = {"IceLance","IceBreath","IceGlacier"} ,
    thunder = {"ThunderStorm","ThunderDash","ThunderBuff"} ,
    power   = {"PowerPunch","PowerDash","PowerUp"},    
    sword   = {"Sword100","HighAndLow","ExtraSlash"},
    gravity = {"GravityBind","GravityMass","GravityJump"},
    void    = {"VoidHole","VoidAbsorb","VoidExchange"},
    medicore= {"InstantHealth","KeepOnRegen","Exchange"},
    phantom = {"SoulCraft","SoulPull","SoulHunt"},
    dragon  = {"DragonClaw","DragonBreath","DragonWing"},
    uranus  = {"Wrap","Enwrap","Dewrap"},
    root    = {"RootBind","RootCharge","RootArmor"},
    angel   = {"WarCry","WingBless","Rage"},
    darkang = {"Demolish","DarkBind","Immortality"},
    nature  = {"NatureRage","NatureHeal","NatureBind"},
    arcana  = {"ArcanaBind","ArcanaConceal","ArcanaConfusion"},
    leopard = {"LeopardSlash","LeopardJump","LeopardTransform"},
    force   = {"PullForce","PushForce","PurpleForce"},
    energy  = {"EnergyRay","EnergyArmor","EnergyDash"},
    timelord= {"Play2Times","Rewind","Pause"}
}

--Add New Item Named Fire Aura with Custom Function and Table Parameters and Icon ID 
GACHA.ADD("Fire Aura", GACHA.SFUNC.ADD_AURA , AURASET.fire ,[[8_1029380338_1719148067]]);
GACHA.ADD("Ice Aura", GACHA.SFUNC.ADD_AURA , AURASET.ices ,[[8_1029380338_1719148085]]);
GACHA.ADD("Thunder Aura", GACHA.SFUNC.ADD_AURA , AURASET.thunder ,[[8_1029380338_1719148114]]);
GACHA.ADD("Power Aura", GACHA.SFUNC.ADD_AURA , AURASET.power ,[[8_1029380338_1719148174]]);
GACHA.ADD("Sword Aura", GACHA.SFUNC.ADD_AURA , AURASET.sword ,[[8_1029380338_1719148133]]);
GACHA.ADD("Gravity Aura", GACHA.SFUNC.ADD_AURA , AURASET.gravity ,[[8_1029380338_1719148190]]);
-- GACHA.ADD("Void Aura", GACHA.SFUNC.ADD_AURA , AURASET.void ,[[8_1029380338_1719148201]]);
-- GACHA.ADD("Medicore Aura", GACHA.SFUNC.ADD_AURA , AURASET.medicore ,[[8_1029380338_1719148214]]);
-- GACHA.ADD("Phantom Aura", GACHA.SFUNC.ADD_AURA , AURASET.phantom ,[[8_1029380338_1719148278]]);
-- GACHA.ADD("Dragon Aura", GACHA.SFUNC.ADD_AURA , AURASET.dragon ,[[8_1029380338_1719148356]]);
-- GACHA.ADD("Uranus Aura", GACHA.SFUNC.ADD_AURA , AURASET.uranus ,[[8_1029380338_1719148489]]);
-- GACHA.ADD("Root Aura", GACHA.SFUNC.ADD_AURA , AURASET.root ,[[8_1029380338_1719148410]]);
-- GACHA.ADD("Angel Aura", GACHA.SFUNC.ADD_AURA , AURASET.angel ,[[8_1029380338_1719148437]]);
-- GACHA.ADD("Dark Angel Aura", GACHA.SFUNC.ADD_AURA , AURASET.darkang ,[[8_1029380338_1719148444]]);
-- GACHA.ADD("Nature Aura", GACHA.SFUNC.ADD_AURA , AURASET.nature ,[[8_1029380338_1719148498]]);
-- GACHA.ADD("Arcana Aura", GACHA.SFUNC.ADD_AURA , AURASET.arcana ,[[8_1029380338_1719148559]]);
-- GACHA.ADD("Leopard Aura", GACHA.SFUNC.ADD_AURA , AURASET.leopard ,[[8_1029380338_1719148600]]);
-- GACHA.ADD("Force Aura", GACHA.SFUNC.ADD_AURA , AURASET.force ,[[8_1029380338_1719148637]]);
-- GACHA.ADD("Energy Aura", GACHA.SFUNC.ADD_AURA , AURASET.energy ,[[8_1029380338_1719148625]]);
-- GACHA.ADD("Time Lord Aura", GACHA.SFUNC.ADD_AURA , AURASET.timelord ,[[8_1029380338_1719148642]]);

