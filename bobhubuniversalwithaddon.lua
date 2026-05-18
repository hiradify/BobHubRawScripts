local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

--// GLOBAL STATE
local State = {
    InfiniteJump = false, Fly = false, Noclip = false, ESP = false,
    ClickTP = false, Spinbot = false, ClickDelete = false, 
    Fullbright = false, AutoClick = false, Aimbot = false, KillAura = false,
    WalkSpeed = 16, JumpPower = 50, FlySpeed = 70, AntiAFK = false,
    AimbotFOV = 120, ShowFOV = false, Tracers = false, NameESP = false,
    HealthESP = false, SuperJump = false, BunnyHop = false, 
    AutoRespawn = false, SpeedPulse = false, TargetStrafe = false,
    LowGFX = false, Gravity = 196.2, FlyKey = Enum.KeyCode.F
}

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

--// CREATE WINDOW
local Window = Rayfield:CreateWindow({
    Name = "BOB HUB GRANDMASTER: ULTIMATE",
    LoadingTitle = "Initializing Grandmaster Scripts...",
    LoadingSubtitle = "Expansion Pack Loaded",
    ConfigurationSaving = { Enabled = true, Folder = "BobHubGrandmaster" },
    KeySystem = false
})

--// TABS
local SelfTab = Window:CreateTab("👤 Self")
local CombatTab = Window:CreateTab("⚔️ Combat")
local MoveTab = Window:CreateTab("🏃 Movement")
local VisualTab = Window:CreateTab("👁️ Visuals")
local PhysTab = Window:CreateTab("🧪 Physics")
local WorldTab = Window:CreateTab("🌎 World")
local ServerTab = Window:CreateTab("🖥️ Server")

--// SELF TAB FEATURES
SelfTab:CreateSection("Character Modifiers")
SelfTab:CreateSlider({
    Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16,
    Callback = function(v) State.WalkSpeed = v end,
})
SelfTab:CreateSlider({
    Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50,
    Callback = function(v) State.JumpPower = v end,
})
SelfTab:CreateToggle({
    Name = "Speed Pulse Mode", CurrentValue = false,
    Callback = function(v) State.SpeedPulse = v end,
})
SelfTab:CreateToggle({
    Name = "Auto Respawn", CurrentValue = false,
    Callback = function(v) State.AutoRespawn = v end,
})
SelfTab:CreateButton({
    Name = "Reset Character",
    Callback = function() player.Character:BreakJoints() end,
})

--// COMBAT TAB FEATURES
CombatTab:CreateSection("Aimbot Settings")
CombatTab:CreateToggle({
    Name = "Aimbot (Right Click Hold)", CurrentValue = false,
    Callback = function(v) State.Aimbot = v end,
})
CombatTab:CreateToggle({
    Name = "Show Aimbot FOV", CurrentValue = false,
    Callback = function(v) State.ShowFOV = v end,
})
CombatTab:CreateSlider({
    Name = "FOV Radius", Range = {50, 800}, Increment = 10, CurrentValue = 120,
    Callback = function(v) State.AimbotFOV = v end,
})
CombatTab:CreateToggle({
    Name = "Target Strafe", CurrentValue = false,
    Callback = function(v) State.TargetStrafe = v end,
})

--// MOVEMENT TAB FEATURES
MoveTab:CreateSection("Movement Hacks")
MoveTab:CreateToggle({
    Name = "Fly (Press F)", CurrentValue = false,
    Callback = function(v) State.Fly = v end,
})
MoveTab:CreateSlider({
    Name = "Fly Speed", Range = {10, 500}, Increment = 5, CurrentValue = 70,
    Callback = function(v) State.FlySpeed = v end,
})
MoveTab:CreateToggle({
    Name = "Noclip", CurrentValue = false,
    Callback = function(v) State.Noclip = v end,
})
MoveTab:CreateToggle({
    Name = "Infinite Jump", CurrentValue = false,
    Callback = function(v) State.InfiniteJump = v end,
})
MoveTab:CreateToggle({
    Name = "Bunny Hop", CurrentValue = false,
    Callback = function(v) State.BunnyHop = v end,
})

--// VISUAL TAB FEATURES
VisualTab:CreateSection("ESP Options")
VisualTab:CreateToggle({
    Name = "Highlight ESP", CurrentValue = false,
    Callback = function(v) State.ESP = v end,
})
VisualTab:CreateToggle({
    Name = "Tracers", CurrentValue = false,
    Callback = function(v) State.Tracers = v end,
})
VisualTab:CreateToggle({
    Name = "Name Tags", CurrentValue = false,
    Callback = function(v) State.NameESP = v end,
})
VisualTab:CreateToggle({
    Name = "Health Display", CurrentValue = false,
    Callback = function(v) State.HealthESP = v end,
})

--// PHYSICS TAB FEATURES
PhysTab:CreateSection("Physics Manipulation")
PhysTab:CreateToggle({
    Name = "Spinbot", CurrentValue = false,
    Callback = function(v) State.Spinbot = v end,
})
PhysTab:CreateToggle({
    Name = "Click TP (Ctrl + Click)", CurrentValue = false,
    Callback = function(v) State.ClickTP = v end,
})
PhysTab:CreateToggle({
    Name = "Click Delete (Alt + Click)", CurrentValue = false,
    Callback = function(v) State.ClickDelete = v end,
})

--// WORLD TAB FEATURES
WorldTab:CreateSection("Environment")
WorldTab:CreateToggle({
    Name = "Fullbright", CurrentValue = false,
    Callback = function(v) 
        State.Fullbright = v
        Lighting.Brightness = v and 3 or 1
        Lighting.GlobalShadows = not v
    end,
})
WorldTab:CreateSlider({
    Name = "World Gravity", Range = {0, 196}, Increment = 1, CurrentValue = 196,
    Callback = function(v) workspace.Gravity = v end,
})
WorldTab:CreateToggle({
    Name = "Low GFX Mode", CurrentValue = false,
    Callback = function(v)
        if v then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                end
            end
        end
    end,
})

--// SERVER TAB FEATURES
ServerTab:CreateSection("Server Utilities")
ServerTab:CreateToggle({
    Name = "Auto Clicker", CurrentValue = false,
    Callback = function(v) State.AutoClick = v end,
})
ServerTab:CreateToggle({
    Name = "Anti-AFK", CurrentValue = false,
    Callback = function(v) State.AntiAFK = v end,
})
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end,
})
ServerTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() TeleportService:Teleport(game.PlaceId) end,
})

--// --- ENGINE CORE ---

-- 1. FOV Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(85, 170, 255)
FOVCircle.Filled = false

-- 2. ESP Drawing Container
local ESPDrawings = {}
local ESPFolder = Instance.new("Folder", workspace)
ESPFolder.Name = "BobHub_ESP_Host"

-- 3. The Main Loop (RenderStepped)
RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    -- Walkspeed/Jump Bypass (Force settings)
    if hum then
        local targetSpeed = State.WalkSpeed
        if State.SpeedPulse then targetSpeed = State.WalkSpeed + math.sin(tick()*5)*10 end
        hum.WalkSpeed = State.Fly and 0 or targetSpeed
        hum.JumpPower = State.JumpPower
    end

    -- Fly Engine
    if State.Fly and hrp then
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
        hrp.Velocity = dir * State.FlySpeed
        hrp.Anchored = (dir == Vector3.zero)
    elseif hrp and hrp.Anchored then
        hrp.Anchored = false
    end

    -- Spinbot Engine
    if State.Spinbot and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(30), 0)
    end

    -- Aimbot Engine
    FOVCircle.Position = Vector2.new(mouse.X, mouse.Y)
    FOVCircle.Radius = State.AimbotFOV
    FOVCircle.Visible = State.ShowFOV

    if State.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local maxDist = State.AimbotFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mouseDist < maxDist then
                        maxDist = mouseDist
                        target = p.Character.Head
                    end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end

    -- Target Strafe Logic
    if State.TargetStrafe and State.Aimbot and hrp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                hrp.CFrame = tHrp.CFrame * CFrame.new(math.cos(tick()*3)*7, 0, math.sin(tick()*3)*7)
                break
            end
        end
    end

    -- Visuals Cleanup & Re-draw
    for _, d in pairs(ESPDrawings) do 
        if d.Line then d.Line:Remove() end 
        if d.Text then d.Text:Remove() end 
    end
    ESPDrawings = {}
    ESPFolder:ClearAllChildren()

    if State.ESP or State.Tracers or State.NameESP or State.HealthESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- Highlight
                if State.ESP then
                    local h = Instance.new("Highlight", ESPFolder)
                    h.Adornee = p.Character
                    h.FillColor = p.TeamColor.Color
                end
                
                local hrpE = p.Character.HumanoidRootPart
                local pos, vis = camera:WorldToViewportPoint(hrpE.Position)
                
                if vis then
                    -- Tracers
                    if State.Tracers then
                        local l = Drawing.new("Line")
                        l.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                        l.To = Vector2.new(pos.X, pos.Y)
                        l.Color = Color3.new(1,1,1)
                        l.Thickness = 1; l.Visible = true
                        table.insert(ESPDrawings, {Line = l})
                    end
                    -- Names
                    if State.NameESP then
                        local t = Drawing.new("Text")
                        t.Text = p.Name; t.Size = 14; t.Center = true
                        t.Position = Vector2.new(pos.X, pos.Y - 25)
                        t.Color = Color3.new(1,1,1); t.Visible = true
                        table.insert(ESPDrawings, {Text = t})
                    end
                end
            end
        end
    end
end)

-- 4. Physics/Input Listeners
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == State.FlyKey then State.Fly = not State.Fly end
end)

UIS.JumpRequest:Connect(function()
    if State.InfiniteJump and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(3) end
    end
end)

RunService.Heartbeat:Connect(function()
    if State.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if State.BunnyHop and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(3) end
    end
    if State.AutoClick then VirtualUser:ClickButton1(Vector2.new(0,0)) end
end)

mouse.Button1Down:Connect(function()
    if State.ClickTP and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        player.Character:MoveTo(mouse.Hit.Position)
    end
    if State.ClickDelete and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) and mouse.Target then
        mouse.Target:Destroy()
    end
end)

player.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

player.CharacterAdded:Connect(function(char)
    if State.AutoRespawn then
        char:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(2)
            player:LoadCharacter()
        end)
    end
end)

print("BOB HUB GRANDMASTER FULLY RESTORED.")