-- version: 2022-04-20
-- mini: 1029380338
M = {}
Boss = {}

function add_m(Name,ID,Cost)
    table.insert(M,{ID=ID,Cost=Cost,n=Name});
end 

function addBoss(Name,ID,Cost)
    table.insert(Boss,{ID=ID,Cost=Cost,n=Name});
end 

add_m("Boarman",3101,20);
add_m("Boarman_Captain_1",3921,30);
add_m("Boarman_Captain_2",3920,30);
add_m("Boarman_Centurion_1",3925,35);
add_m("Boarman_Centurion_2",3924,35);
add_m("Boarman_Void",3929,50);

add_m("Spear_Goblin_Normal",3105,40);
add_m("Pike_Goblin",3922,42);
add_m("Pike_Goblin_Throwing_A",3923,44);
add_m("Pike_Goblin_Throwing_B",3926,46);
add_m("Pike_Goblin_Throwing_C",3927,46);

--add_m("Bom_Egg",3109,60);
--add_m("Void_Egg",3928,80);

add_m("Sulfur_Archer",3131,60);
add_m("Jockey_Void",3933,50);
add_m("Chaos_Archer",3132,50);
add_m("Lava_Giant",3130,50);
--add_m("Big_Lava_Giant",14,100);
add_m("Ice_Golem",3915,300);
add_m("Wild_Imp",3508,30);

add_m("Void_Boarman_Centurion",3930,150);
add_m("Throwing_Pike_Boarman",3932,120);
add_m("Throwing_Pike_Boarman_Captain",3931,130);
add_m("Bulli",3112,100);

add_m("Frosti",3111,100);
add_m("Giant_Scorpion",3829,160);
add_m("Lightning_Boarman_Shaman",3875,120);

-- add_m("Skeleton_Main",2,420)
-- add_m("Second_Skeleton_Main",3,640);

--add_m("FrostBoarman_Shaman",3135,120);
addBoss("Tensei",14,900);
addBoss("IronGolemGigaChad",7,1200);
--add_m("Rocki",3110,100); Not Recommended
--add_m("Bat",3107,50); Bug
--add_m("Wild_Jockey",3102,30);
--add_m("Scorpion",3824,110);
--add_m("Graviti",3103,250);
--add_m("Void_Apostle",3501,60);

setLevel(1,20);
