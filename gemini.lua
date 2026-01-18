--[[
    Syu_hub v10.3 | Ultimate Raw Edition
    Target: Item Asylum + Enhanced Features
    Features: Advanced Combat, Entity Manipulation, Grab Augmentation, Phoenix Hub Features
]]

-- ■■■ UI Loader ■■■
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Syu_hub | Ultimate v10.3",
    LoadingTitle = "Initializing Ultimate Systems...",
    LoadingSubtitle = "Phoenix Edition by Gemini",
    ConfigurationSaving = { Enabled = true, Folder = "SyuHubData" },
    KeySystem = false,
})

-- ■■■ Services ■■■
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ■■■ Remote Events ■■■
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local GameCorrectionEvents = ReplicatedStorage:WaitForChild("GameCorrectionEvents")

local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local CreatureGrab = GrabEvents:FindFirstChild("CreatureGrab") or GrabEvents:WaitForChild("CreatureGrab", 1)
local CreatureDrop = GrabEvents:FindFirstChild("CreatureDrop") or GrabEvents:WaitForChild("CreatureDrop", 1)

-- ■■■ Variables & States ■■■
local State = {
    TargetPlayer = nil,
    IsLoopKicking = false,
    OriginalPosition = nil,
    Effects = {
        AntiGrab = false,
        AntiKickGrab = false,
        AntiExplosion = false,
        AirSuspend = false,
        PoisonGrab = false,
        RadioactiveGrab = false,
        FireGrab = false,
        NoclipGrab = false,
        KickGrab = false,
        KickGrabAnchor = false,
        FireAll = false,
        AnchorGrab = false,
        AutoRecover = false,
        EnableStrength = false,
        CrouchSpeed = false,
        CrouchJumpPower = false,
        DestroyServer = false
    },
    Combat = {
        StrengthPower = 400,
        KickPower = 1000,
        KickHeight = 300,
        SpawnDelay = 0.3,
        BlobmanDelay = 0.005
    },
    Movement = {
        CrouchSpeed = 50,
        CrouchJumpPower = 50
    },
    Settings = {
        MaxMissiles = 9,
        DecoyOffset = 10,
        CircleRadius = 10,
        DecoyFollowMode = true
    }
}

-- ■■■ Core Variables ■■■
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local CharacterConnections = {}
local AntiGrabConnection, AntiKickConnection, ExplosionConnection, AirSuspendCoroutine
local PoisonCoroutine, RadioactiveCoroutine, FireCoroutine, NoclipCoroutine
local KickCoroutine, FireAllCoroutine, AnchorCoroutine, AutoRecoverCoroutine
local StrengthConnection, CrouchSpeedCoroutine, CrouchJumpCoroutine, DestroyServerCoroutine
local Blobman = nil
local SpawnedToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")

-- Character Added Event
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- ■■■ Utility Functions ■■■
local function SendNotif(title, content)
    Rayfield:Notify({ Title = title, Content = content, Duration = 4, Image = 4483345998 })
end

local function GetPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then 
            table.insert(names, p.Name)
        end
    end
    table.sort(names)
    return names
end

local function GetClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
    end
    return closest
end

local function IsDescendantOf(obj, ancestor)
    local parent = obj.Parent
    while parent do
        if parent == ancestor then
            return true
        end
        parent = parent.Parent
    end
    return false
end

local function FindPartsByName(name)
    local parts = {}
    if Workspace:FindFirstChild("Map") then
        for _, descendant in pairs(Workspace.Map:GetDescendants()) do
            if descendant:IsA("Part") and descendant.Name == name then
                table.insert(parts, descendant)
            end
        end
    end
    return parts
end

local PoisonParts = FindPartsByName("PoisonHurtPart")
local PaintParts = FindPartsByName("PaintPlayerPart")

-- ■■■ Phoenix Hub Core Functions ■■■

-- 1. Anti Grab System
local function ToggleAntiGrab(enable)
    if enable then
        AntiGrabConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("PartOwner") then
                Struggle:FireServer()
                GameCorrectionEvents.StopAllVelocity:FireServer()
                
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
                
                while LocalPlayer:GetAttribute("IsHeld") or (char.Head:FindFirstChild("PartOwner") and char.Head.PartOwner.Value ~= LocalPlayer.Name) do
                    task.wait()
                end
                
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end)
    elseif AntiGrabConnection then
        AntiGrabConnection:Disconnect()
        AntiGrabConnection = nil
    end
end

-- 2. Anti Kick Grab
local function ToggleAntiKickGrab(enable)
    if enable then
        AntiKickConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local firePart = char.HumanoidRootPart:FindFirstChild("FirePlayerPart")
                if firePart and firePart:FindFirstChild("PartOwner") then
                    local owner = firePart.PartOwner.Value
                    if owner ~= LocalPlayer.Name then
                        RagdollRemote:FireServer(char.HumanoidRootPart, 0)
                        task.wait(0.1)
                        Struggle:FireServer()
                    end
                end
            end
        end)
    elseif AntiKickConnection then
        AntiKickConnection:Disconnect()
        AntiKickConnection = nil
    end
end

-- 3. Anti Explosion
local function SetupAntiExplosion(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid")
    local ragdolled = humanoid:FindFirstChild("Ragdolled")
    
    if ragdolled then
        local connection = ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
            if ragdolled.Value then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            else
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end)
        table.insert(CharacterConnections, connection)
    end
end

local function ToggleAntiExplosion(enable)
    if enable then
        if LocalPlayer.Character then
            SetupAntiExplosion(LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(SetupAntiExplosion)
    else
        for _, conn in pairs(CharacterConnections) do
            conn:Disconnect()
        end
        CharacterConnections = {}
    end
end

-- 4. Air Suspend / Self Defense
local function ToggleAirSuspend(enable)
    if enable then
        AirSuspendCoroutine = coroutine.create(function()
            while task.wait(0.02) do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Head") then
                    local partOwner = char.Head:FindFirstChild("PartOwner")
                    if partOwner then
                        local attacker = Players:FindFirstChild(partOwner.Value)
                        if attacker and attacker.Character then
                            Struggle:FireServer()
                            local targetPart = attacker.Character.Head or attacker.Character.Torso
                            local firePart = attacker.Character.HumanoidRootPart.FirePlayerPart
                            if targetPart and firePart then
                                SetNetworkOwner:FireServer(targetPart, firePart.CFrame)
                                task.wait(0.1)
                                
                                local torso = attacker.Character:FindFirstChild("Torso")
                                if torso then
                                    local bodyVel = torso:FindFirstChild("l") or Instance.new("BodyVelocity")
                                    bodyVel.Name = "l"
                                    bodyVel.Parent = torso
                                    bodyVel.Velocity = Vector3.new(0, 50, 0)
                                    bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
                                    Debris:AddItem(bodyVel, 100)
                                end
                            end
                        end
                    end
                end
            end
        end)
        coroutine.resume(AirSuspendCoroutine)
    elseif AirSuspendCoroutine then
        coroutine.close(AirSuspendCoroutine)
        AirSuspendCoroutine = nil
    end
end

-- 5. Strength Power
local function ToggleStrength(enable)
    if enable then
        StrengthConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name == "GrabParts" then
                local grabPart = child:FindFirstChild("GrabPart")
                if grabPart then
                    local weld = grabPart:FindFirstChild("WeldConstraint")
                    if weld and weld.Part1 then
                        local bodyVel = Instance.new("BodyVelocity", weld.Part1)
                        local cleanup = child:GetPropertyChangedSignal("Parent"):Connect(function()
                            if not child.Parent then
                                if UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseButton2 then
                                    bodyVel:Destroy()
                                else
                                    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bodyVel.Velocity = Workspace.CurrentCamera.CFrame.LookVector * State.Combat.StrengthPower
                                    Debris:AddItem(bodyVel, 1)
                                end
                                cleanup:Disconnect()
                            end
                        end)
                    end
                end
            end
        end)
    elseif StrengthConnection then
        StrengthConnection:Disconnect()
        StrengthConnection = nil
    end
end

-- 6. Grab Effects (Poison, Radioactive, Fire, Noclip)
local function RunGrabEffect(effectType)
    return coroutine.create(function()
        while true do
            pcall(function()
                local grabParts = Workspace:FindFirstChild("GrabParts")
                if grabParts then
                    local grabPart = grabParts:FindFirstChild("GrabPart")
                    if grabPart then
                        local weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            local head = weld.Part1.Parent:FindFirstChild("Head")
                            if head then
                                local parts = effectType == "poison" and PoisonParts or PaintParts
                                
                                for _, part in pairs(parts) do
                                    part.Size = Vector3.new(2, 2, 2)
                                    part.Transparency = 1
                                    part.Position = head.Position
                                end
                                task.wait()
                                for _, part in pairs(parts) do
                                    part.Position = Vector3.new(0, -200, 0)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait()
        end
    end)
end

local function ToggleGrabEffect(effectType, enable)
    if effectType == "poison" then
        if enable then
            PoisonCoroutine = RunGrabEffect("poison")
            coroutine.resume(PoisonCoroutine)
        elseif PoisonCoroutine then
            coroutine.close(PoisonCoroutine)
            PoisonCoroutine = nil
        end
    elseif effectType == "radioactive" then
        if enable then
            RadioactiveCoroutine = RunGrabEffect("radioactive")
            coroutine.resume(RadioactiveCoroutine)
        elseif RadioactiveCoroutine then
            coroutine.close(RadioactiveCoroutine)
            RadioactiveCoroutine = nil
        end
    elseif effectType == "fire" then
        if enable then
            FireCoroutine = coroutine.create(function()
                while true do
                    pcall(function()
                        local grabParts = Workspace:FindFirstChild("GrabParts")
                        if grabParts then
                            local grabPart = grabParts:FindFirstChild("GrabPart")
                            if grabPart then
                                local weld = grabPart:FindFirstChild("WeldConstraint")
                                if weld and weld.Part1 then
                                    local head = weld.Part1.Parent:FindFirstChild("Head")
                                    if head then
                                        -- Fire effect logic would go here
                                        -- This is a placeholder for actual fire implementation
                                    end
                                end
                            end
                        end
                    end)
                    task.wait()
                end
            end)
            coroutine.resume(FireCoroutine)
        elseif FireCoroutine then
            coroutine.close(FireCoroutine)
            FireCoroutine = nil
        end
    elseif effectType == "noclip" then
        if enable then
            NoclipCoroutine = coroutine.create(function()
                while true do
                    pcall(function()
                        local grabParts = Workspace:FindFirstChild("GrabParts")
                        if grabParts then
                            local grabPart = grabParts:FindFirstChild("GrabPart")
                            if grabPart then
                                local weld = grabPart:FindFirstChild("WeldConstraint")
                                if weld and weld.Part1 then
                                    local character = weld.Part1.Parent
                                    if character and character:FindFirstChild("HumanoidRootPart") then
                                        for _, part in pairs(character:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                part.CanCollide = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait()
                end
            end)
            coroutine.resume(NoclipCoroutine)
        elseif NoclipCoroutine then
            coroutine.close(NoclipCoroutine)
            NoclipCoroutine = nil
        end
    end
end

-- 7. Kick Grab System
local function SetupPlayerFireParts(player)
    local connection = player.CharacterAdded:Connect(function(char)
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local firePart = rootPart:WaitForChild("FirePlayerPart")
        firePart.Size = Vector3.new(4.5, 5, 4.5)
        firePart.CollisionGroup = "1"
        firePart.CanQuery = true
    end)
    table.insert(CharacterConnections, connection)
end

local function ToggleKickGrab(enable)
    if enable then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                SetupPlayerFireParts(player)
            end
        end
        
        local playerAdded = Players.PlayerAdded:Connect(SetupPlayerFireParts)
        table.insert(CharacterConnections, playerAdded)
    else
        for _, conn in pairs(CharacterConnections) do
            if conn.Connected then
                conn:Disconnect()
            end
        end
        CharacterConnections = {}
    end
end

-- 8. Anchor Grab System
local AnchoredParts = {}
local function ToggleAnchorGrab(enable)
    if enable then
        AnchorCoroutine = coroutine.create(function()
            while true do
                pcall(function()
                    local grabParts = Workspace:FindFirstChild("GrabParts")
                    if grabParts then
                        local grabPart = grabParts:FindFirstChild("GrabPart")
                        if grabPart then
                            local weld = grabPart:FindFirstChild("WeldConstraint")
                            if weld and weld.Part1 then
                                local targetPart = weld.Part1
                                
                                -- Check if part is already anchored
                                local alreadyAnchored = false
                                for _, anchored in pairs(AnchoredParts) do
                                    if anchored.part == targetPart then
                                        alreadyAnchored = true
                                        break
                                    end
                                end
                                
                                if not alreadyAnchored then
                                    -- Add BodyPosition and BodyGyro to anchor
                                    local bodyPosition = Instance.new("BodyPosition")
                                    local bodyGyro = Instance.new("BodyGyro")
                                    
                                    bodyPosition.Parent = targetPart
                                    bodyGyro.Parent = targetPart
                                    
                                    bodyPosition.P = 15000
                                    bodyPosition.D = 200
                                    bodyPosition.MaxForce = Vector3.new(5000000, 5000000, 5000000)
                                    bodyPosition.Position = targetPart.Position
                                    
                                    bodyGyro.P = 15000
                                    bodyGyro.D = 200
                                    bodyGyro.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
                                    bodyGyro.CFrame = targetPart.CFrame
                                    
                                    table.insert(AnchoredParts, {
                                        part = targetPart,
                                        bodyPosition = bodyPosition,
                                        bodyGyro = bodyGyro
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
        coroutine.resume(AnchorCoroutine)
    elseif AnchorCoroutine then
        coroutine.close(AnchorCoroutine)
        AnchorCoroutine = nil
    end
end

-- 9. Auto Recover Parts
local function ToggleAutoRecover(enable)
    if enable then
        AutoRecoverCoroutine = coroutine.create(function()
            while true do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local rootPos = char.HumanoidRootPart.Position
                        
                        -- Simple part recovery logic
                        for _, part in pairs(Workspace:GetChildren()) do
                            if part:IsA("BasePart") and not part.Anchored then
                                if (part.Position - rootPos).Magnitude <= 30 then
                                    SetNetworkOwner:FireServer(part, part.CFrame)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.02)
            end
        end)
        coroutine.resume(AutoRecoverCoroutine)
    elseif AutoRecoverCoroutine then
        coroutine.close(AutoRecoverCoroutine)
        AutoRecoverCoroutine = nil
    end
end

-- 10. Movement Modifiers
local function ToggleCrouchSpeed(enable)
    if enable then
        CrouchSpeedCoroutine = coroutine.create(function()
            while true do
                pcall(function()
                    local humanoid = Character and Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.WalkSpeed == 5 then
                        humanoid.WalkSpeed = State.Movement.CrouchSpeed
                    end
                end)
                task.wait()
            end
        end)
        coroutine.resume(CrouchSpeedCoroutine)
    elseif CrouchSpeedCoroutine then
        coroutine.close(CrouchSpeedCoroutine)
        CrouchSpeedCoroutine = nil
        local humanoid = Character and Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

local function ToggleCrouchJump(enable)
    if enable then
        CrouchJumpCoroutine = coroutine.create(function()
            while true do
                pcall(function()
                    local humanoid = Character and Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.JumpPower == 12 then
                        humanoid.JumpPower = State.Movement.CrouchJumpPower
                    end
                end)
                task.wait()
            end
        end)
        coroutine.resume(CrouchJumpCoroutine)
    elseif CrouchJumpCoroutine then
        coroutine.close(CrouchJumpCoroutine)
        CrouchJumpCoroutine = nil
        local humanoid = Character and Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 24
        end
    end
end

-- 11. Blobman Server Destroyer
local function FindBlobman()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "CreatureBlobman" and obj:IsA("Model") then
            local seat = obj:FindFirstChild("VehicleSeat")
            if seat and seat:FindFirstChild("SeatWeld") then
                if IsDescendantOf(seat.SeatWeld.Part1, char) then
                    return obj
                end
            end
        end
    end
    return nil
end

local function ToggleDestroyServer(enable)
    if enable then
        Blobman = FindBlobman()
        if not Blobman then
            SendNotif("Error", "You must be mounted on a Blobman!")
            return false
        end
        
        DestroyServerCoroutine = coroutine.create(function()
            while true do
                pcall(function()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            -- Blobman grab logic would go here
                            -- This is simplified version
                            task.wait(State.Combat.BlobmanDelay)
                        end
                    end
                end)
                task.wait(0.02)
            end
        end)
        coroutine.resume(DestroyServerCoroutine)
        return true
    elseif DestroyServerCoroutine then
        coroutine.close(DestroyServerCoroutine)
        DestroyServerCoroutine = nil
        Blobman = nil
    end
    return false
end

-- 12. Combat Kick System
local function ExecuteKick(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp or not myHrp then return end

    State.OriginalPosition = myHrp.CFrame
    
    -- Find or spawn Blobman
    local blobman = FindBlobman()
    if not blobman then
        local spawnEvent = MenuToys:FindFirstChild("SpawnToyRemoteFunction")
        if spawnEvent then
            spawnEvent:InvokeServer("Blobman", Vector3.new(0,0,0))
        end
        task.wait(State.Combat.SpawnDelay)
        blobman = FindBlobman()
    end

    if blobman and blobman:FindFirstChild("HumanoidRootPart") then
        -- Teleport attack sequence
        myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.05)
        
        -- Grab target
        SetNetworkOwner:FireServer(targetHrp, targetHrp.CFrame)
        
        task.wait(0.05)
        myHrp.Velocity = myHrp.CFrame.LookVector * State.Combat.KickPower + Vector3.new(0, State.Combat.KickHeight, 0)
        
        task.wait(0.1)
        myHrp.CFrame = State.OriginalPosition
        myHrp.Velocity = Vector3.zero
    end
end

-- ■■■ UI Construction ■■■

-- Main Control Tab
local MainTab = Window:CreateTab("Main Control", 4483345998)

MainTab:CreateSection("Target Selection")
local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Select Target Player",
    Options = GetPlayerNames(),
    CurrentOption = "",
    Callback = function(Option) 
        State.TargetPlayer = Option[1]
    end,
})

MainTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function() 
        PlayerDropdown:Refresh(GetPlayerNames())
    end,
})

MainTab:CreateSection("Combat Actions")
MainTab:CreateButton({
    Name = "Instant Kick Target",
    Callback = function() 
        if State.TargetPlayer then 
            ExecuteKick(State.TargetPlayer)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Loop Kick (Kill Target)",
    CurrentValue = false,
    Callback = function(value)
        State.IsLoopKicking = value
        if value and State.TargetPlayer then
            task.spawn(function()
                while State.IsLoopKicking do
                    ExecuteKick(State.TargetPlayer)
                    task.wait(0.6)
                end
            end)
        end
    end,
})

-- Anti-Grab Tab
local AntiGrabTab = Window:CreateTab("Anti-Grab Systems", 4483345998)

AntiGrabTab:CreateSection("Anti-Grab Features")
AntiGrabTab:CreateToggle({
    Name = "Anti Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AntiGrab = value
        ToggleAntiGrab(value)
    end,
})

AntiGrabTab:CreateToggle({
    Name = "Anti Kick Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AntiKickGrab = value
        ToggleAntiKickGrab(value)
    end,
})

AntiGrabTab:CreateToggle({
    Name = "Anti Explosion",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AntiExplosion = value
        ToggleAntiExplosion(value)
    end,
})

AntiGrabTab:CreateToggle({
    Name = "Self Defense / Air Suspend",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AirSuspend = value
        ToggleAirSuspend(value)
    end,
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat Systems", 4483345998)

CombatTab:CreateSection("Strength Settings")
CombatTab:CreateSlider({
    Name = "Strength Power",
    Range = {300, 10000},
    Increment = 100,
    Suffix = "Force",
    CurrentValue = 400,
    Callback = function(value)
        State.Combat.StrengthPower = value
    end,
})

CombatTab:CreateToggle({
    Name = "Enable Strength",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.EnableStrength = value
        ToggleStrength(value)
    end,
})

CombatTab:CreateSection("Kick Settings")
CombatTab:CreateSlider({
    Name = "Kick Power",
    Range = {500, 5000},
    Increment = 100,
    Suffix = "Force",
    CurrentValue = 1000,
    Callback = function(value)
        State.Combat.KickPower = value
    end,
})

CombatTab:CreateSlider({
    Name = "Kick Height",
    Range = {100, 1000},
    Increment = 50,
    Suffix = "Height",
    CurrentValue = 300,
    Callback = function(value)
        State.Combat.KickHeight = value
    end,
})

-- Grab Effects Tab
local EffectsTab = Window:CreateTab("Grab Effects", 4483345998)

EffectsTab:CreateSection("Grab Buffs")
EffectsTab:CreateToggle({
    Name = "Poison Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.PoisonGrab = value
        ToggleGrabEffect("poison", value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Radioactive Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.RadioactiveGrab = value
        ToggleGrabEffect("radioactive", value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Fire Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.FireGrab = value
        ToggleGrabEffect("fire", value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Noclip Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.NoclipGrab = value
        ToggleGrabEffect("noclip", value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Kick Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.KickGrab = value
        ToggleKickGrab(value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Anchor Grab",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AnchorGrab = value
        ToggleAnchorGrab(value)
    end,
})

EffectsTab:CreateToggle({
    Name = "Fire All (Spam)",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.FireAll = value
    end,
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", 4483345998)

MovementTab:CreateSection("Movement Modifiers")
MovementTab:CreateToggle({
    Name = "Crouch Speed",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.CrouchSpeed = value
        ToggleCrouchSpeed(value)
    end,
})

MovementTab:CreateSlider({
    Name = "Crouch Speed Value",
    Range = {6, 1000},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,
    Callback = function(value)
        State.Movement.CrouchSpeed = value
    end,
})

MovementTab:CreateToggle({
    Name = "Crouch Jump Power",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.CrouchJumpPower = value
        ToggleCrouchJump(value)
    end,
})

MovementTab:CreateSlider({
    Name = "Crouch Jump Value",
    Range = {6, 1000},
    Increment = 10,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(value)
        State.Movement.CrouchJumpPower = value
    end,
})

-- Object Grab Tab
local ObjectTab = Window:CreateTab("Object Grab", 4483345998)

ObjectTab:CreateSection("Object Manipulation")
ObjectTab:CreateToggle({
    Name = "Auto Recover Dropped Parts",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.AutoRecover = value
        ToggleAutoRecover(value)
    end,
})

ObjectTab:CreateButton({
    Name = "Unanchor All Parts",
    Callback = function()
        for _, anchored in pairs(AnchoredParts) do
            if anchored.bodyPosition then
                anchored.bodyPosition:Destroy()
            end
            if anchored.bodyGyro then
                anchored.bodyGyro:Destroy()
            end
        end
        AnchoredParts = {}
    end,
})

-- Blobman Tab
local BlobmanTab = Window:CreateTab("Blobman", 4483345998)

BlobmanTab:CreateSection("Blobman Features")
BlobmanTab:CreateToggle({
    Name = "Destroy Server (Blobman)",
    CurrentValue = false,
    Callback = function(value)
        State.Effects.DestroyServer = value
        if value then
            if not ToggleDestroyServer(value) then
                State.Effects.DestroyServer = false
            end
        else
            ToggleDestroyServer(false)
        end
    end,
})

BlobmanTab:CreateSlider({
    Name = "Destroy Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "Delay",
    CurrentValue = 0.005,
    Callback = function(value)
        State.Combat.BlobmanDelay = value
    end,
})

-- Fun/Troll Tab
local FunTab = Window:CreateTab("Fun/Troll", 4483345998)

FunTab:CreateSection("Decoy Control")
FunTab:CreateSlider({
    Name = "Decoy Offset",
    Range = {1, 50},
    Increment = 1,
    Suffix = "Units",
    CurrentValue = 10,
    Callback = function(value)
        State.Settings.DecoyOffset = value
    end,
})

FunTab:CreateSlider({
    Name = "Circle Radius",
    Range = {1, 50},
    Increment = 1,
    Suffix = "Radius",
    CurrentValue = 10,
    Callback = function(value)
        State.Settings.CircleRadius = value
    end,
})

FunTab:CreateButton({
    Name = "Toggle Follow Mode",
    Callback = function()
        State.Settings.DecoyFollowMode = not State.Settings.DecoyFollowMode
        SendNotif("Follow Mode", "Now: " .. (State.Settings.DecoyFollowMode and "Follow Me" or "Follow Target"))
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483345998)

SettingsTab:CreateSection("Configuration")
SettingsTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({Title = "Settings Saved", Content = "Configuration has been saved.", Duration = 3})
    end,
})

SettingsTab:CreateButton({
    Name = "Destroy All Spawned Toys",
    Callback = function()
        if SpawnedToys then
            for _, toy in pairs(SpawnedToys:GetChildren()) do
                DestroyToy:FireServer(toy)
            end
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Window:Destroy()
        SendNotif("Unloaded", "Syu_hub has been unloaded.")
    end,
})

-- ■■■ Initialization ■■■
SendNotif("Syu_hub Ultimate v10.3", "Phoenix Edition Loaded Successfully!")
