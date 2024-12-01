local r , LightGate =  Area:createAreaRectByRange({x=-14,y=7,z=475},{x=-10,y=9,z=487});


ScriptSupportEvent:registerEvent("Player.AreaIn",function(e)
    local playerid,areaid = e.eventobjid,e.areaid;
    if areaid == LightGate then 
        if HX_Q:GET(playerid,"DEFEATED_HOUND") == "TRUE" then
            set2FarPosition(playerid,-151,7,-206)
        end 
    end 
end)

-- local UnkowuMing = 1004052466 ;

-- ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
--     local playerid = e.eventobjid;
--     if playerid == UnkowuMing then 
--        GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",9999999);
--        CUTSCENE:start(playerid,"SKIBIDI_CAT");
--        GLOBAL_SHOP:openSpecialDiscountShop(playerid,[[Weapon_1_Shop]],100);
--     end 
-- end)





