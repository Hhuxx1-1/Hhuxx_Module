-- LUA LOGGER
-- It just Output Anything into Text into Game UI 
LOGGER = {};
LOGGER.STAT = false;
LOGGER.NOW = "";
LOGGER.LOG = function (...)
    if(LOGGER.STAT)then 
    local args = {...}
    local logMessage = ""

    for i = 1, #args do
        logMessage = logMessage .. tostring(args[i]) .. " "
    end

    -- Trim the trailing space
    logMessage = logMessage:sub(1, -2)

    -- Output the log message as a string
    LOGGER.NOW = LOGGER.NOW..logMessage;
    else 
    LOGGER.NOW = "";
    end 
end

LOGGER.UPDATE = function()
    local logMSG = LOGGER.NOW;
    Customui:setText(1029380338, "7398802323463149810", "7398802323463149810_1", logMSG);
end

LOGGER.RESET = function()
    LOGGER.NOW = "";
end


ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=],function(e)
    local playerid = e.eventobjid;
    local Admin = 1029380338;
    local content = e.content;
    if(playerid==Admin)then 
        if (content=="LOG:OPEN") then
            Player:openUIView(Admin,[[7398802323463149810]]);
        end
        if (content=="LOG:UPDATE")then 
            LOGGER.UPDATE();
        end 
        if (content=="LOG:RESET")then 
            LOGGER.RESET();
        end
        if (content=="LOG:SHUTDOWN")then 
            local code  = CloudSever:CloseCurRoom(5,"The Admin Requested the Room to Closed")
                if code == ErrorCode.OK then
                print('OK Shutdown'  )
                else
                print('NO Shutdown')
                end
        end 
        if (content=="LOG:START")then 
            LOGGER.STAT= true;
        end 
        if (content == "LOG:GAME_END")then 
            Game:doGameEnd(nil)
        end 
        if (string.sub(content,1,7)=="LOG:MSG")then 
            Game:msgBox(string.gsub(content,"LOG:MSG",""));
        end 
        if (string.sub(content,1,7)=="LOG:KIL")then 
            local econ = tonumber(string.gsub(content,"LOG:MSG",""));
            Actor:killSelf(econ);
        end 
    end 
end)