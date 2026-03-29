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
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- === CONFIGURAÇÃO WHITE SCREEN (TOTAL) ===
local WhiteScreenUI = Instance.new("ScreenGui")
local WhiteFrame = Instance.new("Frame")
WhiteScreenUI.Name = "ZEO_WhiteScreen"
WhiteScreenUI.IgnoreGuiInset = true 
WhiteScreenUI.DisplayOrder = -1 
WhiteFrame.Size = UDim2.new(1, 0, 1, 0)
WhiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteFrame.BorderSizePixel = 0
WhiteFrame.Visible = false
WhiteFrame.Parent = WhiteScreenUI
pcall(function() WhiteScreenUI.Parent = game:GetService("CoreGui") end)

-- === ABA: AUTO FARM (0.1s FIXO) ===
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

-- === ABA: HATCH (TODOS STAR & GACHA) ===
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

-- === ABA: SETTINGS ===
Tabs.Settings:AddSection("Performance & Privacy")
Tabs.Settings:AddButton({
    Title = "FPS Boost (Mapa Cinza)",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = "Plastic"; v.Color = Color3.fromRGB(163, 162, 165); v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    end
})

local ToggleWhite = Tabs.Settings:AddToggle("WhiteScreenToggle", { Title = "White Screen", Default = false })
ToggleWhite:OnChanged(function() WhiteFrame.Visible = Options.WhiteScreenToggle.Value end)

Tabs.Settings:AddButton({
    Title = "Hide Name & Rank",
    Callback = function()
        local lp = game.Players.LocalPlayer
        pcall(function()
            lp.DisplayName = "ZEO HUB"
            if lp.Character and lp.Character:FindFirstChild("Head") then
                for _, v in pairs(lp.Character.Head:GetChildren()) do
                    if v:IsA("BillboardGui") then v.Enabled = false end
                end
            end
        end)
    end
})

-- === LOOPS DE EXECUÇÃO ===

-- Auto Click (Corrigido)
task.spawn(function()
    while true do
        if Options.AutoClickToggle and Options.AutoClickToggle.Value then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Clicked"):FireServer()
            end)
        end
        task.wait(0.1)
    end
end)

-- Gacha Turbo (0.01s) - COBRE TODOS OS POWERS
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
        task.wait(0.01)
    end
end)

-- Star Turbo (0.01s) - COBRE TODOS OS MUNDOS
task.spawn(function()
    while true do
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

-- Auto Farm (0.1s)
task.spawn(function()
    while true do
        if Options.AutoFarmToggle and Options.AutoFarmToggle.Value then
            pcall(function()
                local world = workspace:FindFirstChild(Options.SelectedMap.Value:gsub(" ", ""))
                if world and world:FindFirstChild("Enemy") then
                    for _, mob in pairs(world.Enemy:GetChildren()) do
                        if not Options.AutoFarmToggle.Value then break end
                        if mob.Name == Options.SelectedEnemy.Value and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                            task.wait(0.1) 
                        end
                    end
                end
            end)
        end
        task.wait()
    end
end)

-- Auto Equip (Loop 5s)
task.spawn(function()
    while true do
        if Options.AutoEquipToggle and Options.AutoEquipToggle.Value then
            pcall(function()
                local s = Options.SelectedEquip.Value
                local r = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
                if s == "Pets" then r:WaitForChild("Pets"):WaitForChild("EquipBestPets"):FireServer()
                elseif s == "Morph" then r:WaitForChild("MorphPets"):WaitForChild("EquipBestMorphPets"):FireServer()
                elseif s == "Accessory" then r:WaitForChild("Accessories"):WaitForChild("EquipBestAccessories"):FireServer()
                elseif s == "Weapons" then r:WaitForChild("Weapons"):WaitForChild("EquipBestWeapons"):FireServer() end
            end)
        end
        task.wait(5)
    end
end)

-- Inicialização dinâmica de Mobs
MapSelect:OnChanged(function()
    local worldName = Options.SelectedMap.Value:gsub(" ", "")
    local worldPath = workspace:FindFirstChild(worldName)
    local list = {}
    if worldPath and worldPath:FindFirstChild("Enemy") then
        for _, enemy in pairs(worldPath.Enemy:GetChildren()) do
            if not table.find(list, enemy.Name) then table.insert(list, enemy.Name) end
        end
    end
    EnemySelect:SetValues(#list > 0 and list or {"Nenhum Mob"})
end)

Window:SelectTab(1)
Fluent:Notify({Title = "Zeo Hub", Content = "Tudo Pronto! Auto Stars e Gachas Ativos.", Duration = 5})
