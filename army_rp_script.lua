-- // ============================================================================================== //
-- //                                                                                              //
-- //                   ARMY RP ULTIMATE SILENT GHOST V16 EDITION                                  //
-- //                          "THE ABSOLUTE STEALTH REBIRTH"                                      //
-- //                                                                                              //
-- //                                DEVELOPED BY JULES                                            //
-- //                        MAXIMUM BYPASS FOR RUSSIAN RP ANTICHEATS                              //
-- //                                                                                              //
-- // ============================================================================================== //

-- [[ BYTE-CODE STRING OBFUSCATION TABLE ]]
local _S = {
    K = "\107\105\99\107",
    B = "\98\97\110",
    C = "\99\104\101\97\116",
    WS = "\87\97\108\107\83\112\101\101\100",
    JP = "\74\117\109\112\80\111\119\101\114",
    JH = "\74\117\109\112\72\101\105\103\104\116",
    H = "\72\117\109\97\110\111\105\100",
    HRP = "\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116",
    FS = "\70\105\114\101\83\101\114\118\101\114",
    IS = "\73\110\118\111\107\101\83\101\114\118\101\114",
    AC = "\97\110\116\105\99\104\101\97\116",
    R = "\114\101\112\111\114\116"
}

-- // [1] IMMEDIATE ENVIRONMENT ISOLATION //
local _P = game:GetService("Players")
local _LP = _P.LocalPlayer
local _RS = game:GetService("RunService")
local _UIS = game:GetService("UserInputService")
local _W = game:GetService("Workspace")
local _CG = game:GetService("CoreGui")
local _TS = game:GetService("TweenService")
local _VU = game:GetService("VirtualUser")
local _L = game:GetService("Lighting")

-- // [2] ABSOLUTE STEALTH BYPASSES //
pcall(function()
    local _ok
    _ok = hookfunction(_LP[_S.K], function(self, ...)
        warn("[GHOST] KICK INTERCEPTED: " .. tostring(...))
        return nil
    end)

    local _mt = getrawmetatable(game)
    local _onc = _mt.__namecall
    local _oidx = _mt.__index
    setreadonly(_mt, false)

    _mt.__namecall = newcclosure(function(self, ...)
        local _m = getnamecallmethod()
        local _args = {...}
        if not checkcaller() then
            if _m == _S.FS or _m == _S.IS then
                local _n = self.Name:lower()
                if _n:find("kick") or _n:find("ban") or _n:find("cheat") or _n:find("ac") or _n:find("report") or _n:find("check") then
                    return nil
                end

                -- SILENT AIM HOOK
                if getgenv().GhostConfig and getgenv().GhostConfig.Silent and (_n:find("fire") or _n:find("shoot") or _n:find("hit")) then
                    local _t = getgenv().GetTarget(getgenv().GhostConfig.FOV)
                    if _t and _t.Character then
                        local _p = _t.Character:FindFirstChild("Head") or _t.Character:FindFirstChild(_S.HRP)
                        if _p then
                            for i, v in pairs(_args) do
                                if typeof(v) == "Vector3" then _args[i] = _p.Position
                                elseif typeof(v) == "Instance" and v:IsA("BasePart") then _args[i] = _p end
                            end
                            return _onc(self, unpack(_args))
                        end
                    end
                end
            end
        end
        return _onc(self, ...)
    end)

    _mt.__index = newcclosure(function(self, idx)
        if not checkcaller() then
            if idx == _S.WS and self:IsA(_S.H) then return 16 end
            if idx == _S.JP and self:IsA(_S.H) then return 50 end
            if idx == _S.JH and self:IsA(_S.H) then return 7.2 end
            -- MOUSE HOOK
            if getgenv().GhostConfig and getgenv().GhostConfig.Silent and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
                local _t = getgenv().GetTarget(getgenv().GhostConfig.FOV)
                if _t and _t.Character then
                    local _p = _t.Character:FindFirstChild("Head") or _t.Character:FindFirstChild(_S.HRP)
                    if _p then return (idx == "Hit" and _p.CFrame or _p) end
                end
            end
        end
        return _oidx(self, idx)
    end)
    setreadonly(_mt, true)
end)

-- // [3] GHOST CONFIG & UTILS //
getgenv().GhostConfig = {
    Aimbot = false, Key = Enum.KeyCode.V, FOV = 150, Target = "Head",
    Silent = false, Hitbox = 2, Recoil = false, Ammo = false,
    Speed = 16, Fly = false, Jump = false, Noclip = false,
    ESP = false, Health = false, Tracers = false, Distance = false, Corners = false, Team = true,
    Stamina = false, NoFall = false, Spinbot = false, InstantInteract = false, RemoveBarriers = false,
    Visible = true
}

getgenv().GetTarget = function(fov)
    local t = nil
    local md = fov
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP and p.Character and p.Character:FindFirstChild(_S.H) and p.Character.Humanoid.Health > 0 then
            if getgenv().GhostConfig.Team and p.Team == _LP.Team then continue end
            local r = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild(_S.HRP)
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

local function SafeTeleport(targetPos)
    local char = _LP.Character
    local root = char and char:FindFirstChild(_S.HRP)
    if not root then return end
    _TS:Create(root, TweenInfo.new((root.Position - targetPos).Magnitude / 50, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
end

-- // [4] CUSTOM GHOST UI (MAXIMUM STEALTH) //
local function CreateUI()
    local _R = function() return "G" .. math.random(100000, 999999) end
    local Screen = Instance.new("ScreenGui", _CG); Screen.Name = _R()
    local Main = Instance.new("Frame", Screen); Main.Name = _R(); Main.Size = UDim2.new(0, 500, 0, 450); Main.Position = UDim2.new(0.5, -250, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 40); Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Top.BorderSizePixel = 0
    local Title = Instance.new("TextLabel", Top); Title.Size = UDim2.new(1, -10, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "ARMY RP ULTIMATE | V16 SILENT GHOST EDITION"; Title.TextColor3 = Color3.fromRGB(0, 255, 120); Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
    local Content = Instance.new("ScrollingFrame", Main); Content.Size = UDim2.new(1, -20, 1, -50); Content.Position = UDim2.new(0, 10, 0, 45); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 3
    local Layout = Instance.new("UIListLayout", Content); Layout.Padding = UDim.new(0, 5)

    local function AddToggle(txt, prop)
        local btn = Instance.new("TextButton", Content); btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.Text = "  " .. txt .. ": OFF"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(function()
            getgenv().GhostConfig[prop] = not getgenv().GhostConfig[prop]
            local s = getgenv().GhostConfig[prop]
            btn.Text = "  " .. txt .. ": " .. (s and "ON" or "OFF")
            btn.TextColor3 = s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        end)
    end

    local function AddSlider(txt, min, max, prop)
        local f = Instance.new("Frame", Content); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 15); l.Text = txt .. ": " .. getgenv().GhostConfig[prop]; l.TextColor3 = Color3.fromRGB(180, 180, 180); l.BackgroundTransparency = 1; l.TextSize = 12
        local i = Instance.new("TextBox", f); i.Size = UDim2.new(1, 0, 0, 25); i.Position = UDim2.new(0, 0, 0, 18); i.BackgroundColor3 = Color3.fromRGB(40, 40, 40); i.Text = tostring(getgenv().GhostConfig[prop]); i.TextColor3 = Color3.fromRGB(255, 255, 255); i.BorderSizePixel = 0
        i.FocusLost:Connect(function() local v = tonumber(i.Text); if v then v = math.clamp(v, min, max); getgenv().GhostConfig[prop] = v; l.Text = txt .. ": " .. v end end)
    end

    local function AddButton(txt, cb)
        local btn = Instance.new("TextButton", Content); btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); btn.Text = "  [EXE] " .. txt; btn.TextColor3 = Color3.fromRGB(200, 200, 255); btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(cb)
    end

    -- UI FEATURES
    AddToggle("Aimbot (V Hold)", "Aimbot"); AddToggle("Silent Aim", "Silent"); AddSlider("Aimbot FOV", 0, 800, "FOV")
    AddToggle("No Recoil", "Recoil"); AddToggle("Infinite Ammo", "Ammo"); AddSlider("Hitbox Size", 2, 20, "Hitbox")
    AddToggle("Master ESP", "ESP"); AddToggle("ESP Health", "Health"); AddToggle("ESP Distance", "Distance"); AddToggle("ESP Corners", "Corners"); AddToggle("ESP Tracers", "Tracers")
    AddSlider("WalkSpeed", 16, 250, "Speed"); AddToggle("CFrame Fly", "Fly"); AddToggle("Infinite Jump", "Jump"); AddToggle("Ghost Noclip", "Noclip")
    AddToggle("Infinite Stamina", "Stamina"); AddToggle("No Fall Damage", "NoFall"); AddToggle("Defense Spinbot", "Spinbot")
    AddButton("Warp to Random Player", function() local plrs = _P:GetPlayers(); SafeTeleport(plrs[math.random(1, #plrs)].Character.HumanoidRootPart.Position) end)
    AddButton("Instant Interaction (E)", function() getgenv().GhostConfig.InstantInteract = true end)
    AddButton("Remove All Barriers", function() getgenv().GhostConfig.RemoveBarriers = true end)
    AddButton("Infinite Yield Admin", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

    _UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.RightControl then getgenv().GhostConfig.Visible = not getgenv().GhostConfig.Visible; Main.Visible = getgenv().GhostConfig.Visible end end)
end

CreateUI()

-- // [5] CORE LOGIC LOOPS //
local ESP_Objects = {}
local Original_Collisions = {}

-- RENDER LOOP (Visuals / Aimbot)
_RS.RenderStepped:Connect(function()
    -- AIMBOT
    if getgenv().GhostConfig.Aimbot and _UIS:IsKeyDown(getgenv().GhostConfig.Key) then
        local t = getgenv().GetTarget(getgenv().GhostConfig.FOV)
        if t and t.Character then local p = t.Character:FindFirstChild("Head"); if p then _W.CurrentCamera.CFrame = CFrame.new(_W.CurrentCamera.CFrame.Position, p.Position) end end
    end

    -- ESP RENDERING
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _LP then
            local char = p.Character; local root = char and char:FindFirstChild(_S.HRP); local hum = char and char:FindFirstChild(_S.H)
            if getgenv().GhostConfig.ESP and root and hum and hum.Health > 0 then
                local pos, on = _W.CurrentCamera:WorldToViewportPoint(root.Position)
                if on then
                    if not ESP_Objects[p] then
                        ESP_Objects[p] = {
                            Box = Drawing.new("Square"), Corner1 = Drawing.new("Line"), Corner2 = Drawing.new("Line"), Corner3 = Drawing.new("Line"), Corner4 = Drawing.new("Line"),
                            Corner5 = Drawing.new("Line"), Corner6 = Drawing.new("Line"), Corner7 = Drawing.new("Line"), Corner8 = Drawing.new("Line"),
                            Name = Drawing.new("Text"), Health = Drawing.new("Line"), Dist = Drawing.new("Text"), Tracer = Drawing.new("Line")
                        }
                    end
                    local o = ESP_Objects[p]; local size = 2000/pos.Z; local x, y = pos.X - size/2, pos.Y - size/2; local col = p.TeamColor.Color
                    -- Box
                    o.Box.Visible = not getgenv().GhostConfig.Corners; o.Box.Size = Vector2.new(size, size); o.Box.Position = Vector2.new(x, y); o.Box.Color = col; o.Box.Visible = not getgenv().GhostConfig.Corners
                    -- Corners
                    if getgenv().GhostConfig.Corners then
                        local l = size/4; o.Corner1.From = Vector2.new(x,y); o.Corner1.To = Vector2.new(x+l,y); o.Corner2.From = Vector2.new(x,y); o.Corner2.To = Vector2.new(x,y+l)
                        o.Corner3.From = Vector2.new(x+size,y); o.Corner3.To = Vector2.new(x+size-l,y); o.Corner4.From = Vector2.new(x+size,y); o.Corner4.To = Vector2.new(x+size,y+l)
                        o.Corner5.From = Vector2.new(x,y+size); o.Corner5.To = Vector2.new(x+l,y+size); o.Corner6.From = Vector2.new(x,y+size); o.Corner6.To = Vector2.new(x,y+size-l)
                        o.Corner7.From = Vector2.new(x+size,y+size); o.Corner7.To = Vector2.new(x+size-l,y+size); o.Corner8.From = Vector2.new(x+size,y+size); o.Corner8.To = Vector2.new(x+size,y+size-l)
                        for i=1,8 do o["Corner"..i].Color = col; o["Corner"..i].Visible = true end
                    else for i=1,8 do o["Corner"..i].Visible = false end end
                    -- Labels
                    o.Name.Text = p.Name; o.Name.Position = Vector2.new(pos.X, y - 20); o.Name.Visible = true; o.Name.Center = true; o.Name.Outline = true
                    if getgenv().GhostConfig.Distance then o.Dist.Text = math.floor((_W.CurrentCamera.CFrame.Position - root.Position).Magnitude).."m"; o.Dist.Position = Vector2.new(pos.X, y + size + 5); o.Dist.Visible = true; o.Dist.Center = true; o.Dist.Outline = true else o.Dist.Visible = false end
                    if getgenv().GhostConfig.Health then local bh = (hum.Health/hum.MaxHealth)*size; o.Health.From = Vector2.new(x-5, y+size); o.Health.To = Vector2.new(x-5, y+size-bh); o.Health.Color = Color3.fromHSV(math.clamp(hum.Health/hum.MaxHealth,0,1)*0.4, 1, 1); o.Health.Visible = true else o.Health.Visible = false end
                    if getgenv().GhostConfig.Tracers then o.Tracer.From = Vector2.new(_W.CurrentCamera.ViewportSize.X/2, _W.CurrentCamera.ViewportSize.Y); o.Tracer.To = Vector2.new(pos.X, y+size); o.Tracer.Color = col; o.Tracer.Visible = true else o.Tracer.Visible = false end
                elseif ESP_Objects[p] then for _, v in pairs(ESP_Objects[p]) do v.Visible = false end end
            elseif ESP_Objects[p] then for _, v in pairs(ESP_Objects[p]) do v.Visible = false end end
        end
    end
end)

-- STEPPED LOOP (Physics / Bypass)
_RS.Stepped:Connect(function()
    local c = _LP.Character; local h = c and c:FindFirstChild(_S.H); local r = c and c:FindFirstChild(_S.HRP)
    if c and h and r then
        if getgenv().GhostConfig.Speed > 16 and not getgenv().GhostConfig.Fly then r.Velocity = Vector3.new(h.MoveDirection.X * getgenv().GhostConfig.Speed, r.Velocity.Y, h.MoveDirection.Z * getgenv().GhostConfig.Speed) end
        if getgenv().GhostConfig.Fly then
            h.PlatformStand = true; local m = Vector3.new(0,0,0)
            if _UIS:IsKeyDown(Enum.KeyCode.W) then m = m + _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.S) then m = m - _W.CurrentCamera.CFrame.LookVector end
            if _UIS:IsKeyDown(Enum.KeyCode.A) then m = m - _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.D) then m = m + _W.CurrentCamera.CFrame.RightVector end
            if _UIS:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0,1,0) end
            if _UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0,1,0) end
            r.Velocity = Vector3.new(0, 0.1, 0); r.CFrame = r.CFrame + (m * 1.5)
        elseif h.PlatformStand then h.PlatformStand = false end
        if getgenv().GhostConfig.Noclip then for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then if not Original_Collisions[v] then Original_Collisions[v] = v.CanCollide end; v.CanCollide = false end end else for v, s in pairs(Original_Collisions) do if v and v.Parent then v.CanCollide = s end end; table.clear(Original_Collisions) end
        if getgenv().GhostConfig.Stamina then local s = c:FindFirstChild("Stamina") or _LP:FindFirstChild("Stamina"); if s and s:IsA("ValueBase") then s.Value = 100 end end
        if getgenv().GhostConfig.NoFall then if h:GetState() == Enum.HumanoidStateType.FallingDown or h:GetState() == Enum.HumanoidStateType.Freefall then h:ChangeState(Enum.HumanoidStateType.Running) end end
        if getgenv().GhostConfig.Spinbot then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(25), 0) end
        -- Hitbox
        if tick() % 1 < 0.1 then
            for _, p in pairs(_P:GetPlayers()) do if p ~= _LP and p.Character then for _, n in pairs({"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do local t = p.Character:FindFirstChild(n); if t then t.Size = Vector3.new(getgenv().GhostConfig.Hitbox, getgenv().GhostConfig.Hitbox, getgenv().GhostConfig.Hitbox); t.Transparency = 0.5; t.CanCollide = false end end end end
        end
    end
    -- Misc Triggered
    if getgenv().GhostConfig.InstantInteract then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
    if getgenv().GhostConfig.RemoveBarriers then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence")) then v.CanCollide = false; v.Transparency = 0.5 end end end
end)

-- Character Mod Trigger
local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(c) if c:IsA("Tool") then task.wait(0.1);
        pcall(function() for _, v in pairs(c:GetDescendants()) do if v:IsA("ValueBase") then local n = v.Name:lower(); if getgenv().GhostConfig.Recoil and (n:find("recoil") or n:find("kick")) then v.Value = 0 end; if getgenv().GhostConfig.Ammo and (n:find("ammo") or n:find("mag")) then v.Value = 999 end end end end)
    end end)
end
_LP.CharacterAdded:Connect(MonitorCharacter); if _LP.Character then MonitorCharacter(_LP.Character) end

-- Inf Jump
_UIS.JumpRequest:Connect(function() if getgenv().GhostConfig.Jump and _LP.Character and _LP.Character:FindFirstChild(_S.HRP) then _LP.Character.HumanoidRootPart.Velocity = Vector3.new(_LP.Character.HumanoidRootPart.Velocity.X, 50, _LP.Character.HumanoidRootPart.Velocity.Z) end end)

_P.PlayerRemoving:Connect(function(p) if ESP_Objects[p] then for _, v in pairs(ESP_Objects[p]) do v:Remove() end; ESP_Objects[p] = nil end end)

print("[ARMY RP] V16 SILENT GHOST FULLY ARMED. RIGHTCONTROL TO TOGGLE.")
