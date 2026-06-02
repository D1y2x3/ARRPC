-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE GHOST PRO V20 EDITION                                     //
-- //                          "THE SUPREME STEALTH DEFINITIVE"                                   //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        COMPREHENSIVE BYPASS + PREMIUM INTERFACE                              //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ SILENT BOOT ]]
-- We wait for the game to stabilize before activating our systems.
print("[V20 PRO] BOOTING SYSTEM. PLEASE WAIT 10S...")
task.wait(10)

-- // [1] SERVICES & LOCALIZATION //
local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _TS = game:GetService("TweenService")
local _VU = game:GetService("VirtualUser")
local _PG = _LP:WaitForChild("PlayerGui")

-- // [2] PRIVATE CONFIGURATION //
local Config = {
    Combat = {
        Aimbot = false,
        Key = Enum.KeyCode.V,
        FOV = 150,
        Smooth = 5,
        Hitbox = 2,
        Ammo = false,
        TargetPart = "Torso"
    },
    Visuals = {
        Enabled = false,
        Names = false,
        Dist = false,
        Health = false,
        Team = true
    },
    Movement = {
        Speed = 0,
        Fly = false,
        FlySpeed = 50,
        Jump = false,
        Stamina = false,
        NoFall = false,
        Spinbot = false,
        Noclip = false
    },
    Teleport = {
        SafeMode = true
    },
    Misc = {
        Interact = false,
        AntiAFK = false
    },
    UI = {
        Visible = true
    }
}

-- // [3] PREMIUM CUSTOM UI (NO LIBRARIES) //
local function BuildPremiumUI()
    local Screen = Instance.new("ScreenGui", _PG); Screen.Name = "SystemConfig_S2"; Screen.ResetOnSpawn = false

    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 400)
    Main.Position = UDim2.new(0.5, -250, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
    local UICorner = Instance.new("UICorner", Main); UICorner.CornerRadius = UDim.new(0, 10)

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Sidebar.BorderSizePixel = 0
    local SBCorner = Instance.new("UICorner", Sidebar); SBCorner.CornerRadius = UDim.new(0, 10)

    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 50); Logo.Text = "GHOST PRO"; Logo.TextColor3 = Color3.fromRGB(0, 160, 255); Logo.Font = Enum.Font.GothamBold; Logo.TextSize = 16; Logo.BackgroundTransparency = 1

    local TabCont = Instance.new("Frame", Sidebar); TabCont.Size = UDim2.new(1, 0, 1, -60); TabCont.Position = UDim2.new(0, 0, 0, 60); TabCont.BackgroundTransparency = 1
    local TabLay = Instance.new("UIListLayout", TabCont); TabLay.Padding = UDim.new(0, 5)

    -- Pages
    local PageCont = Instance.new("Frame", Main); PageCont.Size = UDim2.new(1, -150, 1, -20); PageCont.Position = UDim2.new(0, 145, 0, 10); PageCont.BackgroundTransparency = 1
    local Pages = {}

    local function CreatePage(name)
        local P = Instance.new("ScrollingFrame", PageCont); P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 1; P.CanvasSize = UDim2.new(0,0,0,600)
        local PageLayout = Instance.new("UIListLayout", P); PageLayout.Padding = UDim.new(0, 5)
        Pages[name] = P

        local B = Instance.new("TextButton", TabCont); B.Size = UDim2.new(1, -10, 0, 35); B.Position = UDim2.new(0, 5, 0, 0); B.BackgroundColor3 = Color3.fromRGB(30, 30, 30); B.Text = name; B.TextColor3 = Color3.fromRGB(200, 200, 200); B.Font = Enum.Font.Gotham; B.TextSize = 12; B.BorderSizePixel = 0
        Instance.new("UICorner", B)
        B.MouseButton1Click:Connect(function() for _, p in pairs(Pages) do p.Visible = false end; P.Visible = true end)
        return P
    end

    local CombatPage = CreatePage("Combat")
    local VisualsPage = CreatePage("Visuals")
    local MovementPage = CreatePage("Movement")
    local MiscPage = CreatePage("Misc")
    CombatPage.Visible = true

    local function AddTog(p, txt, tab, key)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = "  " .. txt .. ": OFF"; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.Gotham; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left; b.BorderSizePixel = 0; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config[tab][key] = not Config[tab][key]
            local s = Config[tab][key]
            b.Text = "  " .. txt .. ": " .. (s and "ON" or "OFF")
            b.TextColor3 = s and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
        end)
    end

    local function AddSli(p, txt, min, max, cur, tab, key)
        local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 15); l.Text = txt .. ": " .. cur; l.TextColor3 = Color3.fromRGB(150, 150, 150); l.BackgroundTransparency = 1; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left
        local i = Instance.new("TextBox", f); i.Size = UDim2.new(1, -20, 0, 20); i.Position = UDim2.new(0, 10, 0, 25); i.BackgroundColor3 = Color3.fromRGB(30, 30, 30); i.Text = tostring(cur); i.TextColor3 = Color3.fromRGB(255, 255, 255); i.BorderSizePixel = 0; Instance.new("UICorner", i)
        i.FocusLost:Connect(function() local v = tonumber(i.Text); if v then v = math.clamp(v, min, max); Config[tab][key] = v; l.Text = txt .. ": " .. v end end)
    end

    AddTog(CombatPage, "Aimbot (V Hold)", "Combat", "Aimbot"); AddSli(CombatPage, "FOV", 0, 800, 150, "Combat", "FOV")
    AddTog(CombatPage, "Infinite Ammo", "Combat", "Ammo"); AddSli(CombatPage, "Hitbox Size", 2, 20, 2, "Combat", "Hitbox")

    AddTog(VisualsPage, "Master ESP", "Visuals", "Enabled"); AddTog(VisualsPage, "ESP Names", "Visuals", "Names"); AddTog(VisualsPage, "ESP Dist", "Visuals", "Dist"); AddTog(VisualsPage, "ESP Health", "Visuals", "Health")

    AddSli(MovementPage, "Speed Offset", 0, 100, 0, "Movement", "Speed"); AddTog(MovementPage, "Character Fly", "Movement", "Fly"); AddTog(MovementPage, "Infinite Jump", "Movement", "Jump")
    AddTog(MovementPage, "Noclip", "Movement", "Noclip"); AddTog(MovementPage, "Infinite Stamina", "Movement", "Stamina"); AddTog(MovementPage, "No Fall Damage", "Movement", "NoFall"); AddTog(MovementPage, "Spinbot Defense", "Movement", "Spinbot")

    AddTog(MiscPage, "Instant Interaction", "Misc", "Interact"); AddTog(MiscPage, "Anti-AFK", "Misc", "AntiAFK")

    _UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightShift then Config.UI.Visible = not Config.UI.Visible; Main.Visible = Config.UI.Visible end end)
end

BuildPremiumUI()

-- // [4] DYNAMIC UTILITIES //
local function GetTarget()
    local t = nil; local md = Config.Combat.FOV
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if Config.Visuals.Team and p.Team == _LP.Team then continue end
            local r = p.Character:FindFirstChild(Config.Combat.TargetPart) or p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local pos, on = _W.CurrentCamera:WorldToViewportPoint(r.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if d < md then t = p; md = d end
                end
            end
        end
    end
    return t
end

-- // [5] CORE BYPASSES & LOGIC //

-- WEAPON SCANNER
task.spawn(function()
    while task.wait(2) do
        if Config.Combat.Ammo then
            local t = _LP.Character and _LP.Character:FindFirstChildOfClass("Tool")
            if t then
                pcall(function()
                    for _, v in pairs(t:GetDescendants()) do
                        if v:IsA("ValueBase") then
                            local n = v.Name:lower()
                            if n:find("ammo") or n:find("mag") then v.Value = 999 end
                        end
                    end
                end)
            end
        end
    end
end)

-- PHYSICS LOOP
_RS.Heartbeat:Connect(function()
    local c = _LP.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChild("Humanoid")
    if c and r and h then
        if Config.Movement.Speed > 0 and not Config.Movement.Fly and h.MoveDirection.Magnitude > 0 then r.CFrame = r.CFrame + (h.MoveDirection * (Config.Movement.Speed / 100)) end
        if Config.Movement.Fly then
            h.PlatformStand = true; local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            r.Velocity = Vector3.new(0,0.05,0); r.CFrame = r.CFrame + (m * 1.5)
        elseif h.PlatformStand then h.PlatformStand = false end
        if Config.Movement.Stamina then local s = c:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if Config.Movement.NoFall then if h:GetState() == Enum.HumanoidStateType.FallingDown then h:ChangeState(Enum.HumanoidStateType.Running) end end
        if Config.Movement.Noclip then
            for _, v in pairs(c:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        -- Hitbox
        if tick() % 1 < 0.1 then
            for _, p in pairs(_P:GetPlayers()) do
                if p ~= _LP and p.Character then
                    for _, n in pairs({"Head", "Torso", "HumanoidRootPart"}) do
                        local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(Config.Combat.Hitbox, Config.Combat.Hitbox, Config.Combat.Hitbox); t.Transparency = 0.5; t.CanCollide = false end
                    end
                end
            end
        end
    end
    if Config.Misc.AntiAFK then pcall(function() _VU:CaptureController(); _VU:ClickButton2(Vector2.new()) end) end
end)

-- Performance Interaction
task.spawn(function()
    while task.wait(3) do
        if Config.Misc.Interact then for _,v in pairs(_W:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
    end
end)

-- VISUALS SYSTEM (OPTIMIZED SINGLE LOOP)
local ESP_Reg = {}
local function ApplyESP(plr)
    if plr == _LP then return end
    local function Create()
        local char = plr.Character; if not char then return end
        local b = Instance.new("BillboardGui", char); b.Name = "GB"; b.AlwaysOnTop = true; b.Size = UDim2.new(0,100,0,50); b.Adornee = char:FindFirstChild("Head")
        local l = Instance.new("TextLabel", b); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,255,255); l.TextSize = 10
        local h = Instance.new("Highlight", char); h.Name = "GH"; h.FillColor = plr.TeamColor.Color
        ESP_Reg[plr] = {Bill = b, Label = l, High = h}
    end
    plr.CharacterAdded:Connect(Create); if plr.Character then Create() end
end

_P.PlayerAdded:Connect(ApplyESP)
_P.PlayerRemoving:Connect(function(p) ESP_Reg[p] = nil end)
for _,p in pairs(_P:GetPlayers()) do ApplyESP(p) end

_RS.RenderStepped:Connect(function()
    -- ESP UPDATE
    for p, obs in pairs(ESP_Reg) do
        local c = p.Character
        if c and c.Parent and Config.Visuals.Enabled then
            obs.High.Enabled = true; obs.Bill.Enabled = true
            local r = c:FindFirstChild("HumanoidRootPart")
            local h = c:FindFirstChild("Humanoid")
            if r and h and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then
                local d = math.floor((_LP.Character.HumanoidRootPart.Position - r.Position).Magnitude)
                local txt = ""; if Config.Visuals.Names then txt = p.Name end; if Config.Visuals.Dist then txt = txt .. " [" .. d .. "m]" end; if Config.Visuals.Health then txt = txt .. " (" .. math.floor(h.Health) .. "%)" end; obs.Label.Text = txt
            end
        else
            if obs.High then obs.High.Enabled = false end
            if obs.Bill then obs.Bill.Enabled = false end
        end
    end
    -- AIMBOT
    if Config.Combat.Aimbot and _UIS:IsKeyDown(Config.Combat.Key) then
        local t = GetTarget()
        if t and t.Character then
            local rot = CFrame.new(_W.CurrentCamera.CFrame.Position, t.Character[Config.Combat.TargetPart].Position)
            _W.CurrentCamera.CFrame = _W.CurrentCamera.CFrame:Lerp(rot, 1/Config.Combat.Smooth)
        end
    end
end)

_UIS.JumpRequest:Connect(function() if Config.Movement.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0) end end)

print("[V20 PRO] ULTIMATE STEALTH ACTIVATED. R-SHIFT TO TOGGLE.")
