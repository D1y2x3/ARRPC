-- // ULTRA STEALTH INITIALIZATION
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- BLOCK KICK IMMEDIATELY (BEFORE ANYTHING ELSE)
local _K = "K".."i".."c".."k"
local _oldKick
_oldKick = hookfunction(LocalPlayer[_K], function(self, ...)
    return nil
end)

local mt = getrawmetatable(game)
local _oldNC = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and method == "FireServer" then
        local n = self.Name:lower()
        if n:find("k".."i".."c".."k") or n:find("b".."a".."n") or n:find("c".."h".."e".."a".."t") or n:find("a".."c") then
            return nil
        end
    end
    return _oldNC(self, ...)
end)
setreadonly(mt, true)

-- WAIT BEFORE LOADING UI TO BYPASS STARTUP SCANNERS
task.wait(2)

-- // LOAD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // SERVICES
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- // CONFIGURATION
local Config = {
    Aimbot = { Enabled = false, Keybind = Enum.KeyCode.V, TargetPart = "Head", FOV = 150, Active = false },
    SilentAim = { Enabled = false, FOV = 100, TargetPart = "Head" },
    Visuals = { Enabled = false, Boxes = false, Corners = false, Names = false, Health = false, Distance = false, Tracers = false, TeamCheck = true, Fullbright = false },
    Movement = { WalkSpeed = 16, JumpPower = 50, InfJump = false, Fly = false, FlySpeed = 50, Noclip = false, InfStamina = false, NoFall = false, Spinbot = false },
    Weapon = { NoRecoil = false, NoSpread = false, InfAmmo = false, HitboxSize = 2 },
    Teleport = { SafeMode = true, ClickTP = false }
}

-- // GLOBALS
local ESP_Objects = {}
local Original_Collisions = {}
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")

-- // UTILS
local function GetClosestPlayer(fov, part)
    local target = nil
    local maxDistance = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if Config.Visuals.TeamCheck and player.Team == LocalPlayer.Team then continue end
            local targetPart = player.Character:FindFirstChild(part) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if distance < maxDistance then
                        target = player
                        maxDistance = distance
                    end
                end
            end
        end
    end
    return target
end

local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    for _, v in pairs(tool:GetDescendants()) do
        if v:IsA("ValueBase") then
            local n = v.Name:lower()
            if Config.Weapon.NoRecoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
            if Config.Weapon.NoSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
            if Config.Weapon.InfAmmo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
        end
    end
end

local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end end)
    for _, c in pairs(char:GetChildren()) do if c:IsA("Tool") then ApplyWeaponMods(c) end end
end
LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if LocalPlayer.Character then MonitorCharacter(LocalPlayer.Character) end

local function SafeTeleport(targetPos)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if Config.Teleport.SafeMode then
        local tweenInfo = TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    else root.CFrame = CFrame.new(targetPos) end
end

-- // ESP SYSTEM
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

-- // WINDOW SETUP
local Window = Rayfield:CreateWindow({
    Name = "Army RP | Stealth V4",
    LoadingTitle = "Bypass Enabled",
    LoadingSubtitle = "by Jules",
    Theme = "DarkBlue",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MovementTab = Window:CreateTab("Movement")
local TeleportTab = Window:CreateTab("Teleports")
local MiscTab = Window:CreateTab("Misc")

-- // COMBAT
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({ Name = "Enable Aimbot", Callback = function(v) Config.Aimbot.Enabled = v end })
CombatTab:CreateKeybind({ Name = "Aimbot Keybind", CurrentKeybind = "V", HoldToInteract = true, Callback = function(key) Config.Aimbot.Keybind = key end })
CombatTab:CreateDropdown({ Name = "Aimbot Target", Options = {"Head", "HumanoidRootPart"}, CurrentValue = "Head", Callback = function(v) Config.Aimbot.TargetPart = v end })
CombatTab:CreateSection("Weaponry")
CombatTab:CreateToggle({ Name = "Hitbox Expander", Callback = function(v) Config.Weapon.HitboxSize = v and 10 or 2 end })
CombatTab:CreateToggle({ Name = "No Recoil/Spread", Callback = function(v) Config.Weapon.NoRecoil = v; Config.Weapon.NoSpread = v end })
CombatTab:CreateToggle({ Name = "Infinite Ammo", Callback = function(v) Config.Weapon.InfAmmo = v end })

-- // VISUALS
VisualsTab:CreateToggle({ Name = "Enable Visuals", Callback = function(v) Config.Visuals.Enabled = v end })
VisualsTab:CreateToggle({ Name = "Boxes", Callback = function(v) Config.Visuals.Boxes = v end })
VisualsTab:CreateToggle({ Name = "Corner Boxes", Callback = function(v) Config.Visuals.Corners = v end })
VisualsTab:CreateToggle({ Name = "Health Bar", Callback = function(v) Config.Visuals.Health = v end })
VisualsTab:CreateToggle({ Name = "Names & Distance", Callback = function(v) Config.Visuals.Names = v; Config.Visuals.Distance = v end })
VisualsTab:CreateToggle({ Name = "Tracers", Callback = function(v) Config.Visuals.Tracers = v end })
VisualsTab:CreateToggle({ Name = "Fullbright", Callback = function(v) Config.Visuals.Fullbright = v; if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) end end })

-- // MOVEMENT
MovementTab:CreateSlider({ Name = "Speed Bypass", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.Movement.WalkSpeed = v end })
MovementTab:CreateSlider({ Name = "Jump Bypass (Power)", Range = {50, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) Config.Movement.JumpPower = v end })
MovementTab:CreateToggle({ Name = "Infinite Jump", Callback = function(v) Config.Movement.InfJump = v end })
MovementTab:CreateToggle({ Name = "Noclip", Callback = function(v) Config.Movement.Noclip = v end })
MovementTab:CreateToggle({ Name = "Fly (CFrame)", Callback = function(v) Config.Movement.Fly = v end })
MovementTab:CreateToggle({ Name = "Spinbot", Callback = function(v) Config.Movement.Spinbot = v end })
MovementTab:CreateToggle({ Name = "No Fall Damage", Callback = function(v) Config.Movement.NoFall = v end })
MovementTab:CreateToggle({ Name = "Infinite Stamina", Callback = function(v) Config.Movement.InfStamina = v end })

-- // TELEPORTS
TeleportTab:CreateSection("Player Teleport")
local PlayerDropdown = TeleportTab:CreateDropdown({ Name = "Select Player", Options = {}, Callback = function() end })
local function UpdatePlayerTPDropdown() local plrs = {}; for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then table.insert(plrs, v.Name) end end; PlayerDropdown:Refresh(plrs) end
Players.PlayerAdded:Connect(UpdatePlayerTPDropdown); Players.PlayerRemoving:Connect(UpdatePlayerTPDropdown); UpdatePlayerTPDropdown()
TeleportTab:CreateButton({ Name = "Teleport to Player", Callback = function() local target = Players:FindFirstChild(PlayerDropdown.CurrentValue); if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then SafeTeleport(target.Character.HumanoidRootPart.Position) end end })
TeleportTab:CreateToggle({ Name = "Ctrl + Click Teleport", Callback = function(v) Config.Teleport.ClickTP = v end })

-- // MISC
MiscTab:CreateButton({ Name = "Instant Interact (E)", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end; workspace.DescendantAdded:Connect(function(v) if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end) end })
MiscTab:CreateButton({ Name = "Remove Barriers", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence") or v.Name:lower():find("wall")) then v.CanCollide = false; v.Transparency = 0.5 end end end })
MiscTab:CreateButton({ Name = "Anti-AFK", Callback = function() LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end); Rayfield:Notify({Title = "Utility", Content = "Anti-AFK Active"}) end })
MiscTab:CreateButton({ Name = "Server Hopper", Callback = function() local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")); for _, s in pairs(Servers.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id); break end end end })
MiscTab:CreateButton({ Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

-- // MAIN LOOPS
RunService.RenderStepped:Connect(function()
    Config.Aimbot.Active = UserInputService:IsKeyDown(Config.Aimbot.Keybind)
    if Config.Aimbot.Enabled and Config.Aimbot.Active then
        local target = GetClosestPlayer(Config.Aimbot.FOV, Config.Aimbot.TargetPart)
        if target and target.Character then
            local part = target.Character:FindFirstChild(Config.Aimbot.TargetPart)
            if part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
        end
    end
    for plr, obs in pairs(ESP_Objects) do
        local char = plr.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
        if Config.Visuals.Enabled and root and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local head = char:FindFirstChild("Head") or root; local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0)); local h = math.abs(headPos.Y - legPos.Y); local w = h / 1.5; local x, y = pos.X - w/2, headPos.Y; local col = (Config.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                obs.Box.Visible = Config.Visuals.Boxes; if obs.Box.Visible then obs.Box.Size = Vector2.new(w, h); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end
                local showCorners = Config.Visuals.Corners; for _, l in pairs(obs.Corners) do l.Visible = showCorners end
                if showCorners then
                    local l = w/4; obs.Corners[1].From = Vector2.new(x, y); obs.Corners[1].To = Vector2.new(x+l, y); obs.Corners[2].From = Vector2.new(x, y); obs.Corners[2].To = Vector2.new(x, y+l); obs.Corners[3].From = Vector2.new(x+w, y); obs.Corners[3].To = Vector2.new(x+w-l, y); obs.Corners[4].From = Vector2.new(x+w, y); obs.Corners[4].To = Vector2.new(x+w, y+l); obs.Corners[5].From = Vector2.new(x, y+h); obs.Corners[5].To = Vector2.new(x+l, y+h); obs.Corners[6].From = Vector2.new(x, y+h); obs.Corners[6].To = Vector2.new(x, y+h-l); obs.Corners[7].From = Vector2.new(x+w, y+h); obs.Corners[7].To = Vector2.new(x+w-l, y+h); obs.Corners[8].From = Vector2.new(x+w, y+h); obs.Corners[8].To = Vector2.new(x+w, y+h-l); for _, c in pairs(obs.Corners) do c.Color = col end
                end
                obs.Health.Visible = Config.Visuals.Health; obs.HealthOutline.Visible = Config.Visuals.Health
                if obs.Health.Visible then local barH = (hum.Health / hum.MaxHealth) * h; obs.HealthOutline.From = Vector2.new(x-5, y); obs.HealthOutline.To = Vector2.new(x-5, y+h); obs.Health.From = Vector2.new(x-5, y+h); obs.Health.To = Vector2.new(x-5, y+h-barH); obs.Health.Color = Color3.fromHSV(math.clamp(hum.Health/hum.MaxHealth, 0, 1) * 0.4, 1, 1) end
                obs.Name.Visible = Config.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = Config.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((Camera.CFrame.Position - root.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + h + 5) end
                obs.Tracer.Visible = Config.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
        else for _, o in pairs(obs) do if typeof(o) == "table" then for _, s in pairs(o) do s.Visible = false end else o.Visible = false end end end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        if Config.Movement.WalkSpeed > 16 and not Config.Movement.Fly then root.Velocity = Vector3.new(hum.MoveDirection.X * Config.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * Config.Movement.WalkSpeed) end
        if Config.Movement.InfStamina then local s = char:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if Config.Movement.NoFall then if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Running) end end
        if Config.Movement.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end
        if Config.Movement.Noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end else for v, state in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = state end end; table.clear(Original_Collisions) end
        if Config.Movement.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.1, 0); root.CFrame = root.CFrame + (m * (Config.Movement.FlySpeed/50))
        else if hum.PlatformStand then hum.PlatformStand = false end end
        local seat = hum.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if Config.Movement.Fly then vGyro.Parent = seat; vVelocity.Parent = seat; vGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); vGyro.CFrame = Camera.CFrame; local m = Vector3.new(0,0,0); if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + Camera.CFrame.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - Camera.CFrame.LookVector end; vVelocity.Velocity = m * Config.Movement.FlySpeed
            else vGyro.Parent = nil; vVelocity.Parent = nil; if seat.Throttle ~= 0 then seat.Velocity = seat.CFrame.LookVector * Config.Movement.FlySpeed * seat.Throttle end end
        else vGyro.Parent = nil; vVelocity.Parent = nil end
        if tick() % 1 < 0.1 then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _, name in pairs({"Head", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart"}) do local target = p.Character:FindFirstChild(name); if target then target.Size = Vector3.new(Config.Weapon.HitboxSize, Config.Weapon.HitboxSize, Config.Weapon.HitboxSize); target.Transparency = Config.Weapon.HitboxSize > 2 and 0.5 or 0; target.CanCollide = false end end end end end
    end
end)

-- // EVENTS
Players.PlayerAdded:Connect(CreateESP); Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
UserInputService.JumpRequest:Connect(function() if Config.Movement.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, Config.Movement.JumpPower, 0) end end)
UserInputService.InputBegan:Connect(function(input, processed) if not processed and Config.Teleport.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local ray = Camera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y); local res = workspace:Raycast(ray.Origin, ray.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)

-- // FINAL HOOKS (SPOOFING)
local mt = getrawmetatable(game)
local _oldIdx = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() then
        if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
        if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
        if Config.SilentAim.Enabled and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
            local target = GetClosestPlayer(Config.SilentAim.FOV, Config.SilentAim.TargetPart)
            if target then return (idx == "Hit" and target.Character[Config.SilentAim.TargetPart].CFrame or target.Character[Config.SilentAim.TargetPart]) end
        end
    end
    return _oldIdx(self, idx)
end)
setreadonly(mt, true)

Rayfield:Notify({Title = "ULTRA STEALTH READY", Content = "Script initialized silently."})
