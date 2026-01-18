--[[
    Syu_hub v9.0 | Ultimate Blobman & Phoenix Features
    Target: Fling Things and People
    UI: Rayfield Interface Suite
    Added: Poison/Radioactive/Fire/Noclip Grab, Kick Grab, Fire All, Anchor Grab, Auto Recover
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Syu_hub | Ultimate v9.0",
    LoadingTitle = "Syu_hub Loading...",
    LoadingSubtitle = "by Gemini + Phoenix Features",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

-- ■■■ Services ■■■
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- ■■■ Variables ■■■
local TargetPlayer = nil
local IsLoopKicking = false
local OriginalPosition = nil

local IsPoisonGrab = false
local IsRadioactiveGrab = false
local IsFireGrab = false
local IsNoclipGrab = false
local IsKickGrab = false
local IsFireAll = false
local IsAnchorGrab = false
local IsAutoRecover = false

local GrabbedObjects = {}
local Highlighted = {}

-- ■■■ Poison / Paint Parts ■■■
local PoisonParts = {}
local PaintParts = {}

task.spawn(function()
    if Workspace:FindFirstChild("Map") then
        for _, v in pairs(Workspace.Map:GetDescendants()) do
            if v.Name == "PoisonHurtPart" and v:IsA("Part") then table.insert(PoisonParts, v) end
            if v.Name == "PaintPlayerPart" and v:IsA("Part") then table.insert(PaintParts, v) end
        end
    end
end)

-- ■■■ Utility ■■■
function SendNotif(title, content)
    Rayfield:Notify({ Title = title, Content = content, Duration = 5, Image = 4483345998 })
end

function GetPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

function FindBlobman()
    local nearest, dist = nil, 500
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v.Name == "Blobman" or v.Name == "Ragdoll") and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(v) then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d < dist then dist = d nearest = v end
                end
            end
        end
    end
    return nearest
end

function SpawnBlobman()
    local args = { [1] = "Blobman" }
    local spawned = false
    for _, desc in pairs(ReplicatedStorage:GetDescendants()) do
        if desc:IsA("RemoteEvent") and (string.find(desc.Name, "Spawn") or string.find(desc.Name, "Create") or string.find(desc.Name, "Toy")) then
            pcall(function() desc:FireServer(unpack(args)) end)
            spawned = true
        end
    end
    if spawned then SendNotif("Spawn", "Blobman スポーン試行") end
end

function TriggerGrab(part)
    for _, desc in pairs(ReplicatedStorage:GetDescendants()) do
        if desc:IsA("RemoteEvent") and (string.find(desc.Name, "Grab") or string.find(desc.Name, "Interact")) then
            pcall(function() desc:FireServer(part) end)
        end
    end
end

-- ■■■ Blobman Kick Attack ■■■
function BlobmanKick(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local myHrp = char.HumanoidRootPart
    local targetHrp = target.Character.HumanoidRootPart

    if not OriginalPosition then OriginalPosition = myHrp.CFrame end

    local ammo = FindBlobman()
    if not ammo then
        SpawnBlobman()
        task.wait(0.2)
        ammo = FindBlobman()
        if not ammo then return end
    end

    if ammo:FindFirstChild("HumanoidRootPart") then
        ammo.HumanoidRootPart.CFrame = myHrp.CFrame * CFrame.new(0, 0, -2)
        ammo.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end

    myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
    task.wait(0.01)

    TriggerGrab(targetHrp)
    task.wait(0.01)

    myHrp.Velocity = myHrp.CFrame.LookVector * 800 + Vector3.new(0, 200, 0)
    task.wait(0.05)

    myHrp.CFrame = OriginalPosition
    myHrp.Velocity = Vector3.new(0,0,0)
    OriginalPosition = nil
end

-- ■■■ Grab Effects Loop ■■■
task.spawn(function()
    while task.wait() do
        local grabParts = Workspace:FindFirstChild("GrabParts")
        if grabParts and grabParts:FindFirstChild("GrabPart") then
            local weld = grabParts.GrabPart:FindFirstChild("WeldConstraint")
            if weld and weld.Part1 and weld.Part1.Parent:FindFirstChild("Head") then
                local head = weld.Part1.Parent.Head

                if IsPoisonGrab then
                    for _, p in pairs(PoisonParts) do
                        p.Size = Vector3.new(4,4,4)
                        p.Position = head.Position
                        p.Transparency = 0.8
                    end
                end

                if IsRadioactiveGrab then
                    for _, p in pairs(PaintParts) do
                        p.Size = Vector3.new(4,4,4)
                        p.Position = head.Position
                        p.Transparency = 0.8
                    end
                end

                if IsFireGrab then
                    local toys = Workspace:FindFirstChild(LocalPlayer.Name.."SpawnedInToys")
                    if toys then
                        local campfire = toys:FindFirstChild("Campfire")
                        if campfire then
                            local fire = campfire:FindFirstChild("FirePlayerPart")
                            if fire then
                                fire.Size = Vector3.new(8,8,8)
                                fire.Position = head.Position
                                task.wait(0.3)
                                fire.Position = Vector3.new(0,-100,0)
                            end
                        end
                    end
                end

                if IsNoclipGrab then
                    for _, p in pairs(weld.Part1.Parent:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        else
            for _, p in pairs(PoisonParts) do p.Position = Vector3.new(0,-200,0) end
            for _, p in pairs(PaintParts) do p.Position = Vector3.new(0,-200,0) end
        end
    end
end)

-- ■■■ Kick Grab (Big FirePlayerPart) ■■■
task.spawn(function()
    while task.wait(1) do
        if IsKickGrab then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local fire = plr.Character.HumanoidRootPart:FindFirstChild("FirePlayerPart")
                    if fire then
                        fire.Size = Vector3.new(6,6,6)
                        fire.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- ■■■ Fire All Spam ■■■
task.spawn(function()
    while task.wait(0.4) do
        if IsFireAll then
            pcall(function()
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("Campfire", Vector3.new(0,0,0), Vector3.new(0,90,0))
            end)
        end
    end
end)

-- ■■■ Anchor Grab + Highlight ■■■
task.spawn(function()
    while task.wait() do
        if IsAnchorGrab then
            local grabParts = Workspace:FindFirstChild("GrabParts")
            if grabParts and grabParts:FindFirstChild("GrabPart") then
                local weld = grabParts.GrabPart:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 then
                    local obj = weld.Part1
                    if not table.find(GrabbedObjects, obj) then
                        table.insert(GrabbedObjects, obj)
                        local model = obj:FindFirstAncestorWhichIsA("Model") or obj
                        local hl = Instance.new("Highlight")
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0.4
                        hl.OutlineColor = Color3.new(0,0,1)
                        hl.Parent = model
                        table.insert(Highlighted, hl)

                        local bp = Instance.new("BodyPosition", obj)
                        local bg = Instance.new("BodyGyro", obj)
                        bp.MaxForce = Vector3.new(1e6,1e6,1e6)
                        bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
                    end
                end
            end
        end
    end
end)

-- ■■■ Auto Recover ■■■
task.spawn(function()
    while task.wait(0.05) do
        if IsAutoRecover and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(GrabbedObjects) do
                if obj and obj.Parent and (obj.Position - hrp.Position).Magnitude < 40 then
                    local owner = obj:FindFirstChild("PartOwner")
                    if owner and owner.Value == LocalPlayer.Name then
                        TriggerGrab(obj)
                    end
                end
            end
        end
    end
end)

-- ■■■ UI ■■■
local MainTab = Window:CreateTab("Main", 4483345998)

local TargetSection = MainTab:CreateSection("Target Selector")
local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Select Target Player",
    Options = GetPlayerNames(),
    CurrentOption = "",
    Callback = function(Option)
        TargetPlayer = Option[1]
        SendNotif("Target", "選択: " .. TargetPlayer)
    end,
})
MainTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        PlayerDropdown:Refresh(GetPlayerNames())
    end,
})

local KickSection = MainTab:CreateSection("Blobman Kick Actions")
MainTab:CreateButton({
    Name = "Single Kick Target",
    Callback = function()
        if TargetPlayer then BlobmanKick(TargetPlayer) end
    end,
})
MainTab:CreateToggle({
    Name = "Loop Kick Target",
    CurrentValue = false,
    Callback = function(v)
        IsLoopKicking = v
        if v and TargetPlayer then
            task.spawn(function()
                while IsLoopKicking do
                    BlobmanKick(TargetPlayer)
                    task.wait(0.15)
                end
            end)
        end
    end,
})
MainTab:CreateButton({
    Name = "Loop Kick ALL (Toggle)",
    Callback = function()
        IsLoopKicking = not IsLoopKicking
        if IsLoopKicking then
            task.spawn(function()
                while IsLoopKicking do
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            BlobmanKick(p.Name)
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end,
})
MainTab:CreateButton({ Name = "Force Spawn Blobman", Callback = SpawnBlobman })

local GrabEffectsSection = MainTab:CreateSection("Grab Effects (Phoenix Features)")
MainTab:CreateToggle({ Name = "Poison Grab", CurrentValue = false, Callback = function(v) IsPoisonGrab = v end })
MainTab:CreateToggle({ Name = "Radioactive Grab", CurrentValue = false, Callback = function(v) IsRadioactiveGrab = v end })
MainTab:CreateToggle({ Name = "Fire Grab", CurrentValue = false, Callback = function(v) IsFireGrab = v end })
MainTab:CreateToggle({ Name = "Noclip Grab", CurrentValue = false, Callback = function(v) IsNoclipGrab = v end })
MainTab:CreateToggle({ Name = "Kick Grab (Big FirePart)", CurrentValue = false, Callback = function(v) IsKickGrab = v end })
MainTab:CreateToggle({ Name = "Fire All Spam", CurrentValue = false, Callback = function(v) IsFireAll = v end })
MainTab:CreateToggle({ Name = "Anchor Grab + Highlight", CurrentValue = false, Callback = function(v) IsAnchorGrab = v end })
MainTab:CreateToggle({ Name = "Auto Recover Dropped Parts", CurrentValue = false, Callback = function(v) IsAutoRecover = v end })

SendNotif("Syu_hub Loaded", "Ultimate Edition with Phoenix Features Ready!")
