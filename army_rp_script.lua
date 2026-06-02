-- // ========================================== //
-- // ARMY RP ULTIMATE V8 PHANTOM EDITION //
-- // THE "WHAT IS THIS?" BYPASS UPDATE //
-- // BY JULES //
-- // ========================================== //

-- // 1. IMMEDIATE ENVIRONMENT PROTECTION //
-- This part runs before the game scripts can initialize their detection loops.
local _rawmetatable = getrawmetatable(game)
local _oldNamecall = _rawmetatable.__namecall
local _oldIndex = _rawmetatable.__index
local _oldNewIndex = _rawmetatable.__newindex
local _oldKick = hookfunction(game.Players.LocalPlayer.Kick, function(self, ...)
    local reason = tostring(...)
    print("[STEALTH] Prevented Kick: " .. reason)
    return nil
end)

setreadonly(_rawmetatable, false)

-- // GLOBAL CONFIGURATION (getgenv for cross-script access) //
getgenv().PhantomConfig = {
    Combat = {
        Aimbot = false,
        SilentAim = false,
        Keybind = Enum.KeyCode.V,
        TargetPart = "Head",
        FOV = 150,
        HitboxSize = 2,
        NoRecoil = false,
        NoSpread = false,
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
    Vehicle = {
        Fly = false,
        Speed = 50
    },
    Teleport = {
        SafeMode = true,
        ClickTP = false
    }
}

-- // CORE SERVICES //
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- // BLOCK DETECTION SIGNALS //
_rawmetatable.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        if method == "FireServer" or method == "InvokeServer" then
            local name = self.Name:lower()
            -- Obfuscated keyword check
            if name:find("k".."i".."ck") or name:find("b".."a".."n") or name:find("che".."at") or name:find("re".."port") or name:find("check") or name:find("ac") then
                return nil
            end

            -- Silent Aim Redirection
            if getgenv().PhantomConfig.Combat.SilentAim and (name:find("shoot") or name:find("fire") or name:find("hit")) then
                local target = getgenv().GetPhantomTarget(getgenv().PhantomConfig.Combat.FOV, getgenv().PhantomConfig.Combat.TargetPart)
                if target and target.Character then
                    local part = target.Character:FindFirstChild(getgenv().PhantomConfig.Combat.TargetPart)
                    if part then
                        for i, arg in pairs(args) do
                            if typeof(arg) == "Vector3" then args[i] = part.Position
                            elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then args[i] = part end
                        end
                        return _oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    return _oldNamecall(self, ...)
end)

-- // SPOOF PROPERTIES (BYPASS SCANNERS) //
_rawmetatable.__index = newcclosure(function(self, idx)
    if not checkcaller() then
        if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
        if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
        if getgenv().PhantomConfig.Combat.SilentAim and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
            local target = getgenv().GetPhantomTarget(getgenv().PhantomConfig.Combat.FOV, getgenv().PhantomConfig.Combat.TargetPart)
            if target and target.Character then
                local part = target.Character:FindFirstChild(getgenv().PhantomConfig.Combat.TargetPart)
                if part then return (idx == "Hit" and part.CFrame or part) end
            end
        end
    end
    return _oldIndex(self, idx)
end)

setreadonly(_rawmetatable, true)

-- // UTILITIES //
getgenv().GetPhantomTarget = function(fov, part)
    local target = nil
    local maxDistance = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if getgenv().PhantomConfig.Visuals.TeamCheck and player.Team == LocalPlayer.Team then continue end
            local targetPart = player.Character:FindFirstChild(part) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if distance < maxDistance then
                        target = player; maxDistance = distance
                    end
                end
            end
        end
    end
    return target
end

local function SafeTeleport(targetPos)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if getgenv().PhantomConfig.Teleport.SafeMode then
        local tweenInfo = TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    else root.CFrame = CFrame.new(targetPos) end
end

local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                if getgenv().PhantomConfig.Combat.NoRecoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
                if getgenv().PhantomConfig.Combat.NoSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
                if getgenv().PhantomConfig.Combat.InfAmmo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
            end
        end
    end)
end

-- // ESP SYSTEM //
local ESP_Objects = {}
local function RemoveESP(plr)
    if ESP_Objects[plr] then
        for _, obj in pairs(ESP_Objects[plr]) do
            if typeof(obj) == "table" then for _, sub in pairs(obj) do sub:Remove() end else obj:Remove() end
        end
        ESP_Objects[plr] = nil
    end
end

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    RemoveESP(plr)
    local objects = {
        Box = Drawing.new("Square"),
        Corners = { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") },
        Name = Drawing.new("Text"), Health = Drawing.new("Line"), HealthOutline = Drawing.new("Line"), Dist = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    objects.Box.Thickness = 1; objects.Name.Size = 14; objects.Name.Center = true; objects.Name.Outline = true; objects.Dist.Size = 12; objects.Dist.Center = true; objects.Dist.Outline = true; objects.HealthOutline.Thickness = 3; objects.HealthOutline.Color = Color3.fromRGB(0,0,0)
    for _, l in pairs(objects.Corners) do l.Thickness = 1.5 end
    ESP_Objects[plr] = objects
end

-- // WAIT FOR STEALTH INJECTION //
task.wait(2)

-- // LOAD UI LIBRARY //
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Army RP | PHANTOM V8",
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

-- // COMBAT UI //
CombatTab:CreateSection("Targeting")
CombatTab:CreateToggle({ Name = "Enable Aimbot (Hard Lock)", Callback = function(v) getgenv().PhantomConfig.Combat.Aimbot = v end })
CombatTab:CreateToggle({ Name = "Enable Silent Aim", Callback = function(v) getgenv().PhantomConfig.Combat.SilentAim = v end })
CombatTab:CreateKeybind({ Name = "Aimbot Key", CurrentKeybind = "V", HoldToInteract = true, Callback = function(k) getgenv().PhantomConfig.Combat.Keybind = k end })
CombatTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "HumanoidRootPart"}, CurrentValue = "Head", Callback = function(v) getgenv().PhantomConfig.Combat.TargetPart = v end })
CombatTab:CreateSlider({ Name = "FOV Size", Range = {0, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) getgenv().PhantomConfig.Combat.FOV = v end })

CombatTab:CreateSection("Weapon Modifiers")
CombatTab:CreateToggle({ Name = "Hitbox Expander", Callback = function(v) getgenv().PhantomConfig.Combat.HitboxSize = v and 10 or 2 end })
CombatTab:CreateToggle({ Name = "No Recoil", Callback = function(v) getgenv().PhantomConfig.Combat.NoRecoil = v end })
CombatTab:CreateToggle({ Name = "No Spread", Callback = function(v) getgenv().PhantomConfig.Combat.NoSpread = v end })
CombatTab:CreateToggle({ Name = "Infinite Ammo", Callback = function(v) getgenv().PhantomConfig.Combat.InfAmmo = v end })

-- // VISUALS UI //
VisualsTab:CreateToggle({ Name = "Master Switch", Callback = function(v) getgenv().PhantomConfig.Visuals.Enabled = v end })
VisualsTab:CreateToggle({ Name = "Player Boxes", Callback = function(v) getgenv().PhantomConfig.Visuals.Boxes = v end })
VisualsTab:CreateToggle({ Name = "Corner Accents", Callback = function(v) getgenv().PhantomConfig.Visuals.Corners = v end })
VisualsTab:CreateToggle({ Name = "Health Indicators", Callback = function(v) getgenv().PhantomConfig.Visuals.Health = v end })
VisualsTab:CreateToggle({ Name = "Name Tags", Callback = function(v) getgenv().PhantomConfig.Visuals.Names = v end })
VisualsTab:CreateToggle({ Name = "Distance Tracking", Callback = function(v) getgenv().PhantomConfig.Visuals.Distance = v end })
VisualsTab:CreateToggle({ Name = "Movement Tracers", Callback = function(v) getgenv().PhantomConfig.Visuals.Tracers = v end })
VisualsTab:CreateToggle({ Name = "Fullbright (Night Vision)", Callback = function(v) getgenv().PhantomConfig.Visuals.Fullbright = v; if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) end end })

-- // MOVEMENT UI //
MovementTab:CreateSection("Character Bypass")
MovementTab:CreateSlider({ Name = "Safe WalkSpeed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) getgenv().PhantomConfig.Movement.WalkSpeed = v end })
MovementTab:CreateSlider({ Name = "Safe JumpPower", Range = {50, 300}, Increment = 5, CurrentValue = 50, Callback = function(v) getgenv().PhantomConfig.Movement.JumpPower = v end })
MovementTab:CreateToggle({ Name = "CFrame Flight", Callback = function(v) getgenv().PhantomConfig.Movement.Fly = v end })
MovementTab:CreateSlider({ Name = "Flight Speed", Range = {10, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) getgenv().PhantomConfig.Movement.FlySpeed = v end })
MovementTab:CreateToggle({ Name = "Ghost Noclip", Callback = function(v) getgenv().PhantomConfig.Movement.Noclip = v end })
MovementTab:CreateToggle({ Name = "Infinite Air-Jump", Callback = function(v) getgenv().PhantomConfig.Movement.InfJump = v end })
MovementTab:CreateToggle({ Name = "Infinite Stamina", Callback = function(v) getgenv().PhantomConfig.Movement.InfStamina = v end })
MovementTab:CreateToggle({ Name = "Passive No-Fall Damage", Callback = function(v) getgenv().PhantomConfig.Movement.NoFall = v end })
MovementTab:CreateToggle({ Name = "Defensive Spinbot", Callback = function(v) getgenv().PhantomConfig.Movement.Spinbot = v end })

-- // TELEPORTS UI //
TeleportTab:CreateSection("Quick Travel")
local QuickTPDropdown = TeleportTab:CreateDropdown({ Name = "Major Points", Options = {"Military Base", "The Border", "Village", "Raider Camp", "Spawn"}, CurrentValue = "Spawn", Callback = function() end })
TeleportTab:CreateButton({ Name = "Travel to Point", Callback = function() local m = {["Military Base"]=Vector3.new(0,50,0), ["The Border"]=Vector3.new(100,50,100), ["Village"]=Vector3.new(-200,50,300), ["Raider Camp"]=Vector3.new(-500,50,-500), ["Spawn"]=Vector3.new(0,10,0)}; SafeTeleport(m[QuickTPDropdown.CurrentValue]) end })
TeleportTab:CreateSection("Player Stalking")
local PList = TeleportTab:CreateDropdown({ Name = "Select Player", Options = {}, Callback = function() end })
local function UpdateList() local l = {}; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(l, p.Name) end end; PList:Refresh(l) end
Players.PlayerAdded:Connect(UpdateList); Players.PlayerRemoving:Connect(UpdateList); UpdateList()
TeleportTab:CreateButton({ Name = "Travel to Player", Callback = function() local t = Players:FindFirstChild(PList.CurrentValue); if t and t.Character then SafeTeleport(t.Character.HumanoidRootPart.Position) end end })
TeleportTab:CreateToggle({ Name = "Ctrl + Click Teleport", Callback = function(v) getgenv().PhantomConfig.Teleport.ClickTP = v end })

-- // MISC UI //
MiscTab:CreateSection("Advanced Utilities")
MiscTab:CreateButton({ Name = "Instant Interaction (E)", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end; workspace.DescendantAdded:Connect(function(v) if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end) end })
MiscTab:CreateButton({ Name = "Local Part Eraser (Barriers)", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence") or v.Name:lower():find("wall")) then v.CanCollide = false; v.Transparency = 0.5 end end end })
MiscTab:CreateButton({ Name = "Anti-AFK Kicker", Callback = function() LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end })
MiscTab:CreateButton({ Name = "Server Hopper", Callback = function() local s = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")); for _, x in pairs(s.data) do if x.playing < x.maxPlayers and x.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, x.id); break end end end })
MiscTab:CreateButton({ Name = "Infinite Yield (Admin Panel)", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

-- // LOOPS AND LOGIC //
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")

local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end end)
    for _, c in pairs(char:GetChildren()) do if c:IsA("Tool") then ApplyWeaponMods(c) end end
end
LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if LocalPlayer.Character then MonitorCharacter(LocalPlayer.Character) end

RunService.RenderStepped:Connect(function()
    -- Aimbot Key
    getgenv().PhantomConfig.Combat.Active = UserInputService:IsKeyDown(getgenv().PhantomConfig.Combat.Keybind)
    if getgenv().PhantomConfig.Combat.Aimbot and getgenv().PhantomConfig.Combat.Active then
        local t = getgenv().GetPhantomTarget(getgenv().PhantomConfig.Combat.FOV, getgenv().PhantomConfig.Combat.TargetPart)
        if t and t.Character then
            local p = t.Character:FindFirstChild(getgenv().PhantomConfig.Combat.TargetPart)
            if p then Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position) end
        end
    end
    -- ESP Rendering
    for plr, obs in pairs(ESP_Objects) do
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")
        if getgenv().PhantomConfig.Visuals.Enabled and r and h and h.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(r.Position)
            if onScreen then
                local head = c:FindFirstChild("Head") or r; local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = Camera:WorldToViewportPoint(r.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 1.5; local x, y = pos.X - width/2, headPos.Y; local col = (getgenv().PhantomConfig.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                obs.Box.Visible = getgenv().PhantomConfig.Visuals.Boxes; if obs.Box.Visible then obs.Box.Size = Vector2.new(width, height); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end
                local sc = getgenv().PhantomConfig.Visuals.Corners; for _, l in pairs(obs.Corners) do l.Visible = sc end
                if sc then local l = width/4; obs.Corners[1].From = Vector2.new(x, y); obs.Corners[1].To = Vector2.new(x+l, y); obs.Corners[2].From = Vector2.new(x, y); obs.Corners[2].To = Vector2.new(x, y+l); obs.Corners[3].From = Vector2.new(x+width, y); obs.Corners[3].To = Vector2.new(x+width-l, y); obs.Corners[4].From = Vector2.new(x+width, y); obs.Corners[4].To = Vector2.new(x+width, y+l); obs.Corners[5].From = Vector2.new(x, y+height); obs.Corners[5].To = Vector2.new(x+l, y+height); obs.Corners[6].From = Vector2.new(x, y+height); obs.Corners[6].To = Vector2.new(x, y+height-l); obs.Corners[7].From = Vector2.new(x+width, y+height); obs.Corners[7].To = Vector2.new(x+width-l, y+height); obs.Corners[8].From = Vector2.new(x+width, y+height); obs.Corners[8].To = Vector2.new(x+width, y+height-l); for _, c in pairs(obs.Corners) do c.Color = col end end
                obs.Health.Visible = getgenv().PhantomConfig.Visuals.Health; obs.HealthOutline.Visible = getgenv().PhantomConfig.Visuals.Health
                if obs.Health.Visible then local bh = (h.Health / h.MaxHealth) * height; obs.HealthOutline.From = Vector2.new(x-5, y); obs.HealthOutline.To = Vector2.new(x-5, y+height); obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-bh); obs.Health.Color = Color3.fromHSV(math.clamp(h.Health/h.MaxHealth, 0, 1) * 0.4, 1, 1) end
                obs.Name.Visible = getgenv().PhantomConfig.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = getgenv().PhantomConfig.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((Camera.CFrame.Position - r.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + height + 5) end
                obs.Tracer.Visible = getgenv().PhantomConfig.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
        else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        -- Speed Velocity
        if getgenv().PhantomConfig.Movement.WalkSpeed > 16 and not getgenv().PhantomConfig.Movement.Fly then
            root.Velocity = Vector3.new(hum.MoveDirection.X * getgenv().PhantomConfig.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * getgenv().PhantomConfig.Movement.WalkSpeed)
        end
        -- CFrame Fly
        if getgenv().PhantomConfig.Movement.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.1, 0); root.CFrame = root.CFrame + (m * (getgenv().PhantomConfig.Movement.FlySpeed/50))
        else if hum.PlatformStand then hum.PlatformStand = false end end
        -- Noclip
        if getgenv().PhantomConfig.Movement.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end
        else for v, s in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = s end end; table.clear(Original_Collisions) end
        -- Spinbot
        if getgenv().PhantomConfig.Movement.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end
        -- Stamina
        if getgenv().PhantomConfig.Movement.InfStamina then
            local s = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
            if s and s:IsA("ValueBase") then s.Value = 100 end
        end
        -- No Fall
        if getgenv().PhantomConfig.Movement.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
        -- Vehicle Support
        local seat = hum.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if getgenv().PhantomConfig.Movement.Fly then vGyro.Parent = seat; vVelocity.Parent = seat; vGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); vGyro.CFrame = Camera.CFrame; local m = Vector3.new(0,0,0); if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end; vVelocity.Velocity = m * getgenv().PhantomConfig.Movement.FlySpeed
            else vGyro.Parent = nil; vVelocity.Parent = nil; if seat.Throttle ~= 0 then seat.Velocity = seat.CFrame.LookVector * getgenv().PhantomConfig.Movement.FlySpeed * seat.Throttle end end
        else vGyro.Parent = nil; vVelocity.Parent = nil end
        -- Hitbox expander
        if tick() % 1 < 0.1 then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, n in pairs({"Head", "Torso", "HumanoidRootPart"}) do
                        local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(getgenv().PhantomConfig.Combat.HitboxSize, getgenv().PhantomConfig.Combat.HitboxSize, getgenv().PhantomConfig.Combat.HitboxSize); t.Transparency = getgenv().PhantomConfig.Combat.HitboxSize > 2 and 0.5 or 0; t.CanCollide = false end
                    end
                end
            end
        end
    end
end)

-- // INPUTS //
UserInputService.JumpRequest:Connect(function() if getgenv().PhantomConfig.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().PhantomConfig.Movement.JumpPower, 0) end end)
UserInputService.InputBegan:Connect(function(i, p) if not p and getgenv().PhantomConfig.Teleport.ClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local r = Camera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y); local res = workspace:Raycast(r.Origin, r.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)

Players.PlayerAdded:Connect(CreateESP); Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

print("[Army RP] PHANTOM V8 LOADED SUCCESSFULLY.")
Rayfield:Notify({Title = "PHANTOM BYPASS", Content = "Script Ready. RightControl for Menu."})
