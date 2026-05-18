-- [[ CLEANUP ]] --
if game:GetService("CoreGui"):FindFirstChild("DraggableStats") then
    game:GetService("CoreGui").DraggableStats:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DraggableStats"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 60)
MainFrame.Position = UDim2.new(0.5, -125, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local StatLabel = Instance.new("TextLabel")
StatLabel.Size = UDim2.new(1, 0, 1, 0)
StatLabel.BackgroundTransparency = 1
StatLabel.Font = Enum.Font.Code
StatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatLabel.TextSize = 26 -- Large main font
StatLabel.Text = "Loading..."
StatLabel.Parent = MainFrame

-- [[ DRAGGING ]] --
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- [[ PLAYER TRACKING ]] --
local playerStats = {}

local function createOverhead(plr)
    if plr == Player then return end
    playerStats[plr] = {LastPos = Vector3.new(), LastUpdate = tick(), Ping = 0}
    
    local function setup(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if head:FindFirstChild("PingOverhead") then head.PingOverhead:Destroy() end
        
        local bb = Instance.new("BillboardGui", head)
        bb.Name = "PingOverhead"
        -- Use Scale (the first numbers) so it stays consistent at distances
        bb.Size = UDim2.new(6, 0, 2, 0) 
        bb.StudsOffset = Vector3.new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        
        local l = Instance.new("TextLabel", bb)
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.RobotoMono
        l.TextColor3 = Color3.fromRGB(0, 255, 150)
        l.TextScaled = true -- Forces the text to fill the big box
        l.TextStrokeTransparency = 0
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.Text = "..."
        l.Parent = bb
    end
    plr.CharacterAdded:Connect(setup)
    if plr.Character then setup(plr.Character) end
end

Players.PlayerAdded:Connect(createOverhead)
for _, p in pairs(Players:GetPlayers()) do createOverhead(p) end

-- [[ SPLIT UPDATE LOOP ]] --
local lastNormalUpdate = tick()
local lastFiveSecUpdate = tick()
local frameCount = 0

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            local stats = playerStats[v]
            if stats and (hrp.Position - stats.LastPos).Magnitude > 0.01 then
                stats.Ping = math.floor((tick() - stats.LastUpdate) * 1000)
                stats.LastUpdate = tick()
                stats.LastPos = hrp.Position
            end
        end
    end

    -- 1. NORMAL UPDATE (Every 1 Second)
    if now - lastNormalUpdate >= 1 then
        local myPing = math.floor(Player:GetNetworkPing() * 1000)
        if myPing <= 0 then myPing = math.floor(game:GetService("Stats").Network.ServerTickRate:GetValue()) end
        StatLabel.Text = string.format("FPS: %d | %dms", frameCount, myPing)
        frameCount = 0
        lastNormalUpdate = now
    end

    -- 2. SLOW UPDATE (Every 5 Seconds)
    if now - lastFiveSecUpdate >= 5 then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local ov = v.Character.Head:FindFirstChild("PingOverhead")
                local stats = playerStats[v]
                if ov and stats then
                    local label = ov.TextLabel
                    -- Cap display ping if they stop moving (idle)
                    local displayPing = stats.Ping
                    if (tick() - stats.LastUpdate) > 10 then displayPing = 0 end
                    
                    label.Text = displayPing .. " ms"
                    label.TextColor3 = (displayPing > 150) and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(0, 255, 150)
                end
            end
        end
        lastFiveSecUpdate = now
    end
end)