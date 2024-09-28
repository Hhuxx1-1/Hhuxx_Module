
GLOBAL_LEVER.REGISTER(-141,22,47,814,function()
    Chat:sendSystemMsg("Hello Door")
    local r , isActive = Block:getBlockSwitchStatus({x=-141,y=22,z=47});
    print(" Door is :",r,isActive)
    -- local r = Block:setBlockSwitchStatus({x=-141,y=22,z=47}, not isActive);
    -- local r = Block:setBlockSwitchStatus({x=-141,y=21,z=47}, not isActive);
    if not isActive then 
        OpenDoor(-141,21,47)
   end 
end)

GLOBAL_LEVER.REGISTER(-140,22,46,GLOBAL_LEVER.TYPE.Stone_Button,
function(e)
    local playerid = e.playerid;
    Chat:sendSystemMsg("Hello From a Button to "..playerid);
    OpenSideDoor(-140,21,46);
end,{})