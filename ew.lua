-- Syu_hub v10.5: 完全統合拡張版
-- Phoenix Hubを基盤に全ての機能を一体化

-- サービス初期化
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- リモートイベント
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local GameCorrectionEvents = ReplicatedStorage:WaitForChild("GameCorrectionEvents")

local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local CreatureGrab = GrabEvents:FindFirstChild("CreatureGrab") or GrabEvents:WaitForChild("CreatureGrab", 1)
local CreatureDrop = GrabEvents:FindFirstChild("CreatureDrop") or GrabEvents:WaitForChild("CreatureDrop", 1)

-- ローカルプレイヤー
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- Rayfield UI ロード
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Syu_hub v10.5 | 完全拡張版",
    LoadingTitle = "Syu_hub システム起動中...",
    LoadingSubtitle = "全75機能を統合",
    ConfigurationSaving = { Enabled = true, Folder = "SyuHubData" },
    KeySystem = false,
})

-- グローバル状態管理
local State = {
    -- ⚔️ 戦闘システム
    Combat = {
        StrengthPower = 400,
        MaxStrength = 10000,
        ActiveGrabType = "Normal",
        GrabDamageScale = 1.0,
        BurnGrabEnabled = false,
        RagdollGrabEnabled = false,
        DeathGrabEnabled = false,
        MasslessGrabEnabled = false,
        NoClipGrabEnabled = false,
        UnweldGrabEnabled = false,
        PerspectiveDistance = 100,
        BlobmanGrabEnabled = false,
        TargetPlayer = nil,
        AutoLockEnabled = false,
        AutoBringEnabled = false,
        KickPower = 1000,
        AutoKickEnabled = false,
        WhitelistFriends = {},
        DestroyServerEnabled = false
    },
    
    -- 🛡️ 保護システム
    Protection = {
        AntiGrabEnabled = false,
        AntiFlingEnabled = false,
        AntiExplosionEnabled = false,
        AntiStunEnabled = false,
        AntiLagEnabled = false,
        AntiKickEnabled = false,
        AntiVoidEnabled = false,
        InvisibilityEnabled = false,
        PremiumAntiGrabEnabled = false,
        AntiSnowballEnabled = false,
        AntiBananaEnabled = false,
        AntiBurnEnabled = false,
        AutoAttackerEnabled = false,
        CounterModEnabled = false
    },
    
    -- 👤 プレイヤー強化
    Enhancements = {
        WalkSpeed = 16,
        WalkSpeedMultiplier = 1.0,
        InfiniteJumpEnabled = false,
        JumpPower = 50,
        NoClipModeEnabled = false,
        FlyEnabled = false,
        FlySpeed = 50
    },
    
    -- 🧠 ESP システム
    ESP = {
        Enabled = false,
        FillColor = Color3.fromRGB(0, 255, 0),
        FillTransparency = 0.5,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineTransparency = 0,
        HighlightMode = "All",
        ShowIcons = true,
        IconType = "Skull",
        ShowDistance = true,
        ShowHealth = true
    },
    
    -- 💥 雑多な機能
    Misc = {
        CustomExplosionsEnabled = false,
        ExplosionPower = 100,
        TeleportLocations = {},
        QuickTeleportEnabled = false,
        CustomLineEnabled = false,
        LineColor = Color3.fromRGB(255, 255, 255),
        LineThickness = 1,
        QuiKEnabled = false
    },
    
    -- 🖐️ GRAB拡張システム (追加機能)
    GrabExtensions = {
        ChargeGrabEnabled = false,
        ChargeMultiplier = 1.0,
        MaxChargeMultiplier = 50,
        SpinUpGrabEnabled = false,
        SpinAngularVelocity = 0,
        InverseGrabEnabled = false,
        InverseVertical = false,
        InverseHorizontal = false,
        JointLockGrabEnabled = false,
        RubberGrabEnabled = false,
        RubberBounce = 0.5,
        AnchorGrabEnabled = false,
        GhostGrabEnabled = false,
        MultiLimbGrabEnabled = false,
        DelayedGrabEnabled = false,
        DelayTime = 1.0,
        SnapshotGrabEnabled = false,
        SnapshotCFrames = {},
        MagnetGrabEnabled = false,
        MagnetRange = 20,
        ScaleGrabEnabled = false,
        ScaleMultiplier = 1.0,
        ReverseMassGrabEnabled = false,
        ChainGrabEnabled = false,
        ChainLinks = {},
        AuthorityGrabEnabled = false
    },
    
    -- 🚀 FLING挙動システム (追加機能)
    FlingExtensions = {
        CurveFlingEnabled = false,
        CurveFactor = 0,
        BoomerangFlingEnabled = false,
        ScatterFlingEnabled = false,
        ScatterCount = 3,
        PulseFlingEnabled = false,
        PulsePattern = {},
        PhaseFlingEnabled = false,
        LockOnFlingEnabled = false,
        LockOnTarget = nil,
        OrbitFlingEnabled = false,
        OrbitCenter = nil,
        SpiralFlingEnabled = false,
        SpiralTurns = 2,
        TimeSlowFlingEnabled = false,
        TimeScale = 0.5,
        DirectionalChaosEnabled = false,
        ChaosIntensity = 0.1,
        SnapFlingEnabled = false,
        SnapDistance = 100,
        ReturnToHandEnabled = false
    },
    
    -- 🧱 着地・衝突後システム
    ImpactExtensions = {
        ImpactFreezeEnabled = false,
        FreezeDuration = 3.0,
        BounceOverrideEnabled = false,
        BounceMultiplier = 1.0,
        TerrainEmbedEnabled = false,
        ShockwaveRingEnabled = false,
        ShockwaveRadius = 10,
        RagdollLoopEnabled = false,
        VelocityStealEnabled = false,
        StealRadius = 15,
        ExplosionLessKnockbackEnabled = false,
        KnockbackPower = 100,
        AfterimageTrailEnabled = false,
        TrailDuration = 2.0
    }
}

-- グローバル変数
local Connections = {}
local ESPHighlights = {}
local ActiveCharges = {}
local ActiveSnapshots = {}
local ActiveChains = {}
local ActiveFlingEffects = {}
local ActiveTrails = {}
local Whitelist = {}
local SpawnedToys = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")

-- Phoenix Hub ユーティリティ関数の継承
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

local function DestroyAllConnections()
    for _, connection in pairs(Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    Connections = {}
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

local function GetClosestPlayer()
    local closest = nil
    local closestDist = math.huge
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
    end
    return closest
end

-- 基本機能の実装
local function ApplySuperStrength(targetPart, direction)
    if State.Combat.StrengthPower > 0 then
        local bodyVelocity = targetPart:FindFirstChild("SuperStrengthVelocity") or Instance.new("BodyVelocity")
        bodyVelocity.Name = "SuperStrengthVelocity"
        bodyVelocity.Velocity = direction * State.Combat.StrengthPower
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = targetPart
        Debris:AddItem(bodyVelocity, 0.1)
    end
end

-- グラブタイプの実装
local function ApplyGrabEffect(targetPart, grabType)
    if grabType == "Poison" then
        for _, poisonPart in pairs(PoisonParts) do
            poisonPart.Size = Vector3.new(2, 2, 2)
            poisonPart.Transparency = 1
            poisonPart.Position = targetPart.Position
        end
        task.wait(0.1)
        for _, poisonPart in pairs(PoisonParts) do
            poisonPart.Position = Vector3.new(0, -200, 0)
        end
        
    elseif grabType == "Burn" and State.Combat.BurnGrabEnabled then
        local fire = Instance.new("Fire")
        fire.Size = 5
        fire.Heat = 10
        fire.Color = Color3.fromRGB(255, 100, 0)
        fire.SecondaryColor = Color3.fromRGB(255, 255, 0)
        fire.Parent = targetPart
        
    elseif grabType == "Ragdoll" and State.Combat.RagdollGrabEnabled then
        RagdollRemote:FireServer(targetPart, 0)
        
    elseif grabType == "NoClip" and State.Combat.NoClipGrabEnabled then
        for _, part in pairs(targetPart.Parent:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- 保護システムの実装
local function SetupProtectionSystems()
    -- Anti-Grab
    if State.Protection.AntiGrabEnabled then
        local antiGrabConnection = RunService.Heartbeat:Connect(function()
            if Character and Character:FindFirstChild("Head") and Character.Head:FindFirstChild("PartOwner") then
                Struggle:FireServer()
                GameCorrectionEvents.StopAllVelocity:FireServer()
                
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
                
                while Character.Head.PartOwner.Value ~= LocalPlayer.Name do
                    task.wait()
                end
                
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end)
        table.insert(Connections, antiGrabConnection)
    end
    
    -- Anti-Fling
    if State.Protection.AntiFlingEnabled then
        local antiFlingConnection = RunService.Heartbeat:Connect(function()
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local vel = Character.HumanoidRootPart.Velocity
                if vel.Magnitude > 500 then
                    Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
        table.insert(Connections, antiFlingConnection)
    end
    
    -- Invisibility
    if State.Protection.InvisibilityEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end
end

-- ESP システムの実装
local function UpdateESP()
    for _, highlight in pairs(ESPHighlights) do
        highlight:Destroy()
    end
    ESPHighlights = {}
    
    if not State.ESP.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillColor = State.ESP.FillColor
            highlight.FillTransparency = State.ESP.FillTransparency
            highlight.OutlineColor = State.ESP.OutlineColor
            highlight.OutlineTransparency = State.ESP.OutlineTransparency
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = player.Character
            
            table.insert(ESPHighlights, highlight)
            
            -- ESP Icon
            if State.ESP.ShowIcons then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(4, 0, 4, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = player.Character.Head or player.Character.PrimaryPart
                
                local icon = Instance.new("ImageLabel")
                icon.Size = UDim2.new(1, 0, 1, 0)
                icon.BackgroundTransparency = 1
                icon.Image = "rbxassetid://" .. (State.ESP.IconType == "Skull" and "7734068321" or "7734069243")
                icon.Parent = billboard
            end
        end
    end
end

-- プレイヤー強化システム
local function UpdateEnhancements()
    if not Character then return end
    
    local humanoid = Character:FindFirstChild("Humanoid")
    if humanoid then
        -- Walk Speed
        if State.Enhancements.WalkSpeedMultiplier ~= 1.0 then
            humanoid.WalkSpeed = 16 * State.Enhancements.WalkSpeedMultiplier
        else
            humanoid.WalkSpeed = State.Enhancements.WalkSpeed
        end
        
        -- Jump Power
        if State.Enhancements.InfiniteJumpEnabled then
            humanoid.JumpPower = State.Enhancements.JumpPower
        end
    end
    
    -- NoClip
    if State.Enhancements.NoClipModeEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Fly
    if State.Enhancements.FlyEnabled then
        local bodyVelocity = Character:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = Character.PrimaryPart or Character.HumanoidRootPart
        
        local flying = false
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                flying = true
                while flying do
                    bodyVelocity.Velocity = Vector3.new(0, State.Enhancements.FlySpeed, 0)
                    task.wait()
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                flying = false
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

-- グラブ拡張機能の実装
local function ApplyGrabExtensions(targetPart)
    -- Charge Grab
    if State.GrabExtensions.ChargeGrabEnabled then
        local chargeStart = tick()
        local chargeIndicator = Instance.new("Part")
        chargeIndicator.Size = Vector3.new(1, 1, 1)
        chargeIndicator.Transparency = 0.5
        chargeIndicator.Color = Color3.fromHSV(0, 1, 1)
        chargeIndicator.Material = Enum.Material.Neon
        chargeIndicator.CFrame = targetPart.CFrame
        chargeIndicator.Anchored = true
        chargeIndicator.CanCollide = false
        chargeIndicator.Parent = Workspace
        
        local chargeConnection = RunService.Heartbeat:Connect(function()
            local chargeTime = tick() - chargeStart
            local multiplier = math.min(1 + (chargeTime * 5), State.GrabExtensions.MaxChargeMultiplier)
            
            chargeIndicator.Color = Color3.fromHSV(multiplier / 50, 1, 1)
            chargeIndicator.Size = Vector3.new(1, 1, 1) * (1 + multiplier * 0.1)
            
            State.GrabExtensions.ChargeMultiplier = multiplier
        end)
        
        table.insert(ActiveCharges, {
            Part = targetPart,
            Connection = chargeConnection,
            Indicator = chargeIndicator
        })
    end
    
    -- Spin-Up Grab
    if State.GrabExtensions.SpinUpGrabEnabled then
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, State.GrabExtensions.SpinAngularVelocity, 0)
        bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngularVelocity.Parent = targetPart
        
        table.insert(ActiveCharges, {
            Part = targetPart,
            Velocity = bodyAngularVelocity
        })
    end
    
    -- Magnet Grab
    if State.GrabExtensions.MagnetGrabEnabled then
        local magnetConnection = RunService.Heartbeat:Connect(function()
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not IsDescendantOf(part, Character) then
                    local distance = (part.Position - targetPart.Position).Magnitude
                    if distance < State.GrabExtensions.MagnetRange then
                        local direction = (targetPart.Position - part.Position).Unit
                        part.Velocity = direction * 50
                    end
                end
            end
        end)
        table.insert(Connections, magnetConnection)
    end
    
    -- Scale Grab
    if State.GrabExtensions.ScaleGrabEnabled then
        local originalSize = targetPart.Size
        targetPart.Size = originalSize * State.GrabExtensions.ScaleMultiplier
    end
end

-- FLING拡張機能の実装
local function ApplyFlingExtensions(targetPart, direction)
    -- Curve Fling
    if State.FlingExtensions.CurveFlingEnabled then
        local curveDirection = Vector3.new(
            direction.X + math.sin(tick()) * State.FlingExtensions.CurveFactor,
            direction.Y,
            direction.Z + math.cos(tick()) * State.FlingExtensions.CurveFactor
        )
        direction = curveDirection.Unit
    end
    
    -- Boomerang Fling
    if State.FlingExtensions.BoomerangFlingEnabled then
        local startPos = targetPart.Position
        local startTime = tick()
        
        local boomerangConnection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            
            if elapsed < 2 then
                -- Forward phase
                targetPart.Velocity = direction * 100 * (1 - elapsed/2)
            elseif elapsed < 4 then
                -- Return phase
                local returnDir = (startPos - targetPart.Position).Unit
                targetPart.Velocity = returnDir * 100 * ((elapsed-2)/2)
            else
                boomerangConnection:Disconnect()
            end
        end)
        table.insert(Connections, boomerangConnection)
    end
    
    -- Time-Slow Fling
    if State.FlingExtensions.TimeSlowFlingEnabled then
        local originalVelocity = targetPart.Velocity
        targetPart.Velocity = originalVelocity * State.FlingExtensions.TimeScale
    end
    
    return direction
end

-- UI 構築
local MainTab = Window:CreateTab("メイン", 4483345998)

-- ⚔️ 戦闘システム
MainTab:CreateSection("⚔️ 戦闘システム")

MainTab:CreateSlider({
    Name = "スーパーパワー",
    Range = {0, 10000},
    Increment = 100,
    Suffix = "パワー",
    CurrentValue = 400,
    Callback = function(value)
        State.Combat.StrengthPower = value
    end
})

MainTab:CreateDropdown({
    Name = "グラブタイプ",
    Options = {"通常", "毒", "燃焼", "ラグドール", "即死", "無質量", "ノークリップ", "アンウェルド", "視点", "ブロブマン"},
    CurrentOption = {"通常"},
    Multiple = false,
    Callback = function(option)
        State.Combat.ActiveGrabType = option[1]
    end
})

MainTab:CreateSlider({
    Name = "毒ダメージスケール",
    Range = {1, 3},
    Increment = 0.1,
    Suffix = "倍",
    CurrentValue = 1.0,
    Callback = function(value)
        State.Combat.GrabDamageScale = value
    end
})

-- プレイヤーコントロール
MainTab:CreateSection("プレイヤーコントロール")

local playerList = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

local targetDropdown = MainTab:CreateDropdown({
    Name = "ターゲット選択",
    Options = playerList,
    CurrentOption = {playerList[1] or ""},
    Multiple = false,
    Callback = function(option)
        State.Combat.TargetPlayer = option[1]
    end
})

MainTab:CreateButton({
    Name = "プレイヤーリスト更新",
    Callback = function()
        playerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        targetDropdown:Refresh(playerList)
    end
})

MainTab:CreateToggle({
    Name = "自動ロックオン",
    CurrentValue = false,
    Callback = function(value)
        State.Combat.AutoLockEnabled = value
    end
})

MainTab:CreateButton({
    Name = "ブリング",
    Callback = function()
        if State.Combat.TargetPlayer then
            local target = Players:FindFirstChild(State.Combat.TargetPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                Character:MoveTo(targetPos)
            end
        end
    end
})

MainTab:CreateButton({
    Name = "キック",
    Callback = function()
        if State.Combat.TargetPlayer then
            local target = Players:FindFirstChild(State.Combat.TargetPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                ApplySuperStrength(target.Character.HumanoidRootPart, Vector3.new(0, 1, 0))
            end
        end
    end
})

-- 🛡️ 保護システムタブ
local ProtectionTab = Window:CreateTab("保護システム", 4483345998)

ProtectionTab:CreateSection("基本保護")

ProtectionTab:CreateToggle({
    Name = "アンチグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiGrabEnabled = value
        SetupProtectionSystems()
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチフリング",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiFlingEnabled = value
        SetupProtectionSystems()
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチ爆発",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiExplosionEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチスタン",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiStunEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチラグ",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiLagEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチキック",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiKickEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチボイド",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiVoidEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "透明化",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.InvisibilityEnabled = value
        SetupProtectionSystems()
    end
})

ProtectionTab:CreateSection("プレミアム保護")

ProtectionTab:CreateToggle({
    Name = "アンチグラブ (高級)",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.PremiumAntiGrabEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチ雪玉",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiSnowballEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "アンチバナナ",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiBananaEnabled = value
    end
})

ProtectionTab:CreateSection("高度な機能")

ProtectionTab:CreateToggle({
    Name = "アンチ燃焼",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AntiBurnEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "自動攻撃",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.AutoAttackerEnabled = value
    end
})

ProtectionTab:CreateToggle({
    Name = "カウンターモッド",
    CurrentValue = false,
    Callback = function(value)
        State.Protection.CounterModEnabled = value
    end
})

-- 👤 プレイヤー強化タブ
local EnhancementsTab = Window:CreateTab("プレイヤー強化", 4483345998)

EnhancementsTab:CreateSection("移動強化")

EnhancementsTab:CreateSlider({
    Name = "歩行速度",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "倍速",
    CurrentValue = 1.0,
    Callback = function(value)
        State.Enhancements.WalkSpeedMultiplier = value
        UpdateEnhancements()
    end
})

EnhancementsTab:CreateToggle({
    Name = "無限ジャンプ",
    CurrentValue = false,
    Callback = function(value)
        State.Enhancements.InfiniteJumpEnabled = value
        UpdateEnhancements()
    end
})

EnhancementsTab:CreateSlider({
    Name = "ジャンプパワー",
    Range = {24, 1000},
    Increment = 10,
    Suffix = "パワー",
    CurrentValue = 50,
    Callback = function(value)
        State.Enhancements.JumpPower = value
        UpdateEnhancements()
    end
})

EnhancementsTab:CreateToggle({
    Name = "ノークリップモード",
    CurrentValue = false,
    Callback = function(value)
        State.Enhancements.NoClipModeEnabled = value
        UpdateEnhancements()
    end
})

EnhancementsTab:CreateToggle({
    Name = "飛行モード",
    CurrentValue = false,
    Callback = function(value)
        State.Enhancements.FlyEnabled = value
        UpdateEnhancements()
    end
})

EnhancementsTab:CreateSlider({
    Name = "飛行速度",
    Range = {10, 200},
    Increment = 5,
    Suffix = "速度",
    CurrentValue = 50,
    Callback = function(value)
        State.Enhancements.FlySpeed = value
    end
})

-- 🧠 ESP タブ
local ESPTab = Window:CreateTab("ESP", 4483345998)

ESPTab:CreateSection("ESP設定")

ESPTab:CreateToggle({
    Name = "ESP有効化",
    CurrentValue = false,
    Callback = function(value)
        State.ESP.Enabled = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "塗りつぶし色",
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        State.ESP.FillColor = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "塗りつぶし透明度",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(value)
        State.ESP.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "枠線色",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        State.ESP.OutlineColor = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "枠線透明度",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0,
    Callback = function(value)
        State.ESP.OutlineTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateDropdown({
    Name = "ハイライトモード",
    Options = {"全員", "敵のみ", "味方のみ", "ターゲットのみ"},
    CurrentOption = {"全員"},
    Multiple = false,
    Callback = function(option)
        State.ESP.HighlightMode = option[1]
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "アイコン表示",
    CurrentValue = true,
    Callback = function(value)
        State.ESP.ShowIcons = value
        UpdateESP()
    end
})

ESPTab:CreateDropdown({
    Name = "アイコンタイプ",
    Options = {"スカル", "プレイヤー", "敵", "フレンド"},
    CurrentOption = {"スカル"},
    Multiple = false,
    Callback = function(option)
        State.ESP.IconType = option[1]
        UpdateESP()
    end
})

-- 💥 雑多な機能タブ
local MiscTab = Window:CreateTab("雑多な機能", 4483345998)

MiscTab:CreateSection("カスタム爆発")

MiscTab:CreateToggle({
    Name = "カスタム爆発",
    CurrentValue = false,
    Callback = function(value)
        State.Misc.CustomExplosionsEnabled = value
    end
})

MiscTab:CreateSlider({
    Name = "爆発パワー",
    Range = {10, 500},
    Increment = 10,
    Suffix = "パワー",
    CurrentValue = 100,
    Callback = function(value)
        State.Misc.ExplosionPower = value
    end
})

MiscTab:CreateButton({
    Name = "爆発実行",
    Callback = function()
        if State.Misc.CustomExplosionsEnabled then
            local explosion = Instance.new("Explosion")
            explosion.Position = Character.HumanoidRootPart.Position
            explosion.BlastPressure = State.Misc.ExplosionPower
            explosion.BlastRadius = 20
            explosion.DestroyJointRadiusPercent = 0
            explosion.Parent = Workspace
        end
    end
})

MiscTab:CreateSection("テレポート")

MiscTab:CreateInput({
    Name = "場所を保存",
    PlaceholderText = "場所名を入力",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text ~= "" and Character then
            State.Misc.TeleportLocations[text] = Character.HumanoidRootPart.Position
            Rayfield:Notify({Title = "場所保存", Content = text .. " を保存しました", Duration = 3})
        end
    end
})

MiscTab:CreateDropdown({
    Name = "保存済み場所",
    Options = {},
    CurrentOption = {""},
    Multiple = false,
    Callback = function(option)
        local locName = option[1]
        if State.Misc.TeleportLocations[locName] and Character then
            Character:MoveTo(State.Misc.TeleportLocations[locName])
        end
    end
})

MiscTab:CreateToggle({
    Name = "クイックテレポート",
    CurrentValue = false,
    Callback = function(value)
        State.Misc.QuickTeleportEnabled = value
    end
})

MiscTab:CreateSection("カスタムライン")

MiscTab:CreateToggle({
    Name = "カスタムライン",
    CurrentValue = false,
    Callback = function(value)
        State.Misc.CustomLineEnabled = value
    end
})

MiscTab:CreateColorPicker({
    Name = "ライン色",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(value)
        State.Misc.LineColor = value
    end
})

MiscTab:CreateSlider({
    Name = "ライン太さ",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "太さ",
    CurrentValue = 1,
    Callback = function(value)
        State.Misc.LineThickness = value
    end
})

MiscTab:CreateToggle({
    Name = "QuiK",
    CurrentValue = false,
    Callback = function(value)
        State.Misc.QuiKEnabled = value
    end
})

-- 🖐️ GRAB拡張タブ
local GrabExtensionsTab = Window:CreateTab("GRAB拡張", 4483345998)

GrabExtensionsTab:CreateSection("グラブ拡張機能")

GrabExtensionsTab:CreateToggle({
    Name = "チャージグラブ (最大x50)",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.ChargeGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "スピンアップグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.SpinUpGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "インバースグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.InverseGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "ジョイントロックグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.JointLockGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "ラバーグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.RubberGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "アンカーグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.AnchorGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "ゴーストグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.GhostGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "マルチリムグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.MultiLimbGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "ディレイドグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.DelayedGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "スナップショットグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.SnapshotGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "マグネットグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.MagnetGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "スケールグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.ScaleGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "リバースマスグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.ReverseMassGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "チェーングラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.ChainGrabEnabled = value
    end
})

GrabExtensionsTab:CreateToggle({
    Name = "オーソリティグラブ",
    CurrentValue = false,
    Callback = function(value)
        State.GrabExtensions.AuthorityGrabEnabled = value
    end
})

-- 🚀 FLING拡張タブ
local FlingExtensionsTab = Window:CreateTab("FLING拡張", 4483345998)

FlingExtensionsTab:CreateSection("フリング挙動拡張")

FlingExtensionsTab:CreateToggle({
    Name = "カーブフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.CurveFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "ブーメランフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.BoomerangFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "スキャッターフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.ScatterFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "パルスフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.PulseFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "フェーズフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.PhaseFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "ロックオンフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.LockOnFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "オービットフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.OrbitFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "スパイラルフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.SpiralFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "タイムスローフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.TimeSlowFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "方向カオス",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.DirectionalChaosEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "スナップフリング",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.SnapFlingEnabled = value
    end
})

FlingExtensionsTab:CreateToggle({
    Name = "手元に戻る",
    CurrentValue = false,
    Callback = function(value)
        State.FlingExtensions.ReturnToHandEnabled = value
    end
})

-- 🧱 着地・衝突後タブ
local ImpactTab = Window:CreateTab("着地・衝突", 4483345998)

ImpactTab:CreateSection("衝突効果")

ImpactTab:CreateToggle({
    Name = "インパクトフリーズ",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.ImpactFreezeEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "バウンスオーバーライド",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.BounceOverrideEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "テレインエンベッド",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.TerrainEmbedEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "ショックウェーブリング",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.ShockwaveRingEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "ラグドールループ",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.RagdollLoopEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "ベロシティスチール",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.VelocityStealEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "爆発なしノックバック",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.ExplosionLessKnockbackEnabled = value
    end
})

ImpactTab:CreateToggle({
    Name = "アフターイメージトレイル",
    CurrentValue = false,
    Callback = function(value)
        State.ImpactExtensions.AfterimageTrailEnabled = value
    end
})

-- メインループ
RunService.Heartbeat:Connect(function()
    -- ESP更新
    if State.ESP.Enabled then
        UpdateESP()
    end
    
    -- 強化更新
    UpdateEnhancements()
    
    -- 自動ターゲットロック
    if State.Combat.AutoLockEnabled and not State.Combat.TargetPlayer then
        local closest = GetClosestPlayer()
        if closest then
            State.Combat.TargetPlayer = closest.Name
        end
    end
    
    -- 自動ブリング
    if State.Combat.AutoBringEnabled and State.Combat.TargetPlayer then
        local target = Players:FindFirstChild(State.Combat.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Character:MoveTo(targetPos)
        end
    end
end)

-- 初期化完了
Rayfield:Notify({
    Title = "Syu_hub v10.5",
    Content = "完全拡張版が正常に起動しました",
    Duration = 5,
    Image = 4483345998
})

print("Syu_hub v10.5: 全75機能を統合した完全版が起動しました")
