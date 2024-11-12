local uiid, uiid_values = {}, "7425660961578227954"  -- The base string representation

setmetatable(uiid, {
    __tostring = function()
        return uiid_values  -- When uiid is used as a string
    end,
    __index = function(_, key)
        return uiid_values .. "_" .. tostring(key)  -- When accessing uiid as a table with an index
    end,
    __call = function(self, arg1, arg2)
        if type(arg1) == "string" and arg2 == nil then 
            return rawget(uiid, arg1)
        elseif type(arg1) == "number" and arg2 ~= nil and type(arg2) == "string" then
            self[arg2] = uiid_values .. "_" .. arg1
            return (self[arg2])
        elseif arg1 == nil and arg2 == nil then 
            return uiid_values
        else
            Player:notifyGameInfo2Self(0, "WRONG USAGE!")
            print("Wrong Usage at calling DailyChecking")
        end
    end
})

uiid(10, "Date")
uiid(7, "Name")
uiid(9, "Job")
uiid(14, "Currency_Icon")
uiid(15, "Currency_Ammount")
uiid(16, "Ok_Btn")
uiid(12, "Avatar_Image")

local minimum_pay = 50;

-- GLOBAL_PAYCHECK stores player's paycheck data
GLOBAL_PAYCHECK = setmetatable({}, {
    __call = function(self, playerid, method, amount)
        -- Initialize player paycheck if not present
        if self[playerid] == nil then
            self[playerid] = minimum_pay;
        end

        if method == nil then
            Player:notifyGameInfo2Self(playerid, "Wrong Usage")
            return
        end

        -- Handle method logic
        if method == "Add" then
            if type(amount) == "number" then
                self[playerid] = self[playerid] + amount
            else
                Player:notifyGameInfo2Self(playerid, "Invalid amount for Add")
            end
        elseif method == "Set" then
            if type(amount) == "number" then
                self[playerid] = amount
            else
                Player:notifyGameInfo2Self(playerid, "Invalid amount for Set")
            end
        elseif method == "Get" then
            return self[playerid]
        elseif method == "Double" then
            self[playerid] = self[playerid] * 2
        else
            Player:notifyGameInfo2Self(playerid, "Unknown method: " .. method)
        end
    end
})

-- Check-in function to update UI elements
local function checkin(playerid)
    -- Set the Date
    local code, timestr = World:getLocalDateString()
    if code == 0 then
        Customui:setText(playerid, uiid(), uiid("Date"), timestr)
    end
    
    -- Set The Name
    local code, name = Player:getNickname(playerid)
    if code == 0 then
        Customui:setText(playerid, uiid(), uiid("Name"), "Name : " .. name);
        Customui:setText(playerid, uiid(), uiid("Job"), "Job : Zoo Keeper ");
    end
    
    -- Set the avatar
    local code, iconid = Customui:getRoleIcon(playerid)
    if code == 0 then
        Customui:setTexture(playerid, uiid(), uiid("Avatar_Image"), iconid)
    end
    
    -- Set the paycheck amount
    local amount = GLOBAL_PAYCHECK(playerid, "Get")
    Customui:setText(playerid, uiid(), uiid("Currency_Ammount"),tostring(amount).." Coins ");
end

-- Event handling to check-in player when UI is shown
ScriptSupportEvent:registerEvent("UI.Show", function(e)
    if e.CustomUI == uiid() then
        local playerid = e.eventobjid
        checkin(playerid)
    end
end)

local function playEffectCoin(playerid)
    local r,x,y,z = Actor:getPosition(playerid)
    World:playSoundEffectOnPos({x=x,y=y,z=z}, 10963, math.random(4,9)*10, 1, false);
        -- play Particle Effects
    World:playParticalEffect(x,y,z, 1321, 1);
end

local function getPaycheck(playerid)
    -- add Currency 
    if GLOBAL_CURRENCY:AddCurrency(playerid,"Coin",GLOBAL_PAYCHECK(playerid, "Get")) then 
        playEffectCoin(playerid);
        GLOBAL_PAYCHECK(playerid,"Set",minimum_pay);
    end 
end

-- LETS Get Little Crazy 
ScriptSupportEvent:registerEvent("UI.Hide",function(e)
    if e.CustomUI == uiid() then
        local playerid = e.eventobjid
        getPaycheck(playerid)
    end
end)