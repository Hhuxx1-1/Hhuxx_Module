local claim_button = "7443381674518976754_7";
ScriptSupportEvent:registerEvent("UI.Button.Click",function(e) 
    local btn = e.uielement
    local playerid = e.eventobjid;
    if btn == claim_button then 
        -- get Both Value from Varlib 
        local r , V1 = VarLib2:getPlayerVarByName(playerid, 3, "InvitedFriend1")
        local r , V2 = VarLib2:getPlayerVarByName(playerid, 3, "InvitedFriend2")
        
        if V2 < V1 then 
           if GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",(V1-V2)*100) then 
                VarLib2:setPlayerVarByName(playerid,3,"InvitedFriend2",V1);
           end 
        else
            Player:notifyGameInfo2Self(playerid,"Invite Friend to Get Rewards!")
        end 
        
    end 
end)