--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision 76561220911156511
--]]

cnPanels = cnPanels or {}

include("cl_quest.lua")

net.Receive("npcOpen", function()
	local index = net.ReadUInt(14)
	local entity = Entity(index)

	if (!IsValid(entity)) then
		return
	end

	local uniqueID = entity:GetQuest()
	
	if (!cnQuests[uniqueID]) then
		return
	end

	if (cnQuests[uniqueID].shop) then
		local shop = vgui.Create("cnShop")
		shop:setup(cnQuests[uniqueID].shop)
		shop.entity = entity
	else
		vgui.Create("cnQuest")

		cnPanels.quest.entity = entity
		cnPanels.quest.questID = uniqueID
		cnPanels.quest:setup(uniqueID)

		if (cnQuests[uniqueID].onStart) then
			cnQuests[uniqueID]:onStart()
		end
	end
end)

net.Receive("npcData", function()
	local uniqueID = net.ReadString()
	local questID = net.ReadString()
	local arguments = net.ReadTable()
	local panel = cnPanels.quest

	if (!IsValid(panel) or panel.questID != questID) then
		return
	end

	local data = cnQuests[panel.questID]

	if (data and type(data["on"..uniqueID]) == "function") then
		data["on"..uniqueID](data, unpack(arguments))
	end
end)

net.Receive("npcClose", function()
	local questID = net.ReadString()
	local panel = cnPanels.quest

	if (IsValid(panel) and panel.questID == questID) then
		panel:Remove()
	end
end)