local function addActDescription(id, str , icon , thumb)
    act[id].description = str;
    if icon == nil then icon = [[10287]] end 
    act[id].icon = icon;
    if thumb ~= nil then 
        act[id].thumb = thumb;
    end 
end;

addActDescription(
    "FireBall",
    [[Shoot a fireball at the target. Each fireball deals 110% of your total magic attack to enemies within a 3-block radius. It leaves a burning area that deals 10% of your total magic attack every millisecond.]]
    , [[8_1029380338_1719587451]] , [[8_1029380338_1719148067]]
)
addActDescription(
    "FireBird",
    [[Cast an explosion at the target position. It leaves a large burning area that deals 110% of your total magic attack every millisecond within a 10-block radius.]]
    ,[[8_1029380338_1719587640]]
)
addActDescription(
    "FireDash",
    [[Dash forward and leave a trail of fire that deals 180% of your total magic attack every millisecond.]]
    ,[[8_1029380338_1719587655]]
)
addActDescription(
    "IceLance",
    [[Shoot an ice lance at the target. Each lance deals 35 + 90% of your total magic attack. When it hits the ground, it creates an ice block that explodes and freezes enemies within a 3-block radius.]]
    ,[[8_1029380338_1719587667]] , [[8_1029380338_1719148085]]
)
addActDescription(
    "IceBreath",
    [[Breathe out a cold mist that slows and damages enemies in front of you.]]
    ,[[8_1029380338_1719587739]]
)
addActDescription(
    "IceGlacier",
    [[Transform yourself into a glacier of ice, recovering to full health. While in this form, you cannot cast Ice Lance or Ice Breath.]]
    ,[[8_1029380338_1719587747]]
)
addActDescription(
    "ThunderStorm",
    [[Strike double thunder at the target, dealing 500% of your total magic attack to enemies within a 5-block radius.]]
    ,[[8_1029380338_1719587784]] , [[8_1029380338_1719148114]]
)
addActDescription(
    "ThunderDash",
    [[Dash to the aimed position. Can change direction according to aim position while dashing, allowing curved dashes. Instantly hit nearby enemies with a thunder strike that deals 50% of your total magic attack.]]
    ,[[8_1029380338_1719587777]]
)
addActDescription(
    "ThunderBuff",
    [[Gain a buff that alternates instant cooldowns for Thunderstorm and ThunderDash each second.]]
    ,[[8_1029380338_1719587872]]
)
addActDescription(
    "PowerUp",
    [[Gain a buff that resets Skill 1 and Skill 2 instantly each second and doubles your current HP after a period of time.]]
    ,[[8_1029380338_1719587887]] , [[8_1029380338_1719148174]]
)
addActDescription(
    "PowerDash",
    [[Dash to the designated position and deal 200% total physical attack + 60% total HP when landing. Alternatively, when in the air, deal 350% total physical attack + 60% total HP when landing.]]
    ,[[8_1029380338_1719837454]]
)
addActDescription(
    "PowerPunch",
    [[Instantly punch anything in front of you, dealing 300% total physical attack + 40% total HP, and knocking back enemies.]]
    ,[[8_1029380338_1719587901]]
)
addActDescription(
    "Sword100",
    [[Shoot multiple swords that deal 120% physical attack + 80% magic attack within a 3-block radius.]]
    ,[[8_1029380338_1719587932]] , [[8_1029380338_1719148133]]
)
addActDescription(
    "HighAndLow",
    [[Dash to every target in the aim area and release a slash that deals 450% physical damage + 50% magic attack.]]
    ,[[8_1029380338_1719587945]]
)
addActDescription(
    "ExtraSlash",
    [[Pull everyone within a 12-block radius towards you, dealing damage while pulling. At the end, instantly stun and deal 100% physical attack damage to a nearby 4-block area.]]
    ,[[8_1029380338_1719587953]]
)
addActDescription(
    "GravityBind",
    [[Throw everyone within a 12-block radius into the air, then pull them to the ground, dealing 250% magic attack as fall damage and an additional 250% magic damage.]]
    ,[[8_1029380338_1719587966]]   , [[8_1029380338_1719148190]]
)
addActDescription(
    "GravityMass",
    [[Instantly change the mass of gravity in the target area within a 4-block radius, dealing 100% magic attack.]]
    ,[[8_1029380338_1719587977]]
)
addActDescription(
    "GravityJump",
    [[Dash to the aimed position while slowly rising into the air. The farther you dash, the more the cooldown of Gravity Bind and Gravity Mass is reduced.]]
    ,[[8_1029380338_1719587988]]
)

-- addActDescription(
--     "",
--     [[]]
-- )
-- addActDescription(
--     "",
--     [[]]
-- )
-- addActDescription(
--     "",
--     [[]]
-- )