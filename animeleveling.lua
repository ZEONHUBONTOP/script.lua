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

-- === VARIÁVEL DE CONTROLE (VALOR DIGITADO) ===
local TargetWaveInput = 10

-- === CONFIGURAÇÃO WHITE SCREEN ===
local WhiteScreenUI = Instance.new("ScreenGui")
local WhiteFrame = Instance.new("Frame")
WhiteScreenUI.Name = "ZEO_WhiteScreen"
WhiteScreenUI.IgnoreGuiInset = true 
WhiteFrame.Size = UDim2.new(1, 0, 1, 0)
WhiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteFrame.Visible = false
WhiteFrame.Parent = WhiteScreenUI
pcall(function() WhiteScreenUI.Parent = game:GetService("CoreGui") end)

-- === ABA: AUTO FARM (MAIN) ===
local MapSelect = Tabs.Main:AddDropdown("SelectedMap", {
    Title = "Mundo",
    Values = {"World 1", "World 2", "World 3", "World 4"},
    Default = "World 1",
})
local EnemySelect = Tabs.Main:AddDropdown("SelectedEnemy", {
    Title = "Mob",
    Values = {"Carregando..."},
    Default = "Carregando...",
})
local ToggleFarm = Tabs.Main:AddToggle("AutoFarmToggle", { Title = "Ativar Auto Farm", Default = false })

-- === ABA: PLAYER ===
Tabs.Player:AddSection("Combat")
local ToggleClick = Tabs.Player:AddToggle("AutoClickToggle", { Title = "Auto Click", Default = false })

Tabs.Player:AddSection("Equip Best")
local EquipSelect = Tabs.Player:AddDropdown("SelectedEquip", {
    Title = "Categoria",
    Values = {"Pets", "Morph", "Accessory", "Weapons"},
    Default = "Pets",
})
local ToggleEquip = Tabs.Player:AddToggle("AutoEquipToggle", { Title = "Auto Equip Best (Loop)", Default = false })

-- === ABA: HATCH ===
Tabs.Hatch:AddSection("Auto Gacha")
local GachaSelect = Tabs.Hatch:AddDropdown("SelectedGacha", {
    Title = "Selecionar Power",
    Values = {"SaiyanPower (W1)", "DragonPower (W1)", "FruitPower (W2)", "GrimoiresPower (W3)", "DemonPower (W3)", "BreathingPower (W4)"},
    Default = "SaiyanPower (W1)",
})
local ToggleGacha = Tabs.Hatch:AddToggle("AutoGachaToggle", { Title = "Gacha Turbo", Default = false })

Tabs.Hatch:AddSection("Auto Star")
local StarSelect = Tabs.Hatch:AddDropdown("SelectedStar", {
    Title = "Selecionar Star",
    Values = {"Dragon Ball (W1)", "One Piece (W2)", "Black Clover (W3)", "Demon Slayer (W4)"},
    Default = "Dragon Ball (W1)",
})
local ToggleStar = Tabs.Hatch:AddToggle("AutoStarToggle", { Title = "Star Turbo (x6)", Default = false })

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

-- CAMPO DE NÚMERO (INPUT)
local WaveInput = Tabs.Gamemodes:AddInput("WaveInputBox", {
    Title = "Digitar Wave para Sair:",
    Default = "10",
    Placeholder = "Digite a Wave (ex: 15)",
    NumericOnly = true,
    Finished = true,
    Callback = function(Value)
        TargetWaveInput = tonumber(Value) or 0
    end
})

-- === LOOPS DE EXECUÇÃO ===

-- Loop Auto Join (2s)
task.spawn(function()
    while true do
        if Options.AutoJoinMode and Options.AutoJoinMode.Value then
            pcall(function()
                local mode = Options.SelectedMode.Value
                local r = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
                if mode == "Wisteria Raid (W4)" then r:WaitForChild("OpenWisteriaRaid"):FireServer()
                elseif mode == "Tower Easy" then r:WaitForChild("JoinTowerEasy"):FireServer() end
            end)
        end
        task.wait(2)
    end
end)

-- Loop Auto Leave (Checa o número digitado)
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
                    Fluent:Notify({Title = "ZEON HUB", Content = "Meta Atingida! Wave: " .. tostring(waveObj.Value), Duration = 5})
                    task.wait(1)
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
            end)
        end
        task.wait(2)
    end
end)

-- Farm Wisteria Raid (0.1s)
task.spawn(function()
    while true do
        if Options.FarmWisteria and Options.FarmWisteria.Value then
            pcall(function()
                local enemies = workspace:FindFirstChild("WisteriaRaid") and workspace.WisteriaRaid:FindFirstChild("Raid1") and workspace.WisteriaRaid.Raid1:FindFirstChild("Enemy")
                if enemies and #enemies:GetChildren() > 0 then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if not Options.FarmWisteria.Value then break end
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.1)
                        end
                    end
                else task.wait(1) end
            end)
        end
        task.wait()
    end
end)

-- Farm Tower Easy (0.1s)
task.spawn(function()
    while true do
        if Options.FarmTower and Options.FarmTower.Value then
            pcall(function()
                local enemies = workspace:FindFirstChild("TowerRaid") and workspace.TowerRaid:FindFirstChild("Raid1") and workspace.TowerRaid.Raid1:FindFirstChild("Enemy")
                if enemies and #enemies:GetChildren() > 0 then
                    for _, mob in pairs(enemies:GetChildren()) do
                        if not Options.FarmTower.Value then break end
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.1)
                        end
                    end
                else task.wait(1) end
            end)
        end
        task.wait()
    end
end)

-- Gacha & Star Turbo (0.01s)
task.spawn(function()
    while true do
        if Options.AutoGachaToggle and Options.AutoGachaToggle.Value then
            pcall(function()
                local s = Options.SelectedGacha.Value
                local r = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
                if s == "SaiyanPower (W1)" then r:WaitForChild("RollSaiyanPower"):FireServer()
                elseif s == "DragonPower (W1)" then r:WaitForChild("RollDragonBallPower"):FireServer()
                elseif s == "FruitPower (W2)" then r:WaitForChild("RollFruitPower"):FireServer()
                elseif s == "GrimoiresPower (W3)" then r:WaitForChild("RollGrimoiresPower"):FireServer()
                elseif s == "DemonPower (W3)" then r:WaitForChild("RollDemonPower"):FireServer()
                elseif s == "BreathingPower (W4)" then r:WaitForChild("RollBreathingPower"):FireServer() end
            end)
        end
        if Options.AutoStarToggle and Options.AutoStarToggle.Value then
            pcall(function()
                local s = Options.SelectedStar.Value
                local id = (s == "One Piece (W2)" and "Star2") or (s == "Black Clover (W3)" and "Star3") or (s == "Demon Slayer (W4)" and "Star4") or "Star1"
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Eggs"):WaitForChild("Hatch"):InvokeServer(id, 6)
            end)
        end
        task.wait(0.01)
    end
end)

-- Dropdown Logic (Mundos)
MapSelect:OnChanged(function()
    local worldPath = workspace:FindFirstChild(Options.SelectedMap.Value:gsub(" ", ""))
    local list = {}
    if worldPath and worldPath:FindFirstChild("Enemy") then
        for _, enemy in pairs(worldPath.Enemy:GetChildren()) do
            if not table.find(list, enemy.Name) then table.insert(list, enemy.Name) end
        end
    end
    EnemySelect:SetValues(#list > 0 and list or {"Nenhum Mob"})
end)

Window:SelectTab(1)
Fluent:Notify({Title = "Zeo Hub", Content = "Script Completo com Input Numérico!", Duration = 5})
