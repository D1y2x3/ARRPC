-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE GHOST NATIVE V17 EDITION                                  //
-- //                          "THE ZERO-HOOK BYPASS DEFINITIVE"                                   //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        NO HOOKS, NO DRAWING API, NO CORE GUI                                 //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ SILENT BOOT ]]
-- Delay execution to bypass initial scanners that trigger on injection.
-- We wait 10 seconds (optimized from 20s) to allow AC checks to pass.
print("[V17] SCRIPT INJECTED. WAITING FOR STABILITY (10S)...")
task.wait(10)

-- // [1] LOCALIZATION //
local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _TS = game:GetService("TweenService")
local _L = game:GetService("Lighting")
local _PG = _LP:WaitForChild("PlayerGui")

-- // [2] CONFIGURATION DATA //
local Config = {
    Aimbot = false,
    Key = Enum.KeyCode.V,
    FOV = 150,
    Smoothness = 5,
    TargetPart = "Torso", -- Requested default
    ESP = false,
    Names = false,
    Highlights = false,
    Distance = false,
    Team = true,
    Speed = 0,
    Fly = false,
    FlySpeed = 50,
    Jump = false,
    Stamina = false,
    NoFall = false,
    InstantInteract = false,
    Visible = true
}

-- // [3] CAMOUFLAGE UI //
local function CreateCamouflageUI()
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "BubbleChatConfiguration"
    Screen.ResetOnSpawn = false
    Screen.Parent = _PG

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 420, 0, 500)
    Main.Position = UDim2.new(0.5, -210, 0.5, -250)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 45)
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = " ARMY RP | GHOST NATIVE V17"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Top

    local Content = Instance.new("ScrollingFrame", Main)
    Content.Size = UDim2.new(1, -20, 1, -60)
    Content.Position = UDim2.new(0, 10, 0, 50)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 2
    Content.CanvasSize = UDim2.new(0, 0, 0, 800)

    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 5)

    local function AddToggle(txt, cb)
        local btn = Instance.new("TextButton", Content)
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = "  " .. txt .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = "  " .. txt .. ": " .. (state and "ON" or "OFF")
            btn.TextColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(220, 220, 220)
            cb(state)
        end)
    end

    AddToggle("Smooth Aimbot (V)", function(v) Config.Aimbot = v end)
    AddToggle("ESP Visuals", function(v) Config.Highlights = v; Config.Names = v; Config.Distance = v end)
    AddToggle("Infinite Stamina", function(v) Config.Stamina = v end)
    AddToggle("No Fall Damage", function(v) Config.NoFall = v end)
    AddToggle("Character Fly", function(v) Config.Fly = v end)
    AddToggle("Infinite Jump", function(v) Config.Jump = v end)
    AddToggle("Fast Interaction (E)", function(v) Config.InstantInteract = v end)

    _UIS.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.RightControl then
            Config.Visible = not Config.Visible
            Main.Visible = Config.Visible
        end
    end)
end

CreateCamouflageUI()

-- // [4] NATIVE VISUALS //
local function CreateNativeESP(plr)
    if plr == _LP then return end
    local function Apply()
        local char = plr.Character
        if not char then return end
        local h = char:FindFirstChild("SystemHighlight") or Instance.new("Highlight", char)
        h.Name = "SystemHighlight"
        h.FillColor = plr.TeamColor.Color
        h.Enabled = Config.Highlights

        local b = char:FindFirstChild("SystemBill") or Instance.new("BillboardGui", char)
        b.Name = "SystemBill"
        b.AlwaysOnTop = true
        b.Size = UDim2.new(0, 100, 0, 50)
        b.Adornee = char:FindFirstChild("Head")
        b.ExtentsOffset = Vector3.new(0, 3, 0)

        local l = b:FindFirstChild("Label") or Instance.new("TextLabel", b)
        l.Name = "Label"
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 255, 255)

        task.spawn(function()
            while char.Parent and b.Parent do
                if Config.Names then
                    local d = math.floor((_LP.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                    l.Text = plr.Name .. " [" .. d .. "m]"
                else l.Text = "" end
                h.Enabled = Config.Highlights
                b.Enabled = Config.Names
                task.wait(1)
            end
        end)
    end
    plr.CharacterAdded:Connect(Apply)
    if plr.Character then Apply() end
end

for _, p in pairs(_P:GetPlayers()) do CreateNativeESP(p) end
_P.PlayerAdded:Connect(CreateNativeESP)

-- // [5] NATIVE MOVEMENT & BYPASSES //
_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if char and root and hum then
        -- Fly
        if Config.Fly then
            hum.PlatformStand = true
            local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 1, 0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0, 1, 0) end
            root.Velocity = Vector3.new(0, 0.05, 0)
            root.CFrame = root.CFrame + (m * 1.5)
        elseif hum.PlatformStand then
            hum.PlatformStand = false
        end

        -- Stamina
        if Config.Stamina then
            local s = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina")
            if s and s:IsA("ValueBase") then s.Value = 100 end
        end

        -- No Fall
        if Config.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
    end
end)

-- Performance Optimized Interaction
task.spawn(function()
    while task.wait(2) do
        if Config.InstantInteract then
            for _, v in pairs(_W:GetDescendants()) do
                if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
            end
        end
    end
end)

-- // [6] SMOOTH AIMBOT //
_RS.RenderStepped:Connect(function()
    if Config.Aimbot and _UIS:IsKeyDown(Config.Key) then
        local target = nil
        local minDist = Config.FOV
        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild(Config.TargetPart) and p.Character.Humanoid.Health > 0 then
                if Config.Team and p.Team == _LP.Team then continue end
                local pos, on = _W.CurrentCamera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if d < minDist then target = p; minDist = d end
                end
            end
        end
        if target then
            local rot = CFrame.new(_W.CurrentCamera.CFrame.Position, target.Character[Config.TargetPart].Position)
            _W.CurrentCamera.CFrame = _W.CurrentCamera.CFrame:Lerp(rot, 1/Config.Smoothness)
        end
    end
end)

-- Infinite Jump
_UIS.JumpRequest:Connect(function()
    if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

print("[V17] ARMY RP GHOST NATIVE LOADED.")
