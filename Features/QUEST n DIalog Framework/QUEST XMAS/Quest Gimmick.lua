HX_Q:CREATE_QUEST(76,{
    name = "Shop" , dialog = "Let's See What you have.",
    [1] = function(p)
        return true;
    end, ["END"] = function(p)
        local Shop_UI = "7378748279344535794";
        Player:openUIView(p,Shop_UI);
    end
})