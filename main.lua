--> SERVICES <--
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:getService("ReplicatedStorage")
--> SERVICES <--

--> GLOBAL VARIABLES <--
local player = players.LocalPlayer
local camera = workspace.Camera
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
        [1] = Vector3.new(camera.CFrame.LookVector)
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
HomeTab:CreateLabel("Executor: " .. identifyexecutor() .. " " .. version())

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
    Name = "Toggle Player Esp",
    CurrentValue = false,
    Callback = function(Value)
        playerEspActive = Value
        if playerEspActive == true then 
            for _, otherPlayers in pairs(players:GetPlayers()) do
                if otherPlayers.Character and player.Name ~= otherPlayers.Name then 
                    if not othersPlayers:FindFirstChildWhichIsA("Highlight") then 
                        local espHighlight = Instance.new("Highlight")
                        espHighlight.FillTransparency = 0.3
                        espHighlight.OutlineTransparency = 0
                        espHighlight.OutlineColor = Color3.fromRGB(0, 1, 0)
                        espHighlight.Adornee = otherPlayers.Character
                        espHighlight.Parent = otherPlayers.Character
                    end
                end
            end
        elseif playerEspActive == false then 
            for _, otherPlayers in pairs(players:GetPlayers()) do 
                if otherPlayers.Character and otherPlayers.Character:FindFirstChildWhichIsA("Highlight") then 
                    othersPlayers.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
                end
            end
        end
    end
})

local function onRespawn()
    character = player.Character
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character.Humanoid
end

player.CharacterAdded:Connect(onRespawn)

players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if playerEspActive then 
            if not char:FindFirstChildWhichIsA("Highlight") then 
                if player.Name ~= char.Name then 
                    local espHighlight = Instance.new("Highlight")
                    espHighlight.FillTransparency = 0.3
                    espHighlight.OutlineTransparency = 0
                    espHighlight.OutlineColor = Color3.fromRGB(0, 1, 0)
                    espHighlight.Adornee = char
                    espHighlight.Parent = char
                end
            end
        end
    end)
end)
