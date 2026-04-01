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

-- ================= PLAYER =================

Tabs.Player:AddToggle("Click",{Title="Auto Click"}):OnChanged(function(v)
    _G.Click=v
    if v then
        task.spawn(function()
            while _G.Click do
                Remotes.Clicked:FireServer()
                task.wait(0.1)
            end
        end)
    end
end)

-- AUTO CHEST (1H FIX)
Tabs.Player:AddToggle("Chest",{Title="Auto Chest (1h)"}):OnChanged(function(v)
    _G.Chest=v
    if v then
        task.spawn(function()
            while _G.Chest do
                local p = game.Players.LocalPlayer
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local chests = workspace:FindFirstChild("Chests")

                if hrp and chests then
                    local old = hrp.CFrame

                    for _, chest in pairs(chests:GetChildren()) do
                        local part = chest:IsA("BasePart") and chest or chest:FindFirstChildWhichIsA("BasePart")
                        if part then
                            hrp.CFrame = part.CFrame * CFrame.new(0,3,0)
                            firetouchinterest(hrp, part, 0)
                            firetouchinterest(hrp, part, 1)
                            task.wait(0.2)
                        end
                    end

                    hrp.CFrame = old
                end

                task.wait(3600)
            end
        end)
    end
end)

-- ================= HATCH =================

local EggSelect = Tabs.Hatch:AddDropdown("Egg",{
    Title="Star",
    Values={"Dragon Ball (W1)","One Piece (W2)","Clover Village (W3)","Demon Village (W4)"},
    Default="Dragon Ball (W1)"
})

Tabs.Hatch:AddToggle("Hatch",{Title="Auto Hatch"}):OnChanged(function(v)
    _G.Hatch=v
    if v then
        task.spawn(function()
            while _G.Hatch do
                local w=EggSelect.Value:match("W(%d+)")
                Remotes.Eggs.Hatch:InvokeServer("Star"..w,5)
                task.wait(0.1)
            end
        end)
    end
end)

-- GACHA CORRIGIDO
local GachaSelect = Tabs.Hatch:AddDropdown("Gacha",{
    Title="Power",
    Values={
        "DragonBallPower (W1)",
        "SaiyanPower (W1)",
        "FruitPower (W2)",
        "GrimoiresPower (W3)",
        "ProsperityPower (W3)",
        "DemonPower (W3)",
        "BreathingPower (W4)"
    },
    Default="DragonBallPower (W1)"
})

Tabs.Hatch:AddToggle("GachaT",{Title="Auto Gacha"}):OnChanged(function(v)
    _G.Gacha=v
    if v then
        task.spawn(function()
            while _G.Gacha do
                local p = GachaSelect.Value:match("^(%w+)")
                local r = Remotes:FindFirstChild("Roll"..p)
                if r then r:FireServer() end
                task.wait(0.1)
            end
        end)
    end
end)

-- ================= GAMEMODES =================

local RaidSelect = Tabs.Gamemodes:AddDropdown("Raid",{
    Title="Raid",
    Values={"WisteriaRaid","TowerRaid"},
    Multi=true,
    Default={"WisteriaRaid"}
})

-- AUTO JOIN FIX
Tabs.Gamemodes:AddToggle("Join",{Title="Auto Join"}):OnChanged(function(v)
    _G.Join=v
    if v then
        task.spawn(function()
            while _G.Join do
                if table.find(RaidSelect.Value,"WisteriaRaid") then
                    Remotes.OpenWisteriaRaid:FireServer()
                end
                if table.find(RaidSelect.Value,"TowerRaid") then
                    Remotes.TowerRaid:FireServer()
                end
                task.wait(2)
            end
        end)
    end
end)

-- AUTO FARM RAID
Tabs.Gamemodes:AddToggle("FarmRaid",{Title="Auto Farm Raid"}):OnChanged(function(v)
    _G.FarmRaid=v
    if v then
        task.spawn(function()
            while _G.FarmRaid do
                local hrp=game.Players.LocalPlayer.Character.HumanoidRootPart
                local found=false

                for _,raidName in pairs(RaidSelect.Value) do
                    local raid=workspace:FindFirstChild(raidName)
                    if raid then
                        local enemies=raid:FindFirstChild("Enemy") or (raid:FindFirstChild("Raid1") and raid.Raid1:FindFirstChild("Enemy"))

                        if enemies then
                            for _,mob in pairs(enemies:GetChildren()) do
                                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health>0 then
                                    found=true
                                    hrp.CFrame=mob.HumanoidRootPart.CFrame*CFrame.new(0,0,3)
                                    Remotes.Clicked:FireServer()
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end

                -- SAI DO RAID + VOLTA
                if not found then
                    Remotes.LeaveRaid:FireServer()
                    task.wait(1)

                    if SavedCFrame then
                        hrp.CFrame=SavedCFrame
                    end

                    task.wait(3)
                end

                task.wait()
            end
        end)
    end
end)

-- SAVE POSITION
Tabs.Gamemodes:AddButton({
    Title="Save Position",
    Callback=function()
        local hrp=game.Players.LocalPlayer.Character.HumanoidRootPart
        SavedCFrame=hrp.CFrame
    end
})

Window:SelectTab(1)
