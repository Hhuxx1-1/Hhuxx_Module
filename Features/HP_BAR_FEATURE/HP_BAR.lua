-- Constants and Settings
local hpbar = {}
local le = {}
local color = {}
local Symbol = "▀"
local thresholds = {100, 300, 800, 1200, 2800, 5600, 14600, 39000, 90000}
local le_divisors = {15, 30, 45, 60, 75, 200, 250, 300, 400}
local colors = {"#c8DFF7E", "#c8DFF7E", "#c008324", "#cA79800", "#cF4FF3E", "#c9B000A", "#cFF0900", "#c0004FF", "#c000000"}

-- Functions
local function getHPBarLengthAndColor(v2)
    local length, hp_color = 5, "#c00FFFC"
    for i, threshold in ipairs(thresholds) do
        if v2 >= threshold then
            length = math.floor(v2 / le_divisors[i])
            hp_color = colors[i]
        end
    end
    return length, hp_color
end

local function createHPBar(v1, v2, length, hp_color)
    local filled_length = math.floor(v1 / v2 * length)
    local empty_length = length - filled_length
    local hp_bar = ""

    -- Filled part
    for _ = 1, filled_length do
        hp_bar = hp_bar .. Symbol
    end

    -- Empty part with a gray color
    for _ = 1, empty_length do
        hp_bar = hp_bar .. "#c555555" .. Symbol
    end

    return hp_bar, filled_length >= 0
end

local lastUpdateTime = {}

local function updateNickname(obj_id, name, hp_bar, color, current_hp)
    -- Update nickname display
    Actor:setnickname(obj_id, "#W▶" .. name .. "[ " .. current_hp .. " ]\n #W╚" .. "#b" ..  hp_bar .. "\n\n", true)
    threadpool:wait(0.3)
    Actor:setnickname(obj_id, "#W▶" .. name .. "[ " .. current_hp .. " ]\n╚" .. color .. " " .. hp_bar .. "\n\n")
    -- Update last hit timestamp
    lastUpdateTime[obj_id] = os.time()

    -- Delay clearing nickname only if not hit again
    threadpool:delay(3, function()
        if os.time() - lastUpdateTime[obj_id] >= 3 then
            Actor:setnickname(obj_id, "") -- Clear nickname after 3 seconds of no updates
        end
    end)
end


local function handleAttackEvent(e, obj_id)
    local r1, v1 = Creature:getAttr(obj_id, 2)
    local r2, v2 = Creature:getAttr(obj_id, 1)
    local r3, name = Creature:getActorName(obj_id)
    local rr , actorid = Creature:getActorID(obj_id)
    local r4, real_name = Creature:GetMonsterDefName(actorid)
    print("handling Attack event name : ",name," real Name = ",real_name)
    if name == nil then 
        name = real_name;
    end 
    -- Calculate HP bar length and color
    le[obj_id], color[obj_id] = getHPBarLengthAndColor(v2)
    
    -- Create HP bar
    local hp_bar, has_hp = createHPBar(v1, v2, le[obj_id], color[obj_id])
    local current_hp = math.floor(v1)

    -- Update nickname with HP bar
    if has_hp then
        Actor:shownickname(obj_id, true)
        updateNickname(obj_id, name, hp_bar, color[obj_id], current_hp)
    else 
        Actor:setnickname(obj_id, "")
    end
end

ScriptSupportEvent:registerEvent("Actor.ChangeAttr", function(e)
    handleAttackEvent(e,e.eventobjid);
end)
ScriptSupportEvent:registerEvent("Player.AttackHit", function(e)
    handleAttackEvent(e,e.toobjid);
end)
