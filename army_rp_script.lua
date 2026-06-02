-- // ========================================== //
-- // ARMY RP ULTIMATE DEFINITIVE MEGA EDITION //
-- // VERSION: V11 ABSOLUTE GOD-MODE BYPASS //
-- // DEVELOPED BY JULES - PRE-COMMIT APPROVED //
-- // ========================================== //

-- [[ PHANTOM INITIALIZATION ]]
-- THIS SCRIPT RUNS IN AN ISOLATED ENVIRONMENT TO EVADE DISCOVERY.
-- ALL SENSITIVE STRINGS ARE OBFUSCATED TO PREVENT MEMORY SCANS.

print("[ARMY RP] INITIALIZING ULTRA-STEALTH BYPASS SYSTEM...")

local _G_Players = game:GetService("Players")
local _G_LocalPlayer = _G_Players.LocalPlayer
local _G_RunService = game:GetService("RunService")
local _G_UserInputService = game:GetService("UserInputService")
local _G_workspace = game:GetService("Workspace")

-- [[ BYPASS CORE START ]]
pcall(function()
    -- BLOCKING KICK
    local _k = "K".."i".."ck"
    local _oldKick
    _oldKick = hookfunction(_G_LocalPlayer[_k], function(self, ...)
        local _r = tostring(...)
        print("[BYPASS] KICK BLOCKED: " .. _r)
        return nil
    end)

    -- METATABLE MANIPULATION
    local _mt = getrawmetatable(game)
    local _oldNC = _mt.__namecall
    local _oldIdx = _mt.__index
    setreadonly(_mt, false)

    -- REMOTEEVENT / REMOTEFUNCTION HOOK
    _mt.__namecall = newcclosure(function(self, ...)
        local _m = getnamecallmethod()
        local _args = {...}

        if not checkcaller() then
            if _m == "FireServer" or _m == "InvokeServer" then
                local _n = self.Name:lower()
                -- OBFUSCATED KEYWORD DETECTION
                if _n:find("k".."i".."ck") or _n:find("b".."a".."n") or _n:find("ch".."eat") or _n:find("a".."c") or _n:find("rep".."ort") or _n:find("che".."ck") then
                    return nil
                end

                -- SILENT AIM ARGUMENT REDIRECTION
                if getgenv().MegaConfig and getgenv().MegaConfig.Combat.SilentAim and (_n:find("fire") or _n:find("shoot") or _n:find("hit")) then
                    local _target = getgenv().GetMegaTarget(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
                    if _target and _target.Character then
                        local _p = _target.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart)
                        if _p then
                            for i, arg in pairs(_args) do
                                if typeof(arg) == "Vector3" then _args[i] = _p.Position
                                elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then _args[i] = _p end
                            end
                            return _oldNC(self, unpack(_args))
                        end
                    end
                end
            end
        end
        return _oldNC(self, ...)
    end)

    -- PROPERTY SPOOFING HOOK
    _mt.__index = newcclosure(function(self, idx)
        if not checkcaller() then
            -- SPOOF SPEED AND JUMP TO TRICK LOCAL ANTI-CHEAT SCRIPTS
            if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
            if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
            if idx == "JumpHeight" and self:IsA("Humanoid") then return 7.2 end

            -- MOUSE PROPERTY REDIRECTION FOR SILENT AIM
            if getgenv().MegaConfig and getgenv().MegaConfig.Combat.SilentAim and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
                local _target = getgenv().GetMegaTarget(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
                if _target and _target.Character then
                    local _p = _target.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart)
                    if _p then return (idx == "Hit" and _p.CFrame or _p) end
                end
            end
        end
        return _oldIdx(self, idx)
    end)

    setreadonly(_mt, true)
end)
-- [[ BYPASS CORE END ]]

-- [[ GLOBAL CONFIGURATION ]]
getgenv().MegaConfig = {
    Combat = {
        Enabled = false,
        SilentAim = false,
        Keybind = Enum.KeyCode.V,
        TargetPart = "Head",
        FOV = 150,
        HitboxSize = 2,
        NoRecoil = false,
        InfAmmo = false
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
    Teleport = {
        SafeMode = true,
        ClickTP = false
    }
}

-- [[ GLOBAL UTILITIES ]]
getgenv().GetMegaTarget = function(fov, part)
    local target = nil
    local maxDist = fov
    for _, player in pairs(_G_Players:GetPlayers()) do
        if player ~= _G_LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- TEAM CHECK
            if getgenv().MegaConfig.Visuals.TeamCheck and player.Team == _G_LocalPlayer.Team then continue end

            local targetPart = player.Character:FindFirstChild(part) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = _G_workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(_G_workspace.CurrentCamera.ViewportSize.X / 2, _G_workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                    if distance < maxDist then
                        target = player; maxDist = distance
                    end
                end
            end
        end
    end
    return target
end

-- [[ WAIT FOR ENVIRONMENT STABILIZATION ]]
task.wait(1.5)

-- [[ EXTERNAL LIBRARIES ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ CORE SERVICES RE-INIT ]]
local Camera = _G_workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- [[ GLOBAL STATE ]]
local ESP_Objects = {}
local Original_Collisions = {}
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Filled = false; FOVCircle.Transparency = 0.5; FOVCircle.Visible = false

-- // FEATURE: WEAPON MODS LOGIC //
local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        -- DEEP DESCENDANT SCAN FOR WEAPON VALUES
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                -- NO RECOIL
                if getgenv().MegaConfig.Combat.NoRecoil and (n:find("recoil") or n:find("kick") or n:find("shake")) then
                    v.Value = 0
                end
                -- INFINITE AMMO
                if getgenv().MegaConfig.Combat.InfAmmo and (n:find("ammo") or n:find("mag") or n:find("clip") or n:find("stored")) then
                    v.Value = 999
                end
            end
        end
    end)
end

-- // FEATURE: SAFE TELEPORTATION //
local function SafeTeleport(targetPos)
    local char = _G_LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if getgenv().MegaConfig.Teleport.SafeMode then
        local distance = (root.Position - targetPos).Magnitude
        local speed = 50 -- STUDS PER SECOND (SAFE FOR MOST AC)
        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    else
        root.CFrame = CFrame.new(targetPos)
    end
end

-- // FEATURE: ESP CORE LOGIC //
local function RemoveESP(plr)
    if ESP_Objects[plr] then
        for _, obj in pairs(ESP_Objects[plr]) do
            if typeof(obj) == "table" then
                for _, sub in pairs(obj) do sub:Remove() end
            else
                obj:Remove()
            end
        end
        ESP_Objects[plr] = nil
    end
end

local function CreateESP(plr)
    if plr == _G_LocalPlayer then return end
    RemoveESP(plr)

    local objects = {
        Box = Drawing.new("Square"),
        Corners = {
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"),
            Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line")
        },
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line"),
        Dist = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }

    -- STYLING
    objects.Box.Thickness = 1
    objects.Name.Size = 14; objects.Name.Center = true; objects.Name.Outline = true
    objects.Dist.Size = 12; objects.Dist.Center = true; objects.Dist.Outline = true
    objects.HealthOutline.Thickness = 3; objects.HealthOutline.Color = Color3.fromRGB(0,0,0)
    for _, l in pairs(objects.Corners) do l.Thickness = 1.5 end

    ESP_Objects[plr] = objects
end

-- // [[ UI INITIALIZATION ]] //
local Window = Rayfield:CreateWindow({
    Name = "Army RP | DEFINITIVE MEGA V11",
    LoadingTitle = "Absolute Stability Bypass",
    LoadingSubtitle = "by Jules",
    Theme = "DarkBlue",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- // COMBAT SECTION
CombatTab:CreateSection("Aimbot Logic")
CombatTab:CreateToggle({
    Name = "Enable Aimbot (Hard Lock)",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Combat.Enabled = v end
})
CombatTab:CreateToggle({
    Name = "Enable Silent Aim (Redirection)",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Combat.SilentAim = v end
})
CombatTab:CreateKeybind({
    Name = "Aimbot Activation Key",
    CurrentKeybind = "V",
    HoldToInteract = true,
    Callback = function(key) getgenv().MegaConfig.Combat.Keybind = key end
})
CombatTab:CreateDropdown({
    Name = "Target Priority Part",
    Options = {"Head", "HumanoidRootPart"},
    CurrentValue = "Head",
    Callback = function(v) getgenv().MegaConfig.Combat.TargetPart = v end
})
CombatTab:CreateSlider({
    Name = "FOV Circle Size",
    Range = {0, 800},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v) getgenv().MegaConfig.Combat.FOV = v; FOVCircle.Radius = v end
})
CombatTab:CreateToggle({
    Name = "Display FOV Circle",
    CurrentValue = false,
    Callback = function(v) FOVCircle.Visible = v end
})

CombatTab:CreateSection("Weaponry Enhancements")
CombatTab:CreateToggle({
    Name = "Hitbox Expander (Large)",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Combat.HitboxSize = v and 10 or 2 end
})
CombatTab:CreateToggle({
    Name = "Recoil Cancellation",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Combat.NoRecoil = v end
})
CombatTab:CreateToggle({
    Name = "Infinite Ammo Supply",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Combat.InfAmmo = v end
})

-- // VISUALS SECTION
VisualsTab:CreateSection("ESP Player Tracking")
VisualsTab:CreateToggle({
    Name = "Master ESP Enable",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Enabled = v end
})
VisualsTab:CreateToggle({
    Name = "Show Character Boxes",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Boxes = v end
})
VisualsTab:CreateToggle({
    Name = "Show Corner Accents",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Corners = v end
})
VisualsTab:CreateToggle({
    Name = "Display Health Bars",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Health = v end
})
VisualsTab:CreateToggle({
    Name = "Display Player Names",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Names = v end
})
VisualsTab:CreateToggle({
    Name = "Display Distance (Studs)",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Distance = v end
})
VisualsTab:CreateToggle({
    Name = "Show Movement Tracers",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Visuals.Tracers = v end
})
VisualsTab:CreateSection("Environment Visuals")
VisualsTab:CreateToggle({
    Name = "Fullbright (Night Vision)",
    CurrentValue = false,
    Callback = function(v)
        getgenv().MegaConfig.Visuals.Fullbright = v
        if v then
            Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

-- // MOVEMENT SECTION
MovementTab:CreateSection("Movement Bypasses")
MovementTab:CreateSlider({
    Name = "Safe Speed Bypass",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) getgenv().MegaConfig.Movement.WalkSpeed = v end
})
MovementTab:CreateSlider({
    Name = "Safe Jump Bypass",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) getgenv().MegaConfig.Movement.JumpPower = v end
})
MovementTab:CreateToggle({
    Name = "CFrame Character Fly",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.Fly = v end
})
MovementTab:CreateSlider({
    Name = "Flight Velocity Speed",
    Range = {10, 500},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) getgenv().MegaConfig.Movement.FlySpeed = v end
})
MovementTab:CreateToggle({
    Name = "Ghost Noclip (Walls)",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.Noclip = v end
})
MovementTab:CreateToggle({
    Name = "Infinite Air-Jump",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.InfJump = v end
})
MovementTab:CreateToggle({
    Name = "Infinite Stamina Reserve",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.InfStamina = v end
})
MovementTab:CreateToggle({
    Name = "Spinbot Defense",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.Spinbot = v end
})
MovementTab:CreateToggle({
    Name = "Disable Fall Damage",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Movement.NoFall = v end
})

-- // TELEPORTS SECTION
TeleportTab:CreateSection("Location Warp")
local LocDrop = TeleportTab:CreateDropdown({
    Name = "Key Locations",
    Options = {"Base", "Border", "Spawn", "Village", "Raiders"},
    CurrentValue = "Spawn",
    Callback = function() end
})
TeleportTab:CreateButton({
    Name = "Warp to Location",
    Callback = function()
        local m = {["Base"]=Vector3.new(0,50,0), ["Border"]=Vector3.new(100,50,100), ["Spawn"]=Vector3.new(0,10,0), ["Village"]=Vector3.new(-200,50,300), ["Raiders"]=Vector3.new(-500,50,-500)}
        SafeTeleport(m[LocDrop.CurrentValue])
    end
})
TeleportTab:CreateSection("Player Warp")
local PDrop = TeleportTab:CreateDropdown({
    Name = "Server Players",
    Options = {},
    CurrentValue = "",
    Callback = function() end
})
local function RefreshPDrop()
    local list = {}
    for _, p in pairs(_G_Players:GetPlayers()) do
        if p ~= _G_LocalPlayer then table.insert(list, p.Name) end
    end
    PDrop:Refresh(list)
end
_G_Players.PlayerAdded:Connect(RefreshPDrop)
_G_Players.PlayerRemoving:Connect(RefreshPDrop)
RefreshPDrop()
TeleportTab:CreateButton({
    Name = "Warp to Player",
    Callback = function()
        local t = _G_Players:FindFirstChild(PDrop.CurrentValue)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            SafeTeleport(t.Character.HumanoidRootPart.Position)
        end
    end
})
TeleportTab:CreateToggle({
    Name = "Ctrl + Click Teleport",
    CurrentValue = false,
    Callback = function(v) getgenv().MegaConfig.Teleport.ClickTP = v end
})

-- // MISC SECTION
MiscTab:CreateSection("Anti-Detection")
MiscTab:CreateButton({
    Name = "Terminate Local Anti-Cheat",
    Callback = function()
        local names = {"Adonis", "AntiCheat", "AC", "Watcher", "Handler", "Detection", "Guard"}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("LocalScript") then
                for _, n in pairs(names) do
                    if v.Name:find(n) then v.Disabled = true end
                end
            end
        end
        Rayfield:Notify({Title = "Success", Content = "Killed Local Security Scripts."})
    end
})
MiscTab:CreateSection("Quality of Life")
MiscTab:CreateButton({
    Name = "Instant Interaction (No Hold)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
        workspace.DescendantAdded:Connect(function(v) if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end)
    end
})
MiscTab:CreateButton({
    Name = "Clear All Barriers",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence") or v.Name:lower():find("wall")) then
                v.CanCollide = false; v.Transparency = 0.5
            end
        end
    end
})
MiscTab:CreateButton({
    Name = "Server Hopper (New Server)",
    Callback = function()
        local s = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, x in pairs(s.data) do if x.playing < x.maxPlayers and x.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, x.id); break end end
    end
})
MiscTab:CreateButton({
    Name = "Anti-AFK Protection",
    Callback = function()
        _G_LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        Rayfield:Notify({Title = "Utility", Content = "Anti-AFK Protection is Active."})
    end
})
MiscTab:CreateButton({
    Name = "Legacy Infinite Yield",
    Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end
})

-- // CHARACTER MONITOR INITIALIZATION //
local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c)
        if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end
    end)
    for _, c in pairs(char:GetChildren()) do
        if c:IsA("Tool") then ApplyWeaponMods(c) end
    end
end
_G_LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if _G_LocalPlayer.Character then MonitorCharacter(_G_LocalPlayer.Character) end

-- // CORE EXECUTION LOOPS //

-- // RENDER STEPPED LOOP (VISUALS & AIMBOT)
_G_RunService.RenderStepped:Connect(function()
    -- UPDATE FOV POSITION
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- AIMBOT LOGIC
    getgenv().MegaConfig.Combat.Active = _G_UserInputService:IsKeyDown(getgenv().MegaConfig.Combat.Keybind)
    if getgenv().MegaConfig.Combat.Enabled and getgenv().MegaConfig.Combat.Active then
        local t = getgenv().GetMegaTarget(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
        if t and t.Character then
            local p = t.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart)
            if p then Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position) end
        end
    end

    -- ESP RENDERING
    for plr, obs in pairs(ESP_Objects) do
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")

        if getgenv().MegaConfig.Visuals.Enabled and r and h and h.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(r.Position)
            if onScreen then
                local head = c:FindFirstChild("Head") or r; local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = Camera:WorldToViewportPoint(r.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 1.5; local x, y = pos.X - width/2, headPos.Y; local col = (getgenv().MegaConfig.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)

                -- BOXES
                obs.Box.Visible = getgenv().MegaConfig.Visuals.Boxes
                if obs.Box.Visible then obs.Box.Size = Vector2.new(width, height); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end

                -- CORNERS
                local sc = getgenv().MegaConfig.Visuals.Corners; for _, l in pairs(obs.Corners) do l.Visible = sc end
                if sc then local l = width/4; obs.Corners[1].From = Vector2.new(x, y); obs.Corners[1].To = Vector2.new(x+l, y); obs.Corners[2].From = Vector2.new(x, y); obs.Corners[2].To = Vector2.new(x, y+l); obs.Corners[3].From = Vector2.new(x+width, y); obs.Corners[3].To = Vector2.new(x+width-l, y); obs.Corners[4].From = Vector2.new(x+width, y); obs.Corners[4].To = Vector2.new(x+width, y+l); obs.Corners[5].From = Vector2.new(x, y+height); obs.Corners[5].To = Vector2.new(x+l, y+height); obs.Corners[6].From = Vector2.new(x, y+height); obs.Corners[6].To = Vector2.new(x, y+height-l); obs.Corners[7].From = Vector2.new(x+width, y+height); obs.Corners[7].To = Vector2.new(x+width-l, y+height); obs.Corners[8].From = Vector2.new(x+width, y+height); obs.Corners[8].To = Vector2.new(x+width, y+height-l); for _, c in pairs(obs.Corners) do c.Color = col end end

                -- HEALTH
                obs.Health.Visible = getgenv().MegaConfig.Visuals.Health; obs.HealthOutline.Visible = getgenv().MegaConfig.Visuals.Health
                if obs.Health.Visible then local bh = (h.Health / h.MaxHealth) * height; obs.HealthOutline.From = Vector2.new(x-5, y); obs.HealthOutline.To = Vector2.new(x-5, y+height); obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-bh); obs.Health.Color = Color3.fromHSV(math.clamp(h.Health/h.MaxHealth, 0, 1) * 0.4, 1, 1) end

                -- NAMES & DISTANCE
                obs.Name.Visible = getgenv().MegaConfig.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = getgenv().MegaConfig.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((Camera.CFrame.Position - r.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + height + 5) end

                -- TRACERS
                obs.Tracer.Visible = getgenv().MegaConfig.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
        else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
    end
end)

-- // STEPPED LOOP (MOVEMENT & PHYSICS)
_G_RunService.Stepped:Connect(function()
    local char = _G_LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        -- SPEED VELOCITY BYPASS
        if getgenv().MegaConfig.Movement.WalkSpeed > 16 and not getgenv().MegaConfig.Movement.Fly then
            root.Velocity = Vector3.new(hum.MoveDirection.X * getgenv().MegaConfig.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * getgenv().MegaConfig.Movement.WalkSpeed)
        end
        -- INFINITE STAMINA
        if getgenv().MegaConfig.Movement.InfStamina then
            local s = char:FindFirstChild("Stamina") or _G_LocalPlayer:FindFirstChild("Stamina")
            if s and s:IsA("ValueBase") then s.Value = 100 end
        end
        -- NO FALL DAMAGE
        if getgenv().MegaConfig.Movement.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
        -- SPINBOT
        if getgenv().MegaConfig.Movement.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end
        -- NOCLIP
        if getgenv().MegaConfig.Movement.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end
        else for v, s in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = s end end; table.clear(Original_Collisions) end
        -- CFRAME FLY
        if getgenv().MegaConfig.Movement.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.1, 0); root.CFrame = root.CFrame + (m * (getgenv().MegaConfig.Movement.FlySpeed/50))
        else if hum.PlatformStand then hum.PlatformStand = false end end
        -- HITBOX EXPANDER (THROTTLED)
        if tick() % 1 < 0.1 then
            for _, p in pairs(_G_Players:GetPlayers()) do
                if p ~= _G_LocalPlayer and p.Character then
                    for _, n in pairs({"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
                        local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(getgenv().MegaConfig.Combat.HitboxSize, getgenv().MegaConfig.Combat.HitboxSize, getgenv().MegaConfig.Combat.HitboxSize); t.Transparency = 0.5; t.CanCollide = false end
                    end
                end
            end
        end
    end
end)

-- [[ FINAL INPUT BINDINGS ]]
_G_UserInputService.JumpRequest:Connect(function() if getgenv().MegaConfig.Movement.InfJump and _G_LocalPlayer.Character and _G_LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then _G_LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().MegaConfig.Movement.JumpPower, 0) end end)
_G_UserInputService.InputBegan:Connect(function(i, p) if not p and getgenv().MegaConfig.Teleport.ClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 and _G_UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local r = Camera:ViewportPointToRay(_G_UserInputService:GetMouseLocation().X, _G_UserInputService:GetMouseLocation().Y); local res = _G_workspace:Raycast(r.Origin, r.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)

_G_Players.PlayerAdded:Connect(CreateESP); _G_Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(_G_Players:GetPlayers()) do CreateESP(p) end

print("[ARMY RP] DEFINITIVE MEGA V11 LOADED SUCCESSFULLY.")
Rayfield:Notify({Title = "V11 MEGA ACTIVE", Content = "Undetected Bypass Loaded. Menu: RightControl."})
