-- BID AIM HUB V3 MOBILE | Local UI + authorized TrainingTargets NPC visualization
-- No player targeting, no screen-share bypass. For experiences you own/control.
local Players=game:GetService('Players')
local UIS=game:GetService('UserInputService')
local Run=game:GetService('RunService')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
local previous=pg:FindFirstChild('BIDAimHubV3')
if previous then previous:Destroy() end
local gui=Instance.new('ScreenGui');gui.Name='BIDAimHubV3';gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=pg
local C={bg=Color3.fromRGB(25,18,41),surface=Color3.fromRGB(46,34,68),purple=Color3.fromRGB(160,107,246),white=Color3.fromRGB(243,236,255)}
local cfg={circle=true,fov=160,smooth=50,part='Head',name=false,box=false,skeleton=false,health=false,distance=false,team=false}
local function make(typ,props,parent)
 local x=Instance.new(typ)
 for k,v in pairs(props) do x[k]=v end
 x.Parent=parent;return x
end
local function round(o,n) make('UICorner',{CornerRadius=UDim.new(0,n or 9)},o) end
local panel=make('Frame',{Size=UDim2.fromOffset(310,360),Position=UDim2.new(.5,-155,.5,-180),BackgroundColor3=C.bg,BorderSizePixel=0},gui);round(panel,13)
make('UIStroke',{Color=C.purple,Thickness=1},panel)
local header=make('TextButton',{Size=UDim2.new(1,-48,0,45),Position=UDim2.fromOffset(10,0),Text='BID AIM HUB   •   V3',TextColor3=C.white,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1},panel)
local minimize=make('TextButton',{Size=UDim2.fromOffset(35,32),Position=UDim2.new(1,-41,0,6),Text='−',TextSize=22,TextColor3=C.white,BackgroundColor3=C.surface},panel);round(minimize)
local body=make('Frame',{Position=UDim2.fromOffset(8,48),Size=UDim2.new(1,-16,1,-56),BackgroundTransparency=1},panel)
local nav=make('Frame',{Size=UDim2.fromOffset(51,300),BackgroundTransparency=1},body)
local content=make('Frame',{Position=UDim2.fromOffset(59,0),Size=UDim2.new(1,-59,1,0),BackgroundTransparency=1},body)
local page='visual'
local function clear() for _,x in ipairs(content:GetChildren()) do x:Destroy() end end
local function text(t,y)
 return make('TextLabel',{Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,0,0,28),BackgroundTransparency=1,Text=t,TextColor3=C.purple,Font=Enum.Font.GothamBold,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left},content)
end
local function toggle(label,key,y)
 local b=make('TextButton',{Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,0,0,37),BackgroundColor3=C.surface,TextColor3=C.white,Font=Enum.Font.Gotham,TextSize=12,Text=label..'   '..(cfg[key] and 'ON' or 'OFF')},content);round(b)
 b.MouseButton1Click:Connect(function() cfg[key]=not cfg[key];b.Text=label..'   '..(cfg[key] and 'ON' or 'OFF') end)
end
local function slider(label,key,low,high,y)
 local title=make('TextLabel',{Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,0,0,21),BackgroundTransparency=1,Text=label..': '..cfg[key],TextColor3=C.white,Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},content)
 local track=make('Frame',{Position=UDim2.fromOffset(0,y+25),Size=UDim2.new(1,0,0,13),BackgroundColor3=C.surface},content);round(track)
 local fill=make('Frame',{Size=UDim2.new((cfg[key]-low)/(high-low),0,1,0),BackgroundColor3=C.purple},track);round(fill)
 local dragging=false
 local function update(x)
  local p=math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)
  cfg[key]=math.floor(low+p*(high-low)+.5);fill.Size=UDim2.new(p,0,1,0);title.Text=label..': '..cfg[key]
 end
 track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;update(i.Position.X) end end)
 UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then update(i.Position.X) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
end
local function render()
 clear()
 if page=='visual' then
  text('VISUAL SETTINGS',0);toggle('FOV Circle','circle',38);slider('FOV Size','fov',30,500,87);slider('Smooth (reserved)','smooth',1,100,152)
  make('TextLabel',{Position=UDim2.fromOffset(0,210),Size=UDim2.new(1,0,0,70),BackgroundTransparency=1,TextWrapped=true,Text='Smooth is a saved UI setting; no player aim lock is included.',TextColor3=Color3.fromRGB(170,151,190),TextSize=11,Font=Enum.Font.Gotham},content)
 elseif page=='esp' then
  text('ESP SETTINGS',0)
  for i,v in ipairs({{'Show Name','name'},{'Box ESP','box'},{'Skeletons','skeleton'},{'Health Bar','health'},{'Show Distance','distance'},{'Team Check','team'}}) do toggle(v[1],v[2],31+(i-1)*43) end
 else
  text('SETTINGS',0)
  local parts={'Head','UpperTorso','HumanoidRootPart'}
  local b=make('TextButton',{Position=UDim2.fromOffset(0,40),Size=UDim2.new(1,0,0,40),Text='Target Part: '..cfg.part,BackgroundColor3=C.surface,TextColor3=C.white,TextSize=11},content);round(b)
  b.MouseButton1Click:Connect(function() local i=table.find(parts,cfg.part) or 1;cfg.part=parts[i%#parts+1];b.Text='Target Part: '..cfg.part end)
  make('TextLabel',{Position=UDim2.fromOffset(0,95),Size=UDim2.new(1,0,0,100),BackgroundTransparency=1,TextWrapped=true,Text='BIDSHOP • Training overlay\nTargets: workspace.TrainingTargets\nNo opponent tracking or screen-share bypass.',TextColor3=C.white,TextSize=12},content)
 end
end
local navBtns={}
for i,v in ipairs({{'◎','visual'},{'◉','esp'},{'⚙','settings'}}) do
 local b=make('TextButton',{Position=UDim2.fromOffset(2,(i-1)*56),Size=UDim2.fromOffset(46,47),Text=v[1],TextSize=25,TextColor3=C.white,BackgroundColor3=C.surface},nav);round(b)
 b.MouseButton1Click:Connect(function()page=v[2];for k,bb in ipairs(navBtns) do bb.BackgroundColor3=(k==i) and C.purple or C.surface end;render() end)
 navBtns[i]=b
end
navBtns[1].BackgroundColor3=C.purple;render()
minimize.MouseButton1Click:Connect(function()body.Visible=not body.Visible;panel.Size=body.Visible and UDim2.fromOffset(310,360) or UDim2.fromOffset(310,45);minimize.Text=body.Visible and '−' or '+' end)
local moving=false;local start,origin
header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then moving=true;start=i.Position;origin=panel.Position end end)
UIS.InputChanged:Connect(function(i) if moving and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then local d=i.Position-start;panel.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,origin.Y.Scale,origin.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then moving=false end end)
local circle=make('Frame',{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1},gui);make('UICorner',{CornerRadius=UDim.new(1,0)},circle);make('UIStroke',{Color=C.purple,Thickness=2},circle)
local overlays={}
local function destroyOverlay(m)
 local o=overlays[m];if not o then return end
 for _,x in ipairs(o.objects) do x:Destroy() end;overlays[m]=nil
end
local function createOverlay(m)
 local o={objects={}}
 local function track(x) table.insert(o.objects,x);return x end
 o.box=track(make('Frame',{BackgroundTransparency=1,Visible=false},gui));make('UIStroke',{Color=C.purple,Thickness=2},o.box)
 o.label=track(make('TextLabel',{BackgroundTransparency=1,TextColor3=C.white,TextSize=12,Font=Enum.Font.GothamBold,Visible=false},gui))
 o.hpBg=track(make('Frame',{BackgroundColor3=Color3.fromRGB(55,30,35),BorderSizePixel=0,Visible=false},gui))
 o.hpFill=make('Frame',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(91,232,126),BorderSizePixel=0},o.hpBg)
 o.lines={}
 for i=1,10 do o.lines[i]=track(make('Frame',{AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=C.purple,BorderSizePixel=0,Visible=false},gui)) end
 overlays[m]=o;return o
end
local bones={{'Head','UpperTorso'},{'UpperTorso','LowerTorso'},{'UpperTorso','LeftUpperArm'},{'LeftUpperArm','LeftLowerArm'},{'UpperTorso','RightUpperArm'},{'RightUpperArm','RightLowerArm'},{'LowerTorso','LeftUpperLeg'},{'LeftUpperLeg','LeftLowerLeg'},{'LowerTorso','RightUpperLeg'},{'RightUpperLeg','RightLowerLeg'}}
local function line(f,a,b)
 local d=b-a;f.Visible=true;f.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2);f.Size=UDim2.fromOffset(d.Magnitude,2);f.Rotation=math.deg(math.atan2(d.Y,d.X))
end
local conn
conn=Run.RenderStepped:Connect(function()
 if not gui.Parent then conn:Disconnect();return end
 local cam=workspace.CurrentCamera;if not cam then return end
 local center=cam.ViewportSize/2
 circle.Visible=cfg.circle;circle.Position=UDim2.fromOffset(center.X,center.Y);circle.Size=UDim2.fromOffset(cfg.fov*2,cfg.fov*2)
 local folder=workspace:FindFirstChild('TrainingTargets');local alive={}
 if folder then
  for _,m in ipairs(folder:GetChildren()) do
   local hum=m:IsA('Model') and m:FindFirstChildOfClass('Humanoid');local root=m:FindFirstChild('HumanoidRootPart')
   if hum and root and hum.Health>0 then
    alive[m]=true;local o=overlays[m] or createOverlay(m)
    local p,visible=cam:WorldToViewportPoint(root.Position)
    local points={}
    if visible and p.Z>0 then
     for _,part in ipairs(m:GetDescendants()) do
      if part:IsA('BasePart') then
       local sp=cam:WorldToViewportPoint(part.Position)
       if sp.Z>0 then local half=part.Size.Magnitude*.45;local size=half*cam.ViewportSize.Y/(math.max(sp.Z,.1)*1.4)
        table.insert(points,{x=sp.X-size,y=sp.Y-size});table.insert(points,{x=sp.X+size,y=sp.Y+size})
       end
      end
     end
    end
    local x1,y1,x2,y2=math.huge,math.huge,-math.huge,-math.huge
    for _,q in ipairs(points) do x1=math.min(x1,q.x);y1=math.min(y1,q.y);x2=math.max(x2,q.x);y2=math.max(y2,q.y) end
    local ok=#points>0 and x2>x1 and y2>y1
    o.box.Visible=cfg.box and ok;o.label.Visible=(cfg.name or cfg.distance) and ok;o.hpBg.Visible=cfg.health and ok
    if ok then
     o.box.Position=UDim2.fromOffset(x1,y1);o.box.Size=UDim2.fromOffset(x2-x1,y2-y1)
     local dist=math.floor((cam.CFrame.Position-root.Position).Magnitude)
     o.label.Text=(cfg.name and m.Name or '')..(cfg.distance and ('  ['..dist..' studs]') or '')
     o.label.Position=UDim2.fromOffset(x1,y1-22);o.label.Size=UDim2.fromOffset(math.max(90,x2-x1),20)
     o.hpBg.Position=UDim2.fromOffset(x1-9,y1);o.hpBg.Size=UDim2.fromOffset(5,y2-y1)
     o.hpFill.Size=UDim2.fromScale(1,math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1));o.hpFill.Position=UDim2.fromScale(0,1-o.hpFill.Size.Y.Scale)
    end
    for i,pair in ipairs(bones) do
     local a=m:FindFirstChild(pair[1]);local b=m:FindFirstChild(pair[2]);local f=o.lines[i];f.Visible=false
     if cfg.skeleton and visible and a and b then
      local ap,av=cam:WorldToViewportPoint(a.Position);local bp,bv=cam:WorldToViewportPoint(b.Position)
      if av and bv and ap.Z>0 and bp.Z>0 then line(f,Vector2.new(ap.X,ap.Y),Vector2.new(bp.X,bp.Y)) end
     end
    end
   end
  end
 end
 for m in pairs(overlays) do if not alive[m] then destroyOverlay(m) end end
end)
print('BID AIM HUB V3 MOBILE loaded | TrainingTargets only')
