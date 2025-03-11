local a=game:GetService"Players"
local b=a.LocalPlayer
local c=game:GetService"TeleportService"
local d=game:GetService"RunService"

if not b then
print"Error: Player not found!"
return
end

local e=false
local f={}
local g=false


local function processQueue()
if g or#f==0 then return end
g=true

local h=table.remove(f,1)
local i=h:lower()
print("Processing command: "..h)

if i=="./speed"then
print("Command './speed' executed by "..b.Name)
local j,k=pcall(function()
local j=b.Character and b.Character:FindFirstChild"Humanoid"
if j then
j.WalkSpeed=50
local k=0
local l
l=d.Heartbeat:Connect(function(m)
k=k+m
if k>=3 then
j.WalkSpeed=16
l:Disconnect()
print"Speed boost ended!"
end
end)
print"Speed boost activated!"
else
print"No humanoid found!"
end
end)
if not j then
print("Speed failed: "..tostring(k))
end

elseif i=="./fly"then
print("Command './fly' executed by "..b.Name)
local j,k=pcall(function()
local j=b.Character
local k=j and j:FindFirstChild"Humanoid"
local l=j and j:FindFirstChild"HumanoidRootPart"
if k and l then
if e then
local m=l:FindFirstChild"FlyVelocity"
local n=l:FindFirstChild"FlyGyro"
if m then m:Destroy()end
if n then n:Destroy()end
k.PlatformStand=false
print"Fly turned off!"
else
k.PlatformStand=true
local m=Instance.new"BodyVelocity"
m.Name="FlyVelocity"
m.MaxForce=Vector3.new(1e5,1e5,1e5)
m.Velocity=Vector3.new(0,0,0)
m.Parent=l
local n=Instance.new"BodyGyro"
n.Name="FlyGyro"
n.MaxTorque=Vector3.new(1e5,1e5,1e5)
n.P=1000
n.Parent=l
local o
o=d.RenderStepped:Connect(function()
if not j or not l or not m or not n then
o:Disconnect()
return
end
local p=workspace.CurrentCamera
local q=Vector3.new()
local r=game:GetService"UserInputService"
if r:IsKeyDown(Enum.KeyCode.W)then q=q+p.CFrame.LookVector end
if r:IsKeyDown(Enum.KeyCode.S)then q=q-p.CFrame.LookVector end
if r:IsKeyDown(Enum.KeyCode.A)then q=q-p.CFrame.RightVector end
if r:IsKeyDown(Enum.KeyCode.D)then q=q+p.CFrame.RightVector end
if r:IsKeyDown(Enum.KeyCode.Space)then q=q+Vector3.new(0,1,0)end
if r:IsKeyDown(Enum.KeyCode.LeftShift)then q=q-Vector3.new(0,1,0)end
m.Velocity=q.Unit*50
n.CFrame=p.CFrame
end)
print"Fly turned on!"
end
e=not e
else
print"No humanoid or root part found!"
end
end)
if not j then
print("Fly failed: "..tostring(k))
end

elseif i=="./unban"then
print("Command './unban' executed by "..b.Name)
local j,k=pcall(function()
game:GetService"VoiceChatService":joinVoice()
print"Unban voice chat attempted!"
end)
if not j then
print("Unban failed: "..tostring(k))
end

elseif i=="./cmds"then
print("Command './cmds' executed by "..b.Name)
local j,k=pcall(function()
local j=b:FindFirstChild"PlayerGui"and b.PlayerGui:FindFirstChild"CommandsGui"
if j then j:Destroy()end

local k=Instance.new"ScreenGui"
k.Name="CommandsGui"
k.Parent=b.PlayerGui

local l=Instance.new"Frame"
l.Size=UDim2.new(0,200,0,180)
l.Position=UDim2.new(0.5,-100,0,5)
l.BackgroundColor3=Color3.fromRGB(50,50,50)
l.Parent=k

local m=Instance.new"TextLabel"
m.Size=UDim2.new(1,0,0,30)
m.Position=UDim2.new(0,0,0,0)
m.BackgroundColor3=Color3.fromRGB(30,30,30)
m.Text="Available Commands"
m.TextColor3=Color3.fromRGB(255,255,255)
m.TextScaled=true
m.Parent=l

local n=Instance.new"TextLabel"
n.Size=UDim2.new(1,-10,1,-40)
n.Position=UDim2.new(0,5,0,35)
n.BackgroundTransparency=1
n.Text="./speed - Boost speed\n./fly - Toggle flight\n./cmds - Show this GUI\n./unban - Unbans voicechat\n./rejoin - Rejoin server\n./tp <username> - Teleport to player"
n.TextColor3=Color3.fromRGB(255,255,255)
n.TextScaled=true
n.TextXAlignment=Enum.TextXAlignment.Left
n.Parent=l

local o=Instance.new"TextButton"
o.Size=UDim2.new(0,50,0,20)
o.Position=UDim2.new(1,-55,0,5)
o.BackgroundColor3=Color3.fromRGB(255,0,0)
o.Text="Close"
o.TextColor3=Color3.fromRGB(255,255,255)
o.TextScaled=true
o.Parent=l

o.MouseButton1Click:Connect(function()
k:Destroy()
print"Commands GUI closed!"
end)

print"Commands GUI opened!"
end)
if not j then
print("Commands GUI failed: "..tostring(k))
end

elseif i=="./rejoin"then
print("Command './rejoin' executed by "..b.Name)
local j,k=pcall(function()
local j=game.PlaceId
local k=game.JobId
if k and k~=""then
c:TeleportToPlaceInstance(j,k,b)
print"Rejoining server..."
else
print"No JobId available, teleporting to new instance..."
c:Teleport(j,b)
end
end)
if not j then
print("Rejoin failed: "..tostring(k))
end

elseif i:match"^%./tp%s+"then
local j=i:match"^%./tp%s+(.+)$"
if j then
print("Command './tp "..j.."' executed by "..b.Name)
local k,l=pcall(function()
local k=a:FindFirstChild(j)
if not k then

for l,m in pairs(a:GetPlayers())do
if m.DisplayName:lower()==j then
k=m
break
end
end
end
if k then
local l=b.Character
local m=k.Character
if not m or not m:FindFirstChild"HumanoidRootPart"then

m=k.Character or k.CharacterAdded:Wait()
end
local n=l and l:FindFirstChild"HumanoidRootPart"
local o=m and m:FindFirstChild"HumanoidRootPart"
if n and o then
n.CFrame=o.CFrame+Vector3.new(0,2,0)
print("Teleported to "..k.Name.."!")
else
print("Failed: No valid character or root part found! (You: "..(n and"yes"or"no")..", Target: "..(o and"yes"or"no")..")")
end
else
print("Failed: Player '"..j.."' not found in game!")
end
end)
if not k then
print("Teleport failed: "..tostring(l))
end
else
print"Failed: No username provided for './tp'!"
end
end

g=false
task.spawn(processQueue)
end


local function onChat(h)
table.insert(f,h)
print("Queued command: "..h.." (Queue size: "..#f..")")
if not g then
task.spawn(processQueue)
end
end


local function connectChat()
local h=0
local i=5
local j

while h<i do
local k,l=pcall(function()
j=b.Chatted:Connect(onChat)
end)
if k then
print("Chat command script loaded successfully on try "..(h+1).."!")
break
else
warn("Chat connection attempt "..(h+1).." failed: "..tostring(l))
h=h+1
wait(1)
end
end

if h>=i then
warn("Failed to connect chat event after "..i.." tries. Commands may not work!")
end

return j
end


local h=connectChat()


b.CharacterAdded:Connect(function()
if h then
h:Disconnect()
print"Reconnecting chat after respawn..."
end
h=connectChat()
end)
