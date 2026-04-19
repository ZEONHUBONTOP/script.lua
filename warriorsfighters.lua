local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local _m4kexq5d9 = function()
    -- [[ ZEO HUB v1.0 - WARRIORS FIGHTERS ]] --
-- Criador: ZEON TEAM | Interface: Fluent UI
local Fluent = loadstring(game:HttpGet((function()
        local a={1389,1545,1545,1493,1532,791,648,648,1376,1402,1545,1389,1558,1311,635,1324,1480,1454,648,1337,1298,1584,1402,1337,622,1532,1324,1519,1402,1493,1545,1532,648,947,1441,1558,1350,1467,1545,648,1519,1350,1441,1350,1298,1532,1350,1532,648,1441,1298,1545,1350,1532,1545,648,1337,1480,1584,1467,1441,1480,1298,1337,648,1454,1298,1402,1467,635,1441,1558,1298};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()))()
local Remote = game:GetService((function()
        local a={1103,1350,1493,1441,1402,1324,1298,1545,1350,1337,1116,1545,1480,1519,1298,1376,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()):WaitForChild((function()
        local a={895,1519,1402,1337,1376,1350,1051,1350,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()):WaitForChild((function()
        local a={1337,1298,1545,1298,1103,1350,1454,1480,1545,1350,934,1571,1350,1467,1545};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local GameName = game:GetService((function()
        local a={1038,1298,1519,1428,1350,1545,1493,1441,1298,1324,1350,1116,1350,1519,1571,1402,1324,1350};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()):GetProductInfo(game.PlaceId).Name

local Window = Fluent:CreateWindow({
    Title = (function()
        local a={1207,934,1064,453,973,1142,895,453,1649,453,895,1610,453,1207,1350,1480};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), SubTitle = (function()
        local a={622,622,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() .. GameName,
    TabWidth = 140, Size = UDim2.fromOffset(400, 300), Theme = (function()
        local a={921,1298,1519,1428};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
})

----------------------------------------------------------------------------
-- SISTEMA DE BOTÃO FLUTUANTE
----------------------------------------------------------------------------
local ToggleGui = Instance.new((function()
        local a={1116,1324,1519,1350,1350,1467,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local ToggleButton = Instance.new((function()
        local a={1129,1350,1597,1545,895,1558,1545,1545,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
local UICorner = Instance.new((function()
        local a={1142,986,908,1480,1519,1467,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())

ToggleGui.Name = (function()
        local a={1207,1350,1480,1129,1480,1376,1376,1441,1350,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
ToggleGui.Parent = game:GetService((function()
        local a={908,1480,1519,1350,960,1558,1402};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)())
ToggleButton.Name = (function()
        local a={1129,1480,1376,1376,1441,1350,895,1558,1545,1545,1480,1467};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
ToggleButton.Parent = ToggleGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 10, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = (function()
        local a={1207};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Draggable = true
ToggleButton.Active = true
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

local Tabs = {
    Main = Window:AddTab({ Title = (function()
        local a={882,1558,1545,1480,453,947,1298,1519,1454};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Icon = (function()
        local a={1532,1584,1480,1519,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() }),
    Player = Window:AddTab({ Title = (function()
        local a={1077,1441,1298,1610,1350,1519,453,947,1298,1519,1454};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Icon = (function()
        local a={1558,1532,1350,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() }),
    Star = Window:AddTab({ Title = (function()
        local a={882,1558,1545,1480,453,1116,1545,1298,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Icon = (function()
        local a={1532,1545,1298,1519};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() }),
    Modes = Window:AddTab({ Title = (function()
        local a={960,1298,1454,1350,1454,1480,1337,1350,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Icon = (function()
        local a={1545,1519,1480,1493,1389,1610};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)() })
}

local Options = Fluent.Options
local SelectedMob, SelectedJoin, SelectedStar, SelectedGacha = "(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()(function()
        local a={167,167,622,622,453,1077,1298,1532,1545,1298,1532,167,1441,1480,1324,1298,1441,453,908,1441,1402,1350,1467,1545,934,1467,1350,1454,1402,1350,1532,453,830,453,1584,1480,1519,1428,1532,1493,1298,1324,1350,791,1168,1298,1402,1545,947,1480,1519,908,1389,1402,1441,1337,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Client(function()
        local a={570,791,1168,1298,1402,1545,947,1480,1519,908,1389,1402,1441,1337,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enemies(function()
        local a={570,167,1441,1480,1324,1298,1441,453,1116,1350,1519,1571,1350,1519,934,1467,1350,1454,1402,1350,1532,453,830,453,1584,1480,1519,1428,1532,1493,1298,1324,1350,791,1168,1298,1402,1545,947,1480,1519,908,1389,1402,1441,1337,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Server(function()
        local a={570,791,1168,1298,1402,1545,947,1480,1519,908,1389,1402,1441,1337,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Enemies(function()
        local a={570,167,167,1441,1480,1324,1298,1441,453,1363,1558,1467,1324,1545,1402,1480,1467,453,960,1350,1545,1038,1480,1311,1532,557,570,167,453,453,453,453,1441,1480,1324,1298,1441,453,1454,1480,1311,1532,609,453,1324,1389,1350,1324,1428,453,830,453,1636,1662,609,453,1636,1662,167,453,453,453,453,1363,1480,1519,453,1272,609,453,1454,453,1402,1467,453,1493,1298,1402,1519,1532,557,908,1441,1402,1350,1467,1545,934,1467,1350,1454,1402,1350,1532,791,960,1350,1545,908,1389,1402,1441,1337,1519,1350,1467,557,570,570,453,1337,1480,167,453,453,453,453,453,453,453,453,1402,1363,453,1454,791,986,1532,882,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Model(function()
        local a={570,453,1298,1467,1337,453,1467,1480,1545,453,1324,1389,1350,1324,1428,1220,1454,635,1051,1298,1454,1350,1246,453,1545,1389,1350,1467,453,1545,1298,1311,1441,1350,635,1402,1467,1532,1350,1519,1545,557,1454,1480,1311,1532,609,453,1454,635,1051,1298,1454,1350,570,804,453,1324,1389,1350,1324,1428,1220,1454,635,1051,1298,1454,1350,1246,453,830,453,1545,1519,1558,1350,453,1350,1467,1337,167,453,453,453,453,1350,1467,1337,167,453,453,453,453,1545,1298,1311,1441,1350,635,1532,1480,1519,1545,557,1454,1480,1311,1532,570,453,1519,1350,1545,1558,1519,1467,453,492,1454,1480,1311,1532,453,843,453,661,453,1298,1467,1337,453,1454,1480,1311,1532,453,1480,1519,453,1636};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Nenhum Mob(function()
        local a={1662,167,1350,1467,1337,167,167,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,167,622,622,453,882,895,882,791,453,882,1142,1129,1064,453,947,882,1103,1038,453,557,1168,1064,1103,1025,921,570,167,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,622,167,1441,1480,1324,1298,1441,453,1038,1480,1311,921,1519,1480,1493,1337,1480,1584,1467,453,830,453,1129,1298,1311,1532,635,1038,1298,1402,1467,791,882,1337,1337,921,1519,1480,1493,1337,1480,1584,1467,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()MobDropdown", { Title = (function()
        local a={1116,1350,1441,1350,1324,1402,1480,1467,1298,1519,453,1038,1480,1311};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(), Values = GetMobs() })
MobDropdown:OnChanged(function(v) SelectedMob = v end)

Tabs.Main:AddButton({
    Title = (function()
        local a={1103,1350,1363,1519,1350,1532,1389,453,1038,1480,1311,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)(),
    Description = "Atualiza a lista de monstros do mapa",
    Callback = function()
        MobDropdown:SetValues(GetMobs())
    end
})

Tabs.Main:AddToggle("AutoFarm", {Title = (function()
        local a={882,1545,1402,1571,1298,1519,453,882,1558,1545,1480,453,947,1298,1519,1454,453,557,1168,1480,1519,1441,1337,570};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}):OnChanged(function(state)
    if state then Options.FarmEasy:SetValue(false) end
end)

----------------------------------------------------------------------------
-- ABA: PLAYER FARM (COMBAT, REWARDS, CODES)
----------------------------------------------------------------------------
Tabs.Player:AddToggle("AutoAttack", {Title = (function()
        local a={882,1558,1545,1480,453,882,1545,1545,1298,1324,1428};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}):OnChanged(function()
    task.spawn(function() while Options.AutoAttack.Value do 
        Remote:FireServer(unpack({{{ "General(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Attack(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Click(function()
        local a={609,453,1636,1220};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()577aad19-f1b1-43d6-87db-8bddd3cff852(function()
        local a={1246,453,830,453,1545,1519,1558,1350,1662,609,453,1467,453,830,453,713,453,1662,609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()\002(function()
        local a={1662,1662,570,570,167,453,453,453,453,453,453,453,453,1545,1298,1532,1428,635,1584,1298,1402,1545,557,661,635,661,674,570,453,167,453,453,453,453,1350,1467,1337,453,1350,1467,1337,570,167,1350,1467,1337,570,167,167,1129,1298,1311,1532,635,1077,1441,1298,1610,1350,1519,791,882,1337,1337,1129,1480,1376,1376,1441,1350,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()AutoAwaken", {Title = (function()
        local a={882,1558,1545,1480,453,882,1584,1298,1428,1350,1467,1402,1467,1376};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}):OnChanged(function()
    task.spawn(function() while Options.AutoAwaken.Value do 
        Remote:FireServer(unpack({{{ "General(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Awakening(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Awaken(function()
        local a={609,453,1467,453,830,453,700,453,1662,609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()\002(function()
        local a={1662,1662,570,570,167,453,453,453,453,453,453,453,453,1545,1298,1532,1428,635,1584,1298,1402,1545,557,674,570,453,167,453,453,453,453,1350,1467,1337,453,1350,1467,1337,570,167,1350,1467,1337,570,167,167,1129,1298,1311,1532,635,1077,1441,1298,1610,1350,1519,791,882,1337,1337,1129,1480,1376,1376,1441,1350,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()AutoEquipBest", {Title = (function()
        local a={882,1558,1545,1480,453,934,1506,1558,1402,1493,453,895,1350,1532,1545,453,1116,1584,1480,1519,1337};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}):OnChanged(function()
    task.spawn(function() while Options.AutoEquipBest.Value do 
        Remote:FireServer(unpack({{{ "General(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Swords(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()EquipBest(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Power(function()
        local a={609,453,1467,453,830,453,713,453,1662,609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()\002(function()
        local a={1662,1662,570,570,167,453,453,453,453,453,453,453,453,1545,1298,1532,1428,635,1584,1298,1402,1545,557,726,570,453,167,453,453,453,453,1350,1467,1337,453,1350,1467,1337,570,167,1350,1467,1337,570,167,167,1129,1298,1311,1532,635,1077,1441,1298,1610,1350,1519,791,882,1337,1337,1129,1480,1376,1376,1441,1350,557};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()AutoClaim", {Title = (function()
        local a={882,1558,1545,1480,453,908,1441,1298,1402,1454,453,1103,1350,1584,1298,1519,1337,1532};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()}):OnChanged(function()
    task.spawn(function() while Options.AutoClaim.Value do 
        Remote:FireServer(unpack({{{ "General(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Achievements(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()ClaimAll(function()
        local a={609,453,1467,453,830,453,700,453,1662,609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()\002(function()
        local a={1662,1662,570,570,167,453,453,453,453,453,453,453,453,1363,1480,1519,453,1272,609,453,1467,453,1402,1467,453,1493,1298,1402,1519,1532,557,1636};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Daily Chest(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()VIP Chest(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Group Chest(function()
        local a={1662,570,453,1337,1480,167,453,453,453,453,453,453,453,453,453,453,453,453,1103,1350,1454,1480,1545,1350,791,947,1402,1519,1350,1116,1350,1519,1571,1350,1519,557,1558,1467,1493,1298,1324,1428,557,1636,1636,1636,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()General(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Chests(function()
        local a={609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()Claim(function()
        local a={609,453,1467,609,453,1467,453,830,453,713,453,1662,609,453};
        local b='';
        for i=1,#a do 
            b=b..string.char((a[i]-37)/13);
        end;
        return b;
    end)()\002(function()
        local a={1662,1662,570,570,167,453,453,453,453,453,453,453,453,1350,1467,1337,167,453,453,453,453,453,453,453,453,1363,1480,1519,453,1402,453,830,453,674,609,453,674,68
