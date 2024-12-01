HX_UI = {} -- a global method that wrap UI LOGIC 
function HX_UI:SET_TEXT(playerid,ui,element,text)
    return Customui:setText(playerid,ui,ui.."_"..element,text);
end 

HX_UI.BTN_STRING ={}

function HX_UI:SET_BUTTON(playerid,ui,element,textData)
    HX_UI.BTN_STRING[ui.."_"..element] = textData;
end 

function HX_UI:SET_COLOR(playerid,ui,element,color)
    return Customui:setColor(playerid,ui,ui.."_"..element,color);
end

function HX_UI:HIDE(playerid,ui,element)
    return Customui:hideElement(playerid,ui,ui.."_"..element);
end

function HX_UI:SHOW(playerid,ui,element)
    return Customui:showElement(playerid,ui,ui.."_"..element);
end