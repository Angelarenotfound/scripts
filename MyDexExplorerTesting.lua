local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Crear una pantalla para el explorador
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.3, 0, 0.7, 0)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 50)
TextLabel.Text = "Workspace Explorer"
TextLabel.Parent = Frame

-- Función para agregar los objetos al explorador
local function addObjectToExplorer(object, parentFrame)
    local newLabel = Instance.new("TextButton")
    newLabel.Size = UDim2.new(1, 0, 0, 30)
    newLabel.Text = object.Name .. " (" .. object.ClassName .. ")"
    newLabel.Parent = parentFrame

    -- Si el objeto tiene hijos, crear un contenedor para mostrar los hijos
    if #object:GetChildren() > 0 then
        local childrenFrame = Instance.new("Frame")
        childrenFrame.Size = UDim2.new(1, -20, 0, #object:GetChildren() * 30)
        childrenFrame.Position = UDim2.new(0, 10, 0, 30)
        childrenFrame.Visible = false
        childrenFrame.Parent = parentFrame

        newLabel.MouseButton1Click:Connect(function()
            childrenFrame.Visible = not childrenFrame.Visible
        end)

        -- Agregar hijos al explorador
        for _, child in pairs(object:GetChildren()) do
            addObjectToExplorer(child, childrenFrame)
        end
    end
end

-- Función para inicializar el explorador de Workspace
local function initExplorer()
    for _, object in pairs(Workspace:GetChildren()) do
        addObjectToExplorer(object, Frame)
    end
end

-- Ejecutar el explorador
initExplorer()