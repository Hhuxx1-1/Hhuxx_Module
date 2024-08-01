-- PLAYER_DAT
local secretKey = "8qwyadihsn";
local maxSkillPoint = 999;
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
    return math.floor(exp/1000);
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
        local exp = math.fmod(PLAYER_DAT.TYPE.EXPERIENCE.get(playerid),1000);
        Customui:setText(playerid, self.uiid, self.uiid.."_51", exp.."/1000");
    end,
    setLevelDis = function(self,playerid)
        local levelplayer = getPlayerLevel(playerid);
        --print("Level of player [",playerid,"] is : ",levelplayer);
        Customui:setText(playerid, self.uiid, self.uiid.."_13", levelplayer);
    end,
    setLevelBar = function(self,playerid)
        local percentageofexp = math.fmod(PLAYER_DAT.TYPE.EXPERIENCE.get(playerid),1000)/1000;
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
            Customui:setText(playerid,self.uiid,self.uiid.."_"..stextid[i],sname[i].." Lv."..skillpoint);
            Customui:setSize(playerid,self.uiid,self.uiid.."_"..barid[i],(tonumber(skillpoint)/maxSkillPoint)*Lengthmax,heightnow);
        end 
    end,
    setAvailableSkillPoint = function(self,playerid)
        Customui:setText(playerid,self.uiid,self.uiid.."_47"," "..PLAYER_DAT.TYPE.SKILL_POINT.get(playerid).." ".."Skill Point Available")
    end,
    loadSkillDes = function(self,playerid)
        local s1,s2,s3 = PLAYER_DAT.TYPE.MOD_SKILL.get(playerid);
        local s={s1,s2,s3};
        local desui = {}
        for i,a in ipairs(s) do 
            
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


-- Prepare Global Calling 
PLAYER_DAT.ADD_EXP_TO_PLAYER    = function(playerid,exp) IncreasePlayerExp(playerid,exp) end 
PLAYER_DAT.CONSUME_SKILLPOINT   = function(playerid,ammount)     local currentSkillPoint = PLAYER_DAT.TYPE.SKILL_POINT.get(playerid);    local afterTransaction = currentSkillPoint-ammount;    if(afterTransaction<0)then return false end;    PLAYER_DAT.TYPE.SKILL_POINT.f(playerid,afterTransaction);    PLAYER_DAT.UPDATE_UI_ALL(playerid);    return true; end 
PLAYER_DAT.ADD_MONEY            = function(playerid,ammount)     local currentCurrency = PLAYER_DAT.TYPE.CURRENCY.get(playerid);    local newCurrency     = currentCurrency + ammount; --[[ Give Notification to Player]]    notifTextFloat(playerid,"+ $"..ammount);     Player:notifyGameInfo2Self(playerid,"#G + $"..ammount.." ") ; PLAYER_DAT.TYPE.CURRENCY.f(playerid,newCurrency); end
PLAYER_DAT.OBTAIN_STAT          = function(playerid) 
    local initial   = { HP = 190 , Mana = 190 , P_ATK = 10 , M_ATK = 10};
    local statPoint = { HP = PLAYER_DAT.TYPE.SKILL_HP_POINT.get(playerid),Mana = PLAYER_DAT.TYPE.SKILL_MP_POINT.get(playerid),P_ATK = PLAYER_DAT.TYPE.SKILL_ATK_POINT.get(playerid),M_ATK = PLAYER_DAT.TYPE.SKILL_MATK_POINT.get(playerid)}
    local stat      = {  
          HP    = initial.HP    + ( statPoint.HP    *   30  )     ,
          Mana  = initial.Mana  + ( statPoint.Mana  *   10  )     ,
          P_ATK = initial.P_ATK + ( statPoint.P_ATK *   1   )     ,
          M_ATK = initial.M_ATK + ( statPoint.M_ATK *   2   )     
        }
    return stat;
end 

