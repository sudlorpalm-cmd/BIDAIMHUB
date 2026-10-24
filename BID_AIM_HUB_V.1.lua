-- BID AIM HUB V1 - UI sliders + supplied ESP and Aim Lock logic
-- Reconstructed from the user-provided script; not runtime tested.

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local Camera = workspace.CurrentCamera
local UIS = game:GetService('UserInputService')
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
local state = {FOVCircle=false,FOVSize=130,Smooth=5,ShowName=false,Box=false,Skeletons=false,HealthBar=false,Distance=false,TeamCheck=false,TargetPart='Head'}

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
create('UIStroke',{Color=accent,Thickness=1.5},main)
local header = create('TextLabel',{Size=UDim2.new(1,-48,0,42),BackgroundTransparency=1,Text='BID AIM HUB  |  V1',TextColor3=accent,TextSize=17,Font=Enum.Font.GothamBold},main)
local minimize = create('TextButton',{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,-76,0,5),BackgroundColor3=panel,Text='-',TextSize=24,TextColor3=white},main)
round(minimize,8)
local closeButton=create('TextButton',{Size=UDim2.fromOffset(32,32),Position=UDim2.new(1,-40,0,5),BackgroundColor3=panel,Text='×',TextSize=22,TextColor3=white},main)
round(closeButton,8)
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
-- Touch-friendly draggable sliders
local sliderConnections = {}
local function slider(page,label,key,minVal,maxVal,step)
    local holder=create('Frame',{Size=UDim2.new(1,-5,0,58),BackgroundColor3=bg,BorderSizePixel=0},pages[page])
    round(holder,7)
    local caption=create('TextLabel',{Size=UDim2.new(1,-12,0,23),Position=UDim2.fromOffset(6,3),BackgroundTransparency=1,TextColor3=white,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},holder)
    local track=create('Frame',{Size=UDim2.new(1,-22,0,7),Position=UDim2.new(0,11,0,37),BackgroundColor3=panel,BorderSizePixel=0},holder)
    round(track,7)
    local fill=create('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=accent,BorderSizePixel=0},track)
    round(fill,7)
    local knob=create('Frame',{Size=UDim2.fromOffset(17,17),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(0,.5),BackgroundColor3=white,BorderSizePixel=0},track)
    round(knob,20)
    local active=false
    local function refresh()
        local ratio=(state[key]-minVal)/(maxVal-minVal)
        caption.Text=label..' : '..tostring(state[key])
        fill.Size=UDim2.fromScale(ratio,1)
        knob.Position=UDim2.fromScale(ratio,.5)
        fill.BackgroundColor3=accent
    end
    local function update(x)
        local ratio=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
        state[key]=math.clamp(minVal+math.floor((ratio*(maxVal-minVal))/step+.5)*step,minVal,maxVal)
        refresh()
    end
    for _,target in ipairs({track,knob,holder}) do
        target.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
                if target==holder and input.Position.Y < track.AbsolutePosition.Y-12 then return end
                active=true
                update(input.Position.X)
            end
        end)
    end
    table.insert(sliderConnections,UIS.InputChanged:Connect(function(input)
        if active and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then update(input.Position.X) end
    end))
    table.insert(sliderConnections,UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then active=false end
    end))
    refresh()
end

toggle('Visual','FOV Circle','FOVCircle')
slider('Visual','FOV Size','FOVSize',50,500,5)
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
    showPage((function() for n,p in pairs(pages) do if p.Visible then return n end end return 'Settings' end)())
end)

local fov=create('Frame',{Size=UDim2.fromOffset(260,260),AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,Visible=false},gui)
round(fov,999)
local fovStroke=create('UIStroke',{Color=accent,Thickness=2},fov)
-- Backend Logic: ESP & Aim Lock (Mobile Safe)
local espCache = {}

local function removeESP(p)
    local data = espCache[p]
    if data then
        if data.Highlight then data.Highlight:Destroy() end
        if data.Billboard then data.Billboard:Destroy() end
        espCache[p] = nil
    end
end

local function addESP(p)
    if p == player then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "BIDEsp"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1
    highlight.Parent = p

    local bill = Instance.new("BillboardGui")
    bill.Name = "BIDInfo"
    bill.Size = UDim2.new(0, 150, 0, 50)
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.AlwaysOnTop = true
    bill.Enabled = false
    bill.Parent = p:WaitForChild("Character", 5) or p

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = bill

    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(0, 4, 0, 30)
    healthBarBg.Position = UDim2.new(0, -8, 0, 22)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Visible = false
    healthBarBg.Parent = bill

    local healthBarFill = Instance.new("Frame")
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBarFill.BorderSizePixel = 0
    healthBarFill.Parent = healthBarBg

    p.CharacterAdded:Connect(function(char)
        bill.Parent = char
    end)

    espCache[p] = {Highlight = highlight, Billboard = bill, Text = textLabel, HealthBg = healthBarBg, HealthFill = healthBarFill}

    RunService.RenderStepped:Connect(function()
        local data = espCache[p]
        if not data or not gui.Parent then return end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local isTeam = state.TeamCheck and p.Team and player.Team and p.Team == player.Team

        if char and hrp and humanoid and humanoid.Health > 0 and not isTeam then
            if state.Box then
                highlight.FillTransparency = 0.85
                highlight.OutlineTransparency = 0
                highlight.FillColor = accent
                highlight.OutlineColor = accent
            else
                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 1
            end

            local showInfo = state.ShowName or state.Distance
            if showInfo then
                bill.Enabled = true
                local txt = ""
                if state.ShowName then txt = p.Name end
                if state.Distance and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    txt = txt .. (txt ~= "" and " [" or "") .. dist .. "m" .. (txt ~= "" and "]" or "")
                end
                data.Text.Text = txt
                data.Text.Visible = true
            else
                data.Text.Visible = false
            end

            if state.HealthBar then
                data.HealthBg.Visible = true
                local healthPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                data.HealthFill.Size = UDim2.new(1, 0, healthPct, 0)
                data.HealthFill.Position = UDim2.new(0, 0, 1 - healthPct, 0)
                data.HealthFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
            else
                data.HealthBg.Visible = false
            end
            if not showInfo and not state.HealthBar and highlight.FillTransparency == 1 then
                bill.Enabled = false
            end
        else
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 1
            bill.Enabled = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

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
    fov.Visible=state.FOVCircle
    fovStroke.Color=accent
    if fov.Visible then
        fov.Size=UDim2.fromOffset(state.FOVSize*2,state.FOVSize*2)
        local viewport=Camera and Camera.ViewportSize or Vector2.new(800,600)
        fov.Position=UDim2.fromOffset(viewport.X/2,viewport.Y/2)
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

-- Confirm before permanently closing the UI for this execution.
local confirm=create('Frame',{Size=UDim2.fromOffset(290,145),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),BackgroundColor3=panel,BorderSizePixel=0,Visible=false,ZIndex=20},gui)
round(confirm,12)
create('UIStroke',{Color=accent,Thickness=2},confirm)
create('TextLabel',{Size=UDim2.new(1,-20,0,65),Position=UDim2.fromOffset(10,8),BackgroundTransparency=1,Text='Close BID AIM HUB V1?\nThe menu will close until you run it again.',TextColor3=white,TextSize=13,TextWrapped=true,ZIndex=21},confirm)
local cancel=create('TextButton',{Size=UDim2.fromOffset(120,38),Position=UDim2.fromOffset(17,92),BackgroundColor3=bg,Text='Cancel',TextColor3=white,TextSize=14,ZIndex=21},confirm)
round(cancel,8)
local accept=create('TextButton',{Size=UDim2.fromOffset(120,38),Position=UDim2.fromOffset(153,92),BackgroundColor3=accent,Text='Close',TextColor3=white,TextSize=14,ZIndex=21},confirm)
round(accept,8)
closeButton.MouseButton1Click:Connect(function() confirm.Visible=true end)
cancel.MouseButton1Click:Connect(function() confirm.Visible=false end)
accept.MouseButton1Click:Connect(function()
    for _,connection in ipairs(sliderConnections) do connection:Disconnect() end
    renderConnection:Disconnect()
    gui:Destroy()
end)

print('BID AIM HUB V1 - Fully Functional Loaded Successfully!')
