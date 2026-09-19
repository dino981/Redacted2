--> SERVICES <--
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
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
--> LOCAL VARIABLES <--

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
    Range = {38, 60},
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

PlayerTab:CreateToggle {
    Name = "Toggle Ghost View",
    CurrentValue = false,
    Callback = function(Value)
        ghostViewActive = Value
        if ghostViewActive == true then 
            ghostPart = Instance.new("Part")
            ghostPart.Size = Vector3.new(1,1,1)
            ghostPart.Transparency = 1
            ghostPart.CanCollide = false
            ghostPart.Position = hrp.Position
            ghostPart.Parent = workspace

            camera.CameraSubject = ghostPart

            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = ghostPart

            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P, bg.D = 1000, 50
            bg.Parent = ghostPart

            ghostViewConnection = runService.RenderStepped:Connect(function()
                local cm = require(player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
                if not cm or not camera then return end

                local move = cm:GetMoveVector()
                local forward = -move.Z
                local vel = (camera.CFrame.RightVector * move.X + camera.CFrame.LookVector * forward) * ghostViewSpeed

                bv.Velocity = vel
                bg.CFrame = camera.CFrame
            end)
        elseif ghostViewActive == false then 
            if ghostViewConnection then 
                ghostViewConnection:Disconnect()
                ghostViewConnection = nil
            end

            camera.CameraSubject = humanoid

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
}



local function onRespawn()
    character = player.Character
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character.Humanoid
end

player.CharacterAdded:Connect(onRespawn)
