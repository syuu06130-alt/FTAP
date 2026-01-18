--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- deobf code

local vu1 = game:GetService("ReplicatedStorage")
game:GetService("HttpService")
local vu2 = game:GetService("RunService")
local vu3 = game:GetService("Players")
local vu4 = game:GetService("UserInputService")
local vu5 = game:GetService("Debris")
local v6 = vu1:WaitForChild("GrabEvents")
local v7 = vu1:WaitForChild("MenuToys")
local v8 = vu1:WaitForChild("CharacterEvents")
local vu9 = v6:WaitForChild("SetNetworkOwner")
local vu10 = v8:WaitForChild("Struggle")
local vu11 = v7:WaitForChild("DestroyToy")
v6:WaitForChild("CreateGrabLine")
local vu12 = v6:WaitForChild("DestroyGrabLine")
v8:WaitForChild("RagdollRemote")
local vu13 = v6:FindFirstChild("CreatureGrab") or v6:WaitForChild("CreatureGrab", 1)
local vu14 = v6:FindFirstChild("CreatureDrop") or v6:WaitForChild("CreatureDrop", 1)
local vu15 = vu3.LocalPlayer
local vu16 = vu15.Character or vu15.CharacterAdded:Wait()
vu15.CharacterAdded:Connect(function(p17)
    vu16 = p17
end)
local vu18 = nil
local vu19 = nil
local vu20 = nil
local vu21 = nil
local vu22 = nil
local vu23 = nil
local vu24 = nil
local vu25 = nil
local vu26 = nil
local vu27 = {}
local vu28 = nil
local vu29 = nil
local vu30 = nil
local vu31 = nil
local vu32 = {}
local vu33 = {}
local vu34 = {}
local vu35 = {}
local vu36 = {}
local vu37 = nil
local vu38 = nil
local vu39 = nil
local vu40 = {}
local vu41 = {}
_G.ToyToLoad = "BombMissile"
_G.MaxMissiles = 9
_G.BlobmanDelay = 0.005
_G.strength = 400
local vu42 = 50
local vu43 = 50
local vu44 = 15
local vu45 = 5
local vu46 = 10
local vu47 = true
local vu48 = ""
local vu49 = workspace:FindFirstChild(vu15.Name .. "SpawnedInToys")
local vu50 = nil
local vu51 = nil
local vu52 = loadstring(game:HttpGet("https://paste.ee/r/7X7NLEPB", true))()
local function vu56(p53, p54)
    local v55 = p53.Parent
    while v55 do
        if v55 == p54 then
            return true
        end
        v55 = v55.Parent
    end
    return false
end
local function vu59(p57)
    local v58 = p57 or vu49:FindFirstChildWhichIsA("Model")
    if v58 then
        vu11:FireServer(v58)
    end
end
local function v66(p60)
    local v61 = {}
    if workspace:FindFirstChild("Map") then
        local v62, v63, v64 = ipairs(workspace.Map:GetDescendants())
        while true do
            local v65
            v64, v65 = v62(v63, v64)
            if v64 == nil then
                break
            end
            if v65:IsA("Part") and v65.Name == p60 then
                table.insert(v61, v65)
            end
        end
    end
    return v61
end
local vu67 = v66("PoisonHurtPart")
local vu68 = v66("PaintPlayerPart")
task.spawn(function()
    pcall(function()
        local v69 = vu15:WaitForChild("PlayerGui"):WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("Contents", 5)
        if v69 then
            local v70, v71, v72 = pairs(v69:GetChildren())
            while true do
                local v73
                v72, v73 = v70(v71, v72)
                if v72 == nil then
                    break
                end
                if v73.Name ~= "UIGridLayout" then
                    vu41[v73.Name] = true
                end
            end
        end
    end)
end)
local function vu82()
    local v74 = math.huge
    local v75 = vu3
    local v76, v77, v78 = pairs(v75:GetPlayers())
    local v79 = nil
    while true do
        local v80
        v78, v80 = v76(v77, v78)
        if v78 == nil then
            break
        end
        if v80 ~= vu15 and v80.Character and v80.Character:FindFirstChild("HumanoidRootPart") then
            local v81 = (vu16.HumanoidRootPart.Position - v80.Character.HumanoidRootPart.Position).Magnitude
            if v81 < v74 then
                v79 = v80
                v74 = v81
            end
        end
    end
    return v79
end
local function vu91(p83)
    local v84, v85, v86 = ipairs(p83)
    while true do
        local v87
        v86, v87 = v84(v85, v86)
        if v86 == nil then
            break
        end
        v87:Disconnect()
    end
    local v88, v89, v90 = pairs(p83)
    while true do
        v90 = v88(v89, v90)
        if v90 == nil then
            break
        end
        p83[v90] = nil
    end
end
local function vu95(pu92, pu93)
    task.spawn(function()
        local v94 = Vector3.new(0, 0, 0)
        vu1.MenuToys.SpawnToyRemoteFunction:InvokeServer(pu92, pu93, v94)
    end)
end
local function vu100(pu96, pu97)
    task.spawn(function()
        local v98 = CFrame.new(pu97)
        local v99 = Vector3.new(0, 90, 0)
        vu1.MenuToys.SpawnToyRemoteFunction:InvokeServer(pu96, v98, v99)
    end)
end
local function vu103(p101)
    if not vu49:FindFirstChild("Campfire") then
        vu100("Campfire", Vector3.new(- 72.9304581, - 5.96906614, - 265.543732))
    end
    local v102 = vu49:FindFirstChild("Campfire")
    if v102 then
        vu50 = v102:FindFirstChild("FirePlayerPart") or v102.FirePlayerPart
        if vu50 then
            vu50.Size = Vector3.new(7, 7, 7)
            vu50.Position = p101.Position
            task.wait(0.3)
            vu50.Position = Vector3.new(0, - 50, 0)
        end
    end
end
local function vu108(p104)
    local v107 = p104.CharacterAdded:Connect(function(p105)
        local v106 = p105:WaitForChild("HumanoidRootPart"):WaitForChild("FirePlayerPart")
        v106.Size = Vector3.new(4.5, 5, 4.5)
        v106.CollisionGroup = "1"
        v106.CanQuery = true
    end)
    table.insert(vu27, v107)
end
local function vu117()
    local v109 = vu3
    local v110, v111, v112 = pairs(v109:GetPlayers())
    while true do
        local v113
        v112, v113 = v110(v111, v112)
        if v112 == nil then
            break
        end
        if v113.Character and v113.Character:FindFirstChild("HumanoidRootPart") then
            local v114 = v113.Character.HumanoidRootPart
            if v114:FindFirstChild("FirePlayerPart") then
                local v115 = v114.FirePlayerPart
                v115.Size = Vector3.new(4.5, 5.5, 4.5)
                v115.CollisionGroup = "1"
                v115.CanQuery = true
            end
        end
        vu108(v113)
    end
    local v116 = vu3.PlayerAdded:Connect(vu108)
    table.insert(vu27, v116)
end
local function vu135(pu118)
    while true do
        local _, _ = pcall(function()
            local v119 = workspace:FindFirstChild("GrabParts")
            if v119 and v119.Name == "GrabParts" then
                local v120 = v119:FindFirstChild("GrabPart"):FindFirstChild("WeldConstraint")
                local v121 = v120 and v120.Part1 and v120.Part1.Parent:FindFirstChild("Head")
                if v121 then
                    while workspace:FindFirstChild("GrabParts") do
                        local v122 = pu118 == "poison" and vu67 or vu68
                        local v123, v124, v125 = pairs(v122)
                        while true do
                            local v126
                            v125, v126 = v123(v124, v125)
                            if v125 == nil then
                                break
                            end
                            v126.Size = Vector3.new(2, 2, 2)
                            v126.Transparency = 1
                            v126.Position = v121.Position
                        end
                        task.wait()
                        local v127, v128, v129 = pairs(v122)
                        while true do
                            local v130
                            v129, v130 = v127(v128, v129)
                            if v129 == nil then
                                break
                            end
                            v130.Position = Vector3.new(0, - 200, 0)
                        end
                    end
                    local v131, v132, v133 = pairs(partsTable)
                    while true do
                        local v134
                        v133, v134 = v131(v132, v133)
                        if v133 == nil then
                            break
                        end
                        v134.Position = Vector3.new(0, - 200, 0)
                    end
                end
            end
        end)
        task.wait()
    end
end
local function vu139()
    while true do
        pcall(function()
            local v136 = workspace:FindFirstChild("GrabParts")
            if v136 and v136.Name == "GrabParts" then
                local v137 = v136:FindFirstChild("GrabPart"):FindFirstChild("WeldConstraint")
                local v138 = v137 and v137.Part1 and v137.Part1.Parent:FindFirstChild("Head")
                if v138 then
                    vu103(v138)
                end
            end
        end)
        task.wait()
    end
end
local function vu151()
    while true do
        pcall(function()
            local v140 = workspace:FindFirstChild("GrabParts")
            if v140 and v140.Name == "GrabParts" then
                local v141 = v140:FindFirstChild("GrabPart"):FindFirstChild("WeldConstraint")
                if v141 and v141.Part1 then
                    local v142 = v141.Part1.Parent
                    if v142:FindFirstChild("HumanoidRootPart") then
                        while workspace:FindFirstChild("GrabParts") do
                            local v143, v144, v145 = pairs(v142:GetChildren())
                            while true do
                                local v146
                                v145, v146 = v143(v144, v145)
                                if v145 == nil then
                                    break
                                end
                                if v146:IsA("BasePart") then
                                    v146.CanCollide = false
                                end
                            end
                            task.wait()
                        end
                        local v147, v148, v149 = pairs(v142:GetChildren())
                        while true do
                            local v150
                            v149, v150 = v147(v148, v149)
                            if v149 == nil then
                                break
                            end
                            if v150:IsA("BasePart") then
                                v150.CanCollide = true
                            end
                        end
                    end
                end
            end
        end)
        task.wait()
    end
end
local function vu165()
    while true do
        pcall(function()
            if vu49:FindFirstChild("Campfire") then
                vu59(vu49:FindFirstChild("Campfire"))
                task.wait(0.5)
            end
            if not vu16:FindFirstChild("Head") then
                return
            end
            vu95("Campfire", vu16.Head.CFrame)
            local v152 = vu49:WaitForChild("Campfire")
            local v153, v154, v155 = pairs(v152:GetChildren())
            local v156 = nil
            while true do
                local vu157
                v155, vu157 = v153(v154, v155)
                if v155 == nil then
                    vu157 = v156
                    break
                end
                if vu157.Name == "FirePlayerPart" then
                    vu157.Size = Vector3.new(10, 10, 10)
                    break
                end
            end
            if not vu157 then
            end
            local v158 = vu16.Torso.Position
            vu9:FireServer(vu157, vu157.CFrame)
            vu16:MoveTo(vu157.Position)
            task.wait(0.3)
            vu16:MoveTo(v158)
            local vu159 = Instance.new("BodyPosition")
            vu159.P = 20000
            vu159.Position = vu16.Head.Position + Vector3.new(0, 600, 0)
            vu159.Parent = v152.Main
            pcall(function()
                vu159.Position = vu16.Head.Position + Vector3.new(0, 600, 0)
                if vu161.Character and (vu161.Character.HumanoidRootPart and vu161.Character ~= vu16) then
                    vu157.Position = vu161.Character.HumanoidRootPart.Position or vu161.Character.Head.Position
                    task.wait()
                end
            end)
            local v160, vu161 = v163(v164, v160)
            if v160 ~= nil then
            else
            end
            task.wait()
            local v162 = vu3
            local v163, v164
            v163, v164, v160 = pairs(v162:GetChildren())
        end)
        task.wait()
    end
end
local function vu168(p166)
    local v167 = Instance.new("Highlight")
    v167.DepthMode = Enum.HighlightDepthMode.Occluded
    v167.FillTransparency = 1
    v167.Name = "Highlight"
    v167.OutlineColor = Color3.new(0, 0, 1)
    v167.OutlineTransparency = 0.5
    v167.Parent = p166
    return v167
end
local function vu172(p169, p170)
    local v171 = p169.Name == "PartOwner" and p169.Value ~= vu15.Name and (p170:FindFirstChild("Highlight") or vu52.GetDescendant(vu52.FindFirstAncestorOfType(p170, "Model"), "Highlight", "Highlight"))
    if v171 then
        if p169.Value == vu15.Name then
            v171.OutlineColor = Color3.new(0, 0, 1)
        else
            v171.OutlineColor = Color3.new(1, 0, 0)
        end
    end
end
local function vu178(p173, p174, p175)
    local v176 = Instance.new("BodyPosition")
    local v177 = Instance.new("BodyGyro")
    v176.P = 15000
    v176.D = 200
    v176.MaxForce = Vector3.new(5000000, 5000000, 5000000)
    v176.Position = p174
    v176.Parent = p173
    v177.P = 15000
    v177.D = 200
    v177.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
    v177.CFrame = p175
    v177.Parent = p173
end
local function vu204()
    while true do
        pcall(function()
            local v179 = workspace:FindFirstChild("GrabParts")
            if v179 then
                local v180 = v179:FindFirstChild("GrabPart")
                if v180 then
                    local v181 = v180:FindFirstChild("WeldConstraint")
                    if v181 and v181.Part1 then
                        local vu182 = v181.Part1.Name == "SoundPart" and v181.Part1 or (v181.Part1.Parent.SoundPart or (v181.Part1.Parent.PrimaryPart or v181.Part1))
                        if vu182 then
                            if vu182.Anchored then
                                return
                            elseif not vu56(vu182, workspace.Map) then
                                local v183 = vu3
                                local v184, v185, v186 = pairs(v183:GetChildren())
                                while true do
                                    local v187
                                    v186, v187 = v184(v185, v186)
                                    if v186 == nil then
                                        break
                                    end
                                    if vu56(vu182, v187.Character) then
                                        return
                                    end
                                end
                                local v188, v189, v190 = pairs(vu182:GetDescendants())
                                local v191 = true
                                while true do
                                    local v192
                                    v190, v192 = v188(v189, v190)
                                    if v190 == nil then
                                        break
                                    end
                                    if table.find(vu32, v192) then
                                        v191 = false
                                    end
                                end
                                if v191 and not table.find(vu32, vu182) then
                                    local v193
                                    if vu52.FindFirstAncestorOfType(vu182, "Model") and vu52.FindFirstAncestorOfType(vu182, "Model") ~= workspace then
                                        v193 = vu52.FindFirstAncestorOfType(vu182, "Model") or vu182
                                    else
                                        v193 = vu182
                                    end
                                    vu168(v193)
                                    table.insert(vu32, vu182)
                                    local v195 = v193.DescendantAdded:Connect(function(p194)
                                        vu172(p194, vu182)
                                    end)
                                    table.insert(vu33, v195)
                                end
                                if vu52.FindFirstAncestorOfType(vu182, "Model") and vu52.FindFirstAncestorOfType(vu182, "Model") ~= workspace then
                                    local v196, v197, v198 = ipairs(vu52.FindFirstAncestorOfType(vu182, "Model"):GetDescendants())
                                    while true do
                                        local v199
                                        v198, v199 = v196(v197, v198)
                                        if v198 == nil then
                                            break
                                        end
                                        if v199:IsA("BodyPosition") or v199:IsA("BodyGyro") then
                                            v199:Destroy()
                                        end
                                    end
                                else
                                    local v200, v201, v202 = ipairs(vu182:GetChildren())
                                    while true do
                                        local v203
                                        v202, v203 = v200(v201, v202)
                                        if v202 == nil then
                                            break
                                        end
                                        if v203:IsA("BodyPosition") or v203:IsA("BodyGyro") then
                                            v203:Destroy()
                                        end
                                    end
                                end
                                while workspace:FindFirstChild("GrabParts") do
                                    task.wait()
                                end
                                vu178(vu182, vu182.Position, vu182.CFrame)
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        end)
        task.wait()
    end
end
local function vu213()
    while true do
        pcall(function()
            local v205 = workspace:FindFirstChild("GrabParts")
            if v205 then
                local v206 = v205:FindFirstChild("GrabPart")
                if v206 then
                    local v207 = v206:FindFirstChild("WeldConstraint")
                    if v207 and v207.Part1 then
                        local v208 = v207.Part1
                        if v208 then
                            if vu56(v208, workspace.Map) then
                                return
                            elseif v208.Name == "FirePlayerPart" then
                                local v209, v210, v211 = ipairs(v208:GetChildren())
                                while true do
                                    local v212
                                    v211, v212 = v209(v210, v211)
                                    if v211 == nil then
                                        break
                                    end
                                    if v212:IsA("BodyPosition") or v212:IsA("BodyGyro") then
                                        v212:Destroy()
                                    end
                                end
                                while workspace:FindFirstChild("GrabParts") do
                                    task.wait()
                                end
                                vu178(v208, v208.Position, v208.CFrame)
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        end)
        task.wait()
    end
end
local function vu219()
    local v214, v215, v216 = ipairs(vu32)
    while true do
        local v217
        v216, v217 = v214(v215, v216)
        if v216 == nil then
            break
        end
        if v217 then
            if v217:FindFirstChild("BodyPosition") then
                v217.BodyPosition:Destroy()
            end
            if v217:FindFirstChild("BodyGyro") then
                v217.BodyGyro:Destroy()
            end
            local v218 = not v217:FindFirstChild("Highlight") and v217.Parent
            if v218 then
                v218 = v217.Parent:FindFirstChild("Highlight")
            end
            if v218 then
                v218:Destroy()
            end
        end
    end
    vu91(vu33)
    vu32 = {}
end
local function _(p220)
    local v221, v222, v223 = ipairs(vu34)
    while true do
        local v224
        v223, v224 = v221(v222, v223)
        if v223 == nil then
            break
        end
        if v224.primaryPart and v224.primaryPart == p220 then
            local v225, v226, v227 = ipairs(v224.group)
            while true do
                local v228
                v227, v228 = v225(v226, v227)
                if v227 == nil then
                    break
                end
                local v229 = v228.part:FindFirstChild("BodyPosition")
                local v230 = v228.part:FindFirstChild("BodyGyro")
                if v229 then
                    v229.Position = (p220.CFrame * v228.offset).Position
                end
                if v230 then
                    v230.CFrame = p220.CFrame * v228.offset
                end
            end
        end
    end
end
local function vu240()
    local v231, v232, v233 = ipairs(vu34)
    while true do
        local v234
        v233, v234 = v231(v232, v233)
        if v233 == nil then
            break
        end
        local v235, v236, v237 = ipairs(v234.group)
        while true do
            local v238
            v237, v238 = v235(v236, v237)
            if v237 == nil then
                break
            end
            if v238.part then
                if v238.part:FindFirstChild("BodyPosition") then
                    v238.part.BodyPosition:Destroy()
                end
                if v238.part:FindFirstChild("BodyGyro") then
                    v238.part.BodyGyro:Destroy()
                end
            end
        end
        if v234.primaryPart and v234.primaryPart.Parent then
            local v239 = v234.primaryPart:FindFirstChild("Highlight") or v234.primaryPart.Parent:FindFirstChild("Highlight")
            if v239 then
                v239:Destroy()
            end
        end
    end
    vu91(vu35)
    vu91(vu36)
    vu34 = {}
end
local function vu243()
    local v241 = vu32[1]
    if v241 then
        if v241:FindFirstChild("BodyPosition") then
            v241.BodyPosition:Destroy()
        end
        if v241:FindFirstChild("BodyGyro") then
            v241.BodyGyro:Destroy()
        end
        local v242 = v241.Parent:FindFirstChild("Highlight") or v241:FindFirstChild("Highlight")
        if v242 then
            v242:Destroy()
        end
    end
end
local function vu251()
    while true do
        pcall(function()
            local v244 = vu15.Character
            if v244 and (v244:FindFirstChild("Head") and v244:FindFirstChild("HumanoidRootPart")) then
                local _ = v244.Head
                local vu245 = v244.HumanoidRootPart
                local v246, v247, v248 = pairs(vu32)
                while true do
                    local vu249
                    v248, vu249 = v246(v247, v248)
                    if v248 == nil then
                        break
                    end
                    coroutine.wrap(function()
                        if vu249 and (vu249.Position - vu245.Position).Magnitude <= 30 then
                            local v250 = vu249:FindFirstChild("Highlight") or vu249.Parent:FindFirstChild("Highlight")
                            if v250 and v250.OutlineColor == Color3.new(1, 0, 0) then
                                vu9:FireServer(vu249, vu249.CFrame)
                                if vu249:WaitForChild("PartOwner") and vu249.PartOwner.Value == vu15.Name then
                                    v250.OutlineColor = Color3.new(0, 0, 1)
                                end
                            end
                        end
                    end)()
                end
            end
        end)
        task.wait(0.02)
    end
end
local function vu264(pu252)
    local vu253 = pu252:WaitForChild("Humanoid"):FindFirstChild("Ragdolled")
    if vu253 then
        antiExplosionConnection = vu253:GetPropertyChangedSignal("Value"):Connect(function()
            if vu253.Value then
                local v254 = pu252
                local v255, v256, v257 = ipairs(v254:GetChildren())
                while true do
                    local v258
                    v257, v258 = v255(v256, v257)
                    if v257 == nil then
                        break
                    end
                    if v258:IsA("BasePart") then
                        v258.Anchored = true
                    end
                end
            else
                local v259 = pu252
                local v260, v261, v262 = ipairs(v259:GetChildren())
                while true do
                    local v263
                    v262, v263 = v260(v261, v262)
                    if v262 == nil then
                        break
                    end
                    if v263:IsA("BasePart") then
                        v263.Anchored = false
                    end
                end
            end
        end)
    end
end
local vu265 = 1
local function vu271(p266, p267)
    if p266.Character and (p266.Character:FindFirstChild("HumanoidRootPart") and p267) then
        local v268 = vu265 == 1 and "LeftDetector" or "RightDetector"
        local v269 = vu265 == 1 and "LeftWeld" or "RightWeld"
        local v270 = {
            p267:FindFirstChild(v268),
            p266.Character:FindFirstChild("HumanoidRootPart"),
            p267:FindFirstChild(v268):FindFirstChild(v269)
        }
        blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(v270))
        vu265 = vu265 == 1 and 2 or 1
    end
end
local v272 = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local vu273 = loadstring(game:HttpGet(v272 .. "Library.lua"))()
local v274 = loadstring(game:HttpGet(v272 .. "addons/ThemeManager.lua"))()
local v275 = loadstring(game:HttpGet(v272 .. "addons/SaveManager.lua"))()
local vu276 = vu273.Options
local vu277 = vu273.Toggles
vu273.ForceCheckbox = false
local v278 = vu273
local v279 = vu273.CreateWindow(v278, {
    Title = "Phoenix Hub",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})
local v280 = {
    Main = v279:AddTab("Main"),
    Target = v279:AddTab("Target"),
    Combat = v279:AddTab("Combat"),
    LocalPlayer = v279:AddTab("LocalPlayer"),
    ObjectGrab = v279:AddTab("Object Grab"),
    BlobMan = v279:AddTab("BlobMan"),
    Fun = v279:AddTab("Fun / Troll"),
    Settings = v279:AddTab("Settings")
}
local v281 = v280.Main:AddLeftGroupbox("Information")
v281:AddLabel("Welcome to Phoenix Hub!")
v281:AddLabel("User: " .. vu15.Name)
v281:AddButton("Join Discord Server", function()
    setclipboard("https://discord.gg/C79QAfZC")
    vu273:Notify("Discord Link Copied!", 3)
end)
local v282 = v280.Main:AddLeftGroupbox("Anti-Grab")
v282:AddToggle("AntiGrab", {
    Text = "Anti Grab",
    Default = false,
    Callback = function(p283)
        if p283 then
            vu20 = vu2.Heartbeat:Connect(function()
                local v284 = vu15.Character
                if v284 and v284:FindFirstChild("Head") and vu15.Character.Head:FindFirstChild("PartOwner") then
                    vu10:FireServer()
                    vu1.GameCorrectionEvents.StopAllVelocity:FireServer()
                    local v285, v286, v287 = pairs(vu15.Character:GetChildren())
                    while true do
                        local v288
                        v287, v288 = v285(v286, v287)
                        if v287 == nil then
                            break
                        end
                        if v288:IsA("BasePart") then
                            v288.Anchored = true
                        end
                    end
                    while vu15.IsHeld.Value do
                        task.wait()
                    end
                    local v289, v290, v291 = pairs(vu15.Character:GetChildren())
                    while true do
                        local v292
                        v291, v292 = v289(v290, v291)
                        if v291 == nil then
                            break
                        end
                        if v292:IsA("BasePart") then
                            v292.Anchored = false
                        end
                    end
                end
            end)
        elseif vu20 then
            vu20:Disconnect()
            vu20 = nil
        end
    end
})
v282:AddToggle("AntiKickGrab", {
    Text = "Anti Kick Grab",
    Default = false,
    Callback = function(p293)
        if p293 then
            vu26 = vu2.Heartbeat:Connect(function()
                local v294 = vu15.Character
                if v294 and v294:FindFirstChild("HumanoidRootPart") and v294:FindFirstChild("HumanoidRootPart"):FindFirstChild("FirePlayerPart") then
                    local v295 = v294:FindFirstChild("HumanoidRootPart"):FindFirstChild("FirePlayerPart"):FindFirstChild("PartOwner")
                    if v295 and v295.Value ~= vu15.Name then
                        local v296 = {
                            v294:WaitForChild("HumanoidRootPart"),
                            0
                        }
                        vu1:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(unpack(v296))
                        print("grabbity shap!")
                        task.wait(0.1)
                        vu10:FireServer()
                    end
                end
            end)
        elseif vu26 then
            vu26:Disconnect()
            vu26 = nil
        end
    end
})
v282:AddToggle("AntiExplosion", {
    Text = "Anti Explosion",
    Default = false,
    Callback = function(p297)
        if p297 then
            if vu15.Character then
                vu264(vu15.Character)
            end
            antiExplosionConnection = vu15.CharacterAdded:Connect(function(p298)
                if antiExplosionConnection and type(antiExplosionConnection) ~= "function" then
                    antiExplosionConnection:Disconnect()
                end
                vu264(p298)
            end)
        elseif antiExplosionConnection and type(antiExplosionConnection) ~= "function" then
            antiExplosionConnection:Disconnect()
            antiExplosionConnection = nil
        end
    end
})
v280.Main:AddRightGroupbox("Self Defense"):AddToggle("AirSuspend", {
    Text = "Self Defense / Air Suspend",
    Default = false,
    Callback = function(p299)
        if p299 then
            vu21 = coroutine.create(function()
                while task.wait(0.02) do
                    local v300 = vu15.Character
                    local v301 = v300 and v300:FindFirstChild("Head") and v300.Head:FindFirstChild("PartOwner")
                    if v301 then
                        local v302 = vu3:FindFirstChild(v301.Value)
                        if v302 and v302.Character then
                            vu10:FireServer()
                            vu9:FireServer(v302.Character.Head or v302.Character.Torso, v302.Character.HumanoidRootPart.FirePlayerPart.CFrame)
                            task.wait(0.1)
                            local v303 = v302.Character:FindFirstChild("Torso")
                            if v303 then
                                local v304 = v303:FindFirstChild("l") or Instance.new("BodyVelocity")
                                v304.Name = "l"
                                v304.Parent = v303
                                v304.Velocity = Vector3.new(0, 50, 0)
                                v304.MaxForce = Vector3.new(0, math.huge, 0)
                                vu5:AddItem(v304, 100)
                            end
                        end
                    end
                end
            end)
            coroutine.resume(vu21)
        elseif vu21 then
            coroutine.close(vu21)
            vu21 = nil
        end
    end
})
local v305 = v280.Target:AddLeftGroupbox("Target Interaction")
local function vu312()
    local v306 = vu3
    local v307, v308, v309 = pairs(v306:GetPlayers())
    local v310 = {}
    while true do
        local v311
        v309, v311 = v307(v308, v309)
        if v309 == nil then
            break
        end
        if v311 ~= vu15 then
            table.insert(v310, v311.DisplayName .. " (@" .. v311.Name .. ")")
        end
    end
    return v310
end
local function vu315(p313)
    local v314 = p313:match("@(.*)%)")
    if v314 then
        return vu3:FindFirstChild(v314)
    else
        return nil
    end
end
v305:AddDropdown("TargetSelector", {
    Values = vu312(),
    Default = 1,
    Multi = false,
    Text = "select player for kick",
    Callback = function(p316)
        vu51 = vu315(p316)
    end
})
v305:AddButton("refresh player list", function()
    vu276.TargetSelector:SetValues(vu312())
    vu276.TargetSelector:SetValue(nil)
end)
v305:AddToggle("KickSpamGrab", {
    Text = "kick (spam grab)",
    Default = false,
    Callback = function(p317)
        if p317 then
            if not vu51 then
                vu273:Notify("No target selected!", 3)
                vu277.KickSpamGrab:SetValue(false)
                return
            end
            local v318, v319, v320 = pairs(game.Workspace:GetDescendants())
            local v321 = nil
            while true do
                local vu322
                v320, vu322 = v318(v319, v320)
                if v320 == nil then
                    vu322 = v321
                    break
                end
                if vu322.Name == "CreatureBlobman" and vu322:FindFirstChild("VehicleSeat") and (vu322.VehicleSeat:FindFirstChild("SeatWeld") and vu56(vu322.VehicleSeat.SeatWeld.Part1, vu15.Character)) then
                    break
                end
            end
            vu31 = coroutine.create(function()
                while vu277.KickSpamGrab.Value do
                    if vu51 and vu51.Character and vu51.Character:FindFirstChild("HumanoidRootPart") then
                        local v323 = vu51.Character.HumanoidRootPart
                        vu9:FireServer(v323, v323.CFrame)
                        vu12:FireServer(v323)
                        if vu15.Character and vu15.Character:FindFirstChild("HumanoidRootPart") then
                            v323.CFrame = vu15.Character.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                            v323.AssemblyLinearVelocity = Vector3.zero
                            v323.AssemblyAngularVelocity = Vector3.zero
                        end
                        if vu322 then
                            for _ = 1, 5 do
                                vu271(vu51, vu322)
                            end
                        end
                        if vu13 and vu14 then
                            vu13:FireServer(v323)
                            vu13:FireServer(v323)
                            vu14:FireServer(v323)
                            if vu15.Character and vu15.Character:FindFirstChild("HumanoidRootPart") then
                                v323.CFrame = vu15.Character.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                                v323.AssemblyLinearVelocity = Vector3.zero
                            end
                        end
                    end
                    task.wait()
                end
            end)
            coroutine.resume(vu31)
        elseif vu31 then
            coroutine.close(vu31)
            vu31 = nil
        end
    end
})
local v324 = v280.Combat:AddLeftGroupbox("Strength Settings")
v324:AddSlider("StrengthPower", {
    Text = "Strength Power",
    Default = 300,
    Min = 300,
    Max = 10000,
    Rounding = 0,
    Compact = false,
    Callback = function(p325)
        _G.strength = p325
    end
})
v324:AddToggle("EnableStrength", {
    Text = "Enable Strength",
    Default = false,
    Callback = function(p326)
        if p326 then
            vu19 = workspace.ChildAdded:Connect(function(pu327)
                local v328 = pu327.Name == "GrabParts" and pu327.GrabPart.WeldConstraint.Part1
                if v328 then
                    local vu329 = Instance.new("BodyVelocity", v328)
                    local vu330 = nil
                    vu330 = pu327:GetPropertyChangedSignal("Parent"):Connect(function()
                        if not pu327.Parent then
                            if vu4:GetLastInputType() ~= Enum.UserInputType.MouseButton2 then
                                vu329:Destroy()
                            else
                                vu329.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                vu329.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.strength
                                vu5:AddItem(vu329, 1)
                            end
                            vu330:Disconnect()
                        end
                    end)
                end
            end)
        elseif vu19 then
            vu19:Disconnect()
        end
    end
})
local v331 = v280.Combat:AddRightGroupbox("Grab Effects")
v331:AddToggle("PoisonGrab", {
    Text = "Poison Grab",
    Default = false,
    Callback = function(p332)
        if p332 then
            vu22 = coroutine.create(function()
                vu135("poison")
            end)
            coroutine.resume(vu22)
        else
            if vu22 then
                coroutine.close(vu22)
                vu22 = nil
            end
            local v333, v334, v335 = pairs(vu67)
            while true do
                local v336
                v335, v336 = v333(v334, v335)
                if v335 == nil then
                    break
                end
                v336.Position = Vector3.new(0, - 200, 0)
            end
        end
    end
})
v331:AddToggle("RadioactiveGrab", {
    Text = "Radioactive Grab",
    Default = false,
    Callback = function(p337)
        if p337 then
            vu23 = coroutine.create(function()
                vu135("radioactive")
            end)
            coroutine.resume(vu23)
        else
            if vu23 then
                coroutine.close(vu23)
                vu23 = nil
            end
            local v338, v339, v340 = pairs(vu68)
            while true do
                local v341
                v340, v341 = v338(v339, v340)
                if v340 == nil then
                    break
                end
                v341.Position = Vector3.new(0, - 200, 0)
            end
        end
    end
})
v331:AddToggle("FireGrab", {
    Text = "Fire Grab",
    Default = false,
    Callback = function(p342)
        if p342 then
            vu24 = coroutine.create(vu139)
            coroutine.resume(vu24)
        elseif vu24 then
            coroutine.close(vu24)
            vu24 = nil
        end
    end
})
v331:AddToggle("NoclipGrab", {
    Text = "Noclip Grab",
    Default = false,
    Callback = function(p343)
        if p343 then
            vu25 = coroutine.create(vu151)
            coroutine.resume(vu25)
        elseif vu25 then
            coroutine.close(vu25)
            vu25 = nil
        end
    end
})
local v344 = v280.Combat:AddLeftGroupbox("Kick Features")
v344:AddToggle("KickGrab", {
    Text = "Kick Grab",
    Default = false,
    Callback = function(p345)
        if p345 then
            vu117()
        else
            local v346, v347, v348 = pairs(vu27)
            while true do
                local v349
                v348, v349 = v346(v347, v348)
                if v348 == nil then
                    break
                end
                v349:Disconnect()
            end
            vu27 = {}
        end
    end
})
v344:AddToggle("KickGrabAnchor", {
    Text = "Kick Grab Anchor",
    Default = false,
    Callback = function(p350)
        if p350 then
            if not anchorKickCoroutine or coroutine.status(anchorKickCoroutine) == "dead" then
                anchorKickCoroutine = coroutine.create(vu213)
                coroutine.resume(anchorKickCoroutine)
            end
        elseif anchorKickCoroutine then
            coroutine.close(anchorKickCoroutine)
            anchorKickCoroutine = nil
        end
    end
})
v280.Combat:AddRightGroupbox("Dangerous"):AddToggle("FireAll", {
    Text = "Fire All (Spam)",
    Default = false,
    Callback = function(p351)
        if p351 then
            vu29 = coroutine.create(vu165)
            coroutine.resume(vu29)
        elseif vu29 then
            coroutine.close(vu29)
            vu29 = nil
        end
    end
})
local v352 = v280.LocalPlayer:AddLeftGroupbox("Movement")
v352:AddToggle("CrouchSpeed", {
    Text = "Crouch Speed",
    Default = false,
    Callback = function(p353)
        if p353 then
            vu38 = coroutine.create(function()
                while true do
                    pcall(function()
                        if vu16.Humanoid then
                            if vu16.Humanoid.WalkSpeed == 5 then
                                vu16.Humanoid.WalkSpeed = vu42
                            end
                        end
                    end)
                    task.wait()
                end
            end)
            coroutine.resume(vu38)
        elseif vu38 then
            coroutine.close(vu38)
            vu38 = nil
            if vu16.Humanoid then
                vu16.Humanoid.WalkSpeed = 16
            end
        end
    end
})
v352:AddSlider("SetCrouchSpeed", {
    Text = "Set Crouch Speed",
    Default = 50,
    Min = 6,
    Max = 1000,
    Rounding = 0,
    Callback = function(p354)
        vu42 = p354
    end
})
v352:AddToggle("CrouchJumpPower", {
    Text = "Crouch Jump Power",
    Default = false,
    Callback = function(p355)
        if p355 then
            vu39 = coroutine.create(function()
                while true do
                    pcall(function()
                        if vu16.Humanoid then
                            if vu16.Humanoid.JumpPower == 12 then
                                vu16.Humanoid.JumpPower = vu43
                            end
                        end
                    end)
                    task.wait()
                end
            end)
            coroutine.resume(vu39)
        elseif vu39 then
            coroutine.close(vu39)
            vu39 = nil
            if vu16.Humanoid then
                vu16.Humanoid.JumpPower = 24
            end
        end
    end
})
v352:AddSlider("SetCrouchJump", {
    Text = "Set Crouch Jump Power",
    Default = 50,
    Min = 6,
    Max = 1000,
    Rounding = 0,
    Callback = function(p356)
        vu43 = p356
    end
})
local v357 = v280.ObjectGrab:AddLeftGroupbox("Anchoring")
v357:AddToggle("AnchorGrab", {
    Text = "Anchor Grab",
    Default = false,
    Callback = function(p358)
        if p358 then
            if not vu30 or coroutine.status(vu30) == "dead" then
                vu30 = coroutine.create(vu204)
                coroutine.resume(vu30)
            end
        elseif vu30 then
            coroutine.close(vu30)
            vu30 = nil
        end
    end
})
v357:AddButton("Unanchor Parts", function()
    vu219()
end)
v357:AddButton("Disassemble Parts", function()
    vu240()
    vu219()
    if vu37 then
        coroutine.close(vu37)
        vu37 = nil
    end
end)
v357:AddButton("Unanchor Header Part", function()
    vu243()
end)
v280.ObjectGrab:AddRightGroupbox("Recovery"):AddToggle("AutoRecover", {
    Text = "Auto Recover Dropped Parts",
    Default = false,
    Callback = function(p359)
        if p359 then
            if not vu18 or coroutine.status(vu18) == "dead" then
                vu18 = coroutine.create(vu251)
                coroutine.resume(vu18)
            end
        elseif vu18 then
            coroutine.close(vu18)
            vu18 = nil
        end
    end
})
local v360 = v280.BlobMan:AddLeftGroupbox("Server Destroyer")
v360:AddToggle("DestroyServer", {
    Text = "Destroy Server (Blobman)",
    Default = false,
    Callback = function(p361)
        if p361 then
            print("Toggle enabled")
            vu28 = coroutine.create(function()
                local v362, v363, v364 = pairs(game.Workspace:GetDescendants())
                local v365 = false
                while true do
                    local v366
                    v364, v366 = v362(v363, v364)
                    if v364 == nil then
                        break
                    end
                    if v366.Name == "CreatureBlobman" and v366:FindFirstChild("VehicleSeat") and (v366.VehicleSeat:FindFirstChild("SeatWeld") and vu56(v366.VehicleSeat.SeatWeld.Part1, vu15.Character)) then
                        blobman = v366
                        v365 = true
                        break
                    end
                end
                if v365 then
                    while true do
                        pcall(function()
                            while task.wait() do
                                local v367 = vu3
                                local v368, v369, v370 = pairs(v367:GetChildren())
                                while true do
                                    local v371
                                    v370, v371 = v368(v369, v370)
                                    if v370 == nil then
                                        break
                                    end
                                    if blobman and v371 ~= vu15 then
                                        vu271(v371, blobman)
                                        task.wait(_G.BlobmanDelay)
                                    end
                                end
                            end
                        end)
                        task.wait(0.02)
                    end
                else
                    vu273:Notify("You must be mounted on a blobman!", 3)
                    blobman = nil
                    coroutine.close(vu28)
                    vu28 = nil
                    return
                end
            end)
            coroutine.resume(vu28)
        elseif vu28 then
            coroutine.close(vu28)
            vu28 = nil
            blobman = nil
        end
    end
})
v360:AddSlider("DestroySpeed", {
    Text = "Destroy Speed",
    Default = 0.5,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(p372)
        _G.BlobmanDelay = p372
    end
})
local v373 = v280.Fun:AddLeftGroupbox("Coin Visual")
v373:AddInput("CoinCount", {
    Default = "",
    Numeric = true,
    Finished = false,
    Text = "Number of Coins",
    Callback = function(p374)
        vu48 = p374
    end
})
v373:AddButton("Get Coin (Visual)", function()
    local v375 = tonumber(vu48) or 0
    game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGui").TopRight.CoinsFrame.CoinsDisplay.Coins.Text = tostring(v375)
end)
local v376 = v280.Fun:AddRightGroupbox("Decoy Control")
v376:AddSlider("DecoyOffset", {
    Text = "Decoy Offset",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(p377)
        vu44 = p377
    end
})
v376:AddInput("CircleRadius", {
    Default = "10",
    Numeric = true,
    Finished = true,
    Text = "Circle Radius",
    Callback = function(p378)
        vu46 = tonumber(p378) or 10
    end
})
v376:AddButton("Decoy Follow", function()
    local v379, v380, v381 = pairs(workspace:GetDescendants())
    local vu382 = {}
    while true do
        local v383, v384 = v379(v380, v381)
        if v383 == nil then
            break
        end
        v381 = v383
        if v384:IsA("Model") and v384.Name == "YouDecoy" then
            table.insert(vu382, v384)
        end
    end
    local vu385 = # vu382
    local vu386 = math.ceil(vu385 / 2)
    local function vu401()
        local v387, v388, v389 = pairs(vu382)
        while true do
            local v390
            v389, v390 = v387(v388, v389)
            if v389 == nil then
                break
            end
            local v391 = v390:FindFirstChild("Torso")
            if v391 then
                local v392 = v391:FindFirstChild("BodyPosition")
                local v393 = v391:FindFirstChild("BodyGyro")
                if v392 and v393 then
                    local v394 = nil
                    if vu47 then
                        if vu16 and vu16:FindFirstChild("HumanoidRootPart") then
                            local v395 = vu16.HumanoidRootPart.Position
                            local v396 = (v389 - vu386) * vu44
                            local v397 = vu16.HumanoidRootPart.CFrame.LookVector
                            local v398 = vu16.HumanoidRootPart.CFrame.RightVector
                            v394 = v395 - v397 * vu44 + v398 * v396
                        end
                    else
                        local v399 = vu82()
                        if v399 and v399.Character and v399.Character:FindFirstChild("HumanoidRootPart") then
                            local v400 = math.rad((v389 - 1) * (360 / vu385))
                            v394 = v399.Character.HumanoidRootPart.Position + Vector3.new(math.cos(v400) * vu46, 0, math.sin(v400) * vu46)
                            v393.CFrame = CFrame.new(v391.Position, v399.Character.HumanoidRootPart.Position)
                        end
                    end
                    if v394 then
                        if vu45 >= (v394 - v391.Position).Magnitude then
                            v392.Position = v391.Position
                            v393.CFrame = v391.CFrame
                        else
                            v392.Position = v394
                            if vu47 then
                                v393.CFrame = CFrame.new(v391.Position, v394)
                            end
                        end
                    end
                end
            end
        end
    end
    local function v407(p402)
        local v403 = p402:FindFirstChild("Torso")
        if v403 then
            local v404 = Instance.new("BodyPosition")
            local v405 = Instance.new("BodyGyro")
            v404.Parent = v403
            v405.Parent = v403
            v404.MaxForce = Vector3.new(40000, 40000, 40000)
            v404.D = 100
            v404.P = 100
            v405.MaxTorque = Vector3.new(40000, 40000, 40000)
            v405.D = 100
            v405.P = 20000
            local v406 = vu2.Heartbeat:Connect(vu401)
            table.insert(vu40, v406)
            vu9:FireServer(v403, vu16.Head.CFrame)
        end
    end
    local v408, v409, v410 = pairs(vu382)
    local v411 = vu385
    while true do
        local v412
        v410, v412 = v408(v409, v410)
        if v410 == nil then
            break
        end
        v407(v412)
    end
    vu273:Notify("Decoys connected: " .. v411, 3)
end)
v376:AddButton("Toggle Follow Mode", function()
    vu47 = not vu47
end)
v376:AddButton("Disconnect Clones", function()
    vu91(vu40)
end)
v274:SetLibrary(vu273)
v275:SetLibrary(vu273)
v275:IgnoreThemeSettings()
v275:SetIgnoreIndexes({
    "MenuKeybindFix4"
})
v274:SetFolder("PhoenixHub")
v275:SetFolder("PhoenixHub/Configs")
local v413 = v280.Settings:AddRightGroupbox("Menu")
v413:AddButton("Unload", function()
    vu273:Unload()
end)
v413:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybindFix4", {
    Default = "RightControl",
    NoUI = true,
    Text = "Menu Keybind"
})
v274:ApplyToTab(v280.Settings)
v275:BuildConfigSection(v280.Settings)
vu273.ToggleKeybind = vu276.MenuKeybindFix4
v275:LoadAutoloadConfig()
