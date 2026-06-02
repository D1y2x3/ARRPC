-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE TRUE GHOST V19 EDITION                                    //
-- //                          "THE DEEP STEALTH DEFINITIVE"                                       //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        ABSOLUTE MINIMALISM, ZERO HOOKS, ZERO SIGNATURES                      //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ SILENT INITIALIZATION ]]
print("[V19] DEPLOYING GHOST ENVIRONMENT. WAITING 15S...")
task.wait(15)

-- // [1] LOCALIZATION //
local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _PG = _LP:WaitForChild("PlayerGui")

-- // [2] PRIVATE CONFIGURATION //
local Config = {
    Aimbot = false, Key = Enum.KeyCode.V, FOV = 150, Smooth = 5, Target = "Torso",
    ESP = false, Names = false, Dist = false, Health = false,
    Speed = 0, Fly = false, FlySpeed = 50, Jump = false,
    Recoil = false, Ammo = false, Hitbox = 2,
    Stamina = false, NoFall = false, Interact = false,
    Visible = true
}

-- // [3] CAMOUFLAGE UI (BYPASSES GUI SCANNERS) //
local function BuildGhostUI()
    local S = Instance.new("ScreenGui", _PG); S.Name = "BubbleChatStorage"; S.ResetOnSpawn = false
    local M = Instance.new("Frame", S); M.Size = UDim2.new(0, 320, 0, 450); M.Position = UDim2.new(0.5, -160, 0.5, -225); M.BackgroundColor3 = Color3.fromRGB(15, 15, 15); M.BorderSizePixel = 0; M.Active = true; M.Draggable = true
    Instance.new("UICorner", M)

    local T = Instance.new("TextLabel", M); T.Size = UDim2.new(1, 0, 0, 35); T.BackgroundTransparency = 1; T.Text = " GHOST V19 | R-CTRL"; T.TextColor3 = Color3.fromRGB(0, 180, 255); T.TextXAlignment = Enum.TextXAlignment.Left; T.Font = Enum.Font.GothamBold; T.TextSize = 13
    local C = Instance.new("ScrollingFrame", M); C.Size = UDim2.new(1, -20, 1, -50); C.Position = UDim2.new(0, 10, 0, 40); C.BackgroundTransparency = 1; C.ScrollBarThickness = 2; C.CanvasSize = UDim2.new(0,0,0,850)
    local L = Instance.new("UIListLayout", C); L.Padding = UDim.new(0, 5)

    local function Tog(txt, prop)
        local b = Instance.new("TextButton", C); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = "  " .. txt .. ": OFF"; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.TextXAlignment = Enum.TextXAlignment.Left; b.BorderSizePixel = 0; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            Config[prop] = not Config[prop]
            b.Text = "  " .. txt .. ": " .. (Config[prop] and "ON" or "OFF")
            b.TextColor3 = Config[prop] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)
        end)
    end

    local function Sli(txt, min, max, prop)
        local f = Instance.new("Frame", C); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 15); l.Text = txt .. ": " .. Config[prop]; l.TextColor3 = Color3.fromRGB(150, 150, 150); l.BackgroundTransparency = 1; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left
        local i = Instance.new("TextBox", f); i.Size = UDim2.new(1, 0, 0, 25); i.Position = UDim2.new(0, 0, 0, 18); i.BackgroundColor3 = Color3.fromRGB(30, 30, 30); i.Text = tostring(Config[prop]); i.TextColor3 = Color3.fromRGB(255, 255, 255); i.BorderSizePixel = 0; Instance.new("UICorner", i)
        i.FocusLost:Connect(function() local v = tonumber(i.Text); if v then v = math.clamp(v, min, max); Config[prop] = v; l.Text = txt .. ": " .. v end end)
    end

    Tog("Smooth Aimbot", "Aimbot"); Sli("Aimbot Smooth", 1, 20, "Smooth"); Sli("Aimbot FOV", 10, 800, "FOV")
    Tog("Weapon Mods", "Recoil"); Tog("Infinite Ammo", "Ammo"); Sli("Hitbox Size", 2, 20, "Hitbox")
    Tog("Master ESP", "ESP"); Tog("ESP Names", "Names"); Tog("ESP Distance", "Dist"); Tog("ESP Health", "Health")
    Sli("Speed Offset", 0, 100, "Speed"); Tog("Character Fly", "Fly"); Tog("Infinite Jump", "Jump")
    Tog("Infinite Stamina", "Stamina"); Tog("No Fall Damage", "NoFall"); Tog("Fast Interaction", "Interact")

    _UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightControl then Config.Visible = not Config.Visible; M.Visible = Config.Visible end end)
end

BuildGhostUI()

-- // [4] CORE LOGIC (ZERO DETECTABLE HOOKS) //

-- Targeting Logic
local function GetClosest()
    local t = nil; local md = Config.FOV
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild(Config.Target) and p.Character.Humanoid.Health > 0 then
            local pos, on = _W.CurrentCamera:WorldToViewportPoint(p.Character[Config.Target].Position)
            if on then
                local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if d < md then t = p; md = d end
            end
        end
    end
    return t
end

-- Weapon Scan Logic
task.spawn(function()
    while task.wait(2) do
        if Config.Recoil or Config.Ammo then
            local tool = _LP.Character and _LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("ValueBase") then
                            local n = v.Name:lower()
                            if Config.Recoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end
                            if Config.Ammo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end
                        end
                    end
                end)
            end
        end
    end
end)

-- Visual Update Loop
local function ApplyESP(plr)
    if plr == _LP then return end
    local function Create()
        local char = plr.Character
        if not char then return end
        local b = char:FindFirstChild("GhostBill") or Instance.new("BillboardGui", char); b.Name = "GhostBill"; b.AlwaysOnTop = true; b.Size = UDim2.new(0,100,0,50); b.Adornee = char:FindFirstChild("Head")
        local l = b:FindFirstChild("L") or Instance.new("TextLabel", b); l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,255,255); l.TextSize = 10
        local h = char:FindFirstChild("GhostH") or Instance.new("Highlight", char); h.Name = "GhostH"; h.FillColor = plr.TeamColor.Color
        task.spawn(function()
            while char.Parent and b.Parent do
                if Config.ESP then
                    h.Enabled = true; b.Enabled = true
                    local dist = math.floor((_LP.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                    local txt = ""
                    if Config.Names then txt = plr.Name end
                    if Config.Dist then txt = txt .. " [" .. dist .. "m]" end
                    if Config.Health then txt = txt .. " (" .. math.floor(char.Humanoid.Health) .. "%)" end
                    l.Text = txt
                else h.Enabled = false; b.Enabled = false end
                task.wait(0.1) -- Fast update for ESP
            end
        end)
    end
    plr.CharacterAdded:Connect(Create); if plr.Character then Create() end
end
for _, p in pairs(_P:GetPlayers()) do ApplyESP(p) end
_P.PlayerAdded:Connect(ApplyESP)

-- Main Physics & Combat Loop
_RS.Heartbeat:Connect(function()
    local char = _LP.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and root then
        -- Safe Speed
        if Config.Speed > 0 and not Config.Fly and hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * (Config.Speed / 100)) end
        -- Fly
        if Config.Fly then
            hum.PlatformStand = true; local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            root.Velocity = Vector3.new(0, 0.05, 0); root.CFrame = root.CFrame + (m * (Config.FlySpeed/50))
        elseif hum.PlatformStand then hum.PlatformStand = false end
        -- Mods
        if Config.Stamina then local s = char:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if Config.NoFall then if hum:GetState() == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.Running) end end
        -- Hitbox
        if tick() % 1 < 0.1 then
            for _, p in pairs(_P:GetPlayers()) do
                if p ~= _LP and p.Character then
                    for _, n in pairs({"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do
                        local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(Config.Hitbox, Config.Hitbox, Config.Hitbox); t.Transparency = 0.5; t.CanCollide = false end
                    end
                end
            end
        end
    end
end)

-- Render Loop (Aimbot)
_RS.RenderStepped:Connect(function()
    if Config.Aimbot and _UIS:IsKeyDown(Config.Key) then
        local t = GetClosest()
        if t and t.Character then
            local rot = CFrame.new(_W.CurrentCamera.CFrame.Position, t.Character[Config.Target].Position)
            _W.CurrentCamera.CFrame = _W.CurrentCamera.CFrame:Lerp(rot, 1/Config.Smooth)
        end
    end
end)

_UIS.JumpRequest:Connect(function() if Config.Jump and _LP.Character and _LP.Character:FindFirstChild("HumanoidRootPart") then _LP.Character.HumanoidRootPart.CFrame = _LP.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0) end end)

print("[V19] GHOST NATIVE LOADED SUCCESSFULLY.")
