local ChatLogGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")
local ScrollFrame = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

ChatLogGui.Name = "BobHubChatLogger"
ChatLogGui.Parent = game:GetService("CoreGui")
ChatLogGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ChatLogGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0, 50, 0.5, -100)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "  CHAT LOGGER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Parent = Title
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function() ChatLogGui:Destroy() end)

ClearBtn.Parent = Title
ClearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ClearBtn.Position = UDim2.new(1, -85, 0, 5)
ClearBtn.Size = UDim2.new(0, 50, 0, 20)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 4)

ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4

UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

-- Function to add messages with Copy Button
local function addMessage(sender, msg)
    local msgFrame = Instance.new("Frame")
    msgFrame.Parent = ScrollFrame
    msgFrame.Size = UDim2.new(1, -10, 0, 25)
    msgFrame.BackgroundTransparency = 1

    local log = Instance.new("TextLabel")
    log.Parent = msgFrame
    log.Size = UDim2.new(1, -50, 1, 0)
    log.BackgroundTransparency = 1
    log.Text = "[" .. sender .. "]: " .. msg
    log.TextColor3 = Color3.new(1, 1, 1)
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.TextWrapped = true

    local copy = Instance.new("TextButton")
    copy.Parent = msgFrame
    copy.Size = UDim2.new(0, 40, 0, 18)
    copy.Position = UDim2.new(1, -40, 0, 2)
    copy.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copy.Text = "Copy"
    copy.TextColor3 = Color3.new(1, 1, 1)
    copy.TextSize = 10
    Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 4)

    copy.MouseButton1Click:Connect(function()
        setclipboard(msg)
        copy.Text = "Saved!"
        task.wait(1)
        copy.Text = "Copy"
    end)
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    ScrollFrame.CanvasPosition = Vector2.new(0, UIList.AbsoluteContentSize.Y)
end

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
end)

-- Chat Detection
local events = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
if events and events:FindFirstChild("OnMessageDoneFiltering") then
    events.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
        addMessage(tostring(data.FromSpeaker), tostring(data.Message))
    end)
else
    game:GetService("TextChatService").MessageReceived:Connect(function(textMsg)
        if textMsg.TextSource then addMessage(textMsg.TextSource.Name, textMsg.Text) end
    end)
end

addMessage("SYSTEM", "Chat Logger Ready.")
