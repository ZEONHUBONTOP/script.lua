local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Zeon Hub | Bite By Night",
    SubTitle = "versão 1.0 do script,
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Options = { P_ESP = false, G_ESP = false, B_ESP = false, F_ESP = false, A_Solve = false, I_Stam = false, Noc = false, FB = false, InstInt = false }

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- // --- FUNÇÃO DE TAGS (NOMES + DISTÂNCIA) ---
local function CreateTag(parent, text, color)
    local existing = parent:FindFirstChild("ZeonTag")
    local bgui, label
    
    if existing then 
        bgui = existing
        label = bgui.Frame.TextLabel
    else
        bgui = Instance.new("BillboardGui")
        bgui.Name = "ZeonTag"
        bgui.Adornee = parent
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.StudsOffset = Vector3.new(0, 2, 0)
        bgui.AlwaysOnTop = true
        bgui.Parent = parent

        local frame = Instance.new("Frame", bgui)
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 1, 0)

        label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = frame
    end
    
    label.TextColor3 = color
    label.Text = text
    return bgui
end

-- // --- FUNÇÃO DE BORDA (HIGHLIGHT) ---
local function ApplyHighlight(obj, color)
    local hl = obj:FindFirstChild("ZeonHL")
    if not hl then
        hl = Instance.new("Highlight", obj)
        hl.Name = "ZeonHL"
    end
    hl.FillTransparency = 1 
    hl.OutlineColor = color
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = true
end

-- // --- TABS ---
local Tabs = {
    Visuals = Window:AddTab({ Title = "Visuais", Icon = "eye" }),
    Auto = Window:AddTab({ Title = "Automação", Icon = "bolt" }),
    Utils = Window:AddTab({ Title = "Utilidades", Icon = "settings" })
}

-- UI VISUAIS
Tabs.Visuals:AddToggle("P", {Title = "Player ESP", Default = false}):OnChanged(function(v) Options.P_ESP = v end)
Tabs.Visuals:AddToggle("G", {Title = "Gerador ESP", Default = false}):OnChanged(function(v) Options.G_ESP = v end)
Tabs.Visuals:AddToggle("B", {Title = "Bateria ESP", Default = false}):OnChanged(function(v) Options.B_ESP = v end)
Tabs.Visuals:AddToggle("FBX", {Title = "FuseBox ESP", Default = false}):OnChanged(function(v) Options.F_ESP = v end)
Tabs.Visuals:AddToggle("FB", {Title = "FullBright / No Fog", Default = false}):OnChanged(function(v) Options.FB = v end)

-- UI OUTROS
Tabs.Auto:AddToggle("I", {Title = "Interação Instantânea", Default = false}):OnChanged(function(v) Options.InstInt = v end)
Tabs.Utils:AddToggle("ST", {Title = "Inf Stamina", Default = false}):OnChanged(function(v) Options.I_Stam = v end)
Tabs.Utils:AddToggle("N", {Title = "Noclip", Default = false}):OnChanged(function(v) Options.Noc = v end)

-- // --- LOOP PRINCIPAL ---
RunService.RenderStepped:Connect(function()
    -- FullBright Logic
    if Options.FB then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        Lighting.Ambient = Color3.new(1, 1, 1)
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then atmosphere:Destroy() end
    end

    -- ESP Players
    if Options.P_ESP then
        local PlayersFolder = workspace:FindFirstChild("PLAYERS")
        if PlayersFolder then
            local Alive = PlayersFolder:FindFirstChild("ALIVE")
            local Killer = PlayersFolder:FindFirstChild("KILLER")
            
            if Alive then
                for _, char in pairs(Alive:GetChildren()) do
                    if char:IsA("Model") and char ~= LocalPlayer.Character and char:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                        CreateTag(char.HumanoidRootPart, string.format("%s\n[%dm]", char.Name, dist), Color3.new(0, 1, 0)).Enabled = true
                        ApplyHighlight(char, Color3.new(0, 1, 0))
                    end
                end
            end
            
            if Killer then
                for _, char in pairs(Killer:GetChildren()) do
                    if char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                        CreateTag(char.HumanoidRootPart, string.format("%s\n[%dm]", char.Name, dist), Color3.new(1, 0, 0)).Enabled = true
                        ApplyHighlight(char, Color3.new(1, 0, 0))
                    end
                end
            end
        end
    end

    -- ESP Geradores (Geral)
    if Options.G_ESP then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find("generator") and (v:IsA("BasePart") or v:IsA("Model")) then
                local target = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                if target then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude)
                    CreateTag(target, string.format("GERADOR\n[%dm]", dist), Color3.new(1, 1, 0)).Enabled = true
                end
            end
        end
    end

    -- ESP Baterias (Caminho Específico)
    if Options.B_ESP then
        local BatFolder = workspace.MAPS["GAME MAP"]:FindFirstChild("Batteries")
        if BatFolder then
            for _, b in pairs(BatFolder:GetChildren()) do
                local target = b:IsA("Model") and (b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart")) or b
                if target then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude)
                    CreateTag(target, string.format("BATERIA\n[%dm]", dist), Color3.fromRGB(0, 255, 255)).Enabled = true
                end
            end
        end
    end

    -- ESP FuseBoxes (Caminho Específico)
    if Options.F_ESP then
        local FuseFolder = workspace.MAPS["GAME MAP"]:FindFirstChild("FuseBoxes")
        if FuseFolder then
            for _, f in pairs(FuseFolder:GetChildren()) do
                local target = f:IsA("Model") and (f.PrimaryPart or f:FindFirstChildWhichIsA("BasePart")) or f
                if target then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude)
                    CreateTag(target, string.format("FUSE BOX\n[%dm]", dist), Color3.fromRGB(255, 127, 0)).Enabled = true
                end
            end
        end
    end
end)

-- Utilitários
task.spawn(function()
    while task.wait(0.5) do
        if Options.InstInt then
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        if Options.I_Stam then LocalPlayer.Character:SetAttribute("Stamina", 100) end
        if Options.Noc then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end
        end
    end
end)

Fluent:Notify({Title = "Zeon Hub", Content = "Rastreador de Itens Ativado!", Duration = 3})

