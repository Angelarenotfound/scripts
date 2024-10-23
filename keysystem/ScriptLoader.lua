local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local VerifyButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0, -150) -- Comienza fuera de la pantalla
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.ClipsDescendants = true

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
InfoLabel.TextScaled = true
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

Frame.Position = UDim2.new(0.5, -200, 0, -150) -- Ajusta la posición inicial
Frame:TweenPosition(UDim2.new(0.5, -200, 0.5, -150), "Out", "Quint", 0.5, true)

VerifyButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key and key ~= "" then
        local HttpService = game:GetService("HttpService")
        local url = "https://adonis-except.xyz/api/roblox/scripts/keysystem/verify"
        local data = HttpService:JSONEncode({key = key})
        
        local success, response = pcall(function()
            return HttpService:PostAsync(url, data, Enum.HttpContentType.ApplicationJson)
        end)
        
        if success then
            local result = HttpService:JSONDecode(response)
            if result.success then
                -- Key válida
                KeyInput.PlaceholderText = "Key Valida"
                KeyInput.TextColor3 = Color3.fromRGB(0, 255, 0)
                wait(1)
                ScreenGui:Destroy() loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/AnimeTycoon.lua"))()
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
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function closeWithAnimation()
    KeyInput.PlaceholderText = "Cerrando..."
    wait(1)
    Frame:TweenPosition(UDim2.new(0.5, -200, 0, -150), "Out", "Quint", 0.5, true)
    wait(0.5) -- Esperar a que termine la animación
    ScreenGui:Destroy() -- Cierra el GUI
end

CloseButton.MouseButton1Click:Connect(closeWithAnimation)
