-- PLAYER_DAT
local secretKey = "8qwyadihsn";
local maxSkillPoint = 999;
local SkillPointGainedOnLevelUp = 3;
local function bxor(a, b)
    local result = 0;    local bit = 1;    
    while a > 0 or b > 0 do
        local a_bit = a % 2;        local b_bit = b % 2;        
        if a_bit ~= b_bit then            
            result = result + bit
        end;
        a = math.floor(a / 2);        b = math.floor(b / 2);        bit = bit * 2
    end    return result
end

local function crypt(input, key)
    local output = {};    local keyLen = #key;
    for i = 1, #input do
        local inputByte = input:byte(i);        local keyByte = key:byte((i - 1) % keyLen + 1);        local encryptedByte = bxor(inputByte, keyByte);        table.insert(output, string.format("%02x", encryptedByte));
    end
    return table.concat(output, " ")
end

local function hex_to_string(hex)
    local str = "";    for hexByte in hex:gmatch("%S+") do
        str = str .. string.char(tonumber(hexByte, 16));
    end;    return str
end

local function readcode(encryptedText, key)
    local decryptedBytes = {};
    if(encryptedText:gmatch("%S+")~=nil)then 
    for hexByte in encryptedText:gmatch("%S+") do
        table.insert(decryptedBytes, tonumber(hexByte, 16))
    end
    local decryptedStr = "";    local keyLen = #key;
    for i = 1, #decryptedBytes do
        local keyByte = key:byte((i - 1) % keyLen + 1);        local decryptedByte = bxor(decryptedBytes[i], keyByte);        decryptedStr = decryptedStr .. string.char(decryptedByte)
    end 
    return decryptedStr
    else 
    return false;
    end
end

--local originalText = "HelloWorld"

-- Encrypt the original text
--local encryptedText = crypt(originalText, secretKey)
--print("Encrypted Text: " .. encryptedText)

-- Decrypt the text

-- local decryptedText = decrypt_text(encryptedText, secretKey)
-- --print("Decrypted Text: " .. decryptedText)

PLAYER_DAT = {};

PLAYER_DAT.GET_KEY_VAL = function(oneArguments)
    --print(" Arguments From Get_Key_Val : ",oneArguments);
    local key, value = string.match(oneArguments, "([%w_]+):(%d+)");
    return key,value
end

PLAYER_DAT.SAVE_TYPE=function (key , playerid)
    local r , t = Valuegroup:getAllGroupItem(18, "PLAYER_DAT", playerid);
    for i,a in pairs(t) do
       local decrypts = readcode(a, secretKey);
       --print("index : ",i ,a," ->" ,decrypts);
       local key1, value1 = PLAYER_DAT.GET_KEY_VAL(decrypts);
       --print(key1 , " | ", key);
       if(key1 == key)then return i, true,a end 
    end
    --print(r,t);
    return 1+#t , false;
end 

PLAYER_DAT.SAVE = function(playerid,Value)
    local key, value = PLAYER_DAT.GET_KEY_VAL(Value);
    local indes,cond,oldText = PLAYER_DAT.SAVE_TYPE(key , playerid);
    local newText = crypt(Value, secretKey);
    --print("Saving Data ", indes , " As " , newText)
    if(cond)then 
        Valuegroup:replaceValueByName(18, "PLAYER_DAT", oldText, newText, playerid)
    else 
        Valuegroup:insertInGroupByName(18, "PLAYER_DAT", newText, playerid)
        --Valuegroup:setValueNoByName(18, "PLAYER_DAT",indes, newText, playerid);
    end 
    if r==0 then return true else return false end
end

PLAYER_DAT.READ = function(playerid,indexs)
    local r,Value = Valuegroup:getValueNoByName(18, "PLAYER_DAT", indexs, playerid);
    --print( "Read From Data Index : ",indexs , " is ", r , " and Value is ", Value);
    if(r~=0)then 
        return false; 
    else 
        local decryptedText = readcode(Value, secretKey);
        return decryptedText
    end 
end 

PLAYER_DAT.TYPE = {
    MAX_HP      =   {
        v = PLAYERATTR.MAX_HP,
        f = function(playerid,val) 
            local r = Player:setAttr(playerid, 1, tonumber(val));
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,1);
            if ( r == 0 ) then return v end 
        end 
    },
    CUR_HP      =   { 
        v = PLAYERATTR.CUR_HP,
        f = function(playerid,val)
            Player:setAttr(playerid, 2, tonumber(val));
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,2);
            if ( r == 0 ) then return v end 
        end 
    },
    HP_RECOVER  =   { 
        v = PLAYERATTR.HP_RECOVER,
        f = function(playerid,val) 
            Player:setAttr(playerid, 3, tonumber(val));
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,3);
            if ( r == 0 ) then return v end 
        end 
    },
    LIFE_NUM    =   {
        v = PLAYERATTR.LIFE_NUM,
        f = function(playerid,val) 
            Player:setAttr(playerid, 4, tonumber(val));
        end ,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,4);
            if ( r == 0 ) then return v end 
        end 
    },
    MAX_HUNGER  =  {
        v = PLAYERATTR.MAX_HUNGER,
        f = function(playerid,val) 
            Player:setAttr(playerid,5,tonumber(val)) 
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,5);
            if ( r == 0 ) then return v end 
        end 
    },
    CUR_HUNGER  =  {
        v = PLAYERATTR.CUR_HUNGER,
        f = function(playerid,val) 
            Player:setAttr(playerid,6,tonumber(val)) 
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,6);
            if ( r == 0 ) then return v end 
        end 
    },
    MAX_OXYGEN = {
        v = PLAYERATTR.MAX_OXYGEN,
        f =  function(playerid,val) 
            Player:setAttr(playerid,7,tonumber(val)) 
        end,
        get = function(playerid) 
            local r , v = Player:getAttr(playerid,7);
            if ( r == 0 ) then return v end 
        end 
    },
    CUR_OXYGEN = {
            v = PLAYERATTR.CUR_OXYGEN,
            f =  function(playerid,val) 
                Player:setAttr(playerid,8,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,8);
                if ( r == 0 ) then return v end 
            end 
    },
    WALK_SPEED = {
            v = PLAYERATTR.WALK_SPEED,
            f =  function(playerid,val) 
                Player:setAttr(playerid,10,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,10);
                if ( r == 0 ) then return v end 
            end 
    },
    RUN_SPEED = {
            v = PLAYERATTR.RUN_SPEED,
            f =  function(playerid,val) 
                Player:setAttr(playerid,11,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,11);
                if ( r == 0 ) then return v end 
            end 
    },
    SNEAK_SPEED = {
            v = PLAYERATTR.SNEAK_SPEED,
             f =  function(playerid,val) 
                Player:setAttr(playerid,12,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,12);
                if ( r == 0 ) then return v end 
            end 
    },
    JUMP_POWER = {
            v = PLAYERATTR.JUMP_POWER,
            f =  function(playerid,val) 
                Player:setAttr(playerid,14,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,14);
                if ( r == 0 ) then return v end 
            end 
    },
    ATK_MELEE = {
            v = PLAYERATTR.ATK_MELEE,
            f =  function(playerid,val) 
                Player:setAttr(playerid,17,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,17);
                if ( r == 0 ) then return v end 
            end 
    },
    ATK_REMOTE = {
            v = PLAYERATTR.ATK_REMOTE,
            f =  function(playerid,val) 
                Player:setAttr(playerid,18,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,18);
                if ( r == 0 ) then return v end 
            end 
    },
    DEF_MELEE = {
            v = PLAYERATTR.ATK_REMOTE,
            f =  function(playerid,val) 
                Player:setAttr(playerid,19,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,19);
                if ( r == 0 ) then return v end 
            end 
    },
    DEF_REMOTE = {
            v = PLAYERATTR.DEF_REMOTE,
            f =  function(playerid,val) 
                Player:setAttr(playerid,20,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,20);
                if ( r == 0 ) then return v end 
            end 
    },
    DIMENSION = {
            v = PLAYERATTR.DIMENSION,
            f =  function(playerid,val) 
                Player:setAttr(playerid,21,tonumber(val)) 
            end,
            get = function(playerid) 
                local r , v = Player:getAttr(playerid,21);
                if ( r == 0 ) then return v end 
            end 
    },
    CURRENCY = {
            v = "Currency",
            f = function(playerid,val)
                VarLib2:setPlayerVarByName(playerid, 3, "Currency", tonumber(val))
            end,
            get = function(playerid)
                local r , v = VarLib2:getPlayerVarByName(playerid, 3,"Currency");
                if ( r == 0 ) then return v end 
            end 
    },EXPERIENCE = {
            v = "EXPERIENCE",
            f = function(playerid,val) 
                PLAYER_DAT.SAVE(playerid,"EXPERIENCE:"..val);
            end, 
            get = function(playerid)
                local key = PLAYER_DAT.SAVE_TYPE("EXPERIENCE",playerid);
                local Encrypted_V = PLAYER_DAT.READ(playerid,key);
                local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
                return val;
            end
    },SKILL_POINT={
        v = "SKILL_POINT",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"SKILL_POINT:"..val);
            end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("SKILL_POINT",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end 
    },SKILL_HP_POINT = {
        v = "SKILL_HP_POINT",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"SKILL_HP_POINT:"..val);
        end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("SKILL_HP_POINT",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end
    },SKILL_MP_POINT = {
        v = "SKILL_MP_POINT",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"SKILL_MP_POINT:"..val);
            end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("SKILL_MP_POINT",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end
    },SKILL_ATK_POINT = {
        v = "SKILL_ATK_POINT",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"SKILL_ATK_POINT:"..val);
        end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("SKILL_ATK_POINT",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end
    },SKILL_MATK_POINT = {
        v = "SKILL_MATK_POINT",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"SKILL_MATK_POINT:"..val);
            end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("SKILL_MATK_POINT",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end
    },
    LAST_LOGIN = {
        v = "LAST_LOGIN",
        f = function(playerid,val)
            
        end,
        get = function(playerid)

        end
    },ITEM_1={
        v = "ITEM_1",
        f = function(playerid,val)
            PLAYER_DAT.SAVE(playerid,"ITEM_1:"..val);
        end,
        get = function(playerid)
            local key = PLAYER_DAT.SAVE_TYPE("ITEM_1",playerid);
            local Encrypted_V = PLAYER_DAT.READ(playerid,key);
            local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
            return val;
        end
    },JOINNEW = {
            v = "JOINNEW",
            f = function(playerid,val)
                -- PLAYER_DAT.SAVE(playerid,"MAX_HP:300");
                -- PLAYER_DAT.SAVE(playerid,"CUR_HP:300");
                -- PLAYER_DAT.SAVE(playerid,"ATK_MELEE:10");
                PLAYER_DAT.SAVE(playerid,"JOINNEW:0");
                PLAYER_DAT.SAVE(playerid,"EXPERIENCE:0");
                PLAYER_DAT.SAVE(playerid,"SKILL_POINT:0");
                PLAYER_DAT.SAVE(playerid,"SKILL_HP_POINT:1");
                PLAYER_DAT.SAVE(playerid,"SKILL_MP_POINT:1");
                PLAYER_DAT.SAVE(playerid,"SKILL_ATK_POINT:1");
                PLAYER_DAT.SAVE(playerid,"SKILL_MATK_POINT:1");
            end,
            get = function(playerid)
                local key = PLAYER_DAT.SAVE_TYPE("JOINNEW",playerid);
                --print("Getting Key for JOINNEW : ", key);
                local Encrypted_V = PLAYER_DAT.READ(playerid,key);
                --print("Encrypted_V = ",Encrypted_V);
                if(Encrypted_V~=false)then 
                local k,val = PLAYER_DAT.GET_KEY_VAL(Encrypted_V);
                    if(Encrypted_V==nil)then return false else 
                        return val;
                    end 
                else 
                    return "JOINNEW:1001";
                end 
            end
    },
    MOD_SKILL = {
        v = "MOD_SKILL",
        f = function(playerid,val)
            -- let this Empty we are not going to set from player dat 
        end,
        get = function(playerid)
            local result,ret=Valuegroup:getAllGroupItem(18,"SkillSet", playerid)
            local s1,s2,s3 = ret[1],ret[2],ret[3];
            return s1,s2,s3     
        end
    },
}

PLAYER_DAT.LOAD = function(playerid)
    local r , DAT = Valuegroup:getAllGroupItem(18, "PLAYER_DAT", playerid);
    --print("PLAYER [",playerid,"] LOAD FROM DATA : ",DAT);
    --print("Attempt 1",DAT);
    for i ,a in ipairs(DAT) do 
        local Read_Data1 = readcode(a,secretKey);
        -- --print("Attempt 2",Read_Data1);
        local key, value = PLAYER_DAT.GET_KEY_VAL(Read_Data1);
        local indes = PLAYER_DAT.SAVE_TYPE(key,playerid);
        --print("Attempt 4",indes);
        local Read_Data2 = PLAYER_DAT.READ(playerid,indes);
        if(Read_Data1 == Read_Data2)then 
            local key, value = PLAYER_DAT.GET_KEY_VAL(Read_Data2);
            local DatType = PLAYER_DAT.TYPE[key];
            if(DatType~=nil)then 
                DatType.f(playerid,value);
            else 
                value = "Empty";
                --print("--print Data 2 : ",Read_Data2 , " --print Data 1 : " , Read_Data1)
            end 
            --print("Reading ... : ",DatType,value ,Read_Data1, " | ",Read_Data2)
        else 
            --print("Reading ... : ",Read_Data1, " | ",Read_Data2)
            local key, value = PLAYER_DAT.GET_KEY_VAL(Read_Data1);
            local DatType = PLAYER_DAT.TYPE[key];
            if(DatType~=nil)then 
            DatType.f(playerid,value);
            else 
                value = "Empty";
                --print("--print Data 2 : ",Read_Data2 , " --print Data 1 : " , Read_Data1)
            end 
        end 
        --print("Load : ",indes," k : ",key," v : ", value , "Reading Data : " ,Read_Data1," | ",Read_Data2);
    end 
end 

local EXP_to_LEVEL = function(exp)
    local level = 0
    local required_exp = 100
    local increment = 200
    exp = tonumber(exp);
    while exp >= required_exp do
        exp = exp - required_exp
        level = level + 1
        required_exp = required_exp + increment
    end

    return level,exp,required_exp;
end

PLAYER_DAT.INIT_PLAYER = function(playerid)

    local checkSum = PLAYER_DAT.TYPE.JOINNEW.get(playerid);
    --print("Check SUM : ",checkSum);
    --print(checkSum,playerid);
    if (tonumber(checkSum) == 0) then
        Chat:sendSystemMsg("#G["..playerid.."] #W:"..T_Text(playerid, "Wellcome Back!"));
        --pass
        Player:StandReportEvent(playerid," Player Comeback ");
    else 
        Chat:sendSystemMsg("#G["..playerid.."] #W:"..T_Text(playerid,"Is New to the Game!"));
        PLAYER_DAT.TYPE.JOINNEW.f(playerid);
        Player:StandReportEvent(playerid," New Player ");
    end 
    PLAYER_DAT.LOAD(playerid);

end 
local function getPlayerLevel(playerid)
    local AllExp = PLAYER_DAT.TYPE.EXPERIENCE.get(playerid);
    return EXP_to_LEVEL(AllExp);
end 

PLAYER_DAT.UPDATE_UI ={
    uiid = "7386694522892916978",
    setName = function(self,playerid)
        local r,playername = Player:getNickname(playerid);
        Customui:setText(playerid, self.uiid, self.uiid.."_11", playername);
    end,
    setIcon = function(self,playerid)
        local r, iconid = Customui:getRoleIcon(playerid);
        Customui:setTexture(playerid, self.uiid, self.uiid.."_9", iconid);
    end,
    setExpDis = function(self,playerid)
        local curexp = PLAYER_DAT.TYPE.EXPERIENCE.get(playerid);
        local L,E,R = EXP_to_LEVEL(curexp);
        Customui:setText(playerid, self.uiid, self.uiid.."_51", E.."/"..R);
    end,
    setLevelDis = function(self,playerid)
        local curexp = PLAYER_DAT.TYPE.EXPERIENCE.get(playerid);
        local L,E,R = EXP_to_LEVEL(curexp);
        Customui:setText(playerid, self.uiid, self.uiid.."_13", L);
    end,
    setLevelBar = function(self,playerid)
        local curexp = PLAYER_DAT.TYPE.EXPERIENCE.get(playerid);
        local L,E,R = EXP_to_LEVEL(curexp);
        local percentageofexp = E/R;
        Customui:setSize(playerid, self.uiid, self.uiid.."_49", percentageofexp*150, 16)
    end,
    -- setMoneyDis = function(self,playerid)
    --     Customui:setText(playerid, "7352431270965221618", "7352431270965221618_25", "$"..money);
    --     --Customui:setText(playerid, "7352431270965221618", "7352431270965221618_25", "$"..money);
    -- end,
    setSkillPoint = function(self,playerid)
        local sname = {"Max Health","Max Mana","Physical Attack", "Magic Attack"};
        local stextid = {16,18,22,26};
        local barid = {15,20,24,28};
        local Lengthmax , heightnow = 269,28;
        local keyName = {"SKILL_HP_POINT", "SKILL_MP_POINT", "SKILL_ATK_POINT", "SKILL_MATK_POINT"}
        for i=1,4 do 
            local skillpoint = PLAYER_DAT.TYPE[keyName[i]].get(playerid);
            Customui:setText(playerid,self.uiid,self.uiid.."_"..stextid[i],T_Text(playerid,sname[i]).." Lv."..skillpoint);
            Customui:setSize(playerid,self.uiid,self.uiid.."_"..barid[i],(tonumber(skillpoint)/maxSkillPoint)*Lengthmax,heightnow);
        end 
    end,
    setAvailableSkillPoint = function(self,playerid)
        Customui:setText(playerid,self.uiid,self.uiid.."_47",T_Text(playerid,"You Have").." "..PLAYER_DAT.TYPE.SKILL_POINT.get(playerid).." "..T_Text(playerid,"Skill Point Available"))
    end,
    loadSkillDes = function(self,playerid)
        local s1,s2,s3 = PLAYER_DAT.TYPE.MOD_SKILL.get(playerid);
        local s={s1,s2,s3};
        local desui = {self.uiid.."_42",self.uiid.."_43",self.uiid.."_44"}
        for i,a in ipairs(s) do 
            if(act[a]~=nil)then 
                local textD = act[a].description or "Not Available yet";
                local icon = act[a].icon;
                Customui:setText(playerid,self.uiid,desui[i],textD);
                Customui:setTexture(playerid,self.uiid,self.uiid.."_"..i,icon);
--[[             Set The Thumbnail]]
                if act[a].thumb ~= nil then 
                    Customui:setTexture(playerid,self.uiid,self.uiid.."_36",act[a].thumb);
                end 
            else 
                Customui:setText(playerid,self.uiid,desui[i],"Skill not Set yet");
            end 
        end 
    end
}

PLAYER_DAT.UPDATE_UI_ALL = function(playerid)
    --check if it is function then execute 
        for k,v in pairs(PLAYER_DAT.UPDATE_UI) do
            if(type(v)=="function")then v(PLAYER_DAT.UPDATE_UI,playerid) end
        end
end



local function notifTextFloat(playerid,text) 
    local r,x,y,z = Actor:getPosition(playerid);
    local title="#cffbf00"..tostring(text);
	local font=32;
	local itype=1;
	local graphicsInfo=Graphics:makeflotageText(title, font, itype)
	local x2,y2=(math.random(0,10)-5)/5,(math.random(0,10)-5)/5
	local result,graphid=Graphics:createflotageTextByPos(x+math.random(-1,1), y+2, z+math.random(-1,1), graphicsInfo, x2, y2)
end 

local function isInBoostExp(playerid)
    local idsbuff = {50000013,50000011,50000012};
    for i , a in ipairs(idsbuff)do 
        local r , bool = Actor:hasBuff(playerid,a);
        if(r==0)then 
            return 5-i ;
        end 
    end 
    return 1;
end 


local function IncreasePlayerExp(playerid,value)
    local CurrentExp = PLAYER_DAT.TYPE.EXPERIENCE.get(playerid);
    --  Check For Exp Buff 
    local Multiplier = isInBoostExp(playerid);
    value = value * Multiplier;
    local NewExp = CurrentExp + value;
    if(EXP_to_LEVEL(CurrentExp)<EXP_to_LEVEL(NewExp))then 
        -- it is new Level ! 
        -- Add Skill Point Reward To Player  
        local SkillPoint = PLAYER_DAT.TYPE.SKILL_POINT.get(playerid);
        local NewSkillPoint = SkillPoint + SkillPointGainedOnLevelUp;
        PLAYER_DAT.TYPE.SKILL_POINT.f(playerid,NewSkillPoint);
        -- updateDisplay UI
        Player:notifyGameInfo2Self(playerid,T_Text(playerid,"Level Up!").." Lv."..EXP_to_LEVEL(NewExp));
        notifTextFloat(playerid,T_Text(playerid,"Level Up!").." Lv."..EXP_to_LEVEL(NewExp));
        Player:playMusic(playerid, 10957, 100,1, false);Actor:playBodyEffectById(playerid, 1738 ,1);
        Player:StandReportEvent(playerid,"Level Up! Lv"..EXP_to_LEVEL(NewExp));
    else 
        notifTextFloat(playerid,"+"..value.."EXP");
    end 
    -- set Total Exp 
    PLAYER_DAT.TYPE.EXPERIENCE.f(playerid,NewExp);
    PLAYER_DAT.UPDATE_UI_ALL(playerid);
end 

local function CalculateRewardsDefeatingPlayer(playerid,tplayerid)
    -- Get Target Player Level and Player Level
    local tlevel = getPlayerLevel(tplayerid);
    local level = getPlayerLevel(playerid);
    -- If target player Level is Below Level of Player id don't give rewards 
    if(tlevel<level)then return end;
    -- rewards = targetplayerid level - playeridLevel
    local rewards = tlevel - level;
    -- if rewards is negative then don't give rewards
    if(rewards<0)then return end;
    -- Total Exp Gained is 10*rewards
    local exp = rewards*10;
    -- Total Money Gained is 15*rewards 
    local money = rewards*15;
    -- Increase playerid Exp and Calculate is it Gaining Level or Not 
    IncreasePlayerExp(playerid,exp);
end

-- Prepare Global Calling 
PLAYER_DAT.ADD_EXP_TO_PLAYER    = function(playerid,exp) IncreasePlayerExp(playerid,exp) end 
PLAYER_DAT.CONSUME_SKILLPOINT   = function(playerid,ammount)     local currentSkillPoint = PLAYER_DAT.TYPE.SKILL_POINT.get(playerid);    local afterTransaction = currentSkillPoint-ammount;    if(afterTransaction<0)then return false end;    PLAYER_DAT.TYPE.SKILL_POINT.f(playerid,afterTransaction);    PLAYER_DAT.UPDATE_UI_ALL(playerid);    return true; end 
PLAYER_DAT.ADD_MONEY            = function(playerid,ammount)     local currentCurrency = PLAYER_DAT.TYPE.CURRENCY.get(playerid);    local newCurrency     = currentCurrency + ammount; --[[ Give Notification to Player]]    notifTextFloat(playerid,"+ $"..ammount);     Player:notifyGameInfo2Self(playerid,"#G + $"..ammount.." ") ; PLAYER_DAT.TYPE.CURRENCY.f(playerid,newCurrency); end
PLAYER_DAT.OBTAIN_STAT          = function(playerid) 
    local initial   = { HP = 190 , Mana = 190 , P_ATK = 10 , M_ATK = 10};
    local statPoint = { HP = PLAYER_DAT.TYPE.SKILL_HP_POINT.get(playerid),Mana = PLAYER_DAT.TYPE.SKILL_MP_POINT.get(playerid),P_ATK = PLAYER_DAT.TYPE.SKILL_ATK_POINT.get(playerid),M_ATK = PLAYER_DAT.TYPE.SKILL_MATK_POINT.get(playerid)}
    local stat      = {  
          HP    = initial.HP    + ( statPoint.HP    *   30  )     ,
          Mana  = initial.Mana  + ( statPoint.Mana  *   5  )     ,
          P_ATK = initial.P_ATK + ( statPoint.P_ATK *   1   )     ,
          M_ATK = initial.M_ATK + ( statPoint.M_ATK *   2   )     
        }
    return stat;
end 

local function LoadStat(playerid)
    local stat = PLAYER_DAT.OBTAIN_STAT(playerid);
    PLAYER_DAT.TYPE.MAX_HP.f(playerid,stat.HP);PLAYER_DAT.TYPE.CUR_HP.f(playerid,stat.HP);
    PLAYER_DAT.TYPE.MAX_HUNGER.f(playerid,stat.Mana);PLAYER_DAT.TYPE.CUR_HUNGER.f(playerid,stat.Mana);
    PLAYER_DAT.TYPE.ATK_MELEE.f(playerid,stat.P_ATK);PLAYER_DAT.TYPE.ATK_REMOTE.f(playerid,stat.P_ATK);
end

local function CalculateRewardsDefeatingMob(playerid,actorid)
    -- Get Actorid Max Health Using API 
    local r , maxHP = Actor:getMaxHP(actorid);
    -- Calculate Exp from Actor maxHP 
    local exp = 5+math.ceil(maxHP*0.05314);
    IncreasePlayerExp(playerid,exp);
end

-- Defeating Target and Rewards Calculations 
ScriptSupportEvent:registerEvent("Player.DefeatActor",function (e)
    --print("Defeating target ",e);
    local playerid = e.eventobjid;
    local objid = e.toobjid;
    local r =Actor:isPlayer(objid)
    if(r == ErrorCode.OK)then 
        CalculateRewardsDefeatingPlayer(e.eventobjid,objid);
    else 
        CalculateRewardsDefeatingMob(e.eventobjid,objid);
    end 
end)


--Init
ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    threadpool:wait(1);
    local playerid = e.eventobjid;
    local result,error = pcall(function ()
        return PLAYER_DAT.INIT_PLAYER(playerid);
    end,playerid);
    threadpool:wait(1);
    if(result)then 
        Player:notifyGameInfo2Self(playerid,T_Text(playerid,"Success Loading"));
        PLAYER_DAT.UPDATE_UI_ALL(playerid);
        LoadStat(playerid);
    else 
        Player:notifyGameInfo2Self(playerid,T_Text(playerid,"ERROR : ")..error);
    end 
end)
ScriptSupportEvent:registerEvent('UPDATE_ACCROS_UI', function(e)
print(e);
local ret, data = pcall(JSON.decode,JSON,e.data);
if(data)then 
    PLAYER_DAT.UPDATE_UI_ALL(data.playerid)
else 
    local result,num,array=World:getAllPlayers(-1)
    for i,a in ipairs(array)do 
    PLAYER_DAT.UPDATE_UI_ALL(a);
    end 
end 
end);