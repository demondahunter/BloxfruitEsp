local fruitTag = "Fruit"
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 400)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function createButton(parent, name, position, text, onClick)
    local button = Instance.new("TextButton", parent)
    button.Name = name
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.TextStrokeTransparency = 0.8
    button.BorderSizePixel = 0
    button.ClipsDescendants = true
    
    local uiCorner = Instance.new("UICorner", button)
    uiCorner.CornerRadius = UDim.new(0, 8)
    
    button.MouseButton1Click:Connect(onClick)
    return button
end

local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.Text = "SkxLL HxBy"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.TextStrokeTransparency = 0.8

local closeButton = createButton(titleBar, "CloseButton", UDim2.new(1, -30, 0, 0), "X", function() screenGui:Destroy() end)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local minimizeButton = createButton(titleBar, "MinimizeButton", UDim2.new(1, -60, 0, 0), "-", function()
    mainFrame.Visible = not mainFrame.Visible
    if not mainFrame.Visible then
        local minimizedButton = Instance.new("TextButton", screenGui)
        minimizedButton.Size = UDim2.new(0, 100, 0, 30)
        minimizedButton.Position = UDim2.new(0.5, -50, 0.5, -15)
        minimizedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        minimizedButton.Text = "SkxLL HxBy"
        minimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        minimizedButton.Font = Enum.Font.SourceSansBold
        minimizedButton.TextSize = 18
        minimizedButton.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner", minimizedButton)
        uiCorner.CornerRadius = UDim.new(0, 8)
        minimizedButton.MouseButton1Click:Connect(function()
            mainFrame.Visible = true
            minimizedButton:Destroy()
        end)
    end
end)

local dropdownFrame = Instance.new("Frame", mainFrame)
dropdownFrame.Size = UDim2.new(0, 200, 0, 150)
dropdownFrame.Position = UDim2.new(0.5, -100, 0.5, 80)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false

local function populateDropdown()
    for _, child in pairs(dropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find(fruitTag) then
            local fruitButton = createButton(dropdownFrame, obj.Name, UDim2.new(0, 0, 0, yOffset), obj.Name, function()
                local player = game.Players.LocalPlayer
                player.Character:SetPrimaryPartCFrame(obj:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0))
            end)
            yOffset = yOffset + 30
        end
    end
end

local teleportButton = createButton(mainFrame, "TeleportButton", UDim2.new(0.5, -100, 0.5, 25), "Teleport to Fruit", function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    if dropdownFrame.Visible then
        populateDropdown()
    end
end)

local function toggleHighlight()
    local highlightEnabled = not highlightEnabled
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find(fruitTag) then
            local highlight = obj:FindFirstChild("Highlight")
            if highlightEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", obj)
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    
                    local billboardGui = Instance.new("BillboardGui", obj)
                    billboardGui.Size = UDim2.new(0, 200, 0, 50)
                    billboardGui.Adornee = obj.PrimaryPart
                    
                    local textLabel = Instance.new("TextLabel", billboardGui)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.TextScaled = true
                    game:GetService("RunService").RenderStepped:Connect(function()
                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                        textLabel.Text = obj.Name .. " (" .. math.floor(distance) .. " studs)"
                        textLabel.TextSize = math.clamp(distance / 10, 20, 100)
                    end)
                end
            else
                if highlight then highlight:Destroy() end
                local billboardGui = obj:FindFirstChild("BillboardGui")
                if billboardGui then billboardGui:Destroy() end
            end
        end
    end
end

local toggleFruitButton = createButton(mainFrame, "ToggleFruitButton", UDim2.new(0.5, -100, 0.5, -75), "Toggle Fruit ESP", toggleHighlight)

local function togglePlayerHighlight()
    playerHighlightEnabled = not playerHighlightEnabled
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local highlight = player.Character:FindFirstChild("Highlight")
            if playerHighlightEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    
                    local billboardGui = Instance.new("BillboardGui", player.Character)
                    billboardGui.Size = UDim2.new(0, 200, 0, 50)
                    billboardGui.Adornee = player.Character:FindFirstChild("Head")
                    
                    local textLabel = Instance.new("TextLabel", billboardGui)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.TextScaled = true
                    game:GetService("RunService").RenderStepped:Connect(function()
                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        textLabel.Text = player.Name .. " (" .. math.floor(distance) .. " studs)"
                        textLabel.TextSize = math.clamp(distance / 10, 20, 100)
                    end)
                end
            else
                if highlight then highlight:Destroy() end
                local billboardGui = player.Character:FindFirstChild("BillboardGui")
                if billboardGui then billboardGui:Destroy() end
            end
        end
    end
end

local togglePlayerButton = createButton(mainFrame, "TogglePlayerButton", UDim2.new(0.5, -100, 0.5, -25), "Toggle Player ESP", togglePlayerHighlight)
