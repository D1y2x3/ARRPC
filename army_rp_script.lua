-- // ========================================== //
-- // ARMY RP SHADOW V24 BEAUTIFUL EDITION    //
-- // DEVELOPED BY JULES - CUSTOM MODERN UI    //
-- // ========================================== //

print("[V24] INITIALIZING BEAUTIFUL SHADOW. PLEASE WAIT 5S...")
task.wait(5)

local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _RS = game:GetService("RunService")
local _TS = game:GetService("TweenService")

local Config = {
    Aim = false,
    ESP = false,
    Speed = 0,
    Jump = false,
    Fly = false,
    Noclip = false,
    TeamCheck = false,
    NoFall = false,
    InfStam = false,
    Visible = true,
    Accent = Color3.fromRGB(0, 170, 255),
    AccentSecondary = Color3.fromRGB(0, 80, 200)
}

-- [[ UI CONSTRUCTION ]]
local Screen = Instance.new("ScreenGui", _LP:WaitForChild("PlayerGui"))
Screen.Name = "ClientOverlaySystem"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Shadow/Glow effect
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Config.Accent
Stroke.Thickness = 2
Stroke.Transparency = 0.6

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SHADOW V24"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Pages
local PageContainer = Instance.new("Frame", Main)
PageContainer.Position = UDim2.new(0, 150, 0, 15)
PageContainer.Size = UDim2.new(1, -165, 1, -30)
PageContainer.BackgroundTransparency = 1

local Pages = {}
local CurrentPage = nil
local CurrentTabBtn = nil

local function NewPage(name)
    local p = Instance.new("ScrollingFrame", PageContainer)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Config.Accent
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 10)

    Pages[name] = p

    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new(Config.Accent, Config.AccentSecondary)
    grad.Enabled = false

    btn.MouseButton1Click:Connect(function()
        if CurrentPage == p then return end

        for _, pg in pairs(Pages) do pg.Visible = false end
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                b.UIGradient.Enabled = false
                _TS:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(180, 180, 180), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            end
        end

        p.Visible = true
        grad.Enabled = true
        _TS:Create(btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        CurrentPage = p
    end)

    if not CurrentPage then
        CurrentPage = p
        p.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        grad.Enabled = true
    end

    return p
end

local function AddToggle(parent, text, default, cb)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -5, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 45, 0, 22)
    btn.Position = UDim2.new(1, -60, 0.5, -11)
    btn.BackgroundColor3 = default and Config.Accent or Color3.fromRGB(45, 45, 45)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        cb(state)
        _TS:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = state and Config.Accent or Color3.fromRGB(45, 45, 45)}):Play()
        _TS:Create(dot, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
    end)
end

-- Custom Drag Logic
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
_UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tabs Creation
local CombatPage = NewPage("Combat")
local VisualsPage = NewPage("Visuals")
local MovementPage = NewPage("Movement")
local MiscPage = NewPage("Misc")

-- Combat
AddToggle(CombatPage, "Aimbot (Hold V)", false, function(v) Config.Aim = v end)
AddToggle(CombatPage, "Team Check", false, function(v) Config.TeamCheck = v end)

-- Visuals
AddToggle(VisualsPage, "ESP Master", false, function(v) Config.ESP = v end)

-- Movement
AddToggle(MovementPage, "Speed Offset", false, function(v) Config.Speed = v and 0.5 or 0 end)
AddToggle(MovementPage, "Infinite Jump", false, function(v) Config.Jump = v end)
AddToggle(MovementPage, "Fly", false, function(v) Config.Fly = v end)
AddToggle(MovementPage, "Noclip", false, function(v) Config.Noclip = v end)

-- Misc
AddToggle(MiscPage, "No Fall Damage", false, function(v) Config.NoFall = v end)
AddToggle(MiscPage, "Infinite Stamina", false, function(v) Config.InfStam = v end)

local Hint = Instance.new("TextLabel", Main)
Hint.Size = UDim2.new(1, 0, 0, 25)
Hint.Position = UDim2.new(0, 0, 1, -25)
Hint.Text = "Press [Right-Shift] to Hide/Show Menu"
Hint.TextColor3 = Color3.fromRGB(120, 120, 120)
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 11
Hint.BackgroundTransparency = 1

_UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then
        Config.Visible = not Config.Visible
        Main.Visible = Config.Visible
    end
end)

-- [[ LOGIC INTEGRATION ]]
_RS.Stepped:Connect(function()
    if _LP.Character then
        for _, v in pairs(_LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not Config.Noclip
            end
        end
    end
end)

_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if char and root and hum then
        if Config.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        if Config.InfStam then
            local stam = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina") or char:FindFirstChild("Energy")
            if stam and stam:IsA("NumberValue") then stam.Value = 100 end
        end
        if Config.Speed > 0 and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * Config.Speed)
        end
        if Config.Fly then
            local cam = _W.CurrentCamera.CFrame
            local moveDir = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then
                root.CFrame = CFrame.new(root.Position + moveDir * 1.5, root.Position + moveDir * 1.5 + cam.LookVector)
            end
            root.Velocity = Vector3.new(0, 0.1, 0)
        end
    end
end)

_RS.RenderStepped:Connect(function()
    -- Aim
    if Config.Aim and _UIS:IsKeyDown(Enum.KeyCode.V) then
        local t = nil; local md = 200
        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild("Torso") and p.Character.Humanoid.Health > 0 then
                if Config.TeamCheck and p.Team == _LP.Team then continue end
                local pos, on = _W.CurrentCamera:WorldToViewportPoint(p.Character.Torso.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if d < md then t = p; md = d end
                end
            end
        end
        if t then
            _W.CurrentCamera.CFrame = CFrame.new(_W.CurrentCamera.CFrame.Position, t.Character.Torso.Position)
        end
    end
    -- ESP
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("Head") then
            local b = p.Character:FindFirstChild("ShadowBill")
            if Config.ESP then
                if Config.TeamCheck and p.Team == _LP.Team then if b then b.Enabled = false end continue end
                if not b then
                    b = Instance.new("BillboardGui", p.Character)
                    b.Name = "ShadowBill"; b.Size = UDim2.new(0, 100, 0, 50); b.AlwaysOnTop = true
                    b.Adornee = p.Character.Head
                    local l = Instance.new("TextLabel", b)
                    l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 0, 0); l.TextSize = 10
                end
                b.Enabled = true
                local myRoot = _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and targetRoot then
                    local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                    b.TextLabel.Text = p.Name .. " [" .. dist .. "m]"
                    b.TextLabel.TextColor3 = p.TeamColor.Color
                end
            elseif b then
                b.Enabled = false
            end
        end
    end
end)

_UIS.JumpRequest:Connect(function()
    if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

print("[V24] BEAUTIFUL SHADOW LOADED. R-SHIFT TO TOGGLE.")
