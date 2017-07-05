-- This sets the model for the NPC.
NPC.model = "models/player/hydro/swbf_imperial_officer_isbofficer/swbf_imperial_officer_isbofficer.mdl"
-- This is for player models that support player colors. The values range from 0-1.
NPC.color = Vector(1, 0, 0)

-- This receives the ignite message from cl_init.lua
-- client is the player that sent the message.
-- As you can see, the seconds argument is available.
function NPC:onIgnite(client, seconds)
	client:Ignite(tonumber(seconds) or 5)
end