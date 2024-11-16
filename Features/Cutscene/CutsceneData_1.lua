

local items_for_begginer = {
    {itemid=12005,num=1},{itemid=4148,num=10}
}

local function Reset_Init(playerid)
    if Backpack:clearAllPack(playerid)==0 then return true else return false end
end

local INIT_ITEM = function(playerid,team)
    if Reset_Init(playerid) then 
        for i,v in ipairs(items_for_begginer) do 
            if Player:gainItems(playerid,v.itemid,v.num,1) ~= 0 then  
                return false;
            end 
        end 
    end 
end


CUTSCENE:CREATE("FIRST_START",{
    [1] = function(playerid)
        --Pass
        -- Clear Player Backpack 
        INIT_ITEM(playerid);
    end,
    [20] = function(playerid)
        CUTSCENE:setrotCamera(180,0,2,playerid);
        CUTSCENE:moveCamera(0,0,3,playerid);
    end,
    [60] = function(playerid)
        CUTSCENE:setText(playerid,"Looks Like you Got Lost...");
    end,
    [100] = function(playerid)
        CUTSCENE:setText(playerid," ");
    end,
    [140] = function(playerid)
        CUTSCENE:setText(playerid,"Let's Moving Forward ");
    end,
    [180] = function(playerid)
        CUTSCENE:setText(playerid," ");
    end,
    [220] = function(playerid)
        CUTSCENE:setText(playerid,"Maybe there is Someone Around");
    end,
    [280] = function(playerid)
        return true;
    end,
    ["END"] = function(playerid)
        -- Chat:sendSystemMsg("End");
        Player:SetCameraRotTransformTo(playerid,{x=180,y=0}, 1,2);
        RUNNER.NEW(function()
            -- play sound effect using mytool 
            local x,y,z = MYTOOL.GET_POS(playerid);
            MYTOOL.playSoundOnPos(x,y,z,10956,100,1);
            -- add Quest
            RunQuest(playerid,"none",0);
        end,{},20)
    end
});