-- SERVICIOS DE ROBLOX
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- CONFIGURACIÓN SIMPLE Y SEGURA
local AutofarmActivo = false
local AntiAfkActivo = true
local VELOCIDAD_SEGURA = 20
local LIMITE_MONEDAS = 50
local monedasRecolectadas = 0

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    if AntiAfkActivo then
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

-- RESETEAR CONTADOR AL RESPAWNEAR
LocalPlayer.CharacterAdded:Connect(function()
    monedasRecolectadas = 0
end)

-- INTERFAZ CON ESTILO HALLOWEEN 🎃
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Halloween_Autofarm"
ScreenGui.ResetOnSpawn = false

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25) -- Morado noche de Halloween
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
Title.BackgroundColor3 = Color3.fromRGB(230, 90, 0) -- Naranja Calabaza
Title.Text = "🎃 MM2 HALLOWEEN 🦇"
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
ToggleButton.Size = UDim2.new(0, 180, 0, 35)
ToggleButton.Position = UDim2.new(0, 20, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
ToggleButton.Text = "👻 Farm: APAGADO"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = ToggleButton

-- Botón 2: Anti-AFK
local AfkButton = Instance.new("TextButton")
AfkButton.Name = "AfkButton"
AfkButton.Size = UDim2.new(0, 180, 0, 35)
AfkButton.Position = UDim2.new(0, 20, 0, 95)
AfkButton.BackgroundColor3 = Color3.fromRGB(40, 140, 50)
AfkButton.Text = "🛡️ Anti-AFK: ACTIVADO"
AfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkButton.Font = Enum.Font.SourceSansBold
AfkButton.TextSize = 14
AfkButton.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = AfkButton

-- Texto de Monedas / Estado
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0, 180, 0, 25)
StatusLabel.Position = UDim2.new(0, 20, 0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🍬 Monedas: 0 / 50"
StatusLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- Botón Cerrar (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.Text = "✖"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 12
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- BÚSQUEDA Y MOVIMIENTO SIMPLE
local function obtenerMonedas()
    local monedas = {}
    for _, objeto in pairs(Workspace:GetDescendants()) do
        if (objeto.Name == "Coin_Token" or objeto.Name == "Coin") and objeto:IsA("BasePart") then
            table.insert(monedas, objeto)
        end
    end
    return monedas
end

local function irAMoneda(posicion)
    local personaje = LocalPlayer.Character
    if not personaje then return end
    local root = personaje:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local distancia = (root.Position - posicion).Magnitude
    local tiempo = distancia / VELOCIDAD_SEGURA
    
    local info = TweenInfo.new(tiempo, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, info, {CFrame = CFrame.new(posicion)})
    tween:Play()
    tween.Completed:Wait()
end

-- BUCLE PRINCIPAL SIMPLE
task.spawn(function()
    while task.wait(0.5) do
        if AutofarmActivo then
            local personaje = LocalPlayer.Character
            local humanoid = personaje and personaje:FindFirstChildOfClass("Humanoid")
            
            if personaje and humanoid and humanoid.Health > 0 then
                local lista = obtenerMonedas()
                
                if #lista > 0 then
                    for _, moneda in pairs(lista) do
                        if not AutofarmActivo then break end
                        if monedasRecolectadas >= LIMITE_MONEDAS then break end
                        
                        if moneda and moneda.Parent then
                            irAMoneda(moneda.Position)
                            monedasRecolectadas = monedasRecolectadas + 1
                            StatusLabel.Text = "🍬 Monedas: " .. monedasRecolectadas .. " / " .. LIMITE_MONEDAS
                            task.wait(0.1)
                        end
                    end
                end
                
                -- AUTO-RESET AL LLEGAR A 50
                if AutofarmActivo and monedasRecolectadas >= LIMITE_MONEDAS then
                    humanoid.Health = 0
                    monedasRecolectadas = 0
                    StatusLabel.Text = "🍬 Monedas: 0 / 50"
                    repeat task.wait() until LocalPlayer.Character ~= personaje
                end
            end
        end
    end
end)

-- EVENTOS DE BOTONES
ToggleButton.MouseButton1Click:Connect(function()
    AutofarmActivo = not AutofarmActivo
    if AutofarmActivo then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 140, 50)
        ToggleButton.Text = "🎃 Farm: ENCENDIDO"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        ToggleButton.Text = "👻 Farm: APAGADO"
    end
end)

AfkButton.MouseButton1Click:Connect(function()
    AntiAfkActivo = not AntiAfkActivo
    if AntiAfkActivo then
        AfkButton.BackgroundColor3 = Color3.fromRGB(40, 140, 50)
        AfkButton.Text = "🛡️ Anti-AFK: ACTIVADO"
    else
        AfkButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        AfkButton.Text = "🛡️ Anti-AFK: DESACTIVADO"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    AutofarmActivo = false
    ScreenGui:Destroy()
end)
