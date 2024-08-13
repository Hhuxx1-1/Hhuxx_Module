-- version: 2022-04-20
-- mini: 1029380338
oncur = {} 

Level = 0

places={
Center = {x=0,z=0,y=9}
}

plist = {
"Center"   
}

local ledis = 0;


function NextLevel()
    if(LEVEL[Level]~=nil)then 
    Level = Level + 1; 
    for i,a in ipairs(LEVEL[Level]) do 
        local cp = plist[math.random(1,#plist)];
        local r , mlist = World:spawnCreature(
            places[cp].x,
            places[cp].y, 
            places[cp].z,
            a,1);
        if(r==0 and #mlist>0)then 
            table.insert(oncur,mlist[1]);
        end 
    end 
    else 
    --sysay("Set New Level from Current Level from "..Level.." until "..Level+10);
    setLevel(Level,Level+10);
    end 
end 


function CheckOnLevel()
    for i,a in ipairs(oncur) do 
        local r,hp = Creature:getAttr(a,2)
        if(hp==nil)then 
            table.remove(oncur,i);
        else 
            if(hp<0)then 
                table.remove(oncur,i);
            else
               
            end 
        end 
    end 
end 