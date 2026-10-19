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
local VELOCIDAD = 25
local AL_FINALIZAR_RESET = true
local currentTween = nil

-- ==========================================
-- ANTI-AFK AUTOMÁTICO
-- ==========================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- CREACIÓN DE LA INTERFAZ VISUAL (GUI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Premium_Autofarm"
ScreenGui.ResetOnSpawn = false

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 260)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -130)
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
Title.Text = "MM2 AUTOFARM PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botón 1: Alternar Autofarm
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 200, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "Autofarm: APAGADO"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 15
ToggleButton.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = ToggleButton

-- Botón 2: Resetear Manual
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0, 200, 0, 35)
ResetButton.Position = UDim2.new(0, 20, 0, 100)
ResetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ResetButton.Text = "Resetear Personaje"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.TextSize = 15
ResetButton.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = ResetButton

-- Botón Ocultar Menú
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 200, 0, 30)
HideButton.Position = UDim2.new(0, 20, 0, 145)
HideButton.BackgroundColor3 = Color3.fromRGB(45, 75, 110)
HideButton.Text = "👁️ Ocultar Interfaz"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 14
HideButton.Parent = MainFrame

local BtnCornerHide = Instance.new("UICorner")
BtnCornerHide.CornerRadius = UDim.new(0, 6)
BtnCornerHide.Parent = HideButton

-- Barra Deslizante (Slider)
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Name = "SliderLabel"
SliderLabel.Size = UDim2.new(0, 200, 0, 20)
SliderLabel.Position = UDim2.new(0, 20, 0, 185)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Velocidad de Recogida: 25"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.SourceSans
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = MainFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SliderFrame"
SliderFrame.Size = UDim2.new(0, 200, 0, 8)
SliderFrame.Position = UDim2.new(0, 20, 0, 210)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderFrame.BorderSizePixel = 0
SliderFrame.Parent = MainFrame

local SliderFrameCorner = Instance.new("UICorner")
SliderFrameCorner.CornerRadius = UDim.new(1, 0)
SliderFrameCorner.Parent = SliderFrame

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(0.15, -7, 0.5, -7)
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderButton.Text = ""
SliderButton.Parent = SliderFrame

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

-- Indicador Anti-AFK
local AfkLabel = Instance.new("TextLabel")
AfkLabel.Name = "AfkLabel"
AfkLabel.Size = UDim2.new(0, 200, 0, 20)
AfkLabel.Position = UDim2.new(0, 20, 0, 230)
AfkLabel.BackgroundTransparency = 1
AfkLabel.Text = "🛡️ Anti-AFK: ACTIVO"
AfkLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
AfkLabel.Font = Enum.Font.SourceSansItalic
AfkLabel.TextSize = 12
AfkLabel.Parent = MainFrame

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

-- Botón Flotante
local OpenFloatingButton = Instance.new("TextButton")
OpenFloatingButton.Name = "OpenFloatingButton"
OpenFloatingButton.Size = UDim2.new(0, 50, 0, 30)
OpenFloatingButton.Position = UDim2.new(0, 10, 0, 10)
OpenFloatingButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
OpenFloatingButton.BackgroundTransparency = 0.4
OpenFloatingButton.Text = "Abrir"
OpenFloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenFloatingButton.Font = Enum.Font.SourceSansBold
OpenFloatingButton.TextSize = 14
OpenFloatingButton.Visible = false
OpenFloatingButton.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 6)
FloatingCorner.Parent = OpenFloatingButton

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenFloatingButton.Visible = true
end)

OpenFloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenFloatingButton.Visible = false
end)

-- ==========================================
-- LÓGICA DE MOVIMIENTO Y AUTOFARM OPTIMIZADA
-- ==========================================
local function obtenerMonedas()
    local monedas = {}
    -- Búsqueda más segura abarcando múltiples opciones de contenedores
    local contenedorMapa = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map") or Workspace
    for _, objeto in pairs(contenedorMapa:GetDescendants()) do
        if (objeto.Name == "Coin_Token" or objeto.Name == "Coin") and objeto:IsA("BasePart") then
            table.insert(monedas, objeto)
        end
    end
    return monedas
end

local function moverHacia(objetivoPosicion)
    local personaje = LocalPlayer.Character
    if not personaje or not personaje:FindFirstChild("HumanoidRootPart") then return end
    local root = personaje.HumanoidRootPart
    
    local distancia = (root.Position - objetivoPosicion).Magnitude
    if distancia < 1 then return end
    
    local tiempo = distancia / VELOCIDAD
    local infoTween = TweenInfo.new(tiempo, Enum.EasingStyle.Linear)
    
    if currentTween then currentTween:Cancel() end
    currentTween = TweenService:Create(root, infoTween, {CFrame = CFrame.new(objetivoPosicion)})
    currentTween:Play()
    
    local completed = false
    local connection
    connection = currentTween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)
    
    -- Esperar a que termine o a que interrumpan el proceso
    while not completed and AutofarmActivo and personaje.Parent do
        task.wait(0.05)
    end
    
    if not completed and currentTween then
        currentTween:Cancel()
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if AutofarmActivo then
            local personaje = LocalPlayer.Character
            local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
            
            if personaje and humanoid and humanoid.Health > 0 then
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
                end)
                
                local listaMonedas = obtenerMonedas()
                
                if #listaMonedas > 0 then
                    for _, moneda in pairs(listaMonedas) do
                        if not AutofarmActivo then break end 
                        if moneda and moneda.Parent then
                            moverHacia(moneda.Position)
                            task.wait(0.05)
                        end
                    end
                else
                    -- Esperar un par de segundos antes de resetear si no hay monedas, para evitar bucles locos
                    task.wait(1.5)
                    if AL_FINALIZAR_RESET and AutofarmActivo then
                        if humanoid and humanoid.Health > 0 then
                            humanoid.Health = 0
                            repeat task.wait() until LocalPlayer.Character ~= personaje
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- SCRIPT DE LA BARRA DESLIZANTE (SLIDER)
-- ==========================================
local arrastrandoSlider = false
local function actualizarSlider(input)
    local rangoBarraX = SliderFrame.AbsoluteSize.X
    local mouseX = input.Position.X - SliderFrame.AbsolutePosition.X
    local porcentaje = math.clamp(mouseX / rangoBarraX, 0, 1)
    SliderButton.Position = UDim2.new(porcentaje, -7, 0.5, -7)
    local minVel = 10
    local maxVel = 100
    VELOCIDAD = math.round(minVel + (porcentaje * (maxVel - minVel)))
    SliderLabel.Text = "Velocidad de Recogida: " .. VELOCIDAD
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

-- ==========================================
-- INTERACCIÓN DE LOS BOTONES
-- ==========================================
ToggleButton.MouseButton1Click:Connect(function()
    AutofarmActivo = not AutofarmActivo
    if AutofarmActivo then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        ToggleButton.Text = "Autofarm: ENCENDIDO"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleButton.Text = "Autofarm: APAGADO"
        if currentTween then currentTween:Cancel() end
    end
end)

ResetButton.MouseButton1Click:Connect(function()
    local personaje = LocalPlayer.Character
    local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

CloseButton.MouseButton1Click:Connect(function()
    AutofarmActivo = false
    if currentTween then currentTween:Cancel() end
    -- Limpiar conexiones globales para evitar fugas de memoria
    if inputBeganConn then inputBeganConn:Disconnect() end
    if inputEndedConn then inputEndedConn:Disconnect() end
    if inputChangedConn then inputChangedConn:Disconnect() end
    ScreenGui:Destroy()
end)
