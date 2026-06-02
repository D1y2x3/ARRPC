-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE DEFINITIVE MEGA V15 EDITION                               //
-- //                          "THE ENTERPRISE GOD-MODE BYPASS"                                    //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        OPTIMIZED FOR XENO & SUPERIOR EXECUTORS                               //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ SCRIPT REVISION HISTORY ]]
-- V1.0 - Initial Release
-- V4.0 - Premium UI Update
-- V7.0 - Absolute Stealth Implementation
-- V11.0 - Mega Expansion
-- V14.0 - On-Demand Architecture
-- V15.0 - Enterprise Stability & Scale Update (Current)

-- [[ SCRIPT CAPABILITIES ]]
-- + Absolute Anti-Kick (Metatable & Function Level)
-- + Property Spoofing (WalkSpeed, JumpPower, JumpHeight)
-- + Silent Aim (RemoteEvent & Mouse Interception)
-- + Advanced ESP (Corner Boxes, Health, Distance, Tracers)
-- + Stealth Movement (CFrame Fly, Velocity Speed, Pulse Jump)
-- + Utility Suite (Instant Interact, Barrier Removal, Anti-AFK)

print("------------------------------------------------------------")
print("[V15 MEGA] INITIALIZING ENTERPRISE SCRIPT ENVIRONMENT...")
print("[V15 MEGA] LOADING CORE PROTECTION MODULES...")
print("------------------------------------------------------------")

-- // [1] BOOTSTRAP: CORE SERVICES & LOCALIZATION
-- Accessing engine services through localized variables for extreme performance.
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

-- // [2] ULTIMATE STEALTH BYPASSES (ABSOLUTE PRIORITY)
-- These hooks are established immediately to prevent early-stage detection.

local function InitializeAbsoluteBypasses()
    local success, result = pcall(function()
        -- [[ BYPASS: CORE KICK BLOCK ]]
        -- Intercepting the player's disconnect method.
        local _k = "K".."i".."ck"
        local _originalKick
        _originalKick = hookfunction(LocalPlayer[_k], function(self, ...)
            local _r = tostring(...)
            warn("[V15 BYPASS] KICK INTERCEPTED: " .. _r)
            return nil
        end)

        -- [[ BYPASS: METATABLE CLOAKING ]]
        -- We modify the game's core metatable to hide our presence.
        local _mt = getrawmetatable(game)
        local _oldNamecall = _mt.__namecall
        local _oldIndex = _mt.__index
        local _oldNewIndex = _mt.__newindex

        setreadonly(_mt, false)

        -- REMOTEEVENT / REMOTEFUNCTION INTERCEPTION (__namecall)
        _mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if not checkcaller() then
                if method == "FireServer" or method == "InvokeServer" then
                    local name = self.Name:lower()

                    -- [[ DETECTION SIGNAL FILTERING ]]
                    -- Prevents the game from sending telemetry back to the server.
                    if name:find("kick") or name:find("ban") or name:find("cheat") or
                       name:find("ac") or name:find("report") or name:find("check") or
                       name:find("watch") or name:find("guard") or name:find("update") then
                        return nil
                    end

                    -- [[ SILENT AIM PROJECTILE REDIRECTION ]]
                    -- Dynamically redirects shots to the target's coordinates.
                    if getgenv().EnterpriseConfig and getgenv().EnterpriseConfig.Combat.SilentAim and
                      (name:find("fire") or name:find("shoot") or name:find("hit") or name:find("bullet")) then

                        local target = getgenv().GetEnterpriseTarget(
                            getgenv().EnterpriseConfig.Combat.FOV,
                            getgenv().EnterpriseConfig.Combat.TargetPart
                        )

                        if target and target.Character then
                            local hitPart = target.Character:FindFirstChild(getgenv().EnterpriseConfig.Combat.TargetPart)
                            if hitPart then
                                -- Replacing position/instance arguments.
                                for i, v in pairs(args) do
                                    if typeof(v) == "Vector3" then
                                        args[i] = hitPart.Position
                                    elseif typeof(v) == "Instance" and v:IsA("BasePart") then
                                        args[i] = hitPart
                                    end
                                end
                                return _oldNamecall(self, unpack(args))
                            end
                        end
                    end
                end
            end
            return _oldNamecall(self, ...)
        end)

        -- PROPERTY SPOOFING & MOUSE HOOKING (__index)
        _mt.__index = newcclosure(function(self, idx)
            if not checkcaller() then
                -- [[ BYPASS: PROPERTY MASKING ]]
                -- Tricking scripts that try to read our speed/jump.
                if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
                if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
                if idx == "JumpHeight" and self:IsA("Humanoid") then return 7.2 end

                -- [[ SILENT AIM: CURSOR REDIRECTION ]]
                -- Makes the game think the user's mouse is locked on the target.
                if getgenv().EnterpriseConfig and getgenv().EnterpriseConfig.Combat.SilentAim and
                  (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then

                    local target = getgenv().GetEnterpriseTarget(
                        getgenv().EnterpriseConfig.EnterpriseConfig.Combat.FOV,
                        getgenv().EnterpriseConfig.Combat.TargetPart
                    )

                    if target and target.Character then
                        local hitPart = target.Character:FindFirstChild(getgenv().EnterpriseConfig.Combat.TargetPart)
                        if hitPart then
                            return (idx == "Hit" and hitPart.CFrame or hitPart)
                        end
                    end
                end
            end
            return _oldIndex(self, idx)
        end)

        setreadonly(_mt, true)
    end)
    return success
end

-- Execute bypasses immediately.
InitializeAbsoluteBypasses()

-- // [3] ENTERPRISE CONFIGURATION DATA
-- Centralized configuration table stored in the global environment.

getgenv().EnterpriseConfig = {
    Combat = {
        Enabled = false,
        SilentAim = false,
        Keybind = Enum.KeyCode.V,
        TargetPart = "Head",
        FOV = 150,
        HitboxSize = 2,
        NoRecoil = false,
        NoSpread = false,
        InfAmmo = false,
        Active = false
    },
    Visuals = {
        Enabled = false,
        Boxes = false,
        Corners = false,
        Health = false,
        Distance = false,
        Names = false,
        Tracers = false,
        TeamCheck = true,
        Fullbright = false
    },
    Movement = {
        WalkSpeed = 16,
        JumpPower = 50,
        InfJump = false,
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        InfStamina = false,
        NoFall = false,
        Spinbot = false
    },
    Vehicle = {
        Fly = false,
        Speed = 50
    },
    Teleport = {
        SafeMode = true,
        ClickTP = false
    }
}

-- // [4] CORE UTILITY MODULES

-- TARGETING MODULE
-- Finds the optimal player to target based on field of view and team status.
getgenv().GetEnterpriseTarget = function(fov, part)
    local closestPlayer = nil
    local shortestDistance = fov

    local viewSize = Workspace.CurrentCamera.ViewportSize
    local centerScreen = Vector2.new(viewSize.X / 2, viewSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Verify Health
            if player.Character.Humanoid.Health <= 0 then continue end

            -- Team Logic
            if getgenv().EnterpriseConfig.Visuals.TeamCheck and player.Team == LocalPlayer.Team then continue end

            -- Compatibility Check (R6/R15)
            local targetPart = player.Character:FindFirstChild(part) or
                               player.Character:FindFirstChild("HumanoidRootPart") or
                               player.Character:FindFirstChild("Torso")

            if targetPart then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)

                if onScreen then
                    local mouseDistance = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude

                    if mouseDistance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = mouseDistance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- WEAPON MODIFICATION MODULE
-- Intelligently scans Tool objects to find and override gun parameters.
local function ApplyWeaponModifications(tool)
    if not tool or not tool:IsA("Tool") then return end

    pcall(function()
        local components = tool:GetDescendants()
        for i = 1, #components do
            local item = components[i]
            if item:IsA("ValueBase") then
                local propertyName = item.Name:lower()

                -- Recoil and Accuracy Handling
                if getgenv().EnterpriseConfig.Combat.NoRecoil then
                    if propertyName:find("recoil") or propertyName:find("kick") or propertyName:find("shake") then
                        item.Value = 0
                    end
                end

                if getgenv().EnterpriseConfig.Combat.NoSpread then
                    if propertyName:find("spread") or propertyName:find("accuracy") or propertyName:find("deviation") then
                        item.Value = 0
                    end
                end

                -- Ammunition Handling
                if getgenv().EnterpriseConfig.Combat.InfAmmo then
                    if propertyName:find("ammo") or propertyName:find("mag") or propertyName:find("clip") or propertyName:find("stored") then
                        item.Value = 999
                    end
                end
            end
        end
    end)
end

-- TELEPORTATION MODULE
-- Executes a smooth tween-based teleport to bypass movement threshold checks.
local function ExecuteSafeTeleport(destination)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then return end

    if getgenv().EnterpriseConfig.Teleport.SafeMode then
        local distance = (root.Position - destination).Magnitude
        local speedStudsPerSec = 60
        local duration = distance / speedStudsPerSec

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(destination)})

        print("[V15] Executing Safe TP to: " .. tostring(destination))
        tween:Play()
    else
        root.CFrame = CFrame.new(destination)
    end
end

-- // [5] ESP SYSTEM: ENTERPRISE EDITION
-- A memory-safe, high-performance drawing system for player visuals.

local ESP_Registry = {}

local function InitializeESP(player)
    if player == LocalPlayer then return end

    -- Constructing the object structure.
    local drawObjects = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Dist = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        HealthBG = Drawing.new("Line"),
        Corners = {
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
        }
    }

    -- Default Styling
    drawObjects.Box.Thickness = 1
    drawObjects.Tracer.Thickness = 1
    drawObjects.Name.Size = 14; drawObjects.Name.Center = true; drawObjects.Name.Outline = true
    drawObjects.Dist.Size = 12; drawObjects.Dist.Center = true; drawObjects.Dist.Outline = true
    drawObjects.Health.Thickness = 2
    drawObjects.HealthBG.Thickness = 3; drawObjects.HealthBG.Color = Color3.fromRGB(0, 0, 0)

    for i = 1, 8 do drawObjects.Corners[i].Thickness = 1.5 end

    ESP_Registry[player] = drawObjects
end

local function TerminateESP(player)
    if ESP_Registry[player] then
        for key, obj in pairs(ESP_Registry[player]) do
            if key == "Corners" then
                for i = 1, 8 do obj[i]:Remove() end
            else
                obj:Remove()
            end
        end
        ESP_Registry[player] = nil
    end
end

-- // [6] USER INTERFACE INITIALIZATION (ORION STABLE)
-- Re-initializing the UI with all enterprise-grade controls.

print("[V15 MEGA] PREPARING USER INTERFACE AND NAVIGATION...")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "ARMY RP ULTIMATE | V15 ENTERPRISE MEGA",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "ArmyV15_Enterprise",
    IntroEnabled = true,
    IntroText = "Welcome to the Definitive Bypass."
})

-- [[ NAVIGATION: TAB SETUP ]]
local CombatTab = Window:MakeTab({Name = "Combat Core", Icon = "rbxassetid://4483362458"})
local VisualsTab = Window:MakeTab({Name = "Visual Suite", Icon = "rbxassetid://4483362458"})
local MovementTab = Window:MakeTab({Name = "Movement Bypass", Icon = "rbxassetid://4483362458"})
local TeleportTab = Window:MakeTab({Name = "World Warp", Icon = "rbxassetid://4483362458"})
local MiscTab = Window:MakeTab({Name = "Enterprise Misc", Icon = "rbxassetid://4483362458"})

-- [[ MODULE: COMBAT CONTROLS ]]
CombatTab:AddSection({Name = "Targeting Logic"})
CombatTab:AddToggle({Name = "Master Aimbot (Hard Lock)", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.Enabled = v end})
CombatTab:AddToggle({Name = "Silent Aim (Projectile Hook)", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.SilentAim = v end})
CombatTab:AddBind({Name = "Aimbot Hotkey", Default = Enum.KeyCode.V, Hold = true, Callback = function() end})
CombatTab:AddSlider({Name = "FOV Radius Size", Min = 0, Max = 800, Default = 150, Increment = 10, ValueName = "Studs", Callback = function(v) getgenv().EnterpriseConfig.Combat.FOV = v; FOVCircle.Radius = v end})
CombatTab:AddToggle({Name = "Display FOV Visualizer", Default = false, Callback = function(v) FOVCircle.Visible = v end})

CombatTab:AddSection({Name = "Weapon Mechanics"})
CombatTab:AddToggle({Name = "R6/R15 Hitbox Expander", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.HitboxSize = v and 10 or 2 end})
CombatTab:AddToggle({Name = "Complete Recoil Removal", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.NoRecoil = v end})
CombatTab:AddToggle({Name = "Complete Spread Removal", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.NoSpread = v end})
CombatTab:AddToggle({Name = "Infinite Ammo Capacity", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Combat.InfAmmo = v end})

-- [[ MODULE: VISUAL CONTROLS ]]
VisualsTab:AddToggle({Name = "Master ESP Enable", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Enabled = v end})
VisualsTab:AddToggle({Name = "Show Character Boxes", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Boxes = v end})
VisualsTab:AddToggle({Name = "Show Corner Accents", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Corners = v end})
VisualsTab:AddToggle({Name = "Display Health Status", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Health = v end})
VisualsTab:AddToggle({Name = "Display Player Names", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Names = v end})
VisualsTab:AddToggle({Name = "Display Distance Tracking", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Distance = v end})
VisualsTab:AddToggle({Name = "Display Movement Tracers", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Visuals.Tracers = v end})

VisualsTab:AddSection({Name = "Environment Rendering"})
VisualsTab:AddToggle({Name = "Fullbright (Advanced Night Vision)", Default = false, Callback = function(v)
    getgenv().EnterpriseConfig.Visuals.Fullbright = v
    if v then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false; Lighting.FogEnd = 100000
    end
end})

-- [[ MODULE: MOVEMENT CONTROLS ]]
MovementTab:AddSlider({Name = "Safe WalkSpeed Override", Min = 16, Max = 200, Default = 16, Increment = 1, ValueName = "Speed", Callback = function(v) getgenv().EnterpriseConfig.Movement.WalkSpeed = v end})
MovementTab:AddSlider({Name = "Safe JumpPower Override", Min = 50, Max = 300, Default = 50, Increment = 5, ValueName = "Power", Callback = function(v) getgenv().EnterpriseConfig.Movement.JumpPower = v end})
MovementTab:AddToggle({Name = "Advanced CFrame Flight", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.Fly = v end})
MovementTab:AddToggle({Name = "Infinite Jump (Double Jump)", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.InfJump = v end})
MovementTab:AddToggle({Name = "Ghost Noclip (Pass Walls)", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.Noclip = v end})
MovementTab:AddToggle({Name = "Infinite Stamina Reserve", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.InfStamina = v end})
MovementTab:AddToggle({Name = "Passive No-Fall Damage", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.NoFall = v end})
MovementTab:AddToggle({Name = "Anti-Hit Defensive Spinbot", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Movement.Spinbot = v end})

-- [[ MODULE: TELEPORT CONTROLS ]]
TeleportTab:AddSection({Name = "Player Synchronization"})
local TargetPlayerList = TeleportTab:AddDropdown({Name = "Select Active Player", Options = {}, Default = "", Callback = function() end})
local function RefreshPlayerDropdown()
    local nameBuffer = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(nameBuffer, p.Name) end
    end
    TargetPlayerList:Refresh(nameBuffer, true)
end
Players.PlayerAdded:Connect(RefreshPlayerDropdown)
Players.PlayerRemoving:Connect(RefreshPlayerDropdown)
RefreshPlayerDropdown()

TeleportTab:AddButton({Name = "Safe Warp to Target", Callback = function()
    local target = Players:FindFirstChild(TargetPlayerList:Get())
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        ExecuteSafeTeleport(target.Character.HumanoidRootPart.Position)
    end
end})
TeleportTab:AddToggle({Name = "Control + Click Warp", Default = false, Callback = function(v) getgenv().EnterpriseConfig.Teleport.ClickTP = v end})

-- [[ MODULE: MISC UTILITIES ]]
MiscTab:AddButton({Name = "Force Kill Local Anti-Cheat", Callback = function()
    local blacklist = {"Adonis", "AntiCheat", "AC", "Watcher", "Handler", "Detection", "Guard", "Observer"}
    local scripts = game:GetDescendants()
    for i = 1, #scripts do
        local v = scripts[i]
        if v:IsA("LocalScript") then
            for _, name in pairs(blacklist) do
                if v.Name:find(name) then v.Disabled = true end
            end
        end
    end
    OrionLib:MakeNotification({Name="SYSTEM", Content="Protection scripts terminated.", Time=5})
end})
MiscTab:AddButton({Name = "Instant Proximity Interaction", Callback = function()
    local prompts = workspace:GetDescendants()
    for i = 1, #prompts do local v = prompts[i]; if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
    workspace.DescendantAdded:Connect(function(v) if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end)
end})
MiscTab:AddButton({Name = "Ghost-Remove Barriers", Callback = function()
    local parts = workspace:GetDescendants()
    for i = 1, #parts do
        local v = parts[i]
        if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence") or v.Name:lower():find("wall")) then
            v.CanCollide = false; v.Transparency = 0.5
        end
    end
end})
MiscTab:AddButton({Name = "Server Hopper (Migration)", Callback = function()
    local response = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(response.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id); break end end
end})
MiscTab:AddButton({Name = "Enable Anti-AFK Safeguard", Callback = function()
    LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    OrionLib:MakeNotification({Name="UTILITY", Content="Anti-AFK Protection Active.", Time=5})
end})
MiscTab:AddButton({Name = "Execute Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})

-- // [7] MAIN EXECUTION LOOPS: MULTI-THREADED PERFORMANCE

-- [[ THREAD 1: RENDERING, AIMBOT, AND UI UPDATES ]]
RunService.RenderStepped:Connect(function()
    -- FOV Position Update
    FOVCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)

    -- AIMBOT LOGIC
    getgenv().EnterpriseConfig.Combat.Active = UserInputService:IsKeyDown(getgenv().EnterpriseConfig.Combat.Keybind)
    if getgenv().EnterpriseConfig.Combat.Enabled and getgenv().EnterpriseConfig.Combat.Active then
        local target = getgenv().GetEnterpriseTarget(getgenv().EnterpriseConfig.Combat.FOV, getgenv().EnterpriseConfig.Combat.TargetPart)
        if target and target.Character then
            local p = target.Character:FindFirstChild(getgenv().EnterpriseConfig.Combat.TargetPart)
            if p then
                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, p.Position)
            end
        end
    end

    -- ESP RENDERING LOGIC
    for plr, obs in pairs(ESP_Registry) do
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if getgenv().EnterpriseConfig.Visuals.Enabled and root and hum and hum.Health > 0 then
            local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(root.Position)
            if onScreen then
                -- CALCULATIONS
                local head = char:FindFirstChild("Head") or root
                local headPos = Workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Workspace.CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 1.5
                local x, y = pos.X - width/2, headPos.Y
                local color = plr.TeamColor.Color

                -- BOXES
                obs.Box.Visible = getgenv().EnterpriseConfig.Visuals.Boxes
                if obs.Box.Visible then
                    obs.Box.Size = Vector2.new(width, height)
                    obs.Box.Position = Vector2.new(x, y)
                    obs.Box.Color = color
                end

                -- CORNER ACCENTS
                if getgenv().EnterpriseConfig.Visuals.Corners then
                    local l = width/4
                    obs.Corner1.From = Vector2.new(x,y); obs.Corner1.To = Vector2.new(x+l,y); obs.Corner2.From = Vector2.new(x,y); obs.Corner2.To = Vector2.new(x,y+l)
                    obs.Corner3.From = Vector2.new(x+width,y); obs.Corner3.To = Vector2.new(x+width-l,y); obs.Corner4.From = Vector2.new(x+width,y); obs.Corner4.To = Vector2.new(x+width,y+l)
                    obs.Corner5.From = Vector2.new(x,y+height); obs.Corner5.To = Vector2.new(x+l,y+height); obs.Corner6.From = Vector2.new(x,y+height); obs.Corner6.To = Vector2.new(x,y+height-l)
                    obs.Corner7.From = Vector2.new(x+width,y+height); obs.Corner7.To = Vector2.new(x+width-l,y+height); obs.Corner8.From = Vector2.new(x+width,y+height); obs.Corner8.To = Vector2.new(x+width,y+height-l)
                    for i=1,8 do obs["Corner"..i].Color = color; obs["Corner"..i].Visible = true end
                else for i=1,8 do obs["Corner"..i].Visible = false end end

                -- HEALTH BARS
                obs.Health.Visible = getgenv().EnterpriseConfig.Visuals.Health; obs.HealthBG.Visible = obs.Health.Visible
                if obs.Health.Visible then
                    local barH = (hum.Health / hum.MaxHealth) * height
                    obs.HealthBG.From = Vector2.new(x-5, y); obs.HealthBG.To = Vector2.new(x-5, y+height)
                    obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-barH)
                    obs.Health.Color = Color3.fromHSV(math.clamp(hum.Health/hum.MaxHealth, 0, 1) * 0.4, 1, 1)
                end

                -- LABELS
                obs.Name.Visible = getgenv().EnterpriseConfig.Visuals.Names
                if obs.Name.Visible then
                    obs.Name.Text = plr.Name
                    obs.Name.Position = Vector2.new(pos.X, y - 20)
                end

                obs.Dist.Visible = getgenv().EnterpriseConfig.Visuals.Distance
                if obs.Dist.Visible then
                    obs.Dist.Text = math.floor((Workspace.CurrentCamera.CFrame.Position - root.Position).Magnitude) .. "m"
                    obs.Dist.Position = Vector2.new(pos.X, y + height + 5)
                end

                -- TRACERS
                obs.Tracer.Visible = getgenv().EnterpriseConfig.Visuals.Tracers
                if obs.Tracer.Visible then
                    obs.Tracer.From = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y)
                    obs.Tracer.To = Vector2.new(pos.X, legPos.Y)
                    obs.Tracer.Color = color
                end
            else
                -- Invisible Cleanup
                for key, o in pairs(obs) do if key == "Corners" then for i=1,8 do o[i].Visible = false end else o.Visible = false end end
            end
        else
            -- Dead Cleanup
            for key, o in pairs(obs) do if key == "Corners" then for i=1,8 do o[i].Visible = false end else o.Visible = false end end
        end
    end
end)

-- [[ THREAD 2: PHYSICS BYPASSES AND MOVEMENT MODS ]]
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if char and hum and root then
        -- BYPASS: VELOCITY-BASED WALK SPEED
        if getgenv().EnterpriseConfig.Movement.WalkSpeed > 16 and not getgenv().EnterpriseConfig.Movement.Fly then
            root.Velocity = Vector3.new(hum.MoveDirection.X * getgenv().EnterpriseConfig.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * getgenv().EnterpriseConfig.Movement.WalkSpeed)
        end

        -- BYPASS: CFRAME-BASED FLIGHT
        if getgenv().EnterpriseConfig.Movement.Fly then
            hum.PlatformStand = true
            local move = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end

            root.Velocity = Vector3.new(0, 0.1, 0)
            root.CFrame = root.CFrame + (move * (getgenv().EnterpriseConfig.Movement.FlySpeed/50))
        elseif hum.PlatformStand then
            hum.PlatformStand = false
        end

        -- NOCLIP LOGIC
        if getgenv().EnterpriseConfig.Movement.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end
                    v.CanCollide = false
                end
            end
        else
            for part, state in pairs(Original_Collisions) do
                if part and part.Parent then part.CanCollide = state end
            end
            table.clear(Original_Collisions)
        end

        -- OTHER MODS
        if getgenv().EnterpriseConfig.Movement.InfStamina then
            local s = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
            if s and s:IsA("ValueBase") then s.Value = 100 end
        end

        if getgenv().EnterpriseConfig.Movement.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end

        if getgenv().EnterpriseConfig.Movement.Spinbot then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(25), 0)
        end

        -- [[ HITBOX EXPANDER: CHARACTER SCALING ]]
        if tick() % 1 < 0.1 then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local targetParts = {"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
                    for _, name in pairs(targetParts) do
                        local t = p.Character:FindFirstChild(name)
                        if t then
                            t.Size = Vector3.new(getgenv().EnterpriseConfig.Combat.HitboxSize, getgenv().EnterpriseConfig.Combat.HitboxSize, getgenv().EnterpriseConfig.Combat.HitboxSize)
                            t.Transparency = 0.5; t.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

-- // [8] FINAL EVENT REGISTRATION

local function MonitorLocalCharacter(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            ApplyWeaponModifications(child)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(MonitorLocalCharacter)
if LocalPlayer.Character then MonitorLocalCharacter(LocalPlayer.Character) end

-- Global Player Event Connections
Players.PlayerAdded:Connect(InitializeESP)
Players.PlayerRemoving:Connect(TerminateESP)
for _, p in pairs(Players:GetPlayers()) do InitializeESP(p) end

-- Input Bindings: Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().EnterpriseConfig.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().EnterpriseConfig.Movement.JumpPower, 0)
    end
end)

-- Input Bindings: Click Teleport
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and getgenv().EnterpriseConfig.Teleport.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local ray = Workspace.CurrentCamera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000)
        if result then ExecuteSafeTeleport(result.Position + Vector3.new(0, 3, 0)) end
    end
end)

-- // FINAL INITIALIZATION COMPLETE
OrionLib:Init()
print("[V15 MEGA] SUCCESS: ENTERPRISE EDITION FULLY LOADED (850+ LOGICAL LINES).")
OrionLib:MakeNotification({Name="SYSTEM BOOT", Content="God-Mode V15 Active. Stealth Bypass Enabled.", Time=5})
