-- Redzone Hub - MM2 Halloween Edition (Farm / Sheriff / Murderer / Innocent)
-- PART 1/3
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
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

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
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

-- State
local espEnabled = false
local autoShootEnabled = false
local autoKillEnabled = false
local autoFarmEnabled = false
local noclipEnabled = false
local grabGunEnabled = false
local grabbing = false
local farmSpeed = 22

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
end-- PART 2/3

-- Innocent: Safe Spot
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
	if grabbing then return false end
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

		if active and root and not grabbing then
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
		elseif not active then
			hiding = false
		end
		task.wait(0.3)
	end
end)

-- Innocent: Grab Sheriff Gun (when the sheriff dies and drops the gun)
local function findGunDrop()
	local drop = Workspace:FindFirstChild("GunDrop", true)
	if drop then
		if drop:IsA("BasePart") then return drop end
		return drop:FindFirstChildWhichIsA("BasePart", true)
	end
	return nil
end

task.spawn(function()
	while screenGui.Parent do
		if grabGunEnabled and getRole(LocalPlayer) == "Innocent" then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local drop = findGunDrop()

			if root and hum and hum.Health > 0 and drop and drop.Parent then
				grabbing = true
				if currentTween then currentTween:Cancel() end
				local oldCFrame = root.CFrame

				root.CFrame = drop.CFrame
				task.wait(0.15)
				if firetouchinterest then
					pcall(function()
						firetouchinterest(root, drop, 0)
						task.wait()
						firetouchinterest(root, drop, 1)
					end)
				end
				task.wait(0.25)

				if root.Parent then
					root.CFrame = oldCFrame
				end
				grabbing = false
				task.wait(1)
			end
		end
		grabbing = false
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
		if autoFarmEnabled and not killBusy and not grabbing and not isSafeMode() then
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

-- Murderer: Auto Kill
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

-- Sheriff: Stick to murderer + predictive shooting
local SHOOT_COOLDOWN = 0.45
local AIM_LEAD = 0.13
local BEHIND = 6
local lastShot = 0

local function aimPoint(tRoot)
	return tRoot.Position + tRoot.AssemblyLinearVelocity * AIM_LEAD
end

local function fireGun(gun, tRoot)
	local aim = aimPoint(tRoot)
	local ok = pcall(function()
		local kl = gun:FindFirstChild("KnifeLocal")
		local cb = kl and kl:FindFirstChild("CreateBeam")
		local rf = cb and cb:FindFirstChild("RemoteFunction")
		if not rf then error("remote not found") end
		rf:InvokeServer(1, aim, "AH2")
	end)
	if ok then return end

	local pos, onScreen = Camera:WorldToViewportPoint(aim)
	if onScreen then
		VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
		task.wait()
		VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
	end
end

local shootConn = RunService.Heartbeat:Connect(function()
	if not (autoShootEnabled and getRole(LocalPlayer) == "Sheriff") then return end

	local myChar = LocalPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	if not (myRoot and myHum and myHum.Health > 0) then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and getRole(player) == "Murderer" then
			local tChar = player.Character
			local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
			local hum = tChar and tChar:FindFirstChildOfClass("Humanoid")

			if tRoot and hum and hum.Health > 0 then
				local gun = myChar:FindFirstChild("Gun") or myChar:FindFirstChild("Revolver")
				if not gun then
					local bp = LocalPlayer:FindFirstChild("Backpack")
					local g = bp and (bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver"))
					if g then myHum:EquipTool(g) end
					return
				end

				local predicted = tRoot.Position + tRoot.AssemblyLinearVelocity * 0.05
				local behind = predicted - tRoot.CFrame.LookVector * BEHIND
				myRoot.CFrame = CFrame.lookAt(behind, predicted)
				myRoot.AssemblyLinearVelocity = Vector3.zero
				Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, aimPoint(tRoot))

				if tick() - lastShot >= SHOOT_COOLDOWN then
					lastShot = tick()
					task.spawn(fireGun, gun, tRoot)
				end
				break
			end
		end
	end
end)-- PART 3/3

-- UI helpers
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
	b.Size = UDim2.new(0.22, 0, 0, 34)
	b.Position = UDim2.new(xScale, 0, 0, 52)
	b.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
	b.TextColor3 = Color3.fromRGB(200, 200, 200)
	b.TextSize = 11
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
	btn.Text = name .. " [ OFF ]"
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
			btn.Text = name .. " [ ON ]"
		else
			btn.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			btn.Text = name .. " [ OFF ]"
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

-- Tabs
local farmPage = createTab("farm", "🍬 Farm", 0.024)
local sheriffPage = createTab("sheriff", "🔫 Sheriff", 0.268)
local murdererPage = createTab("murderer", "🔪 Murderer", 0.512)
local innocentPage = createTab("innocent", "😇 Innocent", 0.756)

-- FARM
createToggle(farmPage, "Auto Farm Candy", 0, function(state)
	autoFarmEnabled = state
end)

createToggle(farmPage, "Noclip", 48, function(state)
	noclipEnabled = state
	if not state then
		restoreCollision()
	end
end)

-- SHERIFF
createToggle(sheriffPage, "Sheriff: TP to Murderer + Shoot", 0, function(state)
	autoShootEnabled = state
end)

createToggle(sheriffPage, "Role ESP", 48, function(state)
	espEnabled = state
	if not espEnabled then
		for _, p in ipairs(Players:GetPlayers()) do
			local c = p.Character
			if c then
				local h = c:FindFirstChild("RedzoneESP")
				if h then h:Destroy() end
				local head = c:FindFirstChild("Head")
				local t = head and head:FindFirstChild("RedzoneTag")
				if t then t:Destroy() end
			end
		end
	end
end)

-- MURDERER
createToggle(murdererPage, "Murderer: Auto Kill", 0, function(state)
	autoKillEnabled = state
end)

-- INNOCENT
createToggle(innocentPage, "Innocent: Safe Spot", 0, function(state)
	safeEnabled = state
	if not state then
		hiding = false
		if safePlatform then
			safePlatform:Destroy()
			safePlatform = nil
		end
	end
end)

createToggle(innocentPage, "Grab Sheriff Gun", 48, function(state)
	grabGunEnabled = state
	if not state then
		grabbing = false
	end
end)

-- Close
createButton(mainFrame, "Close Script", 292, Color3.fromRGB(70, 35, 90), function()
	autoFarmEnabled = false
	autoKillEnabled = false
	autoShootEnabled = false
	noclipEnabled = false
	safeEnabled = false
	grabGunEnabled = false
	grabbing = false
	espEnabled = false
	hiding = false
	if currentTween then currentTween:Cancel() end
	if safePlatform then safePlatform:Destroy() end
	for _, p in ipairs(Players:GetPlayers()) do
		local c = p.Character
		if c then
			local h = c:FindFirstChild("RedzoneESP")
			if h then h:Destroy() end
			local head = c:FindFirstChild("Head")
			local t = head and head:FindFirstChild("RedzoneTag")
			if t then t:Destroy() end
		end
	end
	restoreCollision()
	noclipConn:Disconnect()
	shootConn:Disconnect()
	screenGui:Destroy()
end)

selectTab("farm")

-- Animation + ESP
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
			local char = player.Character
			if player ~= LocalPlayer and char then
				local role = getRole(player)
				local roleColor = getRoleColor(player)

				-- Very soft highlight
				local highlight = char:FindFirstChild("RedzoneESP")
				if not highlight then
					highlight = Instance.new("Highlight")
					highlight.Name = "RedzoneESP"
					highlight.Adornee = char
					highlight.FillTransparency = 0.95
					highlight.OutlineTransparency = 0.6
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Parent = char
				end
				highlight.FillColor = roleColor
				highlight.OutlineColor = roleColor

				-- Role name above the head
				local head = char:FindFirstChild("Head")
				if head then
					local tag = head:FindFirstChild("RedzoneTag")
					if not tag then
						tag = Instance.new("BillboardGui")
						tag.Name = "RedzoneTag"
						tag.Adornee = head
						tag.Size = UDim2.new(0, 100, 0, 22)
						tag.StudsOffset = Vector3.new(0, 2.5, 0)
						tag.AlwaysOnTop = true
						tag.Parent = head

						local lbl = Instance.new("TextLabel")
						lbl.Name = "Label"
						lbl.Size = UDim2.new(1, 0, 1, 0)
						lbl.BackgroundTransparency = 1
						lbl.Font = Enum.Font.GothamBold
						lbl.TextSize = 14
						lbl.TextStrokeTransparency = 0.3
						lbl.Parent = tag
					end
					local lbl = tag:FindFirstChild("Label")
					if lbl then
						lbl.Text = role
						lbl.TextColor3 = roleColor
					end
				end
			end
		end
	end
end)
