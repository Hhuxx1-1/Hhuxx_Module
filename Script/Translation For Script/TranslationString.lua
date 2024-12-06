playerSession = {}

LANGUAGE_UPDATE = function(playerid)
    local r,lc,ar = Player:GetLanguageAndRegion(playerid);
    local codeLang = {"tw", "en", "cn", "tha", "esn", "ptb", "fra", "jpn", "ara", "kor", "vie", "rus", "tur", "ita", "ger", "ind", "msa"};
    if(r==0)then 
        local inlangcode = tonumber(lc);
            if(inlangcode and inlangcode>=0)then  
                if lc < 1 then lc = 1 else lc = lc + 1 end ;
                playerSession[playerid]={lc=codeLang[lc],ar=""} or {lc="en",ar=""}
            else  
                playerSession[playerid]={lc=lc,ar=ar};
            end
        else 
        playerSession[playerid]={lc="en",ar="EN"};
    end 
    Player:notifyGameInfo2Self(playerid," Language Detected : "..playerSession[playerid].lc);
end 

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    local playerid = e.eventobjid;
    LANGUAGE_UPDATE(playerid);
    print(playerSession);
end)

reportText_ERROR = ""

local loggedKeys = {} -- Table to track logged keys

-- Function to log an error key
function logErrorKey(key)
    if not loggedKeys[key] then
        -- If the key is not already logged, add it to the report and mark it as logged
        reportText_ERROR = reportText_ERROR .. key .. "|"
        loggedKeys[key] = true
    end
end
T_Text = {};
function toIndex(nonIndex)
    return string.gsub(nonIndex," ","_");
end 
function getSession(playerid)
    return playerSession[playerid].lc
end 

function trim(s)
    return s:match("^%s*(.-)%s*$")
end

T_Text_meta = {
    __index = function(table,key)
        T_Text[key]={};
        return T_Text[key];
    end,
    __add = function(a, b)
        a[toIndex(b[3])][b[1]] = b[2]
        return a[toIndex(b[3])][b[1]];
    end,
    __sub = function(a,b)
        a[toIndex(b[2])][b[1]] = nil;
    end,
    __call = function(T_Text,playerid,key)
        key = trim(key) -- making sure the Key Trimmed
        if T_Text[toIndex(key)][getSession(playerid)] == nil then 
            --Chat:sendSystemMsg("#RERROR T_Text "..toIndex(key).." is Not Defined!",1029380338);
            --print("Session from [",playerid,"] got an Error",getSession(playerid));
            --print("What is T ?",T_Text);
            logErrorKey(key)
            return key
        end 
        return T_Text[toIndex(key)][getSession(playerid)]
    end
}
T_Text = setmetatable(T_Text,T_Text_meta);

function createText(langcode,value,keystring) return T_Text + {langcode,value,keystring}; end

-- USAGE
-- Lets Say Player is from Spanyol
-- Cannot Directly be Used before player joined the game
-- T_Text(playerid,"Hello World") -> "Hola Mundo"