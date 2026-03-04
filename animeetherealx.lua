-- // Limpeza de GUI Antiga (Evita duplicar o botão ao re-executar)
if game.CoreGui:FindFirstChild("ZeonSkullGui") then
    game.CoreGui.ZeonSkullGui:Destroy()
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local MarketPlaceService = game:GetService("MarketplaceService")
local GameInfo = MarketPlaceService:GetProductInfo(game.PlaceId)
local GameName = string.upper(GameInfo.Name)
local GameCreator = string.upper(GameInfo.Creator.Name)

-- // Janela Principal
local Window = Fluent:CreateWindow({
    Title = "ZEON HUB",
    SubTitle = "-- " .. GameName,
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300), 
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

-- // --- SISTEMA DO BOTÃO DE CAVEIRA (ANTI-DUPLICAÇÃO) ---
local ZeonGui = Instance.new("ScreenGui")
local SkullBtn = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ZeonGui.Name = "ZeonSkullGui"
ZeonGui.Parent = game.CoreGui
ZeonGui.ResetOnSpawn = false

SkullBtn.Name = "SkullBtn"
SkullBtn.Parent = ZeonGui
SkullBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SkullBtn.Position = UDim2.new(0, 50, 0, 10) 
SkullBtn.Size = UDim2.new(0, 55, 0, 55) 
SkullBtn.Image = "rbxassetid://415531405" 
SkullBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
SkullBtn.Active = true
SkullBtn.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = SkullBtn

UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2.5
UIStroke.Parent = SkullBtn

SkullBtn.MouseButton1Click:Connect(function()
    local fluentGui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if fluentGui then
        fluentGui.Enabled = not fluentGui.Enabled
    end
end)

-- // Variáveis de Controle
local Options = Fluent.Options
_G.AutoFarm_Normal = false
_G.SelectedMobsList = {}
_G.AutoClickPlayer = false
_G.AutoFarm_Trial = false
_G.AutoEnterTrial = false
_G.AutoEgg = false
_G.SelectedStar = "Naruto W1"

-- // ABAS
local Tabs = {
    Info = Window:AddTab({ Title = "Informações", Icon = "info" }),
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
    Player = Window:AddTab({ Title = "Player Farm", Icon = "user" }),
    Trial = Window:AddTab({ Title = "Auto Trial", Icon = "target" }),
    Star = Window:AddTab({ Title = "Auto Star", Icon = "star" }),
    Teleport = Window:AddTab({ Title = "Teleporte", Icon = "map-pin" })
}

-- --- 1. ABA DE INFORMAÇÕES ---
Tabs.Info:AddParagraph({ Title = "CRIADOR", Content = "ZEON TEAM", Icon = "user" })

local UpdateTimerLabel = Tabs.Info:AddParagraph({ 
    Title = "PRÓXIMA ATUALIZAÇÃO DO SCRIPT EM:", 
    Content = "Sincronizando...", 
    Icon = "clock" 
})

Tabs.Info:AddParagraph({ Title = "STATUS", Content = "ONLINE & SEGURO", Icon = "shield-check" })
Tabs.Info:AddParagraph({ Title = "GAME", Content = GameName .. " [" .. GameCreator .. "]", Icon = "gamepad-2" })

-- // LÓGICA DO CRONÓMETRO (DATA ALVO: 06/03/2026 ÀS 18:00)
local targetTime = 1772830800 -- Timestamp para 06/03/2026 18:00 (UTC-3 aprox)

task.spawn(function()
    while true do
        local currentTime = os.time()
        local timeLeft = targetTime - currentTime
        
        if timeLeft > 0 then
            local d = math.floor(timeLeft / 86400)
            local h = math.floor((timeLeft % 86400) / 3600)
            local m = math.floor((timeLeft % 3600) / 60)
            local s = timeLeft % 60
            UpdateTimerLabel:SetDesc(string.format("%02dd : %02dh : %02dm : %02ds", d, h, m, s))
        else
            UpdateTimerLabel:SetDesc("ATUALIZAÇÃO DISPONÍVEL!")
        end
        task.wait(1)
    end
end)

-- // Funções de Sistema (Mobs)
local function getRealName(mob)
    local billboard = mob:FindFirstChildWhichIsA("BillboardGui", true)
    if billboard then
        local textLabel = billboard:FindFirstChildWhichIsA("TextLabel", true)
        if textLabel and textLabel.Text ~= "" then return textLabel.Text end
    end
    return mob:GetAttribute("Name") or mob.Name
end

local function getMobNames()
    local names = {}
    local hash = {}
    local folder = workspace:FindFirstChild("Enemies") or workspace
    for _, mob in pairs(folder:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
            local name = getRealName(mob)
            if not hash[name] and name ~= game.Players.LocalPlayer.Name then
                table.insert(names, name)
                hash[name] = true
            end
        end
    end
    return #names > 0 and names or {"Nenhum Mob Encontrado"}
end

-- --- 2. AUTO FARM ---
local MobDropdown = Tabs.Main:AddDropdown("MobDropdown", { Title = "Selecionar Mobs", Values = getMobNames(), Multi = true, Default = {} })
Tabs.Main:AddButton({ Title = "Refresh Mobs", Icon = "refresh-cw", Callback = function() MobDropdown:SetValues(getMobNames()) end })
MobDropdown:OnChanged(function(Value) _G.SelectedMobsList = Value end)
Tabs.Main:AddToggle("FarmToggle", {Title = "Auto Farm Mobs", Default = false }):OnChanged(function() _G.AutoFarm_Normal = Options.FarmToggle.Value end)

-- --- 3. PLAYER FARM ---
Tabs.Player:AddToggle("PlayerClickToggle", {Title = "Auto Click", Default = false }):OnChanged(function() _G.AutoClickPlayer = Options.PlayerClickToggle.Value end)

-- --- 4. AUTO TRIAL ---
Tabs.Trial:AddToggle("AutoEnterToggle", {Title = "Auto Entrar na Trial", Default = false }):OnChanged(function() _G.AutoEnterTrial = Options.AutoEnterToggle.Value end)
Tabs.Trial:AddToggle("TrialFarmToggle", {Title = "Auto Kill Trial (Bruto)", Default = false }):OnChanged(function() _G.AutoFarm_Trial = Options.TrialFarmToggle.Value end)

-- --- 5. AUTO STAR ---
local StarDropdown = Tabs.Star:AddDropdown("StarDropdown", { Title = "Selecionar Star", Values = {"Naruto W1", "Namek W2", "Demon Slayer W4"}, Default = 1 })
StarDropdown:OnChanged(function(Value) _G.SelectedStar = Value end)
Tabs.Star:AddToggle("EggToggle", {Title = "Auto Roll (1s)", Default = false }):OnChanged(function() _G.AutoEgg = Options.EggToggle.Value end)

-- --- 6. TELEPORTE ---
Tabs.Teleport:AddButton({ Title = "Área 2x Energy", Icon = "zap", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1261.28, 232.91, 1320.81) end })
Tabs.Teleport:AddButton({ Title = "Área 4x Energy", Icon = "zap", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(411.29, 245.59, 942.58) end })

-- --- LOOPS ---

task.spawn(function()
    while true do
        task.wait(2)
        if _G.AutoEnterTrial then
            pcall(function() game:GetService("ReplicatedStorage").RemotesFolder.EnterTrial:FireServer(1) end)
        end
    end
end)

task.spawn(function()
    while true do
        if _G.AutoClickPlayer then game:GetService("ReplicatedStorage").RemotesFolder.Click:FireServer() end
        task.wait()
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if _G.AutoFarm_Trial then
                local enemies = workspace:FindFirstChild("Enemies") or workspace
                for _, mob in pairs(enemies:GetDescendants()) do
                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob ~= char then
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        break
                    end
                end
            elseif _G.AutoFarm_Normal then
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        local name = getRealName(mob)
                        if _G.SelectedMobsList[name] then
                            hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

Window:SelectTab(1)
