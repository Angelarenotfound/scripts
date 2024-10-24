-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local VerifyButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local HttpService = game:GetService("HttpService")  -- Asegúrate de incluir esto

-- Configurar GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.ClipsDescendants = true

-- Configurar elementos del GUI
TitleLabel.Parent = Frame
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.Text = "Adonis Except Key System"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextStrokeTransparency = 0.5
TitleLabel.BorderSizePixel = 0

InfoLabel.Parent = Frame
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 50)
InfoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfoLabel.Text = "Verifica tu key"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextScaled = true  -- Corregido
InfoLabel.TextStrokeTransparency = 0.5
InfoLabel.BorderSizePixel = 0

KeyInput.Parent = Frame
KeyInput.Size = UDim2.new(1, -20, 0, 40)
KeyInput.Position = UDim2.new(0, 10, 0, 90)
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Ingresa tu key"
KeyInput.TextScaled = true
KeyInput.BorderSizePixel = 2
KeyInput.BorderColor3 = Color3.fromRGB(0, 0, 0)

VerifyButton.Parent = Frame
VerifyButton.Size = UDim2.new(1, 0, 0, 50)
VerifyButton.Position = UDim2.new(0, 0, 0, 140)
VerifyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
VerifyButton.Text = "Verificar"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextScaled = true
VerifyButton.BorderSizePixel = 0

CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.BorderSizePixel = 0

-- Función para verificar la clave
local function verifyKey(key)
    if key and key ~= "" then
        local HTTPProxy = require(game:GetService("ReplicatedStorage"):FindFirstChild("HTTPProxy"))

        local function sendRequest(url, data)
            local proxy = HTTPProxy:GetInstance()
            local response = proxy:SendRequest(url, data)
            return response
        end

        local url = "https://adonis-except.xyz/api/roblox/scripts/keysystem/verify"
        local data = HttpService:JSONEncode({key = key})

        local success, response = pcall(sendRequest, url, data)
        if success then
            local result = HttpService:JSONDecode(response)
            if result.success then
                -- Key válida
                KeyInput.PlaceholderText = "Key Valida"
                KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)
                wait(1)
                ScreenGui:Destroy()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/AnimeTycoon.lua"))()
            elseif result.error then
                KeyInput.PlaceholderText = "Key Incorrecta"
                KeyInput.TextColor3 = Color3.fromRGB(255, 0, 0) -- Rojo
            end
        else
            print("Error en la solicitud: " .. response)
        end
    else
        print("Por favor, ingresa una key.")
    end
end

VerifyButton.MouseButton1Click:Connect(function()
    verifyKey(KeyInput.Text)  -- Conectar el botón a la función
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function closeWithAnimation()
    KeyInput.PlaceholderText = "Cerrando..."
    wait(1)
    Frame:TweenPosition(UDim2.new(0.5, -200, 0, -150), "Out", "Quint", 0.5, true)
    wait(0.5)
    ScreenGui:Destroy()
end

CloseButton.MouseButton1Click:Connect(closeWithAnimation)