--[[
    Syu_hub v8.3 | Added Phoenix Unique Features
    Target: Fling Things and People
    Fixed Version: Improved safety, memory management, and UI
]]

-- ■■■ Services ■■■
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ■■■ Variables ■■■
local IsPoison = false
local IsRadioactive = false
local IsFireGrab = false
local IsNoclipGrab = false
local IsKickGrab = false
local IsFireAll = false
local IsAnchorGrab = false
local IsAutoRecover = false

local PoisonParts = {}
local PaintParts = {}
local GrabbedObjects = {}
local Highlighted = {}
local ActiveBodyParts = {}

-- ■■■ 初期化 ■■■
local function InitializeParts()
    PoisonParts = {}
    PaintParts = {}
    
    local Map = Workspace:FindFirstChild("Map")
    if Map then
        for _, v in pairs(Map:GetDescendants()) do
            if v.Name == "PoisonHurtPart" and v:IsA("BasePart") then
                table.insert(PoisonParts, v)
                v.Transparency = 1
                v.CanCollide = false
                v.Anchored = true
                v.Position = Vector3.new(0, -200, 0)
            elseif v.Name == "PaintPlayerPart" and v:IsA("BasePart") then
                table.insert(PaintParts, v)
                v.Transparency = 1
                v.CanCollide = false
                v.Anchored = true
                v.Position = Vector3.new(0, -200, 0)
            end
        end
    end
end

-- ゲームロード時に初期化
InitializeParts()
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "PoisonHurtPart" and descendant:IsA("BasePart") then
        table.insert(PoisonParts, descendant)
        descendant.Transparency = 1
        descendant.CanCollide = false
        descendant.Anchored = true
        descendant.Position = Vector3.new(0, -200, 0)
    elseif descendant.Name == "PaintPlayerPart" and descendant:IsA("BasePart") then
        table.insert(PaintParts, descendant)
        descendant.Transparency = 1
        descendant.CanCollide = false
        descendant.Anchored = true
        descendant.Position = Vector3.new(0, -200, 0)
    end
end)

-- ■■■ Utility ■■■
local function Notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Syu_hub v8.3",
            Text = msg,
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

local function GetGrabPart()
    local GrabParts = Workspace:FindFirstChild("GrabParts")
    if GrabParts then
        return GrabParts:FindFirstChild("GrabPart")
    end
    return nil
end

local function TriggerGrab(part)
    if not part then return end
    
    for _, rem in pairs(ReplicatedStorage:GetDescendants()) do
        if rem:IsA("RemoteEvent") and (string.find(rem.Name:lower(), "grab") or string.find(rem.Name:lower(), "interact")) then
            pcall(function() 
                rem:FireServer(part)
            end)
        end
    end
end

local function CreateFirePlayerPart()
    -- 炎のパーツを作成する関数
    local fire = Instance.new("Part")
    fire.Name = "FirePlayerPart"
    fire.Size = Vector3.new(5, 0.2, 5)
    fire.Transparency = 1
    fire.CanCollide = false
    fire.Anchored = true
    fire.Position = Vector3.new(0, -200, 0)
    
    local fireTouch = Instance.new("TouchTransmitter")
    fireTouch.Parent = fire
    
    return fire
end

-- ■■■ メインループ ■■■
task.spawn(function()
    while task.wait(0.1) do
        local grabPart = GetGrabPart()
        
        if grabPart then
            local weld = grabPart:FindFirstChild("WeldConstraint")
            if weld and weld.Part1 and weld.Part1.Parent then
                local parent = weld.Part1.Parent
                local head = parent:FindFirstChild("Head")
                
                if head then
                    -- Poison Grab
                    if IsPoison and #PoisonParts > 0 then
                        for _, p in pairs(PoisonParts) do
                            p.Size = Vector3.new(3, 3, 3)
                            p.Position = head.Position + Vector3.new(0, 1.5, 0)
                        end
                    end
                    
                    -- Radioactive Grab
                    if IsRadioactive and #PaintParts > 0 then
                        for _, p in pairs(PaintParts) do
                            p.Size = Vector3.new(3, 3, 3)
                            p.Position = head.Position + Vector3.new(0, 1.5, 0)
                        end
                    end
                    
                    -- Fire Grab
                    if IsFireGrab then
                        -- キャンプファイヤーを探す
                        local campfire = nil
                        if LocalPlayer.Character then
                            campfire = LocalPlayer.Character:FindFirstChild("Campfire")
                        end
                        if not campfire then
                            local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                            if toyFolder then
                                campfire = toyFolder:FindFirstChild("Campfire")
                            end
                        end
                        
                        if campfire then
                            local fire = campfire:FindFirstChild("FirePlayerPart")
                            if fire then
                                fire.Size = Vector3.new(8, 8, 8)
                                fire.Position = head.Position + Vector3.new(0, 1.5, 0)
                            end
                        end
                    end
                    
                    -- Noclip Grab
                    if IsNoclipGrab then
                        for _, p in pairs(parent:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end
        else
            -- グラブしていない時はリセット
            if not IsPoison then
                for _, p in pairs(PoisonParts) do
                    p.Position = Vector3.new(0, -200, 0)
                end
            end
            
            if not IsRadioactive then
                for _, p in pairs(PaintParts) do
                    p.Position = Vector3.new(0, -200, 0)
                end
            end
        end
    end
end)

-- ■■■ Kick Grabループ ■■■
task.spawn(function()
    while task.wait(0.5) do
        if IsKickGrab then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    local fire = hrp:FindFirstChild("FirePlayerPart")
                    
                    if not fire then
                        fire = CreateFirePlayerPart()
                        fire.Parent = hrp
                        Debris:AddItem(fire, 0.6) -- 少し長めに持たせる
                    end
                    
                    fire.Size = Vector3.new(5, 5.5, 5)
                    fire.Position = hrp.Position
                end
            end
        end
    end
end)

-- ■■■ Fire Allループ ■■■
task.spawn(function()
    local lastSpawn = 0
    while task.wait(0.5) do
        if IsFireAll and tick() - lastSpawn > 0.5 then
            pcall(function()
                -- 既存のキャンプファイヤーをクリーン
                local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                if toyFolder then
                    for _, toy in pairs(toyFolder:GetChildren()) do
                        if toy.Name == "Campfire" then
                            toy:Destroy()
                        end
                    end
                end
                
                -- 新しいキャンプファイヤーをスポーン
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                    "Campfire", 
                    Vector3.new(math.random(-10, 10), 5, math.random(-10, 10)),
                    Vector3.new(0, 90, 0)
                )
                
                lastSpawn = tick()
            end)
        end
    end
end)

-- ■■■ Anchor Grabシステム ■■■
local function CleanupHighlights()
    for _, hl in pairs(Highlighted) do
        if hl then
            hl:Destroy()
        end
    end
    Highlighted = {}
end

local function CleanupBodyParts()
    for _, obj in pairs(ActiveBodyParts) do
        if obj then
            obj:Destroy()
        end
    end
    ActiveBodyParts = {}
end

task.spawn(function()
    while task.wait(0.5) do
        if IsAnchorGrab then
            local grabPart = GetGrabPart()
            if grabPart then
                local weld = grabPart:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 then
                    local obj = weld.Part1
                    local model = obj:FindFirstAncestorWhichIsA("Model") or obj
                    
                    if not table.find(GrabbedObjects, model) then
                        table.insert(GrabbedObjects, model)
                        
                        -- ハイライトを追加
                        local hl = Instance.new("Highlight")
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0.3
                        hl.OutlineColor = Color3.fromRGB(0, 150, 255)
                        hl.Adornee = model
                        hl.Parent = Workspace
                        table.insert(Highlighted, hl)
                        
                        -- 物理制御を追加（Partのみ）
                        if obj:IsA("BasePart") then
                            local bp = Instance.new("BodyPosition")
                            local bg = Instance.new("BodyGyro")
                            
                            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bp.Position = obj.Position
                            bp.P = 10000
                            bp.D = 500
                            
                            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bg.CFrame = obj.CFrame
                            
                            bp.Parent = obj
                            bg.Parent = obj
                            
                            table.insert(ActiveBodyParts, bp)
                            table.insert(ActiveBodyParts, bg)
                        end
                    end
                end
            else
                -- グラブしていない時はクリーンアップ
                if #Highlighted > 0 then
                    CleanupHighlights()
                    CleanupBodyParts()
                    GrabbedObjects = {}
                end
            end
        else
            -- Anchor Grabがオフの時もクリーンアップ
            if #Highlighted > 0 then
                CleanupHighlights()
                CleanupBodyParts()
                GrabbedObjects = {}
            end
        end
    end
end)

-- ■■■ Auto Recoverシステム ■■■
task.spawn(function()
    while task.wait(0.1) do
        if IsAutoRecover and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            
            -- Workspace内のパーツをスキャン
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local distance = (obj.Position - hrp.Position).Magnitude
                    
                    if distance <= 30 then
                        -- 所有権を確認
                        local owner = obj:FindFirstChild("PartOwner")
                        if owner and owner.Value == LocalPlayer.Name then
                            TriggerGrab(obj)
                            task.wait(0.05) -- スパム防止
                        end
                    end
                end
            end
        end
    end
end)

-- ■■■ UI作成 ■■■
local function CreateUI()
    -- ScreenGuiの作成
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SyuHubUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- メインフレーム
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(100, 100, 200)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- タイトル
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Title.Text = "Syu_hub v8.3 - Phoenix Features"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title
    
    -- 閉じるボタン
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = Title
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- スクロールフレーム
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = MainFrame
    
    -- ボタンリスト
    local ButtonList = Instance.new("UIListLayout")
    ButtonList.Padding = UDim.new(0, 5)
    ButtonList.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonList.Parent = ScrollFrame
    
    -- ボタン作成関数
    local function CreateToggleButton(text, initialState, color, toggleFunc)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = initialState and Color3.fromRGB(60, 150, 60) or color
        button.Text = text .. " (" .. (initialState and "ON" or "OFF") .. ")"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.AutoButtonColor = false
        button.LayoutOrder = #ScrollFrame:GetChildren()
        button.Parent = ScrollFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 100, 100)
        stroke.Thickness = 1
        stroke.Parent = button
        
        button.MouseButton1Click:Connect(function()
            local newState = toggleFunc()
            button.BackgroundColor3 = newState and Color3.fromRGB(60, 150, 60) or color
            button.Text = text .. " (" .. (newState and "ON" or "OFF") .. ")"
        end)
        
        return button
    end
    
    -- 各機能のトグルボタンを作成
    CreateToggleButton("Poison Grab", IsPoison, Color3.fromRGB(40, 60, 40), function()
        IsPoison = not IsPoison
        if not IsPoison then
            for _, p in pairs(PoisonParts) do
                p.Position = Vector3.new(0, -200, 0)
            end
        end
        Notify("Poison Grab: " .. (IsPoison and "ON" or "OFF"))
        return IsPoison
    end)
    
    CreateToggleButton("Radioactive Grab", IsRadioactive, Color3.fromRGB(60, 60, 40), function()
        IsRadioactive = not IsRadioactive
        if not IsRadioactive then
            for _, p in pairs(PaintParts) do
                p.Position = Vector3.new(0, -200, 0)
            end
        end
        Notify("Radioactive Grab: " .. (IsRadioactive and "ON" or "OFF"))
        return IsRadioactive
    end)
    
    CreateToggleButton("Fire Grab", IsFireGrab, Color3.fromRGB(60, 40, 40), function()
        IsFireGrab = not IsFireGrab
        Notify("Fire Grab: " .. (IsFireGrab and "ON" or "OFF"))
        return IsFireGrab
    end)
    
    CreateToggleButton("Noclip Grab", IsNoclipGrab, Color3.fromRGB(40, 40, 60), function()
        IsNoclipGrab = not IsNoclipGrab
        Notify("Noclip Grab: " .. (IsNoclipGrab and "ON" or "OFF"))
        return IsNoclipGrab
    end)
    
    CreateToggleButton("Kick Grab", IsKickGrab, Color3.fromRGB(60, 40, 60), function()
        IsKickGrab = not IsKickGrab
        Notify("Kick Grab: " .. (IsKickGrab and "ON" or "OFF"))
        return IsKickGrab
    end)
    
    CreateToggleButton("Fire All", IsFireAll, Color3.fromRGB(60, 40, 20), function()
        IsFireAll = not IsFireAll
        Notify("Fire All: " .. (IsFireAll and "ON" or "OFF"))
        return IsFireAll
    end)
    
    CreateToggleButton("Anchor Grab", IsAnchorGrab, Color3.fromRGB(40, 40, 80), function()
        IsAnchorGrab = not IsAnchorGrab
        if not IsAnchorGrab then
            CleanupHighlights()
            CleanupBodyParts()
            GrabbedObjects = {}
        end
        Notify("Anchor Grab: " .. (IsAnchorGrab and "ON" or "OFF"))
        return IsAnchorGrab
    end)
    
    CreateToggleButton("Auto Recover", IsAutoRecover, Color3.fromRGB(40, 80, 40), function()
        IsAutoRecover = not IsAutoRecover
        Notify("Auto Recover: " .. (IsAutoRecover and "ON" or "OFF"))
        return IsAutoRecover
    end)
    
    -- クリアボタン
    local ClearButton = Instance.new("TextButton")
    ClearButton.Size = UDim2.new(1, 0, 0, 40)
    ClearButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
    ClearButton.Text = "CLEAR ALL EFFECTS"
    ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearButton.Font = Enum.Font.GothamBold
    ClearButton.TextSize = 14
    ClearButton.LayoutOrder = #ScrollFrame:GetChildren()
    ClearButton.Parent = ScrollFrame
    
    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 6)
    ClearCorner.Parent = ClearButton
    
    ClearButton.MouseButton1Click:Connect(function()
        -- すべての状態をリセット
        IsPoison = false
        IsRadioactive = false
        IsFireGrab = false
        IsNoclipGrab = false
        IsKickGrab = false
        IsFireAll = false
        IsAnchorGrab = false
        IsAutoRecover = false
        
        -- パーツをリセット
        for _, p in pairs(PoisonParts) do
            p.Position = Vector3.new(0, -200, 0)
        end
        for _, p in pairs(PaintParts) do
            p.Position = Vector3.new(0, -200, 0)
        end
        
        -- クリーンアップ
        CleanupHighlights()
        CleanupBodyParts()
        GrabbedObjects = {}
        
        -- UI更新
        local buttons = ScrollFrame:GetChildren()
        for _, btn in pairs(buttons) do
            if btn:IsA("TextButton") and btn ~= ClearButton then
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                btn.Text = btn.Text:gsub(" %(ON%)", " (OFF)"):gsub(" %(OFF%)", " (OFF)")
            end
        end
        
        Notify("All effects cleared!")
    end)
    
    return ScreenGui
end

-- ■■■ スクリプト開始 ■■■
local success, err = pcall(function()
    -- UIを作成
    local UI = CreateUI()
    
    -- 初期通知
    Notify("Syu_hub v8.3 loaded! Phoenix features activated.")
    
    -- プレイヤーが退出した時のクリーンアップ
    LocalPlayer.CharacterRemoving:Connect(function()
        CleanupHighlights()
        CleanupBodyParts()
        GrabbedObjects = {}
    end)
end)

if not success then
    warn("Syu_hub initialization error:", err)
end
