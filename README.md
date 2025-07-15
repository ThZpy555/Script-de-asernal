-- SARANY SCRIPT PRO FINAL v8 by ThZy 💥
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI BASE
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "SaranyScript"

-- FRAME PRINCIPAL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.Active = true
frame.Draggable = true

-- RGB Toggle
local title = Instance.new("TextButton", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ Sarany Script ⚡"
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.AutoButtonColor = false

-- RGB Cor
coroutine.wrap(function()
	local r, g, b = 255, 0, 0
	while true do
		for i = 0, 255, 5 do
			title.TextColor3 = Color3.fromRGB(255, i, 0)
			wait(0.03)
		end
		for i = 255, 0, -5 do
			title.TextColor3 = Color3.fromRGB(i, 255, 0)
			wait(0.03)
		end
		for i = 0, 255, 5 do
			title.TextColor3 = Color3.fromRGB(0, 255, i)
			wait(0.03)
		end
		for i = 255, 0, -5 do
			title.TextColor3 = Color3.fromRGB(0, i, 255)
			wait(0.03)
		end
	end
end)()

-- CONTAINER
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1

-- NOTIFICAÇÃO
local notify = Instance.new("TextLabel", frame)
notify.Size = UDim2.new(1, 0, 0, 25)
notify.Position = UDim2.new(0, 0, 1, -25)
notify.BackgroundTransparency = 1
notify.Text = ""
notify.TextColor3 = Color3.fromRGB(0, 255, 100)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14

-- Toggle Mostrar/Ocultar
local menuVisible = true
title.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	content.Visible = menuVisible
	if menuVisible then
		frame.Size = UDim2.new(0, 250, 0, 350)
	else
		frame.Size = UDim2.new(0, 180, 0, 40)
	end
end)

-- CRÉDITOS
local credit = Instance.new("TextLabel", content)
credit.Size = UDim2.new(1, 0, 0, 40)
credit.Position = UDim2.new(0, 0, 1, -40)
credit.Text = "Criador: ThZy"
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(255,255,255)
credit.Font = Enum.Font.Gotham
credit.TextSize = 13

-- botão genérico
local function makeButton(text, posY, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(function()
		callback()
	end)
	return btn
end

-- ESP Linha
local connections = {}
local function clearESP()
	for _, obj in pairs(connections) do
		if obj.draw then pcall(function() obj.draw:Remove() end) end
		if obj.conn then obj.conn:Disconnect() end
	end
	connections = {}
end

local function createESPLine(color)
	clearESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local part = player.Character.HumanoidRootPart
			local line = Drawing.new("Line")
			line.Color = color
			line.Thickness = 2
			line.Transparency = 1

			local conn = RunService.RenderStepped:Connect(function()
				if part and part:IsDescendantOf(workspace) then
					local pos, visible = Camera:WorldToViewportPoint(part.Position)
					if visible then
						line.Visible = true
						line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						line.To = Vector2.new(pos.X, pos.Y)
					else
						line.Visible = false
					end
				else
					line:Remove()
					conn:Disconnect()
				end
			end)
			table.insert(connections, {draw = line, conn = conn})
		end
	end
end

-- ESP Caixa
local function createBoxESP()
	clearESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local part = player.Character.HumanoidRootPart
			local box = Drawing.new("Square")
			box.Color = Color3.fromRGB(255, 255, 255)
			box.Thickness = 2
			box.Filled = false

			local conn = RunService.RenderStepped:Connect(function()
				if part and part:IsDescendantOf(workspace) then
					local pos, onscreen = Camera:WorldToViewportPoint(part.Position)
					if onscreen then
						local size = Vector2.new(50, 80)
						box.Size = size
						box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
						box.Visible = true
					else
						box.Visible = false
					end
				else
					box:Remove()
					conn:Disconnect()
				end
			end)
			table.insert(connections, {draw = box, conn = conn})
		end
	end
end

-- ESP Nome
local function createNameESP()
	clearESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local text = Drawing.new("Text")
			text.Color = Color3.fromRGB(255,255,255)
			text.Size = 16
			text.Center = true
			text.Outline = true
			text.Text = player.Name

			local conn = RunService.RenderStepped:Connect(function()
				if head and head:IsDescendantOf(workspace) then
					local pos, onscreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,2,0))
					if onscreen then
						text.Position = Vector2.new(pos.X, pos.Y)
						text.Visible = true
					else
						text.Visible = false
					end
				else
					text:Remove()
					conn:Disconnect()
				end
			end)
			table.insert(connections, {draw = text, conn = conn})
		end
	end
end

-- Aimbot e Speed
local aimbot = false
local speed = false
local function notifyText(msg)
	notify.Text = msg
	wait(1.5)
	notify.Text = ""
end

makeButton("Toggle Aimbot", 0, function()
	aimbot = not aimbot
	notifyText("Aimbot " .. (aimbot and "Ativado ✅" or "Desativado ❌"))
end)

makeButton("Toggle Speed", 40, function()
	speed = not speed
	if speed then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
	else
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
	end
	notifyText("Speed " .. (speed and "Ativado ✅" or "Desativado ❌"))
end)

makeButton("ESP Linhas", 80, function() createESPLine(Color3.fromRGB(0,255,255)) end)
makeButton("ESP Caixa", 120, function() createBoxESP() end)
makeButton("ESP Nome", 160, function() createNameESP() end)

-- Loop Aimbot
RunService.RenderStepped:Connect(function()
	if aimbot then
		local closest = nil
		local shortest = math.huge
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local h = p.Character.Head
				local d = (h.Position - Camera.CFrame.Position).Magnitude
				if d < shortest then
					shortest = d
					closest = h
				end
			end
		end
		if closest then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
		end
	end
end)
