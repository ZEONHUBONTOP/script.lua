-- PEGAR NOME DO JOGO
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

-- LOAD UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local Window = Fluent:CreateWindow({
    Title = "ZEON HUB",
    SubTitle = "-- " .. GameName,
    TabWidth = 120,
    Size = UDim2.fromOffset(450, 350),
    Acrylic = true,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- ABAS
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Player = Window:AddTab({ Title = "Players", Icon = "user" }),
    Hatch = Window:AddTab({ Title = "Hatch", Icon = "star" }),
    Gamemodes = Window:AddTab({ Title = "Gamemodes", Icon = "layout-grid" })
}

local SavedCFrame = nil
_G.TargetWave = 0

-- FUNÇÃO MULTI SELECT
local function IsSelected(selected, name)
    if typeof(selected) == "table" then
        if table.find(selected, name) then return true end
        if selected[name] then return true end
    end
    return false
end

-- =========================
-- MAIN
-- =========================
Tabs.Main:AddSection("Informações")

Tabs.Main:AddParagraph({
    Title = "Game",
    Content = "Nome: "..GameName.."\nCriador: ???\nGrupo: ???"
})

Tabs.Main:AddParagraph({
    Title = "Script",
    Content = "Dono: ZEON TEAM\nVersão: v1.0\nStatus: Online\nAtualizado: 31/03/2026"
})

-- =========================
-- PLAYER
-- =========================
Tabs.Player:AddSection("Ações")

Tabs.Player:AddToggle("Click",{Title="Auto Click",Icon="mouse"}):OnChanged(function(v)
    _G.Click=v
    task.spawn(function()
        while _G.Click do
            Remotes.Clicked:FireServer()
            task.wait(0.1)
        end
    end)
end)

Tabs.Player:AddToggle("Chest",{Title="Auto Chest",Icon="treasure-chest"}):OnChanged(function(v)
    _G.Chest=v
    task.spawn(function()
        while _G.Chest do
            local p = game.Players.LocalPlayer
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local chests = workspace:FindFirstChild("Chests")

            if hrp and chests then
                for _, chest in pairs(chests:GetChildren()) do
                    local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
                    if part then
                        hrp.CFrame = part.CFrame
                        firetouchinterest(hrp, part, 0)
                        task.wait(0.1)
                        firetouchinterest(hrp, part, 1)
                    end
                end

                if SavedCFrame then hrp.CFrame = SavedCFrame end
            end

            task.wait(3600)
        end
    end)
end)

-- =========================
-- EQUIP BEST
-- =========================
Tabs.Player:AddSection("Equip Best")

local function AutoEquip(toggle, path, remote)
    task.spawn(function()
        while _G[toggle] do
            if Remotes:FindFirstChild(path) and Remotes[path]:FindFirstChild(remote) then
                Remotes[path][remote]:FireServer()
            end
            task.wait(3)
        end
    end)
end

Tabs.Player:AddToggle("Pets",{Title="Auto Best Pets",Icon="star"}):OnChanged(function(v)
    _G.Pets=v
    if v then AutoEquip("Pets","Pets","EquipBestPets") end
end)

Tabs.Player:AddToggle("Morphs",{Title="Auto Best Morphs",Icon="sparkles"}):OnChanged(function(v)
    _G.Morphs=v
    if v then AutoEquip("Morphs","MorphPets","EquipBestMorphPets") end
end)

Tabs.Player:AddToggle("Accessories",{Title="Auto Best Accessories",Icon="gem"}):OnChanged(function(v)
    _G.Accessories=v
    if v then AutoEquip("Accessories","Accessories","EquipBestAccessories") end
end)

Tabs.Player:AddToggle("Weapons",{Title="Auto Best Weapons",Icon="sword"}):OnChanged(function(v)
    _G.Weapons=v
    if v then AutoEquip("Weapons","Weapons","EquipBestWeapons") end
end)

-- =========================
-- AUTO FARM (VARREDURA)
-- =========================
Tabs.AutoFarm:AddSection("Configuração")

local WorldSelect = Tabs.AutoFarm:AddDropdown("WorldSelect",{
    Title="Selecionar Mundo",
    Values={"World 1","World 2","World 3","World 4"},
    Default="World 1"
})

local MobSelect = Tabs.AutoFarm:AddDropdown("MobSelect",{
    Title="Selecionar Mob",
    Values={"Carregando..."},
    Default=1
})

local function UpdateMob()
    local world = WorldSelect.Value:gsub(" ","")
    local folder = workspace:FindFirstChild(world) and workspace[world]:FindFirstChild("Enemy")
    local list = {}

    if folder then
        for _,m in pairs(folder:GetChildren()) do
            if not table.find(list,m.Name) then
                table.insert(list,m.Name)
            end
        end
    end

    MobSelect:SetValues(#list>0 and list or {"Nenhum"})
end

WorldSelect:OnChanged(UpdateMob)
task.spawn(UpdateMob)

Tabs.AutoFarm:AddToggle("Farm",{Title="Auto Farm (Sweep)",Icon="zap"}):OnChanged(function(v)
    _G.Farm=v
    task.spawn(function()
        while _G.Farm do
            local p=game.Players.LocalPlayer
            local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")

            local world=workspace:FindFirstChild(WorldSelect.Value:gsub(" ",""))
            local enemies=world and world:FindFirstChild("Enemy")

            if hrp and enemies then
                for _,mob in pairs(enemies:GetChildren()) do
                    if not _G.Farm then break end

                    if mob.Name==MobSelect.Value and mob:FindFirstChild("Humanoid") then
                        local target=mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                        if target then
                            hrp.CFrame=target.CFrame*CFrame.new(0,0,3)

                            for i=1,2 do
                                Remotes.Clicked:FireServer()
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end

            task.wait(0.1)
        end
    end)
end)

-- =========================
-- HATCH + GACHA
-- =========================
Tabs.Hatch:AddSection("Auto Star")

local EggSelect = Tabs.Hatch:AddDropdown("EggSelect",{
    Title="Selecionar Star",
    Values={
        "Dragon Ball (W1)",
        "One Piece (W2)",
        "Clover Village (W3)",
        "Demon Village (W4)"
    },
    Default="Dragon Ball (W1)"
})

Tabs.Hatch:AddToggle("Hatch",{Title="Auto Hatch",Icon="egg"}):OnChanged(function(v)
    _G.Hatch=v
    task.spawn(function()
        while _G.Hatch do
            local world=EggSelect.Value:match("W(%d+)")
            Remotes.Eggs.Hatch:InvokeServer("Star"..world,5)
            task.wait(0.01)
        end
    end)
end)

Tabs.Hatch:AddSection("Auto Gacha")

local GachaSelect = Tabs.Hatch:AddDropdown("GachaSelect",{
    Title="Selecionar Poder",
    Values={
        "Saiyan Power (W1)",
        "Dragon Power (W1)",
        "Fruits Power (W2)",
        "Grimoires Power (W3)",
        "Demon Power (W3)",
        "Breathing Power (W4)"
    },
    Default="Saiyan Power (W1)"
})

Tabs.Hatch:AddToggle("Gacha",{Title="Auto Gacha",Icon="refresh-cw"}):OnChanged(function(v)
    _G.Gacha=v
    task.spawn(function()
        while _G.Gacha do
            local power=GachaSelect.Value:gsub(" ",""):match("(%w+)")
            local remote=Remotes:FindFirstChild("Roll"..power) or Remotes:FindFirstChild(power)
            if remote then remote:FireServer() end
            task.wait(0.01)
        end
    end)
end)

-- =========================
-- RAIDS
-- =========================
Tabs.Gamemodes:AddSection("Raids")

local RaidSelect = Tabs.Gamemodes:AddDropdown("RaidSelect",{
    Title="Selecionar Raids",
    Values={"WisteriaRaid","TowerRaid"},
    Multi=true,
    Default={"WisteriaRaid"}
})

Tabs.Gamemodes:AddToggle("JoinRaid",{Title="Auto Join Raid",Icon="log-in"}):OnChanged(function(v)
    _G.JoinRaid=v
    task.spawn(function()
        while _G.JoinRaid do
            if IsSelected(RaidSelect.Value,"WisteriaRaid") then
                Remotes.OpenWisteriaRaid:FireServer()
            end
            if IsSelected(RaidSelect.Value,"TowerRaid") then
                Remotes.JoinTowerRaid:FireServer()
            end
            task.wait(2)
        end
    end)
end)

Tabs.Gamemodes:AddToggle("FarmRaid",{Title="Auto Farm Raid",Icon="swords"}):OnChanged(function(v)
    _G.FarmRaid=v
    task.spawn(function()
        while _G.FarmRaid do
            local hrp=game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if hrp then
                if IsSelected(RaidSelect.Value,"WisteriaRaid") then
                    local enemies=workspace.WisteriaRaid and workspace.WisteriaRaid.Raid1 and workspace.WisteriaRaid.Raid1:FindFirstChild("Enemy")
                    if enemies then
                        for _,mob in pairs(enemies:GetChildren()) do
                            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health>0 then
                                local t=mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                                if t then hrp.CFrame=t.CFrame*CFrame.new(0,0,3); Remotes.Clicked:FireServer() end
                            end
                        end
                    end
                end

                if IsSelected(RaidSelect.Value,"TowerRaid") then
                    local enemies=workspace.TowerRaid and workspace.TowerRaid.Raid1 and workspace.TowerRaid.Raid1:FindFirstChild("Enemy")
                    if enemies then
                        for _,mob in pairs(enemies:GetChildren()) do
                            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health>0 then
                                local t=mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                                if t then hrp.CFrame=t.CFrame*CFrame.new(0,0,3); Remotes.Clicked:FireServer() end
                            end
                        end
                    end
                end
            end

            task.wait(0.1)
        end
    end)
end)

-- =========================
-- CHECKPOINT + AUTO LEAVE
-- =========================
Tabs.Gamemodes:AddSection("Checkpoint")

Tabs.Gamemodes:AddButton({
    Title="Salvar Posição",
    Callback=function()
        local hrp=game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then SavedCFrame=hrp.CFrame end
    end
})

Tabs.Gamemodes:AddSection("Auto Leave")

Tabs.Gamemodes:AddInput("Wave",{Title="Sair na Wave",Default="10",Numeric=true,Callback=function(v)
    _G.TargetWave=tonumber(v)
end})

Tabs.Gamemodes:AddToggle("Leave",{Title="Auto Leave Wave",Icon="log-out"}):OnChanged(function(v)
    _G.Leave=v
    task.spawn(function()
        while _G.Leave do
            local wave=workspace:FindFirstChild("Wave") or workspace:FindFirstChild("CurrentWave")
            local current=wave and tonumber(wave.Value) or 0

            if _G.TargetWave>0 and current>=_G.TargetWave then
                if SavedCFrame then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=SavedCFrame
                end
                _G.Leave=false
                _G.FarmRaid=false
            end
            task.wait(2)
        end
    end)
end)

Window:SelectTab(1)
