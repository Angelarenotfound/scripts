local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local cameraEnabled = false  -- Inicialmente deshabilitado

local knifeName = "Knife"
local gunName = "Gun"

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

local function focusOnPlayer(player)
    local character = player.Character
    if character then
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            Camera.CameraSubject = torso
        end
    end
end

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

local function updateCamera()
    if not cameraEnabled then return end  -- No hacer nada si está deshabilitado

    if isGunEquipped() then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and hasItem(player, knifeName) then
                focusOnPlayer(player)
                return
            end
        end
    else
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end

LocalPlayer.Character.ChildAdded:Connect(updateCamera)
LocalPlayer.Backpack.ChildAdded:Connect(updateCamera)
LocalPlayer.Character.ChildRemoved:Connect(updateCamera)

-- Loop para actualizar la cámara solo si está habilitada
while true do
    if cameraEnabled then
        updateCamera()
    end
    wait(1)
end

-- Función para alternar el estado de la cámara
local function toggleCamera(state)
    cameraEnabled = state
    if not state then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end