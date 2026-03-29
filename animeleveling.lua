local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Zeo Hub",
    SubTitle = "by ZEON TEAM",
    TabWidth = 120, 
    Size = UDim2.fromOffset(400, 300), 
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "target" }),
    Player = Window:AddTab({ Title = "Player", Icon = "swords" }),
    Hatch = Window:AddTab({ Title = "Hatch", Icon = "star" }),
    Gamemodes = Window:AddTab({ Title = "Auto Gamemodes", Icon = "gamepad" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- === VARIÁVEIS DE CONTROLE ===
local TargetWaveInput = 10

-- === ABA: AUTO FARM (MAIN) ===
local MapSelect = Tabs.Main:AddDropdown("SelectedMap", {
    Title = "Mundo",
    Values = {"World 1", "World 2", "World 3", "World 4"},
    Default = "World 1",
})

local EnemySelect = Tabs.Main:AddDropdown("SelectedEnemy", {
    Title = "Selecionar Mob",
    Values = {"Carregando..."},
    Default = "Carregando...",
})

local ToggleFarm = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "Ativar Auto Farm", Default = false })

-- === ABA: PLAYER ===
Tabs.Player:AddSection("Combat")
local ToggleClick = Tabs.Player:AddToggle("AutoClickToggle", { Title = "Auto Click", Default = false })

-- === ABA: AUTO GAMEMODES (SEÇÕES SEPARADAS) ===

Tabs.Gamemodes:AddSection("Entrar nos Modos")
local ModeSelect = Tabs.Gamemodes:AddDropdown("SelectedMode", {
    Title = "Escolher Modo",
    Values = {"Wisteria Raid (W4)", "Tower Easy"},
    Default = "Wisteria Raid (W4)",
})
local ToggleJoin = Tabs.Gamemodes:AddToggle("AutoJoinMode", { Title = "Auto Entrar (Loop)", Default = false })

Tabs.Gamemodes:AddSection("Auto Farm")
local ToggleWisteria = Tabs.Gamemodes:AddToggle("FarmWisteria", { Title = "Farm Wisteria (Raid1)", Default = false })
local ToggleTower = Tabs.Gamemodes:AddToggle("FarmTower", { Title = "Farm Tower (Raid1)", Default = false })

Tabs.Gamemodes:AddSection("Auto Leave (Kitar)")
local ToggleLeave = Tabs.Gamemodes:AddToggle("AutoLeaveToggle", { 
    Title = "Ativar Auto Leave", 
    Default = false 
})

local WaveInput = Tabs.Gamemodes:AddInput("WaveInputBox", {
    Title = "Digitar Wave para Sair:",
    Default = "10",
    NumericOnly = true,
    Finished = true,
    Callback = function(Value)
        TargetWaveInput = tonumber(Value) or 0
    end
})

-- === LOOPS DE EXECUÇÃO ===

-- AUTO FARM PRINCIPAL (0.1s)
task.spawn(function()
    while true do
        if Options.AutoFarmToggle and Options.AutoFarmToggle.Value then
            pcall(function()
                local worldName = Options.SelectedMap.Value:gsub(" ", "")
                local world = workspace:FindFirstChild(worldName)
                if world and world:FindFirstChild("Enemy") then
                    for _, mob in pairs(world.Enemy:GetChildren()) do
                        if not Options.AutoFarmToggle.Value then break end
                        if mob.Name == Options.SelectedEnemy.Value and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            local hrp = mob:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait()
    end
end)

-- AUTO LEAVE (KITAR)
task.spawn(function()
    while true do
        if Options.AutoLeaveToggle and Options.AutoLeaveToggle.Value then
            pcall(function()
                local tower = workspace:FindFirstChild("TowerRaid") and workspace.TowerRaid:FindFirstChild("Raid1")
                local wisteria = workspace:FindFirstChild("WisteriaRaid") and (workspace.WisteriaRaid:FindFirstChild("Raid1") or workspace.WisteriaRaid:FindFirstChild("Raid8"))
                
                local waveObj = (tower and tower:FindFirstChild("Wave")) 
                             or (wisteria and wisteria:FindFirstChild("Wave"))
                             or game:GetService("ReplicatedStorage"):FindFirstChild("CurrentWave")

                if waveObj and tonumber(waveObj.Value) >= TargetWaveInput then
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            end)
        end
        task.wait(2)
    end
end)

-- AUTO CLICK (0.1s)
task.spawn(function()
    while true do
        if Options.AutoClickToggle and Options.AutoClickToggle.Value then
            pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clicked"):FireServer() end)
        end
        task.wait(0.1)
    end
end)

-- LÓGICA DROPDOWN MOBS
MapSelect:OnChanged(function(Value)
    local worldName = Value:gsub(" ", "")
    local world = workspace:FindFirstChild(worldName)
    local list = {}
    if world and world:FindFirstChild("Enemy") then
        for _, enemy in pairs(world.Enemy:GetChildren()) do
            if not table.find(list, enemy.Name) then table.insert(list, enemy.Name) end
        end
    end
    EnemySelect:SetValues(#list > 0 and list or {"Nenhum Mob"})
end)

-- FARM RAID/TOWER (0.1s)
task.spawn(function()
    while true do
        if Options.FarmWisteria and Options.FarmWisteria.Value then
            -- Lógica de Farm Wisteria simplificada
            task.wait(0.1)
        end
        task.wait()
    end
end)

Window:SelectTab(1)
Fluent:Notify({Title = "Zeon Hub", Content = "Script Restaurado com World 1-4!", Duration = 5})
