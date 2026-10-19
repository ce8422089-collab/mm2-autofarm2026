-- SERVICIOS DE ROBLOX
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- VARIABLES DE ESTADO
local AutofarmActivo = false
local AntiAfkActivo = true
local VELOCIDAD = 30
local LIMITE_MONEDAS = 50
local monedasRecolectadas = 0
local currentTween = nil

-- ANTI-AFK AUTOMÁTICO
LocalPlayer.Idled:Connect(function()
    if AntiAfkActivo then
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

-- INTERFAZ VISUAL (GUI SIMPLIFICADA)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Autofarm"
ScreenGui.ResetOnSpawn = false

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 210)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "MM2 AUTOFARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botón 1: Autofarm
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 200, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "Autofarm: APAGADO"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = ToggleButton

-- Botón 2: Anti-AFK (Alternable)
local AfkButton = Instance.new("TextButton")
AfkButton.Name = "AfkButton"
AfkButton.Size = UDim2.new(0, 200, 0, 35)
AfkButton.Position = UDim2.new(0, 20, 0, 95)
AfkButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
AfkButton.Text = "Anti-AFK: ENCENDIDO"
AfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkButton.Font = Enum.Font.SourceSansBold
AfkButton.TextSize = 14
AfkButton.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = AfkButton

-- Barra Deslizante de Velocidad (Slider)
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Name = "SliderLabel"
SliderLabel.Size = UDim2.new(0, 200, 0, 20)
SliderLabel.Position = UDim2.new(0, 20, 0, 140)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Velocidad: 30"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.SourceSans
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = MainFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SliderFrame"
SliderFrame.Size = UDim2.new(0, 200, 0, 8)
SliderFrame.Position = UDim2.new(0, 20, 0, 165)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderFrame.BorderSizePixel = 0
SliderFrame.Parent = MainFrame

local SliderFrameCorner = Instance.new("UICorner")
SliderFrameCorner.CornerRadius = UDim.new(1, 0)
SliderFrameCorner.Parent = SliderFrame

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(0.2, -7, 0.5, -7)
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderButton.Text = ""
SliderButton.Parent = SliderFrame

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

-- Botón Cerrar (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -32, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- RESETEAR CONTADOR AL RESPAWNEAR
LocalPlayer.CharacterAdded:Connect(function()
    monedasRecolectadas = 0
end)

-- BÚSQUEDA DE MONEDAS
local function obtenerMonedas()
    local monedas = {}
    for _, objeto in pairs(Workspace:GetDescendants()) do
        if (objeto.Name == "Coin_Token" or objeto.Name == "Coin") and objeto:IsA("BasePart") then
            table.insert(monedas, objeto)
        end
    end
    return monedas
end

-- MOVIMIENTO CON PERSONAJE ACOSTADO
local function moverHacia(objetivoPosicion)
    local personaje = LocalPlayer.Character
    if not personaje or not personaje:FindFirstChild("HumanoidRootPart") then return end
    local root = personaje.HumanoidRootPart
    
    local distancia = (root.Position - objetivoPosicion).Magnitude
    if distancia < 1 then return end
    
    local tiempo = distancia / VELOCIDAD
    local infoTween = TweenInfo.new(tiempo, Enum.EasingStyle.Linear)
    local cframeAcostado = CFrame.new(objetivoPosicion) * CFrame.Angles(math.rad(-90), 0, 0)
    
    root.Anchored = true
    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(root, infoTween, {CFrame = cframeAcostado})
    currentTween:Play()
    
    local completed = false
    local connection
    connection = currentTween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)
    
    while not completed and AutofarmActivo and personaje.Parent do
        task.wait(0.02)
    end
    
    if currentTween then currentTween:Cancel() end
    root.Anchored = false
end

-- BUCLE PRINCIPAL
task.spawn(function()
    while task.wait(0.3) do
        if AutofarmActivo then
            local personaje = LocalPlayer.Character
            local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
            
            if personaje and humanoid and humanoid.Health > 0 then
                local listaMonedas = obtenerMonedas()
                
                if #listaMonedas > 0 then
                    for _, moneda in pairs(listaMonedas) do
                        if not AutofarmActivo then break end 
                        if monedasRecolectadas >= LIMITE_MONEDAS then break end
                        
                        if moneda and moneda.Parent then
                            moverHacia(moneda.Position)
                            monedasRecolectadas = monedasRecolectadas + 1
                            task.wait(0.02)
                        end
                    end
                end
                
                -- AUTO-RESET ÚNICAMENTE AL LLEGAR A 50 MONEDAS
                if AutofarmActivo and monedasRecolectadas >= LIMITE_MONEDAS then
                    humanoid.Health = 0
                    monedasRecolectadas = 0
                    repeat task.wait() until LocalPlayer.Character ~= personaje
                end
            end
        end
    end
end)

-- CONTROLES DE LA BARRA DESLIZANTE
local arrastrandoSlider = false
local function actualizarSlider(input)
    local rangoBarraX = SliderFrame.AbsoluteSize.X
    local mouseX = input.Position.X - SliderFrame.AbsolutePosition.X
    local porcentaje = math.clamp(mouseX / rangoBarraX, 0, 1)
    SliderButton.Position = UDim2.new(porcentaje, -7, 0.5, -7)
    local minVel = 10
    local maxVel = 80
    VELOCIDAD = math.round(minVel + (porcentaje * (maxVel - minVel)))
    SliderLabel.Text = "Velocidad: " .. VELOCIDAD
end

local inputBeganConn = SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastrandoSlider = true
    end
end)

local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        arrastrandoSlider = false
    end
end)

local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
    if arrastrandoSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        actualizarSlider(input)
    end
end)

-- INTERACCIÓN DE BOTONES
ToggleButton.MouseButton1Click:Connect(function()
    AutofarmActivo = not AutofarmActivo
    if AutofarmActivo then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        ToggleButton.Text = "Autofarm: ENCENDIDO"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleButton.Text = "Autofarm: APAGADO"
        if currentTween then currentTween:Cancel() end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

AfkButton.MouseButton1Click:Connect(function()
    AntiAfkActivo = not AntiAfkActivo
    if AntiAfkActivo then
        AfkButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        AfkButton.Text = "Anti-AFK: ENCENDIDO"
    else
        AfkButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        AfkButton.Text = "Anti-AFK: APAGADO"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    AutofarmActivo = false
    if currentTween then currentTween:Cancel() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
    if inputBeganConn then inputBeganConn:Disconnect() end
    if inputEndedConn then inputEndedConn:Disconnect() end
    if inputChangedConn then inputChangedConn:Disconnect() end
    ScreenGui:Destroy()
end)
