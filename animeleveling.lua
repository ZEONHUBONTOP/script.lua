local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "ZEON HUB",
    SubTitle = "By ZEON TEAM",
    TabWidth = 120,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = true, 
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- ORDEM DAS ABAS: Auto Farm, Players, Hatch, Gamemodes
local Tabs = {
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Player = Window:AddTab({ Title = "Players", Icon = "user" }),
    Hatch = Window:AddTab({ Title = "Hatch", Icon = "star" }),
    Gamemodes = Window:AddTab({ Title = "Gamemodes", Icon = "layout-grid" })
}

local SavedCFrame = nil
_G.TargetWave = 0

-- [[ ABA: AUTO FARM ]]
Tabs.AutoFarm:AddSection("Configuração de Farm")
local WorldSelect = Tabs.AutoFarm:AddDropdown("WorldSelect", { Title = "Selecionar Mundo", Values = {"World1", "World2", "World3", "World4"}, Multi = false, Default = 1 })
local MobSelect = Tabs.AutoFarm:AddDropdown("MobSelect", { Title = "Selecionar Mob", Values = {"Carregando..."}, Multi = false, Default = 1 })

local function UpdateMobDropdown()
    local SelectedWorld = WorldSelect.Value
    local EnemyFolder = workspace:FindFirstChild(SelectedWorld) and workspace[SelectedWorld]:FindFirstChild("Enemy")
    local MobList = {}
    if EnemyFolder then
        for _, mob in pairs(EnemyFolder:GetChildren()) do
            if not table.find(MobList, mob.Name) then table.insert(MobList, mob.Name) end
        end
    end
    MobSelect:SetValues(#MobList > 0 and MobList or {"Nenhum Mob"})
end

WorldSelect:OnChanged(UpdateMobDropdown)
task.spawn(UpdateMobDropdown)

Tabs.AutoFarm:AddToggle("StartFarm", {Title = "Ativar Farm Multi-Target", Default = false }):OnChanged(function(Value)
    _G.AutoFarm = Value
    if Value then
        task.spawn(function()
            while _G.AutoFarm do
                local p = game.Players.LocalPlayer
                local SelectedMob = MobSelect.Value
                local EnemyFolder = workspace:FindFirstChild(WorldSelect.Value) and workspace[WorldSelect.Value]:FindFirstChild("Enemy")
                if EnemyFolder and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    for _, mob in pairs(EnemyFolder:GetChildren()) do
                        if not _G.AutoFarm then break end
                        if mob.Name == SelectedMob then
                            local targetPos = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                            if targetPos then
                                p.Character.HumanoidRootPart.CFrame = targetPos.CFrame * CFrame.new(0, 0, 3)
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clicked"):FireServer()
                                task.wait(0.1)
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end)

-- [[ ABA: PLAYERS ]]
Tabs.Player:AddSection("Ações")
Tabs.Player:AddToggle("AutoAttack", {Title = "Auto Attack (Click)", Default = false }):OnChanged(function(Value)
    _G.AutoAttack = Value
    if Value then
        task.spawn(function()
            while _G.AutoAttack do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clicked"):FireServer()
                task.wait(0.1) 
            end
        end)
    end
end)

Tabs.Player:AddToggle("AutoChest", {Title = "Auto Chest (1h)", Default = false }):OnChanged(function(Value)
    _G.AutoChest = Value
    if Value then
        task.spawn(function()
            while _G.AutoChest do
                local Chests = workspace:FindFirstChild("Chests")
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if Chests and hrp then
                    for _, chest in pairs(Chests:GetChildren()) do
                        local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
                        if part then hrp.CFrame = part.CFrame; firetouchinterest(hrp, part, 0); task.wait(0.1); firetouchinterest(hrp, part, 1) end
                    end
                    if SavedCFrame then hrp.CFrame = SavedCFrame end
                end
                task.wait(3600)
            end
        end)
    end
end)

-- [[ ABA: HATCH ]]
Tabs.Hatch:AddSection("Auto Star (Hatch)")
local EggSelect = Tabs.Hatch:AddDropdown("EggSelect", { 
    Title = "Selecionar Star", 
    Values = {"Dragon Ball (W1)", "One Piece (W2)", "Clover Village (W3)", "Demon Village (W4)"}, 
    Multi = false, 
    Default = 1 
})

Tabs.Hatch:AddToggle("AutoHatch", {Title = "Ativar Auto Hatch (x5)", Default = false }):OnChanged(function(Value)
    _G.AutoHatch = Value
    if Value then
        task.spawn(function()
            while _G.AutoHatch do
                local Selected = EggSelect.Value
                local EggName = (Selected == "Dragon Ball (W1)" and "Star1") or (Selected == "One Piece (W2)" and "Star2") or (Selected == "Clover Village (W3)" and "Star3") or (Selected == "Demon Village (W4)" and "Star4")
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Eggs"):WaitForChild("Hatch"):InvokeServer(EggName, 5)
                task.wait(0.01)
            end
        end)
    end
end)

Tabs.Hatch:AddSection("Auto Gacha (Powers)")
local GachaSelect = Tabs.Hatch:AddDropdown("GachaSelect", { Title = "Selecionar Poder", Values = {"SaiyanPower (W1)", "Dragon Power (W1)", "FruitsPower (W2)", "GrimoiresPower (W3)", "DemonPower (W3)", "BreathingPower (W4)"}, Multi = false, Default = 1 })
Tabs.Hatch:AddToggle("AutoGacha", {Title = "Auto Roll Gacha", Default = false }):OnChanged(function(Value)
    _G.AutoGacha = Value
    if Value then
        task.spawn(function()
            while _G.AutoGacha do
                local Selected = GachaSelect.Value
                local Remote = (Selected == "SaiyanPower (W1)" and "RollSaiyanPower") or (Selected == "Dragon Power (W1)" and "RollDragonBallPower") or (Selected == "FruitsPower (W2)" and "RollFruitPower") or (Selected == "GrimoiresPower (W3)" and "RollGrimoiresPower") or (Selected == "DemonPower (W3)" and "RollDemonPower") or (Selected == "BreathingPower (W4)" and "RollBreathingPower")
                game:GetService("ReplicatedStorage").Remotes[Remote]:FireServer()
                task.wait(0.01) 
            end
        end)
    end
end)

-- [[ ABA: GAMEMODES ]]
Tabs.Gamemodes:AddSection("Checkpoint")
Tabs.Gamemodes:AddButton({
    Title = "Salvar Posição de Retorno",
    Callback = function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then SavedCFrame = hrp.CFrame; Fluent:Notify({ Title = "ZEON HUB", Content = "Posição Salva!", Duration = 2 }) end
    end
})

Tabs.Gamemodes:AddSection("Wisteria Raid")
Tabs.Gamemodes:AddToggle("AutoJoinWisteria", {Title = "Auto Join Wisteria", Default = false }):OnChanged(function(Value)
    _G.AutoJoinWisteria = Value
    if Value then
        task.spawn(function()
            while _G.AutoJoinWisteria do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("OpenWisteriaRaid"):FireServer()
                task.wait(2)
            end
        end)
    end
end)

Tabs.Gamemodes:AddToggle("StartWisteriaFarm", {Title = "Auto Farm Wisteria", Default = false }):OnChanged(function(Value)
    _G.AutoWisteria = Value
    if Value then
        task.spawn(function()
            while _G.AutoWisteria do
                local EnemyFolder = workspace:FindFirstChild("WisteriaRaid") and workspace.WisteriaRaid:FindFirstChild("Raid1") and workspace.WisteriaRaid.Raid1:FindFirstChild("Enemy")
                local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if EnemyFolder and hrp then
                    for _, mob in pairs(EnemyFolder:GetChildren()) do
                        if not _G.AutoWisteria then break end
                        local target = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                        if target then 
                            hrp.CFrame = target.CFrame * CFrame.new(0,0,3)
                            game:GetService("ReplicatedStorage").Remotes.Clicked:FireServer()
                            task.wait(0.1) 
                        end
                    end
                end
                task.wait()
            end
        end)
    end
end)

Tabs.Gamemodes:AddSection("Auto Leave Por Wave")
Tabs.Gamemodes:AddInput("WaveInput", { Title = "Sair na Wave:", Default = "10", Numeric = true, Callback = function(V) _G.TargetWave = tonumber(V) end })
Tabs.Gamemodes:AddToggle("AutoLeaveWave", {Title = "Ativar Auto Leave", Default = false }):OnChanged(function(Value)
    _G.AutoLeaveWave = Value
    if Value then
        task.spawn(function()
            while _G.AutoLeaveWave do
                local currentWave = 0
                local wv = workspace:FindFirstChild("Wave") or workspace:FindFirstChild("CurrentWave")
                if wv then currentWave = tonumber(wv.Value) or 0 end
                if _G.TargetWave > 0 and currentWave >= _G.TargetWave then
                    if SavedCFrame then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame end
                    _G.AutoLeaveWave = false; _G.AutoWisteria = false
                    Fluent:Notify({ Title = "ZEON HUB", Content = "Meta batida! Saindo da Raid...", Duration = 5 })
                end
                task.wait(2)
            end
        end)
    end
end)

Window:SelectTab(1)
