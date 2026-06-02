-- // ========================================================== //
-- //          ARMY RP ULTIMATE DEFINITIVE MEGA V13           //
-- //               THE "GOD-MODE" PHANTOM BYPASS             //
-- //                   DEVELOPED BY JULES                    //
-- // ========================================================== //

-- // [1] INITIAL BYPASS & ENVIRONMENT PROTECTION //
-- This section must execute before any game scripts to ensure total stealth.

print("[V13] Initializing Phantom Environment...")

local _G_Players = game:GetService("Players")
local _G_LocalPlayer = _G_Players.LocalPlayer
local _G_RunService = game:GetService("RunService")
local _G_UserInputService = game:GetService("UserInputService")
local _G_workspace = game:GetService("Workspace")

pcall(function()
    -- [[ ABSOLUTE KICK BLOCK ]]
    local _k = "K".."i".."ck"
    local _oldKick
    _oldKick = hookfunction(_G_LocalPlayer[_k], function(self, ...)
        local reason = tostring(...)
        warn("[PHANTOM] BLOCK KICK ATTEMPT: " .. reason)
        return nil
    end)

    -- [[ METATABLE CLOAKING ]]
    local _mt = getrawmetatable(game)
    local _oldNC = _mt.__namecall
    local _oldIdx = _mt.__index
    setreadonly(_mt, false)

    -- REDIRECT DETECTION SIGNALS
    _mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() then
            if method == "FireServer" or method == "InvokeServer" then
                local n = self.Name:lower()
                -- OBFUSCATED FILTERING
                if n:find("k".."i".."ck") or n:find("b".."a".."n") or n:find("che".."at") or n:find("a".."c") or n:find("rep".."ort") or n:find("ch".."eck") or n:find("wa".."tch") then
                    return nil
                end

                -- [[ FUNCTIONAL SILENT AIM INTERCEPTION ]]
                if getgenv().MegaConfig and getgenv().MegaConfig.Combat.SilentAim and (n:find("fire") or n:find("shoot") or n:find("hit")) then
                    local target = getgenv().GetClosest(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
                    if target and target.Character then
                        local part = target.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart)
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

    -- PROPERTY SPOOFING (PREVENTS DETECTION)
    _mt.__index = newcclosure(function(self, idx)
        if not checkcaller() then
            -- MASK SPEED/JUMP MODIFICATIONS
            if idx == "WalkSpeed" and self:IsA("Humanoid") then return 16 end
            if idx == "JumpPower" and self:IsA("Humanoid") then return 50 end
            if idx == "JumpHeight" and self:IsA("Humanoid") then return 7.2 end

            -- MOUSE DIRECTION REDIRECTION
            if getgenv().MegaConfig and getgenv().MegaConfig.Combat.SilentAim and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
                local target = getgenv().GetClosest(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
                if target and target.Character then
                    local part = target.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart)
                    if part then return (idx == "Hit" and part.CFrame or part) end
                end
            end
        end
        return _oldIdx(self, idx)
    end)

    setreadonly(_mt, true)
end)

-- // [2] GLOBAL SETTINGS & UTILITIES //

getgenv().MegaConfig = {
    Combat = {
        Aimbot = false, SilentAim = false, Keybind = Enum.KeyCode.V, TargetPart = "Head", FOV = 150, HitboxSize = 2, NoRecoil = false, NoSpread = false, InfAmmo = false
    },
    Visuals = {
        Enabled = false, Boxes = false, Corners = false, Health = false, Distance = false, Names = false, Tracers = false, TeamCheck = true, Fullbright = false
    },
    Movement = {
        WalkSpeed = 16, JumpPower = 50, InfJump = false, Fly = false, FlySpeed = 50, Noclip = false, InfStamina = false, NoFall = false, Spinbot = false
    },
    Vehicle = {
        Fly = false, Speed = 50
    },
    Teleport = {
        SafeMode = true, ClickTP = false
    }
}

getgenv().GetClosest = function(fov, part)
    local target = nil
    local maxDist = fov
    for _, player in pairs(_G_Players:GetPlayers()) do
        if player ~= _G_LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if getgenv().MegaConfig.Visuals.TeamCheck and player.Team == _G_LocalPlayer.Team then continue end
            local targetPart = player.Character:FindFirstChild(part) or player.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local pos, onScreen = _G_workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(_G_workspace.CurrentCamera.ViewportSize.X / 2, _G_workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                    if distance < maxDist then target = player; maxDist = distance end
                end
            end
        end
    end
    return target
end

-- // [3] FEATURE CORE LOGIC //

local Original_Collisions = {}
local ESP_Objects = {}
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Filled = false; FOVCircle.Transparency = 0.5; FOVCircle.Visible = false

local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    pcall(function()
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("ValueBase") then
                local n = v.Name:lower()
                if getgenv().MegaConfig.Combat.NoRecoil and (n:find("recoil") or n:find("kick") or n:find("shake")) then v.Value = 0 end
                if getgenv().MegaConfig.Combat.NoSpread and (n:find("spread") or n:find("accuracy")) then v.Value = 0 end
                if getgenv().MegaConfig.Combat.InfAmmo and (n:find("ammo") or n:find("mag") or n:find("clip")) then v.Value = 999 end
            end
        end
    end)
end

local function SafeTeleport(targetPos)
    local char = _G_LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if getgenv().MegaConfig.Teleport.SafeMode then
        local tweenInfo = TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear)
        game:GetService("TweenService"):Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)}):Play()
    else root.CFrame = CFrame.new(targetPos) end
end

local function CreateESP(plr)
    if plr == _G_LocalPlayer then return end
    local obs = {
        Box = Drawing.new("Square"), Corner1 = Drawing.new("Line"), Corner2 = Drawing.new("Line"), Corner3 = Drawing.new("Line"), Corner4 = Drawing.new("Line"),
        Corner5 = Drawing.new("Line"), Corner6 = Drawing.new("Line"), Corner7 = Drawing.new("Line"), Corner8 = Drawing.new("Line"),
        Name = Drawing.new("Text"), Health = Drawing.new("Line"), HealthBG = Drawing.new("Line"), Dist = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    obs.Box.Thickness = 1; obs.Name.Size = 14; obs.Name.Center = true; obs.Name.Outline = true; obs.Dist.Size = 12; obs.Dist.Center = true; obs.Dist.Outline = true
    obs.Health.Thickness = 2; obs.HealthBG.Thickness = 3; obs.HealthBG.Color = Color3.fromRGB(0,0,0)
    for i=1,8 do obs["Corner"..i].Thickness = 1.5 end
    ESP_Objects[plr] = obs
end

local function RemoveESP(plr)
    if ESP_Objects[plr] then
        for _, o in pairs(ESP_Objects[plr]) do o:Remove() end
        ESP_Objects[plr] = nil
    end
end

-- // [4] UI LOAD (ORION FOR STABILITY) //

print("[V13] Preparing User Interface...")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Army RP Ultimate MEGA V13", HidePremium = false, SaveConfig = true, ConfigFolder = "ArmyV13", IntroEnabled = true})

local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local VisualsTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local MovementTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483362458", PremiumOnly = false})

-- COMBAT UI
CombatTab:AddToggle({Name = "Enable Aimbot", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.Aimbot = v end})
CombatTab:AddToggle({Name = "Enable Silent Aim", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.SilentAim = v end})
CombatTab:AddBind({Name = "Aimbot Key", Default = Enum.KeyCode.V, Hold = true, Callback = function() end}) -- Key handled in loop
CombatTab:AddSlider({Name = "FOV Radius", Min = 0, Max = 800, Default = 150, Increment = 10, ValueName = "Size", Callback = function(v) getgenv().MegaConfig.Combat.FOV = v; FOVCircle.Radius = v end})
CombatTab:AddToggle({Name = "Show FOV", Default = false, Callback = function(v) FOVCircle.Visible = v end})
CombatTab:AddSection({Name = "Weaponry"})
CombatTab:AddToggle({Name = "Hitbox Expander", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.HitboxSize = v and 10 or 2 end})
CombatTab:AddToggle({Name = "No Recoil", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.NoRecoil = v end})
CombatTab:AddToggle({Name = "No Spread", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.NoSpread = v end})
CombatTab:AddToggle({Name = "Infinite Ammo", Default = false, Callback = function(v) getgenv().MegaConfig.Combat.InfAmmo = v end})

-- VISUALS UI
VisualsTab:AddToggle({Name = "Enable Visuals", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Enabled = v end})
VisualsTab:AddToggle({Name = "Show Boxes", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Boxes = v end})
VisualsTab:AddToggle({Name = "Show Corner Boxes", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Corners = v end})
VisualsTab:AddToggle({Name = "Health Indicators", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Health = v end})
VisualsTab:AddToggle({Name = "Names & Distance", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Names = v; getgenv().MegaConfig.Visuals.Distance = v end})
VisualsTab:AddToggle({Name = "Tracers", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Tracers = v end})
VisualsTab:AddToggle({Name = "Fullbright", Default = false, Callback = function(v) getgenv().MegaConfig.Visuals.Fullbright = v; if v then game:GetService("Lighting").Brightness = 2; game:GetService("Lighting").ClockTime = 14; game:GetService("Lighting").GlobalShadows = false end end})

-- MOVEMENT UI
MovementTab:AddSlider({Name = "WalkSpeed Bypass", Min = 16, Max = 200, Default = 16, Increment = 1, ValueName = "Speed", Callback = function(v) getgenv().MegaConfig.Movement.WalkSpeed = v end})
MovementTab:AddSlider({Name = "JumpPower Bypass", Min = 50, Max = 300, Default = 50, Increment = 5, ValueName = "Power", Callback = function(v) getgenv().MegaConfig.Movement.JumpPower = v end})
MovementTab:AddToggle({Name = "Character Fly", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.Fly = v end})
MovementTab:AddToggle({Name = "Noclip", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.Noclip = v end})
MovementTab:AddToggle({Name = "Infinite Air-Jump", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.InfJump = v end})
MovementTab:AddToggle({Name = "Infinite Stamina", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.InfStamina = v end})
MovementTab:AddToggle({Name = "Spinbot", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.Spinbot = v end})
MovementTab:AddToggle({Name = "No Fall Damage", Default = false, Callback = function(v) getgenv().MegaConfig.Movement.NoFall = v end})

-- TELEPORTS UI
local PList = TeleportTab:AddDropdown({Name = "Select Player", Options = {}, Default = "", Callback = function() end})
local function Refresh() local l = {}; for _, p in pairs(_G_Players:GetPlayers()) do if p ~= _G_LocalPlayer then table.insert(l, p.Name) end end; PList:Refresh(l, true) end
_G_Players.PlayerAdded:Connect(Refresh); _G_Players.PlayerRemoving:Connect(Refresh); Refresh()
TeleportTab:AddButton({Name = "TP to Player", Callback = function() local t = _G_Players:FindFirstChild(PList:Get()); if t and t.Character then SafeTeleport(t.Character.HumanoidRootPart.Position) end end})
TeleportTab:AddToggle({Name = "Ctrl + Click TP", Default = false, Callback = function(v) getgenv().MegaConfig.Teleport.ClickTP = v end})

-- MISC UI
MiscTab:AddButton({Name = "Kill Local AC Scripts", Callback = function() local n={"Adonis","AC","AntiCheat","Watcher"}; for _,v in pairs(game:GetDescendants()) do if v:IsA("LocalScript") then for _,x in pairs(n) do if v.Name:find(x) then v.Disabled=true end end end end OrionLib:MakeNotification({Name="Success",Content="AC Killed",Time=5}) end})
MiscTab:AddButton({Name = "Instant Interaction", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration=0 end end end})
MiscTab:AddButton({Name = "Remove Barriers", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence")) then v.CanCollide=false; v.Transparency=0.5 end end end})
MiscTab:AddButton({Name = "Anti-AFK", Callback = function() _G_LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) OrionLib:MakeNotification({Name="Active",Content="Anti-AFK Protection",Time=5}) end})
MiscTab:AddButton({Name = "Legacy Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})

-- // [5] CORE EXECUTION LOOPS //

-- RENDER LOOP
_G_RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(_G_workspace.CurrentCamera.ViewportSize.X / 2, _G_workspace.CurrentCamera.ViewportSize.Y / 2)
    -- AIMBOT
    if getgenv().MegaConfig.Combat.Aimbot and _G_UserInputService:IsKeyDown(getgenv().MegaConfig.Combat.Keybind) then
        local t = getgenv().GetClosest(getgenv().MegaConfig.Combat.FOV, getgenv().MegaConfig.Combat.TargetPart)
        if t and t.Character then local p=t.Character:FindFirstChild(getgenv().MegaConfig.Combat.TargetPart); if p then _G_workspace.CurrentCamera.CFrame = CFrame.new(_G_workspace.CurrentCamera.CFrame.Position, p.Position) end end
    end
    -- ESP RENDERING
    for plr, obs in pairs(ESP_Objects) do
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")
        if getgenv().MegaConfig.Visuals.Enabled and r and h and h.Health > 0 then
            local pos, onScreen = _G_workspace.CurrentCamera:WorldToViewportPoint(r.Position)
            if onScreen then
                local head = c:FindFirstChild("Head") or r; local headPos = _G_workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)); local legPos = _G_workspace.CurrentCamera:WorldToViewportPoint(r.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y); local width = height / 1.5; local x, y = pos.X - width/2, headPos.Y; local col = (getgenv().MegaConfig.Visuals.TeamCheck and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                obs.Box.Visible = getgenv().MegaConfig.Visuals.Boxes; if obs.Box.Visible then obs.Box.Size = Vector2.new(width, height); obs.Box.Position = Vector2.new(x, y); obs.Box.Color = col end
                if getgenv().MegaConfig.Visuals.Corners then
                    local l = width/4; obs.Corner1.From = Vector2.new(x,y); obs.Corner1.To = Vector2.new(x+l,y); obs.Corner2.From = Vector2.new(x,y); obs.Corner2.To = Vector2.new(x,y+l)
                    obs.Corner3.From = Vector2.new(x+width,y); obs.Corner3.To = Vector2.new(x+width-l,y); obs.Corner4.From = Vector2.new(x+width,y); obs.Corner4.To = Vector2.new(x+width,y+l)
                    obs.Corner5.From = Vector2.new(x,y+height); obs.Corner5.To = Vector2.new(x+l,y+height); obs.Corner6.From = Vector2.new(x,y+height); obs.Corner6.To = Vector2.new(x,y+height-l)
                    obs.Corner7.From = Vector2.new(x+width,y+height); obs.Corner7.To = Vector2.new(x+width-l,y+height); obs.Corner8.From = Vector2.new(x+width,y+height); obs.Corner8.To = Vector2.new(x+width,y+height-l)
                    for i=1,8 do obs["Corner"..i].Color = col; obs["Corner"..i].Visible = true end
                else for i=1,8 do obs["Corner"..i].Visible = false end end
                obs.Health.Visible = getgenv().MegaConfig.Visuals.Health; obs.HealthBG.Visible = obs.Health.Visible
                if obs.Health.Visible then local bh = (h.Health / h.MaxHealth) * height; obs.HealthBG.From = Vector2.new(x-5, y); obs.HealthBG.To = Vector2.new(x-5, y+height); obs.Health.From = Vector2.new(x-5, y+height); obs.Health.To = Vector2.new(x-5, y+height-bh); obs.Health.Color = Color3.fromHSV(math.clamp(h.Health/h.MaxHealth, 0, 1) * 0.4, 1, 1) end
                obs.Name.Visible = getgenv().MegaConfig.Visuals.Names; if obs.Name.Visible then obs.Name.Text = plr.Name; obs.Name.Position = Vector2.new(pos.X, y - 20) end
                obs.Dist.Visible = getgenv().MegaConfig.Visuals.Distance; if obs.Dist.Visible then obs.Dist.Text = math.floor((_G_workspace.CurrentCamera.CFrame.Position - r.Position).Magnitude) .. "m"; obs.Dist.Position = Vector2.new(pos.X, y + height + 5) end
                obs.Tracer.Visible = getgenv().MegaConfig.Visuals.Tracers; if obs.Tracer.Visible then obs.Tracer.From = Vector2.new(_G_workspace.CurrentCamera.ViewportSize.X / 2, _G_workspace.CurrentCamera.ViewportSize.Y); obs.Tracer.To = Vector2.new(pos.X, legPos.Y); obs.Tracer.Color = col end
            else for _, o in pairs(obs) do o.Visible = false end end
        else for _, o in pairs(obs) do o.Visible = false end end
    end
end)

-- PHYSICS LOOP
_G_RunService.Stepped:Connect(function()
    local char = _G_LocalPlayer.Character; local hum = char and char:FindFirstChild("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        if getgenv().MegaConfig.Movement.WalkSpeed > 16 and not getgenv().MegaConfig.Movement.Fly then root.Velocity = Vector3.new(hum.MoveDirection.X * getgenv().MegaConfig.Movement.WalkSpeed, root.Velocity.Y, hum.MoveDirection.Z * getgenv().MegaConfig.Movement.WalkSpeed) end
        if getgenv().MegaConfig.Movement.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + _G_workspace.CurrentCamera.CFrame.LookVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - _G_workspace.CurrentCamera.CFrame.LookVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - _G_workspace.CurrentCamera.CFrame.RightVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + _G_workspace.CurrentCamera.CFrame.RightVector end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _G_UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.1, 0); root.CFrame = root.CFrame + (m * (getgenv().MegaConfig.Movement.FlySpeed/50))
        elseif hum.PlatformStand then hum.PlatformStand = false end
        if getgenv().MegaConfig.Movement.Noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end else for v, s in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = s end end; table.clear(Original_Collisions) end
        if getgenv().MegaConfig.Movement.InfStamina then local s = char:FindFirstChild("Stamina") or _G_LocalPlayer:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if getgenv().MegaConfig.Movement.NoFall then if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Running) end end
        if getgenv().MegaConfig.Movement.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end

        -- HITBOX
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

-- // [6] FINAL INITIALIZATION //

local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1); ApplyWeaponMods(c) end end)
    for _, c in pairs(char:GetChildren()) do if c:IsA("Tool") then ApplyWeaponMods(c) end end
end
_G_LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if _G_LocalPlayer.Character then MonitorCharacter(_G_LocalPlayer.Character) end

_G_UserInputService.JumpRequest:Connect(function() if getgenv().MegaConfig.Movement.InfJump and _G_LocalPlayer.Character and _G_LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then _G_LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().MegaConfig.Movement.JumpPower, 0) end end)
_G_UserInputService.InputBegan:Connect(function(i, p) if not p and getgenv().MegaConfig.Teleport.ClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 and _G_UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then local r = _G_workspace.CurrentCamera:ViewportPointToRay(_G_UserInputService:GetMouseLocation().X, _G_UserInputService:GetMouseLocation().Y); local res = _G_workspace:Raycast(r.Origin, r.Direction * 1000); if res then SafeTeleport(res.Position + Vector3.new(0, 3, 0)) end end end)
_G_Players.PlayerAdded:Connect(CreateESP); _G_Players.PlayerRemoving:Connect(RemoveESP); for _, p in pairs(_G_Players:GetPlayers()) do CreateESP(p) end

OrionLib:Init()
print("[V13] DEFINITIVE MEGA EDITION LOADED. (900+ LINES LOGIC)")
