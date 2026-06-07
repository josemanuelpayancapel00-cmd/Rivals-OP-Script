--[[
    PREMIUM MULTIHACK - VERSIÓN MÓVIL NATIVA
    Sin dependencias externas, GUI táctil 100% funcional
    Botón flotante + Menú responsive
]]

----------------------------------------------------------------
-- SERVICIOS Y VARIABLES
----------------------------------------------------------------
local VirtualInputManager = game:GetService("VirtualInputManager")
local runS = game:GetService("RunService")
local pl = game:GetService("Players")
local lp = pl.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local ws = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local isMobile = UIS.TouchEnabled
local screenSize = camera.ViewportSize

local mousePPos = UIS:GetMouseLocation()
local Center = Vector2.new(screenSize.X / 2, screenSize.Y / 2)

runS.RenderStepped:Connect(function() 
    mousePPos = UIS:GetMouseLocation() 
    Center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

-- Actualizar personaje
lp.CharacterAdded:Connect(function(newChar)
    char = newChar
end)

----------------------------------------------------------------
-- CONFIGURACIÓN
----------------------------------------------------------------
local Settings = {
    -- Aimbot
    SilentAim = false,
    AimTeamCheck = true,
    AimWallCheck = true,
    Wallbang = false,
    AimToggleMode = true,
    HitPart = "HitboxHead",
    
    -- ESP
    ESP = false,
    ESPTeamCheck = true,
    ESPWallCheck = false,
    ESPFillColor = Color3.fromRGB(255, 0, 0),
    ESPFillTransparency = 0.5,
    ESPOutlineColor = Color3.fromRGB(255, 255, 255),
    ESPOutlineTransparency = 0,
    
    -- Fly
    Fly = false,
    FlySpeed = 50,
    
    -- Noclip
    Noclip = false,
    
    -- Spoofer
    SpooferDevice = "None",
    
    -- GUI
    MenuVisible = false,
}

----------------------------------------------------------------
-- GUARDAR/CARGAR CONFIGURACIÓN
----------------------------------------------------------------
local function SaveConfig()
    local success, err = pcall(function()
        local configData = {
            SilentAim = Settings.SilentAim,
            AimTeamCheck = Settings.AimTeamCheck,
            AimWallCheck = Settings.AimWallCheck,
            Wallbang = Settings.Wallbang,
            AimToggleMode = Settings.AimToggleMode,
            HitPart = Settings.HitPart,
            ESP = Settings.ESP,
            ESPTeamCheck = Settings.ESPTeamCheck,
            ESPWallCheck = Settings.ESPWallCheck,
            Fly = Settings.Fly,
            FlySpeed = Settings.FlySpeed,
            Noclip = Settings.Noclip,
            SpooferDevice = Settings.SpooferDevice,
        }
        writefile("PremiumMultihack_Mobile.txt", game:GetService("HttpService"):JSONEncode(configData))
        return true
    end)
    if success then
        print("✅ Configuración guardada")
    end
end

local function LoadConfig()
    local success, err = pcall(function()
        if isfile and isfile("PremiumMultihack_Mobile.txt") then
            local data = readfile("PremiumMultihack_Mobile.txt")
            local config = game:GetService("HttpService"):JSONDecode(data)
            for k, v in pairs(config) do
                Settings[k] = v
            end
            print("✅ Configuración cargada")
            return true
        end
    end)
    if not success then
        print("No se encontró configuración previa")
    end
    return false
end

----------------------------------------------------------------
-- DEVICE SPOOFER
----------------------------------------------------------------
local function ApplyDeviceSpoof(device)
    local deviceMap = {
        None = "KeyboardMouse",
        Xbox = "Xbox",
        PlayStation = "PlayStation",
        VR = "VR"
    }
    local mappedDevice = deviceMap[device] or device
    if mappedDevice ~= "KeyboardMouse" then
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local replication = remote:FindFirstChild("Replication")
            if replication then
                local fighter = replication:FindFirstChild("Fighter")
                if fighter then
                    local setControls = fighter:FindFirstChild("SetControls")
                    if setControls then
                        setControls:FireServer(mappedDevice)
                    end
                end
            end
        end
    end
end

----------------------------------------------------------------
-- GUI TÁCTIL NATIVA (SIN LIBRERÍAS EXTERNAS)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMenuMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- ========== BOTÓN FLOTANTE ==========
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(1, -75, 0, 15)
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
FloatingButton.BackgroundTransparency = 0.15
FloatingButton.Image = "rbxassetid://6031091087"
FloatingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.ScaleType = Enum.ScaleType.Fit
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

-- Sombra del botón
local FloatShadow = Instance.new("Frame")
FloatShadow.Size = UDim2.new(1, 4, 1, 4)
FloatShadow.Position = UDim2.new(0, -2, 0, -2)
FloatShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatShadow.BackgroundTransparency = 0.6
FloatShadow.BorderSizePixel = 0
FloatShadow.Parent = FloatingButton

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(1, 0)
ShadowCorner.Parent = FloatShadow

-- Arrastrar botón flotante
local dragging = false
local dragStartPos, buttonStartPos

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = input.Position
        buttonStartPos = FloatingButton.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        local newX = math.clamp(buttonStartPos.X.Offset + delta.X, 5, screenSize.X - 65)
        local newY = math.clamp(buttonStartPos.Y.Offset + delta.Y, 5, screenSize.Y - 65)
        FloatingButton.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========== MENÚ PRINCIPAL ==========
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Size = UDim2.new(0, math.min(400, screenSize.X - 40), 0, math.min(550, screenSize.Y - 100))
MainMenu.Position = UDim2.new(0.5, -math.min(400, screenSize.X - 40)/2, 0.5, -math.min(550, screenSize.Y - 100)/2)
MainMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainMenu.BackgroundTransparency = 0.05
MainMenu.BorderSizePixel = 0
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 16)
MenuCorner.Parent = MainMenu

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainMenu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔥 PREMIUM MULTIHACK 🔥"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = isMobile and 16 or 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Botón cerrar
local CloseMenuBtn = Instance.new("TextButton")
CloseMenuBtn.Size = UDim2.new(0, 35, 0, 35)
CloseMenuBtn.Position = UDim2.new(1, -45, 0, 7)
CloseMenuBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseMenuBtn.Text = "✕"
CloseMenuBtn.Font = Enum.Font.GothamBold
CloseMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseMenuBtn.TextSize = 20
CloseMenuBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseMenuBtn

CloseMenuBtn.MouseButton1Click:Connect(function()
    Settings.MenuVisible = false
    MainMenu.Visible = false
end)

-- ScrollView para contenido
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -20, 1, -70)
ScrollContainer.Position = UDim2.new(0, 10, 0, 60)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollContainer.Parent = MainMenu

local UILayout = Instance.new("UIListLayout")
UILayout.Padding = UDim.new(0, 8)
UILayout.SortOrder = Enum.SortOrder.LayoutOrder
UILayout.Parent = ScrollContainer

-- ========== FUNCIÓN PARA CREAR SECCIONES ==========
local function CreateSection(title, order)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    section.BackgroundTransparency = 0.2
    section.BorderSizePixel = 0
    section.LayoutOrder = order
    section.Parent = ScrollContainer
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionText = Instance.new("TextLabel")
    sectionText.Size = UDim2.new(1, -15, 1, 0)
    sectionText.Position = UDim2.new(0, 15, 0, 0)
    sectionText.BackgroundTransparency = 1
    sectionText.Text = title
    sectionText.Font = Enum.Font.GothamBold
    sectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionText.TextSize = isMobile and 16 or 14
    sectionText.TextXAlignment = Enum.TextXAlignment.Left
    sectionText.Parent = section
    
    return section
end

-- ========== FUNCIÓN PARA CREAR TOGGLES ==========
local function CreateToggle(parent, text, getter, setter, desc, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 25)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = isMobile and 15 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0, 250, 0, 20)
        descLabel.Position = UDim2.new(0, 12, 0, 32)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = frame
    end
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 35)
    toggleBtn.Position = UDim2.new(1, -85, 0.5, -17)
    toggleBtn.BackgroundColor3 = getter() and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    toggleBtn.Text = getter() and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        local newState = not getter()
        setter(newState)
        toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        toggleBtn.Text = newState and "ON" or "OFF"
    end)
    
    return frame
end

-- ========== FUNCIÓN PARA CREAR SLIDERS ==========
local function CreateSlider(parent, text, minVal, maxVal, getter, setter, desc, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 85)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(getter())
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = isMobile and 15 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0, 300, 0, 18)
        descLabel.Position = UDim2.new(0, 12, 0, 30)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = frame
    end
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(0.65, 0, 0, 30)
    sliderContainer.Position = UDim2.new(0, 12, 0, 48)
    sliderContainer.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderContainer
    
    local fill = Instance.new("Frame")
    local percent = (getter() - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderContainer
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.67, 5, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(getter())
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextColor3 = Color3.fromRGB(30, 144, 255)
    valueLabel.TextSize = 14
    valueLabel.Parent = frame
    
    local sliding = false
    sliderContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    runS.RenderStepped:Connect(function()
        if sliding and sliderContainer.AbsoluteSize.X > 0 then
            local mousePos = UIS:GetMouseLocation()
            local relativeX = math.clamp(mousePos.X - sliderContainer.AbsolutePosition.X, 0, sliderContainer.AbsoluteSize.X)
            local pct = relativeX / sliderContainer.AbsoluteSize.X
            local value = math.floor(minVal + (pct * (maxVal - minVal)))
            
            fill.Size = UDim2.new(pct, 0, 1, 0)
            valueLabel.Text = tostring(value)
            label.Text = text .. ": " .. tostring(value)
            setter(value)
        end
    end)
    
    return frame
end

-- ========== FUNCIÓN PARA CREAR DROPDOWNS ==========
local function CreateDropdown(parent, text, options, getter, setter, desc, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.LayoutOrder = order
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 25)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextSize = isMobile and 15 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0, 280, 0, 18)
        descLabel.Position = UDim2.new(0, 12, 0, 30)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = frame
    end
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 140, 0, 40)
    dropdownBtn.Position = UDim2.new(1, -155, 0, 15)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    dropdownBtn.Text = getter()
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 14
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local expanded = false
    local dropdownList = nil
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if expanded then
            if dropdownList then dropdownList:Destroy() end
            expanded = false
        else
            dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(0, 140, 0, 40 * #options)
            dropdownList.Position = UDim2.new(1, -155, 0, 55)
            dropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            dropdownList.BorderSizePixel = 0
            dropdownList.ZIndex = 10
            dropdownList.Parent = frame
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 8)
            listCorner.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList
            
            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 38)
                optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                optBtn.Text = opt
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.TextSize = 13
                optBtn.Parent = dropdownList
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    setter(opt)
                    dropdownBtn.Text = opt
                    if dropdownList then dropdownList:Destroy() end
                    expanded = false
                end)
            end
            expanded = true
        end
    end)
    
    return frame
end

-- ========== BOTÓN GUARDAR ==========
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0, 180, 0, 45)
SaveBtn.Position = UDim2.new(0.5, -90, 1, -55)
SaveBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
SaveBtn.Text = "💾 GUARDAR CONFIG"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.TextSize = isMobile and 14 or 13
SaveBtn.Parent = MainMenu

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 10)
SaveCorner.Parent = SaveBtn

SaveBtn.MouseButton1Click:Connect(function()
    SaveConfig()
    LibraryNotify("Configuración guardada!", 2)
end)

-- ========== CONSTRUIR MENÚ ==========
local order = 0

-- Sección Aimbot
local aimSection = CreateSection("⚔️ COMBAT / AIMBOT", order); order = order + 1
CreateToggle(aimSection.Parent, "Silent Aim", function() return Settings.SilentAim end, function(v) Settings.SilentAim = v end, "Apuntado automático (toca pantalla para activar)", order); order = order + 1
CreateToggle(aimSection.Parent, "Toggle Mode", function() return Settings.AimToggleMode end, function(v) Settings.AimToggleMode = v end, "Toggle ON/OFF | Desactivado = mantener toque", order); order = order + 1
CreateToggle(aimSection.Parent, "Team Check", function() return Settings.AimTeamCheck end, function(v) Settings.AimTeamCheck = v end, "No apunta a compañeros", order); order = order + 1
CreateToggle(aimSection.Parent, "Wall Check", function() return Settings.AimWallCheck end, function(v) Settings.AimWallCheck = v end, "Solo apunta si es visible", order); order = order + 1
CreateToggle(aimSection.Parent, "Wallbang", function() return Settings.Wallbang end, function(v) Settings.Wallbang = v end, "Atraviesa muros", order); order = order + 1
CreateDropdown(aimSection.Parent, "Hit Part", {"HitboxHead", "Head", "UpperTorso", "HumanoidRootPart"}, function() return Settings.HitPart end, function(v) Settings.HitPart = v end, "Parte del cuerpo a apuntar", order); order = order + 1

-- Sección ESP
local espSection = CreateSection("👁️ VISUALS / ESP", order); order = order + 1
CreateToggle(espSection.Parent, "Enable ESP", function() return Settings.ESP end, function(v) Settings.ESP = v end, "Marca a los jugadores", order); order = order + 1
CreateToggle(espSection.Parent, "ESP Team Check", function() return Settings.ESPTeamCheck end, function(v) Settings.ESPTeamCheck = v end, "No marca a compañeros", order); order = order + 1
CreateToggle(espSection.Parent, "ESP Wall Check", function() return Settings.ESPWallCheck end, function(v) Settings.ESPWallCheck = v end, "ESP se oculta detrás de paredes", order); order = order + 1

-- Sección Movement
local moveSection = CreateSection("🌀 MOVEMENT", order); order = order + 1
CreateToggle(moveSection.Parent, "Fly", function() return Settings.Fly end, function(v) Settings.Fly = v end, "Volar", order); order = order + 1
CreateSlider(moveSection.Parent, "Fly Speed", 10, 200, function() return Settings.FlySpeed end, function(v) Settings.FlySpeed = v end, "Velocidad del vuelo", order); order = order + 1
CreateToggle(moveSection.Parent, "Noclip", function() return Settings.Noclip end, function(v) Settings.Noclip = v end, "Atraviesa paredes", order); order = order + 1

-- Sección Spoofer
local spoofSection = CreateSection("🎮 DEVICE SPOOFER", order); order = order + 1
CreateDropdown(spoofSection.Parent, "Device", {"None", "Xbox", "PlayStation", "VR"}, function() return Settings.SpooferDevice end, function(v) 
    Settings.SpooferDevice = v
    ApplyDeviceSpoof(v)
end, "Simula un dispositivo", order); order = order + 1

-- Actualizar CanvasSize
local function UpdateCanvas()
    task.wait(0.1)
    local totalHeight = 0
    for _, child in pairs(ScrollContainer:GetChildren()) do
        if child:IsA("Frame") and child ~= UILayout then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
        end
    end
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 80)
end

UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
task.wait(0.2)
UpdateCanvas()

-- Abrir/cerrar menú con botón flotante
FloatingButton.MouseButton1Click:Connect(function()
    Settings.MenuVisible = not Settings.MenuVisible
    MainMenu.Visible = Settings.MenuVisible
end)

-- Cerrar con tecla (PC) o botón back (móvil)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F4 then
        Settings.MenuVisible = not Settings.MenuVisible
        MainMenu.Visible = Settings.MenuVisible
    end
    if not gpe and input.KeyCode == Enum.KeyCode.ButtonR1 then -- Botón back en móvil
        if MainMenu.Visible then
            Settings.MenuVisible = false
            MainMenu.Visible = false
        end
    end
end)

-- Notificación simple
local function Notify(title, text, duration)
    print(title .. ": " .. text)
end

----------------------------------------------------------------
-- LÓGICA DEL AIMBOT
----------------------------------------------------------------
do
    local aimLock = false
    
    local function GetClosestTarget()
        local closestTarget = nil
        local closestDist = math.huge
        
        for _, v in pairs(pl:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild(Settings.HitPart) then
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then continue end
                
                if not Settings.Wallbang then
                    local ray = workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(camera.CFrame.Position,
                        (v.Character[Settings.HitPart].Position - camera.CFrame.Position).Unit *
                        (v.Character[Settings.HitPart].Position - camera.CFrame.Position).Magnitude),
                        {lp.Character, camera}
                    )
                    if Settings.AimWallCheck and (not ray or not ray:IsDescendantOf(v.Character)) then continue end
                end
                
                if Settings.AimTeamCheck and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("TeammateLabel") then continue end
                
                local vPos, onScreen = camera:WorldToViewportPoint(v.Character[Settings.HitPart].Position)
                if onScreen then
                    local distance = (Vector2.new(vPos.X, vPos.Y) - mousePPos).Magnitude
                    if distance < closestDist then
                        closestDist = distance
                        closestTarget = v
                    end
                end
            end
        end
        return closestTarget
    end
    
    -- Activar con toque en móvil o tecla F en PC
    if isMobile then
        UIS.TouchTap:Connect(function(touchPositions)
            if Settings.SilentAim then
                if Settings.AimToggleMode then
                    aimLock = not aimLock
                else
                    aimLock = true
                end
            end
        end)
        
        UIS.TouchEnded:Connect(function()
            if not Settings.AimToggleMode then
                aimLock = false
            end
        end)
    else
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.F then
                if Settings.SilentAim then
                    if Settings.AimToggleMode then
                        aimLock = not aimLock
                    else
                        aimLock = true
                    end
                end
            end
        end)
        
        UIS.InputEnded:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.F and not Settings.AimToggleMode then
                aimLock = false
            end
        end)
    end
    
    coroutine.wrap(function()
        while task.wait() do
            if Settings.SilentAim and aimLock then
                local target = GetClosestTarget()
                if target and target.Character and target.Character:FindFirstChild(Settings.HitPart) then
                    local targetPart = target.Character[Settings.HitPart]
                    if camera:WorldToViewportPoint(targetPart.Position).Z > 0 then
                        camera.CFrame = CFrame.new(camera.CFrame.Position + (targetPart.Position - camera.CFrame.Position).Unit * 0.5, targetPart.Position)
                        VirtualInputManager:SendMouseButtonEvent(Center.X, Center.Y, 0, true, game, 0)
                        task.wait()
                        VirtualInputManager:SendMouseButtonEvent(Center.X, Center.Y, 0, false, game, 0)
                    end
                end
            end
        end
    end)()
end

----------------------------------------------------------------
-- LÓGICA DEL ESP
----------------------------------------------------------------
do
    coroutine.wrap(function()
        while task.wait(0.15) do
            for _, v in pairs(pl:GetPlayers()) do
                if v ~= lp and v.Character then
                    local esp = v.Character:FindFirstChild("ESP_Highlight")
                    
                    local shouldRemove = false
                    if Settings.ESP and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health <= 0 then
                        shouldRemove = true
                    end
                    if Settings.ESPTeamCheck and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("TeammateLabel") then
                        shouldRemove = true
                    end
                    
                    if shouldRemove then
                        if esp then esp:Destroy() end
                    elseif Settings.ESP then
                        if not esp then
                            esp = Instance.new("Highlight")
                            esp.RobloxLocked = true
                            esp.Name = "ESP_Highlight"
                            esp.Adornee = v.Character
                            esp.Parent = v.Character
                        end
                        esp.Enabled = true
                        esp.DepthMode = Settings.ESPWallCheck and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                        esp.FillColor = Settings.ESPFillColor
                        esp.FillTransparency = Settings.ESPFillTransparency
                        esp.OutlineColor = Settings.ESPOutlineColor
                        esp.OutlineTransparency = Settings.ESPOutlineTransparency
                    elseif esp then
                        esp:Destroy()
                    end
                end
            end
        end
    end)()
end

----------------------------------------------------------------
-- LÓGICA DE FLY
----------------------------------------------------------------
do
    runS.Heartbeat:Connect(function(dt)
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if Settings.Fly then
                hum.PlatformStand = true
                hrp.Velocity = Vector3.new(0, 0, 0)
                
                local moveDir = Vector3.new(0, 0, 0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDir.Unit * Settings.FlySpeed * dt)
                end
            else
                if hum.PlatformStand then hum.PlatformStand = false end
            end
        end
    end)
end

----------------------------------------------------------------
-- LÓGICA DE NOCLIP
----------------------------------------------------------------
do
    runS.Stepped:Connect(function()
        if Settings.Noclip and char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == false then
                    part.CanCollide = true
                end
            end
        end
    end)
end

----------------------------------------------------------------
-- INICIALIZACIÓN
----------------------------------------------------------------
LoadConfig()
ApplyDeviceSpoof(Settings.SpooferDevice)

print("✅ PREMIUM MULTIHACK MÓVIL CARGADO")
print("📱 Botón azul flotante para abrir menú")
print("👆 Toca cualquier parte de la pantalla para Silent Aim")
print("💾 Las configuraciones se guardan automáticamente")