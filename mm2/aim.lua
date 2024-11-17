-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Nombre de los ítems
local knifeName = "Knife"
local gunName = "Gun"

-- Función para verificar si un jugador tiene un ítem en su inventario
local function hasItem(player, itemName)
    local backpack = player.Backpack
    if backpack:FindFirstChild(itemName) then
        return true
    end
    local character = player.Character
    if character and character:FindFirstChild(itemName) then
        return true
    end
    return false
end

-- Función para enfocar la cámara en el torso de un jugador
local function focusOnPlayer(player)
    local character = player.Character
    if character then
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            Camera.CameraSubject = torso
        end
    end
end

-- Verificar si el jugador local tiene el ítem Gun equipado
local function isGunEquipped()
    local character = LocalPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool.Name == gunName then
            return true
        end
    end
    return false
end

-- Monitorear el estado del Gun y buscar jugadores con Knife
local function updateCamera()
    if isGunEquipped() then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and hasItem(player, knifeName) then
                focusOnPlayer(player)
                return
            end
        end
    else
        -- Resetear la cámara al estado normal
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end

-- Conectar eventos
LocalPlayer.Character.ChildAdded:Connect(updateCamera)
LocalPlayer.Backpack.ChildAdded:Connect(updateCamera)
LocalPlayer.Character.ChildRemoved:Connect(updateCamera)

-- Monitorear constantemente si el estado cambia
while true do
    updateCamera()
    wait(1)  -- Puedes ajustar la frecuencia de actualización
end