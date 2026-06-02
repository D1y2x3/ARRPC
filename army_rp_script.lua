-- // ========================================== //
-- // ARMY RP ULTIMATE V10 DEFINITIVE EDITION //
-- // THE ABSOLUTE STABILITY & BYPASS UPDATE //
-- // BY JULES //
-- // ========================================== //

print("[Army RP] Initializing Definitive V10 Environment...")

-- // 1. ABSOLUTE PRIORITY BYPASSES (RUNS BEFORE ANYTHING)
local _Players = game:GetService("Players")
local _LocalPlayer = _Players.LocalPlayer

pcall(function()
    -- Block Kick method immediately
    local _oldKick
    _oldKick = hookfunction(_LocalPlayer.Kick, function(self, ...)
        warn("[Army RP] Blocked Kick Attempt! Reason: " .. tostring(...))
        return nil
    end)

    -- Universal Meta-Hooking
    local _mt = getrawmetatable(game)
    local _oldNC = _mt.__namecall
    local _oldIdx = _mt.__index
    setreadonly(_mt, false)

    -- Intercept detection signals
    _mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if not checkcaller() then
            if method == "FireServer" or method == "InvokeServer" then
                local n = self.Name:lower()
                if n:find("kick") or n:find("ban") or n:find("cheat") or n:find("ac") or n:find("report") or n:find("check") then
                    return nil
                end

                -- [[ SILENT AIM LOGIC ]]
                if getgenv().ArmyConfig and getgenv().ArmyConfig.Combat.SilentAim and (n:find("fire") or n:find("shoot") or n:find("hit")) then
                    local target = getgenv().GetClosest(getgenv().ArmyConfig.Combat.FOV, getgenv().ArmyConfig.Combat.TargetPart)
                    if target and target.Character then
                        local part = target.Character:FindFirstChild(getgenv().ArmyConfig.Combat.TargetPart)
                        if part then
                            for i, arg in pairs(args) do
                                if typeof(arg) == "Vector3" then args[i] = part.Position
                                elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then args[i] = part end
                            end
                            return _oldNC(self, unpack(args))
                        end
                    end
                end
            end
        end
        return _oldNC(self, ...)
    end)

    -- Spoof property checks
    _mt.__index = newcclosure(function(self, idx)
        if not checkcaller() then
            if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
            if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
            -- Mouse redirect for Silent Aim
            if getgenv().ArmyConfig and getgenv().ArmyConfig.Combat.SilentAim and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
                local target = getgenv().GetClosest(getgenv().ArmyConfig.Combat.FOV, getgenv().ArmyConfig.Combat.TargetPart)
                if target and target.Character then
                    local part = target.Character:FindFirstChild(getgenv().ArmyConfig.Combat.TargetPart)
                    if part then return (idx == "Hit" and part.CFrame or part) end
                end
            end
        end
        return _oldIdx(self, idx)
    end)
    setreadonly(_mt, true)
end)

-- // 2. GLOBAL CONFIGURATION
getgenv().ArmyConfig = {
    Combat = { Enabled = false, Keybind = Enum.KeyCode.V, TargetPart = "Head", FOV = 150, HitboxSize = 2, SilentAim = false, NoRecoil = false, NoSpread = false, InfAmmo = false },
    Visuals = { Enabled = false, Boxes = false, Corners = false, Names = false, Health = false, Distance = false, Tracers = false, TeamCheck = true, Fullbright = false },
    Movement = { WalkSpeed = 16, JumpPower = 50, InfJump = false, Fly = false, FlySpeed = 50, Noclip = false, InfStamina = false, NoFall = false, Spinbot = false },
    Teleport = { SafeMode = true, ClickTP = false }
}

-- // 3. SERVICES & GLOBALS
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local ESP_Objects = {}
local Original_Collisions = {}
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Filled = false; FOVCircle.Transparency = 0.5; FOVCircle.Visible = false

-- // 4. CORE UTILITIES
getgenv().GetClosest = function(fov, part)
    local target = nil
    local maxDist = fov
    for _, player in pairs(_Players:GetPlayers()) do
        if player ~= _LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if getgenv().ArmyConfig.Visuals.TeamCheck and player.Team == _LocalPlayer.Team then continue end
            local targetPart = player.Character:FindFirstChild(part) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if distance < maxDist then target = player; maxDist = distance end
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
                if getgenv().ArmyConfig.Combat.NoRecoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
                if getgenv().ArmyConfig.Combat.NoSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
                if getgenv().ArmyConfig.Combat.InfAmmo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
            end
        end
    end)
end

local function SafeTeleport(targetPos)
    local char = _LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if getgenv().ArmyConfig.Teleport.SafeMode then
        TweenService:Create(root, TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
    else root.CFrame = CFrame.new(targetPos) end
end

-- // 5. ESP CORE
local function RemoveESP(plr)
    if ESP_Objects[plr] then
        for _, obj in pairs(ESP_Objects[plr]) do
            if typeof(obj) == "table" then for _, sub in pairs(obj) do sub:Remove() end else obj:Remove() end
        end
        ESP_Objects[plr] = nil
    end
end

local function CreateESP(plr)
    if plr == _LocalPlayer then return end
    RemoveESP(plr)
    local obs = {
        Box = Drawing.new("Square"),
        Corners = { Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line"), Drawing.new("Line") },
        Name = Drawing.new("Text"), Health = Drawing.new("Line"), HealthBG = Drawing.new("Line"), Dist = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    obs.Box.Thickness = 1; obs.Name.Size = 14; obs.Name.Center = true; obs.Name.Outline = true; obs.Dist.Size = 12; obs.Dist.Center = true; obs.Dist.Outline = true; obs.Health.Thickness = 2; obs.HealthBG.Thickness = 3; obs.HealthBG.Color = Color3.fromRGB(0,0,0)
    for _, l in pairs(obs.Corners) do l.Thickness = 1.5 end
    ESP_Objects[plr] = obs
end

-- // 6. UI INITIALIZATION
print("[Army RP] Fetching UI library...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Army RP | V10 DEFINITIVE",
    LoadingTitle = "Undetected God-Mode",
    LoadingSubtitle = "by Jules",
    Theme = "DarkBlue",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")
local TeleportTab = Window:CreateTab("Teleports")
local MiscTab = Window:CreateTab("Misc")

-- COMBAT UI
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({ Name = "Hard-Lock Aimbot", Callback = function(v) getgenv().ArmyConfig.Combat.Enabled = v end })
CombatTab:CreateToggle({ Name = "Silent Aim", Callback = function(v) getgenv().ArmyConfig.Combat.SilentAim = v end })
CombatTab:CreateKeybind({ Name = "Aimbot Bind", CurrentKeybind = "V", HoldToInteract = true, Callback = function(k) getgenv().ArmyConfig.Combat.Keybind = k end })
CombatTab:CreateSlider({ Name = "FOV Size", Range = {0, 800}, Increment = 10, CurrentValue = 150, Callback = function(v) getgenv().ArmyConfig.Combat.FOV = v; FOVCircle.Radius = v end })
CombatTab:CreateToggle({ Name = "Show FOV", Callback = function(v) FOVCircle.Visible = v end })
CombatTab:CreateSection("Weaponry")
CombatTab:CreateToggle({ Name = "Hitbox Expander", Callback = function(v) getgenv().ArmyConfig.Combat.HitboxSize = v and 10 or 2 end })
CombatTab:CreateToggle({ Name = "No Recoil", Callback = function(v) getgenv().ArmyConfig.Combat.NoRecoil = v end })
CombatTab:CreateToggle({ Name = "No Spread", Callback = function(v) getgenv().ArmyConfig.Combat.NoSpread = v end })
CombatTab:CreateToggle({ Name = "Infinite Ammo", Callback = function(v) getgenv().ArmyConfig.Combat.InfAmmo = v end })

-- VISUALS UI
VisualsTab:CreateToggle({ Name = "Enable Visuals", Callback = function(v) getgenv().ArmyConfig.Visuals.Enabled = v end })
VisualsTab:CreateToggle({ Name = "Boxes", Callback = function(v) getgenv().ArmyConfig.Visuals.Boxes = v end })
VisualsTab:CreateToggle({ Name = "Corner Accents", Callback = function(v) getgenv().ArmyConfig.Visuals.Corners = v end })
VisualsTab:CreateToggle({ Name = "Health Indicators", Callback = function(v) getgenv().ArmyConfig.Visuals.Health = v end })
VisualsTab:CreateToggle({ Name = "Player Names", Callback = function(v) getgenv().ArmyConfig.Visuals.Names = v end })
VisualsTab:CreateToggle({ Name = "Distance Info", Callback = function(v) getgenv().ArmyConfig.Visuals.Distance = v end })
VisualsTab:CreateToggle({ Name = "Movement Tracers", Callback = function(v) getgenv().ArmyConfig.Visuals.Tracers = v end })
VisualsTab:CreateToggle({ Name = "Fullbright", Callback = function(v) getgenv().ArmyConfig.Visuals.Fullbright = v; if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) end end })

-- MOVEMENT UI
MovementTab:CreateSlider({ Name = "Bypass Speed", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) getgenv().ArmyConfig.Movement.WalkSpeed = v end })
MovementTab:CreateSlider({ Name = "Bypass Jump", Range = {50, 300}, Increment = 5, CurrentValue = 50, Callback = function(v) getgenv().ArmyConfig.Movement.JumpPower = v end })
MovementTab:CreateToggle({ Name = "Character Fly", Callback = function(v) getgenv().ArmyConfig.Movement.Fly = v end })
MovementTab:CreateToggle({ Name = "Infinite Air-Jump", Callback = function(v) getgenv().ArmyConfig.Movement.InfJump = v end })
MovementTab:CreateToggle({ Name = "No-Clip (Ghost)", Callback = function(v) getgenv().ArmyConfig.Movement.Noclip = v end })
MovementTab:CreateToggle({ Name = "Infinite Stamina", Callback = function(v) getgenv().ArmyConfig.Movement.InfStamina = v end })
MovementTab:CreateToggle({ Name = "No Fall Damage", Callback = function(v) getgenv().ArmyConfig.Movement.NoFall = v end })
MovementTab:CreateToggle({ Name = "Defensive Spinbot", Callback = function(v) getgenv().ArmyConfig.Movement.Spinbot = v end })

-- TELEPORTS UI
local PLList = TeleportTab:CreateDropdown({ Name = "Select Player", Options = {}, Callback = function() end })
local function UpdatePL() local l={}; for _,p in pairs(_Players:GetPlayers()) do if p ~= _LocalPlayer then table.insert(l, p.Name) end end; PLList:Refresh(l) end
_Players.PlayerAdded:Connect(UpdatePL); _Players.PlayerRemoving:Connect(UpdatePL); UpdatePL()
TeleportTab:CreateButton({ Name = "Teleport to Player", Callback = function() local t=_Players:FindFirstChild(PLList.CurrentValue); if t and t.Character then SafeTeleport(t.Character.HumanoidRootPart.Position) end end })
TeleportTab:CreateToggle({ Name = "Ctrl + Click TP", Callback = function(v) getgenv().ArmyConfig.Teleport.ClickTP = v end })

-- MISC UI
MiscTab:CreateButton({ Name = "Disable Local AC", Callback = function() local n={"Adonis","AC"}; for _,v in pairs(game:GetDescendants()) do if v:IsA("LocalScript") then for _,x in pairs(n) do if v.Name:find(x) then v.Disabled=true end end end end end })
MiscTab:CreateButton({ Name = "Instant Interaction", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration=0 end end end })
MiscTab:CreateButton({ Name = "Remove Barriers", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence")) then v.CanCollide=false; v.Transparency=0.5 end end end })
MiscTab:CreateButton({ Name = "Anti-AFK Protection", Callback = function() _LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end })
MiscTab:CreateButton({ Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

-- // 7. CHARACTER MONITOR
local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end end)
    for _, c in pairs(char:GetChildren()) do if c:IsA("Tool") then ApplyWeaponMods(c) end end
end
_LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if _LocalPlayer.Character then MonitorCharacter(_LocalPlayer.Character) end

-- // 8. MAIN LOOPS
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if getgenv().ArmyConfig.Combat.Enabled and UserInputService:IsKeyDown(getgenv().ArmyConfig.Combat.Keybind) then
        local t = getgenv().GetClosest(getgenv().ArmyConfig.Combat.FOV, getgenv().ArmyConfig.Combat.TargetPart)
        if t and t.Character then local p=t.Character:FindFirstChild(getgenv().ArmyConfig.Combat.TargetPart); if p then Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position) end end
    end
    for plr, obs in pairs(ESP_Objects) do
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")
        if getgenv().ArmyConfig.Visuals.Enabled and r and h and h.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(r.Position)
            if onScreen then
                local head = c:FindFirstChild("Head") or r; local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = Camera:WorldToViewportPoint(r.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 1.5; local x, y = pos.X - width/2, headPos.Y; local col = (getgenv().ArmyConfig.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                obs.Box.Visible = getgenv().ArmyConfig.Visuals.Boxes; if obs.Box.Visible then obs.Box.Size = Vector2.new(width, height); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end
                local sc = getgenv().ArmyConfig.Visuals.Corners; for _, l in pairs(obs.Corners) do l.Visible = sc end
                if sc then local l = width/4; obs.Corners[1].From = Vector2.new(x, y); obs.Corners[1].To = Vector2.new(x+l, y); obs.Corners[2].From = Vector2.new(x, y); obs.Corners[2].To = Vector2.new(x, y+l); obs.Corners[3].From = Vector2.new(x+width, y); obs.Corners[3].To = Vector2.new(x+width-l, y); obs.Corners[4].From = Vector2.new(x+width, y); obs.Corners[4].To = Vector2.new(x+width, y+l); obs.Corners[5].From = Vector2.new(x, y+height); obs.Corners[5].To = Vector2.new(x+l, y+height); obs.Corners[6].From = Vector2.new(x, y+height); obs.Corners[6].To = Vector2.new(x, y+height-l); obs.Corners[7].From = Vector2.new(x+width, y+height); obs.Corners[7].To = Vector2.new(x+width-l, y+height); obs.Corners[8].From = Vector2.new(x+width, y+height); obs.Corners[8].To = Vector2.new(x+width, y+height-l); for _, c in pairs(obs.Corners) do c.Color = col end end
                obs.Health.Visible = getgenv().ArmyConfig.Visuals.Health; obs.HealthBG.Visible = obs.Health.Visible
                if obs.Health.Visible then local bh = (h.Health / h.MaxHealth) * height; obs.HealthBG.From = Vector2.new(x-5, y); obs.HealthBG.To = Vector2.new(x-5, y+height); obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-bh); obs.Health.Color = Color3.fromHSV(math.clamp(h.Health/h.MaxHealth, 0, 1) * 0.4, 1, 1) end
                obs.Name.Visible = getgenv().ArmyConfig.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = getgenv().ArmyConfig.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((Camera.CFrame.Position - r.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + height + 5) end
                obs.Tracer.Visible = getgenv().ArmyConfig.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
        else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
    end
end)

RunService.Stepped:Connect(function()
    local c = _LocalPlayer.Character; local h = c and c:FindFirstChild("Humanoid"); local r = c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r then
        if getgenv().ArmyConfig.Movement.WalkSpeed > 16 and not getgenv().ArmyConfig.Movement.Fly then r.Velocity = Vector3.new(h.MoveDirection.X * getgenv().ArmyConfig.Movement.WalkSpeed, r.Velocity.Y, h.MoveDirection.Z * getgenv().ArmyConfig.Movement.WalkSpeed) end
        if getgenv().ArmyConfig.Movement.Fly then
            h.PlatformStand = true; local m = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            r.Velocity = Vector3.new(0, 0.1, 0); r.CFrame = r.CFrame + (m * (getgenv().ArmyConfig.Movement.FlySpeed/50))
        elseif h.PlatformStand then h.PlatformStand = false end
        if getgenv().ArmyConfig.Movement.Noclip then for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end else for v, s in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = s end end; table.clear(Original_Collisions) end
        if getgenv().ArmyConfig.Movement.InfStamina then local s = c:FindFirstChild("Stamina") or _LocalPlayer:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if getgenv().ArmyConfig.Movement.NoFall then if h:GetState() == Enum.HumanoidStateType.FallingDown or h:GetState() == Enum.HumanoidStateType.Freefall then h:ChangeState(Enum.HumanoidStateType.Running) end end
        if getgenv().ArmyConfig.Movement.Spinbot then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(20), 0) end

        -- Vehicle Support
        local seat = h.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if getgenv().ArmyConfig.Movement.Fly then
                vGyro.Parent = seat; vVelocity.Parent = seat; vGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); vGyro.CFrame = Camera.CFrame
                local m = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
                vVelocity.Velocity = m * getgenv().ArmyConfig.Movement.FlySpeed
            else
                vGyro.Parent = nil; vVelocity.Parent = nil
                if seat.Throttle ~= 0 then seat.Velocity = seat.CFrame.LookVector * getgenv().ArmyConfig.Movement.FlySpeed * seat.Throttle end
            end
        else vGyro.Parent = nil; vVelocity.Parent = nil end

        -- Hitbox Expansion
        if tick() % 1 < 0.1 then
            for _, p in pairs(_Players:GetPlayers()) do
                if p ~= _LocalPlayer and p.Character then
                    for _, n in pairs({"Head", "Torso", "HumanoidRootPart"}) do
                        local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(getgenv().ArmyConfig.Combat.HitboxSize, getgenv().ArmyConfig.Combat.HitboxSize, getgenv().ArmyConfig.Combat.HitboxSize); t.Transparency = 0.5; t.CanCollide = false end
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if getgenv().ArmyConfig.Movement.InfJump and _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then _LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().ArmyConfig.Movement.JumpPower, 0) end end)
UserInputService.InputBegan:Connect(function(i, p) if not p and getgenv().ArmyConfig.Teleport.ClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local r = Camera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y); local res = workspace:Raycast(r.Origin, r.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)
_Players.PlayerAdded:Connect(CreateESP); _Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(_Players:GetPlayers()) do CreateESP(p) end

print("[Army RP] V10 DEFINITIVE LOADED SUCCESSFULLY.")
Rayfield:Notify({Title = "V10 DEFINITIVE", Content = "Script Ready. RightControl for Menu."})
