-- 拡張実装サンプル：COMBAT SYSTEM

-- 1. 強力なグラブ・タイプセレクター
local GrabMasterTab = Window:CreateTab("Grab Master", 4483345998)
GrabMasterTab:CreateSection("⚔️ Grab Type Configuration")

local GrabTypeSelector = GrabMasterTab:CreateDropdown({
    Name = "Select Active Grab Type",
    Options = {"Normal", "Poison", "Burn", "Ragdoll", "Death", "Massless", "NoClip", "Perspective", "Blobman"},
    CurrentOption = {"Normal"},
    Multiple = false,
    Callback = function(Option)
        State.ActiveGrabType = Option[1]
    end
})

-- グラブ効果の強度設定
GrabMasterTab:CreateSlider({
    Name = "Grab Effect Power",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x Multiplier",
    CurrentValue = 1.0,
    Callback = function(Value)
        State.GrabEffectMultiplier = Value
    end
})

-- 毒グラブの詳細設定
GrabMasterTab:CreateSlider({
    Name = "Poison Damage Scale",
    Range = {1, 3},
    Increment = 0.1,
    Suffix = "x Damage",
    CurrentValue = 1.5,
    Callback = function(Value)
        State.PoisonDamageScale = Value
    end
})

-- 2. 高度なプレイヤーコントロール
local PlayerControlTab = Window:CreateTab("Player Control", 4483345998)
PlayerControlTab:CreateSection("👤 Target Management")

-- 強化されたプレイヤー検索とロックオン
PlayerControlTab:CreateInput({
    Name = "Search Player",
    PlaceholderText = "Enter name or display name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        for _, player in pairs(Players:GetPlayers()) do
            if string.find(string.lower(player.Name), string.lower(Text)) or 
               string.find(string.lower(player.DisplayName), string.lower(Text)) then
                State.TargetPlayer = player.Name
                Rayfield:Notify({Title = "Target Found", Content = "Locked onto: " .. player.Name, Duration = 3})
                break
            end
        end
    end
})

-- 自動ブリング機能
PlayerControlTab:CreateToggle({
    Name = "Auto-Bring (Continuous)",
    CurrentValue = false,
    Callback = function(Value)
        State.AutoBringEnabled = Value
        if Value then
            coroutine.resume(coroutine.create(function()
                while State.AutoBringEnabled and State.TargetPlayer do
                    ExecuteBring(State.TargetPlayer)
                    task.wait(0.5) -- 0.5秒間隔でブリング
                end
            end))
        end
    end
})

-- 3. プレミアム保護システム
local PremiumProtectionTab = Window:CreateTab("Premium Protection", 4483345998)
PremiumProtectionTab:CreateSection("💎 Advanced Defenses")

PremiumProtectionTab:CreateToggle({
    Name = "Anti-Grab (Gucci Edition)",
    CurrentValue = false,
    Callback = function(Value)
        State.PremiumAntiGrab = Value
        if Value then
            -- 高精度アンチグラブ実装
            RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        -- 高度な位置修正ロジック
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end)
            end)
        end
    end
})

-- 4. ESP システム完全実装
local ESPTab = Window:CreateTab("ESP Vision", 4483345998)
ESPTab:CreateSection("🧠 Enhanced Visuals")

-- ESP ハイライト設定
ESPTab:CreateColorPicker({
    Name = "ESP Fill Color",
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        State.ESP.FillColor = Value
        UpdateESPVisuals() -- ESP更新関数を呼び出し
    end
})

ESPTab:CreateSlider({
    Name = "ESP Fill Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(Value)
        State.ESP.FillTransparency = Value
        UpdateESPVisuals()
    end
})

-- ESP アウトライン設定
ESPTab:CreateColorPicker({
    Name = "ESP Outline Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        State.ESP.OutlineColor = Value
        UpdateESPVisuals()
    end
})

-- ESP モード選択
ESPTab:CreateDropdown({
    Name = "ESP Highlight Mode",
    Options = {"All Players", "Enemies Only", "Friends Only", "Target Only"},
    CurrentOption = {"All Players"},
    Multiple = false,
    Callback = function(Option)
        State.ESP.Mode = Option[1]
        UpdateESPVisuals()
    end
})
