--> GLOBAL VARIABLES <--
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid
local hrp = character.HumanoidRootPart
--> GLOBAL VARIABLES <--

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
HomeTab:CreateSection("Home Section")
HomeTab:CreateLabel("Display Name: " .. player.DisplayName)
HomeTab:CreateLabel("Username: " .. player.Name)
HomeTab:CreateLabel("User ID: " .. player.UserId)
HomeTab:CreateLabel("Executor: " .. identifyexecutor() .. " " .. version())
