GACHA = {};

local function notify(playerid,text) Player:notifyGameInfo2Self(playerid,text); local r,name=Player:getNickname(playerid); Chat:sendSystemMsg(name.." "..text) end ;
GACHA.SFUNC = {
    ADD_AURA = function(playerid,AuraSet)
        for i,a in ipairs(AuraSet) do 
            Valuegroup:setValueNoByName(18, "SkillSet", i, a, playerid)
        end 
    end,
    ADD_ITEM = function(playerid,ItemSet)
        for i,a in ipairs(ItemSet) do 
            Player:gainItems(playerid,a,1,1)
        end 
    end ,
    ADD_CURRENCY = function(playerid,TableWithCurrency)
        local r,Currencyvalue = VarLib2:getPlayerVarByName(playerid, 3, "Currency")
        VarLib2:setPlayerVarByName(playerid, 3, "Currency", Currencyvalue+TableWithCurrency[1]);
    end 
};
-- Initial Gacha Function  
GACHA.EXECUTE = function(index,playerid) local df = GACHA[index];   df.main(playerid,df.data);  notify(playerid,"#YRoll Aura #GAnd Obtained #W"..df.name); end 
-- Name is The Reward TO Be displayed into Player when got the things 
-- Main is the Logic Function Which Must Expecting playerid, table with index 
-- data is table with index contain data set to be proceeded 
-- icon is display on the Aura Crate 
GACHA.ADD = function(name,main,data,icon) table.insert(GACHA,{name=name,main = main,data=data,icon=icon}) end 
GACHA.GETICON = function(index) return GACHA[index].icon end 

-- Usage Example 
--GACHA.EXECUTE(1,1029380338);


