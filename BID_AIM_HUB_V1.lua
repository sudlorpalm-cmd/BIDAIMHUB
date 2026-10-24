-- BID AIM HUB V1 - Fully Functional ESP & Aim Lock
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local pg = player:WaitForChild('PlayerGui')
local old = pg:FindFirstChild('BID_AIM_HUB_V1')
if old then old:Destroy() end

local gui = Instance.new('ScreenGui')
gui.Name = 'BID_AIM_HUB_V1'
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = pg

local accent = Color3.fromRGB(160, 85, 255)
local bg = Color3.fromRGB(19, 16, 29)
local panel = Color3.fromRGB(32, 26, 46)
local white = Color3.fromRGB(240, 235, 255)
local state = {
    FOVCircle = false,
    FOVSize = 130,
    Smooth = 5,
    ShowName = false,
    Box = false,
    Skeletons = false,
    HealthBar = false,
    Distance = false,
    TeamCheck = false,
    TargetPart = 'Head'
}

local function create(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, r)
    create('UICorner',{CornerRadius=UDim.new(0,r)},o)
end

local main = create('Frame',{Size=UDim2.fromOffset(330,310),Position=UDim2.new(.5,-165,.5,-155),BackgroundColor3=bg,BorderSizePixel=0,Active=true},gui)
round(main,14)
local mainStroke = create('UIStroke',{Color=accent,Thickness=1.5},main)
local header = create('TextLabel',{Size=UDim2.new(1,-48,0,42),BackgroundTransparency=1,Text='BID AIM HUB  |  V1',TextColor3=accent,TextSize=17,Font=Enum.Font.GothamBold},main)
local minimize = create('TextButton',{Size=UDim2.fromOffset(36,32),Position=UDim2.new(1,-40,0,5),BackgroundColor3=panel,Text='-',TextSize=24,TextColor3=white},main)
round(minimize,8)
local sidebar = create('Frame',{Size=UDim2.fromOffset(95,252),Position=UDim2.fromOffset(8,48),BackgroundColor3=panel,BorderSizePixel=0},main)
round(sidebar,10)
local content = create('Frame',{Size=UDim2.new(1,-119,1,-58),Position=UDim2.fromOffset(111,48),BackgroundColor3=panel,BorderSizePixel=0},main)
round(content,10)
local pages,tabs={},{}
for _,name in ipairs({'Visual','ESP','Settings'}) do
    local page = create('ScrollingFrame',{Size=UDim2.new(1,-12,1,-12),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=accent,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=name=='Visual'},content)
    create('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
    pages[name]=page
end
local function showPage(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
    for n,b in pairs(tabs) do b.BackgroundColor3=(n==name and accent or bg) end
end
for i,name in ipairs({'Visual','ESP','Settings'}) do
    local b=create('TextButton',{Size=UDim2.new(1,-12,0,38),Position=UDim2.fromOffset(6,7+(i-1)*46),BackgroundColor3=name=='Visual' and accent or bg,Text=name,TextColor3=white,TextSize=12,Font=Enum.Font.GothamBold},sidebar)
    round(b,8)
    tabs[name]=b
    b.MouseButton1Click:Connect(function() showPage(name) end)
end
local function toggle(page,label,key)
    local b=create('TextButton',{Size=UDim2.new(1,-5,0,35),BackgroundColor3=bg,TextColor3=white,TextSize=12,Font=Enum.Font.Gotham,Text=label..' : OFF'},pages[page])
    round(b,7)
    b.MouseButton1Click:Connect(function()
        state[key]=not state[key]
        b.Text=label..(state[key] and ' : ON' or ' : OFF')
        b.BackgroundColor3=state[key] and accent or bg
    end)
end
local function slider(page,label,key,minVal,maxVal,step)
    local b=create('TextButton',{Size=UDim2.new(1,-5,0,35),BackgroundColor3=bg,TextColor3=white,TextSize=12,Font=Enum.Font.Gotham,Text=label..' : '..state[key]..' (+)'},pages[page])
    round(b,7)
    b.MouseButton1Click:Connect(function()
        state[key]=state[key]+step
        if state[key]>maxVal then state[key]=minVal end
        b.Text=label..' : '..state[key]..' (+)'
    end)
end

toggle('Visual','FOV Circle','FOVCircle')
slider('Visual','FOV Size','FOVSize',50,500,10)
slider('Visual','Smooth','Smooth',1,20,1)
for _,item in ipairs({{'Show Name','ShowName'},{'Box','Box'},{'Skeletons','Skeletons'},{'Health Bar','HealthBar'},{'Distance','Distance'},{'Team Check','TeamCheck'}}) do
    toggle('ESP',item[1],item[2])
end
local part=create('TextButton',{Size=UDim2.new(1,-5,0,35),BackgroundColor3=bg,TextColor3=white,TextSize=12,Text='Target Part : Head'},pages.Settings)
round(part,7)
part.MouseButton1Click:Connect(function()
    state.TargetPart=state.TargetPart=='Head' and 'HumanoidRootPart' or 'Head'
    part.Text='Target Part : '..state.TargetPart
end)
local color=create('TextButton',{Size=UDim2.new(1,-5,0,35),BackgroundColor3=bg,TextColor3=white,TextSize=12,Text='Accent Color : Purple'},pages.Settings)
round(color,7)
local colors={{'Purple',Color3.fromRGB(160,85,255)},{'Blue',Color3.fromRGB(60,140,255)},{'Pink',Color3.fromRGB(255,80,180)}}
local ci=1
color.MouseButton1Click:Connect(function()
    ci=ci%#colors+1
    accent=colors[ci][2]
    color.Text='Accent Color : '..colors[ci][1]
    header.TextColor3=accent
    mainStroke.Color=accent
    showPage((function() for n,p in pairs(pages) do if p.Visible then return n end end return 'Settings' end)())
end)

-- FOV Circle Frame Handler
local fov=create('Frame',{Size=UDim2.fromOffset(260,260),AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,Visible=false},gui)
round(fov,999)
local fovStroke = create('UIStroke',{Color=accent,Thickness=2},fov)

-- ==========================================
-- Backend Logic: ESP & Aim Lock
-- ==========================================
local espCache = {}

local function removeESP(p)
    if espCache[p] then
        if espCache[p].Box then espCache[p].Box:Remove() end
        if espCache[p].Name then espCache[p].Name:Remove() end
        if espCache[p].Health then espCache[p].Health:Remove() end
        if espCache[p].Distance then espCache[p].Distance:Remove() end
        espCache[p] = nil
    end
end

local function addESP(p)
    if p == player then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Size = 13
    nameTag.Center = true
    nameTag.Color = Color3.fromRGB(255, 255, 255)

    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Filled = true
    healthBar.Thickness = 1

    local distTag = Drawing.new("Text")
    distTag.Visible = false
    distTag.Size = 12
    distTag.Center = true
    distTag.Color = Color3.fromRGB(200, 200, 200)

    espCache[p] = {Box = box, Name = nameTag, Health = healthBar, Distance = distTag}

    RunService.RenderStepped:Connect(function()
        local data = espCache[p]
        if not data or not gui.Parent then return end

        local character = p.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        local isTeam = false
        if state.TeamCheck and p.Team and player.Team and p.Team == player.Team then
            isTeam = true
        end

        if character and hrp and humanoid and humanoid.Health > 0 and not isTeam then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local width = math.clamp(1500 / vector.Z, 15, 300)
                local height = math.clamp(2500 / vector.Z, 25, 500)
                local pos = Vector2.new(vector.X - width / 2, vector.Y - height / 2)

                -- Box ESP
                if state.Box then
                    data.Box.Size = Vector2.new(width, height)
                    data.Box.Position = pos
                    data.Box.Color = accent
                    data.Box.Visible = true
                else
                    data.Box.Visible = false
                end

                -- Show Name
                if state.ShowName then
                    data.Name.Text = p.Name
                    data.Name.Position = Vector2.new(vector.X, pos.Y - 18)
                    data.Name.Visible = true
                else
                    data.Name.Visible = false
                end

                -- Health Bar
                if state.HealthBar then
                    local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    data.HealthBar.Size = Vector2.new(3, height * healthPct)
                    data.HealthBar.Position = Vector2.new(pos.X - 6, pos.Y + (height * (1 - healthPct)))
                    data.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                    data.HealthBar.Visible = true
                else
                    data.HealthBar.Visible = false
                end

                -- Distance
                if state.Distance and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    data.Distance.Text = dist .. "m"
                    data.Distance.Position = Vector2.new(vector.X, pos.Y + height + 2)
                    data.Distance.Visible = true
                else
                    data.Distance.Visible = false
                end
            else
                data.Box.Visible = false
                data.Name.Visible = false
                data.HealthBar.Visible = false
                data.Distance.Visible = false
            end
        else
            data.Box.Visible = false
            data.Name.Visible = false
            data.HealthBar.Visible = false
            data.Distance.Visible = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

-- ฟังก์ชันค้นหาเป้าหมายที่ใกล้ที่สุดในวง FOV
local function getClosestPlayerInFOV()
    local closestPart = nil
    local shortestDist = state.FOVSize
    local mousePos = UIS:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local targetPartObj = p.Character:FindFirstChild(state.TargetPart)
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            local isTeam = state.TeamCheck and p.Team and player.Team and p.Team == player.Team

            if targetPartObj and humanoid and humanoid.Health > 0 and not isTeam then
                local vector, onScreen = Camera:WorldToViewportPoint(targetPartObj.Position)
                if onScreen then
                    local dist = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPart = targetPartObj
                    end
                end
            end
        end
    end
    return closestPart
end

local renderConnection
renderConnection=RunService.RenderStepped:Connect(function()
    if not gui.Parent then renderConnection:Disconnect() return end
    
    -- จัดการแสดงผลวง FOV
    fov.Visible=state.FOVCircle
    if fov.Visible then
        fov.Size=UDim2.fromOffset(state.FOVSize*2,state.FOVSize*2)
        local viewport=Camera and Camera.ViewportSize or Vector2.new(800,600)
        fov.Position=UDim2.fromOffset(viewport.X/2,viewport.Y/2)
        fovStroke.Color = accent

        -- ระบบล็อกเป้าทำงานเมื่อเปิด FOV Circle
        local target = getClosestPlayerInFOV()
        if target then
            local camPos = Camera.CFrame.Position
            local targetPos = target.Position
            local smoothVal = math.clamp(state.Smooth, 1, 20)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, targetPos), 1 / smoothVal)
        end
    end
end)

local dragging,startPos,initialPos=false,nil,nil
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        startPos=input.Position
        initialPos=main.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-startPos
        main.Position=UDim2.new(initialPos.X.Scale,initialPos.X.Offset+delta.X,initialPos.Y.Scale,initialPos.Y.Offset+delta.Y)
    end
end)
local minimized=false
minimize.MouseButton1Click:Connect(function()
    minimized=not minimized
    sidebar.Visible=not minimized
    content.Visible=not minimized
    main.Size=minimized and UDim2.fromOffset(330,42) or UDim2.fromOffset(330,310)
    minimize.Text=minimized and '+' or '-'
end)

print('BID AIM HUB V1 - Full ESP & Aim Lock Loaded')
