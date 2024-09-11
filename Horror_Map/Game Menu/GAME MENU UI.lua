GAME_MENU = {}
GAME_MENU.UI= {uiid = "7411360567318485234"}
GAME_MENU_UI_mt = {
    __index = function(self,index)
        if rawget(GAME_MENU.UI,index) == nil then 
            return self.uiid.."_"..tostring(index);
        else
            return rawget(GAME_MENU.UI,index)
        end 
    end
}
-- Set the UI meta table 
GAME_MENU.UI = setmetatable(GAME_MENU.UI, GAME_MENU_UI_mt);

-- Try 
print(GAME_MENU.UI[1]);