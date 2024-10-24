-- Carga la librería de Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Configuración principal del GUI
local Window = OrionLib:MakeWindow({
    Name = "Angelarenotfound's All Scripts",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AngelScriptsConfig"
})

-- Pantalla de inicio
OrionLib:MakeNotification({
    Name = "Adonis Except",
    Content = "Bienvenid@ a Angelarenotfound's All Scripts",
    Image = "rbxassetid://4483345998", -- Reemplaza este asset ID si tienes otro en mente
    Time = 5
})

-- Scripts Tab
local ScriptsTab = Window:MakeTab({
    Name = "Scripts",
    Icon = "rbxassetid://4483345998", -- Icono de la pestaña, puedes cambiar el asset ID
    PremiumOnly = false
})

-- Botones para cargar los scripts
ScriptsTab:AddButton({
    Name = "Prison Life Silent Aim",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/PrisonLifeSilentAim.lua"))()
    end    
})

ScriptsTab:AddButton({
    Name = "My Turtle Spy Testing",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/MyTurtleSpyTesting.lua"))()
    end    
})

ScriptsTab:AddButton({
    Name = "Jump Button",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/Jumpbutton.lua"))()
    end    
})

ScriptsTab:AddButton({
    Name = "Jujutsu Mobile",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/JujutsuMobile.lua"))()
    end    
})

ScriptsTab:AddButton({
    Name = "Anime Tycoon",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelarenotfound/scripts/main/AnimeTycoon.lua"))()
    end    
})

-- Finaliza el GUI
OrionLib:Init()