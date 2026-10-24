-- BID AIM HUB MOBILE V1 | training NPCs only
-- Put NPC models with Humanoid inside workspace.TrainingTargets.
-- LocalScript compatible with Roblox Studio. Executor compatibility is not guaranteed.
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService('UserInputService')
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local targets = workspace:FindFirstChild('TrainingTargets')
local old = player.PlayerGui:FindFirstChild('BIDAimMobile')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name='BIDAimMobile'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
 gui.Parent=player:WaitForChild('PlayerGui')
local config={fov=150,smooth=50,part='Head',circle=true,esp=false,assist=false}
local function ui(class,props,parent)
 local o=Instance.new(class)
 for k,v in pairs(props) do o[k]=v end
 o.Parent=parent; return o
end
local panel=ui('Frame',{Size=UDim2.fromOffset(275,335),Position=UDim2.new(.5,-137,.5,-167),BackgroundColor3=Color3.fromRGB(23,17,38),BorderSizePixel=0},gui)
ui('UICorner',{CornerRadius=UDim.new(0,12)},panel)
ui('UIStroke',{Color=Color3.fromRGB(135,91,220),Thickness=1},panel)
local top=ui('TextLabel',{Size=UDim2.new(1,-50,0,42),Position=UDim2.fromOffset(12,0),Text='BID AIM HUB  |  TRAINING',TextColor3=Color3.fromRGB(214,191,255),TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1},panel)
local collapse=ui('TextButton',{Size=UDim2.fromOffset(35,35),Position=UDim2.new(1,-40,0,4),Text='−',TextSize=24,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(75,47,125)},panel)
ui('UICorner',{CornerRadius=UDim.new(0,7)},collapse)
local body=ui('Frame',{Size=UDim2.new(1,-16,1,-50),Position=UDim2.fromOffset(8,45),BackgroundTransparency=1},panel)
local layout=ui('UIListLayout',{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},body)
local function button(name,fn)
 local b=ui('TextButton',{Size=UDim2.new(1,0,0,32),BackgroundColor3=Color3.fromRGB(48,35,72),TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamMedium,Text=name},body)
 ui('UICorner',{CornerRadius=UDim.new(0,7)},b)
 b.MouseButton1Click:Connect(function() fn(b) end)
 return b
end
local function slider(name,key,min,max)
 local row=ui('Frame',{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1},body)
 local label=ui('TextLabel',{Size=UDim2.new(1,0,0,19),BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Text=name..': '..config[key]},row)
 local track=ui('Frame',{Position=UDim2.fromOffset(4,25),Size=UDim2.new(1,-8,0,12),BackgroundColor3=Color3.fromRGB(62,48,82)},row)
 ui('UICorner',{CornerRadius=UDim.new(1,0)},track)
 local fill=ui('Frame',{Size=UDim2.new((config[key]-min)/(max-min),0,1,0),BackgroundColor3=Color3.fromRGB(166,119,255)},track)
 ui('UICorner',{CornerRadius=UDim.new(1,0)},fill)
 local dragging=false
 local function set(x)
  local f=math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)
  config[key]=math.floor(min+(max-min)*f+.5)
  fill.Size=UDim2.new(f,0,1,0); label.Text=name..': '..config[key]
 end
 track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;set(i.Position.X) end end)
 UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then set(i.Position.X) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
end
slider('FOV','fov',30,500)
slider('Smooth','smooth',1,100)
button('FOV Circle: ON',function(b) config.circle=not config.circle;b.Text='FOV Circle: '..(config.circle and 'ON' or 'OFF') end)
button('Aim Assist (NPC): OFF',function(b) config.assist=not config.assist;b.Text='Aim Assist (NPC): '..(config.assist and 'ON' or 'OFF') end)
button('Training ESP: OFF',function(b) config.esp=not config.esp;b.Text='Training ESP: '..(config.esp and 'ON' or 'OFF') end)
local parts={'Head','UpperTorso','HumanoidRootPart'}
button('Target: Head',function(b) local i=table.find(parts,config.part) or 1;config.part=parts[i%#parts+1];b.Text='Target: '..config.part end)
button('Hide Menu / Tap BID to reopen',function() body.Visible=false;panel.Size=UDim2.fromOffset(275,42);collapse.Text='+' end)
collapse.MouseButton1Click:Connect(function() body.Visible=not body.Visible;panel.Size=body.Visible and UDim2.fromOffset(275,335) or UDim2.fromOffset(275,42);collapse.Text=body.Visible and '−' or '+' end)
-- Touch/mouse dragging on header
local moving=false;local startPos;local origin
 top.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then moving=true;startPos=i.Position;origin=panel.Position end end)
 UIS.InputChanged:Connect(function(i) if moving and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then local d=i.Position-startPos;panel.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,origin.Y.Scale,origin.Y.Offset+d.Y) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then moving=false end end)
local circle=ui('Frame',{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1},gui)
ui('UICorner',{CornerRadius=UDim.new(1,0)},circle)
ui('UIStroke',{Color=Color3.fromRGB(180,133,255),Thickness=2},circle)
local highlights={}
local function updateESP()
 if not targets then targets=workspace:FindFirstChild('TrainingTargets') end
 local alive={}
 if targets then for _,model in ipairs(targets:GetChildren()) do
  if model:IsA('Model') and model:FindFirstChildOfClass('Humanoid') then
   alive[model]=true
   if config.esp and not highlights[model] then
    highlights[model]=ui('Highlight',{Name='BIDTrainingHighlight',FillTransparency=.8,OutlineColor=Color3.fromRGB(195,145,255),FillColor=Color3.fromRGB(119,74,206),DepthMode=Enum.HighlightDepthMode.Occluded,Adornee=model},gui)
   end
  end
 end end
 for model,h in pairs(highlights) do if not config.esp or not alive[model] or not model.Parent then h:Destroy();highlights[model]=nil end end
end
local tickESP=0
local connection
connection=RunService.RenderStepped:Connect(function(dt)
 if not gui.Parent then connection:Disconnect();return end
 camera=workspace.CurrentCamera
 if not camera then return end
 local center=camera.ViewportSize/2
 circle.Visible=config.circle
 circle.Position=UDim2.fromOffset(center.X,center.Y)
 circle.Size=UDim2.fromOffset(config.fov*2,config.fov*2)
 tickESP=tickESP+dt
 if tickESP>.3 then tickESP=0;updateESP() end
 if not config.assist or not targets then return end
 local best,bestDist=nil,config.fov
 for _,m in ipairs(targets:GetChildren()) do
  local hum=m:FindFirstChildOfClass('Humanoid')
  local part=m:FindFirstChild(config.part) or m:FindFirstChild('HumanoidRootPart')
  if hum and hum.Health>0 and part and part:IsA('BasePart') then
   local pos,visible=camera:WorldToViewportPoint(part.Position)
   if visible then local dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude
    if dist<bestDist then bestDist=dist;best=part end
   end
  end
 end
 if best then
  local alpha=math.clamp(dt* (101-config.smooth)*.3,0,1)
  camera.CFrame=camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position,best.Position),alpha)
 end
end)
