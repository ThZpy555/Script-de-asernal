

-- SaranyBloxHub VIP Ultimate Script
-- By ThZy

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = Rayfield:CreateWindow({
    Name = "SaranyBlox Hub VIP",
    LoadingTitle = "SaranyBlox Hub VIP",
    LoadingSubtitle = "By ThZy",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "SaranyBloxHubVIP"
    }
})

local TabPrincipal = Window:CreateTab("Principal", 4483362458)
local TabFarm = Window:CreateTab("Farm", 4483362458)
local TabExtras = Window:CreateTab("Extras", 4483362458)
local TabESP = Window:CreateTab("ESP", 4483362458)

-- Variables
local AimbotAtivo = false
local DISTANCIA_MAX = 150

-- Helpers
local function GetClosestEnemy()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local closest, minDist = nil, DISTANCIA_MAX
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local dist = (char.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = mob
            end
        end
    end
    return closest
end

-- Aimbot soco + arma (gruda e ataca)
RunService.RenderStepped:Connect(function()
    if AimbotAtivo then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local enemy = GetClosestEnemy()
        if enemy then
            char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
            char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, enemy.HumanoidRootPart.Position)

            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            else
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Attacking)
            end
        end
    end
end)

-- Principal Tab
TabPrincipal:CreateToggle({
    Name = "Aimbot Soco + Arma",
    CurrentValue = false,
    Callback = function(v)
        AimbotAtivo = v
    end
})

TabPrincipal:CreateToggle({
    Name = "Velocidade Alta",
    CurrentValue = false,
    Callback = function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = v and 50 or 16
        end
    end
})

TabPrincipal:CreateSlider({
    Name = "Altura do Pulo",
    Range = {0, 120},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.JumpPower = val
        end
    end
})

-- Farm Tab
-- Auto Haki
local AutoHaki = false
TabFarm:CreateToggle({
    Name = "Auto Haki",
    CurrentValue = false,
    Callback = function(v)
        AutoHaki = v
        spawn(function()
            while AutoHaki do
                task.wait(1)
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end)
            end
        end)
    end
})

-- Variável de controle
local AutoFruta = false

-- Cria o botão no menu
TabExtras:CreateToggle({
    Name = "Auto Frutas (Coletar Sozinho)",
    CurrentValue = false,
    Callback = function(State)
        AutoFruta = State
        if AutoFruta then
            task.spawn(function()
                while AutoFruta do
                    task.wait(1)
                    pcall(function()
                        for _, obj in pairs(workspace:GetChildren()) do
                            if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                                -- Move até a fruta
                                LocalPlayer.Character:MoveTo(obj.Handle.Position + Vector3.new(0, 3, 0))
                                task.wait(2)
                                break -- só anda até uma por vez
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- Auto Skills Z, X, C
local function createAutoSkillToggle(skill)
    local toggle = false
    TabFarm:CreateToggle({
        Name = "Auto " .. skill,
        CurrentValue = false,
        Callback = function(v)
            toggle = v
            spawn(function()
                while toggle do
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, skill, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, skill, false, game)
                end
            end)
        end
    })
end

createAutoSkillToggle("Z")
createAutoSkillToggle("X")
createAutoSkillToggle("C")

-- Auto Farm Boss (simples)
local AutoFarmBoss = false
TabFarm:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(v)
        AutoFarmBoss = v
        spawn(function()
            while AutoFarmBoss do
                task.wait(0.1)
                local boss = Workspace:FindFirstChild("Boss") or Workspace:FindFirstChild("RaidBoss")
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, boss.HumanoidRootPart.Position)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        else
                            char.Humanoid:ChangeState(Enum.HumanoidStateType.Attacking)
                        end
                    end
                end
            end
        end)
    end
})

-- Auto Rebirth
local AutoRebirth = false
TabFarm:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(v)
        AutoRebirth = v
        spawn(function()
            while AutoRebirth do
                task.wait(10)
                pcall(function()
                    ReplicatedStorage.Remotes.Rebirth:InvokeServer()
                end)
            end
        end)
    end
})

-- Extras Tab
-- Teleportes VIP frutas
local teleportLocations = {
    ["Ilha Inicial"] = Vector3.new(973, 38, 1427),
    ["Jungle"] = Vector3.new(-1618, 36, 146),
    ["Marine"] = Vector3.new(-2604, 20, 2032),
    ["Sky Island"] = Vector3.new(2254, 200, 500),
    ["Deserto"] = Vector3.new(-1080, 50, -1700)
}

for name, pos in pairs(teleportLocations) do
    TabExtras:CreateButton({
        Name = "Teleporte para " .. name,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(pos)
            end
        end
    })
end

-- O melhor rápido (Auto andar + achar frutas automaticamente)
local MelhorRapido = false
TabExtras:CreateToggle({
    Name = "O melhor rápido",
    CurrentValue = false,
    Callback = function(v)
        MelhorRapido = v
        spawn(function()
            while MelhorRapido do
                task.wait(1)
                pcall(function()
                    -- Procurar frutas no mapa
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                            LocalPlayer.Character:MoveTo(obj.Handle.Position + Vector3.new(0, 3, 0))
                            task.wait(2)
                            break
                        end
                    end

                    -- Movimentação aleatória pelo mapa
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local x = math.random(-5000, 5000)
                        local z = math.random(-5000, 5000)
                        local newPos = Vector3.new(x, 50, z)
                        char:MoveTo(newPos)
                    end
                end)
            end
        end)
    end
})

-- FPS Boost (deixa jogo rápido e sem travamento)
-- Procurar frutas automaticamente (Extras)
TabExtras:CreateButton({
    Name = "Achar Frutas Próximas",
    Callback = function()
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                LocalPlayer.Character:MoveTo(obj.Handle.Position + Vector3.new(0, 3, 0))
                break
            end
        end
    end
})

local FPSBoostAtivo = false
TabExtras:CreateToggle({
    Name = "FPS Boost (mais rápido)",
    CurrentValue = false,
    Callback = function(v)
        FPSBoostAtivo = v
        if v then
            -- Remover partículas e sombras para FPS melhor
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") then
                    particle.Enabled = false
                elseif particle:IsA("Light") or particle:IsA("SpotLight") or particle:IsA("PointLight") or particle:IsA("SurfaceLight") then
                    particle.Enabled = false
                elseif particle:IsA("Smoke") then
                    particle.Enabled = false
                end
            end
            -- Diminuir qualidade gráfica (exemplo)
            if game:GetService("Lighting") then
                game:GetService("Lighting").GlobalShadows = false
                game:GetService("Lighting").FogEnd = 999999
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").GeographicLatitude = 0
            end
        else
            -- Voltar configurações padrão ao desligar
            for _, particle in pairs(Workspace:GetDescendants()) do
                if particle:IsA("ParticleEmitter") or particle:IsA("Trail") then
                    particle.Enabled = true
                elseif particle:IsA("Light") or particle:IsA("SpotLight") or particle:IsA("PointLight") or particle:IsA("SurfaceLight") then
                    particle.Enabled = true
                elseif particle:IsA("Smoke") then
                    particle.Enabled = true
                end
            end
            if game:GetService("Lighting") then
                game:GetService("Lighting").GlobalShadows = true
                game:GetService("Lighting").FogEnd = 100000
                game:GetService("Lighting").Brightness = 1
                game:GetService("Lighting").GeographicLatitude = 41.73
            end
        end
    end
})

-- ESP Tab (linha + caixa)
local DrawingNew = Drawing.new
local ESPInimigosAtivo = false
local ESPFrutasAtivo = false

local ESPInimigosLines = {}
local ESPInimigosBoxes = {}
local ESPFrutasLines = {}
local ESPFrutasBoxes = {}

local function ClearESP(tbl)
    for _, esp in pairs(tbl) do
        if esp then
            esp:Remove()
        end
    end
    table.clear(tbl)
end

local function UpdateESPInimigos()
    ClearESP(ESPInimigosLines)
    ClearESP(ESPInimigosBoxes)

    if not ESPInimigosAtivo then return end

    local camera = workspace.CurrentCamera
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local root = mob.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local screenPos = Vector2.new(pos.X, pos.Y)

                -- Linha
                local line = DrawingNew("Line")
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = screenPos
                line.Color = Color3.new(1, 0, 0)
                line.Thickness = 1.5
                line.Transparency = 1
                table.insert(ESPInimigosLines, line)

                -- Caixa
                local size = 30
                local box = DrawingNew("Square")
                box.Size = Vector2.new(size, size)
                box.Position = screenPos - Vector2.new(size/2, size/2)
                box.Color = Color3.new(1, 0, 0)
                box.Thickness = 2
                box.Filled = false
                box.Transparency = 1
                table.insert(ESPInimigosBoxes, box)
            end
        end
    end
end

local function UpdateESPFrutas()
    ClearESP(ESPFrutasLines)
    ClearESP(ESPFrutasBoxes)

    if not ESPFrutasAtivo then return end

    local camera = workspace.CurrentCamera
    for _, fruit in pairs(Workspace:GetChildren()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            local pos, onScreen = camera:WorldToViewportPoint(fruit.Handle.Position)
            if onScreen then
                local screenPos = Vector2.new(pos.X, pos.Y)

                -- Linha
                local line = DrawingNew("Line")
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = screenPos
                line.Color = Color3.new(0, 1, 0)
                line.Thickness = 1.5
                line.Transparency = 1
                table.insert(ESPFrutasLines, line)

                -- Caixa
                local size = 30
                local box = DrawingNew("Square")
                box.Size = Vector2.new(size, size)
                box.Position = screenPos - Vector2.new(size/2, size/2)
                box.Color = Color3.new(0, 1, 0)
                box.Thickness = 2
                box.Filled = false
                box.Transparency = 1
                table.insert(ESPFrutasBoxes, box)
            end
        end
    end
end


local ContadorInimigos = TabESP:CreateParagraph({
    Title = "Contador de Inimigos",
    Content = "Inimigos detectados: 0"
})

TabESP:CreateToggle({
    Name = "ESP Inimigos (Linha + Caixa)",
    CurrentValue = false,
    Callback = function(v)
        ESPInimigosAtivo = v
        if not v then
            ClearESP(ESPInimigosLines)
            ClearESP(ESPInimigosBoxes)
        end
    end
})

TabESP:CreateToggle({
    Name = "ESP Frutas (Linha + Caixa)",
    CurrentValue = false,
    Callback = function(v)
        ESPFrutasAtivo = v
        if not v then
            ClearESP(ESPFrutasLines)
            ClearESP(ESPFrutasBoxes)
        end
    end
})

RunService:BindToRenderStep("UpdateESP", 301, function()
    if ESPInimigosAtivo then
        local totalInimigos = 0
        for _, mob in pairs(Workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                totalInimigos += 1
            end
        end
        ContadorInimigos:Set({Content = "Inimigos detectados: " .. totalInimigos})
    end

    if ESPInimigosAtivo then
        UpdateESPInimigos()
    end
    if ESPFrutasAtivo then
        UpdateESPFrutas()
    end
end)

Rayfield:LoadConfiguration()
