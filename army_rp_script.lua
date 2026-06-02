local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- SETTINGS
local AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    TargetPart = "Torso",
    FOV = 150,
    VisibleCheck = true
}

local SilentAimSettings = {
    Enabled = false,
    TeamCheck = true,
    TargetPart = "Torso",
    FOV = 100
}

local WeaponSettings = {
    NoRecoil = false,
    NoSpread = false,
    InfAmmo = false
}

local HitboxSettings = {
    Enabled = false,
    Size = 5
}

local MovementSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfStamina = false,
    NoFallDamage = false,
    InfJump = false,
    Spinbot = false,
    VehicleFly = false,
    VehicleSpeed = 50
}

local ESPSettings = {
    Enabled = false,
    Boxes = false,
    CornerBoxes = false,
    Names = false,
    HealthBar = false,
    Distance = false,
    Tracers = false,
    Teams = true,
    Fullbright = false
}

local ClickTPEnabled = false

-- UTILS
local function GetClosestPlayer(fov, part)
    local target = nil
    local maxDistance = fov
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(part) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(player.Character[part].Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < maxDistance then
                    target = player
                    maxDistance = distance
                end
            end
        end
    end
    return target
end

-- WINDOW
local Window = Rayfield:CreateWindow({
   Name = "Army RP | Xeno Premium",
   LoadingTitle = "Army RP Premium",
   LoadingSubtitle = "by Jules",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ArmyRP_Jules",
      FileName = "Config"
   },
   Theme = "DarkBlue", -- More aesthetic theme
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false,
})

-- TABS
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local PlayerTab = Window:CreateTab("Player & TP", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- COMBAT UI
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value) AimbotSettings.Enabled = Value end,
})
CombatTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {0, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) AimbotSettings.FOV = Value end,
})
CombatTab:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "Torso", "HumanoidRootPart"},
   CurrentValue = "Torso",
   Callback = function(Value) AimbotSettings.TargetPart = Value; SilentAimSettings.TargetPart = Value end,
})

CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({
   Name = "Enable Silent Aim",
   CurrentValue = false,
   Callback = function(Value) SilentAimSettings.Enabled = Value end,
})

CombatTab:CreateSection("Weapon Mods")
CombatTab:CreateToggle({
   Name = "No Recoil",
   CurrentValue = false,
   Callback = function(Value) WeaponSettings.NoRecoil = Value end,
})
CombatTab:CreateToggle({
   Name = "No Spread",
   CurrentValue = false,
   Callback = function(Value) WeaponSettings.NoSpread = Value end,
})
CombatTab:CreateToggle({
   Name = "Infinite Ammo",
   CurrentValue = false,
   Callback = function(Value) WeaponSettings.InfAmmo = Value end,
})

CombatTab:CreateSection("Hitbox Expander")
CombatTab:CreateToggle({
   Name = "Enable Hitbox Expander",
   CurrentValue = false,
   Callback = function(Value) HitboxSettings.Enabled = Value end,
})
CombatTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 20},
   Increment = 1,
   CurrentValue = 5,
   Callback = function(Value) HitboxSettings.Size = Value end,
})

-- MOVEMENT UI
MovementTab:CreateSection("Character")
MovementTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) MovementSettings.WalkSpeed = Value end,
})
MovementTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) MovementSettings.JumpPower = Value end,
})
MovementTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.InfStamina = Value end,
})
MovementTab:CreateToggle({
   Name = "No Fall Damage",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.NoFallDamage = Value end,
})
MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.InfJump = Value end,
})
MovementTab:CreateToggle({
   Name = "Spinbot",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.Spinbot = Value end,
})

MovementTab:CreateSection("Flight")
MovementTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.Fly = Value end,
})
MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) MovementSettings.FlySpeed = Value end,
})
MovementTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.Noclip = Value end,
})

MovementTab:CreateSection("Vehicle")
MovementTab:CreateToggle({
   Name = "Vehicle Fly",
   CurrentValue = false,
   Callback = function(Value) MovementSettings.VehicleFly = Value end,
})
MovementTab:CreateSlider({
   Name = "Vehicle Speed",
   Range = {10, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) MovementSettings.VehicleSpeed = Value end,
})

-- VISUALS UI
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.Enabled = Value end,
})
VisualsTab:CreateToggle({
   Name = "Boxes",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.Boxes = Value end,
})
VisualsTab:CreateToggle({
   Name = "Corner Boxes",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.CornerBoxes = Value end,
})
VisualsTab:CreateToggle({
   Name = "Names",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.Names = Value end,
})
VisualsTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.HealthBar = Value end,
})
VisualsTab:CreateToggle({
   Name = "Distance",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.Distance = Value end,
})
VisualsTab:CreateToggle({
   Name = "Tracers",
   CurrentValue = false,
   Callback = function(Value) ESPSettings.Tracers = Value end,
})

VisualsTab:CreateSection("World")
VisualsTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Callback = function(Value)
      ESPSettings.Fullbright = Value
      if Value then
          Lighting.Brightness = 2
          Lighting.ClockTime = 14
          Lighting.FogEnd = 100000
          Lighting.GlobalShadows = false
          Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
      end
   end,
})

-- PLAYER & TP UI
PlayerTab:CreateSection("Teleports")
local LocationDropdown = PlayerTab:CreateDropdown({
   Name = "Select Location",
   Options = {"Military Base", "Border", "Bandit Camp", "Spawn"},
   CurrentValue = "Spawn",
   Callback = function(Value) end,
})
local TPLocations = {
    ["Military Base"] = Vector3.new(0, 50, 0),
    ["Border"] = Vector3.new(100, 50, 100),
    ["Bandit Camp"] = Vector3.new(-500, 50, -500),
    ["Spawn"] = Vector3.new(0, 10, 0)
}
PlayerTab:CreateButton({
   Name = "Teleport to Location",
   Callback = function()
      local loc = LocationDropdown.CurrentValue
      if TPLocations[loc] and LocalPlayer.Character then
          LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(TPLocations[loc]))
      end
   end,
})

PlayerTab:CreateSection("Player Teleport")
local PlayerDropdown = PlayerTab:CreateDropdown({
   Name = "Select Player",
   Options = {},
   CurrentValue = "",
   Callback = function(Value) end,
})
local function UpdatePlayerDropdown()
    local plrs = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then table.insert(plrs, v.Name) end
    end
    PlayerDropdown:Refresh(plrs)
end
Players.PlayerAdded:Connect(UpdatePlayerDropdown)
Players.PlayerRemoving:Connect(UpdatePlayerDropdown)
UpdatePlayerDropdown()

PlayerTab:CreateButton({
   Name = "Teleport to Player",
   Callback = function()
      local targetName = PlayerDropdown.CurrentValue
      local target = Players:FindFirstChild(targetName)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
          LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
      end
   end,
})

PlayerTab:CreateSection("Click TP")
PlayerTab:CreateToggle({
   Name = "Ctrl + Click Teleport",
   CurrentValue = false,
   Callback = function(Value) ClickTPEnabled = Value end,
})

-- MISC UI
MiscTab:CreateSection("Utilities")
MiscTab:CreateButton({
   Name = "Instant Interact (E)",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
       end
       workspace.DescendantAdded:Connect(function(v)
           if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
       end)
   end,
})
MiscTab:CreateButton({
   Name = "Remove Barriers",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("fence")) then
               v:Destroy()
           end
       end
   end,
})
MiscTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
       local VirtualUser = game:GetService("VirtualUser")
       LocalPlayer.Idled:Connect(function()
           VirtualUser:CaptureController()
           VirtualUser:ClickButton2(Vector2.new())
       end)
       Rayfield:Notify({Title = "Anti-AFK", Content = "Anti-AFK is now active!", Duration = 5})
   end,
})
MiscTab:CreateButton({
   Name = "Server Hopper",
   Callback = function()
       local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
       for _, s in pairs(Servers.data) do
           if s.playing < s.maxPlayers and s.id ~= game.JobId then
               TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
               break
           end
       end
   end,
})

-- LOGIC LOOPS
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

local bodyGyro = Instance.new("BodyGyro")
local bodyVelocity = Instance.new("BodyVelocity")
local vGyro = Instance.new("BodyGyro")
local vVelocity = Instance.new("BodyVelocity")

local function ApplyWeaponMods(tool)
    if not tool or not tool:IsA("Tool") then return end
    local config = tool:FindFirstChild("Configuration") or tool:FindFirstChild("Settings") or tool
    if WeaponSettings.NoRecoil then
        local recoil = config:FindFirstChild("Recoil") or config:FindFirstChild("RecoilPower")
        if recoil and recoil:IsA("ValueBase") then recoil.Value = 0 end
    end
    if WeaponSettings.NoSpread then
        local spread = config:FindFirstChild("Spread") or config:FindFirstChild("Accuracy")
        if spread and spread:IsA("ValueBase") then spread.Value = 0 end
    end
    if WeaponSettings.InfAmmo then
        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo")
        if ammo and ammo:IsA("IntValue") then ammo.Value = 999 end
    end
end

local function MonitorCharacter(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            ApplyWeaponMods(child)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(MonitorCharacter)
if LocalPlayer.Character then MonitorCharacter(LocalPlayer.Character) end

-- Optimized ESP Handling
local ESPObjects = {}
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Thickness = 1

    local Corner1 = Drawing.new("Line")
    local Corner2 = Drawing.new("Line")
    local Corner3 = Drawing.new("Line")
    local Corner4 = Drawing.new("Line")
    local Corner5 = Drawing.new("Line")
    local Corner6 = Drawing.new("Line")
    local Corner7 = Drawing.new("Line")
    local Corner8 = Drawing.new("Line")
    local Corners = {Corner1, Corner2, Corner3, Corner4, Corner5, Corner6, Corner7, Corner8}
    for _, c in pairs(Corners) do c.Visible = false; c.Thickness = 1.5 end

    local HealthBar = Drawing.new("Line")
    HealthBar.Visible = false
    HealthBar.Thickness = 2

    local HealthOutline = Drawing.new("Line")
    HealthOutline.Visible = false
    HealthOutline.Thickness = 3
    HealthOutline.Color = Color3.fromRGB(0,0,0)

    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true

    local Dist = Drawing.new("Text")
    Dist.Visible = false
    Dist.Color = Color3.fromRGB(255, 255, 255)
    Dist.Size = 12
    Dist.Center = true
    Dist.Outline = true

    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Thickness = 1

    ESPObjects[plr] = {
        Box = Box,
        Corners = Corners,
        HealthBar = HealthBar,
        HealthOutline = HealthOutline,
        Name = Name,
        Dist = Dist,
        Tracer = Tracer
    }
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, obj in pairs(ESPObjects[plr]) do
            if typeof(obj) == "table" then
                for _, subObj in pairs(obj) do subObj:Remove() end
            else
                obj:Remove()
            end
        end
        ESPObjects[plr] = nil
    end
end)
for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = AimbotSettings.FOV

    -- Aimbot Logic
    if AimbotSettings.Enabled then
        local target = GetClosestPlayer(AimbotSettings.FOV, AimbotSettings.TargetPart)
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimbotSettings.TargetPart].Position)
        end
    end

    -- Hitbox Expander Logic
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(AimbotSettings.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            if part and player.Team ~= LocalPlayer.Team then
                if HitboxSettings.Enabled then
                    if not part:FindFirstChild("OriginalSize") then
                        local s = Instance.new("Vector3Value", part); s.Name = "OriginalSize"; s.Value = part.Size
                        local t = Instance.new("NumberValue", part); t.Name = "OriginalTransparency"; t.Value = part.Transparency
                    end
                    part.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                    part.Transparency = 0.7
                    part.CanCollide = false
                else
                    if part:FindFirstChild("OriginalSize") then
                        part.Size = part.OriginalSize.Value
                        part.Transparency = part.OriginalTransparency.Value
                        part.OriginalSize:Destroy()
                        part.OriginalTransparency:Destroy()
                    end
                end
            end
        end
    end

    -- ESP Logic
    for plr, objects in pairs(ESPObjects) do
        if ESPSettings.Enabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local char = plr.Character
            local root = char.HumanoidRootPart
            local head = char:FindFirstChild("Head")
            if not head then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local color = (ESPSettings.Teams and plr.TeamColor.Color) or Color3.fromRGB(255, 0, 0)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 1.5
                local x = pos.X - width / 2
                local y = headPos.Y

                -- Box ESP
                if ESPSettings.Boxes then
                    objects.Box.Size = Vector2.new(width, height)
                    objects.Box.Position = Vector2.new(x, y)
                    objects.Box.Color = color
                    objects.Box.Visible = true
                else objects.Box.Visible = false end

                -- Corner Box ESP
                if ESPSettings.CornerBoxes then
                    local lineLen = width / 4
                    objects.Corners[1].From = Vector2.new(x, y); objects.Corners[1].To = Vector2.new(x + lineLen, y)
                    objects.Corners[2].From = Vector2.new(x, y); objects.Corners[2].To = Vector2.new(x, y + lineLen)
                    objects.Corners[3].From = Vector2.new(x + width, y); objects.Corners[3].To = Vector2.new(x + width - lineLen, y)
                    objects.Corners[4].From = Vector2.new(x + width, y); objects.Corners[4].To = Vector2.new(x + width, y + lineLen)
                    objects.Corners[5].From = Vector2.new(x, y + height); objects.Corners[5].To = Vector2.new(x + lineLen, y + height)
                    objects.Corners[6].From = Vector2.new(x, y + height); objects.Corners[6].To = Vector2.new(x, y + height - lineLen)
                    objects.Corners[7].From = Vector2.new(x + width, y + height); objects.Corners[7].To = Vector2.new(x + width - lineLen, y + height)
                    objects.Corners[8].From = Vector2.new(x + width, y + height); objects.Corners[8].To = Vector2.new(x + width, y + height - lineLen)
                    for _, c in pairs(objects.Corners) do c.Color = color; c.Visible = true end
                else for _, c in pairs(objects.Corners) do c.Visible = false end end

                -- Health Bar
                if ESPSettings.HealthBar then
                    local health = char.Humanoid.Health
                    local maxHealth = char.Humanoid.MaxHealth
                    local hHeight = (health / maxHealth) * height
                    local hColor = Color3.fromHSV(math.clamp(health/maxHealth, 0, 1) * 0.4, 1, 1)

                    objects.HealthOutline.From = Vector2.new(x - 5, y)
                    objects.HealthOutline.To = Vector2.new(x - 5, y + height)
                    objects.HealthOutline.Visible = true

                    objects.HealthBar.From = Vector2.new(x - 5, y + height)
                    objects.HealthBar.To = Vector2.new(x - 5, y + height - hHeight)
                    objects.HealthBar.Color = hColor
                    objects.HealthBar.Visible = true
                else objects.HealthBar.Visible = false; objects.HealthOutline.Visible = false end

                -- Names & Distance
                if ESPSettings.Names then
                    objects.Name.Text = plr.Name
                    objects.Name.Position = Vector2.new(pos.X, y - 20)
                    objects.Name.Visible = true
                else objects.Name.Visible = false end

                if ESPSettings.Distance then
                    local distance = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                    objects.Dist.Text = tostring(distance) .. "m"
                    objects.Dist.Position = Vector2.new(pos.X, y + height + 5)
                    objects.Dist.Visible = true
                else objects.Dist.Visible = false end

                -- Tracers
                if ESPSettings.Tracers then
                    objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    objects.Tracer.To = Vector2.new(pos.X, legPos.Y)
                    objects.Tracer.Color = color
                    objects.Tracer.Visible = true
                else objects.Tracer.Visible = false end
            else
                for _, obj in pairs(objects) do if typeof(obj) == "table" then for _, c in pairs(obj) do c.Visible = false end else obj.Visible = false end end
            end
        else
            for _, obj in pairs(objects) do if typeof(obj) == "table" then for _, c in pairs(obj) do c.Visible = false end else obj.Visible = false end end
        end
    end
end)

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = MovementSettings.WalkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = MovementSettings.JumpPower

        if MovementSettings.Noclip then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        if MovementSettings.InfStamina then
            local stamina = LocalPlayer.Character:FindFirstChild("Stamina") or LocalPlayer:FindFirstChild("Stamina")
            if stamina and stamina:IsA("ValueBase") then stamina.Value = 100 end
        end

        if MovementSettings.NoFallDamage then
            if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end

        if MovementSettings.Spinbot then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end
    end

    -- Movement / Vehicle Logic
    if MovementSettings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character.Humanoid

        humanoid.PlatformStand = true
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end

        root.Velocity = Vector3.new(0,0,0)
        root.CFrame = root.CFrame + (moveDir * (MovementSettings.FlySpeed / 50))
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end

    if MovementSettings.VehicleFly or MovementSettings.VehicleSpeed > 50 then
        local seat = LocalPlayer.Character and LocalPlayer.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if MovementSettings.VehicleFly then
                vGyro.Parent = seat; vVelocity.Parent = seat
                vGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); vGyro.CFrame = Camera.CFrame
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                vVelocity.Velocity = moveDir * MovementSettings.VehicleSpeed
            else
                vGyro.Parent = nil; vVelocity.Parent = nil
                if seat.Throttle ~= 0 then seat.Velocity = seat.CFrame.LookVector * MovementSettings.VehicleSpeed * seat.Throttle end
            end
        else
            vGyro.Parent = nil; vVelocity.Parent = nil
        end
    else
        vGyro.Parent = nil; vVelocity.Parent = nil
    end
end)

-- Silent Aim Hooks
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if SilentAimSettings.Enabled and not checkcaller() then
        if getnamecallmethod() == "FireServer" and (self.Name:lower():find("shoot") or self.Name:lower():find("fire")) then
            local target = GetClosestPlayer(SilentAimSettings.FOV, SilentAimSettings.TargetPart)
            if target then
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then args[i] = target.Character[SilentAimSettings.TargetPart].Position end
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(self, idx)
    if SilentAimSettings.Enabled and not checkcaller() and (idx == "Hit" or idx == "Target") and self:IsA("Mouse") then
        local target = GetClosestPlayer(SilentAimSettings.FOV, SilentAimSettings.TargetPart)
        if target then return (idx == "Hit" and target.Character[SilentAimSettings.TargetPart].CFrame or target.Character[SilentAimSettings.TargetPart]) end
    end
    return oldIndex(self, idx)
end)
setreadonly(mt, true)

UserInputService.JumpRequest:Connect(function()
    if MovementSettings.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and ClickTPEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local ray = Camera:ViewportPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        local res = workspace:Raycast(ray.Origin, ray.Direction * 1000)
        if res and LocalPlayer.Character then LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(res.Position + Vector3.new(0, 3, 0))) end
    end
end)

Rayfield:Notify({Title = "Script Loaded", Content = "Army RP Script Ready!", Duration = 5})
