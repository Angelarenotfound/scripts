local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Interfaz para mostrar los eventos espiados
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.3, 0, 0.7, 0)
Frame.Position = UDim2.new(0.7, 0, 0.3, 0)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 50)
TextLabel.Text = "Event Spy"
TextLabel.Parent = Frame

-- Función para espiar eventos en objetos específicos
local function spyOnEvents(object)
    local objectLabel = Instance.new("TextLabel")
    objectLabel.Size = UDim2.new(1, 0, 0, 30)
    objectLabel.Text = "Espiando: " .. object.Name
    objectLabel.Parent = Frame

    -- Ejemplo: Espiar cambios en propiedades
    object:GetPropertyChangedSignal("Position"):Connect(function()
        local eventLabel = Instance.new("TextLabel")
        eventLabel.Size = UDim2.new(1, 0, 0, 20)
        eventLabel.Text = "Posición cambió en: " .. object.Name
        eventLabel.Parent = Frame
    end)

    -- Ejemplo: Espiar clics
    if object:IsA("ClickDetector") then
        object.MouseClick:Connect(function(player)
            local eventLabel = Instance.new("TextLabel")
            eventLabel.Size = UDim2.new(1, 0, 0, 20)
            eventLabel.Text = "Click detectado en: " .. object.Parent.Name .. " por " .. player.Name
            eventLabel.Parent = Frame
        end)
    end
end

-- Ejemplo: Espiar todos los objetos en el Workspace
for _, object in pairs(Workspace:GetDescendants()) do
    spyOnEvents(object)
end