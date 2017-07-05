--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision 76561220911156511
--]]

cnQuests = cnQuests or {}

local _, folders = file.Find("cn_npcs/*", "LUA")

for k, v in ipairs(folders) do
	NPC = {uniqueID = v}
		if (SERVER) then
			include("cn_npcs/"..v.."/sv_init.lua")
			AddCSLuaFile("cn_npcs/"..v.."/cl_init.lua")
		else
			include("cn_npcs/"..v.."/cl_init.lua")
		end

		if (SERVER) then
			function NPC:send(client, uniqueID, ...)
				local entity = client.cnQuest

				if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 128) then
					return
				end

				net.Start("npcData")
					net.WriteString(uniqueID)
					net.WriteString(self.uniqueID)
					net.WriteTable({...})
				net.Send(client)
			end

			function NPC:close(client)
				local entity = client.cnQuest

				if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 128) then
					return
				end

				net.Start("npcClose")
					net.WriteString(self.uniqueID)
				net.Send(client)

				client.cnQuest = nil
			end
		else
			function NPC:addText(text, fromMe)
				local panel = cnPanels.quest

				if (IsValid(panel)) then
					return panel:addText(text, fromMe)
				end
			end

			function NPC:addOption(text, callback)
				local panel = cnPanels.quest

				if (IsValid(panel)) then
					return panel:addOption(text, callback)
				end
			end

			function NPC:clear()
				local panel = cnPanels.quest

				if (IsValid(panel)) then
					return panel:clear()
				end				
			end

			function NPC:send(uniqueID, ...)
				net.Start("npcData")
					net.WriteString(uniqueID)
					net.WriteString(self.uniqueID)
					net.WriteTable({...})
				net.SendToServer()
			end

			function NPC:addLeave(text)
				local panel = cnPanels.quest

				if (IsValid(panel)) then
					return panel:addOption(text or "<Leave>", nil, true)
				end				
			end

			function NPC:close()
				local panel = cnPanels.quest

				if (IsValid(panel)) then
					panel:Remove()
				end
			end
		end

		cnQuests[v] = NPC
	NPC = nil
end