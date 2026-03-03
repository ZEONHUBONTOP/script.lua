-- =====================================
-- SERVICES
-- =====================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- REMOTES
local GachaService = ReplicatedStorage:WaitForChild("Core"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("GachaService")
local ExecuteSpin = GachaService:WaitForChild("RF"):WaitForChild("ExecuteSpin")

local UpgradeService = ReplicatedStorage:WaitForChild("Core"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("UpgradeService")
local ExecuteUpgrade = UpgradeService:WaitForChild("RF"):WaitForChild("ExecuteUpgradeType")

local TeleportService = ReplicatedStorage:WaitForChild("Core"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("TeleportService")
local RequestTeleport = TeleportService:WaitForChild("RF"):WaitForChild("RequestTeleport")

local CombatService = ReplicatedStorage:WaitForChild("Core"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("CombatService")
local Attack = CombatService:WaitForChild("RF"):WaitForChild("Attack")

-- =====================================
-- GAME NAME
-- =====================================
local GameName = "Game"
pcall(function()
    GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- =====================================
-- FLUENT UI
-- =====================================
local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

Fluent:Notify({
    Title = "Script executado com sucesso",
    Content = "Você está usando o melhor script ZEON HUB",
    Duration = 6
})

local Window = Fluent:CreateWindow({
    Title = "ZEON HUB",
    SubTitle = "-- " .. GameName,
    TabWidth = 120,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- =====================================
-- STATES
-- =====================================
local AutoFarm = false
local AutoGacha = false
local SelectedGacha = "Haki"
local AutoStar = false
local SelectedStar = "One Piece"
local AutoUpgrade = false
local SelectedUpgrade = "Ninja"
local SelectedMap = "One Piece"

-- Auto Farm Mobs
local AutoFarmMob = false
local RefreshMobs = false
local SelectedMobs = {}

-- Auto Fruits
local AutoCollectFruits = false
local FruitsCollected = 0

-- =====================================
-- FUNÇÃO PARA PEGAR NOMES ÚNICOS DOS MOBS
-- =====================================
local function getUniqueMobNames()
    local names, seen = {}, {}
    for _, mob in ipairs(workspace.Enemies:GetChildren()) do
        if not seen[mob.Name] then
            table.insert(names, mob.Name)
            seen[mob.Name] = true
        end
    end
    return names
end

-- =====================================
-- FUNÇÃO DE TELEPORTE + NOTIFICAÇÃO (FRUITS)
-- =====================================
local function teleportToFruit(fruit)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local fruitPart = fruit:FindFirstChild("HumanoidRootPart") 
        or fruit:FindFirstChild("Handle") 
        or fruit:FindFirstChildWhichIsA("BasePart")

    if fruitPart then
        hrp.CFrame = fruitPart.CFrame * CFrame.new(0, 0, 3)
        FruitsCollected += 1

        Fluent:Notify({
            Title = "Fruta Coletada!",
            Content = "Você coletou: " .. fruit.Name ..
                      " | Total: " .. FruitsCollected,
            Duration = 5
        })
    end
end

-- =====================================
-- LOOPS
-- =====================================

-- Auto Click Turbo
task.spawn(function()
    while true do
        if AutoFarm then
            local args = {4}
            pcall(function() Attack:InvokeServer(unpack(args)) end)
        end
        task.wait()
    end
end)

-- Auto Farm Mobs
task.spawn(function()
    while true do
        if AutoFarmMob and #SelectedMobs > 0 then
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")

            for _, mob in ipairs(workspace.Enemies:GetChildren()) do
                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                local humanoid = mob:FindFirstChildOfClass("Humanoid")

                if mobHRP and humanoid and humanoid.Health > 0 then
                    for _, selected in ipairs(SelectedMobs) do
                        if mob.Name == selected then
                            hrp.CFrame = mobHRP.CFrame * CFrame.new(0,0,5)
                            while humanoid.Health > 0 and AutoFarmMob do
                                local args = {4}
                                pcall(function() Attack:InvokeServer(unpack(args)) end)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end

        if RefreshMobs then
            mobDropdown:SetValues(getUniqueMobNames())
        end

        task.wait(0.1)
    end
end)

-- Auto Fruits
task.spawn(function()
    while true do
        if AutoCollectFruits then
            for _, fruit in ipairs(workspace.Fruits:GetChildren()) do
                teleportToFruit(fruit)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end)

-- Auto Gacha
task.spawn(function()
    while true do
        if AutoGacha then
            local args
            if SelectedGacha == "Sword" then
                args = {"Sword",1,1,"GachaRollTemplateSecond:Sword",true}
            elseif SelectedGacha == "GhoulEye" then
                args = {"GhoulEye",1,1,"GachaRollTemplate:GhoulEye",false}
            elseif SelectedGacha == "SayajinAura" then
                args = {"SayajinAura",1,1,"GachaRollTemplate:SayajinAura",false}
            else
                args = {"Haki",1,1,[5]=false}
            end
            pcall(function() ExecuteSpin:InvokeServer(unpack(args)) end)
        end
        task.wait()
    end
end)

-- Auto Star
task.spawn(function()
    while true do
        if AutoStar then
            local args
            if SelectedStar == "Leaf Village" then
                args = {"Champions",2,3}
            elseif SelectedStar == "Tokyo Ghoul" then
                args = {"Champions",3,3}
            elseif SelectedStar == "Dragon Ball" then
                args = {"Champions",4,3}
            else
                args = {"Champions",1,3}
            end
            pcall(function() ExecuteSpin:InvokeServer(unpack(args)) end)
        end
        task.wait()
    end
end)

-- Auto Upgrade
task.spawn(function()
    while true do
        if AutoUpgrade then
            local args = {SelectedUpgrade}
            pcall(function() ExecuteUpgrade:InvokeServer(unpack(args)) end)
        end
        task.wait()
    end
end)

-- =====================================
-- UI TABS
-- =====================================

-- Auto Farm (Mobs)
local TabFarm = Window:AddTab({ Title = "Auto Farm", Icon = "sword" })
TabFarm:AddToggle("AutoFarmMob", {
    Title = "Auto Farm Mobs",
    Default = false,
    Callback = function(v) AutoFarmMob = v end
})
TabFarm:AddToggle("RefreshMobs", {
    Title = "Atualizar Lista de Mobs",
    Default = false,
    Callback = function(v) RefreshMobs = v end
})
mobDropdown = TabFarm:AddDropdown("MobSelect", {
    Title = "Selecionar Mobs",
    Values = getUniqueMobNames(),
    Multi = true,
    Default = {},
    Callback = function(v) SelectedMobs = v end
})

-- Player Farm (Auto Click + Fruits)
local TabPlayer = Window:AddTab({ Title = "Player Farm", Icon = "user" })
TabPlayer:AddToggle("AutoFarm", {
    Title = "Auto Click (Turbo)",
    Default = false,
    Callback = function(v) AutoFarm = v end
})
TabPlayer:AddToggle("AutoCollectFruits", {
    Title = "Auto Collect Fruits (Todas)",
    Default = false,
    Callback = function(v) AutoCollectFruits = v end
})

-- 3. Auto Star
local TabStar = Window:AddTab({ Title = "Auto Star", Icon = "star" })
TabStar:AddDropdown("StarSelect", {
    Title = "Selecionar Tipo de Star",
    Values = {"One Piece","Leaf Village","Tokyo Ghoul","Dragon Ball"},
    Default = "One Piece",
    Callback = function(v) SelectedStar = v end
})
TabStar:AddToggle("AutoStar", {
    Title = "Auto Spin Star (Turbo)",
    Default = false,
    Callback = function(v) AutoStar = v end
})

-- 4. Auto Gacha
local TabGacha = Window:AddTab({ Title = "Auto Gacha", Icon = "gift" })
TabGacha:AddDropdown("GachaSelect", {
    Title = "Selecionar Egg de Gacha",
    Values = {"Haki","Sword","GhoulEye","SayajinAura"},
    Default = "Haki",
    Callback = function(v) SelectedGacha = v end
})
TabGacha:AddToggle("AutoGacha", {
    Title = "Auto Spin Gacha (Turbo)",
    Default = false,
    Callback = function(v) AutoGacha = v end
})

-- 5. Auto Upgrades
local TabUpgrade = Window:AddTab({ Title = "Auto Upgrades", Icon = "trending-up" })
TabUpgrade:AddDropdown("UpgradeSelect", {
    Title = "Selecionar Tipo de Upgrade",
    Values = {"Ninja","Ghoul","Sayajin"},
    Default = "Ninja",
    Callback = function(v) SelectedUpgrade = v end
})
TabUpgrade:AddToggle("AutoUpgrade", {
    Title = "Auto Upgrade (Turbo)",
    Default = false,
    Callback = function(v) AutoUpgrade = v end
})

-- 6. Teleporte
local TabTeleport = Window:AddTab({ Title = "Teleporte", Icon = "map" })
TabTeleport:AddDropdown("TeleportSelect", {
    Title = "Selecionar Mapa",
    Values = {"OnePiece","Naruto","Tokyo Ghoul","DragonBall"},
    Default = "OnePiece",
    Callback = function(v) SelectedMap = v end
})
TabTeleport:AddButton({
    Title = "Teleportar",
    Description = "Ir para o mapa selecionado",
    Callback = function()
        local args = {SelectedMap}
        pcall(function() RequestTeleport:InvokeServer(unpack(args)) end)
end
})
