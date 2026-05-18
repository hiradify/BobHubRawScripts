--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

--// STATE
local State = {
    InfiniteJump = false, Fly = false, Noclip = false, ESP = false,
    ClickTP = false, Spinbot = false, ClickDelete = false, 
    Fullbright = false, AutoClick = false, Aimbot = false, KillAura = false,
    WalkSpeed = 16, JumpPower = 50, FlySpeed = 70, Visible = true, 
    Minimized = false, AntiAFK = false
}

--// GUI CORE
local gui = Instance.new("ScreenGui", (game:GetService("CoreGui") or player.PlayerGui))
gui.Name = "BobHub_Ultimate_Resizable"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(750, 600); main.Position = UDim2.fromScale(0.5, 0.5); main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0; main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- RESIZE HANDLE
local resizeBtn = Instance.new("Frame", main)
resizeBtn.Size = UDim2.fromOffset(20, 20)
resizeBtn.Position = UDim2.new(1, -20, 1, -20)
resizeBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
resizeBtn.BackgroundTransparency = 0.5
Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(1, 0)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 60); titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Text = "  BOB HUB GRANDMASTER"; titleText.Size = UDim2.new(0.7, 0, 1, 0); titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(85, 170, 255); titleText.Font = Enum.Font.GothamBold; titleText.TextSize = 24; titleText.TextXAlignment = Enum.TextXAlignment.Left

-- WINDOW BUTTONS
local function createWinBtn(text, pos, color, callback)
    local b = Instance.new("TextButton", titleBar); b.Size = UDim2.fromOffset(35, 35); b.Position = pos
    b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 18
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(callback)
end
createWinBtn("X", UDim2.new(1, -45, 0, 12), Color3.fromRGB(150, 50, 50), function() gui:Destroy() end)
createWinBtn("-", UDim2.new(1, -90, 0, 12), Color3.fromRGB(60, 60, 60), function()
    State.Minimized = not State.Minimized
    main:TweenSize(State.Minimized and UDim2.fromOffset(main.Size.X.Offset, 60) or UDim2.fromOffset(main.Size.X.Offset, 600), "Out", "Quad", 0.3, true)
end)

-- LAYOUT
local contentFrame = Instance.new("Frame", main); contentFrame.Size = UDim2.new(1, 0, 1, -60); contentFrame.Position = UDim2.fromOffset(0, 60); contentFrame.BackgroundTransparency = 1
local sidebar = Instance.new("ScrollingFrame", contentFrame); sidebar.Size = UDim2.new(0, 200, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); sidebar.BorderSizePixel = 0; sidebar.ScrollBarThickness = 0
local container = Instance.new("Frame", contentFrame); container.Position = UDim2.fromOffset(210, 10); container.Size = UDim2.new(1, -220, 1, -20); container.BackgroundTransparency = 1
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)

-- UI HELPERS (TABS, TOGGLES, SLIDERS)
local tabs = {}
local function createTab(name)
    local page = Instance.new("ScrollingFrame", container); page.Size = UDim2.fromScale(1, 1); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 4
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(1, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; btn.TextSize = 16; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for _, v in pairs(tabs) do v.Visible = false end page.Visible = true end)
    tabs[name] = page; return page
end

local function addToggle(p, t, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = t .. ": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 16; Instance.new("UICorner", b)
    local a = false; b.MouseButton1Click:Connect(function() a = not a; b.Text = t .. ": " .. (a and "ON" or "OFF"); b.BackgroundColor3 = a and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(30, 30, 30); c(a) end)
end

local function addButton(p, t, c)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 45); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 16; Instance.new("UICorner", b); b.MouseButton1Click:Connect(c)
end

local function addSlider(p, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", p); sliderFrame.Size = UDim2.new(1, -10, 0, 65); sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", sliderFrame)
    local label = Instance.new("TextLabel", sliderFrame); label.Size = UDim2.new(1, 0, 0, 30); label.BackgroundTransparency = 1; label.Text = text .. ": " .. default; label.TextColor3 = Color3.new(1,1,1); label.Font = Enum.Font.GothamBold; label.TextSize = 14
    local slideArea = Instance.new("Frame", sliderFrame); slideArea.Size = UDim2.new(0.9, 0, 0, 6); slideArea.Position = UDim2.new(0.05, 0, 0.7, 0); slideArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    local bar = Instance.new("Frame", slideArea); bar.Size = UDim2.fromScale((default-min)/(max-min), 1); bar.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    local dragging = false
    local function update()
        local pos = math.clamp((mouse.X - slideArea.AbsolutePosition.X) / slideArea.AbsoluteSize.X, 0, 1); bar.Size = UDim2.fromScale(pos, 1)
        local val = math.floor(min + (pos * (max - min))); label.Text = text .. ": " .. val; callback(val)
    end
    slideArea.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

--// INITIALIZE TABS
local selfT = createTab("👤 Self")
local combatT = createTab("⚔️ Combat")
local moveT = createTab("🏃 Movement")
local visualT = createTab("👁️ Visuals")
local physT = createTab("🧪 Physics")
local worldT = createTab("🌎 World")
local servT = createTab("🖥️ Server")
selfT.Visible = true

--// FEATURES
addToggle(selfT, "Anti-AFK", function(v) State.AntiAFK = v end)
addSlider(selfT, "WalkSpeed", 16, 250, 16, function(v) State.WalkSpeed = v end)
addSlider(selfT, "JumpPower", 50, 500, 50, function(v) State.JumpPower = v end)
addButton(selfT, "Reset Character", function() player.Character:BreakJoints() end)
addToggle(combatT, "Aimbot (Right Hold)", function(v) State.Aimbot = v end)
addToggle(combatT, "Kill Aura", function(v) State.KillAura = v end)
addToggle(moveT, "Fly", function(v) State.Fly = v end)
addSlider(moveT, "Fly Speed", 10, 300, 70, function(v) State.FlySpeed = v end)
addToggle(moveT, "Noclip", function(v) State.Noclip = v end)
addToggle(moveT, "Infinite Jump", function(v) State.InfiniteJump = v end)
local ESPFolder = Instance.new("Folder", workspace); ESPFolder.Name = "BobESP_Container"
addToggle(visualT, "Highlight ESP", function(v) State.ESP = v; if not v then ESPFolder:ClearAllChildren() end end)
addToggle(physT, "Spinbot", function(v) State.Spinbot = v end)
addToggle(physT, "Click TP (Ctrl+LClick)", function(v) State.ClickTP = v end)
addToggle(physT, "Click Delete (Alt+LClick)", function(v) State.ClickDelete = v end)
addToggle(worldT, "Fullbright", function(v) Lighting.Brightness = v and 3 or 1; Lighting.GlobalShadows = not v end)
addButton(servT, "Server Hop", function()
    local x = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(x.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) break end end
end)
addToggle(servT, "Auto Clicker", function(v) State.AutoClick = v end)

--// MASTER ENGINES
local function applyStats(character)
    local hum = character:WaitForChild("Humanoid", 5)
    if hum then
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = State.WalkSpeed end)
        hum:GetPropertyChangedSignal("JumpPower"):Connect(function() hum.JumpPower = State.JumpPower end)
        hum.WalkSpeed = State.WalkSpeed; hum.JumpPower = State.JumpPower
    end
end
player.CharacterAdded:Connect(applyStats)
if player.Character then applyStats(player.Character) end

RunService.Stepped:Connect(function()
    if State.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = State.Fly and 0 or State.WalkSpeed end
    if State.Fly and hrp then
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
        hrp.Velocity = dir * State.FlySpeed; hrp.Anchored = (dir == Vector3.zero)
    elseif hrp and hrp.Anchored then hrp.Anchored = false end
    if State.Spinbot and hrp then hrp.CFrame *= CFrame.Angles(0, math.rad(30), 0) end
    if State.AutoClick then VirtualUser:ClickButton1(Vector2.new(0,0)) end
    if State.ESP then
        ESPFolder:ClearAllChildren()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then local h = Instance.new("Highlight", ESPFolder); h.Adornee = p.Character; h.FillColor = p.TeamColor.Color end
        end
    end
    if State.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closest = nil; local dist = 500
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local pos, visible = camera:WorldToViewportPoint(p.Character.Head.Position)
                if visible then
                    local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < dist then dist = mag; closest = p.Character.Head end
                end
            end
        end
        if closest then camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position) end
    end
end)

--// RESIZE & DRAG LOGIC
local function setupResize()
    local dragging, startPos, startSize
    resizeBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; startPos = i.Position; startSize = main.Size
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - startPos
            main.Size = UDim2.fromOffset(math.max(startSize.X.Offset + delta.X, 400), math.max(startSize.Y.Offset + delta.Y, 300))
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end
setupResize()

local dragToggle, dragStart, dragStartPos
titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = i.Position; dragStartPos = main.Position end end)
UIS.InputChanged:Connect(function(i) if dragToggle and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; main.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

--// MISC INPUTS
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible end end)
UIS.JumpRequest:Connect(function() if State.InfiniteJump and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(3) end end end)
mouse.Button1Down:Connect(function()
    if State.ClickTP and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then player.Character:MoveTo(mouse.Hit.Position) end
    if State.ClickDelete and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) and mouse.Target then mouse.Target:Destroy() end
end)
player.Idled:Connect(function() if State.AntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

print("Bob Hub: All features, forcing WalkSpeed, and Resizable.")