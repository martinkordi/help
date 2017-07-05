--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision 76561220911156511
--]]

local PANEL = {}
	surface.CreateFont("cnChatFont", {
		font = "Tahoma",
		size = 16,
		weight = 800
	})

	function PANEL:Init()
		cnPanels.quest = self

		self:SetSize(640, 320)
		self:Center()
		self:SetPos(self.x, ScrH() * 0.6)
		self:MakePopup()

		self.top = self:Add("DPanel")
		self.top:SetTall(180)
		self.top:Dock(TOP)

		local LEFT_ANGLE = Angle(0, 70, 0)
		local RIGHT_ANGLE = Angle(0, 20, 0)
		local lastUpdate = 0
		local realTime

		self.model = self.top:Add("DModelPanel")
		self.model:Dock(LEFT)
		self.model:SetWide(128)
		self.model:SetModel(LocalPlayer():GetModel())
		self.model:SetFOV(20)
		self.model.LayoutEntity = function(this, entity)
			realTime = RealTime()

			entity:FrameAdvance(realTime - lastUpdate)
			entity:SetAngles(LEFT_ANGLE)

			lastUpdate = realTime
		end
		self.model.Entity:SetIK(false)

		self.me = self.top:Add("DModelPanel")
		self.me:Dock(RIGHT)
		self.me:SetWide(128)
		self.me:SetModel(LocalPlayer():GetModel())
		self.me:SetFOV(20)
		self.me.LayoutEntity = function(this, entity)
			entity:SetAngles(RIGHT_ANGLE)
		end
		self.me.Entity:SetPos(self.me.Entity:GetPos() - Vector(0, 0, 16))
		self.me.Entity:SetIK(false)
		self.me.Entity.GetPlayerColor = function()
			return LocalPlayer():GetPlayerColor()
		end
		self.me.Entity:SetEyeTarget(Vector(60, 0, 42))

		self.scroll = self.top:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll:DockMargin(4, 4, 4, 4)
		self.scroll.VBar:SetWide(0)

		self.options = self:Add("DScrollPanel")
		self.options:Dock(FILL)
		self.options:SetDrawBackground(true)
		self.options:DockMargin(0, 4, 0, 0)
		self.options:SetBackgroundColor(Color(0, 0, 0, 125))
		self.options:DockPadding(2, 2, 2, 2)
	end

	function PANEL:addOption(text, callback, isLeave)
		local button = self.options:Add("DButton")
		button:Dock(TOP)
		button:SetTall(28)
		button:SetText(text)
		button:DockMargin(2, 2, 2, 0)

		if (isLeave) then
			button.DoClick = function() self:Remove() end
		else
			button.DoClick = function()
				self:clear()
				self:addText(text, true, function()
					if (callback) then
						callback()
					end
				end)
			end
		end

		return button
	end

	function PANEL:clear()
		self.options:Clear(true)
	end

	function PANEL:setup(uniqueID)
		local data = cnQuests[uniqueID]

		if (!data) then
			return self:Remove()
		end

		self.model:SetModel(self.entity:GetModel())

		local found = false

		for k, v in ipairs(self.model.Entity:GetSequenceList()) do
			if (v:lower():find("idle") and v != "idlenoise") then
				self.model.Entity:ResetSequence(k)
				found = true

				break
			end
		end

		if (!found) then
			self:ResetSequence(4)
		end

		self.model.Entity:SetPos(self.model.Entity:GetPos() - Vector(0, 0, 17))
		self.model.Entity:SetEyeTarget(Vector(-60, 0, 42))

		if (data.color) then
			self.model.Entity.GetPlayerColor = function()
				return data.color
			end
		end

		self:SetTitle(data.name)
	end

	local COLOR_OTHER = Color(236, 236, 236)
	local COLOR_ME = Color(65, 160, 250)

	function PANEL:addText(text, fromMe, callback)
		if (!text) then
			return
		end
		
		if (fromMe) then
			text = "<color=250,250,250>"..text.."</color>"
		end

		local object = markup.Parse("<font=cnChatFont><color=50,50,50>"..text.."</font>", 240)
		local w, h = object:Size()
		local x = fromMe and (364 - (w + 10)) or 0

		self.lastY = self.lastY or 0

		local panel = self.scroll:Add("DPanel")
		panel:SetPos(x + (fromMe and (w + 10) or -(w + 10)), self.lastY)
		panel:SetSize(w + 10, h + 10)
		panel:SetBackgroundColor(fromMe and COLOR_ME or COLOR_OTHER)
		panel:SetAlpha(0)
		panel:AlphaTo(255, 0.25)
		panel:MoveTo(x, self.lastY, 0.2, 0, -1, function()
			timer.Simple(0.75, function()
				if (IsValid(self) and callback) then
					callback()
				end
			end)
		end)

		local text = panel:Add("DPanel")
		text:SetPos(5, 5)
		text:SetSize(w, h)
		text.Paint = function(this, w, h)
			object:Draw(0, 0, 0, 0)
		end
		text:CenterVertical()

		self.lastY = self.lastY + panel:GetTall() + 4
		self.scroll:ScrollToChild(panel)

		if (fromMe) then
			LocalPlayer():EmitSound("friends/friend_join.wav", 30, 180)
		else
			LocalPlayer():EmitSound("friends/message.wav", 30, 180)
		end

		return panel
	end

	function PANEL:OnRemove()
		if (IsValid(self.entity)) then
			net.Start("npcClose")
			net.SendToServer()
		end
	end
vgui.Register("cnQuest", PANEL, "DFrame")