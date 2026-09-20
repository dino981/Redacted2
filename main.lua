--> SERVICES <--
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
--> SERVICES <--

--> GLOBAL VARIABLES <--
local player = players.LocalPlayer
local camera = workspace.Camera
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid
local hrp = character.HumanoidRootPart
--> GLOBAL VARIABLES <--

--> LOCAL VARIABLES <--
local bv, bg
local ghostPart
local ghostViewSpeed = 1
local ghostViewConnection
local ghostViewActive = false
local respawnDelay = 120
local playerEspActive = false
local crateEspActive = false
local militaryCrateEspActive = false
--> LOCAL VARIABLES <--

--> FUNCTIONS <--
local function moveItemFromStorage(destinationPath, originPath)
    local moveArgs = {
        [1] = destinationPath,
        [2] = originPath
    }

    replicatedStorage.Inventory.StorageRemoteEvents.QuickMoveFromStorage:FireServer(unpack(moveArgs))
end

local function moveItemIntoStorage(originPath, destinationPath)
    local moveArgs = {
        [1] = originPath,
        [2] = destinationPath
    }

    replicatedStorage.Inventory.StorageRemoteEvents.QuickMoveToStorage:FireServer(unpack(moveArgs))
end

local function spawnAtBag(targetBag)
    
end

local function swingTool()
    local swingArgs = {
        [1] = camera.CFrame.LookVector,
        [2] = camera:FindFirstChild("Viewmodel"):FindFirstChildWhichIsA("Model").Name or "Rock"
    }

    replicatedStorage.ToolSystem.RemoteEvents.Swing:FireServer(unpack(swingArgs))
end

local function pickUp(path)
    local pickUpArgs = {
        [1] = path
    }

    replicatedStorage.LootSystem.RemoteEvents.PickUpRequest:FireServer(unpack(pickUpArgs))
end

local function createEsp(target)
    local char, displayName
    if target:IsA("Player") then
        char = target.Character
        displayName = target.DisplayName .. " (@" .. target.Name .. ")"
    elseif target:IsA("Model") then
        char = target
        local targetPlr = players:GetPlayerFromCharacter(target)
        displayName = targetPlr and (targetPlr.DisplayName .. " (@" .. targetPlr.Name .. ")") or target.Name
    end

    if not char then return end

    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 2)
    if not head then return end

    if not char:FindFirstChild("DecayEspHighlight") then
        local espHighlight = Instance.new("Highlight")
        espHighlight.Name = "DecayEspHighlight"
        espHighlight.FillTransparency = 0.3
        espHighlight.OutlineTransparency = 0
        espHighlight.FillColor = Color3.fromRGB(0, 255, 0)
        espHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        
        espHighlight.Adornee = char
        espHighlight.Parent = char
    end

    if not head:FindFirstChild("DecayEspTag") then
        local espBillboard = Instance.new("BillboardGui")
        espBillboard.Name = "DecayEspTag"
        espBillboard.AlwaysOnTop = true
        espBillboard.MaxDistance = math.huge
        espBillboard.Size = UDim2.new(0, 150, 0, 30)
        espBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
        espBillboard.Adornee = head

        local espNameTag = Instance.new("TextLabel")
        espNameTag.BackgroundTransparency = 1
        espNameTag.Size = UDim2.new(1, 0, 1, 0)
        espNameTag.Position = UDim2.new(0, 0, 0, 0)
        espNameTag.TextTransparency = 0
        espNameTag.ZIndex = 10
        espNameTag.Font = Enum.Font.SourceSansBold
        espNameTag.TextSize = 14
        espNameTag.Text = displayName
        espNameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
        espNameTag.TextStrokeTransparency = 0
        espNameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        espNameTag.Parent = espBillboard

        espBillboard.Parent = head
    end
end

local function deleteEsp(target)
    local char = target:IsA("Player") and target.Character or target
    if not char then return end

    local highlight = char:FindFirstChild("DecayEspHighlight")
    if highlight then
        highlight:Destroy()
    end

    local head = char:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("DecayEspTag")
        if billboard then
            billboard:Destroy()
        end
    end
end

local function setupPlayer(targetPlayer)
    if targetPlayer == player then return end

    targetPlayer.CharacterAdded:Connect(function(char)
        if playerEspActive then
            task.wait(0.5)
            createEsp(char)
        end
    end)

    if playerEspActive and targetPlayer.Character then
        createEsp(targetPlayer)
    end
end

--[[local function createObjectEsp(target)
    local espBillboard = Instance.new("BillboardGui")
    espBillboard.Name = "DecayEspTag"
    espBillboard.AlwaysOnTop = true
    espBillboard.MaxDistance = math.huge
    espBillboard.Size = UDim2.new(0, 150, 0, 30)
    espBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
    espBillboard.Adornee = target:FindFirstChild("Hitbox")
    espBillboard.Parent = target:FindFirstChild("Hitbox")

    local espNameTag = Instance.new("TextLabel")
    espNameTag.BackgroundTransparency = 1
    espNameTag.Size = UDim2.new(1, 0, 1, 0)
    espNameTag.Position = UDim2.new(0, 0, 0, 0)
    espNameTag.TextTransparency = 0
    espNameTag.ZIndex = 10
    espNameTag.Font = Enum.Font.SourceSansBold
    espNameTag.TextSize = 14
    espNameTag.Text = target.Name
    espNameTag.TextColor3 = Color3.fromRGB(255, 0, 0)
    espNameTag.TextStrokeTransparency = 0
    espNameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    espNameTag.Parent = espBillboard
end

local function deleteObjectEsp(target)
    if target:FindFirstChild("Hitbox") and target.Hitbox:FindFirstChild("DecayEspTag") then 
        target.Hitbox.DecayEspTag:Destroy()
    end
end]]
--> FUNCTIONS <--

-- 144803933568 Main Game
-- 97393041934796 US #3

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Decay GUI",
    Icon = "globe",
    LoadingTitle = "Decay GUI",
    LoadingSubtitle = "by dino981",
    Theme = "Default",

    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,

    ConfigurationSaving = {
        Enabled  = false,
        FolderName = nil,
        FileName = "Nil"
    },

    KeySystem = false,
})

local HomeTab = Window:CreateTab("Home", "home")
HomeTab:CreateLabel("Welcome, " .. player.Name)
HomeTab:CreateSection("Home")
HomeTab:CreateLabel("Display Name: " .. player.DisplayName)
HomeTab:CreateLabel("Username: " .. player.Name)
HomeTab:CreateLabel("User ID: " .. player.UserId)
HomeTab:CreateLabel("Executor: " .. identifyexecutor() .. " " .. version()  or "Unknown")

local PlayerTab = Window:CreateTab("Player", "circle-user")
PlayerTab:CreateSection("LocalPlayer")
local SpeedSlider = PlayerTab:CreateSlider {
    Name = "Walk Speed",
    Range = {12, 21},
    Increment = 1,
    Suffix = "WS",
    CurrentValue = 12,
    Callback = function(Value)
        humanoid.WalkSpeed = Value
    end,
}
PlayerTab:CreateButton {
    Name = "Rest Walk Speed",
    Callback = function()
        if player.IsSprinting then 
            humanoid.WalkSpeed = 16.5
            SpeedSlider:Set(16.5)
        elseif not player.IsSprinting then 
            humanoid.WalkSpeed = 12
            SpeedSlider:Set(12)
        end
    end,
}

local JumpSlider = PlayerTab:CreateSlider {
    Name = "Jump Power",
    Range = {38, 65},
    Increment = 1,
    Suffix = "JP",
    CurrentValue = 38,
    Callback = function(Value)
        humanoid.JumpPower = Value
    end,
}

PlayerTab:CreateButton {
    Name = "Reset Jump Power",
    Callback = function()
        humanoid.JumpPower = 38
        JumpSlider:Set(38)
    end,
}

PlayerTab:CreateSlider {
    Name = "Ghost View Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "GVS",
    CurrentValue = 1,
    Callback = function(Value)
        ghostViewSpeed = Value
    end,
}

PlayerTab:CreateToggle({
    Name = "Toggle Ghost View",
    CurrentValue = false,
    Callback = function(Value)
        ghostViewActive = Value
        if ghostViewActive == true then
            Rayfield:Notify({
                Title = "Ghost View Enabled",
                Content = "Ghost view only works up to a few hundred studs away, if stuck re-toggle.",
                Duration = 5,
                Image = "alert-triangle",
            })
            ghostPart = Instance.new("Part")
            ghostPart.Size = Vector3.new(1, 1, 1)
            ghostPart.Transparency = 1
            ghostPart.CanCollide = false
            ghostPart.Position = hrp.Position
            ghostPart.Parent = workspace

            camera.CameraSubject = ghostPart
            hrp.Anchored = true

            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = ghostPart

            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P, bg.D = 1000, 50
            bg.Parent = ghostPart

            ghostViewConnection = runService.RenderStepped:Connect(function()
                local playerScripts = player:FindFirstChild("PlayerScripts")
                local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
                if not playerModule then return end

                local cm = require(playerModule:WaitForChild("ControlModule"))
                if not cm or not camera then return end

                local move = cm:GetMoveVector()
                local forward = -move.Z
                local vel = (camera.CFrame.RightVector * move.X + camera.CFrame.LookVector * forward) * ghostViewSpeed

                bv.Velocity = vel
                bg.CFrame = camera.CFrame
            end)
        else
            if ghostViewConnection then 
                ghostViewConnection:Disconnect()
                ghostViewConnection = nil
            end

            camera.CameraSubject = humanoid
            hrp.Anchored = false

            if ghostPart then 
                ghostPart:Destroy()
                ghostPart = nil
            end
            if bv then 
                bv:Destroy()
                bv = nil
            end
            if bg then 
                bg:Destroy()
                bg = nil
            end
        end
    end
})

local EspTab = Window:CreateTab("Esp", "glasses")

EspTab:CreateToggle({
    Name = "Player Esp",
    CurrentValue = false,
    Callback = function(Value)
        playerEspActive = Value

        if playerEspActive then
            playerEspThread = task.spawn(function()
                while playerEspActive do
                    for _, otherPlayer in ipairs(players:GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character then
                            local char = otherPlayer.Character
                            if not char:FindFirstChild("DecayEspHighlight") then
                                createEsp(otherPlayer)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        elseif playerEspActive == false then
            for _, otherPlayer in ipairs(players:GetPlayers()) do
                if otherPlayer ~= player then
                    deleteEsp(otherPlayer)
                end
            end
        end
    end,
})

--[[EspTab:CreateToggle({
    Name = "Crate Esp",
    CurrentValue = false,
    Callback = function(Value)
        crateEspActive = Value
        if crateEspActive then 
            crateEspThread = task.spawn(function()
                while crateEspActive do 
                    for _, crate in ipairs(workspace.LootSpawns:GetDescendants()) do 
                        if crate.Name == "Crate" and crate:IsA("Model") then
                            if not crate:FindFirstChild("Hitbox"):FindFirstChild("DecayEspTag") then
                            createObjectEsp(crate)
                        end
                    end
                    task.wait(1)
                end
            end)
        elseif crateEspActive == false then 
            for _, crate in ipairs(workspace.LootSpawns:GetDescendants()) do 
                if crate.Name == "Crate" and crate:IsA("Model") then 
                    if crate:FindFirstChild("Hitbox"):FindFirstChild("DecayEspTag") then
                    deleteObjectEsp(crate)
                    end
                end
            end
        end
    end,
})

EspTab:CreateToggle({
    Name = "Military Crate Esp",
    CurrentValue = false,
    Callback = function(Value)
        militaryCrateEspActive = Value
        if militaryCrateEspActive then 
            militaryCrateEspThread = task.spawn(function()
                while militaryCrateEspActive do 
                    for _, militaryCrate in ipairs(workspace.LootSpawns:GetDescendants()) do 
                        if militaryCrate.Name == "Military Crate" and militaryCrate:IsA("Model") then  
                            if not militaryCrate:FindFirstChild("Hitbox"):FindFirstChild("DecayEspTag") then
                            createObjectEsp(militaryCrate)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        elseif militaryCrateEspActive == false then 
            for _, militaryCrate in ipairs(workspace.LootSpawns:GetDescendants()) do 
                if militaryCrate.Name == "Military Crate" and militaryCrate:IsA("Model") then 
                    if militaryCrate:FindFirstChild("Hitbox"):FindFirstChild("DecayEspTag") then 
                    deleteObjectEsp(militaryCrate)
                    end
                end
            end
        end
    end,
})]]

for _, otherPlayer in ipairs(players:GetPlayers()) do
    setupPlayer(otherPlayer)
end

local function onRespawn()
    character = player.Character
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(onRespawn)
