--[[
    LINORIA LIB - PREMIUM MULTIHACK (VERSIÓN MÓVIL)
    Totalmente adaptado para pantalla táctil
    Botón flotante para abrir/cerrar
    Tamaños responsivos
]]

-- Configuración de pantalla para móvil
local screenSize = workspace.CurrentCamera.ViewportSize
local isMobile = game:GetService("UserInputService").TouchEnabled

-- Ajustes de tamaño según dispositivo
local ScaleFactor = isMobile and 1.2 or 1
local ButtonSize = isMobile and 60 or 40
local FontSize = isMobile and 16 or 14

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library, ThemeManager, SaveManager

pcall(function()
    Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
end)

if not Library then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "No se pudo cargar Linoria Lib",
        Duration = 5
    })
    return
end

pcall(function()
    ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
    SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
end)

-- Tamaño de ventana adaptado a móvil
local Window = Library:CreateWindow({
    Title = 'PREMIUM MULTIHACK',
    Center = true,
    AutoShow = false, -- No se muestra automáticamente en móvil
    TabPadding = 8,
    Size = isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 600, 0, 500)
})

-- Crear Tabs
local Tabs = {
    Combat = Window:AddTab('⚔️ Combat'),
    Visuals = Window:AddTab('👁️ Visuals'),
    Movement = Window:AddTab('🌀 Movement'),
    Spoofer = Window:AddTab('🎮 Device'),
    Settings = Window:AddTab('⚙️ Settings')
}

-- Groupboxes
local CombatGroup = Tabs.Combat:AddLeftGroupbox('Aimbot Settings')
local CombatChecks = Tabs.Combat:AddRightGroupbox('Combat Checks')
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox('ESP Settings')
local VisualsColors = Tabs.Visuals:AddRightGroupbox('Colors')
local MovementGroup = Tabs.Movement:AddLeftGroupbox('Fly Settings')
local NoclipGroup = Tabs.Movement:AddRightGroupbox('Noclip')
local SpooferGroup = Tabs.Spoofer:AddLeftGroupbox('Device Simulation')

----------------------------------------------------------------
-- SERVICIOS Y VARIABLES GLOBALES
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

local mousePPos = UIS:GetMouseLocation()
local Center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

runS.RenderStepped:Connect(function() 
    mousePPos = UIS:GetMouseLocation() 
    Center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

lp.CharacterAdded:Connect(function(newChar)
    char = newChar
end)

----------------------------------------------------------------
-- VARIABLES DEL SCRIPT
----------------------------------------------------------------
local ScriptSettings = {
    SilentAim = false,
    AimTeamCheck = true,
    AimWallCheck = true,
    Wallbang = false,
    AimToggleMode = true,
    HitPart = "HitboxHead",
    
    ESP = false,
    ESPTeamCheck = true,
    ESPWallCheck = false,
    ESPFillColor = Color3.fromRGB(255, 255, 255),
    ESPFillTransparency = 0.5,
    ESPOutlineColor = Color3.fromRGB(200, 200, 200),
    ESPOutlineTransparency = 0,
    
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    SpooferDevice = "None",
}

----------------------------------------------------------------
-- BOTÓN FLOTANTE PARA MÓVIL (ABRIR/CERRAR MENÚ)
----------------------------------------------------------------
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingMenuButton"
FloatingButton.Size = UDim2.new(0, ButtonSize, 0, ButtonSize)
FloatingButton.Position = UDim2.new(1, -ButtonSize - 15, 0, 50) -- Esquina superior derecha
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FloatingButton.BackgroundTransparency = 0.1
FloatingButton.Image = "rbxassetid://6031091087" -- Icono de menú hamburguesa
FloatingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.ScaleType = Enum.ScaleType.Fit
FloatingButton.Parent = game:GetService("CoreGui")

-- Borde redondeado
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = FloatingButton

-- Sombra del botón
local ButtonShadow = Instance.new("Frame")
ButtonShadow.Size = UDim2.new(1, 4, 1, 4)
ButtonShadow.Position = UDim2.new(0, -2, 0, -2)
ButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ButtonShadow.BackgroundTransparency = 0.5
ButtonShadow.BorderSizePixel = 0
ButtonShadow.ZIndex = 0
ButtonShadow.Parent = FloatingButton

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(1, 0)
ShadowCorner.Parent = ButtonShadow

-- Arrastrar el botón flotante (toque y arrastre para móvil)
local dragging = false
local dragStartPos
local buttonStartPos

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
        local newX = math.clamp(buttonStartPos.X.Offset + delta.X, 10, screenSize.X - ButtonSize - 10)
        local newY = math.clamp(buttonStartPos.Y.Offset + delta.Y, 50, screenSize.Y - ButtonSize - 50)
        FloatingButton.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Abrir/cerrar menú al tocar el botón
local menuVisible = false
FloatingButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    if menuVisible then
        Window:Show()
        -- Animación de aparición
        FloatingButton:TweenSize(UDim2.new(0, ButtonSize + 5, 0, ButtonSize + 5), "Out", "Quad", 0.1, true)
        task.wait(0.1)
        FloatingButton:TweenSize(UDim2.new(0, ButtonSize, 0, ButtonSize), "Out", "Quad", 0.1, true)
    else
        Window:Hide()
    end
end)

-- Ocultar ventana inicialmente en móvil
if isMobile then
    Window:Hide()
    menuVisible = false
end

----------------------------------------------------------------
-- CREAR UI ELEMENTOS (TAMAÑOS ADAPTADOS)
----------------------------------------------------------------

-- COMBAT GROUPBOX
CombatGroup:AddToggle('SilentAim', {
    Text = 'Enable Silent Aim',
    Default = ScriptSettings.SilentAim,
    Tooltip = 'Apunta automáticamente (Toque en pantalla para activar)',
    Callback = function(v)
        ScriptSettings.SilentAim = v
        if v then
            Library:Notify('Silent Aim', 'Activado - Toca el botón flotante para ajustes', 2)
        end
    end
})

CombatGroup:AddToggle('AimToggleMode', {
    Text = 'Toggle Mode',
    Default = ScriptSettings.AimToggleMode,
    Tooltip = 'Activar/Desactivar con toque | Desactivado = Mantener toque',
    Callback = function(v)
        ScriptSettings.AimToggleMode = v
    end
})

CombatGroup:AddDropdown('HitPart', {
    Text = 'Hit Part',
    Values = {"HitboxHead", "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"},
    Default = 1,
    Multi = false,
    Callback = function(v)
        ScriptSettings.HitPart = v
    end
})

-- COMBAT CHECKS
CombatChecks:AddToggle('AimTeamCheck', {
    Text = 'Team Check',
    Default = ScriptSettings.AimTeamCheck,
    Tooltip = 'No apunta a compañeros',
    Callback = function(v)
        ScriptSettings.AimTeamCheck = v
    end
})

CombatChecks:AddToggle('AimWallCheck', {
    Text = 'Wall Check',
    Default = ScriptSettings.AimWallCheck,
    Tooltip = 'Solo apunta si es visible',
    Callback = function(v)
        ScriptSettings.AimWallCheck = v
    end
})

CombatChecks:AddToggle('Wallbang', {
    Text = 'Wallbang',
    Default = ScriptSettings.Wallbang,
    Tooltip = 'Atraviesa paredes',
    Callback = function(v)
        ScriptSettings.Wallbang = v
    end
})

-- VISUALS GROUPBOX
VisualsGroup:AddToggle('ESP', {
    Text = 'Enable ESP',
    Default = ScriptSettings.ESP,
    Tooltip = 'Marca a los jugadores',
    Callback = function(v)
        ScriptSettings.ESP = v
    end
})

VisualsGroup:AddToggle('ESPTeamCheck', {
    Text = 'Team Check',
    Default = ScriptSettings.ESPTeamCheck,
    Tooltip = 'No marca a compañeros',
    Callback = function(v)
        ScriptSettings.ESPTeamCheck = v
    end
})

VisualsGroup:AddToggle('ESPWallCheck', {
    Text = 'Wall Check',
    Default = ScriptSettings.ESPWallCheck,
    Tooltip = 'ESP se oculta detrás de paredes',
    Callback = function(v)
        ScriptSettings.ESPWallCheck = v
    end
})

-- VISUALS COLORS
VisualsColors:AddLabel('Fill Color'):AddColorPicker('ESPFillColor', {
    Default = ScriptSettings.ESPFillColor,
    Title = 'Fill Color',
    Callback = function(v)
        ScriptSettings.ESPFillColor = v
    end
})

VisualsColors:AddSlider('ESPFillTransparency', {
    Text = 'Fill Transparency',
    Default = ScriptSettings.ESPFillTransparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(v)
        ScriptSettings.ESPFillTransparency = v
    end
})

VisualsColors:AddLabel('Outline Color'):AddColorPicker('ESPOutlineColor', {
    Default = ScriptSettings.ESPOutlineColor,
    Title = 'Outline Color',
    Callback = function(v)
        ScriptSettings.ESPOutlineColor = v
    end
})

VisualsColors:AddSlider('ESPOutlineTransparency', {
    Text = 'Outline Transparency',
    Default = ScriptSettings.ESPOutlineTransparency,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(v)
        ScriptSettings.ESPOutlineTransparency = v
    end
})

-- MOVEMENT
MovementGroup:AddToggle('Fly', {
    Text = 'Enable Fly',
    Default = ScriptSettings.Fly,
    Tooltip = 'Activa el vuelo (Botones virtuales en pantalla)',
    Callback = function(v)
        ScriptSettings.Fly = v
    end
})

MovementGroup:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = ScriptSettings.FlySpeed,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(v)
        ScriptSettings.FlySpeed = v
    end
})

NoclipGroup:AddToggle('Noclip', {
    Text = 'Enable Noclip',
    Default = ScriptSettings.Noclip,
    Tooltip = 'Atraviesa paredes',
    Callback = function(v)
        ScriptSettings.Noclip = v
    end
})

-- DEVICE SPOOFER
SpooferGroup:AddDropdown('SpooferDevice', {
    Text = 'Simulate Device',
    Values = { 'None', 'Xbox', 'PlayStation', 'VR' },
    Default = 1,
    Multi = false,
    Tooltip = 'Simula un dispositivo',
    Callback = function(v)
        ScriptSettings.SpooferDevice = v
        ApplyDeviceSpoof(v)
    end
})

SpooferGroup:AddButton({
    Text = 'Apply Spoofer',
    Func = function()
        ApplyDeviceSpoof(ScriptSettings.SpooferDevice)
        Library:Notify('Device Spoofer', 'Dispositivo cambiado a: ' .. ScriptSettings.SpooferDevice, 3)
    end,
    Tooltip = 'Aplica el spoofer'
})

----------------------------------------------------------------
-- FUNCIONES
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

-- Aimbot logic (adaptado para móvil)
do
    local aimLock = false
    
    -- En móvil, usamos el toque en pantalla como activador
    local function GetClosestTarget()
        local closestTarget = nil
        local closestDist = math.huge
        
        for _, v in ipairs(pl:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild(ScriptSettings.HitPart) then
                local hum = v.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then continue end
                
                if not ScriptSettings.Wallbang then
                    local ray = workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(camera.CFrame.Position,
                        (v.Character[ScriptSettings.HitPart].Position - camera.CFrame.Position).Unit *
                        (v.Character[ScriptSettings.HitPart].Position - camera.CFrame.Position).Magnitude),
                        {lp.Character, camera}
                    )
                    if ScriptSettings.AimWallCheck and (not ray or not ray:IsDescendantOf(v.Character)) then continue end
                end
                
                if ScriptSettings.AimTeamCheck and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("TeammateLabel") then continue end
                
                local vPos, onScreen = camera:WorldToViewportPoint(v.Character[ScriptSettings.HitPart].Position)
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
    
    -- Para móvil: usar toque en pantalla (cualquier toque activa el aim)
    if isMobile then
        UIS.TouchTap:Connect(function(touchPositions)
            if ScriptSettings.SilentAim then
                if ScriptSettings.AimToggleMode then
                    aimLock = not aimLock
                    Library:Notify('Silent Aim', aimLock and 'Activado' or 'Desactivado', 1)
                else
                    aimLock = true
                end
            end
        end)
        
        UIS.TouchEnded:Connect(function()
            if not ScriptSettings.AimToggleMode then
                aimLock = false
            end
        end)
    else
        -- PC: tecla F
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.F then
                if ScriptSettings.AimToggleMode then
                    aimLock = not aimLock
                    Library:Notify('Silent Aim', aimLock and 'Activado' or 'Desactivado', 1)
                else
                    aimLock = true
                end
            end
        end)
        
        UIS.InputEnded:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.F and not ScriptSettings.AimToggleMode then
                aimLock = false
            end
        end)
    end
    
    coroutine.wrap(function()
        while task.wait() do
            if ScriptSettings.SilentAim and aimLock then
                local target = GetClosestTarget()
                if target and target.Character and target.Character:FindFirstChild(ScriptSettings.HitPart) then
                    local targetPart = target.Character[ScriptSettings.HitPart]
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

-- ESP logic
do
    coroutine.wrap(function()
        while task.wait(0.1) do
            for _, v in pairs(pl:GetPlayers()) do
                if v ~= lp and v.Character then
                    local esp = v.Character:FindFirstChild("ESP_Highlight")
                    
                    local shouldRemove = false
                    if ScriptSettings.ESP and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health <= 0 then
                        shouldRemove = true
                    end
                    if ScriptSettings.ESPTeamCheck and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("TeammateLabel") then
                        shouldRemove = true
                    end
                    
                    if shouldRemove then
                        if esp then esp:Destroy() end
                    elseif ScriptSettings.ESP then
                        if not esp then
                            esp = Instance.new("Highlight")
                            esp.RobloxLocked = true
                            esp.Name = "ESP_Highlight"
                            esp.Adornee = v.Character
                            esp.Parent = v.Character
                        end
                        esp.Enabled = true
                        esp.DepthMode = ScriptSettings.ESPWallCheck and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                        esp.FillColor = ScriptSettings.ESPFillColor
                        esp.FillTransparency = ScriptSettings.ESPFillTransparency
                        esp.OutlineColor = ScriptSettings.ESPOutlineColor
                        esp.OutlineTransparency = ScriptSettings.ESPOutlineTransparency
                    elseif esp then
                        esp:Destroy()
                    end
                end
            end
        end
    end)()
end

-- Fly logic (adaptado para móvil)
do
    -- Controles virtuales para móvil (se pueden añadir botones en pantalla)
    local flyActive = false
    
    runS.Heartbeat:Connect(function(dt)
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if ScriptSettings.Fly then
                hum.PlatformStand = true
                hrp.Velocity = Vector3.new(0, 0, 0)
                
                local moveDir = Vector3.new(0, 0, 0)
                
                if isMobile then
                    -- En móvil, usar el joystick virtual del juego o gestos
                    -- Por defecto, usamos la orientación del dispositivo para moverse
                    local gyro = game:GetService("UserInputService"):GetDeviceOrientation()
                    if gyro then
                        moveDir = Vector3.new(gyro.X, 0, -gyro.Z)
                    end
                    
                    -- También se puede usar toques en pantalla
                    if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:GetFocusedTextBox() then
                        moveDir = moveDir + camera.CFrame.LookVector
                    end
                else
                    -- PC: teclado
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                end
                
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDir.Unit * ScriptSettings.FlySpeed * dt)
                end
            else
                if hum.PlatformStand then hum.PlatformStand = false end
            end
        end
    end)
end

-- Noclip logic
do
    runS.Stepped:Connect(function()
        if ScriptSettings.Noclip and char then
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

-- ThemeManager y SaveManager (opcional)
if ThemeManager then
    pcall(function()
        ThemeManager:SetLibrary(Library)
        ThemeManager:SetFolder('PremiumMultihack_Mobile')
        ThemeManager:ApplyToTab(Tabs.Settings)
    end)
end

if SaveManager then
    pcall(function()
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetFolder('PremiumMultihack_Mobile/saves')
        SaveManager:BuildConfigSection(Tabs.Settings)
    end)
end

-- Notificación de inicio
if isMobile then
    Library:Notify('Premium Multihack Móvil', 'Botón flotante para abrir menú | Toca pantalla para Silent Aim', 5)
else
    Library:Notify('Premium Multihack', 'F4 para abrir/cerrar | F para Silent Aim', 5)
end

-- Abrir/cerrar con F4 (solo PC)
if not isMobile then
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.F4 then
            menuVisible = not menuVisible
            if menuVisible then
                Window:Show()
            else
                Window:Hide()
            end
        end
    end)
end

print("✅ Premium Multihack Móvil cargado correctamente")
print("📱 Botón flotante en esquina superior derecha")
print("👆 Toca el botón para abrir el menú")
print("🎯 Toca cualquier parte de la pantalla para Silent Aim")