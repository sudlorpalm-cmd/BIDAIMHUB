-- BID AIM HUB V1 | Roblox mobile UI
-- UI demo only. No player targeting or ESP.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local pg = Players.LocalPlayer:WaitForChild('PlayerGui')
local existing = pg:FindFirstChild('BID_AIM_HUB_V1')
if existing then existing:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name='BID_AIM_HUB_V1'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.Parent=pg
local purple=Color3.fromRGB(157,88,255)
local dark=Color3.fromRGB(19,16,29)
local panel=Color3.fromRGB(33,27,47)
local white=Color3.fromRGB(243,239,255)
local function new(cls, props, parent)
 local o=Instance.new(cls)
 for k,v in pairs(props) do o[k]=v end
 o.Parent=parent; return o
end
local function round(o,r)
 new('UICorner',{CornerRadius=UDim.new(0,r)},o)
end
local main=new('Frame',{Size=UDim2.fromOffset(345,340),Position=UDim2.new(.5,-172,.5,-170),BackgroundColor3=dark,BorderSizePixel=0,Active=true},gui)
round(main,13)
new('UIStroke',{Color=purple,Thickness=1.5},main)
local bar=new('Frame',{Size=UDim2.new(1,0,0,45),BackgroundTransparency=1,Active=true},main)
new('TextLabel',{Size=UDim2.new(1,-55,1,0),BackgroundTransparency=1,Text='BID AIM HUB  |  V1',TextColor3=purple,Font=Enum.Font.GothamBold,TextSize=17},bar)
local minimize=new('TextButton',{Size=UDim2.fromOffset(34,31),Position=UDim2.new(1,-40,0,7),BackgroundColor3=panel,Text='−',TextColor3=white,TextSize=23},bar)
round(minimize,8)
local side=new('Frame',{Position=UDim2.fromOffset(8,49),Size=UDim2.new(0,99,1,-57),BackgroundColor3=panel,BorderSizePixel=0},main)
round(side,9)
local content=new('Frame',{Position=UDim2.fromOffset(114,49),Size=UDim2.new(1,-122,1,-57),BackgroundColor3=panel,BorderSizePixel=0},main)
round(content,9)
local pages,buttons={},{}
for _,name in ipairs({'Visual','ESP','Settings'}) do
 local p=new('ScrollingFrame',{Size=UDim2.new(1,-12,1,-12),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=purple,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=name=='Visual'},content)
 new('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},p)
 pages[name]=p
end
local function selectTab(name)
 for n,p in pairs(pages) do p.Visible=n==name end
 for n,b in pairs(buttons) do b.BackgroundColor3=n==name and purple or dark end
end
for i,name in ipairs({'Visual','ESP','Settings'}) do
 local b=new('TextButton',{Position=UDim2.fromOffset(6,7+(i-1)*47),Size=UDim2.new(1,-12,0,39),BackgroundColor3=name=='Visual' and purple or dark,Text=name,TextColor3=white,Font=Enum.Font.GothamBold,TextSize=12},side)
 round(b,7); buttons[name]=b
 b.MouseButton1Click:Connect(function() selectTab(name) end)
end
local state={FOVCircle=false,FOVSize=130,Smooth=5,ShowName=false,Box=false,Skeletons=false,HealthBar=false,Distance=false,TeamCheck=false,TargetPart='Head'}
local function toggle(tab,label,key)
 local b=new('TextButton',{Size=UDim2.new(1,-6,0,37),BackgroundColor3=dark,TextColor3=white,TextSize=12,Font=Enum.Font.GothamMedium},pages[tab])
 round(b,7)
 local function refresh() b.Text=label..'  ['..(state[key] and 'ON' or 'OFF')..']' end
 refresh()
 b.MouseButton1Click:Connect(function() state[key]=not state[key];refresh() end)
end
local function cycle(tab,label,key,values)
 local b=new('TextButton',{Size=UDim2.new(1,-6,0,37),BackgroundColor3=dark,TextColor3=white,TextSize=12,Font=Enum.Font.GothamMedium},pages[tab]);round(b,7)
 local function refresh() b.Text=label..': '..tostring(state[key]) end
 refresh()
 b.MouseButton1Click:Connect(function()
  local at=table.find(values,state[key]) or 0
  state[key]=values[(at%#values)+1]
  refresh()
 end)
end
local fovCircle=new('Frame',{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(130,130),Position=UDim2.fromScale(.5,.5),BackgroundTransparency=1,Visible=false},gui)
round(fovCircle,999)
new('UIStroke',{Color=purple,Thickness=1.6},fovCircle)
local function updateCircle()
 fovCircle.Visible=state.FOVCircle
 fovCircle.Size=UDim2.fromOffset(state.FOVSize,state.FOVSize)
end
local fovButton=new('TextButton',{Size=UDim2.new(1,-6,0,37),BackgroundColor3=dark,TextColor3=white,TextSize=12,Font=Enum.Font.GothamMedium},pages.Visual);round(fovButton,7)
local function fovLabel() fovButton.Text='FOV Circle  ['..(state.FOVCircle and 'ON' or 'OFF')..']' end
fovLabel()
fovButton.MouseButton1Click:Connect(function() state.FOVCircle=not state.FOVCircle;fovLabel();updateCircle() end)
local function stepper(tab,label,key,min,max,step,onChanged)
 local b=new('TextButton',{Size=UDim2.new(1,-6,0,37),BackgroundColor3=dark,TextColor3=white,TextSize=12,Font=Enum.Font.GothamMedium},pages[tab]);round(b,7)
 local function refresh() b.Text=label..': '..tostring(state[key])..'  (+)' end
 refresh()
 b.MouseButton1Click:Connect(function()
  local n=state[key]+step
  if n>max then n=min end
  state[key]=n;refresh()
  if onChanged then onChanged() end
 end)
end
stepper('Visual','FOV Size','FOVSize',70,300,10,updateCircle)
stepper('Visual','Smooth','Smooth',1,20,1)
for _,entry in ipairs({{'Show Name','ShowName'},{'Box','Box'},{'Skeletons','Skeletons'},{'Health Bar','HealthBar'},{'Distance','Distance'},{'Team Check','TeamCheck'}}) do toggle('ESP',entry[1],entry[2]) end
cycle('Settings','Target Part','TargetPart',{'Head','UpperTorso','HumanoidRootPart'})
local accentButton=new('TextButton',{Size=UDim2.new(1,-6,0,37),BackgroundColor3=dark,Text='Accent Color: Purple',TextColor3=white,TextSize=12,Font=Enum.Font.GothamMedium},pages.Settings);round(accentButton,7)
local colors={{'Purple',Color3.fromRGB(157,88,255)},{'Pink',Color3.fromRGB(255,88,182)},{'Blue',Color3.fromRGB(80,170,255)}}
local ci=1
accentButton.MouseButton1Click:Connect(function()
 ci=ci%#colors+1
 purple=colors[ci][2]
 accentButton.Text='Accent Color: '..colors[ci][1]
 fovCircle.UIStroke.Color=purple
 main.UIStroke.Color=purple
 for name,b in pairs(buttons) do if pages[name].Visible then b.BackgroundColor3=purple end end
end)
local drag,origin,start
bar.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  drag=true;origin=main.Position;start=input.Position
  input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then drag=false end end)
 end
end)
UIS.InputChanged:Connect(function(input)
 if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-start
  main.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,origin.Y.Scale,origin.Y.Offset+d.Y)
 end
end)
local minimized=false
minimize.MouseButton1Click:Connect(function()
 minimized=not minimized
 side.Visible=not minimized;content.Visible=not minimized
 main.Size= minimized and UDim2.fromOffset(345,45) or UDim2.fromOffset(345,340)
 minimize.Text=minimized and '+' or '−'
end)
print('BID AIM HUB V1 UI loaded')
