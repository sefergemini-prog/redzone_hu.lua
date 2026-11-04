-- Redzone Hub - MM2 Halloween Edition (Auto Farm Silindi)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local success, parentContainer = pcall(function()
	return CoreGui
end)
if not success or not parentContainer then
	parentContainer = LocalPlayer:WaitForChild("PlayerGui")
end

if parentContainer:FindFirstChild("RedzoneHubGui") then
	parentContainer.RedzoneHubGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RedzoneHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentContainer

-- Toggle Butonu
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 40)
toggleBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
toggleBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "🎃 Redzone Hub"
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

-- Ana Menü (Boyutu butonlara göre yeniden ayarlandı)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 360)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
title.TextColor3 = Color3.fromRGB(255, 140, 0)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Text = "🎃 REDZONE HUB [HALLOWEEN] 🎃"
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local espEnabled = false
local autoShootEnabled = false

local function getRole(player)
	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	
	if (character and character:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then
		return "Murderer"
	elseif (character and (character:FindFirstChild("Gun") or character:FindFirstChild("Revolver"))) or (backpack and (backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver"))) then
		return "Sheriff"
	else
		return "Innocent"
	end
end

local function getRoleColor(player)
	local role = getRole(player)
	if role == "Murderer" then
		return Color3.fromRGB(255, 0, 0)
	elseif role == "Sheriff" then
		return Color3.fromRGB(0, 150, 255)
	else
		return Color3.fromRGB(0, 255, 0)
	end
end

local function createToggle(name, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 42)
	btn.Position = UDim2.new(0.06, 0, yPos, 0)
	btn.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name .. " [ KAPALI ]"
	btn.Parent = mainFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		callback(state)
		if state then
			btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Text = name .. " [ AÇIK ]"
		else
			btn.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			btn.Text = name .. " [ KAPALI ]"
		end
	end)
	return btn
end

local function createButton(name, yPos, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 42)
	btn.Position = UDim2.new(0.06, 0, yPos, 0)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name
	btn.Parent = mainFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
	return btn
end

createToggle("Role ESP", 0.16, function(state)
	espEnabled = state
	if not espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("RedzoneESP") then
				p.Character.RedzoneESP:Destroy()
			end
		end
	end
end)

createToggle("Sherif Oto-Sık (Yakın)", 0.35, function(state)
	autoShootEnabled = state
end)

createButton("Katil: Herkesi Yok Et", 0.54, Color3.fromRGB(180, 60, 0), function()
	local myRole = getRole(LocalPlayer)
	if myRole == "Murderer" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local char = player.Character
				local rootPart = char:FindFirstChild("HumanoidRootPart")
				local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				
				if rootPart and myRoot then
					myRoot.CFrame = rootPart.CFrame + Vector3.new(0, 0, 2)
					task.wait(0.1)
				end
			end
		end
	end
end)

createButton("Scripti Kapat", 0.75, Color3.fromRGB(50, 40, 60), function()
	screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
	local t = tick() % 5 / 5
	local halloweenColor = Color3.fromHSV(t * 0.15 + 0.05, 0.9, 1)
	uiStroke.Color = halloweenColor
	toggleStroke.Color = halloweenColor
	
	if espEnabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local highlight = player.Character:FindFirstChild("RedzoneESP")
				local roleColor = getRoleColor(player)
				
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = "RedzoneESP"
					highlight.Adornee = player.Character
					highlight.FillTransparency = 0.5
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Parent = player.Character
				end
				highlight.FillColor = roleColor
			end
		end
	end
	
	if autoShootEnabled and getRole(LocalPlayer) == "Sheriff" then
		local myChar = LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local tChar = player.Character
					local head = tChar:FindFirstChild("Head")
					local root = tChar:FindFirstChild("HumanoidRootPart")
					local hum = tChar:FindFirstChildOfClass("Humanoid")
					
					if hum and hum.Health > 0 and head and root and getRole(player) == "Murderer" then
						local distance = (root.Position - myChar.HumanoidRootPart.Position).Magnitude
						if distance <= 35 then
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
							break
						end
					end
				end
			end
		end
	end
end)
