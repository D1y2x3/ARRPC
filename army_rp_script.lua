-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE GHOST PRO V18 EDITION                                     //
-- //                          "THE DEFINITIVE AESTHETIC REBIRTH"                                  //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        NO HOOKS, NO DRAWING API, CUSTOM PRO UI                               //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ SILENT BOOT ]]
-- We wait for the game environment to settle before initializing our stealth modules.
print("[V18 PRO] SCRIPT INJECTED. INITIALIZING STEALTH (5S)...")
task.wait(5)

-- // [1] LOCALIZATION //
local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _TS = game:GetService("TweenService")
local _L = game:GetService("Lighting")
local _VU = game:GetService("VirtualUser")
local _PG = _LP:WaitForChild("PlayerGui")

-- // [2] CONFIGURATION DATA //
local Config = {
    Aimbot = false,
    Key = Enum.KeyCode.V,
    FOV = 150,
    Smoothness = 5,
    TargetPart = "Torso",
    ESP = false,
    Highlights = false,
    Names = false,
    Distance = false,
    Team = true,
    Speed = 0,
    Fly = false,
    FlySpeed = 50,
    Jump = false,
    Recoil = false,
    Ammo = false,
    Stamina = false,
    NoFall = false,
    InstantInteract = false,
    AntiAFK = false,
    Visible = true
}

-- // [3] PRO CUSTOM UI SYSTEM (NO LIBRARIES) //
local function CreateProUI()
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "SystemChatConfig" -- Camouflage name
    Screen.ResetOnSpawn = false
    Screen.Parent = _PG

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 550, 0, 400)
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    local _Corner = Instance.new("UICorner", Main); _Corner.CornerRadius = UDim.new(0, 8)

    -- Sidebar for Navigation
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    local _SBCorner = Instance.new("UICorner", Sidebar); _SBCorner.CornerRadius = UDim.new(0, 8)

    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.Text = "GHOST PRO V18"
    Logo.TextColor3 = Color3.fromRGB(0, 150, 255)
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 16
    Logo.BackgroundTransparency = 1

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.Padding = UDim.new(0, 5)

    -- Pages Management
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -160, 1, -20)
    PageContainer.Position = UDim2.new(0, 155, 0, 10)
    PageContainer.BackgroundTransparency = 1

    local Pages = {}
    local function CreatePage(name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 5)
        Pages[name] = Page

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.Position = UDim2.new(0, 5, 0, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn)
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            Page.Visible = true
        end)
        return Page
    end

    local CombatPage = CreatePage("Combat")
    local VisualsPage = CreatePage("Visuals")
    local MovementPage = CreatePage("Movement")
    local MiscPage = CreatePage("Misc")
    CombatPage.Visible = true

    local function AddToggle(parent, txt, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.Text = "  " .. txt .. ": OFF"
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BorderSizePixel = 0
        Instance.new("UICorner", btn)

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = "  " .. txt .. ": " .. (state and "ON" or "OFF")
            btn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(200, 200, 200)
            cb(state)
        end)
    end

    local function AddSlider(parent, txt, min, max, cur, cb)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 50); f.BackgroundColor3 = Color3.fromRGB(22, 22, 22); f.BorderSizePixel = 0; Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = "  " .. txt .. ": " .. cur; l.TextColor3 = Color3.fromRGB(150, 150, 150); l.BackgroundTransparency = 1; l.TextSize = 11; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left
        local i = Instance.new("TextBox", f); i.Size = UDim2.new(1, -20, 0, 20); i.Position = UDim2.new(0, 10, 0, 25); i.BackgroundColor3 = Color3.fromRGB(35, 35, 35); i.Text = tostring(cur); i.TextColor3 = Color3.fromRGB(255, 255, 255); i.BorderSizePixel = 0; Instance.new("UICorner", i)
        i.FocusLost:Connect(function() local v = tonumber(i.Text); if v then v = math.clamp(v, min, max); cb(v); l.Text = "  " .. txt .. ": " .. v end end)
    end

    -- Feature Population
    AddToggle(CombatPage, "Smooth Aimbot", function(v) Config.Aimbot = v end)
    AddSlider(CombatPage, "Smoothness", 1, 20, 5, function(v) Config.Smoothness = v end)
    AddToggle(CombatPage, "Weapon No-Recoil", function(v) Config.Recoil = v end)
    AddToggle(CombatPage, "Weapon Infinite Ammo", function(v) Config.Ammo = v end)

    AddToggle(VisualsPage, "ESP Master Highlights", function(v) Config.Highlights = v end)
    AddToggle(VisualsPage, "ESP Player Names", function(v) Config.Names = v end)
    AddToggle(VisualsPage, "ESP Distance Info", function(v) Config.Distance = v end)

    AddSlider(MovementPage, "WalkSpeed Offset", 0, 100, 0, function(v) Config.Speed = v end)
    AddToggle(MovementPage, "Safe Character Fly", function(v) Config.Fly = v end)
    AddToggle(MovementPage, "Safe Infinite Jump", function(v) Config.Jump = v end)
    AddToggle(MovementPage, "Passive No-Fall Damage", function(v) Config.NoFall = v end)
    AddToggle(MovementPage, "Infinite Stamina", function(v) Config.Stamina = v end)

    AddToggle(MiscPage, "Instant Interaction (E)", function(v) Config.InstantInteract = v end)
    AddToggle(MiscPage, "Anti-AFK Protection", function(v) Config.AntiAFK = v end)

    _UIS.InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.RightControl then
            Config.Visible = not Config.Visible
            Main.Visible = Config.Visible
        end
    end)
    print("[V18 PRO] Camouflage Interface Loaded.")
end

CreateProUI()

-- // [4] CORE LOGIC MODULES (ZERO-HOOK) //

-- MODULE: WEAPON SCANNER
task.spawn(function()
    while task.wait(1.5) do
        if Config.Recoil or Config.Ammo then
            local tool = _LP.Character and _LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("ValueBase") then
                            local n = v.Name:lower()
                            if Config.Recoil and (n:find("recoil") or n:find("kick") or n:find("shake")) then v.Value = 0 end
                            if Config.Ammo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
                        end
                    end
                end)
            end
        end
    end
end)

-- MODULE: MOVEMENT & BYPASSES
_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if char and root and hum then
        -- STEALTH WALK SPEED (CFrame Offset)
        if Config.Speed > 0 and not Config.Fly and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (Config.Speed / 100))
        end

        -- STEALTH FLIGHT (CFrame Method)
        if Config.Fly then
            hum.PlatformStand = true
            local moveDir = Vector3.new(0, 0, 0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            root.Velocity = Vector3.new(0, 0.05, 0) -- Fake physics to stay active
            root.CFrame = root.CFrame + (moveDir * (Config.FlySpeed / 50))
        elseif hum.PlatformStand then
            hum.PlatformStand = false
        end

        -- STEALTH STAMINA
        if Config.Stamina then
            local s = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina")
            if s and s:IsA("ValueBase") then s.Value = 100 end
        end

        -- NO FALL DAMAGE
        if Config.NoFall then
            if hum:GetState() == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
    end

    -- ANTI-AFK (Virtual Inputs)
    if Config.AntiAFK then
        pcall(function() _VU:CaptureController(); _VU:ClickButton2(Vector2.new()) end)
    end
end)

-- THREAD: PERFORMANCE OPTIMIZED INTERACTION
task.spawn(function()
    while task.wait(3) do -- Throttled to prevent lag
        if Config.InstantInteract then
            for _, v in pairs(_W:GetDescendants()) do
                if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
            end
        end
    end
end)

-- MODULE: NATIVE VISUALS (HIGHLIGHTS & BILLBOARDS)
local function ApplyESP(plr)
    if plr == _LP then return end
    local function Create()
        local char = plr.Character
        if not char then return end

        local h = char:FindFirstChild("GhostH") or Instance.new("Highlight", char)
        h.Name = "GhostH"; h.FillColor = plr.TeamColor.Color

        local b = char:FindFirstChild("GhostB") or Instance.new("BillboardGui", char)
        b.Name = "GhostB"; b.AlwaysOnTop = true; b.Size = UDim2.new(0,100,0,50); b.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

        local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
        l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,255,255); l.TextSize = 12

        task.spawn(function()
            while char.Parent and b.Parent do
                if not Config.Names and not Config.Distance then
                    b.Enabled = false
                else
                    b.Enabled = true
                    local dist = 0
                    if _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
                        dist = math.floor((_LP.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                    end

                    if Config.Names and Config.Distance then l.Text = plr.Name .. " [" .. dist .. "m]"
                    elseif Config.Names then l.Text = plr.Name
                    elseif Config.Distance then l.Text = "[" .. dist .. "m]" end
                end
                h.Enabled = Config.Highlights
                task.wait(1)
            end
        end)
    end
    plr.CharacterAdded:Connect(Create); if plr.Character then Create() end
end

for _, p in pairs(_P:GetPlayers()) do ApplyESP(p) end
_P.PlayerAdded:Connect(ApplyESP)

-- MODULE: SMOOTH CAMERA AIMBOT
_RS.RenderStepped:Connect(function()
    if Config.Aimbot and _UIS:IsKeyDown(Config.Key) then
        local target = nil
        local minDist = Config.FOV

        for _, p in pairs(_P:GetPlayers()) do
            if p ~= _LP and p.Character and p.Character:FindFirstChild(Config.TargetPart) and p.Character.Humanoid.Health > 0 then
                if Config.Team and p.Team == _LP.Team then continue end
                local pos, onScreen = _W.CurrentCamera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                if onScreen then
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

-- AIR-STEP JUMP BYPASS
_UIS.JumpRequest:Connect(function()
    if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
        _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

print("[V18 PRO] ARMY RP GHOST PRO FULLY OPERATIONAL.")
print("[V18 PRO] BY JULES. ABSOLUTE STEALTH REBORN.")
