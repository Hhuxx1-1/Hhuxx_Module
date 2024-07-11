local secretKey = "CODE2024YEAR_Unknown";

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
    for hexByte in encryptedText:gmatch("%S+") do
        table.insert(decryptedBytes, tonumber(hexByte, 16))
    end
    local decryptedStr = "";    local keyLen = #key;
    for i = 1, #decryptedBytes do
        local keyByte = key:byte((i - 1) % keyLen + 1);        local decryptedByte = bxor(decryptedBytes[i], keyByte);        decryptedStr = decryptedStr .. string.char(decryptedByte)
    end
    return decryptedStr
end

--local originalText = "HelloWorld"

-- Encrypt the original text
--local encryptedText = crypt(originalText, secretKey)
--print("Encrypted Text: " .. encryptedText)

-- Decrypt the text

-- local decryptedText = decrypt_text(encryptedText, secretKey)
-- print("Decrypted Text: " .. decryptedText)

PLAYER_DAT = {};

PLAYER_DAT.TYPE = {
    MAX_HP      =   {
        v = PLAYERATTR.MAX_HP,
        f = function(playerid,val) 
            print("Set Max Hp of Player : "..playerid.." Into : "..val);
            local r = Player:setAttr(playerid, 1, tonumber(val));
            print("Execution status is "..r);
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
    },
    EXP_LEVEL = {
            v = "EXP_LEVEL",
            f = function(playerid,val) 
                
            end, 
            get = function(playerid)
                local r , v = VarLib2:getPlayerVarByName(playerid, 3,"Currency");
                if ( r == 0 ) then return v end 
            end
    }
}

PLAYER_DAT.SAVE = function(playerid,Value)
    local encryptedText = crypt(Value, secretKey);
    local r = Valuegroup:insertInGroupByName(18, "PLAYER_DAT", encryptedText, playerid);
    if r==0 then return true else return false end
end

PLAYER_DAT.READ = function(playerid,indexs)
    local r,Value = Valuegroup:getValueNoByName(18, "PLAYER_DAT", indexs, playerid);
    local decryptedText = readcode(Value, secretKey);
    return decryptedText
end 

PLAYER_DAT.LOAD = function(playerid)
    local r , DAT = Valuegroup:getAllGroupItem(18, "PLAYER_DAT", playerid);
    for i ,a in ipairs(DAT) do 
        local Read_Data2 = PLAYER_DAT.READ(playerid,i);
        local Read_Data1 = readcode(a,secretKey);
        if(Read_Data1 == Read_Data2)then 
            local key, value = string.match(Read_Data1, "([%w_]+):(%d+)");
            local DatType = PLAYER_DAT.TYPE[key];
            DatType.f(playerid,value);
        end 
    end 
end 


--Example Usage 
-- ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
-- local playerid = e.eventobjid;
-- PLAYER_DAT.SAVE(playerid,"CURRENCY:1000");    
-- PLAYER_DAT.SAVE(playerid,"MAX_HP:100");
-- PLAYER_DAT.SAVE(playerid,"CUR_HP:10");
-- PLAYER_DAT.SAVE(playerid,"CURRENCY:100");
-- PLAYER_DAT.SAVE(playerid,"ATK_MELEE:200");
-- PLAYER_DAT.SAVE(playerid,"CURRENCY:1000");    
-- PLAYER_DAT.LOAD(playerid);

-- end)