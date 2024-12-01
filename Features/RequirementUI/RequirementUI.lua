local UI = {
    ui = "7443329619515349234",
    Title = "7443329619515349234_2",
    Desc = "7443329619515349234_20",
    R1 = {
        image = "7443329619515349234_4",
        check = "7443329619515349234_5",
        text = "7443329619515349234_7"
    },
    R2 = {
        image = "7443329619515349234_8",
        check = "7443329619515349234_10",
        text = "7443329619515349234_11"
    },
    R3 = {
        image = "7443329619515349234_12",
        check = "7443329619515349234_14",
        text = "7443329619515349234_15"
    },
    R4 = {
        image = "7443329619515349234_16",
        check = "7443329619515349234_18",
        text = "7443329619515349234_19"
    }
}
REQUIREMENT_UI = {}
function REQUIREMENT_UI:open(playerid,data)
    if data then 
        Player:openUIView(playerid,UI.ui);
        if data.title then 
            Customui:setText(playerid,UI.ui,UI.Title,data.title)
        end 
        if data.desc then 
            Customui:setText(playerid,UI.ui,UI.Desc,data.desc)
        end 
        for i = 1, 4 do 
            if data[i] then 
                Customui:showElement(playerid,UI.ui,UI["R"..i].image)
                local url = data[i].url 
                if url then
                    Customui:setTexture(playerid,UI.ui,UI["R"..i].image,url)
                end 

                local check = data[i].check
                if check then
                    Customui:showElement(playerid,UI.ui,UI["R"..i].check)
                else 
                    Customui:hideElement(playerid,UI.ui,UI["R"..i].check)
                end 
                

                local text = data[i].text
                if text then 
                    Customui:setText(playerid,UI.ui,UI["R"..i].text,text)
                end 
            else 
               Customui:hideElement(playerid,UI.ui,UI["R"..i].image)
            end 
        end 
    end 
end 
