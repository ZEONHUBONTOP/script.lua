-- GAME NAME
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

-- UI
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

-- TABS
local Tabs = {
    AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Player = Window:AddTab({ Title = "Players", Icon = "user" }),
    Hatch = Window:AddTab({ Title = "Hatch", Icon = "star" }),
    Gamemodes = Window:AddTab({ Title = "Gamemodes", Icon = "layout-grid" })
}

local SavedCFrame = nil
_G.TargetWave = 0

local function IsSelected(selected, name)
    if typeof(selected) == "table" then
        if table.find(selected, name) then return true end
        if selected[name] then return true end
    end
    return false
end

-- ================= PLAYER =================
Tabs.Player:AddSection("Ações")

Tabs.Player:AddToggle("Click",{Title="Auto Attack"}):OnChanged(function(v)
    _G.Click=v
    task.spawn(function()
        while _G.Click do
            Remotes.Clicked:FireServer()
            task.wait(0.1)
        end
    end)
end)

Tabs.Player:AddToggle("Chest",{Title="Auto Chest (1h)"}):OnChanged(function(v)
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

-- EQUIP BEST
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

Tabs.Player:AddToggle("Pets",{Title="Auto Best Pets"}):OnChanged(function(v)
    _G.Pets=v if v then AutoEquip("Pets","Pets","EquipBestPets") end
end)

Tabs.Player:AddToggle("Morphs",{Title="Auto Best Morphs"}):OnChanged(function(v)
    _G.Morphs=v if v then AutoEquip("Morphs","MorphPets","EquipBestMorphPets") end
end)

Tabs.Player:AddToggle("Accessories",{Title="Auto Best Accessories"}):OnChanged(function(v)
    _G.Accessories=v if v then AutoEquip("Accessories","Accessories","EquipBestAccessories") end
end)

Tabs.Player:AddToggle("Weapons",{Title="Auto Best Weapons"}):OnChanged(function(v)
    _G.Weapons=v if v then AutoEquip("Weapons","Weapons","EquipBestWeapons") end
end)

-- ================= AUTO FARM =================
Tabs.AutoFarm:AddSection("Config Do Farm")

local WorldSelect = Tabs.AutoFarm:AddDropdown("WorldSelect",{Title="Mundo",Values={"World 1","World 2","World 3","World 4"},Default="World 1"})
local MobSelect = Tabs.AutoFarm:AddDropdown("MobSelect",{Title="Mob",Values={"Carregando..."}})

local function UpdateMob()
    local world = workspace:FindFirstChild(WorldSelect.Value:gsub(" ",""))
    local list = {}
    if world and world:FindFirstChild("Enemy") then
        for _,m in pairs(world.Enemy:GetChildren()) do
            if not table.find(list,m.Name) then table.insert(list,m.Name) end
        end
    end
    MobSelect:SetValues(#list>0 and list or {"Nenhum"})
end

WorldSelect:OnChanged(UpdateMob)
task.spawn(UpdateMob)

Tabs.AutoFarm:AddToggle("Farm",{Title="Auto Farm Ultra"}):OnChanged(function(v)
    _G.Farm=v
    task.spawn(function()
        local index=1
        while _G.Farm do
            local hrp=game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local world=workspace:FindFirstChild(WorldSelect.Value:gsub(" ",""))
            local enemies=world and world:FindFirstChild("Enemy")

            if hrp and enemies then
                local mobs={}
                for _,m in pairs(enemies:GetChildren()) do
                    if m.Name==MobSelect.Value and m:FindFirstChild("Humanoid") then
                        table.insert(mobs,m)
                    end
                end

                if #mobs>0 then
                    if index>#mobs then index=1 end
                    local mob=mobs[index]
                    index+=1
                    local t=mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                    if t then hrp.CFrame=t.CFrame*CFrame.new(0,0,3); Remotes.Clicked:FireServer() end
                end
            end
            task.wait(0.15)
        end
    end)
end)

-- ================= HATCH =================
Tabs.Hatch:AddSection("Star Hatch")

local EggSelect = Tabs.Hatch:AddDropdown("EggSelect",{
    Title="Star",
    Values={"Dragon Ball (W1)","One Piece (W2)","Clover Village (W3)","Demon Village (W4)"},
    Default="Dragon Ball (W1)"
})

Tabs.Hatch:AddToggle("Hatch",{Title="Auto Star 0.01"}):OnChanged(function(v)
    _G.Hatch=v
    task.spawn(function()
        while _G.Hatch do
            local w=EggSelect.Value:match("W(%d+)")
            Remotes.Eggs.Hatch:InvokeServer("Star"..w,5)
            task.wait(0.01)
        end
    end)
end)

Tabs.Hatch:AddSection("Gacha Power")

local GachaSelect = Tabs.Hatch:AddDropdown("GachaSelect",{
    Title="Gacha",
    Values={
        "Saiyan Power (W1)",
        "Dragon Power (W1)",
        "Fruit Power (W2)",
        "Grimoires Power (W3)",
        "Demon Power (W3)",
        "Prosperity Power (W3)",
        "Breathing Power (W4)"
    }
})

Tabs.Hatch:AddToggle("Gacha",{Title="Auto Gacha 0.01"}):OnChanged(function(v)
    _G.Gacha=v
    task.spawn(function()
        while _G.Gacha do
            local p=GachaSelect.Value:gsub(" ",""):match("(%w+)")
            local r=Remotes:FindFirstChild("Roll"..p) or Remotes:FindFirstChild(p)
            if r then r:FireServer() end
            task.wait(0.01)
        end
    end)
end)

-- SKIP
Tabs.Hatch:AddToggle("Skip",{Title="Skip Animação"}):OnChanged(function(v)
    _G.Skip=v
    task.spawn(function()
        while _G.Skip do
            local pg=game.Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _,ui in pairs(pg:GetChildren()) do
                    if ui.Name:lower():find("egg") or ui.Name:lower():find("roll") then ui:Destroy() end
                end
            end
            for _,o in pairs(workspace:GetChildren()) do
                if o.Name:lower():find("egg") or o.Name:lower():find("roll") then o:Destroy() end
            end
            task.wait(0.01)
        end
    end)
end)

-- ================= RAID OTIMIZADO =================
Tabs.Gamemodes:AddSection("Raids Farm")

local RaidSelect = Tabs.Gamemodes:AddDropdown("RaidSelect",{
    Title="Raids",
    Values={"WisteriaRaid","TowerRaid"},
    Multi=true,
    Default={"WisteriaRaid"}
})

Tabs.Gamemodes:AddToggle("Join",{Title="Auto Join"}):OnChanged(function(v)
    _G.Join=v
    task.spawn(function()
        while _G.Join do
            if IsSelected(RaidSelect.Value,"WisteriaRaid") then Remotes.OpenWisteriaRaid:FireServer() end
            if IsSelected(RaidSelect.Value,"TowerRaid") then Remotes.JoinTowerRaid:FireServer() end
            task.wait(2)
        end
    end)
end)

-- RAID GOD
Tabs.Gamemodes:AddToggle("FarmRaid",{Title="Auto Farm Raid GOD"}):OnChanged(function(v)
    _G.FarmRaid=v
    task.spawn(function()
        local index=1
        while _G.FarmRaid do
            local hrp=game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            local folder=nil
            if IsSelected(RaidSelect.Value,"WisteriaRaid") then
                folder=workspace.WisteriaRaid and workspace.WisteriaRaid.Raid1 and workspace.WisteriaRaid.Raid1:FindFirstChild("Enemy")
            end
            if IsSelected(RaidSelect.Value,"TowerRaid") then
                folder=workspace.TowerRaid and workspace.TowerRaid.Raid1 and workspace.TowerRaid.Raid1:FindFirstChild("Enemy")
            end

            if hrp and folder then
                local alive={}
                for _,m in pairs(folder:GetChildren()) do
                    if m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 then table.insert(alive,m) end
                end

                if #alive>0 then
                    if index>#alive then index=1 end
                    local mob=alive[index]
                    index+=1
                    local t=mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Base")
                    if t then
                        hrp.CFrame=t.CFrame*CFrame.new(0,0,3)
                        Remotes.Clicked:FireServer()
                        Remotes.Clicked:FireServer()
                    end
                else
                    if SavedCFrame then hrp.CFrame=SavedCFrame end
                    repeat
                        task.wait(2)
                        local found=false
                        for _,m in pairs(folder:GetChildren()) do
                            if m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 then found=true break end
                        end
                        if not _G.FarmRaid then break end
                    until found
                end
            end
            task.wait(0.05)
        end
    end)
end)

-- SAVE + LEAVE
Tabs.Gamemodes:AddButton({Title="Salvar Posição",Callback=function()
    local hrp=game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then SavedCFrame=hrp.CFrame end
end})
    end)
end)

Window:SelectTab(1)
