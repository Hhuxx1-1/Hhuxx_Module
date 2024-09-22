local image_data = {
    [1] = [[8_1029380338_1726747210]],
    [2] = [[8_1029380338_1726747220]],
    [3] = [[8_1029380338_1726747229]],
    [4] = [[8_1029380338_1726747238]],
    [5] = [[8_1029380338_1726747254]],
    [6] = [[8_1029380338_1726747296]],
    [7] = [[8_1029380338_1726747307]],
    [8] = [[8_1029380338_1726747319]],
    [9] = [[8_1029380338_1726747335]],
    [10] = [[8_1029380338_1726747350]]
}

local function isExists(tbl, value)
    for i, v in pairs(tbl) do
        if v == value then
            return true  -- Value found
        end
    end
    return false  -- Value not found
end

local function getIndexOf(tbl,value)
    for i, v in pairs(tbl) do
        if v == value then
            return i  -- return the index
        end
    end
    return false  -- Value not found
end

HINT_PAPER = {}

HINT_PAPER.DATA = {}

HINT_PAPER.NEW = function(obj)
    if not isExists(HINT_PAPER.DATA,obj) then 
        table.insert(HINT_PAPER.DATA,obj)
    end 

    return  HINT_PAPER.DATA
end

HINT_PAPER.OPEN = function(playerid,obj)
    local uiid = "7416320374077069554";
    local picid = uiid.."_4";
    local textid = uiid.."_3";
    local data = HINT_PAPER.NEW(obj)
    local ix = getIndexOf(data,obj);
    if ix then 
        Player:openUIView(playerid,uiid);        
        Customui:setText(playerid,uiid,textid,T_Text(playerid,"Generator").." "..ix);
        Customui:setTexture(playerid,uiid,picid,image_data[ix]);
    else 
        Player:notifyGameInfo2Self(playerid,"Please try again Later");
    end 
end



