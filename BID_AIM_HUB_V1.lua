-- ตรวจสอบการโหลด Library (ใช้ Rayfield ตามโครงสร้างเมนูของคุณ)
local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then
    warn("ไม่สามารถโหลด UI Library ได้!")
    return
end

local Window = Rayfield:CreateWindow({
   Name = "BID AIM HUB | V1",
   LoadingTitle = "[FPS] Flick",
   LoadingSubtitle = "by sudlorpalm",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "BidAimHub",
      FileName = "Config"
   },
   KeySystem = false,
})

-- ตัวแปรควบคุมสถานะฟังก์ชันทั้งหมด
_G.FOVEnabled = false
_G.FOVSize = 130
_G.ShowName = false
_G.BoxESP = false
_G.SkeletonESP = false
_G.HealthBar = false
_G.DistanceESP = false
_G.TargetPart = "Head"

-- ==========================================
-- แท็บที่ 1: Visual (วงกลม FOV)
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
   Name = "FOV Circle",
   CurrentValue = false,
   Callback = function(Value)
      _G.FOVEnabled = Value
   end,
})

VisualTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 500},
   Increment = 5,
   CurrentValue = 130,
   Callback = function(Value)
      _G.FOVSize = Value
   end,
})

-- ==========================================
-- แท็บที่ 2: ESP (มองทะลุ / ชื่อ / กรอบ)
-- ==========================================
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
   Name = "Show Name",
   CurrentValue = false,
   Callback = function(Value)
      _G.ShowName = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Box",
   CurrentValue = false,
   Callback = function(Value)
      _G.BoxESP = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Skeletons",
   CurrentValue = false,
   Callback = function(Value)
      _G.SkeletonESP = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = false,
   Callback = function(Value)
      _G.HealthBar = Value
   end,
})

ESPTab:CreateToggle({
   Name = "Distance",
   CurrentValue = false,
   Callback = function(Value)
      _G.DistanceESP = Value
   end,
})

-- ==========================================
-- แท็บที่ 3: Settings (ตั้งค่าเพิ่มเติม)
-- ==========================================
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(Option)
      _G.TargetPart = Option
   end,
})

-- ==========================================
-- ระบบเบื้องหลัง (Backend Logic) ทำงานจริง
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 1. วาดวงกลม FOV บนจอ
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 30
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(170, 0, 255) -- สีม่วงเข้ากับธีม
fovCircle.Transparency = 1

RunService.RenderStepped:Connect(function()
    if _G.FOVEnabled then
        fovCircle.Visible = true
        fovCircle.Radius = _G.FOVSize
        fovCircle.Position = UserInputService:GetMouseLocation()
    else
        fovCircle.Visible = false
    end
end)

-- 2. ระบบ ESP (Box, Name, Distance) สำหรับผู้เล่นอื่น
local espCache = {}

local function removeESP(player)
    if espCache[player] then
        if espCache[player].Box then espCache[player].Box:Remove() end
        if espCache[player].Name then espCache[player].Name:Remove() end
        if espCache[player].Distance then espCache[player].Distance:Remove() end
        espCache[player] = nil
    end
end

local function addESP(player)
    if player == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(170, 0, 255)
    box.Thickness = 1
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)

    local distTag = Drawing.new("Text")
    distTag.Visible = false
    distTag.Size = 13
    distTag.Center = true
    distTag.Color = Color3.fromRGB(200, 200, 200)

    espCache[player] = {Box = box, Name = nameTag, Distance = distTag}

    RunService.RenderStepped:Connect(function()
        local data = espCache[player]
        if not data then return end

        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")

        if character and hrp and humanoid and humanoid.Health > 0 then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                -- Box ESP
                if _G.BoxESP then
                    data.Box.Size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                    data.Box.Position = Vector2.new(vector.X - data.Box.Size.X / 2, vector.Y - data.Box.Size.Y / 2)
                    data.Box.Visible = true
                else
                    data.Box.Visible = false
                end

                -- Show Name
                if _G.ShowName then
                    data.Name.Text = player.Name
                    data.Name.Position = Vector2.new(vector.X, vector.Y - (3000 / vector.Z) / 2 - 20)
                    data.Name.Visible = true
                else
                    data.Name.Visible = false
                end

                -- Distance
                if _G.DistanceESP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    data.Distance.Text = "[" .. dist .. "m]"
                    data.Distance.Position = Vector2.new(vector.X, vector.Y + (3000 / vector.Z) / 2 + 5)
                    data.Distance.Visible = true
                else
                    data.Distance.Visible = false
                end
            else
                box.Visible = false
                nameTag.Visible = false
                distTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
            distTag.Visible = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

Rayfield:LoadConfiguration()
print("BID AIM HUB Loaded Successfully!")
