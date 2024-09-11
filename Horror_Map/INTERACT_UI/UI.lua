INTERACTIVE_UI = {}
INTERACTIVE_UI.uiid = "7404398618605197554";
INTERACTIVE_UI.name = "Interactive UI";
INTERACTIVE_UI.elements = {uiid = "7404398618605197554"}
local elements_mt = {__index = function(self,key)    return self.uiid .."_"..key end};
INTERACTIVE_UI.elements = setmetatable(INTERACTIVE_UI.elements,elements_mt);

INTERACTIVE_UI["desc"]  = INTERACTIVE_UI.elements[3];
INTERACTIVE_UI["btndes"]   = INTERACTIVE_UI.elements[2];
INTERACTIVE_UI["btn"]   = INTERACTIVE_UI.elements[1];
