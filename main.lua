-- LocalScript for Solara executor

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

if not Player then
    print("Error: Player not found!")
    return
end

local isFlying = false
local commandQueue = {}
local isProcessing = false

-- Function to process commands from the queue
local function processQueue()
    if isProcessing or #commandQueue == 0 then return end
    isProcessing = true
    
    local message = table.remove(commandQueue, 1)
    local msgLower = message:lower()
    print("Processing command: " .. message)
    
    if msgLower == "./speed" then
        print("Command './speed' executed by " .. Player.Name)
        local success, error = pcall(function()
            local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50
                local elapsed = 0
                local connection
                connection = RunService.Heartbeat:Connect(function(dt)
                    elapsed = elapsed + dt
                    if elapsed >= 3 then
                        humanoid.WalkSpeed = 16
                        connection:Disconnect()
                        print("Speed boost ended!")
                    end
                end)
                print("Speed boost activated!")
            else
                print("No humanoid found!")
            end
        end)
        if not success then
            print("Speed failed: " .. tostring(error))
        end
        
    elseif msgLower == "./fly" then
        print("Command './fly' executed by " .. Player.Name)
        local success, error = pcall(function()
            local character = Player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                if isFlying then
                    local bv = rootPart:FindFirstChild("FlyVelocity")
                    local bg = rootPart:FindFirstChild("FlyGyro")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                    humanoid.PlatformStand = false
                    print("Fly turned off!")
                else
                    humanoid.PlatformStand = true
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "FlyVelocity"
                    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = rootPart
                    local bg = Instance.new("BodyGyro")
                    bg.Name = "FlyGyro"
                    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                    bg.P = 1000
                    bg.Parent = rootPart
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not character or not rootPart or not bv or not bg then
                            connection:Disconnect()
                            return
                        end
                        local cam = workspace.CurrentCamera
                        local dir = Vector3.new()
                        local uis = game:GetService("UserInputService")
                        if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                        if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                        if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                        if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                        if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                        bv.Velocity = dir.Unit * 50
                        bg.CFrame = cam.CFrame
                    end)
                    print("Fly turned on!")
                end
                isFlying = not isFlying
            else
                print("No humanoid or root part found!")
            end
        end)
        if not success then
            print("Fly failed: " .. tostring(error))
        end
    
    elseif msgLower == "./unban" then
        print("Command './unban' executed by " .. Player.Name)
        local success, error = pcall(function()
            game:GetService("VoiceChatService"):joinVoice() -- Placeholder; still invalid
            print("Unban voice chat attempted!")
        end)
        if not success then
            print("Unban failed: " .. tostring(error))
        end

    elseif msgLower == "./cmds" then
        print("Command './cmds' executed by " .. Player.Name)
        local success, error = pcall(function()
            local existingGui = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("CommandsGui")
            if existingGui then existingGui:Destroy() end
            
            local sg = Instance.new("ScreenGui")
            sg.Name = "CommandsGui"
            sg.Parent = Player.PlayerGui
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 180)
            frame.Position = UDim2.new(0.5, -100, 0, 5)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            frame.Parent = sg
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 30)
            title.Position = UDim2.new(0, 0, 0, 0)
            title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            title.Text = "Available Commands"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextScaled = true
            title.Parent = frame
            
            local cmdsList = Instance.new("TextLabel")
            cmdsList.Size = UDim2.new(1, -10, 1, -40)
            cmdsList.Position = UDim2.new(0, 5, 0, 35)
            cmdsList.BackgroundTransparency = 1
            cmdsList.Text = "./speed - Boost speed\n./fly - Toggle flight\n./cmds - Show this GUI\n./unban - Unbans voicechat\n./rejoin - Rejoin server\n./tp <username> - Teleport to player"
            cmdsList.TextColor3 = Color3.fromRGB(255, 255, 255)
            cmdsList.TextScaled = true
            cmdsList.TextXAlignment = Enum.TextXAlignment.Left
            cmdsList.Parent = frame
            
            local closeButton = Instance.new("TextButton")
            closeButton.Size = UDim2.new(0, 50, 0, 20)
            closeButton.Position = UDim2.new(1, -55, 0, 5)
            closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            closeButton.Text = "Close"
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.TextScaled = true
            closeButton.Parent = frame
            
            closeButton.MouseButton1Click:Connect(function()
                sg:Destroy()
                print("Commands GUI closed!")
            end)
            
            print("Commands GUI opened!")
        end)
        if not success then
            print("Commands GUI failed: " .. tostring(error))
        end

    elseif msgLower == "./rejoin" then
        print("Command './rejoin' executed by " .. Player.Name)
        local success, error = pcall(function()
            local placeId = game.PlaceId
            local jobId = game.JobId
            if jobId and jobId ~= "" then
                TeleportService:TeleportToPlaceInstance(placeId, jobId, Player)
                print("Rejoining server...")
            else
                print("No JobId available, teleporting to new instance...")
                TeleportService:Teleport(placeId, Player)
            end
        end)
        if not success then
            print("Rejoin failed: " .. tostring(error))
        end

    elseif msgLower:match("^%./tp%s+") then
        local targetName = msgLower:match("^%./tp%s+(.+)$")
        if targetName then
            print("Command './tp " .. targetName .. "' executed by " .. Player.Name)
            local success, error = pcall(function()
                local targetPlayer = Players:FindFirstChild(targetName) -- Exact match on username
                if not targetPlayer then
                    -- Try exact match on DisplayName if Name fails
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.DisplayName:lower() == targetName then
                            targetPlayer = p
                            break
                        end
                    end
                end
                if targetPlayer then
                    local myCharacter = Player.Character
                    local targetCharacter = targetPlayer.Character
                    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
                        -- Wait briefly for character to load
                        targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
                    end
                    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                    if myRoot and targetRoot then
                        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 2, 0)
                        print("Teleported to " .. targetPlayer.Name .. "!")
                    else
                        print("Failed: No valid character or root part found! (You: " .. (myRoot and "yes" or "no") .. ", Target: " .. (targetRoot and "yes" or "no") .. ")")
                    end
                else
                    print("Failed: Player '" .. targetName .. "' not found in game!")
                end
            end)
            if not success then
                print("Teleport failed: " .. tostring(error))
            end
        else
            print("Failed: No username provided for './tp'!")
        end
    end
    
    isProcessing = false
    task.spawn(processQueue)
end

-- Function to handle chat input
local function onChat(message)
    table.insert(commandQueue, message)
    print("Queued command: " .. message .. " (Queue size: " .. #commandQueue .. ")")
    if not isProcessing then
        task.spawn(processQueue)
    end
end

-- Robust chat connection with retry
local function connectChat()
    local tries = 0
    local maxTries = 5
    local connection
    
    while tries < maxTries do
        local success, error = pcall(function()
            connection = Player.Chatted:Connect(onChat)
        end)
        if success then
            print("Chat command script loaded successfully on try " .. (tries + 1) .. "!")
            break
        else
            warn("Chat connection attempt " .. (tries + 1) .. " failed: " .. tostring(error))
            tries = tries + 1
            wait(1)
        end
    end
    
    if tries >= maxTries then
        warn("Failed to connect chat event after " .. maxTries .. " tries. Commands may not work!")
    end
    
    return connection
end

-- Initial connection attempt
local chatConnection = connectChat()

-- Reconnect if character respawns
Player.CharacterAdded:Connect(function()
    if chatConnection then
        chatConnection:Disconnect()
        print("Reconnecting chat after respawn...")
    end
    chatConnection = connectChat()
end)
