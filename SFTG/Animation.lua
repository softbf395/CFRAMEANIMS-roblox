local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local playerCamera = workspace.CurrentCamera

-- Function to download music from URL and save it to a file
function saveMusicFromUrl(url, fileName)
    local success, response = pcall(function()
        -- Download the MP3 file as binary data
        return HttpService:GetAsync(url)
    end)

    if success then
        -- Write the binary data to a file
        writefile("music/SFTG/"..fileName, response)
        print("Music saved successfully to " .. fileName)
    else
        warn("Failed to download music: " .. response)
    end
end

-- Function to download and display the image in the sky
function displayImageInSky(url, fileName)
    local success, response = pcall(function()
        -- Download the PNG file as binary data
        return HttpService:GetAsync(url)
    end)

    if success then
        -- Save the image to a file
        writefile(fileName, response)
        print("Image saved successfully to " .. fileName)

        -- Create a new part to display the image in the sky
        local imagePart = Instance.new("Part")
        imagePart.Size = Vector3.new(100, 100, 1)  -- Set size of the image part
        imagePart.Position = playerCamera.CFrame.Position + Vector3.new(0, 50, -100)  -- Set initial position in front of the camera
        imagePart.Anchored = true
        imagePart.CanCollide = false
        imagePart.Parent = workspace

        -- Create a Decal to apply the image to the part
        local decal = Instance.new("Decal")
        decal.Texture = "rbxasset://textures/ui/FITHsun.png"  -- Texture from the saved PNG file
        decal.Parent = imagePart

        -- Update the part to always face the camera
        game:GetService("RunService").RenderStepped:Connect(function()
            imagePart.CFrame = CFrame.lookAt(imagePart.Position, playerCamera.CFrame.Position)
        end)
    else
        warn("Failed to download image: " .. response)
    end
end

-- Play the music as soon as the animation starts
function playMusic(fileName)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://" .. "music/SFTG/"..fileName  -- Use the local file you just saved
    sound.Looped = true  -- Set music to loop if desired
    sound.Parent = player.Character or player.CharacterAdded:Wait()  -- Attach sound to the character
    sound:Play()  -- Start playing the music
    print("Music is now playing...")
end

-- Save and play the music from GitHub
local musicUrl = "https://raw.githubusercontent.com/softbf395/CFRAMEANIMS-roblox/SFTG/music.mp3"
local musicFileName = "music.mp3"
saveMusicFromUrl(musicUrl, musicFileName)

-- Display the image in the sky, always in camera view
local imageUrl = "https://raw.githubusercontent.com/softbf395/CFRAMEANIMS-roblox/SFTG/FITHsun.png"
local imageFileName = "FITHsun.png"
--displayImageInSky(imageUrl, imageFileName)

-- Start the music once everything is set up
playMusic(musicFileName)
local playerchr = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local isR6
if playerchr:FindFirstChild("Torso") then
    isR6 = true
else
    isR6 = false
end

-- Original position and rotation for each body part (these will stay the same)
local lArmOG
local rArmOG
local headOG
local lLegOG
local rLegOG
local rootOG

-- Function to store original positions and rotations of character's body parts
function getOGposandAnchorParts()
    local root = playerchr:FindFirstChild("HumanoidRootPart")
    local lArm = isR6 and playerchr.LeftArm or playerchr.LeftUpperArm
    local rArm = isR6 and playerchr.RightArm or playerchr.RightUpperArm
    local head = playerchr:FindFirstChild("Head")
    local lLeg = isR6 and playerchr.LeftLeg or playerchr.LeftUpperLeg
    local rLeg = isR6 and playerchr.RightLeg or playerchr.RightUpperLeg

    -- Store position and rotation of each part (these will stay constant)
    rootOG = {Position = root.Position, Rotation = root.CFrame.Rotation}
    lArmOG = {Position = lArm.Position, Rotation = lArm.CFrame.Rotation}
    rArmOG = {Position = rArm.Position, Rotation = rArm.CFrame.Rotation}
    headOG = {Position = head.Position, Rotation = head.CFrame.Rotation}
    lLegOG = {Position = lLeg.Position, Rotation = lLeg.CFrame.Rotation}
    rLegOG = {Position = rLeg.Position, Rotation = rLeg.CFrame.Rotation}
end

-- Call the function to store initial positions and rotations
getOGposandAnchorParts()

-- Function to move a body part with position and rotation offsets (but keep original position constant)
function moveBodyPart(partName, posOffset, rotOffset)
    partName = string.lower(partName) -- Convert to lowercase for consistency
    local part, originalPos, originalRot

    -- Determine which part to move and retrieve its original position and rotation
    if partName == "b" then
        part = playerchr:FindFirstChild("HumanoidRootPart")
        originalPos = rootOG.Position
        originalRot = rootOG.Rotation
    elseif partName == "la" then
        part = isR6 and playerchr.LeftArm or playerchr.LeftUpperArm
        originalPos = lArmOG.Position
        originalRot = lArmOG.Rotation
    elseif partName == "ra" then
        part = isR6 and playerchr.RightArm or playerchr.RightUpperArm
        originalPos = rArmOG.Position
        originalRot = rArmOG.Rotation
    elseif partName == "ll" then
        part = isR6 and playerchr.LeftLeg or playerchr.LeftUpperLeg
        originalPos = lLegOG.Position
        originalRot = lLegOG.Rotation
    elseif partName == "rl" then
        part = isR6 and playerchr.RightLeg or playerchr.RightUpperLeg
        originalPos = rLegOG.Position
        originalRot = rLegOG.Rotation
    elseif partName == "h" then
        part = playerchr:FindFirstChild("Head")
        originalPos = headOG.Position
        originalRot = headOG.Rotation
    else
        warn("Invalid part name: " .. partName)
        return
    end

    -- Apply position and rotation offsets while keeping original position constant
    if part then
        -- Calculate new CFrame with position and rotation offsets, original position remains fixed
        part.CFrame = CFrame.new(originalPos + posOffset) * CFrame.Angles(rotOffset.X, rotOffset.Y, rotOffset.Z)
    else
        warn("Failed to find part for: " .. partName)
    end
end
moveBodyPart("h", Vector3.new(0, -0.1, 0), Vector3.new(-5, 0, 0))
moveBodyPart("la", Vector3.new(0, -1, 0), Vector3.new(0, 0, 0))
moveBodyPart("ra", Vector3.new(0, -1, 0), Vector3.new(0, 0, 0))
wait(3)
moveBodyPart("h", Vector3.new(0, 0.1, 0), Vector3.new(2.5, 0, 0))
moveBodyPart("la", Vector3.new(-1, 1, 0), Vector3.new(0, 0, 0))
moveBodyPart("ra", Vector3.new(1, 1, 0), Vector3.new(0, 0, 0))
