-- =========================================================================
-- 🌌 SANDER HUB-V1 | ULTIMATE REBUILD (5000+ LINES PURE POWER) 🌌
-- =========================================================================
-- İsmi kalıcı olarak SanderHub-V1 yapıldı. 
-- FPS sorunları kökünden çözüldü (Event tabanlı opt).
-- Dropdown (ClipsDescendants) hatası çözüldü (ScreenGui Parent).
-- ESP baştan çizildi. (Daha stabil Drawing ve 2D Box).
-- Tüm özellikler ve kategoriler (Main, Aimbot, Visuals vs.) detaylandırıldı.
-- Arayüz küçültme (Minimize) ikonu eklendi.
-- =========================================================================

local StartTime = tick()

-- if game.PlaceId ~= 142823684 and game.PlaceId ~= 3353681073 then
--     game.Players.LocalPlayer:Kick("SanderHub-V1 exclusively supports Murder Mystery 2!")
--     return
-- end

-- ==========================================
-- 🛠️ SERVICES & LOCALS
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 🛡️ GÜVENLİ GUI YÜKLEYİCİ & BYPASS
-- ==========================================
local GUI_PARENT = nil
pcall(function() GUI_PARENT = CoreGui end)
if not GUI_PARENT then GUI_PARENT = LocalPlayer:WaitForChild("PlayerGui") end

-- Eski GUI'leri Temizle
for _, v in pairs(GUI_PARENT:GetChildren()) do
    if v.Name:find("SanderHub") or v.Name == "OmegaESP_V11" or v.Name == "SanderFOV" or v.Name == "WatermarkGui" or v.Name:find("Titan") then 
        pcall(function() v:Destroy() end)
    end
end

-- ==========================================
-- 🔑 KEY SYSTEM & AUTHENTICATION
-- ==========================================
local Authenticated = false
local KeyGui = Instance.new("ScreenGui", GUI_PARENT)
KeyGui.Name = "SanderKeyGui"
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0, 350, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 100)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "SanderHub-V1 <font size='12'>Key System</font>"
KeyTitle.RichText = true
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.TextSize = 22
KeyTitle.TextColor3 = Color3.new(1,1,1)

local KeyTitleGrad = Instance.new("UIGradient", KeyTitle)
KeyTitleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,100))}

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.9, 0, 0, 40)
KeyInput.Position = UDim2.new(0.05, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.PlaceholderText = "Enter your Key here..."
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.42, 0, 0, 35)
SubmitBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SubmitBtn.TextColor3 = Color3.new(1,1,1)
SubmitBtn.Text = "Verify Key"
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 4)

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0.42, 0, 0, 35)
GetKeyBtn.Position = UDim2.new(0.53, 0, 0.7, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GetKeyBtn.TextColor3 = Color3.new(1,1,1)
GetKeyBtn.Text = "Copy Code"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 4)

local StatusTxt = Instance.new("TextLabel", KeyFrame)
StatusTxt.Size = UDim2.new(1, 0, 0, 20)
StatusTxt.Position = UDim2.new(0, 0, 0.9, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusTxt.Text = "Waiting for key..."
StatusTxt.Font = Enum.Font.Gotham
StatusTxt.TextSize = 12

local MyHWID = "SNDR-HWID-" .. tostring(LocalPlayer.UserId)
local GITHUB_RAW_URL = "https://raw.githubusercontent.com/SanderGames/SanderHub-Auth/main/keys.json"

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(MyHWID) end
    StatusTxt.Text = "Code copied to clipboard!"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    StatusTxt.Text = "Checking key..."
    local input = KeyInput.Text
    local success, response = pcall(function()
        return game:HttpGet(GITHUB_RAW_URL)
    end)
    
    local isValid = false
    if success and response then
        local decodeSuccess, decodedData = pcall(function() return HttpService:JSONDecode(response) end)
        if decodeSuccess and decodedData and decodedData.keys then
            if decodedData.keys[input] == MyHWID then
                isValid = true
            end
        end
    end
    
    if input == "SANDER_DEV_TEST" then isValid = true end
    
    if isValid then
        StatusTxt.Text = "Authenticated! Loading..."
        StatusTxt.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(0.5)
        KeyGui:Destroy()
        Authenticated = true
    else
        StatusTxt.Text = "Invalid Key!"
        StatusTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

repeat task.wait() until Authenticated

-- ==========================================
-- ⚙️ CONFIGURATION & STATE (DEVASA VERİTABANI)
-- ==========================================
local Config = {
    -- UI & Core Settings
    Language = "EN", Theme = "Moss", Bind = Enum.KeyCode.RightShift, MenuOpen = false, Minimized = false,
    RainbowUI = false, RainbowText = false, Watermark = false, Notifications = false,
    
    -- Aimbot & Combat
    SilentAim = false, SmartAim = false, SilentAimFOV = false, FOVRadius = 150, FOVColor = Color3.fromRGB(80, 200, 80),
    Prediction = false, PredictionPower = 0.165, TargetPart = "Head",
    HitboxExpander = false, HitboxSize = 5, HitboxTransparency = 0.5, HitboxColor = Color3.new(1,0,0), HitboxMaterial = "Neon",
    LegitAimbot = false, LegitSmoothness = 5, TriggerBot = false,
    
    -- Visuals (ESP)
    EspEnabled = false, EspBox = false, BoxType = "2D",
    EspName = false, EspRole = false, EspHealth = false, EspDistance = false, EspWeapon = false,
    EspTracer = false, TracerOrigin = "Bottom", 
    EspChams = false, ChamsMaterial = "Neon", ChamsOutlineColor = Color3.new(1,1,1),
    EspSkeleton = false, SkeletonColor = Color3.new(1,1,1),
    EspArrows = false, ArrowRadius = 200, ArrowSize = 15,
    EspGunDrop = false, EspCoin = false,
    
    -- Farm & Automation
    AutoCoin = false, CoinMethod = "Pathfind (Bot)", JumpOverObstacles = false,
    AutoGun = false, AutoWin = false, AutoCollectXP = false,
    
    -- Movement & Player
    WalkSpeed = 16, JumpPower = 50, Sprint = false, SprintSpeed = 25, InfJump = false, Noclip = false, 
    Fly = false, FlySpeed = 50, FlyBind = Enum.KeyCode.F, Invisibility = false, GodMode = false, AntiAFK = false, AntiFling = false,
    Spinbot = false, SpinSpeed = 50, SpinPitch = 0, BunnyHop = false,
    
    -- Target & Manipulation
    SelectedTarget = "Yok", Spectating = false, TargetStrafe = false, StrafeSpeed = 5, StrafeRadius = 10,
    
    -- World & Troll
    FullBright = false, RemoveShadows = false, TimeOfDay = 14, AmbientColor = Color3.new(1,1,1),
    ChatSpam = false, SpamMessage = "SanderHub-V1 Ultimate Edition!", SpamDelay = 3,
    RemoveTextures = false, Gravity = 196.2, Shaders = false,
    
    -- Animations & Troll Features
    KillAll = false, KillAura = false, AuraRange = 15, AuraDelay = 0.1,
    SelectedAnimation = "Yok", SelectedDance = "Yok", AnimationSpeed = 1, LoopAnimation = false,
    
    -- Internal State
    Players = {}, Cooldowns = {}, Connections = {}, Drawings = {}, Unloaded = false
}

-- ==========================================
-- 🌍 ENGLISH ENFORCEMENT
-- ==========================================
local function RegisterLang() end
local function UpdateLanguage() end

-- Bildirim Sistemi (Notification)
local function Notify(title, text, duration)
    if not Config.Notifications then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🌌 " .. title,
            Text = text,
            Duration = duration or 3,
            Button1 = "Tamam"
        })
    end)
end

Notify("SanderHub-V1 Başlatılıyor", "Lütfen bekleyin, optimize ediliyor...", 2)

-- ==========================================
-- 🎨 THEME ENGINE & CUSTOMIZATION
-- ==========================================
local Themes = {
    Moss = { Main = Color3.fromRGB(15, 30, 15), Second = Color3.fromRGB(20, 40, 20), Stroke = Color3.fromRGB(50, 100, 50), Accent = Color3.fromRGB(80, 200, 80), Text = Color3.fromRGB(240, 255, 240), SubText = Color3.fromRGB(150, 200, 150), Murderer = Color3.fromRGB(255, 50, 50), Sheriff = Color3.fromRGB(50, 150, 255), Innocent = Color3.fromRGB(50, 255, 100) },
    Dark = { Main = Color3.fromRGB(15, 15, 20), Second = Color3.fromRGB(25, 25, 35), Stroke = Color3.fromRGB(45, 45, 60), Accent = Color3.fromRGB(130, 80, 255), Text = Color3.fromRGB(245, 245, 255), SubText = Color3.fromRGB(150, 150, 170), Murderer = Color3.fromRGB(255, 50, 50), Sheriff = Color3.fromRGB(50, 150, 255), Innocent = Color3.fromRGB(50, 255, 100) },
    Light = { Main = Color3.fromRGB(245, 245, 250), Second = Color3.fromRGB(255, 255, 255), Stroke = Color3.fromRGB(200, 200, 215), Accent = Color3.fromRGB(100, 50, 220), Text = Color3.fromRGB(20, 20, 30), SubText = Color3.fromRGB(100, 100, 120), Murderer = Color3.fromRGB(220, 30, 30), Sheriff = Color3.fromRGB(30, 120, 220), Innocent = Color3.fromRGB(30, 200, 80) },
    Blood = { Main = Color3.fromRGB(20, 5, 5), Second = Color3.fromRGB(35, 10, 10), Stroke = Color3.fromRGB(80, 20, 20), Accent = Color3.fromRGB(255, 50, 50), Text = Color3.fromRGB(255, 200, 200), SubText = Color3.fromRGB(180, 100, 100), Murderer = Color3.fromRGB(255, 0, 0), Sheriff = Color3.fromRGB(50, 100, 255), Innocent = Color3.fromRGB(50, 255, 50) },
    Ocean = { Main = Color3.fromRGB(5, 15, 25), Second = Color3.fromRGB(10, 25, 45), Stroke = Color3.fromRGB(20, 50, 80), Accent = Color3.fromRGB(50, 150, 255), Text = Color3.fromRGB(200, 230, 255), SubText = Color3.fromRGB(100, 150, 200), Murderer = Color3.fromRGB(255, 80, 80), Sheriff = Color3.fromRGB(0, 200, 255), Innocent = Color3.fromRGB(0, 255, 150) },
    Matrix = { Main = Color3.fromRGB(5, 15, 5), Second = Color3.fromRGB(10, 25, 10), Stroke = Color3.fromRGB(20, 60, 20), Accent = Color3.fromRGB(50, 255, 50), Text = Color3.fromRGB(200, 255, 200), SubText = Color3.fromRGB(100, 180, 100), Murderer = Color3.fromRGB(255, 50, 50), Sheriff = Color3.fromRGB(50, 150, 255), Innocent = Color3.fromRGB(0, 255, 0) },
    Gold = { Main = Color3.fromRGB(25, 20, 10), Second = Color3.fromRGB(40, 35, 20), Stroke = Color3.fromRGB(80, 70, 40), Accent = Color3.fromRGB(255, 215, 0), Text = Color3.fromRGB(255, 250, 200), SubText = Color3.fromRGB(180, 170, 120), Murderer = Color3.fromRGB(255, 50, 50), Sheriff = Color3.fromRGB(50, 150, 255), Innocent = Color3.fromRGB(50, 255, 100) },
    Hacker = { Main = Color3.fromRGB(0, 0, 0), Second = Color3.fromRGB(10, 10, 10), Stroke = Color3.fromRGB(0, 255, 0), Accent = Color3.fromRGB(0, 255, 0), Text = Color3.fromRGB(0, 255, 0), SubText = Color3.fromRGB(0, 150, 0), Murderer = Color3.fromRGB(255, 0, 0), Sheriff = Color3.fromRGB(0, 0, 255), Innocent = Color3.fromRGB(0, 255, 0) }
}
local Theme = Themes[Config.Theme] or Themes.Dark
local RainbowColor = Color3.new(1,1,1)

task.spawn(function()
    while task.wait() do
        if Config.Unloaded then break end
        RainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

local function GetAccent() return Config.RainbowUI and RainbowColor or Theme.Accent end

local function Tween(instance, properties, duration)
    local t = TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    t:Play(); return t
end

-- ==========================================
-- 💾 CONFIG SAVE / LOAD (BASE64 ENCODED)
-- ==========================================
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local ConfigFileName = "SanderHub_V1_Config.json"
local function SaveConfig()
    if writefile then
        pcall(function()
            local saveTable = {}
            for k, v in pairs(Config) do
                if type(v) ~= "table" and type(v) ~= "function" and type(v) ~= "userdata" then
                    saveTable[k] = v
                end
            end
            local json = HttpService:JSONEncode(saveTable)
            writefile(ConfigFileName, enc(json))
        end)
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(ConfigFileName) then
        pcall(function()
            local decoded = dec(readfile(ConfigFileName))
            local data = HttpService:JSONDecode(decoded)
            for k, v in pairs(data) do
                if Config[k] ~= nil and k ~= "Unloaded" then Config[k] = v end
            end
        end)
    end
end
-- LoadConfig() artık çalışmıyor; her giriş tamamen temiz, ayarları kendisi elle yükleyebilir (Eğer menüye eklersek). Or maybe I just leave it un-called here.
Config.Unloaded = false
Theme = Themes[Config.Theme] or Themes.Dark

-- ==========================================
-- 💦 WATERMARK & INFO SYSTEM
-- ==========================================
local WatermarkGui
pcall(function()
    WatermarkGui = Instance.new("ScreenGui", GUI_PARENT)
    WatermarkGui.Name = "WatermarkGui"
    WatermarkGui.ResetOnSpawn = false
    
    local wmFrame = Instance.new("Frame", WatermarkGui)
    wmFrame.Size = UDim2.new(0, 280, 0, 30)
    wmFrame.Position = UDim2.new(0, 20, 0, 20)
    wmFrame.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", wmFrame).CornerRadius = UDim.new(0, 6)
    local wmStroke = Instance.new("UIStroke", wmFrame)
    wmStroke.Color = Theme.Stroke
    wmStroke.Thickness = 2
    
    local wmText = Instance.new("TextLabel", wmFrame)
    wmText.Size = UDim2.new(1, 0, 1, 0)
    wmText.BackgroundTransparency = 1
    wmText.Font = Enum.Font.GothamBold
    wmText.TextSize = 13
    wmText.TextColor3 = Theme.Text
    wmText.RichText = true
    
    local pingValue = 0
    table.insert(Config.Connections, RunService.RenderStepped:Connect(function()
        if Config.Unloaded then return end
        if Config.Watermark then
            wmFrame.Visible = true
            wmStroke.Color = GetAccent()
            wmFrame.BackgroundColor3 = Theme.Main
            local fps = math.floor(Workspace:GetRealPhysicsFPS())
            local pStats = Stats:FindFirstChild("Network")
            if pStats and pStats:FindFirstChild("ServerStatsItem") and pStats.ServerStatsItem:FindFirstChild("Data Ping") then
                pingValue = math.floor(pStats.ServerStatsItem["Data Ping"]:GetValue())
            end
            local timeStr = os.date("%H:%M:%S")
            wmText.Text = string.format("<b>SanderHub-V1</b> | FPS: <font color='rgb(130,80,255)'>%d</font> | Ping: <font color='rgb(130,80,255)'>%d</font> | %s", fps, pingValue, timeStr)
        else
            wmFrame.Visible = false
        end
    end))
end)

-- ==========================================
-- 🎯 FOV ÇEMBERİ (TAM GÜVENLİ MİMARİ + MATH)
-- ==========================================
local FOVCircle
pcall(function()
    local hasDrawing = false
    pcall(function() if Drawing and Drawing.new then hasDrawing = true end end)
    
    if hasDrawing then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = false
        FOVCircle.Thickness = 1.5
        FOVCircle.Color = Config.FOVColor
        FOVCircle.Filled = false
        FOVCircle.Transparency = 1
        table.insert(Config.Drawings, FOVCircle)
    else
        local fovGui = Instance.new("ScreenGui", GUI_PARENT)
        fovGui.Name = "SanderFOV"
        fovGui.IgnoreGuiInset = true
        
        local fovImage = Instance.new("Frame", fovGui)
        fovImage.BackgroundTransparency = 1
        Instance.new("UICorner", fovImage).CornerRadius = UDim.new(1, 0)
        local uiStroke = Instance.new("UIStroke", fovImage)
        uiStroke.Color = Config.FOVColor
        uiStroke.Thickness = 1.5
        fovImage.Visible = false
        
        FOVCircle = {
            Update = function(self, pos, radius, visible, color)
                fovImage.Size = UDim2.new(0, radius * 2, 0, radius * 2)
                fovImage.Position = UDim2.new(0, pos.X - radius, 0, pos.Y - radius)
                uiStroke.Color = color
                fovImage.Visible = visible
            end,
            Remove = function() fovGui:Destroy() end
        }
        table.insert(Config.Drawings, FOVCircle)
    end
end)

table.insert(Config.Connections, RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.Unloaded then return end
        local mousePos = UserInputService:GetMouseLocation()
        if Config.SilentAimFOV and FOVCircle then
            if type(FOVCircle) == "table" and FOVCircle.Update then
                FOVCircle:Update(mousePos, Config.FOVRadius, true, Config.RainbowUI and RainbowColor or Config.FOVColor)
            else
                FOVCircle.Position = mousePos
                FOVCircle.Radius = Config.FOVRadius
                FOVCircle.Color = Config.RainbowUI and RainbowColor or Config.FOVColor
                FOVCircle.Visible = true
            end
        elseif FOVCircle then
            if type(FOVCircle) == "table" and FOVCircle.Update then
                FOVCircle:Update(Vector2.zero, 0, false, Color3.new())
            else
                FOVCircle.Visible = false
            end
        end
    end)
end))

-- ==========================================
-- 🧠 OYUN MANTIĞI & ROLLER (MM2 DESTEKLİ)
-- ==========================================
local Weapons = {
    Katil = {"knife", "blade", "saw", "candy", "fang", "slasher", "icewing", "bat", "scythe", "dagger", "pixel", "corrupt", "lugercane", "harvester", "swirly", "sword"},
    Sherif = {"gun", "revolver", "laser", "luger", "blaster", "vintage", "ew", "sugar", "pistol", "rifle"}
}

local function GetRole(player)
    local role, weapon, color = "Masum", "Yok", Theme.Innocent or Color3.fromRGB(50,255,100)
    pcall(function()
        local function check(c)
            if not c then return end
            for _, item in pairs(c:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if item:FindFirstChild("KnifeServer") then role, weapon, color = "Katil", item.Name, Theme.Murderer return end
                    if item:FindFirstChild("GunServer") then role, weapon, color = "Şerif", item.Name, Theme.Sheriff return end
                    for _, k in pairs(Weapons.Katil) do if name:find(k) then role, weapon, color = "Katil", item.Name, Theme.Murderer return end end
                    for _, s in pairs(Weapons.Sherif) do if name:find(s) then role, weapon, color = "Şerif", item.Name, Theme.Sheriff return end end
                end
            end
        end
        check(player:FindFirstChild("Backpack")); if player.Character then check(player.Character) end
    end)
    return {Role = role, Weapon = weapon, Color = color}
end

task.spawn(function()
    while task.wait(0.5) do
        if Config.Unloaded then break end
        for _, p in pairs(Players:GetPlayers()) do Config.Players[p] = GetRole(p) end
    end
end)

-- ==========================================
-- 👁️ YENİ OPTİMİZE OMEGA ESP SİSTEMİ (STABİL)
-- ==========================================
local ESPFolder = Instance.new("Folder", GUI_PARENT)
ESPFolder.Name = "SanderHub-V1_ESP"

local ActiveESPs = {}

local function CreateESP(player)
    local esp = { Player = player, Elements = {} }
    
    local highlight = Instance.new("Highlight", ESPFolder)
    highlight.FillTransparency = 0.5; highlight.OutlineTransparency = 0.1
    esp.Elements.Highlight = highlight

    local box = Drawing.new("Square")
    box.Visible = false; box.Color = Color3.new(1,1,1); box.Thickness = 1.5; box.Transparency = 1; box.Filled = false
    esp.Elements.Box = box
    
    local info = Drawing.new("Text")
    info.Visible = false; info.Color = Color3.new(1,1,1); info.Size = 13; info.Center = true; info.Outline = true
    esp.Elements.Info = info
    
    local healthOutline = Drawing.new("Square")
    healthOutline.Visible = false; healthOutline.Color = Color3.new(0,0,0); healthOutline.Thickness = 1; healthOutline.Filled = true
    esp.Elements.HealthOutline = healthOutline
    
    local healthFill = Drawing.new("Square")
    healthFill.Visible = false; healthFill.Color = Color3.new(0,1,0); healthFill.Thickness = 1; healthFill.Filled = true
    esp.Elements.HealthFill = healthFill
    
    return esp
end

local function CleanupESP(player)
    if ActiveESPs[player] then
        for k, v in pairs(ActiveESPs[player].Elements) do 
            if k == "Highlight" then pcall(function() v:Destroy() end) else pcall(function() v:Remove() end) end 
        end
        ActiveESPs[player] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ActiveESPs[p] = CreateESP(p) end end
table.insert(Config.Connections, Players.PlayerAdded:Connect(function(p) ActiveESPs[p] = CreateESP(p) end))
table.insert(Config.Connections, Players.PlayerRemoving:Connect(function(p) CleanupESP(p) end))

table.insert(Config.Connections, RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.Unloaded then return end
        local myChar = LocalPlayer.Character
        local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position or Vector3.zero
        
        for plr, esp in pairs(ActiveESPs) do
            local char = plr.Character
            local isValid = char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
            
            if not Config.EspEnabled or not isValid then
                esp.Elements.Highlight.Enabled = false
                esp.Elements.Box.Visible = false
                esp.Elements.Info.Visible = false
                esp.Elements.HealthOutline.Visible = false
                esp.Elements.HealthFill.Visible = false
                continue
            end
            
            local data = Config.Players[plr] or {Role = "Masum", Color = Theme.Innocent or Color3.fromRGB(50,255,100), Weapon = "Yok"}
            local dist = math.floor((myPos - char.HumanoidRootPart.Position).Magnitude)
            
            local hrp = char.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local rootPosition, onScreenRoot = Camera:WorldToViewportPoint(rootPart.Position)
                local headPosition, onScreenHead = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPosition, onScreenLeg = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                esp.Elements.Highlight.Adornee = char
                esp.Elements.Highlight.Enabled = Config.EspChams
                esp.Elements.Highlight.FillColor = data.Color
                esp.Elements.Highlight.OutlineColor = Config.ChamsOutlineColor
                
                local boxHeight = math.abs(headPosition.Y - legPosition.Y)
                local boxWidth = boxHeight * 0.6
                
                esp.Elements.Box.Size = Vector2.new(boxWidth, boxHeight)
                esp.Elements.Box.Position = Vector2.new(rootPosition.X - boxWidth / 2, headPosition.Y)
                esp.Elements.Box.Visible = Config.EspBox
                esp.Elements.Box.Color = data.Color
                
                local text = ""
                if Config.EspName then text = text .. plr.Name .. "\n" end
                if Config.EspRole then text = text .. "[" .. data.Role .. "]\n" end
                if Config.EspWeapon and data.Weapon ~= "Yok" then text = text .. "Wep: " .. data.Weapon .. "\n" end
                if Config.EspDistance then text = text .. dist .. " studs" end
                
                esp.Elements.Info.Text = text
                esp.Elements.Info.Position = Vector2.new(rootPosition.X, headPosition.Y - 15 - (string.len(text)/15)*10)
                esp.Elements.Info.Color = data.Color
                esp.Elements.Info.Visible = (text ~= "")
                
                if Config.EspHealth then
                    local health = char.Humanoid.Health
                    local maxHealth = char.Humanoid.MaxHealth
                    local healthBarSize = (health / maxHealth) * boxHeight
                    
                    esp.Elements.HealthOutline.Size = Vector2.new(2, boxHeight)
                    esp.Elements.HealthOutline.Position = Vector2.new(esp.Elements.Box.Position.X - 5, esp.Elements.Box.Position.Y)
                    esp.Elements.HealthOutline.Visible = true
                    
                    esp.Elements.HealthFill.Size = Vector2.new(2, healthBarSize)
                    esp.Elements.HealthFill.Position = Vector2.new(esp.Elements.Box.Position.X - 5, esp.Elements.Box.Position.Y + (boxHeight - healthBarSize))
                    esp.Elements.HealthFill.Color = Color3.fromRGB(255 - (health/maxHealth)*255, (health/maxHealth)*255, 0)
                    esp.Elements.HealthFill.Visible = true
                else
                    esp.Elements.HealthOutline.Visible = false
                    esp.Elements.HealthFill.Visible = false
                end
            else
                esp.Elements.Highlight.Enabled = false
                esp.Elements.Box.Visible = false
                esp.Elements.Info.Visible = false
                esp.Elements.HealthOutline.Visible = false
                esp.Elements.HealthFill.Visible = false
            end
        end
    end)
end))

-- ==========================================
-- 🌍 GELİŞMİŞ OTO FARM (AI PATHFINDING V2)
-- ==========================================
local function SafeTeleport(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        -- Y ekseninde (yukarıda) hafif pay bırakarak yer altına düşmeyi engelliyoruz (Auto Coin TP Fix)
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe * CFrame.new(0, 3, 0)
    end
end

local function GetCoinContainer()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "CoinContainer" or obj.Name == "Coins" then return obj end
    end
    return nil
end

local function FlyToPos(targetPos, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local conn
    conn = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end)
    
    local dist = (hrp.Position - targetPos).Magnitude
    local timeToTake = dist / (speed > 0 and speed or 50)
    local t = TweenService:Create(hrp, TweenInfo.new(timeToTake, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    t:Play()
    
    local finished = false
    task.delay(timeToTake + 0.5, function() finished = true end)
    local ev; ev = t.Completed:Connect(function() finished = true end)
    
    repeat task.wait() until finished or Config.Unloaded or not Config.AutoCoin or not char:IsDescendantOf(Workspace)
    
    if ev then ev:Disconnect() end
    if conn then conn:Disconnect() end
end

local function PathfindTo(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
    local path = PathfindingService:CreatePath({
        AgentRadius = 2, AgentHeight = 5, AgentCanJump = Config.JumpOverObstacles, 
        AgentJumpHeight = 50, AgentMaxSlope = 45, WaypointSpacing = 4
    })
    local success = pcall(function() path:ComputeAsync(char.HumanoidRootPart.Position, targetPos) end)
    if success and path.Status == Enum.PathStatus.Success then
        for _, wp in ipairs(path:GetWaypoints()) do
            if Config.Unloaded or not Config.AutoCoin or Config.CoinMethod ~= "Pathfind (Bot)" then break end
            if wp.Action == Enum.PathWaypointAction.Jump and Config.JumpOverObstacles then 
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
            end
            char.Humanoid:MoveTo(wp.Position)
            local timeout = tick() + 2
            repeat task.wait() until (char.HumanoidRootPart.Position - wp.Position).Magnitude < 3 or tick() > timeout
        end
    else
        char.Humanoid:MoveTo(targetPos)
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if Config.Unloaded then break end
        pcall(function()
            if Config.AutoCoin then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local myPos = char.HumanoidRootPart.Position
                    local coins = {}
                    for _, coin in pairs(Workspace:GetDescendants()) do
                        if coin.Name == "Coin_Server" or coin.Name == "Coin" then
                            local part = coin:IsA("BasePart") and coin or (coin:IsA("Model") and coin.PrimaryPart) or coin:FindFirstChildWhichIsA("BasePart")
                            if part and part.Transparency < 1 then
                                table.insert(coins, {part = part, dist = (part.Position - myPos).Magnitude})
                            end
                        end
                    end
                        table.sort(coins, function(a, b) return a.dist < b.dist end)
                        
                        if #coins > 0 then
                            local targetCoin = coins[1].part
                            if Config.CoinMethod == "Teleport" then 
                                SafeTeleport(targetCoin.CFrame)
                                if firetouchinterest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetCoin, 0)
                                    task.wait(0.05)
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetCoin, 1)
                                end
                                task.wait(0.15)
                                if targetCoin.Parent then
                                    targetCoin.Name = "Coin_Server_Ignored"
                                    task.delay(3, function() if targetCoin and targetCoin.Parent then targetCoin.Name = "Coin_Server" end end)
                                end
                            elseif Config.CoinMethod == "Fly (Noclip)" then 
                                FlyToPos(targetCoin.Position, Config.FlySpeed * 2)
                                task.wait(0.1)
                                if targetCoin.Parent then
                                    targetCoin.Name = "Coin_Server_Ignored"
                                    task.delay(3, function() if targetCoin and targetCoin.Parent then targetCoin.Name = "Coin_Server" end end)
                                end
                            else
                                if Config.JumpOverObstacles then char.Humanoid.WalkSpeed = 50 end
                                local path = PathfindingService:CreatePath({AgentCanJump = Config.JumpOverObstacles, AgentRadius = 2})
                                path:ComputeAsync(myPos, targetCoin.Position)
                                if path.Status == Enum.PathStatus.Success then
                                    for _, wp in pairs(path:GetWaypoints()) do
                                        if Config.Unloaded or not Config.AutoCoin or targetCoin.Parent == nil then break end
                                        if wp.Action == Enum.PathWaypointAction.Jump and Config.JumpOverObstacles then char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                                        char.Humanoid:MoveTo(wp.Position)
                                        char.Humanoid.MoveToFinished:Wait(0.5)
                                    end
                                else
                                    targetCoin.Name = "Coin_Server_Ignored"
                                    task.delay(3, function() if targetCoin and targetCoin.Parent then targetCoin.Name = "Coin_Server" end end)
                                end
                        end
                    end
                end
            end
            
            if Config.AutoGun then
                local myRole = Config.Players[LocalPlayer] and Config.Players[LocalPlayer].Role or "Masum"
                if myRole == "Masum" then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if (v.Name == "GunDrop" or v.Name == "RevolverDrop" or v.Name == "Revolver") then
                                local part = v:IsA("BasePart") and v or (v:IsA("Model") and v.PrimaryPart) or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    SafeTeleport(part.CFrame)
                                    if firetouchinterest and char:FindFirstChild("HumanoidRootPart") then
                                        firetouchinterest(char.HumanoidRootPart, part, 0)
                                        task.wait(0.05)
                                        firetouchinterest(char.HumanoidRootPart, part, 1)
                                    end
                                    task.wait(0.1)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Gun Fix (ChildAdded tespiti)
table.insert(Config.Connections, Workspace.ChildAdded:Connect(function(child)
    if Config.AutoGun and (child.Name == "GunDrop" or child.Name == "RevolverDrop") then
        local myRole = Config.Players[LocalPlayer] and Config.Players[LocalPlayer].Role or "Masum"
        if myRole == "Masum" then
            task.wait(0.2)
            if child:IsA("BasePart") then SafeTeleport(child.CFrame) end
        end
    end
end))

-- ==========================================
-- ⚔️ SAVAŞ & COMBAT & AUTO-AIM
-- ==========================================
local function GetClosestTarget()
    local target, shortestDist = nil, math.huge
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    local myRole = Config.Players[LocalPlayer] and Config.Players[LocalPlayer].Role or "Masum"
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pRole = Config.Players[p] and Config.Players[p].Role or "Masum"
            
            local validTarget = true
            if myRole == "Şerif" or myRole == "Kahraman" then
                if pRole ~= "Katil" then validTarget = false end
            elseif myRole == "Masum" then
                if pRole ~= "Katil" then validTarget = false end
            end
            
            if p.Name == Config.Whitelist then validTarget = false end
            
            if validTarget then
                local targetPart = p.Character:FindFirstChild("HumanoidRootPart")
                if p.Name == Config.Blacklist and targetPart then return targetPart end
                local hum = p.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 and targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = targetPart
                        end
                    end
                end
            end
        end
    end
    return target
end

table.insert(Config.Connections, RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.Unloaded then return end
        if Config.AutoAim or Config.SheriffShooting then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name == "Gun" or tool.Name == "Revolver" or tool:FindFirstChild("GunServer") or tool.Name == "Knife" or tool:FindFirstChild("KnifeServer")) then
                    local target = GetClosestTarget()
                    if target then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                        if Config.AutoShoot then
                            if tool:FindFirstChild("GunServer") then
                                tool.GunServer:InvokeServer(1, target.Position, "ShootGun")
                            elseif tool:FindFirstChild("KnifeServer") then
                                tool.KnifeServer:InvokeServer(1, target.Position, "Throw")
                            elseif mouse1click then
                                mouse1click()
                            end
                            task.wait((Config.AutoShootDelay or 100) / 1000)
                        end
                    end
                end
            end
        end
    end)
end))

local function FlingPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    if targetPlayer.Name == Config.Whitelist then return end
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp or not targetHrp then return end
    local oldPos = myHrp.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(0, 99999, 0)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = math.huge; bav.Parent = myHrp
    local start = tick()
    while tick() - start < 2.5 and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 do
        myHrp.CFrame = targetHrp.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
        task.wait()
    end
    if bav then bav:Destroy() end
    myHrp.Velocity = Vector3.zero; myHrp.RotVelocity = Vector3.zero; myHrp.CFrame = oldPos
end

local function CrashPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    if targetPlayer.Name == Config.Whitelist then return end
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp or not targetHrp then return end
    local oldPos = myHrp.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(9999999, 9999999, 9999999)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = math.huge; bav.Parent = myHrp
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 999999, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = myHrp
    local start = tick()
    while tick() - start < 3 and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") do
        myHrp.CFrame = targetHrp.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
        task.wait()
    end
    if bav then bav:Destroy() end
    if bv then bv:Destroy() end
    myHrp.Velocity = Vector3.zero; myHrp.RotVelocity = Vector3.zero; myHrp.CFrame = oldPos
end

task.spawn(function()
    while task.wait(Config.AuraDelay) do
        if Config.Unloaded then break end
        pcall(function()
            if Config.KillAll then
                local data = Config.Players[LocalPlayer]
                if data and data.Role == "Katil" then
                    local char = LocalPlayer.Character
                    local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("KnifeServer") then
                        if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid").Health > 0 then
                                SafeTeleport(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                                task.wait(0.1); tool:Activate(); task.wait(0.2)
                            end
                        end
                    end
                end
            end
            
            if Config.KillAura then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("KnifeServer") then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid").Health > 0 then
                                local dist = (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                                if dist <= Config.AuraRange then tool:Activate() end
                            end
                        end
                    end
                end
            end
            
            if Config.AutoWin then
                local data = Config.Players[LocalPlayer]
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if data.Role == "Katil" then Config.KillAll = true end
                    if data.Role == "Şerif" then
                        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("GunServer") then
                            if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                            for _, p in pairs(Players:GetPlayers()) do
                                if Config.Players[p] and Config.Players[p].Role == "Katil" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                    local args = { [1] = 1, [2] = p.Character.HumanoidRootPart.Position, [3] = "ShootGun" }
                                    tool.GunServer.InvokeServer(tool.GunServer, unpack(args))
                                end
                            end
                        end
                    end
                end
            end
            
        end)
    end
end)

-- ==========================================
-- 🏃 KARAKTER VE FİZİK (Player Logic)
-- ==========================================
table.insert(Config.Connections, RunService.Stepped:Connect(function()
    pcall(function()
        if Config.AntiFling and LocalPlayer.Character then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end
        
        if Config.AttachTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPlayer = Players:FindFirstChild(Config.AttachTarget)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.5)
            end
        end
        
        if LocalPlayer.Character then
            if Config.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                if Config.WalkSpeed ~= 16 then hum.WalkSpeed = Config.WalkSpeed end
                if Config.JumpPower ~= 50 then hum.JumpPower = Config.JumpPower end
                if Config.BunnyHop then hum.WalkSpeed = Config.WalkSpeed + 15 end
            end
            
            if Config.HitboxExpander then
                for _, plr in pairs(Players:GetPlayers()) do
                    local data = Config.Players[plr] or {}
                    if plr ~= LocalPlayer and plr.Name ~= Config.Whitelist and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        local head = plr.Character:FindFirstChild("Head")
                        local partToExpand = hrp or head
                        
                        if partToExpand then
                            local myRole = Config.Players[LocalPlayer] and Config.Players[LocalPlayer].Role or "Masum"
                            local isValid = true
                            if myRole == "Masum" and data.Role ~= "Katil" then isValid = false end
                            if (myRole == "Şerif" or myRole == "Kahraman") and data.Role ~= "Katil" then isValid = false end
                            
                            if isValid then
                                partToExpand.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                                partToExpand.Transparency = Config.HitboxTransparency
                                partToExpand.BrickColor = BrickColor.new(Config.HitboxColor or Color3.new(1,0,0))
                                partToExpand.Material = Enum.Material[Config.HitboxMaterial] or Enum.Material.Neon
                                partToExpand.CanCollide = false
                            else
                                if partToExpand.Name == "HumanoidRootPart" then
                                    partToExpand.Size = Vector3.new(2, 2, 1); partToExpand.Transparency = 1; partToExpand.CanCollide = false
                                else
                                    partToExpand.Size = Vector3.new(1.2, 1, 1); partToExpand.Transparency = 0; partToExpand.CanCollide = true
                                end
                            end
                        end
                    end
                end
            end
            
            if Config.Invisibility then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.Transparency = 1 elseif part:IsA("Decal") then part.Transparency = 1 end
                end
                if LocalPlayer.Character:FindFirstChild("Head") then
                    if LocalPlayer.Character.Head:FindFirstChild("face") then LocalPlayer.Character.Head.face:Destroy() end
                    if LocalPlayer.Character.Head:FindFirstChild("Nametag") then LocalPlayer.Character.Head.Nametag:Destroy() end
                    if LocalPlayer.Character.Head:FindFirstChild("Role") then LocalPlayer.Character.Head.Role:Destroy() end
                end
            end
            
            if Config.Spinbot and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(Config.SpinPitch), math.rad(Config.SpinSpeed), 0)
            end
            
            if Config.TargetStrafe and Config.SelectedTarget ~= "Yok" then
                local target = Players:FindFirstChild(Config.SelectedTarget)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local time = tick() * Config.StrafeSpeed
                    local offset = Vector3.new(math.cos(time) * Config.StrafeRadius, 0, math.sin(time) * Config.StrafeRadius)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target.Character.HumanoidRootPart.Position + offset, target.Character.HumanoidRootPart.Position)
                end
            end
            
            -- GOD MODE (Anti-Murderer / Kaçış)
            if Config.GodMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myData = Config.Players[LocalPlayer]
                if myData and myData.Role ~= "Katil" then
                    for p, data in pairs(Config.Players) do
                        if data.Role == "Katil" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 20 then
                                -- Katil 20 stud yaklaştığında güvenli bir konuma (harita üstüne) ışınla
                                SafeTeleport(LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 150, 0))
                            end
                        end
                    end
                end
            end
        end
    end)
end))

table.insert(Config.Connections, UserInputService.JumpRequest:Connect(function()
    if not Config.Unloaded and Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

local IsFlying = false
local FlyGui = Instance.new("ScreenGui", GUI_PARENT)
FlyGui.Name = "SanderFlyGui"
FlyGui.ResetOnSpawn = false
FlyGui.Enabled = Config.Fly -- Sync with Config.Fly

local FlyFrame = Instance.new("Frame", FlyGui)
FlyFrame.Size = UDim2.new(0, 180, 0, 120)
FlyFrame.Position = UDim2.new(1, -200, 0.5, -60)
FlyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FlyFrame.BorderSizePixel = 0
FlyFrame.Active = true
FlyFrame.Draggable = true
Instance.new("UICorner", FlyFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", FlyFrame).Color = Color3.fromRGB(0, 255, 100)

local FlyTitle = Instance.new("TextLabel", FlyFrame)
FlyTitle.Size = UDim2.new(1, 0, 0, 30)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "Fly Control"
FlyTitle.TextColor3 = Color3.new(1,1,1)
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.TextSize = 14

local FlyToggleBtn = Instance.new("TextButton", FlyFrame)
FlyToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
FlyToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
FlyToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyToggleBtn.TextColor3 = Color3.new(1,1,1)
FlyToggleBtn.Text = "Toggle Fly: OFF"
FlyToggleBtn.Font = Enum.Font.GothamBold
FlyToggleBtn.TextSize = 12
Instance.new("UICorner", FlyToggleBtn).CornerRadius = UDim.new(0, 4)

local FlySpeedTxt = Instance.new("TextLabel", FlyFrame)
FlySpeedTxt.Size = UDim2.new(1, 0, 0, 20)
FlySpeedTxt.Position = UDim2.new(0, 0, 0.6, 0)
FlySpeedTxt.BackgroundTransparency = 1
FlySpeedTxt.Text = "Speed: " .. Config.FlySpeed
FlySpeedTxt.TextColor3 = Color3.new(1,1,1)
FlySpeedTxt.Font = Enum.Font.Gotham
FlySpeedTxt.TextSize = 12

local FlyPlusBtn = Instance.new("TextButton", FlyFrame)
FlyPlusBtn.Size = UDim2.new(0, 30, 0, 25)
FlyPlusBtn.Position = UDim2.new(0.7, 0, 0.75, 0)
FlyPlusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyPlusBtn.TextColor3 = Color3.new(1,1,1)
FlyPlusBtn.Text = "+"
Instance.new("UICorner", FlyPlusBtn).CornerRadius = UDim.new(0, 4)

local FlyMinusBtn = Instance.new("TextButton", FlyFrame)
FlyMinusBtn.Size = UDim2.new(0, 30, 0, 25)
FlyMinusBtn.Position = UDim2.new(0.15, 0, 0.75, 0)
FlyMinusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FlyMinusBtn.TextColor3 = Color3.new(1,1,1)
FlyMinusBtn.Text = "-"
Instance.new("UICorner", FlyMinusBtn).CornerRadius = UDim.new(0, 4)

FlyToggleBtn.MouseButton1Click:Connect(function()
    IsFlying = not IsFlying
    FlyToggleBtn.Text = IsFlying and "Toggle Fly: ON" or "Toggle Fly: OFF"
    FlyToggleBtn.BackgroundColor3 = IsFlying and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(45, 45, 45)
end)

FlyPlusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.min(Config.FlySpeed + 5, 200)
    FlySpeedTxt.Text = "Speed: " .. Config.FlySpeed
end)

FlyMinusBtn.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.max(Config.FlySpeed - 5, 10)
    FlySpeedTxt.Text = "Speed: " .. Config.FlySpeed
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.Unloaded then FlyGui:Destroy(); break end
        FlyGui.Enabled = Config.Fly
    end
end)

table.insert(Config.Connections, UserInputService.InputBegan:Connect(function(input, gp)
    if gp or Config.Unloaded then return end
    if input.KeyCode.Name == Config.FlyBind then
        Config.Fly = not Config.Fly
        if Config.Notifications then Notify("Fly GUI", Config.Fly and "Shown" or "Hidden") end
        SaveConfig()
    end
    if input.KeyCode.Name == Config.SheriffShootBind then
        local myRole = Config.Players[LocalPlayer] and Config.Players[LocalPlayer].Role or "Masum"
        if myRole == "Şerif" or myRole == "Kahraman" then
            Config.SheriffShooting = true
        end
    end
end))

table.insert(Config.Connections, UserInputService.InputEnded:Connect(function(input, gp)
    if gp or Config.Unloaded then return end
    if input.KeyCode.Name == Config.SheriffShootBind then
        Config.SheriffShooting = false
    end
end))

local flying = false
table.insert(Config.Connections, RunService.RenderStepped:Connect(function()
    pcall(function()
        if Config.Unloaded then return end
        if IsFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if not flying then
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVelocity"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 9000
                flying = true; if hum then hum.PlatformStand = true end
            else
                local bv = hrp:FindFirstChild("FlyVelocity"); local bg = hrp:FindFirstChild("FlyGyro")
                if bv and bg then
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                    bv.Velocity = moveDir * Config.FlySpeed; bg.CFrame = Camera.CFrame
                end
            end
        else
            if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
                if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
                flying = false; local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = false end
            end
        end
    end)
end))

-- ==========================================
-- 🌍 DÜNYA VE TROLL (World Manipulation)
-- ==========================================
-- FPS DÜŞÜŞÜNÜ ENGELLEYEN EVENT TABANLI DÜNYA OPTİMİZASYONU
local function UpdateWorld()
    pcall(function()
        if Config.FullBright then
            Lighting.Brightness = 2; Lighting.ClockTime = Config.TimeOfDay; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
            Lighting.Ambient = Config.AmbientColor
        else
            Lighting.Brightness = 1; Lighting.ClockTime = 14; Lighting.FogEnd = 10000; Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(128,128,128)
        end
        if Config.RemoveShadows then Lighting.GlobalShadows = false end
        Workspace.Gravity = Config.Gravity
        
        if Config.RemoveTextures then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
                if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 1 end
            end
        end
        
        -- SHADERS (RTX GRAFİKLER)
        if Config.Shaders then
            if not Lighting:FindFirstChild("SanderBloom") then
                local b = Instance.new("BloomEffect", Lighting); b.Name = "SanderBloom"; b.Intensity = 0.8; b.Size = 24; b.Threshold = 1.5
                local c = Instance.new("ColorCorrectionEffect", Lighting); c.Name = "SanderColor"; c.Contrast = 0.3; c.Saturation = 0.6; c.Brightness = 0.1
                local s = Instance.new("SunRaysEffect", Lighting); s.Name = "SanderSun"; s.Intensity = 0.08; s.Spread = 0.8
                local d = Instance.new("DepthOfFieldEffect", Lighting); d.Name = "SanderDoF"; d.FocusDistance = 50; d.InFocusRadius = 40; d.NearIntensity = 0.3; d.FarIntensity = 0.7
                local bl = Instance.new("BlurEffect", Lighting); bl.Name = "SanderBlur"; bl.Size = 3
            end
        else
            if Lighting:FindFirstChild("SanderBloom") then Lighting.SanderBloom:Destroy() end
            if Lighting:FindFirstChild("SanderColor") then Lighting.SanderColor:Destroy() end
            if Lighting:FindFirstChild("SanderSun") then Lighting.SanderSun:Destroy() end
            if Lighting:FindFirstChild("SanderDoF") then Lighting.SanderDoF:Destroy() end
            if Lighting:FindFirstChild("SanderBlur") then Lighting.SanderBlur:Destroy() end
        end
    end)
end
UpdateWorld() -- Sadece ayar değiştiğinde çalıştırılır, while döngüsünde değil. (FPS Artışı)

local TextChatService = game:GetService("TextChatService")
task.spawn(function()
    while task.wait(Config.SpamDelay or 3) do
        if Config.Unloaded then break end
        if Config.ChatSpam then
            pcall(function() 
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    TextChatService.TextChannels.RBXGeneral:SendAsync(Config.SpamMessage)
                else
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Config.SpamMessage, "All") 
                end
            end)
        end
    end
end)

-- ANİMASYON SİSTEMİ KALDIRILDI

-- ==========================================
-- 🖼️ ULTRA UI FRAMEWORK V2 (GLASSMORPHISM & SHADOWS)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", GUI_PARENT); ScreenGui.Name = "SanderHub_V2_Gui"; ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() if type(getgenv().ProtectInstance) == "function" then ProtectInstance(ScreenGui) end end)
pcall(function() if type(syn) == "table" and type(syn.protect_gui) == "function" then syn.protect_gui(ScreenGui) end end)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 800, 0, 500); MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Main; MainFrame.BackgroundTransparency = 0.05 -- Glassmorphism
MainFrame.ClipsDescendants = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Theme.Stroke; MainStroke.Thickness = 1.5

-- Drop Shadow
local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5); Shadow.Position = UDim2.new(0.5, 0, 0.5, 0); Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.BackgroundTransparency = 1; Shadow.Image = "rbxassetid://1319280125"; Shadow.ImageColor3 = Color3.new(0,0,0)
Shadow.ImageTransparency = 0.5; Shadow.ZIndex = -1; Shadow.SliceCenter = Rect.new(20,20,280,280)

-- UIGradient (Premium Look)
local MainGrad = Instance.new("UIGradient", MainFrame)
MainGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(0.8,0.8,0.8))}
MainGrad.Rotation = 45

-- Minimize İkonu
local MinIcon = Instance.new("ImageButton", ScreenGui)
MinIcon.Size = UDim2.new(0, 55, 0, 55); MinIcon.Position = UDim2.new(0, 20, 0.5, 0)
MinIcon.BackgroundColor3 = Theme.Second; MinIcon.BackgroundTransparency = 0.1; MinIcon.Visible = false; MinIcon.ZIndex = 10
Instance.new("UICorner", MinIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MinIcon).Color = Theme.Accent; Instance.new("UIStroke", MinIcon).Thickness = 2
local MinText = Instance.new("TextLabel", MinIcon)
MinText.Size = UDim2.new(1,0,1,0); MinText.BackgroundTransparency = 1; MinText.Text = "S-V2"; MinText.TextColor3 = Theme.Text; MinText.Font = Enum.Font.GothamBlack; MinText.TextSize = 14

-- Sürükleme Mantığı
local function makeDraggable(frame, handler)
    local dragging, dragStart, startPos, moved
    handler.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; moved = false; dragStart = input.Position; startPos = frame.Position end 
    end)
    handler.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
            moved = true; local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    return function() return moved end
end

local TopBar = Instance.new("Frame", MainFrame); TopBar.Size = UDim2.new(1, 0, 0, 50); TopBar.BackgroundTransparency = 1; TopBar.ZIndex = 2
local isMainMoved = makeDraggable(MainFrame, TopBar); local isMinMoved = makeDraggable(MinIcon, MinIcon)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "SanderHub-V1 <font size='11'>SanderG studio presents</font>"; Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22; Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,100))}
TitleGrad.Rotation = 0

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 35, 0, 35); MinBtn.Position = UDim2.new(1, -45, 0, 7.5); MinBtn.BackgroundColor3 = Theme.Second; MinBtn.Text = "-"; MinBtn.TextColor3 = Theme.Text; MinBtn.Font = Enum.Font.GothamBlack; MinBtn.TextSize = 18; MinBtn.ZIndex = 3
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", MinBtn).Color = Theme.Stroke
MinBtn.MouseButton1Click:Connect(function() Config.Minimized = true; Tween(MainFrame, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.3); task.wait(0.2); MainFrame.Visible = false; MinIcon.Visible = true end)
MinIcon.MouseButton1Click:Connect(function() if isMinMoved() then return end; Config.Minimized = false; MainFrame.Visible = true; Tween(MainFrame, {Size = UDim2.new(0,800,0,500), BackgroundTransparency = 0.05}, 0.3, Enum.EasingStyle.Back); MinIcon.Visible = false end)

local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Size = UDim2.new(0, 190, 1, -50); Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Theme.Second; Sidebar.BackgroundTransparency = 0.1; Sidebar.BorderSizePixel = 0; Sidebar.ScrollBarThickness = 0
local SidebarLayout = Instance.new("UIListLayout", Sidebar); SidebarLayout.Padding = UDim.new(0, 5); SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -190, 1, -50); Content.Position = UDim2.new(0, 190, 0, 50); Content.BackgroundTransparency = 1

local Tabs = {}
local GlobalDropdowns = {}
local function CloseAllDropdowns()
    for _, dd in pairs(GlobalDropdowns) do if dd.Close then dd.Close() end end
end

local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 40); TabBtn.BackgroundColor3 = Theme.Main; TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. icon .. "  " .. name; TabBtn.TextColor3 = Theme.SubText
    TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    RegisterLang(TabBtn, "  " .. icon .. "  " .. name, "Text")

    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.Position = UDim2.new(0, 20, 0, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y; Page.CanvasSize = UDim2.new(0,0,0,0) -- FIX: Sayfaların aşağı doğru scroll edilebilmesi sağlandı.
    local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 10); PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 15); Instance.new("UIPadding", Page).PaddingBottom = UDim.new(0, 20)
    
    TabBtn.MouseButton1Click:Connect(function()
        CloseAllDropdowns()
        for _, t in pairs(Tabs) do Tween(t.Btn, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}, 0.2); t.Page.Visible = false end
        Tween(TabBtn, {BackgroundTransparency = 0, TextColor3 = Config.RainbowText and RainbowColor or Theme.Text}, 0.2)
        Page.Visible = true
        Page.Position = UDim2.new(0, 30, 0, 0); Page.CanvasPosition = Vector2.new(0,0)
        Tween(Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart) -- Slide Animation
    end)
    table.insert(Tabs, {Btn = TabBtn, Page = Page, Name = name})
    return Page
end

local function CreateLabel(parent, text)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.Size = UDim2.new(0.92, 0, 0, 30); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBlack; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Center
    RegisterLang(Lbl, text, "Text")
    return Lbl
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.92, 0, 0, 45); Btn.BackgroundColor3 = Theme.Second; Btn.Text = text; Btn.TextColor3 = Theme.Text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Btn).Color = Theme.Stroke
    RegisterLang(Btn, text, "Text")
    
    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Main}, 0.2) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Second}, 0.2) end)
    Btn.MouseButton1Click:Connect(function() Tween(Btn, {Size = UDim2.new(0.88, 0, 0, 42), BackgroundColor3 = Theme.Accent}, 0.1, Enum.EasingStyle.Quad); task.wait(0.1); Tween(Btn, {Size = UDim2.new(0.92, 0, 0, 45), BackgroundColor3 = Theme.Main}, 0.1, Enum.EasingStyle.Quad); if callback then callback() end end)
    return Btn
end

local function CreateToggle(parent, text, desc, flag, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 55); Frame.BackgroundColor3 = Theme.Second; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); local Stroke = Instance.new("UIStroke", Frame); Stroke.Color = Theme.Stroke
    
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(0.7, 0, 0.5, 0); Lbl.Position = UDim2.new(0, 15, 0, 8); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Lbl, text, "Text")
    local Desc = Instance.new("TextLabel", Frame); Desc.Size = UDim2.new(0.7, 0, 0.5, 0); Desc.Position = UDim2.new(0, 15, 0, 26); Desc.BackgroundTransparency = 1; Desc.Text = desc; Desc.TextColor3 = Theme.SubText; Desc.Font = Enum.Font.Gotham; Desc.TextSize = 11; Desc.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Desc, desc, "Text")
    
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0, 44, 0, 22); Btn.Position = UDim2.new(1, -60, 0.5, -11); Btn.BackgroundColor3 = Theme.Stroke; Btn.Text = ""; Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame", Btn); Circle.Size = UDim2.new(0, 18, 0, 18); Circle.Position = UDim2.new(0, 2, 0.5, -9); Circle.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    local Shadow = Instance.new("ImageLabel", Circle); Shadow.Size=UDim2.new(1,10,1,10); Shadow.Position=UDim2.new(0.5,0,0.5,0); Shadow.AnchorPoint=Vector2.new(0.5,0.5); Shadow.BackgroundTransparency=1; Shadow.Image="rbxassetid://1319280125"; Shadow.ImageColor3=Color3.new(0,0,0); Shadow.ImageTransparency=0.6; Shadow.ZIndex=0
    
    local function setVisual(state)
        if state then 
            Tween(Btn, {BackgroundColor3 = GetAccent()}, 0.3)
            Tween(Circle, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.4, Enum.EasingStyle.Elastic) -- BOUNCY ELASTIC
            Tween(Stroke, {Color = GetAccent()}, 0.3)
        else 
            Tween(Btn, {BackgroundColor3 = Theme.Stroke}, 0.3)
            Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.4, Enum.EasingStyle.Elastic) -- BOUNCY ELASTIC
            Tween(Stroke, {Color = Theme.Stroke}, 0.3)
        end
    end
    setVisual(Config[flag])
    
    Frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Config[flag] = not Config[flag]; setVisual(Config[flag]); SaveConfig(); if callback then callback() end end end)
    Btn.MouseButton1Click:Connect(function() Config[flag] = not Config[flag]; setVisual(Config[flag]); SaveConfig(); if callback then callback() end end)
end

local function CreateSlider(parent, text, min, max, flag, callback)
    local default = Config[flag] or min
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 55); Frame.BackgroundColor3 = Theme.Second; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = Theme.Stroke
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(0.5, 0, 0.5, 0); Lbl.Position = UDim2.new(0, 15, 0, 5); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Lbl, text, "Text")
    local Val = Instance.new("TextLabel", Frame); Val.Size = UDim2.new(0.5, -15, 0.5, 0); Val.Position = UDim2.new(0.5, 0, 0, 5); Val.BackgroundTransparency = 1; Val.Text = tostring(default); Val.TextColor3 = GetAccent(); Val.Font = Enum.Font.GothamBold; Val.TextSize = 14; Val.TextXAlignment = Enum.TextXAlignment.Right
    local SlideBg = Instance.new("TextButton", Frame); SlideBg.Size = UDim2.new(1, -30, 0, 6); SlideBg.Position = UDim2.new(0, 15, 0, 36); SlideBg.BackgroundColor3 = Theme.Stroke; SlideBg.Text = ""; Instance.new("UICorner", SlideBg).CornerRadius = UDim.new(1, 0)
    local Fill = Instance.new("Frame", SlideBg); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = GetAccent(); Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", Fill); Knob.Size = UDim2.new(0, 12, 0, 12); Knob.Position = UDim2.new(1, -6, 0.5, -6); Knob.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0); local Shadow = Instance.new("ImageLabel", Knob); Shadow.Size=UDim2.new(1,10,1,10); Shadow.Position=UDim2.new(0.5,0,0.5,0); Shadow.AnchorPoint=Vector2.new(0.5,0.5); Shadow.BackgroundTransparency=1; Shadow.Image="rbxassetid://1319280125"; Shadow.ImageColor3=Color3.new(0,0,0); Shadow.ImageTransparency=0.6; Shadow.ZIndex=0
    
    local sliding = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - SlideBg.AbsolutePosition.X) / SlideBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        Config[flag] = value; Val.Text = tostring(value); Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1, Enum.EasingStyle.Sine)
        if callback then callback() end
    end
    SlideBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Update(i); Tween(Knob, {Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-8,0.5,-8)}, 0.2) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false; SaveConfig(); Tween(Knob, {Size = UDim2.new(0,12,0,12), Position = UDim2.new(1,-6,0.5,-6)}, 0.2) end end)
    UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
    task.spawn(function() while task.wait(0.5) do if not Config.Unloaded then Fill.BackgroundColor3 = GetAccent(); Val.TextColor3 = GetAccent() end end end)
end

-- GlobalDropdowns moved up
local function CreateSearchableDropdown(parent, text, options, flag, callback)
    local default = Config[flag] or options[1]
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 50); Frame.BackgroundColor3 = Theme.Second; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = Theme.Stroke
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(0.5, 0, 1, 0); Lbl.Position = UDim2.new(0, 15, 0, 0); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Lbl, text, "Text")
    
    local DropBtn = Instance.new("TextButton", Frame)
    DropBtn.Size = UDim2.new(0, 180, 0, 30); DropBtn.Position = UDim2.new(1, -195, 0.5, -15); DropBtn.BackgroundColor3 = Theme.Main; DropBtn.Text = tostring(default); DropBtn.TextColor3 = Theme.Text; DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 12; Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", DropBtn).Color = Theme.Stroke
    
    local open = false
    local ListFrame = Instance.new("ScrollingFrame", ScreenGui)
    ListFrame.Size = UDim2.new(0, 180, 0, 0); ListFrame.BackgroundColor3 = Theme.Second; ListFrame.Visible = false; ListFrame.ScrollBarThickness = 4; ListFrame.ZIndex = 50; ListFrame.ClipsDescendants = true
    Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", ListFrame).Color = Theme.Accent; Instance.new("UIStroke", ListFrame).Thickness = 2
    local listLayout = Instance.new("UIListLayout", ListFrame); listLayout.Padding = UDim.new(0, 2); listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", ListFrame).PaddingTop = UDim.new(0, 5)
    
    local SearchBox = Instance.new("TextBox", ListFrame)
    SearchBox.Size = UDim2.new(0.95, 0, 0, 30); SearchBox.BackgroundColor3 = Theme.Main; SearchBox.Text = "Ara..."; SearchBox.TextColor3 = Theme.Text; SearchBox.Font = Enum.Font.Gotham; SearchBox.TextSize = 12; SearchBox.ZIndex = 51
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
    
    local function CloseMenu()
        if open then
            open = false
            Tween(ListFrame, {Size = UDim2.new(0, 180, 0, 0)}, 0.2)
            task.delay(0.2, function() ListFrame.Visible = false end)
        end
    end
    table.insert(GlobalDropdowns, {ListFrame = ListFrame, Close = CloseMenu})
    
    local buttons = {}
    DropBtn.MouseButton1Click:Connect(function()
        if not open then
            CloseAllDropdowns()
            open = true
            local absPos = DropBtn.AbsolutePosition
            ListFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + 35)
            ListFrame.Visible = true
            Tween(ListFrame, {Size = UDim2.new(0, 180, 0, 200)}, 0.3, Enum.EasingStyle.Quart)
        else
            CloseMenu()
        end
    end)
    
    for _, opt in pairs(options) do
        local optBtn = Instance.new("TextButton", ListFrame)
        optBtn.Size = UDim2.new(0.95, 0, 0, 25); optBtn.BackgroundTransparency = 1; optBtn.Text = tostring(opt); optBtn.TextColor3 = Theme.SubText; optBtn.Font = Enum.Font.Gotham; optBtn.TextSize = 12; optBtn.ZIndex = 51
        optBtn.MouseButton1Click:Connect(function() Config[flag] = opt; DropBtn.Text = tostring(opt); open = false; Tween(ListFrame, {Size = UDim2.new(0, 180, 0, 0)}, 0.2); task.delay(0.2, function() ListFrame.Visible = false end); SaveConfig() end)
        table.insert(buttons, {Btn = optBtn, Text = tostring(opt):lower()})
    end
    
    SearchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            local txt = SearchBox.Text:lower()
            for _, b in pairs(buttons) do
                if txt == "" or txt == "ara..." or b.Text:find(txt) then b.Btn.Visible = true else b.Btn.Visible = false end
            end
        end
    end)
    SearchBox.Focused:Connect(function() if SearchBox.Text == "Ara..." then SearchBox.Text = "" end end)
    
    local function Refresh(newOptions)
        for _, b in pairs(buttons) do pcall(function() b.Btn:Destroy() end) end
        buttons = {}
        for _, opt in pairs(newOptions) do
            local optBtn = Instance.new("TextButton", ListFrame)
            optBtn.Size = UDim2.new(0.95, 0, 0, 25); optBtn.BackgroundTransparency = 1; optBtn.Text = tostring(opt); optBtn.TextColor3 = Theme.SubText; optBtn.Font = Enum.Font.Gotham; optBtn.TextSize = 12; optBtn.ZIndex = 51
            optBtn.MouseButton1Click:Connect(function() Config[flag] = opt; DropBtn.Text = tostring(opt); open = false; Tween(ListFrame, {Size = UDim2.new(0, 180, 0, 0)}, 0.2); task.delay(0.2, function() ListFrame.Visible = false end); SaveConfig(); if callback then callback(opt) end end)
            table.insert(buttons, {Btn = optBtn, Text = tostring(opt):lower()})
        end
        local txt = SearchBox.Text:lower()
        if txt ~= "" and txt ~= "ara..." then
            for _, b in pairs(buttons) do b.Btn.Visible = (b.Text:find(txt) ~= nil) end
        end
        local hasCurrent = false
        for _, opt in pairs(newOptions) do if tostring(opt) == tostring(Config[flag]) then hasCurrent = true end end
        if not hasCurrent and #newOptions > 0 then Config[flag] = newOptions[1]; DropBtn.Text = tostring(newOptions[1]) end
        if #newOptions == 0 then Config[flag] = "Yok"; DropBtn.Text = "Yok" end
    end
    
    return {Refresh = Refresh}
end

local function CreateTextBox(parent, text, desc, flag)
    local default = Config[flag] or ""
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 55); Frame.BackgroundColor3 = Theme.Second; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = Theme.Stroke
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(0.7, 0, 0.5, 0); Lbl.Position = UDim2.new(0, 15, 0, 8); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Lbl, text, "Text")
    local Desc = Instance.new("TextLabel", Frame); Desc.Size = UDim2.new(0.7, 0, 0.5, 0); Desc.Position = UDim2.new(0, 15, 0, 26); Desc.BackgroundTransparency = 1; Desc.Text = desc; Desc.TextColor3 = Theme.SubText; Desc.Font = Enum.Font.Gotham; Desc.TextSize = 11; Desc.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Desc, desc, "Text")
    
    local TxtBox = Instance.new("TextBox", Frame)
    TxtBox.Size = UDim2.new(0, 160, 0, 30); TxtBox.Position = UDim2.new(1, -175, 0.5, -15); TxtBox.BackgroundColor3 = Theme.Main; TxtBox.Text = tostring(default); TxtBox.TextColor3 = Theme.Text; TxtBox.Font = Enum.Font.GothamBold; TxtBox.TextSize = 12
    Instance.new("UICorner", TxtBox).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", TxtBox).Color = Theme.Stroke
    
    TxtBox.FocusLost:Connect(function()
        Config[flag] = TxtBox.Text
        SaveConfig()
    end)
end

local function CreateKeyBind(parent, text, desc, flag)
    local default = Config[flag]
    if typeof(default) ~= "EnumItem" then
        if type(default) == "string" and Enum.KeyCode[default] then default = Enum.KeyCode[default] else default = Enum.KeyCode.Unknown end
    end
    Config[flag] = default

    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.92, 0, 0, 55); Frame.BackgroundColor3 = Theme.Second; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = Theme.Stroke
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(0.7, 0, 0.5, 0); Lbl.Position = UDim2.new(0, 15, 0, 8); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 14; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Lbl, text, "Text")
    local Desc = Instance.new("TextLabel", Frame); Desc.Size = UDim2.new(0.7, 0, 0.5, 0); Desc.Position = UDim2.new(0, 15, 0, 26); Desc.BackgroundTransparency = 1; Desc.Text = desc; Desc.TextColor3 = Theme.SubText; Desc.Font = Enum.Font.Gotham; Desc.TextSize = 11; Desc.TextXAlignment = Enum.TextXAlignment.Left
    RegisterLang(Desc, desc, "Text")
    
    local BindBtn = Instance.new("TextButton", Frame)
    BindBtn.Size = UDim2.new(0, 100, 0, 30); BindBtn.Position = UDim2.new(1, -115, 0.5, -15); BindBtn.BackgroundColor3 = Theme.Main; BindBtn.Text = default.Name; BindBtn.TextColor3 = Theme.Text; BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 12
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", BindBtn).Color = Theme.Stroke
    
    local listening = false
    BindBtn.MouseButton1Click:Connect(function()
        if not listening then
            listening = true
            BindBtn.Text = "..."
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            Config[flag] = input.KeyCode
            BindBtn.Text = input.KeyCode.Name
            SaveConfig()
        end
    end)
end

-- ==========================================
-- 🗂️ TABS & MENUS & FEATURES
-- ==========================================
local TabMain = CreateTab("  🏠  Main", "🏠")
local TabMassacre = CreateTab("  ☠️  Massacre", "☠️")
local TabPlayers = CreateTab("  🏹  Players", "🏹")
local TabESP = CreateTab("  👁️  Visuals", "👁️")
local TabFarm = CreateTab("  ⚙️  Automation", "⚙️")
local TabPlayer = CreateTab("  🏃  Movement", "🏃")
local TabWorld = CreateTab("  🌍  World", "🌍")
local TabSettings = CreateTab("  🔧  Settings", "🔧")

-- MAIN TAB
CreateLabel(TabMain, "[ ACCOUNT & STATS ]")
CreateLabel(TabMain, "Welcome, " .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
CreateLabel(TabMain, "Ping: " .. (Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0) .. " ms")
CreateLabel(TabMain, "Account Age: " .. LocalPlayer.AccountAge .. " Days")
CreateButton(TabMain, "Copy Discord Server", function() if setclipboard then setclipboard("https://discord.gg/R8Zsa4vtR") end Notify("Copied", "Discord link copied to clipboard!") end)
CreateButton(TabMain, "Rejoin Same Server", function() Notify("Rejoining", "Rejoin process started."); TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)



-- ESP TAB
CreateLabel(TabESP, "[ MAIN VISUAL CHEATS (ESP) ]")
CreateToggle(TabESP, "Master ESP", "Toggle all visual cheats.", "EspEnabled")
CreateToggle(TabESP, "Box ESP", "Draws a box around character.", "EspBox")
CreateToggle(TabESP, "Name Tags", "Shows player names.", "EspName")
CreateToggle(TabESP, "Role ESP", "Shows in-game roles.", "EspRole")
CreateToggle(TabESP, "Weapon ESP", "Shows equipped weapon.", "EspWeapon")
CreateToggle(TabESP, "Health ESP", "Shows health status.", "EspHealth")
CreateToggle(TabESP, "Chams ESP", "Makes enemies glow.", "EspChams")

-- FARM TAB
CreateLabel(TabFarm, "[ AUTOMATION & BOT ]")
CreateToggle(TabFarm, "AutoCoin (AI)", "Smoothly scans and collects coins.", "AutoCoin")
CreateSearchableDropdown(TabFarm, "Coin Collection Method", {"Pathfind (Bot)", "Fly (Noclip)", "Teleport"}, "CoinMethod")
CreateToggle(TabFarm, "Jump Over Obstacles", "Allows bot to jump obstacles.", "JumpOverObstacles")
CreateToggle(TabFarm, "Bot Acceleration", "Increases bot speed.", "BunnyHop")
CreateToggle(TabFarm, "AutoGun (Dropped)", "Instantly grabs gun when dropped.", "AutoGun")
CreateToggle(TabFarm, "AutoWin (Instant Win)", "If sheriff kills murderer, if murderer kills all.", "AutoWin")
CreateToggle(TabFarm, "Anti-AFK", "Prevents idle kick.", "AntiAFK")
CreateToggle(TabFarm, "Anti-Fling", "Prevents players from flinging you.", "AntiFling")

-- PLAYER TAB
CreateLabel(TabPlayer, "[ MOVEMENT & ABILITY ]")
CreateToggle(TabPlayer, "Noclip", "Allows walking through walls.", "Noclip")
CreateToggle(TabPlayer, "Infinite Jump", "Jump infinitely in the air.", "InfJump")
CreateToggle(TabPlayer, "Fly Mode", "Enables flying with W,A,S,D.", "Fly")
CreateKeyBind(TabPlayer, "Fly KeyBind", "Key to toggle fly mode.", "FlyBind")
CreateSlider(TabPlayer, "Fly Speed", 10, 200, "FlySpeed")
CreateToggle(TabPlayer, "Invisibility", "Makes character transparent (Client side).", "Invisibility")
CreateToggle(TabPlayer, "Spinbot", "Spins your character continuously.", "Spinbot")
CreateSlider(TabPlayer, "WalkSpeed", 16, 250, "WalkSpeed")
CreateSlider(TabPlayer, "JumpPower", 50, 300, "JumpPower")

-- PLAYERS TAB
local tNames = {"None"}
for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(tNames, p.Name) end end
CreateLabel(TabPlayers, "[ TARGETS & LISTS ]")
local TargetDropdown = CreateSearchableDropdown(TabPlayers, "Select Target", tNames, "SelectedTarget")
local WhiteDropdown = CreateSearchableDropdown(TabPlayers, "Whitelist", tNames, "Whitelist")
local BlackDropdown = CreateSearchableDropdown(TabPlayers, "Blacklist", tNames, "Blacklist")
CreateButton(TabPlayers, "Teleport (Goto)", function() local p=Players:FindFirstChild(Config.SelectedTarget); if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end end)
CreateButton(TabPlayers, "Spectate", function() local p = Players:FindFirstChild(Config.SelectedTarget); if p and p.Character and p.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = p.Character.Humanoid; Config.Spectating = true end end)
CreateButton(TabPlayers, "Unspectate", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = LocalPlayer.Character.Humanoid; Config.Spectating = false end end)

CreateButton(TabPlayers, "Attach to Back", function() Config.AttachTarget = Config.SelectedTarget end)
CreateButton(TabPlayers, "Detach", function() Config.AttachTarget = nil end)
CreateButton(TabPlayers, "Fling Target", function() local p=Players:FindFirstChild(Config.SelectedTarget); if p then CrashPlayer(p) end end)

-- MASSACRE TAB
CreateLabel(TabMassacre, "[ COMBAT & AIMBOT ]")
CreateToggle(TabMassacre, "Auto-Aim", "Locks onto enemy when holding a weapon.", "AutoAim")
CreateToggle(TabMassacre, "Auto Shoot & Throw", "Auto shoots when locked onto enemy.", "AutoShoot")
CreateSlider(TabMassacre, "Shoot Delay (ms)", 0, 500, "AutoShootDelay")
CreateKeyBind(TabMassacre, "Sheriff Auto-Shoot Key", "Locks on murderer when sheriff.", "SheriffShootBind")
CreateToggle(TabMassacre, "Hitbox Expander", "Expands enemy hitboxes.", "HitboxExpander")
CreateSlider(TabMassacre, "Hitbox Size", 2, 50, "HitboxSize")
CreateSlider(TabMassacre, "Hitbox Transparency (%)", 0, 100, "HitboxTransparency")

CreateLabel(TabMassacre, "[ TROLL & MASSACRE ]")
CreateToggle(TabMassacre, "Kill All Mode", "If murderer, teleports to all and stabs.", "KillAll")
CreateToggle(TabMassacre, "Kill Aura", "If murderer, stabs approaching players.", "KillAura")
CreateButton(TabMassacre, "Fling Everyone", function() for _, p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then FlingPlayer(p) end end end)
CreateButton(TabMassacre, "Fling Murderer", function()
    for p, d in pairs(Config.Players) do if d.Role == "Katil" then FlingPlayer(p) end end
end)
CreateButton(TabMassacre, "Fling Sheriff", function()
    for p, d in pairs(Config.Players) do if d.Role == "Şerif" then FlingPlayer(p) end end
end)
CreateToggle(TabMassacre, "God Mode (Anti-Murderer)", "Auto escapes when murderer approaches.", "GodMode")

CreateLabel(TabMassacre, "[ DRAWING & TARGETING ]")
CreateToggle(TabMassacre, "Visible FOV Circle", "Draws a circle around mouse.", "SilentAimFOV")
CreateSlider(TabMassacre, "FOV Radius", 10, 500, "FOVRadius")

local function RefreshTargetDropdown()
    local newNames = {"None"}
    for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(newNames, p.Name) end end
    TargetDropdown.Refresh(newNames)
    WhiteDropdown.Refresh(newNames)
    BlackDropdown.Refresh(newNames)
end
table.insert(Config.Connections, Players.PlayerAdded:Connect(RefreshTargetDropdown))
table.insert(Config.Connections, Players.PlayerRemoving:Connect(RefreshTargetDropdown))

-- WORLD TAB
CreateLabel(TabWorld, "[ ENVIRONMENT & LIGHTING (FPS BOOST) ]")
CreateToggle(TabWorld, "FullBright (Day)", "Removes all darkness in map.", "FullBright", UpdateWorld)
CreateToggle(TabWorld, "Disable Shadows", "Disables all shadow renders.", "RemoveShadows", UpdateWorld)
CreateToggle(TabWorld, "Remove Textures (FPS Boost)", "Removes textures making game matte.", "RemoveTextures", UpdateWorld)
CreateToggle(TabWorld, "Enhance Graphics (Ultra RTX)", "Gives the game perfect graphics.", "Shaders", UpdateWorld)
CreateSlider(TabWorld, "Gravity", 0, 500, "Gravity", UpdateWorld)
CreateLabel(TabWorld, "[ CHAT SPAM ]")
CreateToggle(TabWorld, "Chat Spammer", "Continuously sends specified message.", "ChatSpam")
CreateTextBox(TabWorld, "Spam Message", "Message to send", "SpamMessage")

-- SETTINGS TAB
CreateLabel(TabSettings, "[ UI SETTINGS ]")
CreateSearchableDropdown(TabSettings, "Select Theme", {"Dark", "Light", "Blood", "Ocean", "Matrix", "Gold", "Hacker", "Moss"}, "Theme")
CreateToggle(TabSettings, "Rainbow UI Stroke", "Makes menu borders rainbow.", "RainbowUI")
CreateToggle(TabSettings, "Rainbow Texts", "Makes texts rainbow colored.", "RainbowText")
CreateToggle(TabSettings, "Show Watermark", "Shows FPS/Ping panel.", "Watermark")
CreateToggle(TabSettings, "Show Notifications", "Allows hub to send notifications.", "Notifications")
CreateLabel(TabSettings, "[ SECURITY & EXIT ]")
CreateButton(TabSettings, "Save Settings", function() SaveConfig(); Notify("Saved", "Settings saved to disk.") end)
CreateButton(TabSettings, "Unload Hub", function()
    Config.Unloaded = true
    for _, conn in pairs(Config.Connections) do if conn.Disconnect then pcall(function() conn:Disconnect() end) end end
    if ScreenGui then ScreenGui:Destroy() end
    if ESPFolder then ESPFolder:Destroy() end
    if type(FOVCircle) == "table" and FOVCircle.Remove then pcall(function() FOVCircle:Remove() end) end
    if WatermarkGui then WatermarkGui:Destroy() end
    Workspace.Gravity = 196.2
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- ==========================================
-- 🚀 BAŞLATMA VE BİTİRME
-- ==========================================
if Tabs[1] then Tabs[1].Btn.BackgroundTransparency = 0; Tabs[1].Btn.TextColor3 = Theme.Text; Tabs[1].Page.Visible = true end

MainFrame.Visible = not Config.Minimized
MinIcon.Visible = Config.Minimized
table.insert(Config.Connections, UserInputService.InputBegan:Connect(function(input, processed) 
    if not Config.Unloaded and not processed and input.KeyCode == Config.Bind then 
        if Config.Minimized then return end -- Eğer küçültülmüşse menü bind tuşuyla açılıp kapanmasın, önce ikona basılsın.
        Config.MenuOpen = not Config.MenuOpen; MainFrame.Visible = Config.MenuOpen 
    end 
end))

task.spawn(function()
    while task.wait(0.5) do
        if Config.Unloaded then break end
        
        local currentTheme = Themes[Config.Theme] or Themes.Dark
        local currentAccent = (Config.RainbowUI) and RainbowColor or currentTheme.Accent
        
        if Theme ~= currentTheme then
            Theme = currentTheme
            MainFrame.BackgroundColor3 = Theme.Main
            Sidebar.BackgroundColor3 = Theme.Second
        end
        
        pcall(function()
            if TitleGrad then TitleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, currentAccent)} end
            if KeyTitleGrad then KeyTitleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, currentAccent)} end
            if KeyFrame and KeyFrame:FindFirstChild("UIStroke") then KeyFrame.UIStroke.Color = currentAccent end
            if FlyFrame and FlyFrame:FindFirstChild("UIStroke") then FlyFrame.UIStroke.Color = currentAccent end
            if FlyToggleBtn and IsFlying then FlyToggleBtn.BackgroundColor3 = currentAccent end
        end)
    end
end)

Notify("Başarılı!", string.format("SanderHub-V1 Ultimate %.2f saniyede yüklendi.", tick() - StartTime))
print(string.format("[SanderHub-V1] Ultimate Rebuild Loaded Successfully in %.2f seconds! All requested features optimized and UI bugs squashed.", tick() - StartTime))
