-- // ========================================== //
-- // ARMY RP MINIMAL SHADOW V23 EDITION      //
-- // DEVELOPED BY JULES - ZERO-HOOK MINIMAL   //
-- // ========================================== //

print("[V23] INITIALIZING SHADOW MODE. PLEASE WAIT 10S...")
task.wait(10)

local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _RS = game:GetService("RunService")

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
    Visible = true
}

-- [[ MINIMAL UI ]]
local Screen = Instance.new("ScreenGui", _LP:WaitForChild("PlayerGui"))
Screen.Name = "SystemConfig"
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 200, 0, 355)
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Instance.new("UICorner", Main)

-- Custom Drag
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

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = " SHADOW V23 | R-SHIFT"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left; Title.TextSize = 12

local List = Instance.new("Frame", Main)
List.Size = UDim2.new(1, -10, 1, -30)
List.Position = UDim2.new(0, 5, 0, 30)
List.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", List); Layout.Padding = UDim.new(0, 5)

local function NewBtn(txt, cb)
    local b = Instance.new("TextButton", List)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = txt .. ": " .. (state and "ON" or "OFF")
        b.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        cb(state)
    end)
end

NewBtn("Aimbot (V)", function(v) Config.Aim = v end)
NewBtn("ESP", function(v) Config.ESP = v end)
NewBtn("Team Check", function(v) Config.TeamCheck = v end)
NewBtn("Speed", function(v) Config.Speed = v and 0.5 or 0 end)
NewBtn("Inf Jump", function(v) Config.Jump = v end)
NewBtn("Fly", function(v) Config.Fly = v end)
NewBtn("Noclip", function(v) Config.Noclip = v end)
NewBtn("No Fall", function(v) Config.NoFall = v end)
NewBtn("Inf Stamina", function(v) Config.InfStam = v end)

_UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then
        Config.Visible = not Config.Visible
        Main.Visible = Config.Visible
    end
end)

-- [[ LOGIC ]]
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
        -- No Fall
        if Config.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end

        -- Inf Stamina (Generic implementation for many RP games)
        if Config.InfStam then
            local stam = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina") or char:FindFirstChild("Energy")
            if stam and stam:IsA("NumberValue") then
                stam.Value = 100
            end
        end

        -- Safe Speed Offset (CFrame)
        if Config.Speed > 0 and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * Config.Speed)
        end

        -- Fly
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
                if Config.TeamCheck and p.Team == _LP.Team then
                    if b then b.Enabled = false end
                    continue
                end

                if not b then
                    b = Instance.new("BillboardGui", p.Character)
                    b.Name = "ShadowBill"; b.Size = UDim2.new(0, 100, 0, 50); b.AlwaysOnTop = true
                    b.Adornee = p.Character.Head
                    local l = Instance.new("TextLabel", b)
                    l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255, 0, 0); l.TextSize = 10
                end
                b.Enabled = true
                -- Nil-check for Local Character
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

print("[V23] SHADOW LOADED. R-SHIFT TO TOGGLE.")
