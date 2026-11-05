-- Redzone Hub - MM2 Halloween Edition (Qruplu menyu: Farm / Şerif / Katil)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
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
toggleBtn.Size = UDim2.new(0, 140, 0, 40)
toggleBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
toggleBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "🎃 Redzone Hub 👻"
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

-- Ana Menü
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 20, 70)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 12, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 14)),
})
bgGradient.Rotation = 90
bgGradient.Parent = mainFrame

-- Süs katmanı
local decor = Instance.new("Frame")
decor.Name = "Decor"
decor.Size = UDim2.new(1, 0, 1, 0)
decor.BackgroundTransparency = 1
decor.ClipsDescendants = true
decor.ZIndex = 0
decor.Parent = mainFrame

local decorCorner = Instance.new("UICorner")
decorCorner.CornerRadius = UDim.new(0, 12)
decorCorner.Parent = decor

local floaters = {}
local floaterIcons = {"🦇", "👻", "🎃", "🍬", "🦇", "👻", "🍬", "🎃"}
for i, icon in ipairs(floaterIcons) do
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 30, 0, 30)
	lbl.BackgroundTransparency = 1
	lbl.Text = icon
	lbl.TextSize = 20 + (i % 3) * 4
	lbl.TextTransparency = 0.45
	lbl.Parent = decor
	table.insert(floaters, {
		label = lbl,
		baseX = (i - 0.5) / #floaterIcons,
		speed = 0.02 + (i % 4) * 0.008,
		offset = i / #floaterIcons,
		phase = i * 1.3,
	})
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Text = "🎃 REDZONE HUB 🎃"
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 40, 160)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 110, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 40, 160)),
})
titleGradient.Parent = title

local function makeWeb(posX, anchorX, flip)
	local web = Instance.new("TextLabel")
	web.Size = UDim2.new(0, 34, 0, 34)
	web.AnchorPoint = Vector2.new(anchorX, 0)
	web.Position = UDim2.new(posX, 0, 0, 2)
	web.BackgroundTransparency = 1
	web.Text = "🕸️"
	web.TextSize = 26
	web.ZIndex = 5
	web.Rotation = flip and 90 or 0
	web.Parent = mainFrame
end
makeWeb(0, 0, false)
makeWeb(1, 1, true)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 28)
footer.AnchorPoint = Vector2.new(0, 1)
footer.Position = UDim2.new(0, 0, 1, -4)
footer.BackgroundTransparency = 1
footer.TextColor3 = Color3.fromRGB(255, 140, 0)
footer.Font = Enum.Font.GothamBold
footer.TextSize = 18
footer.Text = "🦇 👻 🎃 👻 🦇"
footer.ZIndex = 5
footer.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local espEnabled = false
local autoShootEnabled = false
local autoKillEnabled = false
local autoFarmEnabled = false
local noclipEnabled = false
local farmSpeed = 25
local MIN_SPEED, MAX_SPEED, SPEED_STEP = 5, 50, 5

-- Rol bulma
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

-- Innocent: Güvenli Yer (farm ilə birləşdirilmiş)
local safeEnabled = false
local SAFE_POS = Vector3.new(0, 500, 0)
local DANGER_DIST = 35
local HIDE_TIME = 6
local safePlatform
local hideUntil = 0
local hiding = false
local returnCFrame
local currentTween

local function ensurePlatform()
	if safePlatform and safePlatform.Parent then return end
	safePlatform = Instance.new("Part")
	safePlatform.Name = "RedzoneSafe"
	safePlatform.Size = Vector3.new(40, 2, 40)
	safePlatform.Anchored = true
	safePlatform.Position = SAFE_POS
	safePlatform.Parent = Workspace
end

local function roundActive()
	for _, p in ipairs(Players:GetPlayers()) do
		if getRole(p) == "Murderer" then return true end
	end
	return false
end

local function murdererNear(root)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and getRole(p) == "Murderer" then
			local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position - root.Position).Magnitude < DANGER_DIST then
				return true
			end
		end
	end
	return false
end

local function isSafeMode()
	if not (safeEnabled and roundActive() and getRole(LocalPlayer) == "Innocent") then
		return false
	end
	return (not autoFarmEnabled) or tick() < hideUntil
end

task.spawn(function()
	while screenGui.Parent do
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local active = safeEnabled and roundActive() and getRole(LocalPlayer) == "Innocent"

		if active and root then
			if autoFarmEnabled and tick() >= hideUntil and not hiding and murdererNear(root) then
				returnCFrame = root.CFrame
				hideUntil = tick() + HIDE_TIME
				hiding = true
				if currentTween then currentTween:Cancel() end
			end

			if isSafeMode() then
				ensurePlatform()
				local target = SAFE_POS + Vector3.new(0, 4, 0)
				if (root.Position - target).Magnitude > 15 then
					root.CFrame = CFrame.new(target)
				end
			elseif hiding then
				hiding = false
				if returnCFrame then root.CFrame = returnCFrame end
			end
		else
			hiding = false
		end
		task.wait(0.3)
	end
end)

-- Noclip
local noclipCache = {}

local function restoreCollision()
	for part in pairs(noclipCache) do
		if part.Parent then
			part.CanCollide = true
		end
	end
	noclipCache = {}
end

local noclipConn = RunService.Stepped:Connect(function()
	if noclipEnabled then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					noclipCache[part] = true
					part.CanCollide = false
				end
			end
		end
	end
end)

-- Auto Farm Candy
local visited = setmetatable({}, {__mode = "k"})
local VISIT_COOLDOWN = 15

local function isCandy(obj)
	if not obj:IsA("BasePart") then return false end
	local n = obj.Name:lower()
	return n:find("candy") ~= nil or obj.Name == "Coin_Server"
end

local function getClosestCandy(root)
	local closest, best = nil, math.huge
	local now = tick()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if isCandy(obj) and obj.Parent then
			local last = visited[obj]
			if not last or now - last > VISIT_COOLDOWN then
				local d = (obj.Position - root.Position).Magnitude
				if d < best then
					best = d
					closest = obj
				end
			end
		end
	end
	return closest, best
end

task.spawn(function()
	while screenGui.Parent do
		local didMove = false
		local killBusy = autoKillEnabled and getRole(LocalPlayer) == "Murderer"
		if autoFarmEnabled and not killBusy and not isSafeMode() then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local candy, dist = getClosestCandy(root)
				if candy then
					visited[candy] = tick()
					local tween = TweenService:Create(
						root,
						TweenInfo.new(math.max(dist / farmSpeed, 0.05), Enum.EasingStyle.Linear),
						{CFrame = CFrame.new(candy.Position)}
					)
					currentTween = tween
					tween:Play()
					tween.Completed:Wait()
					didMove = true
				end
			end
		end
		if not didMove then
			task.wait(0.2)
		else
			task.wait()
		end
	end
end)

-- Katil: Oto Öldür
task.spawn(function()
	while screenGui.Parent do
		if autoKillEnabled and getRole(LocalPlayer) == "Murderer" then
			local char = LocalPlayer.Character
			local myRoot = char and char:FindFirstChild("HumanoidRootPart")
			local myHum = char and char:FindFirstChildOfClass("Humanoid")
			if myRoot and myHum and myHum.Health > 0 then
				local knife = char:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
				if knife then
					if knife.Parent ~= char then
						myHum:EquipTool(knife)
						task.wait(0.15)
					end
					for _, player in ipairs(Players:GetPlayers()) do
						if not autoKillEnabled then break end
						local tChar = player.Character
						local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
						local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
						if player ~= LocalPlayer and tRoot and tHum and tHum.Health > 0 then
							local pos = (tRoot.CFrame * CFrame.new(0, 0, 2)).Position
							myRoot.CFrame = CFrame.lookAt(pos, tRoot.Position)
							local k = char:FindFirstChild("Knife")
							if k then k:Activate() end
							task.wait(0.2)
						end
					end
				end
			end
		end
		task.wait(0.2)
	end
end)

-- UI köməkçiləri
local function addButtonStroke(btn)
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(140, 70, 200)
	s.Thickness = 1.5
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = btn
end

local pages = {}
local tabButtons = {}

local function selectTab(name)
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
	for n, b in pairs(tabButtons) do
		if n == name then
			b.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			b.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
			b.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end
end

local function createTab(name, label, xScale)
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 0, 200)
	page.Position = UDim2.new(0, 0, 0, 94)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = mainFrame
	pages[name] = page

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.29, 0, 0, 34)
	b.Position = UDim2.new(xScale, 0, 0, 52)
	b.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
	b.TextColor3 = Color3.fromRGB(200, 200, 200)
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.Text = label
	b.Parent = mainFrame
	tabButtons[name] = b

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b
	addButtonStroke(b)

	b.MouseButton1Click:Connect(function()
		selectTab(name)
	end)
	return page
end

local function createToggle(parent, name, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 42)
	btn.Position = UDim2.new(0.06, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name .. " [ KAPALI ]"
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	addButtonStroke(btn)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		callback(state)
		if state then
			btn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Text = name .. " [ AÇIK ]"
		else
			btn.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			btn.Text = name .. " [ KAPALI ]"
		end
	end)
	return btn
end

local function createButton(parent, name, yPos, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.88, 0, 0, 42)
	btn.Position = UDim2.new(0.06, 0, 0, yPos)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	addButtonStroke(btn)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createSpeedControl(parent, yPos)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(0.88, 0, 0, 42)
	row.Position = UDim2.new(0.06, 0, 0, yPos)
	row.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
	row.BorderSizePixel = 0
	row.Parent = parent

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 8)
	rowCorner.Parent = row
	addButtonStroke(row)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.Position = UDim2.new(0.25, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 13
	label.Font = Enum.Font.GothamSemibold
	label.Text = "Hız: " .. farmSpeed
	label.Parent = row

	local function makeBtn(text, xPos, delta)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0.22, 0, 0.8, 0)
		b.Position = UDim2.new(xPos, 0, 0.1, 0)
		b.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.TextSize = 18
		b.Font = Enum.Font.GothamBold
		b.Text = text
		b.Parent = row

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = b

		b.MouseButton1Click:Connect(function()
			farmSpeed = math.clamp(farmSpeed + delta, MIN_SPEED, MAX_SPEED)
			label.Text = "Hız: " .. farmSpeed
		end)
	end

	makeBtn("-", 0.02, -SPEED_STEP)
	makeBtn("+", 0.76, SPEED_STEP)
end

-- Qruplar
local farmPage = createTab("farm", "🍬 Farm", 0.04)
local sheriffPage = createTab("sheriff", "🔫 Şerif", 0.355)
local murdererPage = createTab("murderer", "🔪 Katil", 0.67)

-- FARM qrupu
createToggle(farmPage, "Auto Farm Candy", 0, function(state)
	autoFarmEnabled = state
end)

createToggle(farmPage, "Noclip", 48, function(state)
	noclipEnabled = state
	if not state then
		restoreCollision()
	end
end)

createSpeedControl(farmPage, 96)

createToggle(farmPage, "Innocent: Güvenli Yer", 144, function(state)
	safeEnabled = state
	if not state then
		hiding = false
		if safePlatform then
			safePlatform:Destroy()
			safePlatform = nil
		end
	end
end)

-- ŞERİF qrupu
createToggle(sheriffPage, "Şerif: Oto Vur", 0, function(state)
	autoShootEnabled = state
end)

createToggle(sheriffPage, "Role ESP", 48, function(state)
	espEnabled = state
	if not espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("RedzoneESP") then
				p.Character.RedzoneESP:Destroy()
			end
		end
	end
end)

-- KATİL qrupu
createToggle(murdererPage, "Katil: Oto Öldür", 0, function(state)
	autoKillEnabled = state
end)

-- Kapat düyməsi (bütün tablarda görünür)
createButton(mainFrame, "Scripti Kapat", 292, Color3.fromRGB(70, 35, 90), function()
	autoFarmEnabled = false
	autoKillEnabled = false
	autoShootEnabled = false
	noclipEnabled = false
	safeEnabled = false
	hiding = false
	if currentTween then currentTween:Cancel() end
	if safePlatform then safePlatform:Destroy() end
	restoreCollision()
	noclipConn:Disconnect()
	screenGui:Destroy()
end)

selectTab("farm")

-- Şerif: katili görünce vur
local lastShot = 0
local SHOOT_COOLDOWN = 0.6

RunService.RenderStepped:Connect(function()
	local now = tick()
	local t = now % 5 / 5
	local halloweenColor = Color3.fromHSV(t * 0.15 + 0.05, 0.9, 1)
	uiStroke.Color = halloweenColor
	toggleStroke.Color = halloweenColor
	
	titleGradient.Offset = Vector2.new(math.sin(now * 0.8) * 0.4, 0)
	
	for _, f in ipairs(floaters) do
		local y = 1.1 - ((now * f.speed + f.offset) % 1.2)
		local x = f.baseX + math.sin(now * 0.8 + f.phase) * 0.06
		f.label.Position = UDim2.new(x, -15, y, 0)
	end
	
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
		local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
		if myChar and myHum and myHum.Health > 0 then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and getRole(player) == "Murderer" then
					local tChar = player.Character
					local head = tChar:FindFirstChild("Head")
					local hum = tChar:FindFirstChildOfClass("Humanoid")
					
					if head and hum and hum.Health > 0 then
						local params = RaycastParams.new()
						params.FilterType = Enum.RaycastFilterType.Exclude
						params.FilterDescendantsInstances = {myChar}
						local origin = Camera.CFrame.Position
						local result = Workspace:Raycast(origin, head.Position - origin, params)
						
						if result and result.Instance:IsDescendantOf(tChar) then
							Camera.CFrame = CFrame.new(origin, head.Position)
							
							local gun = myChar:FindFirstChild("Gun") or myChar:FindFirstChild("Revolver")
							if not gun and myChar:FindFirstChild("HumanoidRootPart") then
								local bp = LocalPlayer:FindFirstChild("Backpack")
								local g = bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver"))
								if g then
									myHum:EquipTool(g)
								end
							end
							
							if gun and tick() - lastShot >= SHOOT_COOLDOWN then
								lastShot = tick()
								gun:Activate()
							end
							break
						end
					end
				end
			end
		end
	end
end)
