-- // ========================================== //
-- // ARMY RP SHADOW V28 ELITE FUN EDITION     //
-- // DEVELOPED BY JULES - ADVANCED CUSTOM UI  //
-- // ========================================== //

print("[V28] INITIALIZING ELITE FUN SHADOW...")

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
    Aim = false,
    AimFOV = 150,
    AimSmooth = 5,
    ShowFOV = false,
    TeamCheck = false,

    ESP = false,
    ESPBox = false,
    ESPTracer = false,
    ESPChams = false,

    Speed = 0,
    Jump = false,
    Fly = false,
    Noclip = false,

    NoFall = false,
    InfStam = false,
    AutoRejoin = false,
    FullBright = false,

    Spinbot = false,
    Rainbow = false,

    Visible = true,
    Accent = Color3.fromRGB(0, 170, 255),
    AccentSecondary = Color3.fromRGB(0, 80, 200)
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
FOVCircle.Size = UDim2.new(0, Config.AimFOV * 2, 0, Config.AimFOV * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1; FOVCircle.BorderSizePixel = 0; FOVCircle.Visible = false
local FOVStroke = Instance.new("UIStroke", FOVCircle); FOVStroke.Color = Config.Accent; FOVStroke.Thickness = 1; FOVStroke.Transparency = 0.5
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Config.Accent; Stroke.Thickness = 2; Stroke.Transparency = 0.6

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 8); Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = "SHADOW ELITE"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Position = UDim2.new(0, 0, 0, 70); TabContainer.Size = UDim2.new(1, 0, 1, -70); TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageContainer = Instance.new("Frame", Main)
PageContainer.Position = UDim2.new(0, 165, 0, 15); PageContainer.Size = UDim2.new(1, -180, 1, -30); PageContainer.BackgroundTransparency = 1

local Pages = {}
local CurrentPage = nil

local function NewPage(name)
    local p = Instance.new("ScrollingFrame", PageContainer)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.ScrollBarImageColor3 = Config.Accent
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    Pages[name] = p
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.85, 0, 0, 38); btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18); btn.Text = name; btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", btn); grad.Color = ColorSequence.new(Config.Accent, Config.AccentSecondary); grad.Enabled = false
    btn.MouseButton1Click:Connect(function()
        if CurrentPage == p then return end
        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.UIGradient.Enabled = false; _TS:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play() end end
        p.Visible = true; grad.Enabled = true; _TS:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play(); CurrentPage = p
    end)
    if not CurrentPage then CurrentPage = p; p.Visible = true; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); grad.Enabled = true end
    return p
end

local function AddToggle(parent, text, default, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -5, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 15, 0, 0); label.Text = text; label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 45, 0, 22); btn.Position = UDim2.new(1, -60, 0.5, -11); btn.BackgroundColor3 = default and Config.Accent or Color3.fromRGB(40, 40, 40); btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 18, 0, 18); dot.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9); dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state; cb(state); _TS:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and Config.Accent or Color3.fromRGB(40, 40, 40)}):Play()
        _TS:Create(dot, TweenInfo.new(0.3), {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
    end)
end

local function AddSlider(parent, text, min, max, default, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -5, 0, 60); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 30); label.Position = UDim2.new(0, 15, 0, 0); label.Text = text .. ": " .. default; label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local sbg = Instance.new("Frame", frame)
    sbg.Size = UDim2.new(0.9, 0, 0, 6); sbg.Position = UDim2.new(0.05, 0, 0, 40); sbg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", sbg)
    local sfill = Instance.new("Frame", sbg)
    sfill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); sfill.BackgroundColor3 = Config.Accent; Instance.new("UICorner", sfill)
    local trigger = Instance.new("TextButton", sbg)
    trigger.Size = UDim2.new(1, 0, 1, 0); trigger.BackgroundTransparency = 1; trigger.Text = ""
    local sliding = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        sfill.Size = UDim2.new(pos, 0, 1, 0); label.Text = text .. ": " .. val; cb(val)
    end
    trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Update(input) end end)
    trigger.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    _UIS.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
end

local function AddButton(parent, text, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -5, 0, 40); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Text = text; b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Gotham; b.TextSize = 14; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
end

-- Dragging
local d_dragging, d_dragInput, d_dragStart, d_startPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d_dragging = true; d_dragStart = i.Position; d_startPos = Main.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d_dragging = false end end) end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then d_dragInput = i end end)
_UIS.InputChanged:Connect(function(i) if i == d_dragInput and d_dragging then local delta = i.Position - d_dragStart; Main.Position = UDim2.new(d_startPos.X.Scale, d_startPos.X.Offset + delta.X, d_startPos.Y.Scale, d_startPos.Y.Offset + delta.Y) end end)

-- Pages
local CombatPage = NewPage("Combat")
local VisualsPage = NewPage("Visuals")
local MovementPage = NewPage("Movement")
local MiscPage = NewPage("Misc")
local FunPage = NewPage("Fun")

AddToggle(CombatPage, "Aimbot (Hold V)", false, function(v) Config.Aim = v end)
AddToggle(CombatPage, "Team Check", false, function(v) Config.TeamCheck = v end)
AddToggle(CombatPage, "Show FOV Circle", false, function(v) Config.ShowFOV = v; FOVCircle.Visible = v end)
AddSlider(CombatPage, "FOV Size", 50, 800, 150, function(v) Config.AimFOV = v; FOVCircle.Size = UDim2.new(0, v*2, 0, v*2) end)
AddSlider(CombatPage, "Smoothing", 1, 20, 5, function(v) Config.AimSmooth = v end)

AddToggle(VisualsPage, "Name ESP", false, function(v) Config.ESP = v end)
AddToggle(VisualsPage, "Box ESP", false, function(v) Config.ESPBox = v end)
AddToggle(VisualsPage, "Tracer ESP", false, function(v) Config.ESPTracer = v end)
AddToggle(VisualsPage, "Chams", false, function(v) Config.ESPChams = v end)

AddToggle(MovementPage, "Speed Offset", false, function(v) Config.Speed = v and 0.5 or 0 end)
AddToggle(MovementPage, "Infinite Jump", false, function(v) Config.Jump = v end)
AddToggle(MovementPage, "Fly", false, function(v) Config.Fly = v end)
AddToggle(MovementPage, "Noclip", false, function(v) Config.Noclip = v end)

AddToggle(MiscPage, "Full Bright", false, function(v) Config.FullBright = v end)
AddToggle(MiscPage, "No Fall Damage", false, function(v) Config.NoFall = v end)
AddToggle(MiscPage, "Infinite Stamina", false, function(v) Config.InfStam = v end)
AddToggle(MiscPage, "Auto Rejoin", false, function(v) Config.AutoRejoin = v end)

AddToggle(FunPage, "Spinbot", false, function(v) Config.Spinbot = v end)
AddToggle(FunPage, "Rainbow UI", false, function(v) Config.Rainbow = v end)
AddButton(FunPage, "Random Player TP", function()
    local players = _P:GetPlayers()
    if #players <= 1 then return end
    local r = players[math.random(1, #players)]
    while r == _LP do r = players[math.random(1, #players)] end
    if r.Character and r.Character:FindFirstChild("HumanoidRootPart") and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        _LP.Character.HumanoidRootPart.CFrame = r.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

_UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Config.Visible = not Config.Visible; Main.Visible = Config.Visible; FOVCircle.Visible = Config.Visible and Config.ShowFOV end end)

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
        if Config.NoFall and (hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll) then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        if Config.InfStam then local s = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina") or char:FindFirstChild("Energy"); if s and s:IsA("NumberValue") then s.Value = 100 end end
        if Config.Speed > 0 and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * Config.Speed) end
        if Config.Fly then
            local cam = _W.CurrentCamera.CFrame; local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - cam.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + cam.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            if m.Magnitude > 0 then root.CFrame = CFrame.new(root.Position + m * 1.5, root.Position + m * 1.5 + cam.LookVector) end
            root.Velocity = Vector3.new(0, 0.1, 0)
        end
        if Config.FullBright then _L.Ambient = Color3.new(1,1,1); _L.Brightness = 2; _L.ClockTime = 14 end
        if Config.Spinbot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0) end
    end
end)

_RS.RenderStepped:Connect(function()
    if Config.Rainbow then
        local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        Stroke.Color = c; FOVStroke.Color = c
    end

    local myChar = _LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if Config.Aim and _UIS:IsKeyDown(Enum.KeyCode.V) then
        local t = GetTarget()
        if t then
            local cp = _W.CurrentCamera.CFrame.Position; local tp = t.Character.HumanoidRootPart.Position
            _W.CurrentCamera.CFrame = _W.CurrentCamera.CFrame:Lerp(CFrame.new(cp, tp), 1/Config.AimSmooth)
        end
    end

    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP then
            local char = p.Character
            local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            if torso then
                local b = char:FindFirstChild("ShadowEliteESP")
                local h = char:FindFirstChild("ShadowHighlight")
                if Config.ESP or Config.ESPBox or Config.ESPTracer or Config.ESPChams then
                    if Config.TeamCheck and p.Team == _LP.Team then
                        if b then b.Enabled = false end
                        if h then h.Enabled = false end
                        local tr = Screen:FindFirstChild(p.Name.."_Tracer"); if tr then tr.Visible = false end
                        continue
                    end

                    if not b then
                        b = Instance.new("BillboardGui", char); b.Name = "ShadowEliteESP"; b.AlwaysOnTop = true; b.Size = UDim2.new(4, 0, 5.5, 0); b.Adornee = torso;
                        local l = Instance.new("TextLabel", b); l.Name = "N"; l.Size = UDim2.new(1, 0, 0.4, 0); l.Position = UDim2.new(0, 0, -0.5, 0); l.BackgroundTransparency = 1; l.TextSize = 12; l.Font = Enum.Font.GothamBold; l.TextColor3 = Color3.new(1,1,1);
                        local box = Instance.new("Frame", b); box.Name = "B"; box.Size = UDim2.new(1, 0, 1, 0); box.BackgroundTransparency = 1; local bs = Instance.new("UIStroke", box); bs.Thickness = 1
                    end
                    if not h then h = Instance.new("Highlight", char); h.Name = "ShadowHighlight" end

                    b.Enabled = true; b.N.Visible = Config.ESP;
                    if myRoot then
                        b.N.Text = p.Name .. " [" .. math.floor((myRoot.Position - torso.Position).Magnitude) .. "m]"
                    else
                        b.N.Text = p.Name
                    end
                    b.N.TextColor3 = p.TeamColor.Color; b.B.Visible = Config.ESPBox; b.B.UIStroke.Color = p.TeamColor.Color; h.Enabled = Config.ESPChams; h.FillColor = p.TeamColor.Color; h.OutlineColor = Color3.new(1,1,1)

                    local tr = Screen:FindFirstChild(p.Name.."_Tracer")
                    if Config.ESPTracer then
                        if not tr then tr = Instance.new("Frame", Screen); tr.Name = p.Name.."_Tracer"; tr.BorderSizePixel = 0; tr.AnchorPoint = Vector2.new(0.5, 0.5) end
                        local pos, on = _W.CurrentCamera:WorldToViewportPoint(torso.Position)
                        if on then
                            local startPos = Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y); local endPos = Vector2.new(pos.X, pos.Y); local dist = (startPos - endPos).Magnitude; tr.Visible = true; tr.Size = UDim2.new(0, 1, 0, dist); tr.Position = UDim2.new(0, (startPos.X + endPos.X)/2, 0, (startPos.Y + endPos.Y)/2); tr.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)) - 90; tr.BackgroundColor3 = p.TeamColor.Color
                        else tr.Visible = false end
                    elseif tr then tr.Visible = false end
                else
                    if b then b.Enabled = false end
                    if h then h.Enabled = false end
                    local tr = Screen:FindFirstChild(p.Name.."_Tracer"); if tr then tr.Visible = false end
                end
            end
        end
    end
end)

-- Cleanup on Player Removing
_P.PlayerRemoving:Connect(function(p)
    local tr = Screen:FindFirstChild(p.Name.."_Tracer")
    if tr then tr:Destroy() end
end)

_RS.Stepped:Connect(function() if _LP.Character then for _, v in pairs(_LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = not Config.Noclip end end end end)
_UIS.JumpRequest:Connect(function() if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) end end)

print("[V28] ELITE FUN SHADOW LOADED. R-SHIFT TO TOGGLE.")
