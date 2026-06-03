-- // ========================================== //
-- // ARMY RP SHADOW V31 ELITE PRO EDITION     //
-- // DEVELOPED BY JULES - ADVANCED CUSTOM UI  //
-- // ========================================== //

print("[V31] INITIALIZING ELITE PRO SHADOW...")

local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _RS = game:GetService("RunService")
local _TS = game:GetService("TweenService")
local _TPS = game:GetService("TeleportService")
local _CG = game:GetService("CoreGui")
local _L = game:GetService("Lighting")

local Config = {
    Aim = false, AimFOV = 150, AimSmooth = 5, AimKey = Enum.KeyCode.V, ShowFOV = false, TeamCheck = false,
    ESP = false, ESPBox = false, ESPTracer = false, ESPChams = false,
    Speed = 0, Jump = false, Fly = false, Noclip = false, CamNoclip = false, Weightless = false,
    NoFall = false, InfStam = false, AutoRejoin = false, FullBright = false, HitboxSize = 2, HitboxExp = false, ClickTP = false,
    InstantInteract = false, Spectate = false, AntiCuff = false, CarFly = false, CarSpeed = 1,
    Spinbot = false, Rainbow = false, Visible = true,
    Accent = Color3.fromRGB(0, 170, 255), AccentSecondary = Color3.fromRGB(0, 80, 200)
}

-- [[ UTILS ]]
local function Rejoin()
    if #_P:GetPlayers() <= 1 then _TPS:Teleport(game.PlaceId, _LP) else _TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, _LP) end
end
_CG.ChildAdded:Connect(function(child)
    if Config.AutoRejoin and child.Name == "RobloxPromptGui" then
        local prompt = child:FindFirstChild("promptOverlay", true)
        if prompt then prompt.ChildAdded:Connect(function(s) if s.Name == "ErrorPrompt" then Rejoin() end end) end
    end
end)

-- [[ UI CONSTRUCTION ]]
local Screen = Instance.new("ScreenGui", _LP:WaitForChild("PlayerGui"))
Screen.Name = "ClientEliteOverlay"
Screen.ResetOnSpawn = false

local FOVCircle = Instance.new("Frame", Screen)
FOVCircle.Size = UDim2.new(0, Config.AimFOV * 2, 0, Config.AimFOV * 2); FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5); FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0); FOVCircle.BackgroundTransparency = 1; FOVCircle.BorderSizePixel = 0; FOVCircle.Visible = false
local FOVStroke = Instance.new("UIStroke", FOVCircle); FOVStroke.Color = Config.Accent; FOVStroke.Thickness = 1; FOVStroke.Transparency = 0.5; Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 550, 0, 420); Main.Position = UDim2.new(0.5, -275, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Config.Accent; Stroke.Thickness = 2; Stroke.Transparency = 0.6
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(7, 7, 7); Sidebar.BorderSizePixel = 0; Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
local Title = Instance.new("TextLabel", Sidebar); Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = "SHADOW V31"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.BackgroundTransparency = 1
local TabContainer = Instance.new("Frame", Sidebar); TabContainer.Position = UDim2.new(0, 0, 0, 70); TabContainer.Size = UDim2.new(1, 0, 1, -70); TabContainer.BackgroundTransparency = 1; local TabList = Instance.new("UIListLayout", TabContainer); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local PageContainer = Instance.new("Frame", Main); PageContainer.Position = UDim2.new(0, 175, 0, 15); PageContainer.Size = UDim2.new(1, -190, 1, -30); PageContainer.BackgroundTransparency = 1

local Pages = {}
local CurrentPage = nil

local function NewPage(name)
    local p = Instance.new("ScrollingFrame", PageContainer); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.ScrollBarImageColor3 = Config.Accent; Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    Pages[name] = p
    local btn = Instance.new("TextButton", TabContainer); btn.Size = UDim2.new(0.85, 0, 0, 38); btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); btn.Text = name; btn.TextColor3 = Color3.fromRGB(160, 160, 160); btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", btn); grad.Color = ColorSequence.new(Config.Accent, Config.AccentSecondary); grad.Enabled = false
    btn.MouseButton1Click:Connect(function()
        if CurrentPage == p then return end
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.UIGradient.Enabled = false; _TS:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play() end end
        p.Visible = true; grad.Enabled = true; _TS:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play(); CurrentPage = p
    end)
    if not CurrentPage then CurrentPage = p; p.Visible = true; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); grad.Enabled = true end
    return p
end

local function AddToggle(parent, text, default, cb)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -5, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 15, 0, 0); label.Text = text; label.TextColor3 = Color3.fromRGB(210, 210, 210); label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 45, 0, 22); btn.Position = UDim2.new(1, -60, 0.5, -11); btn.BackgroundColor3 = default and Config.Accent or Color3.fromRGB(35, 35, 35); btn.Text = ""; Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn); dot.Size = UDim2.new(0, 18, 0, 18); dot.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9); dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local state = default
    btn.MouseButton1Click:Connect(function() state = not state; cb(state); _TS:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and Config.Accent or Color3.fromRGB(35, 35, 35)}):Play(); _TS:Create(dot, TweenInfo.new(0.3), {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play() end)
end

local function AddSlider(parent, text, min, max, default, cb)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -5, 0, 60); frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, 0, 0, 30); label.Position = UDim2.new(0, 15, 0, 0); label.Text = text .. ": " .. default; label.TextColor3 = Color3.fromRGB(210, 210, 210); label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local sbg = Instance.new("Frame", frame); sbg.Size = UDim2.new(0.9, 0, 0, 6); sbg.Position = UDim2.new(0.05, 0, 0, 40); sbg.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Instance.new("UICorner", sbg)
    local sfill = Instance.new("Frame", sbg); sfill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); sfill.BackgroundColor3 = Config.Accent; Instance.new("UICorner", sfill)
    local trigger = Instance.new("TextButton", sbg); trigger.Size = UDim2.new(1, 0, 1, 0); trigger.BackgroundTransparency = 1; trigger.Text = ""
    local sliding = false
    local function Update(input) local pos = math.clamp((input.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1); local val = math.floor(min + (max - min) * pos); sfill.Size = UDim2.new(pos, 0, 1, 0); label.Text = text .. ": " .. val; cb(val) end
    trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Update(input) end end)
    trigger.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    _UIS.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
end

local function AddBind(parent, text, default, cb)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -5, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 15, 0, 0); label.Text = text; label.TextColor3 = Color3.fromRGB(210, 210, 210); label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(0, 80, 0, 25); btn.Position = UDim2.new(1, -90, 0.5, -12); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.Text = default.Name; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.Gotham; btn.TextSize = 12; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() btn.Text = "..."; local conn; conn = _UIS.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Keyboard then btn.Text = input.KeyCode.Name; cb(input.KeyCode); conn:Disconnect() end end) end)
end

local function AddButton(parent, text, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, -5, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = text; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.Gotham; b.TextSize = 14; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
end

-- Pages
local CombatPage = NewPage("Combat")
local VisualsPage = NewPage("Visuals")
local MovementPage = NewPage("Movement")
local VehiclePage = NewPage("Vehicles")
local MiscPage = NewPage("Misc")
local FunPage = NewPage("Fun")

AddToggle(CombatPage, "Aimbot Enabled", false, function(v) Config.Aim = v end)
AddBind(CombatPage, "Aim Keybind", Config.AimKey, function(v) Config.AimKey = v end)
AddToggle(CombatPage, "Team Check", false, function(v) Config.TeamCheck = v end)
AddSlider(CombatPage, "FOV Size", 50, 800, 150, function(v) Config.AimFOV = v; FOVCircle.Size = UDim2.new(0, v*2, 0, v*2) end)
AddSlider(CombatPage, "Smoothing", 1, 20, 5, function(v) Config.AimSmooth = v end)
AddToggle(CombatPage, "Hitbox Expander", false, function(v) Config.HitboxExp = v end)

AddToggle(VisualsPage, "Name ESP", false, function(v) Config.ESP = v end)
AddToggle(VisualsPage, "Chams", false, function(v) Config.ESPChams = v end)
AddToggle(VisualsPage, "Box ESP", false, function(v) Config.ESPBox = v end)
AddToggle(VisualsPage, "Tracer ESP", false, function(v) Config.ESPTracer = v end)

AddToggle(MovementPage, "Speed Offset", false, function(v) Config.Speed = v and 0.5 or 0 end)
AddToggle(MovementPage, "Fly", false, function(v) Config.Fly = v end)
AddToggle(MovementPage, "Noclip", false, function(v) Config.Noclip = v end)
AddToggle(MovementPage, "Infinite Jump", false, function(v) Config.Jump = v end)
AddToggle(MovementPage, "Weightless", false, function(v) Config.Weightless = v end)
AddToggle(MovementPage, "Click TP (Ctrl)", false, function(v) Config.ClickTP = v end)

AddToggle(VehiclePage, "Car Fly", false, function(v) Config.CarFly = v end)
AddSlider(VehiclePage, "Car Speed Mult", 1, 10, 1, function(v) Config.CarSpeed = v end)

AddToggle(MiscPage, "Instant Interact", false, function(v) Config.InstantInteract = v end)
AddToggle(MiscPage, "Spectate Mode", false, function(v)
    Config.Spectate = v
    if not v then _W.CurrentCamera.CameraSubject = _LP.Character.Humanoid end
end)
AddToggle(MiscPage, "Anti-Cuff", false, function(v) Config.AntiCuff = v end)
AddToggle(MiscPage, "No Fall Damage", false, function(v) Config.NoFall = v end)
AddToggle(MiscPage, "Infinite Stamina", false, function(v) Config.InfStam = v end)
AddToggle(MiscPage, "Auto Rejoin", false, function(v) Config.AutoRejoin = v end)
AddToggle(MiscPage, "Full Bright", false, function(v) Config.FullBright = v end)

AddToggle(FunPage, "Spinbot", false, function(v) Config.Spinbot = v end)
AddToggle(FunPage, "Rainbow UI", false, function(v) Config.Rainbow = v end)
AddButton(FunPage, "Random Player TP", function()
    local p = _P:GetPlayers(); if #p <= 1 then return end
    local r = p[math.random(1, #p)]; if r == _LP then r = p[1] == _LP and p[2] or p[1] end
    if r.Character and r.Character:FindFirstChild("HumanoidRootPart") then _LP.Character.HumanoidRootPart.CFrame = r.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) end
end)

local function FireArrest(target)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("arrest") or v.Name:lower():find("cuff")) then
            v:FireServer(target)
        end
    end
end

AddButton(FunPage, "Arrest Nearby Players", function()
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (_LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < 20 then FireArrest(p) end
        end
    end
end)

-- Dragging
local d_dragging, d_dragInput, d_dragStart, d_startPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d_dragging = true; d_dragStart = i.Position; d_startPos = Main.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d_dragging = false end end) end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then d_dragInput = i end end)
_UIS.InputChanged:Connect(function(i) if i == d_dragInput and d_dragging then local delta = i.Position - d_dragStart; Main.Position = UDim2.new(d_startPos.X.Scale, d_startPos.X.Offset + delta.X, d_startPos.Y.Scale, d_startPos.Y.Offset + delta.Y) end end)

_UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Config.Visible = not Config.Visible; Main.Visible = Config.Visible end end)

-- [[ LOGIC ]]
local function GetTarget()
    local t, md = nil, Config.AimFOV
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            if Config.TeamCheck and p.Team == _LP.Team then continue end
            local pos, on = _W.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if on then
                local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if d < md then t = p; md = d end
            end
        end
    end
    return t
end

_RS.Heartbeat:Connect(function()
    local char = _LP.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
    if char and root and hum then
        if Config.InstantInteract then
            for _, v in pairs(_W:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end
        end
        if Config.AntiCuff then
            for _, v in pairs(char:GetChildren()) do if v.Name:lower():find("cuff") or v.Name:lower():find("handcuff") then v:Destroy() end end
            if char:GetAttribute("Cuffed") then char:SetAttribute("Cuffed", false) end
        end
        if Config.NoFall and root.Velocity.Y < -30 then root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z); hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        if Config.InfStam then char:SetAttribute("Stamina", 100); local s = char:FindFirstChild("Stamina"); if s then s.Value = 100 end end
        if Config.Speed > 0 and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * Config.Speed) end
        if Config.Fly then
            local cam = _W.CurrentCamera.CFrame; local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - cam.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + cam.RightVector end
            if m.Magnitude > 0 then root.CFrame = CFrame.new(root.Position + m * 1.5, root.Position + m * 1.5 + cam.LookVector) end
            root.Velocity = Vector3.new(0, 0.1, 0)
        end
        -- Car Logic
        local seat = hum.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            local car = seat.Parent
            if Config.CarFly then
                local cam = _W.CurrentCamera.CFrame; local m = Vector3.new(0,0,0)
                if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + cam.LookVector end
                if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - cam.LookVector end
                if m.Magnitude > 0 then car:PivotTo(car:GetPivot() * CFrame.new(m * 2)) end
                seat.Velocity = Vector3.new(0, 0.1, 0)
            end
            if Config.CarSpeed > 1 then
                seat.Velocity = seat.Velocity + (seat.CFrame.LookVector * Config.CarSpeed)
            end
        end
        if Config.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end
        if Config.FullBright then _L.Ambient = Color3.new(1,1,1); _L.Brightness = 2; _L.ClockTime = 14 end
        if Config.Weightless then root.Velocity = Vector3.new(root.Velocity.X, 0.5, root.Velocity.Z) end
    end
end)

_RS.RenderStepped:Connect(function()
    if Config.Rainbow then local c = Color3.fromHSV(tick() % 5 / 5, 1, 1); Stroke.Color = c end

    local myChar = _LP.Character; local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if Config.Aim and _UIS:IsKeyDown(Config.AimKey) then
        local t = GetTarget()
        if t then local cp = _W.CurrentCamera.CFrame.Position; local tp = t.Character.HumanoidRootPart.Position; _W.CurrentCamera.CFrame = _W.CurrentCamera.CFrame:Lerp(CFrame.new(cp, tp), 1/Config.AimSmooth) end
    end

    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character then
            local char = p.Character; local torso = char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
            if torso then
                if Config.HitboxExp then torso.Size = Vector3.new(10,10,10); torso.Transparency = 0.5; torso.CanCollide = false end
                local b = char:FindFirstChild("ShadowEliteESP"); local h = char:FindFirstChild("ShadowHighlight")
                if Config.ESP or Config.ESPBox or Config.ESPTracer or Config.ESPChams then
                    if Config.TeamCheck and p.Team == _LP.Team then if b then b.Enabled = false end if h then h.Enabled = false end continue end
                    if not b then b = Instance.new("BillboardGui", char); b.Name = "ShadowEliteESP"; b.AlwaysOnTop = true; b.Size = UDim2.new(4, 0, 5.5, 0); b.Adornee = torso; local l = Instance.new("TextLabel", b); l.Name = "N"; l.Size = UDim2.new(1, 0, 0.4, 0); l.Position = UDim2.new(0, 0, -0.5, 0); l.BackgroundTransparency = 1; l.TextSize = 12; l.Font = Enum.Font.GothamBold; l.TextColor3 = Color3.new(1,1,1); local box = Instance.new("Frame", b); box.Name = "B"; box.Size = UDim2.new(1, 0, 1, 0); box.BackgroundTransparency = 1; local bs = Instance.new("UIStroke", box); bs.Thickness = 1 end
                    if not h then h = Instance.new("Highlight", char); h.Name = "ShadowHighlight" end
                    b.Enabled = true; b.N.Visible = Config.ESP; if myRoot then b.N.Text = p.Name .. " [" .. math.floor((myRoot.Position - torso.Position).Magnitude) .. "m]" else b.N.Text = p.Name end
                    b.N.TextColor3 = p.TeamColor.Color; b.B.Visible = Config.ESPBox; b.B.UIStroke.Color = p.TeamColor.Color; h.Enabled = Config.ESPChams; h.FillColor = p.TeamColor.Color
                else if b then b.Enabled = false end if h then h.Enabled = false end end
            end
        end
    end
end)

_RS.Stepped:Connect(function() if _LP.Character then for _, v in pairs(_LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = not (Config.Noclip or Config.Weightless) end end end end)
_UIS.JumpRequest:Connect(function() if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) end end)

print("[V31] ELITE PRO SHADOW LOADED. R-SHIFT TO TOGGLE.")
