ScriptSupportEvent:registerEvent("Game.Start",function()
    HX_Q:CREATE_QUEST(2,{
    name = "none", dialog = "Can You Kick Out Those Wolves? I'll Give you the Key",
    hint = {x=70,y=7,z=0},
    [1] = function(playerid)
        -- print("this is function for requirement needed")
        -- print("this is quest don't have any requirements")
        local santaKey = HX_Q:GET("santaKey");
        if santaKey ~= "Empty" then 
            return false;
        else 
            return true;
        end 

    end,
    [2] = function(playerid)
        -- print("This function will starting to keep executed when the quest is accepted"); 
        -- until it return true and execute the 3rd function once 
            local proggress = HX_Q:GET(playerid,"a_default_wolves_jackal");
            if proggress == "Empty" then HX_Q:SET(playerid,"a_default_wolves_jackal",0); proggress = 0 end;
            local max = 5;
            if proggress >= max then
                return true;
            else 
                HX_Q:SHOW_QUEST(playerid,{
                    name = "Training", text = "Defeat Wolves ("..proggress.."/"..max..")",pic = "3003914",open = true;
                })
            end 
    end,
    [3] = function(playerid)
        -- print("This function is executed once")
        if HX_Q:SET_CurQuest(playerid,"tutorial") then 
            Chat:sendSystemMsg("Go Talk to Santa Minion Again",playerid)
            HX_Q:SHOW_QUEST(playerid,{
                open = false;
            })
            HX_Q:SET(playerid,"a_default_wolves_jackal",0);
        end 
    end
    });

    HX_Q:CREATE_QUEST(2,{
        name = "tutorial", dialog = "Here is the Key",
        hint = {x=70,y=7,z=0},
        [1] = function(playerid)
            -- print("this is function for requirement needed")
            -- print("this is quest don't have any requirements")
            local santaKey = HX_Q:GET("santaKey");
            if santaKey ~= "True" then 
                return true;
            end 
        end,
        [2] = function(playerid)
            return true;
        end,
        [3] = function(playerid)
            -- print("This function is executed once")
            if HX_Q:SET_CurQuest(playerid,"Begginer") then 
                HX_Q:SET(playerid,"SantaKey","True");
                HX_Q:ShowReward(playerid,[[1004125]],"Santa's Key",[[Key to Access Santa's House. Can be Obtained trough Finishing 1st Quest Tutorial]])
            end 
        end
    });


    HX_Q:CREATE_QUEST(28,{
        name = "none", dialog = "Christmas is Now on Danger. You have to find Santa and Help to Save this Year",
        hint = {x=88,y=8,z=18},
        [1] = function(playerid)
            if HX_Q:GET_CurQuest(playerid) == "none" then 
                return true;
            end 
        end,
        [2] = function(playerid)
            local door = {x=88,y=8,z=18};
            local r,x,y,z = Actor:getPosition(playerid)
            local calculate_distance = function(px, py, pz, x, y, z)
                return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
            end
            local distance = math.floor(calculate_distance(x,y,z,door.x,door.y,door.z));

            if distance-5 < 0 then 
                HX_Q:SHOW_QUEST(playerid,{
                    open = false;
                })
                return true;
            else 
                HX_Q:SHOW_QUEST(playerid,{
                    name = "Find Santa", text = "Find Santa ("..distance.." Block Far )",pic = [[3003013]],open = true,detail = "Tap for Hint";
                })
            end 
        end,
        [3] = function(playerid)
            Chat:sendSystemMsg("Talk to Santa's Minion");
        end
    })

    HX_Q:CREATE_QUEST(0,{
        name = "none", dialog = "";
        hint = {x=0,y=7,z=18},
        [1] = function(playerid)
            return true;
        end,
        [2] = function(playerid)
            local r,x,y,z = Actor:getPosition(playerid)
            local calculate_distance = function(px, py, pz, x, y, z)
                return math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
            end
            local distance = math.floor(calculate_distance(x,y,z,0,7,18));
            if distance-5 < 0 then 
                HX_Q:SHOW_QUEST(playerid,{
                    open = false;
                })
                return true;
            else 
                HX_Q:SHOW_QUEST(playerid,{
                    name = "Talk to Minicaptain" , text = "Talk to Minicaptain ("..distance.." Block Far )",pic = [[5000004]],open = true,detail = "Tap for Hint";
                })
            end 
        end,
        [3] = function(playerid)    
            Chat:sendSystemMsg("Talk to Mini Captain");
        end 
    })
end)

ScriptSupportEvent:registerEvent("Player.DefeatActor",function(e)
    local playerid,target,actorid = e.eventobjid, e.toobjid, e.targetactorid;
    if HX_Q.CURRENT_QUEST[playerid] then 
        if HX_Q.CURRENT_QUEST[playerid].name == "none" and actorid == 32 then 
            local curProggress = HX_Q:GET(playerid,"a_default_wolves_jackal");
            HX_Q:SET(playerid,"a_default_wolves_jackal",curProggress + 1 );
        end 
    end 
end)

ScriptSupportEvent:registerEvent("Game.AnyPlayer.EnterGame",function(e)
    local playerid = e.eventobjid;
    if HX_Q.CURRENT_QUEST[playerid]  == nil then
        if HX_Q:GET_CurQuest(playerid) == "none" then 
            CUTSCENE:start(playerid,"FIRST_START")
            HX_Q.CURRENT_QUEST[playerid] = HX_Q.NPC_QUEST_DATA[0].none;
        end 
    end 
end)