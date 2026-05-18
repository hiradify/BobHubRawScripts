-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local SliderFrame = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")

-- Setup UI Properties
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "SpeedGlitchMenu"
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "  SpeedGlitch (R-Ctrl)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Close Button (Hides instead of Destroys)
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.BorderSizePixel = 0

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
ToggleBtn.Text = "Enable Speedglitch"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1,1,1)

SliderFrame.Parent = MainFrame
SliderFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
SliderFrame.Size = UDim2.new(0.8, 0, 0.1, 0)
SliderFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

SliderButton.Parent = SliderFrame
SliderButton.Size = UDim2.new(0.1, 0, 2, 0)
SliderButton.Position = UDim2.new(0, 0, -0.5, 0)
SliderButton.Text = ""
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
SpeedLabel.Text = "Speed: 16"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)

-- Logic Variables
local Player = game.Players.LocalPlayer
local Enabled = false
local SpeedValue = 16
local UserInputService = game:GetService("UserInputService")

-- Keybind to Toggle Visibility (Right Control)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Slider Dragging Logic
local dragging = false
SliderButton.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(pos, 0, -0.5, 0)
        SpeedValue = math.floor(16 + (pos * 200)) 
        SpeedLabel.Text = "Speed: " .. SpeedValue
    end
end)

-- Toggle Logic
ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    ToggleBtn.Text = Enabled and "Disable Speedglitch" or "Enable Speedglitch"
    ToggleBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Core Functionality: Side Jumping with Shiftlock
game:GetService("RunService").RenderStepped:Connect(function()
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    
    if Enabled and Humanoid then
        local isJumping = Humanoid.FloorMaterial == Enum.Material.Air
        local movingSide = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.D)
        
        if isJumping and movingSide then
            Humanoid.WalkSpeed = SpeedValue
        else
            Humanoid.WalkSpeed = 16
        end
    elseif Humanoid then
        Humanoid.WalkSpeed = 16
    end
end)
