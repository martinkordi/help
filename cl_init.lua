util.AddNetworkString("give_wep")

NPC.name = "Imperial Officer"
 
function NPC:onStart()
 
    self:addText("Hi, what do you need?")
    self:addOption("How do I get trained?", function()
        self:addText("Ask someone to train you by typing /comms I need trainer.")
        self:addLeave("Thanks!")
    end)
 
    self:addOption("How do I donate?", function()
        self:addText("Type !donate or !shop and you will see all information there. Be sure to read our TOS!")
        self:addLeave("Thanks!")
    end)
   
    self:addOption("How do I become one of the High Inquisitors or how do I become Commander?", function()
        self:addText("Type !website and look at our applications, there you can apply for them.")
        self:addLeave("Thanks!")
    end)
 
    self:addOption("I see a lot of errors, how do I fix that?", function()
        self:addText("Type !content in chat and subscribe to our content.")
        self:addLeave("Thanks!")
    end)
   
    self:addOption("I have a suggestion, where do I post it?", function()
        self:addText("Type !suggestions in chat and post a suggestion or post it on our forums by typing !website.")
        self:addLeave("Thanks!")
    end)
   
    self:addOption("I need a training weapon", function()
        net.Start("give_wep") net.SendToServer()
        self:addText("Here you go.")
        self:addLeave("Thanks!")
    end)
 
end