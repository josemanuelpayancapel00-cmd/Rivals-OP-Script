local CORRECT_KEY = "2978v5562375v5623975v62937562v39756937516t233975v1t2398758t112387v5121367v291171r9v1132yurv11ik23rhvby23t1o73t4273b4t123874112t344" -- Change this to your desired key
local KEY_LINK = "https://www.roblox.et/users/7022582195/profile" -- Change this to your Linkvertise / key link

-- Roblox Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplicates by removing previous instances
if PlayerGui:FindFirstChild("ZyfronKeySystem") then
PlayerGui.ZyfronKeySystem:Destroy()
end

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZyfronKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Panel (Slightly wider to accommodate the two-column dashboard)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 290)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- Sleek dark background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(40, 40, 50)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame


-- Steps Container
local StepsFrame = Instance.new("Frame")
StepsFrame.Name = "StepsFrame"
StepsFrame.Size = UDim2.new(0, 240, 1, -40)
StepsFrame.Position = UDim2.new(0, 20, 0, 20)
StepsFrame.BackgroundTransparency = 1
StepsFrame.Parent = MainFrame

-- Steps Title
local StepsTitle = Instance.new("TextLabel")
StepsTitle.Name = "StepsTitle"
StepsTitle.Size = UDim2.new(1, 0, 0, 25)
StepsTitle.Position = UDim2.new(0, 0, 0, 0)
StepsTitle.BackgroundTransparency = 1
StepsTitle.Text = "STEPS TO UNLOCK"
StepsTitle.TextColor3 = Color3.fromRGB(129, 140, 248) -- Premium Indigo-400
StepsTitle.TextSize = 14
StepsTitle.Font = Enum.Font.GothamBold
StepsTitle.TextXAlignment = Enum.TextXAlignment.Left
StepsTitle.Parent = StepsFrame

-- Helper function to generate clean step list items
local function createStepItem(number, text, posY)
local ItemFrame = Instance.new("Frame")
ItemFrame.Size = UDim2.new(1, 0, 0, 55)
ItemFrame.Position = UDim2.new(0, 0, 0, posY)
ItemFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 29)
ItemFrame.BorderSizePixel = 0
ItemFrame.Parent = StepsFrame

local ItemCorner = Instance.new("UICorner")
ItemCorner.CornerRadius = UDim.new(0, 8)
ItemCorner.Parent = ItemFrame

local ItemStroke = Instance.new("UIStroke")
ItemStroke.Thickness = 1
ItemStroke.Color = Color3.fromRGB(35, 35, 45)
ItemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ItemStroke.Parent = ItemFrame

-- Stylized Number Indicator
local NumBadge = Instance.new("TextLabel")
NumBadge.Size = UDim2.new(0, 24, 0, 24)
NumBadge.Position = UDim2.new(0, 12, 0.5, -12)
NumBadge.BackgroundColor3 = Color3.fromRGB(129, 140, 248)
NumBadge.Text = tostring(number)
NumBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
NumBadge.TextSize = 12
NumBadge.Font = Enum.Font.GothamBold
NumBadge.Parent = ItemFrame

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(1, 0) -- Circle
BadgeCorner.Parent = NumBadge

-- Step Text
local StepText = Instance.new("TextLabel")
StepText.Size = UDim2.new(1, -54, 1, -10)
StepText.Position = UDim2.new(0, 46, 0, 5)
StepText.BackgroundTransparency = 1
StepText.Text = text
StepText.TextColor3 = Color3.fromRGB(200, 200, 210)
StepText.TextSize = 11
StepText.Font = Enum.Font.GothamMedium
StepText.TextWrapped = true
StepText.TextXAlignment = Enum.TextXAlignment.Left
StepText.Parent = ItemFrame

return ItemFrame


end

-- Step 1: Follow Creator
createStepItem(1, "Follow the creator of this script to support updates.", 35)

-- Step 2: Get Redirected
createStepItem(2, "You will be redirected to a Linkvertise link to get the key.", 98)

-- Step 3: Paste Key
createStepItem(3, "Open Roblox again, paste the key and verify to unlock.", 161)

-- Column Separator
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 1, 1, -40)
Divider.Position = UDim2.new(0, 280, 0, 20)
Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Right Column Container
local RightFrame = Instance.new("Frame")
RightFrame.Name = "RightFrame"
RightFrame.Size = UDim2.new(0, 240, 1, -40)
RightFrame.Position = UDim2.new(0, 300, 0, 20)
RightFrame.BackgroundTransparency = 1
RightFrame.Parent = MainFrame

-- Premium RichText Header
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = 'ZYFRON KEY SYSTEM'
Title.RichText = true
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = RightFrame

-- Information subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, 0, 0, 18)
Subtitle.Position = UDim2.new(0, 0, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Verify your access below:"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 150)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = RightFrame

-- Link Copier Button
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Size = UDim2.new(1, 0, 0, 38)
CopyButton.Position = UDim2.new(0, 0, 0, 55)
CopyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
CopyButton.Text = "Copy Access Link"
CopyButton.TextColor3 = Color3.fromRGB(230, 230, 240)
CopyButton.TextSize = 12
CopyButton.Font = Enum.Font.GothamBold
CopyButton.AutoButtonColor = false
CopyButton.Parent = RightFrame

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyButton

local CopyStroke = Instance.new("UIStroke")
CopyStroke.Thickness = 1
CopyStroke.Color = Color3.fromRGB(60, 60, 80)
CopyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CopyStroke.Parent = CopyButton

-- Key Text Input
local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(1, 0, 0, 38)
KeyInput.Position = UDim2.new(0, 0, 0, 105)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyInput.PlaceholderText = "Enter or paste your key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
KeyInput.TextSize = 12
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = RightFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = KeyInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Thickness = 1
InputStroke.Color = Color3.fromRGB(45, 45, 55)
InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
InputStroke.Parent = KeyInput

-- Verify Access Button
local VerifyButton = Instance.new("TextButton")
VerifyButton.Name = "VerifyButton"
VerifyButton.Size = UDim2.new(1, 0, 0, 42)
VerifyButton.Position = UDim2.new(0, 0, 0, 161)
VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White base allows gradients to display properly
VerifyButton.Text = "Verify Key"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextSize = 13
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.AutoButtonColor = false
VerifyButton.Parent = RightFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 8)
VerifyCorner.Parent = VerifyButton

-- Indigo-P煤rpura Premium Gradient for the Button
local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)), -- Indigo-500
ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 85, 247))  -- Purple-500
}
ButtonGradient.Parent = VerifyButton

-- UI Transitions
local tweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Hover/Unhover Effects for Copy Button
CopyButton.MouseEnter:Connect(function()
TweenService:Create(CopyButton, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
TweenService:Create(CopyStroke, tweenInfoFast, {Color = Color3.fromRGB(100, 100, 130)}):Play()
end)

CopyButton.MouseLeave:Connect(function()
TweenService:Create(CopyButton, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
TweenService:Create(CopyStroke, tweenInfoFast, {Color = Color3.fromRGB(60, 60, 80)}):Play()
end)

-- Focus Highlight Effects for Key Input
KeyInput.Focused:Connect(function()
TweenService:Create(InputStroke, tweenInfoFast, {Color = Color3.fromRGB(129, 140, 248)}):Play()
end)

KeyInput.FocusLost:Connect(function()
TweenService:Create(InputStroke, tweenInfoFast, {Color = Color3.fromRGB(45, 45, 55)}):Play()
end)

-- Hover Scale Effects for Verify Button
VerifyButton.MouseEnter:Connect(function()
TweenService:Create(VerifyButton, tweenInfoFast, {Size = UDim2.new(1, 6, 0, 44), Position = UDim2.new(0, -3, 0, 160)}):Play()
end)

VerifyButton.MouseLeave:Connect(function()
TweenService:Create(VerifyButton, tweenInfoFast, {Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0, 161)}):Play()
end)

-- Action executed upon successful validation
local function onSuccess()
local fadeTime = 0.5
local fadeTweenInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Smooth transition out of all UI assets
TweenService:Create(MainFrame, fadeTweenInfo, {Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, -200, 0.5, -100), BackgroundTransparency = 1}):Play()
TweenService:Create(MainStroke, fadeTweenInfo, {Transparency = 1}):Play()
TweenService:Create(Divider, fadeTweenInfo, {BackgroundTransparency = 1}):Play()

-- Fade out columns
for _, item in ipairs(StepsFrame:GetDescendants()) do
    if item:IsA("TextLabel") or item:IsA("Frame") then
        TweenService:Create(item, fadeTweenInfo, {BackgroundTransparency = 1}):Play()
    end
    if item:IsA("TextLabel") then
        TweenService:Create(item, fadeTweenInfo, {TextTransparency = 1}):Play()
    end
    if item:IsA("UIStroke") then
        TweenService:Create(item, fadeTweenInfo, {Transparency = 1}):Play()
    end
end

for _, item in ipairs(RightFrame:GetDescendants()) do
    if item:IsA("TextLabel") or item:IsA("TextBox") or item:IsA("TextButton") then
        TweenService:Create(item, fadeTweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    end
    if item:IsA("UIStroke") then
        TweenService:Create(item, fadeTweenInfo, {Transparency = 1}):Play()
    end
end

task.wait(fadeTime)
ScreenGui:Destroy()

----------------------------------------------------------------------
-- 隆PLACE YOUR MAIN EXECUTABLE CODE HERE!                            --
----------------------------------------------------------------------
print("Zyfron Loaded: Access validated successfully! Enjoy the script.")


end

-- Copy Button Script integration using execution environment context API
CopyButton.MouseButton1Click:Connect(function()
local copyFunction = setclipboard or toclipboard or (Clipboard and Clipboard.set)

if copyFunction then
    copyFunction(KEY_LINK)
    CopyButton.Text = "Link Copied to Clipboard!"
    CopyButton.TextColor3 = Color3.fromRGB(150, 255, 150)
    CopyButton.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
    task.wait(2.5)
    CopyButton.Text = "Copy Access Link"
    CopyButton.TextColor3 = Color3.fromRGB(230, 230, 240)
    CopyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
else
    CopyButton.Text = "Error: Executor doesn't support clipboard"
    CopyButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CopyButton.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    task.wait(3)
    CopyButton.Text = "Copy Access Link"
    CopyButton.TextColor3 = Color3.fromRGB(230, 230, 240)
    CopyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
end


end)

-- Validation Script handler
VerifyButton.MouseButton1Click:Connect(function()
if KeyInput.Text == CORRECT_KEY then
ButtonGradient.Enabled = false
VerifyButton.Text = "鉁� ACCESS GRANTED!"
VerifyButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94) -- Success Green
task.wait(1.2)
onSuccess()
else
ButtonGradient.Enabled = false
VerifyButton.Text = "鉁� INVALID KEY"
VerifyButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68) -- Error Red
task.wait(1.8)
VerifyButton.Text = "Verify Key"
VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonGradient.Enabled = true
end
end)
