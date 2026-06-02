-- // ========================================== //
-- // ARMY RP MINIMAL SHADOW V21 EDITION      //
-- // DEVELOPED BY JULES - ZERO-HOOK MINIMAL   //
-- // ========================================== //

print("[V21] INITIALIZING SHADOW MODE. PLEASE WAIT 20S...")
task.wait(20)

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
    Visible = true
}

-- [[ MINIMAL UI ]]
local Screen = Instance.new("ScreenGui", _LP:WaitForChild("PlayerGui"))
Screen.Name = "SystemConfig"
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 200, 0, 180)
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = " SHADOW V21 | R-SHIFT"
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
NewBtn("Speed", function(v) Config.Speed = v and 0.5 or 0 end)
NewBtn("Inf Jump", function(v) Config.Jump = v end)

_UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then
        Config.Visible = not Config.Visible
        Main.Visible = Config.Visible
    end
end)

-- [[ LOGIC ]]
_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if char and root and hum then
        -- Safe Speed Offset (CFrame)
        if Config.Speed > 0 and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * Config.Speed)
        end
    end
end)

_RS.RenderStepped:Connect(function()
    -- Aim
    if Config.Aim and _UIS:IsKeyDown(Enum.KeyCode.V) then
        local t = nil; local md = 200
        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild("Torso") and p.Character.Humanoid.Health > 0 then
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

print("[V21] SHADOW LOADED. R-SHIFT TO TOGGLE.")
