--[[
    Syu_hub v8.3 | Added Phoenix Unique Features
    Target: Fling Things and People
]]

-- ■■■ Services ■■■
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- ■■■ Variables ■■■
local IsPoison = false
local IsRadioactive = false
local IsFireGrab = false
local IsNoclipGrab = false
local IsKickGrab = false
local IsFireAll = false
local IsAnchorGrab = false
local IsAutoRecover = false

local PoisonParts = Workspace:FindFirstChild("Map") and (function()
    local t = {}
    for _, v in pairs(Workspace.Map:GetDescendants()) do
        if v.Name == "PoisonHurtPart" and v:IsA("Part") then table.insert(t, v) end
    end
    return t
end)() or {}

local PaintParts = Workspace:FindFirstChild("Map") and (function()
    local t = {}
    for _, v in pairs(Workspace.Map:GetDescendants()) do
        if v.Name == "PaintPlayerPart" and v:IsA("Part") then table.insert(t, v) end
    end
    return t
end)() or {}

local GrabbedObjects = {}
local Highlighted = {}

-- ■■■ Utility ■■■
local function Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Syu_hub"; Text = msg; Duration = 3})
end

local function GetGrabPart()
    return Workspace:FindFirstChild("GrabParts") and Workspace.GrabParts:FindFirstChild("GrabPart")
end

local function TriggerGrab(part)
    for _, rem in pairs(ReplicatedStorage:GetDescendants()) do
        if rem:IsA("RemoteEvent") and (string.find(rem.Name, "Grab") or string.find(rem.Name, "Interact")) then
            pcall(function() rem:FireServer(part) end)
        end
    end
end

-- ■■■ Poison / Radioactive / Fire / Noclip Grab Loop ■■■
task.spawn(function()
    while task.wait() do
        local grabPart = GetGrabPart()
        if grabPart then
            local weld = grabPart:FindFirstChild("WeldConstraint")
            if weld and weld.Part1 and weld.Part1.Parent:FindFirstChild("Head") then
                local head = weld.Part1.Parent.Head

                if IsPoison then
                    for _, p in pairs(PoisonParts) do
                        p.Size = Vector3.new(3,3,3)
                        p.Position = head.Position
                        p.Transparency = 1
                    end
                elseif IsRadioactive then
                    for _, p in pairs(PaintParts) do
                        p.Size = Vector3.new(3,3,3)
                        p.Position = head.Position
                        p.Transparency = 1
                    end
                end

                if IsFireGrab then
                    local campfire = LocalPlayer.Character:FindFirstChild("Campfire") or Workspace[LocalPlayer.Name.."SpawnedInToys"]:FindFirstChild("Campfire")
                    if campfire then
                        local fire = campfire:FindFirstChild("FirePlayerPart")
                        if fire then
                            fire.Size = Vector3.new(8,8,8)
                            fire.Position = head.Position
                            task.wait(0.3)
                            fire.Position = Vector3.new(0,-50,0)
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
            -- Reset when not grabbing
            if not IsPoison then
                for _, p in pairs(PoisonParts) do p.Position = Vector3.new(0,-200,0) end
            end
            if not IsRadioactive then
                for _, p in pairs(PaintParts) do p.Position = Vector3.new(0,-200,0) end
            end
        end
    end
end)

-- ■■■ Kick Grab (Add big FirePlayerPart to all players) ■■■
task.spawn(function()
    while task.wait(0.5) do
        if IsKickGrab then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    local fire = hrp:FindFirstChild("FirePlayerPart")
                    if fire then
                        fire.Size = Vector3.new(5,5.5,5)
                    end
                end
            end
        end
    end
end)

-- ■■■ Fire All (Spam Campfire) ■■■
task.spawn(function()
    while task.wait(0.3) do
        if IsFireAll then
            pcall(function()
                local toys = Workspace[LocalPlayer.Name.."SpawnedInToys"]
                if toys then
                    for _, toy in pairs(toys:GetChildren()) do
                        if toy.Name == "Campfire" then toy:Destroy() end
                    end
                end
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("Campfire", Vector3.new(0,0,0), Vector3.new(0,90,0))
            end)
        end
    end
end)

-- ■■■ Anchor Grab + Highlight ■■■
task.spawn(function()
    while task.wait() do
        if IsAnchorGrab then
            local grabPart = GetGrabPart()
            if grabPart then
                local weld = grabPart:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 then
                    local obj = weld.Part1
                    if not table.find(GrabbedObjects, obj) then
                        table.insert(GrabbedObjects, obj)

                        local model = obj:FindFirstAncestorWhichIsA("Model") or obj
                        local hl = Instance.new("Highlight")
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0.5
                        hl.OutlineColor = Color3.new(0,0,1)
                        hl.Parent = model
                        table.insert(Highlighted, hl)

                        local bp = Instance.new("BodyPosition", obj)
                        local bg = Instance.new("BodyGyro", obj)
                        bp.MaxForce = Vector3.new(5e6,5e6,5e6)
                        bg.MaxTorque = Vector3.new(5e6,5e6,5e6)
                    end
                end
            end
        end
    end
end)

-- ■■■ Auto Recover Dropped Parts ■■■
task.spawn(function()
    while task.wait(0.02) do
        if IsAutoRecover and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(GrabbedObjects) do
                if obj and obj.Parent and (obj.Position - hrp.Position).Magnitude <= 30 then
                    local owner = obj:FindFirstChild("PartOwner")
                    if owner and owner.Value == LocalPlayer.Name then
                        TriggerGrab(obj)
                    end
                end
            end
        end
    end
end)

-- ■■■ UI Additions (Add to existing ScrollFrame) ■■■
-- 既存のScrollFrameに追加するボタン/トグルを作成してください

-- Example (Poison Grab Toggle)
local PoisonBtn = Instance.new("TextButton")
PoisonBtn.Size = UDim2.new(1,0,0,40)
PoisonBtn.Text = "Poison Grab (OFF)"
PoisonBtn.BackgroundColor3 = Color3.fromRGB(40,60,40)
PoisonBtn.Parent = ScrollFrame
Instance.new("UICorner", PoisonBtn)

PoisonBtn.MouseButton1Click:Connect(function()
    IsPoison = not IsPoison
    PoisonBtn.Text = "Poison Grab ("..(IsPoison and "ON" or "OFF")..")"
    PoisonBtn.BackgroundColor3 = IsPoison and Color3.fromRGB(150,40,40) or Color3.fromRGB(40,60,40)
end)

-- 同様に他の機能も追加可能（Radioactive, FireGrab, NoclipGrab, KickGrab, FireAll, AnchorGrab, AutoRecover）

Notify("Syu_hub v8.3 | Phoenix Unique Features Added")
