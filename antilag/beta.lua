local function reduceLagExploit()
    -- Reducir la calidad gráfica localmente
    local settings = UserSettings():GetService("UserGameSettings")
    settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 -- Calidad mínima

    -- Reducir el campo de visión (FOV) y limitar el zoom de la cámara
    local camera = game.Workspace.CurrentCamera
    camera.FieldOfView = 70 -- Campo de visión ajustado
    camera.MaxZoomDistance = 30 -- Distancia de zoom limitada

    -- Apagar las sombras locales
    game.Lighting.GlobalShadows = false

    -- Ajustar la iluminación para reducir el impacto gráfico
    game.Lighting.Brightness = 1
    game.Lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3) -- Iluminación exterior reducida
    game.Lighting.EnvironmentDiffuseScale = 0 -- Quitar luz difusa
    game.Lighting.EnvironmentSpecularScale = 0 -- Eliminar brillos especulares

    -- Cambiar todas las partes a plástico suave y desactivar sombras locales
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.SmoothPlastic -- Plástico suave
            part.Reflectance = 0 -- Eliminar reflejos
            part.CastShadow = false -- Desactivar sombras en cada parte
        end
    end

    -- Apagar los emisores de partículas, humo, fuego, y otros efectos visuales locales
    for _, descendant in pairs(game.Workspace:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
            descendant.Enabled = false -- Desactivar efectos visuales
        end
    end

    -- Apagar los sonidos 3D locales
    for _, sound in pairs(game.Workspace:GetDescendants()) do
        if sound:IsA("Sound") and sound.IsPlaying then
            sound.Playing = false -- Detener sonidos en reproducción
        end
    end

    -- Optimización dinámica: reducir visibilidad de partes a distancia
    local function optimizeParts()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                local distance = (humanoidRootPart.Position - part.Position).Magnitude
                if distance > 200 then -- Si está demasiado lejos, hacerlo invisible
                    part.Transparency = 1
                else
                    part.Transparency = 0 -- Visible si está cerca
                end
            end
        end
    end

    -- Apagar luces distantes del jugador
    local function optimizeLights()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        for _, light in pairs(game.Workspace:GetDescendants()) do
            if light:IsA("PointLight") or light:IsA("SpotLight") or light:IsA("SurfaceLight") then
                local distance = (humanoidRootPart.Position - light.Parent.Position).Magnitude
                if distance > 100 then -- Si la luz está lejos, apagarla
                    light.Enabled = false
                else
                    light.Enabled = true
                end
            end
        end
    end

    -- Reducir nivel de detalle (LOD) de las MeshParts
    local function optimizeMeshes()
        for _, part in pairs(game.Workspace:GetDescendants()) do
            if part:IsA("MeshPart") then
                part.RenderFidelity = Enum.RenderFidelity.Performance -- Usar LOD bajo
            end
        end
    end

    -- Ejecutar optimizaciones dinámicas
    optimizeParts()
    optimizeLights()
    optimizeMeshes()

    print("Reducción de lag aplicada exitosamente.")
end

-- Ejecutar la función de reducción de lag
reduceLagExploit()