-- // ========================================== //
-- // ARMY RP ULTIMATE V7 ABSOLUTE STEALTH //
-- // BY JULES //
-- // ========================================== //

-- // 1. IMMEDIATE KICK PROTECTION (ABSOLUTE PRIORITY)
local _p = game:GetService("Players")
local _lp = _p.LocalPlayer

pcall(function()
    local _k = "K".."i".."c".."k"
    local _ok
    _ok = hookfunction(_lp[_k], function(self, ...)
        warn("[Army RP] Blocked kick: " .. tostring(...))
        return nil
    end)

    local _mt = getrawmetatable(game)
    local _onc = _mt.__namecall
    local _oidx = _mt.__index
    setreadonly(_mt, false)

    _mt.__namecall = newcclosure(function(self, ...)
        local _m = getnamecallmethod()
        local _args = {...}
        if not checkcaller() then
            if _m == "FireServer" then
                local _n = self.Name:lower()
                if _n:find("kick") or _n:find("ban") or _n:find("cheat") or _n:find("ac") or _n:find("report") then
                    return nil
                end

                -- [[ SILENT AIM LOGIC ]]
                if _G.Config.SilentAim.Enabled and (_n:find("shoot") or _n:find("fire") or _n:find("hit")) then
                    local _t = _G.GetClosestPlayer(_G.Config.SilentAim.FOV, _G.Config.SilentAim.TargetPart)
                    if _t and _t.Character then
                        local _part = _t.Character:FindFirstChild(_G.Config.SilentAim.TargetPart)
                        if _part then
                            for i, arg in pairs(_args) do
                                if typeof(arg) == "Vector3" then _args[i] = _part.Position
                                elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then _args[i] = _part end
                            end
                            return _onc(self, unpack(_args))
                        end
                    end
                end
            end
        end
        return _onc(self, ...)
    end)

    _mt.__index = newcclosure(function(self, idx)
        if not checkcaller() then
            if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
            if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
            -- SILENT AIM MOUSE HOOK
            if _G.Config.SilentAim.Enabled and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
                local _t = _G.GetClosestPlayer(_G.Config.SilentAim.FOV, _G.Config.SilentAim.TargetPart)
                if _t and _t.Character then
                    local _part = _t.Character:FindFirstChild(_G.Config.SilentAim.TargetPart)
                    if _part then return (idx == "Hit" and _part.CFrame or _part) end
                end
            end
        end
        return _oidx(self, idx)
    end)
    setreadonly(_mt, true)
end)

-- // 2. CONFIGURATION
_G.Config = {
    Aimbot = { Enabled = false, Keybind = Enum.KeyCode.V, TargetPart = "Head", FOV = 150, Active = false },
    SilentAim = { Enabled = false, FOV = 100, TargetPart = "Head" },
    Visuals = { Enabled = false, Boxes = false, Corners = false, Names = false, Health = false, Distance = false, Tracers = false, TeamCheck = true, Fullbright = false },
    Movement = { WalkSpeed = 16, JumpPower = 50, InfJump = false, Fly = false, FlySpeed = 50, Noclip = false, InfStamina = false, NoFall = false, Spinbot = false },
    Weapon = { NoRecoil = false, NoSpread = false, InfAmmo = false, HitboxSize = 2 },
    Teleport = { SafeMode = true, ClickTP = false }
}

-- // 3. CORE SERVICES
local Players = _p
local LocalPlayer = _lp
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- // GLOBALS
local ESP_Objects = {}
local Original_Collisions = {}
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Filled = false; FOVCircle.Transparency = 0.5; FOVCircle.Visible = false

-- // 4. UTILITIES
_G.GetClosestPlayer = function(fov, part)
    local target = nil
    local maxDistance = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if _G.Config.Visuals.TeamCheck and player.Team == LocalPlayer.Team then continue end
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

local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                if _G.Config.Weapon.NoRecoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
                if _G.Config.Weapon.NoSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
                if _G.Config.Weapon.InfAmmo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
            end
        end
    end)
end

local function SafeTeleport(targetPos)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if _G.Config.Teleport.SafeMode then
        local tweenInfo = TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    else root.CFrame = CFrame.new(targetPos) end
end

-- // 5. ESP SYSTEM
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

-- // 6. UI LOAD
print("[Army RP] Waiting for bypass stability...")
task.wait(2)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Army RP | V7 ABSOLUTE",
    LoadingTitle = "Absolute Stealth Mode",
    LoadingSubtitle = "by Jules",
    Theme = "DarkBlue",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")
local TeleportTab = Window:CreateTab("Teleports")
local MiscTab = Window:CreateTab("Misc")

-- [[ COMBAT UI ]]
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({ Name = "Enable Aimbot", Callback = function(v) _G.Config.Aimbot.Enabled = v end })
CombatTab:CreateKeybind({ Name = "Aimbot Key", CurrentKeybind = "V", HoldToInteract = true, Callback = function(key) _G.Config.Aimbot.Keybind = key end })
CombatTab:CreateDropdown({ Name = "Aimbot Target", Options = {"Head", "HumanoidRootPart"}, CurrentValue = "Head", Callback = function(v) _G.Config.Aimbot.TargetPart = v end })
CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({ Name = "Enable Silent Aim", Callback = function(v) _G.Config.SilentAim.Enabled = v end })
CombatTab:CreateSlider({ Name = "Silent FOV", Range = {0, 800}, Increment = 10, CurrentValue = 100, Callback = function(v) _G.Config.SilentAim.FOV = v end })

CombatTab:CreateSection("Weaponry")
CombatTab:CreateToggle({ Name = "Hitbox Expander", Callback = function(v) _G.Config.Weapon.HitboxSize = v and 10 or 2 end })
CombatTab:CreateToggle({ Name = "No Recoil", Callback = function(v) _G.Config.Weapon.NoRecoil = v end })
CombatTab:CreateToggle({ Name = "No Spread", Callback = function(v) _G.Config.Weapon.NoSpread = v end })
CombatTab:CreateToggle({ Name = "Infinite Ammo", Callback = function(v) _G.Config.Weapon.InfAmmo = v end })

-- [[ VISUALS UI ]]
VisualsTab:CreateToggle({ Name = "Enable Visuals", Callback = function(v) _G.Config.Visuals.Enabled = v end })
VisualsTab:CreateToggle({ Name = "Boxes", Callback = function(v) _G.Config.Visuals.Boxes = v end })
VisualsTab:CreateToggle({ Name = "Corners", Callback = function(v) _G.Config.Visuals.Corners = v end })
VisualsTab:CreateToggle({ Name = "Health Bar", Callback = function(v) _G.Config.Visuals.Health = v end })
VisualsTab:CreateToggle({ Name = "Names", Callback = function(v) _G.Config.Visuals.Names = v end })
VisualsTab:CreateToggle({ Name = "Distance", Callback = function(v) _G.Config.Visuals.Distance = v end })
VisualsTab:CreateToggle({ Name = "Tracers", Callback = function(v) _G.Config.Visuals.Tracers = v end })
VisualsTab:CreateToggle({ Name = "Fullbright", Callback = function(v) _G.Config.Visuals.Fullbright = v; if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) end end })

-- [[ MOVEMENT UI ]]
MovementTab:CreateSlider({ Name = "Speed", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(v) _G.Config.Movement.WalkSpeed = v end })
MovementTab:CreateSlider({ Name = "Jump", Range = {50, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) _G.Config.Movement.JumpPower = v end })
MovementTab:CreateToggle({ Name = "Fly", Callback = function(v) _G.Config.Movement.Fly = v end })
MovementTab:CreateToggle({ Name = "Noclip", Callback = function(v) _G.Config.Movement.Noclip = v end })
MovementTab:CreateToggle({ Name = "Infinite Jump", Callback = function(v) _G.Config.Movement.InfJump = v end })
MovementTab:CreateToggle({ Name = "Infinite Stamina", Callback = function(v) _G.Config.Movement.InfStamina = v end })
MovementTab:CreateToggle({ Name = "Spinbot", Callback = function(v) _G.Config.Movement.Spinbot = v end })
MovementTab:CreateToggle({ Name = "No Fall Damage", Callback = function(v) _G.Config.Movement.NoFall = v end })

-- [[ TELEPORTS UI ]]
TeleportTab:CreateSection("Player Teleport")
local PlayerTPDropdown = TeleportTab:CreateDropdown({ Name = "Select Player", Options = {}, CurrentValue = "", Callback = function() end })
local function RefreshPlayers() local list = {}; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end; PlayerTPDropdown:Refresh(list) end
Players.PlayerAdded:Connect(RefreshPlayers); Players.PlayerRemoving:Connect(RefreshPlayers); RefreshPlayers()
TeleportTab:CreateButton({ Name = "Teleport to Player", Callback = function() local target = Players:FindFirstChild(PlayerTPDropdown.CurrentValue); if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then SafeTeleport(target.Character.HumanoidRootPart.Position) end end })
TeleportTab:CreateToggle({ Name = "Ctrl + Click Teleport", CurrentValue = false, Callback = function(v) _G.Config.Teleport.ClickTP = v end })

-- [[ MISC UI ]]
MiscTab:CreateButton({ Name = "Disable Local AC", Callback = function() local n={"Adonis","AC"}; for _,v in pairs(game:GetDescendants()) do if v:IsA("LocalScript") then for _,x in pairs(n) do if v.Name:find(x) then v.Disabled=true end end end end end })
MiscTab:CreateButton({ Name = "Instant Interact", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration=0 end end end })
MiscTab:CreateButton({ Name = "Remove Barriers", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence")) then v.CanCollide=false; v.Transparency=0.5 end end end })
MiscTab:CreateButton({ Name = "Anti-AFK", Callback = function() LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end })
MiscTab:CreateButton({ Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

-- // 7. LOOPS
local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end end)
    for _, c in pairs(char:GetChildren()) do if c:IsA("Tool") then ApplyWeaponMods(c) end end
end
LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if LocalPlayer.Character then MonitorCharacter(LocalPlayer.Character) end

RunService.RenderStepped:Connect(function()
    _G.Config.Aimbot.Active = UserInputService:IsKeyDown(_G.Config.Aimbot.Keybind)
    if _G.Config.Aimbot.Enabled and _G.Config.Aimbot.Active then
        local t = _G.GetClosestPlayer(_G.Config.Aimbot.FOV, _G.Config.Aimbot.TargetPart)
        if t and t.Character then local p=t.Character:FindFirstChild(_G.Config.Aimbot.TargetPart); if p then Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position) end end
    end
    for plr, obs in pairs(ESP_Objects) do
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")
        if _G.Config.Visuals.Enabled and r and h and h.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(r.Position)
            if onScreen then
                local head = c:FindFirstChild("Head") or r; local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = Camera:WorldToViewportPoint(r.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 1.5; local x, y = pos.X - width/2, headPos.Y; local col = (_G.Config.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                obs.Box.Visible = _G.Config.Visuals.Boxes; if obs.Box.Visible then obs.Box.Size = Vector2.new(width, height); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end
                local sc = _G.Config.Visuals.Corners; for _, l in pairs(obs.Corners) do l.Visible = sc end
                if sc then local l = width/4; obs.Corners[1].From = Vector2.new(x, y); obs.Corners[1].To = Vector2.new(x+l, y); obs.Corners[2].From = Vector2.new(x, y); obs.Corners[2].To = Vector2.new(x, y+l); obs.Corners[3].From = Vector2.new(x+width, y); obs.Corners[3].To = Vector2.new(x+width-l, y); obs.Corners[4].From = Vector2.new(x+width, y); obs.Corners[4].To = Vector2.new(x+width, y+l); obs.Corners[5].From = Vector2.new(x, y+height); obs.Corners[5].To = Vector2.new(x+l, y+height); obs.Corners[6].From = Vector2.new(x, y+height); obs.Corners[6].To = Vector2.new(x, y+height-l); obs.Corners[7].From = Vector2.new(x+width, y+height); obs.Corners[7].To = Vector2.new(x+width-l, y+height); obs.Corners[8].From = Vector2.new(x+width, y+height); obs.Corners[8].To = Vector2.new(x+width, y+height-l); for _, c in pairs(obs.Corners) do c.Color = col end end
                obs.Health.Visible = _G.Config.Visuals.Health; obs.HealthOutline.Visible = _G.Config.Visuals.Health
                if obs.Health.Visible then local bh = (h.Health / h.MaxHealth) * height; obs.HealthOutline.From = Vector2.new(x-5, y); obs.HealthOutline.To = Vector2.new(x-5, y+height); obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-bh); obs.Health.Color = Color3.fromHSV(math.clamp(h.Health/h.MaxHealth, 0, 1) * 0.4, 1, 1) end
                obs.Name.Visible = _G.Config.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = _G.Config.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((Camera.CFrame.Position - r.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + height + 5) end
                obs.Tracer.Visible = _G.Config.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
        else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        if _G.Config.Movement.WalkSpeed > 16 and not _G.Config.Movement.Fly then root.Velocity = Vector3.new(hum.MoveDirection.X * _G.Config.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * _G.Config.Movement.WalkSpeed) end
        if _G.Config.Movement.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.1, 0); root.CFrame = root.CFrame + (m * (_G.Config.Movement.FlySpeed/50))
        else if hum.PlatformStand then hum.PlatformStand = false end end
        if _G.Config.Movement.Noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end else for v, state in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = state end end; table.clear(Original_Collisions) end
        if _G.Config.Movement.InfStamina then local s = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if _G.Config.Movement.NoFall then if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Running) end end
        if _G.Config.Movement.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end

        -- Vehicle Fly/Speed
        local seat = hum.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if _G.Config.Movement.Fly then vGyro.Parent = seat; vVelocity.Parent = seat; vGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); vGyro.CFrame = Camera.CFrame; local m = Vector3.new(0,0,0); if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end; vVelocity.Velocity = m * _G.Config.Movement.FlySpeed
            else vGyro.Parent = nil; vVelocity.Parent = nil; if seat.Throttle ~= 0 then seat.Velocity = seat.CFrame.LookVector * _G.Config.Movement.FlySpeed * seat.Throttle end end
        else vGyro.Parent = nil; vVelocity.Parent = nil end

        if tick() % 1 < 0.1 then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _, name in pairs({"Head", "Torso", "HumanoidRootPart"}) do local target = p.Character:FindFirstChild(name); if target then target.Size = Vector3.new(_G.Config.Weapon.HitboxSize, _G.Config.Weapon.HitboxSize, _G.Config.Weapon.HitboxSize); target.Transparency = _G.Config.Weapon.HitboxSize > 2 and 0.5 or 0; target.CanCollide = false end end end end end
    end
end)

UserInputService.JumpRequest:Connect(function() if _G.Config.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, _G.Config.Movement.JumpPower, 0) end end)
UserInputService.InputBegan:Connect(function(input, processed) if not processed and _G.Config.Teleport.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local ray = Camera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y); local res = workspace:Raycast(ray.Origin, ray.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)

Players.PlayerAdded:Connect(CreateESP); Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

print("[Army RP] Script fully loaded with God-Mode Bypasses!")
Rayfield:Notify({Title = "V7 ABSOLUTE", Content = "Script Ready. RightControl to Toggle UI."})
