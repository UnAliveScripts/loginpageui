-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Potassium Premium — Full Admin System v16                    ║
-- ║  Change Pass/User • Kick • Blacklist • Full User Management   ║
-- ╚══════════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

do
    local e = playerGui:FindFirstChild("PotassiumPremium")
    if e then e:Destroy() end
end

-- ═══════════════════════════════════════════════════════════════════════
--  ADMIN CONFIG
-- ═══════════════════════════════════════════════════════════════════════

local ADMIN_CONFIG = {
    WebhookURL = "YOUR_DISCORD_WEBHOOK_URL_HERE",
    AdminPassword = "admin123",
    DefaultRole = "premium",
    
    -- Blacklist storage
    BlacklistedHWIDs = {},
    BlacklistedUserIDs = {},
}

-- ═══════════════════════════════════════════════════════════════════════
--  USER DATABASE
-- ═══════════════════════════════════════════════════════════════════════

local UserDatabase = {
    ["admin"]   = { Password = "admin123", Role = "developer" },
    ["dev"]     = { Password = "devpass",  Role = "developer" },
    ["premium"] = { Password = "prem123",  Role = "premium"   },
    ["user"]    = { Password = "user123",  Role = "premium"   },
}

-- ═══════════════════════════════════════════════════════════════════════
--  WEBHOOK FUNCTION
-- ═══════════════════════════════════════════════════════════════════════

local function sendWebhook(title, description, color, fields)
    if ADMIN_CONFIG.WebhookURL == "YOUR_DISCORD_WEBHOOK_URL_HERE" then return end
    
    local payload = {
        embeds = {{
            title = title,
            description = description,
            color = color or 0x5865F2,
            fields = fields or {},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = { text = "Potassium Admin • " .. player.Name }
        }}
    }
    
    pcall(function()
        local json = HttpService:JSONEncode(payload)
        if syn and syn.request then
            syn.request({Url = ADMIN_CONFIG.WebhookURL, Method = "POST", 
                Headers = {["Content-Type"] = "application/json"}, Body = json})
        elseif request then
            request({Url = ADMIN_CONFIG.WebhookURL, Method = "POST", 
                Headers = {["Content-Type"] = "application/json"}, Body = json})
        elseif http and http.request then
            http.request({Url = ADMIN_CONFIG.WebhookURL, Method = "POST", 
                Headers = {["Content-Type"] = "application/json"}, Body = json})
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
--  CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════

local CONFIG = {
    Window = {
        Width = 540, Height = 460, CornerRadius = 16, BorderThickness = 1,
        BgColor = Color3.fromRGB(12, 12, 14), BorderColor = Color3.fromRGB(34, 34, 40),
        Shadow = {Enabled = true, Image = "rbxassetid://6015897843", Transparency = 0.65, Offset = 40},
    },
    TitleBar = {
        Height = 34, BgColor = Color3.fromRGB(16, 16, 19), LineColor = Color3.fromRGB(36, 36, 42),
        Text = "Potassium", TextColor = Color3.fromRGB(190, 190, 198), 
        Font = Enum.Font.Gotham, TextSize = 14, TextLeft = 14,
    },
    Dots = {
        Enabled = true, RightOffset = 16, Size = 10, Spacing = 8,
        Colors = {Close = Color3.fromRGB(255, 95, 87), Minimize = Color3.fromRGB(255, 189, 46), Stroke = Color3.fromRGB(0, 0, 0)},
        HoverLerp = 0.22, HoverDur = 0.12,
    },
    Card = {
        MarginLeft = 22, MarginRight = 22, MarginTop = 18, MarginBottom = 18,
        CornerRadius = 16, BorderThickness = 1,
        BgColor = Color3.fromRGB(20, 20, 24), BorderColor = Color3.fromRGB(38, 38, 46),
        Shadow = {Enabled = true, Image = "rbxassetid://6015897843", Transparency = 0.7, Offset = 30},
    },
    Font = {
        Heading = Enum.Font.GothamBold, Subtitle = Enum.Font.Gotham, Input = Enum.Font.Gotham,
        InputPass = Enum.Font.GothamBold, Button = Enum.Font.GothamSemibold, Link = Enum.Font.Gotham,
    },
    TextSize = {
        Heading = 26, Subtitle = 14, Input = 14, InputPass = 17,
        Placeholder = 14, PlaceholderPass = 16, Button = 15, Link = 12,
    },
    Input = {
        Height = 46, CornerRadius = 10, BorderThickness = 1,
        IconSize = 16, IconLeft = 15, TextLeft = 40, Gap = 12,
        BgColor = Color3.fromRGB(24, 24, 28), BorderColor = Color3.fromRGB(42, 42, 50),
        BorderFocus = Color3.fromRGB(64, 64, 78), BorderError = Color3.fromRGB(185, 50, 50),
        IconColor = Color3.fromRGB(82, 82, 100), IconFocus = Color3.fromRGB(118, 118, 142),
        PlaceholderColor = Color3.fromRGB(72, 72, 88), TextColor = Color3.fromRGB(225, 225, 234),
    },
    Button = {
        Height = 46, CornerRadius = 10, BorderThickness = 1, GapFromInputs = 12,
        Text = "→]  Login", BgColor = Color3.fromRGB(30, 30, 36), BorderColor = Color3.fromRGB(48, 48, 58),
        HoverBg = Color3.fromRGB(38, 38, 46), HoverBorder = Color3.fromRGB(64, 64, 78),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
    Register = {
        Text = "Don't have an account? Create one", TextColor = Color3.fromRGB(130, 130, 148),
        HoverColor = Color3.fromRGB(180, 180, 200), GapFromButton = 10,
    },
    States = {
        LockBg = Color3.fromRGB(34, 16, 16), LockBd = Color3.fromRGB(72, 28, 28), LockTx = Color3.fromRGB(225, 65, 65),
        OkBg = Color3.fromRGB(16, 34, 22), OkBd = Color3.fromRGB(34, 82, 46), OkTx = Color3.fromRGB(72, 210, 130),
    },
    Drag = {
        Enabled = true, Smoothness = 0.15, DragAnywhere = true,
        ScaleDown = 0.97, ScaleDur = 0.15, ShadowDarken = 0.15,
    },
    Minimize = {
        CollapsedHeight = 36, AnimDur = 0.35,
        Easing = {Enum.EasingStyle.Quad, Enum.EasingDirection.Out},
    },
    Auth = {
        MaxAttempts = 3, LockoutTime = 30,
        HWIDWhitelist = {}, UserIDWhitelist = {}, StrictWhitelist = false,
        Roles = {
            premium = {name = "Premium", color = Color3.fromRGB(255, 215, 0)},
            developer = {name = "Developer", color = Color3.fromRGB(0, 255, 128)},
        },
    },
    Icons = {Mail = "rbxassetid://7734053495", Lock = "rbxassetid://7733992528"},
    Anim = {
        TweenDur = 0.25, ShakeDur = 0.03, FlashDur = 0.08, FlashHold = 1.5,
        FadeOutDur = 0.4, SuccessWait = 0.5,
        Intro = {WindowDur = 0.5, WindowEasing = {Enum.EasingStyle.Back, Enum.EasingDirection.Out},
            CardDur = 0.4, CardDelay = 0.1, TextStagger = 0.06},
    },
}

-- ═══════════════════════════════════════════════════════════════════════
--  SHORTCUTS
-- ═══════════════════════════════════════════════════════════════════════

local W = CONFIG.Window; local TB = CONFIG.TitleBar; local DT = CONFIG.Dots
local CD = CONFIG.Card; local IN = CONFIG.Input; local BT = CONFIG.Button
local RG = CONFIG.Register; local ST = CONFIG.States; local DR = CONFIG.Drag
local MN = CONFIG.Minimize; local AU = CONFIG.Auth; local AN = CONFIG.Anim
local IC = CONFIG.Icons

local WIN_W, WIN_H = W.Width, W.Height
local TB_H = TB.Height
local CARD_W = WIN_W - CD.MarginLeft - CD.MarginRight
local CARD_H = WIN_H - TB_H - CD.MarginTop - CD.MarginBottom
local CARD_X = CD.MarginLeft
local CARD_Y = TB_H + CD.MarginTop
local PAD_H = IN.IconLeft
local ELEM_W = CARD_W - (PAD_H * 2)

local Y_HEAD = 28
local Y_SUB = Y_HEAD + 34 + 10
local Y_USR = Y_SUB + 20 + 24
local Y_PWD = Y_USR + IN.Height + IN.Gap
local Y_BTN = Y_PWD + IN.Height + BT.GapFromInputs
local Y_REG = Y_BTN + BT.Height + RG.GapFromButton

-- ═══════════════════════════════════════════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════════════════════════════════════════

local function Tween(obj, props, dur, sty, dir)
    TweenService:Create(obj, TweenInfo.new(dur or AN.TweenDur, sty or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function getHWID()
    local h = "UNKNOWN"
    pcall(function()
        if gethwid then h = gethwid() else
            local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
            if ok and id then h = tostring(id) end
        end
    end)
    return tostring(h)
end

local function isBlacklisted()
    local myH, myU = getHWID(), player.UserId
    for _, v in ipairs(ADMIN_CONFIG.BlacklistedHWIDs) do
        if tostring(v) == myH then return true, "hwid" end
    end
    for _, v in ipairs(ADMIN_CONFIG.BlacklistedUserIDs) do
        if tonumber(v) == myU then return true, "userid" end
    end
    return false, "clean"
end

local function isWhitelisted()
    local hL, uL = AU.HWIDWhitelist, AU.UserIDWhitelist
    local hE, uE = (#hL == 0), (#uL == 0)
    if hE and uE then return true, "open" end
    local myH, myU = getHWID(), player.UserId
    local hM, uM = false, false
    for _, v in ipairs(hL) do if tostring(v) == myH then hM = true; break end end
    for _, v in ipairs(uL) do if tonumber(v) == myU then uM = true; break end end
    if AU.StrictWhitelist then
        return ((hE or hM) and (uE or uM)), (hM or uM) and "strict-pass" or "strict-fail"
    end
    return (hM or uM), (hM or uM) and "lax-pass" or "lax-fail"
end

-- ═══════════════════════════════════════════════════════════════════════
--  GUI SETUP
-- ═══════════════════════════════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "PotassiumPremium"; gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset = true
gui.DisplayOrder = 999; gui.Parent = playerGui

-- Window
local window = Instance.new("Frame")
window.Name = "Window"; window.Size = UDim2.new(0, WIN_W, 0, WIN_H)
window.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
window.BackgroundColor3 = W.BgColor; window.BorderSizePixel = 0
window.ClipsDescendants = true; window.ZIndex = 2; window.Parent = gui

Instance.new("UICorner", window).CornerRadius = UDim.new(0, W.CornerRadius)

local winStroke = Instance.new("UIStroke", window)
winStroke.Color = W.BorderColor; winStroke.Thickness = W.BorderThickness
winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local uiScale = Instance.new("UIScale"); uiScale.Parent = window

if W.Shadow.Enabled then
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"; s.Size = UDim2.new(1, W.Shadow.Offset, 1, W.Shadow.Offset)
    s.Position = UDim2.new(0, -W.Shadow.Offset/2, 0, -W.Shadow.Offset/2)
    s.BackgroundTransparency = 1; s.Image = W.Shadow.Image
    s.ImageColor3 = Color3.fromRGB(0,0,0); s.ImageTransparency = W.Shadow.Transparency
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,50,50)
    s.ZIndex = 1; s.Parent = window
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1, 0, 0, TB_H)
titleBar.BackgroundColor3 = TB.BgColor; titleBar.BorderSizePixel = 0
titleBar.ZIndex = 10; titleBar.Parent = window

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, W.CornerRadius)

local tbMask = Instance.new("Frame")
tbMask.Name = "BottomMask"; tbMask.Size = UDim2.new(1, 0, 0, W.CornerRadius)
tbMask.Position = UDim2.new(0, 0, 1, -W.CornerRadius)
tbMask.BackgroundColor3 = TB.BgColor; tbMask.BorderSizePixel = 0
tbMask.ZIndex = 10; tbMask.Parent = titleBar

local tbLine = Instance.new("Frame")
tbLine.Name = "Hairline"; tbLine.Size = UDim2.new(1, 0, 0, 1)
tbLine.Position = UDim2.new(0, 0, 1, -1); tbLine.BackgroundColor3 = TB.LineColor
tbLine.BorderSizePixel = 0; tbLine.ZIndex = 11; tbLine.Parent = titleBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Name = "Title"; titleLbl.Size = UDim2.new(0, 200, 0, TB.TextSize)
titleLbl.AnchorPoint = Vector2.new(0, 0.5); titleLbl.Position = UDim2.new(0, TB.TextLeft, 0.5, 0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = TB.Text; titleLbl.Font = TB.Font
titleLbl.TextSize = TB.TextSize; titleLbl.TextColor3 = TB.TextColor
titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.TextTruncate = Enum.TextTruncate.AtEnd; titleLbl.ZIndex = 11; titleLbl.Parent = titleBar

-- Dots
if DT.Enabled then
    local dotColors = {DT.Colors.Close, DT.Colors.Minimize}
    local minimized = false; local origSz, origPos

    local dotActions = {
        function() gui:Destroy() end,
        function()
            if minimized then
                Tween(window, {Size = origSz, Position = origPos}, MN.AnimDur, MN.Easing[1], MN.Easing[2])
                Tween(card, {BackgroundTransparency = 0}, MN.AnimDur)
                Tween(cardStroke, {Transparency = 0}, MN.AnimDur)
                for _, d in ipairs(card:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        Tween(d, {TextTransparency = 0}, MN.AnimDur)
                    elseif d:IsA("ImageLabel") and d.Name ~= "Shadow" then
                        Tween(d, {ImageTransparency = 0}, MN.AnimDur)
                    elseif d:IsA("Frame") then Tween(d, {BackgroundTransparency = 0}, MN.AnimDur)
                    elseif d:IsA("UIStroke") then Tween(d, {Transparency = 0}, MN.AnimDur) end
                end
                minimized = false
            else
                origSz = window.Size; origPos = window.Position
                local collapsed = UDim2.new(0, WIN_W, 0, MN.CollapsedHeight)
                for _, d in ipairs(card:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        Tween(d, {TextTransparency = 1}, 0.2)
                    elseif d:IsA("ImageLabel") and d.Name ~= "Shadow" then
                        Tween(d, {ImageTransparency = 1}, 0.2)
                    elseif d:IsA("Frame") then Tween(d, {BackgroundTransparency = 1}, 0.2)
                    elseif d:IsA("UIStroke") then Tween(d, {Transparency = 1}, 0.2) end
                end
                Tween(card, {BackgroundTransparency = 1}, 0.2)
                Tween(cardStroke, {Transparency = 1}, 0.2)
                task.delay(0.15, function()
                    Tween(window, {Size = collapsed}, MN.AnimDur, MN.Easing[1], MN.Easing[2])
                end)
                minimized = true
            end
        end,
    }

    for i = 1, 2 do
        local offset = DT.RightOffset + DT.Size/2 + (2-i)*(DT.Size + DT.Spacing)
        local dot = Instance.new("TextButton")
        dot.Name = "Dot" .. i; dot.Size = UDim2.new(0, DT.Size, 0, DT.Size)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(1, -offset, 0.5, 0)
        dot.BackgroundColor3 = dotColors[i]; dot.BorderSizePixel = 0
        dot.Text = ""; dot.AutoButtonColor = false; dot.ZIndex = 15
        dot.Parent = titleBar

        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local ds = Instance.new("UIStroke", dot)
        ds.Color = DT.Colors.Stroke; ds.Thickness = 0.5; ds.Transparency = 0.6

        local base = dotColors[i]
        dot.MouseEnter:Connect(function()
            Tween(dot, {BackgroundColor3 = base:Lerp(Color3.new(1,1,1), DT.HoverLerp)}, DT.HoverDur)
        end)
        dot.MouseLeave:Connect(function()
            Tween(dot, {BackgroundColor3 = base}, DT.HoverDur)
        end)
        dot.MouseButton1Click:Connect(dotActions[i])
    end
end

-- Card
local card = Instance.new("Frame")
card.Name = "Card"; card.Size = UDim2.new(0, CARD_W, 0, CARD_H)
card.Position = UDim2.new(0, CARD_X, 0, CARD_Y)
card.BackgroundColor3 = CD.BgColor; card.BorderSizePixel = 0
card.ZIndex = 5; card.Parent = window

Instance.new("UICorner", card).CornerRadius = UDim.new(0, CD.CornerRadius)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = CD.BorderColor; cardStroke.Thickness = CD.BorderThickness
cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

if CD.Shadow.Enabled then
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"; s.Size = UDim2.new(1, CD.Shadow.Offset, 1, CD.Shadow.Offset)
    s.Position = UDim2.new(0, -CD.Shadow.Offset/2, 0, -CD.Shadow.Offset/2)
    s.BackgroundTransparency = 1; s.Image = CD.Shadow.Image
    s.ImageColor3 = Color3.fromRGB(0,0,0); s.ImageTransparency = CD.Shadow.Transparency
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,50,50)
    s.ZIndex = 4; s.Parent = card
end

-- Heading
local heading = Instance.new("TextLabel")
heading.Name = "Heading"; heading.Size = UDim2.new(1, 0, 0, 34)
heading.Position = UDim2.new(0, 0, 0, Y_HEAD); heading.BackgroundTransparency = 1
heading.Text = "Welcome Back"; heading.Font = CONFIG.Font.Heading
heading.TextSize = CONFIG.TextSize.Heading; heading.TextColor3 = Color3.fromRGB(255,255,255)
heading.TextXAlignment = Enum.TextXAlignment.Center; heading.TextYAlignment = Enum.TextYAlignment.Center
heading.ZIndex = 6; heading.Parent = card

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"; subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, Y_SUB); subtitle.BackgroundTransparency = 1
subtitle.Text = "Sign in to continue to Potassium"; subtitle.Font = CONFIG.Font.Subtitle
subtitle.TextSize = CONFIG.TextSize.Subtitle; subtitle.TextColor3 = Color3.fromRGB(135,135,150)
subtitle.TextXAlignment = Enum.TextXAlignment.Center; subtitle.TextYAlignment = Enum.TextYAlignment.Center
subtitle.ZIndex = 6; subtitle.Parent = card

-- ═══════════════════════════════════════════════════════════════════════
--  INPUT FACTORY
-- ═══════════════════════════════════════════════════════════════════════

local function makeField(yPos, iconId, phText, isPass)
    local f = Instance.new("Frame")
    f.Name = phText .. "_Field"; f.Size = UDim2.new(0, ELEM_W, 0, IN.Height)
    f.Position = UDim2.new(0, PAD_H, 0, yPos); f.BackgroundColor3 = IN.BgColor
    f.BorderSizePixel = 0; f.ZIndex = 6; f.Parent = card

    Instance.new("UICorner", f).CornerRadius = UDim.new(0, IN.CornerRadius)

    local stroke = Instance.new("UIStroke", f)
    stroke.Color = IN.BorderColor; stroke.Thickness = IN.BorderThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"; icon.Size = UDim2.new(0, IN.IconSize, 0, IN.IconSize)
    icon.AnchorPoint = Vector2.new(0, 0.5); icon.Position = UDim2.new(0, IN.IconLeft, 0.5, 0)
    icon.BackgroundTransparency = 1; icon.Image = iconId; icon.ImageColor3 = IN.IconColor
    icon.ScaleType = Enum.ScaleType.Fit; icon.ZIndex = 8; icon.Parent = f

    local ph = Instance.new("TextLabel")
    ph.Name = "Placeholder"; ph.Size = UDim2.new(1, -(IN.TextLeft + 8), 1, 0)
    ph.Position = UDim2.new(0, IN.TextLeft, 0, 0); ph.BackgroundTransparency = 1
    ph.Text = phText; ph.Font = CONFIG.Font.Input
    ph.TextSize = isPass and CONFIG.TextSize.PlaceholderPass or CONFIG.TextSize.Placeholder
    ph.TextColor3 = IN.PlaceholderColor; ph.TextXAlignment = Enum.TextXAlignment.Left
    ph.TextYAlignment = Enum.TextYAlignment.Center; ph.ZIndex = 7; ph.Parent = f

    local box = Instance.new("TextBox")
    box.Name = "Box"; box.Size = UDim2.new(1, -(IN.TextLeft + 8), 1, 0)
    box.Position = UDim2.new(0, IN.TextLeft, 0, 0); box.BackgroundTransparency = 1
    box.Text = ""; box.Font = isPass and CONFIG.Font.InputPass or CONFIG.Font.Input
    box.TextSize = isPass and CONFIG.TextSize.InputPass or CONFIG.TextSize.Input
    box.TextColor3 = IN.TextColor; box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Center; box.ClearTextOnFocus = false
    box.ZIndex = 9; box.Parent = f

    local real = ""
    if isPass then
        local ok = pcall(function() box.TextInputType = Enum.TextInputType.Password end)
        if not ok then
            box:SetAttribute("RealText", "")
            box:GetPropertyChangedSignal("Text"):Connect(function()
                local cur = box.Text
                if cur == string.rep("•", #real) then return end
                real = (#cur > #real) and (real .. cur:sub(#real + 1)) or real:sub(1, #cur)
                box.Text = string.rep("•", #real); box:SetAttribute("RealText", real)
            end)
        end
    end

    local function syncPH() ph.Visible = (box.Text == "") end
    box:GetPropertyChangedSignal("Text"):Connect(syncPH)

    box.Focused:Connect(function()
        ph.Visible = false
        Tween(stroke, {Color = IN.BorderFocus}, AN.TweenDur)
        Tween(icon, {ImageColor3 = IN.IconFocus}, AN.TweenDur)
    end)
    box.FocusLost:Connect(function()
        syncPH()
        Tween(stroke, {Color = IN.BorderColor}, AN.TweenDur)
        Tween(icon, {ImageColor3 = IN.IconColor}, AN.TweenDur)
    end)

    return box, f, stroke
end

local userBox, _, userStroke = makeField(Y_USR, IC.Mail, "Username", false)
local passBox, _, passStroke = makeField(Y_PWD, IC.Lock, "Password", true)

-- Login Button
local btn = Instance.new("TextButton")
btn.Name = "LoginBtn"; btn.Size = UDim2.new(0, ELEM_W, 0, BT.Height)
btn.Position = UDim2.new(0, PAD_H, 0, Y_BTN); btn.BackgroundColor3 = BT.BgColor
btn.BorderSizePixel = 0; btn.Text = BT.Text; btn.Font = CONFIG.Font.Button
btn.TextSize = CONFIG.TextSize.Button; btn.TextColor3 = BT.TextColor
btn.TextYAlignment = Enum.TextYAlignment.Center; btn.AutoButtonColor = false
btn.ZIndex = 6; btn.Parent = card

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, BT.CornerRadius)

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = BT.BorderColor; btnStroke.Thickness = BT.BorderThickness
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

btn.MouseEnter:Connect(function()
    if locked then return end
    Tween(btn, {BackgroundColor3 = BT.HoverBg}, AN.TweenDur)
    Tween(btnStroke, {Color = BT.HoverBorder}, AN.TweenDur)
end)
btn.MouseLeave:Connect(function()
    if locked then return end
    Tween(btn, {BackgroundColor3 = BT.BgColor}, AN.TweenDur)
    Tween(btnStroke, {Color = BT.BorderColor}, AN.TweenDur)
end)

-- Register Link
local regLink = Instance.new("TextButton")
regLink.Name = "RegisterLink"; regLink.Size = UDim2.new(0, ELEM_W, 0, 20)
regLink.Position = UDim2.new(0, PAD_H, 0, Y_REG); regLink.BackgroundTransparency = 1
regLink.Text = RG.Text; regLink.Font = CONFIG.Font.Link
regLink.TextSize = CONFIG.TextSize.Link; regLink.TextColor3 = RG.TextColor
regLink.TextXAlignment = Enum.TextXAlignment.Center; regLink.TextYAlignment = Enum.TextYAlignment.Center
regLink.AutoButtonColor = false; regLink.ZIndex = 6; regLink.Parent = card

regLink.MouseEnter:Connect(function() Tween(regLink, {TextColor3 = RG.HoverColor}, AN.TweenDur) end)
regLink.MouseLeave:Connect(function() Tween(regLink, {TextColor3 = RG.TextColor}, AN.TweenDur) end)

-- ═══════════════════════════════════════════════════════════════════════
--  MODE SWITCHING
-- ═══════════════════════════════════════════════════════════════════════

local isRegisterMode = false
local confirmBox, _, confirmStroke

local function switchToRegister()
    isRegisterMode = true
    heading.Text = "Create Account"; subtitle.Text = "Join Potassium Premium"
    btn.Text = "→]  Create Account"
    confirmBox, _, confirmStroke = makeField(Y_PWD + IN.Height + IN.Gap, IC.Lock, "Confirm Password", true)
    confirmBox.Name = "ConfirmBox"
    btn.Position = UDim2.new(0, PAD_H, 0, Y_BTN + IN.Height + IN.Gap)
    regLink.Position = UDim2.new(0, PAD_H, 0, Y_REG + IN.Height + IN.Gap)
    regLink.Text = "Already have an account? Sign in"
end

local function switchToLogin()
    isRegisterMode = false
    heading.Text = "Welcome Back"; subtitle.Text = "Sign in to continue to Potassium"
    btn.Text = BT.Text
    if confirmBox and confirmBox.Parent then confirmBox.Parent:Destroy(); confirmBox = nil; confirmStroke = nil end
    btn.Position = UDim2.new(0, PAD_H, 0, Y_BTN)
    regLink.Position = UDim2.new(0, PAD_H, 0, Y_REG)
    regLink.Text = RG.Text
end

regLink.MouseButton1Click:Connect(function()
    if isRegisterMode then switchToLogin() else switchToRegister() end
end)

-- ═══════════════════════════════════════════════════════════════════════
--  ADMIN PANEL — Full User Management
-- ═══════════════════════════════════════════════════════════════════════

local adminPanelVisible = false
local adminPanel, adminOverlay

local function createAdminPanel()
    -- Dark overlay behind panel
    adminOverlay = Instance.new("Frame")
    adminOverlay.Name = "AdminOverlay"
    adminOverlay.Size = UDim2.new(1, 0, 1, 0)
    adminOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    adminOverlay.BackgroundTransparency = 0.5
    adminOverlay.ZIndex = 99
    adminOverlay.Parent = gui
    
    adminPanel = Instance.new("Frame")
    adminPanel.Name = "AdminPanel"
    adminPanel.Size = UDim2.new(0, 420, 0, 520)
    adminPanel.Position = UDim2.new(0.5, -210, 0.5, -260)
    adminPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    adminPanel.BorderSizePixel = 0
    adminPanel.ZIndex = 100
    adminPanel.Parent = gui
    
    Instance.new("UICorner", adminPanel).CornerRadius = UDim.new(0, 14)
    
    local adminStroke = Instance.new("UIStroke", adminPanel)
    adminStroke.Color = Color3.fromRGB(48, 48, 60); adminStroke.Thickness = 1
    
    -- Shadow
    local aShadow = Instance.new("ImageLabel")
    aShadow.Name = "Shadow"; aShadow.Size = UDim2.new(1, 40, 1, 40)
    aShadow.Position = UDim2.new(0, -20, 0, -20); aShadow.BackgroundTransparency = 1
    aShadow.Image = "rbxassetid://6015897843"; aShadow.ImageColor3 = Color3.fromRGB(0,0,0)
    aShadow.ImageTransparency = 0.5; aShadow.ScaleType = Enum.ScaleType.Slice
    aShadow.SliceCenter = Rect.new(49,49,50,50); aShadow.ZIndex = 99
    aShadow.Parent = adminPanel
    
    -- Title
    local aTitle = Instance.new("TextLabel")
    aTitle.Size = UDim2.new(1, -20, 0, 28); aTitle.Position = UDim2.new(0, 10, 0, 12)
    aTitle.BackgroundTransparency = 1; aTitle.Text = "⚡ Admin Panel"
    aTitle.Font = Enum.Font.GothamBold; aTitle.TextSize = 18
    aTitle.TextColor3 = Color3.fromRGB(255, 215, 0); aTitle.ZIndex = 101
    aTitle.Parent = adminPanel
    
    local aSub = Instance.new("TextLabel")
    aSub.Size = UDim2.new(1, -20, 0, 18); aSub.Position = UDim2.new(0, 10, 0, 40)
    aSub.BackgroundTransparency = 1; aSub.Text = "User Management & Blacklist"
    aSub.Font = Enum.Font.Gotham; aSub.TextSize = 12
    aSub.TextColor3 = Color3.fromRGB(140, 140, 160); aSub.ZIndex = 101
    aSub.Parent = adminPanel
    
    -- Divider
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -20, 0, 1); div.Position = UDim2.new(0, 10, 0, 64)
    div.BackgroundColor3 = Color3.fromRGB(40, 40, 50); div.BorderSizePixel = 0
    div.ZIndex = 101; div.Parent = adminPanel
    
    -- Helper to create admin input
    local function makeAdminInput(y, placeholder, isPass)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 380, 0, 34); f.Position = UDim2.new(0.5, -190, 0, y)
        f.BackgroundColor3 = Color3.fromRGB(26, 26, 30); f.BorderSizePixel = 0
        f.ZIndex = 101; f.Parent = adminPanel
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local s = Instance.new("UIStroke", f)
        s.Color = Color3.fromRGB(45, 45, 55); s.Thickness = 1
        
        local b = Instance.new("TextBox")
        b.Size = UDim2.new(1, -16, 1, 0); b.Position = UDim2.new(0, 8, 0, 0)
        b.BackgroundTransparency = 1; b.Text = ""; b.PlaceholderText = placeholder
        b.Font = Enum.Font.Gotham; b.TextSize = 13
        b.TextColor3 = Color3.fromRGB(225, 225, 234)
        b.PlaceholderColor3 = Color3.fromRGB(80, 80, 96)
        b.ClearTextOnFocus = false; b.ZIndex = 102; b.Parent = f
        
        if isPass then
            pcall(function() b.TextInputType = Enum.TextInputType.Password end)
        end
        
        return b, f
    end
    
    -- Helper to create admin button
    local function makeAdminButton(y, text, color, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 380, 0, 32); b.Position = UDim2.new(0.5, -190, 0, y)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 36); b.BorderSizePixel = 0
        b.Text = text; b.Font = Enum.Font.GothamSemibold; b.TextSize = 13
        b.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        b.AutoButtonColor = false; b.ZIndex = 101; b.Parent = adminPanel
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        
        local bs = Instance.new("UIStroke", b)
        bs.Color = Color3.fromRGB(48, 48, 58); bs.Thickness = 1
        
        b.MouseEnter:Connect(function()
            Tween(b, {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}, 0.15)
        end)
        b.MouseLeave:Connect(function()
            Tween(b, {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}, 0.15)
        end)
        b.MouseButton1Click:Connect(callback)
        return b
    end
    
    -- Section: Change Password
    local lbl1 = Instance.new("TextLabel")
    lbl1.Size = UDim2.new(0, 380, 0, 18); lbl1.Position = UDim2.new(0.5, -190, 0, 74)
    lbl1.BackgroundTransparency = 1; lbl1.Text = "Change User Password"
    lbl1.Font = Enum.Font.GothamBold; lbl1.TextSize = 13
    lbl1.TextColor3 = Color3.fromRGB(200, 200, 210); lbl1.ZIndex = 101
    lbl1.TextXAlignment = Enum.TextXAlignment.Left; lbl1.Parent = adminPanel
    
    local chgUserBox, _ = makeAdminInput(96, "Username", false)
    local chgPassBox, _ = makeAdminInput(134, "New Password", true)
    
    makeAdminButton(174, "📝 Change Password", Color3.fromRGB(100, 180, 255), function()
        local target = chgUserBox.Text; local newPass = chgPassBox.Text
        if target == "" or newPass == "" then return end
        if UserDatabase[target] then
            local oldPass = UserDatabase[target].Password
            UserDatabase[target].Password = newPass
            chgUserBox.Text = ""; chgPassBox.Text = ""
            chgUserBox.PlaceholderText = "✓ Password changed for " .. target
            sendWebhook("Password Changed", "Admin changed password for **" .. target .. "**", 0x64B4FF,
                {{name = "Target", value = target, inline = true},
                 {name = "Admin", value = player.Name, inline = true}})
        else
            chgUserBox.Text = ""; chgUserBox.PlaceholderText = "✗ User not found!"
        end
    end)
    
    -- Section: Change Username
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(0, 380, 0, 18); lbl2.Position = UDim2.new(0.5, -190, 0, 216)
    lbl2.BackgroundTransparency = 1; lbl2.Text = "Change Username"
    lbl2.Font = Enum.Font.GothamBold; lbl2.TextSize = 13
    lbl2.TextColor3 = Color3.fromRGB(200, 200, 210); lbl2.ZIndex = 101
    lbl2.TextXAlignment = Enum.TextXAlignment.Left; lbl2.Parent = adminPanel
    
    local oldNameBox, _ = makeAdminInput(238, "Current Username", false)
    local newNameBox, _ = makeAdminInput(276, "New Username", false)
    
    makeAdminButton(316, "🏷️ Change Username", Color3.fromRGB(150, 120, 255), function()
        local oldName = oldNameBox.Text; local newName = newNameBox.Text
        if oldName == "" or newName == "" then return end
        if UserDatabase[oldName] then
            if UserDatabase[newName] then
                newNameBox.Text = ""; newNameBox.PlaceholderText = "✗ Name already taken!"
                return
            end
            UserDatabase[newName] = UserDatabase[oldName]
            UserDatabase[oldName] = nil
            oldNameBox.Text = ""; newNameBox.Text = ""
            oldNameBox.PlaceholderText = "✓ Renamed to " .. newName
            sendWebhook("Username Changed", "Admin renamed **" .. oldName .. "** to **" .. newName .. "**", 0x9678FF,
                {{name = "Old Name", value = oldName, inline = true},
                 {name = "New Name", value = newName, inline = true},
                 {name = "Admin", value = player.Name, inline = true}})
        else
            oldNameBox.Text = ""; oldNameBox.PlaceholderText = "✗ User not found!"
        end
    end)
    
    -- Section: Assign Premium
    local lbl3 = Instance.new("TextLabel")
    lbl3.Size = UDim2.new(0, 380, 0, 18); lbl3.Position = UDim2.new(0.5, -190, 0, 358)
    lbl3.BackgroundTransparency = 1; lbl3.Text = "Assign Premium Role"
    lbl3.Font = Enum.Font.GothamBold; lbl3.TextSize = 13
    lbl3.TextColor3 = Color3.fromRGB(200, 200, 210); lbl3.ZIndex = 101
    lbl3.TextXAlignment = Enum.TextXAlignment.Left; lbl3.Parent = adminPanel
    
    local premBox, _ = makeAdminInput(380, "Username to upgrade", false)
    
    makeAdminButton(420, "⭐ Make Premium", Color3.fromRGB(255, 215, 0), function()
        local target = premBox.Text
        if target == "" then return end
        if UserDatabase[target] then
            UserDatabase[target].Role = "premium"
            premBox.Text = ""
            premBox.PlaceholderText = "✓ " .. target .. " is now Premium!"
            sendWebhook("Premium Assigned", "User **" .. target .. "** upgraded to Premium", 0xFFD700,
                {{name = "Target", value = target, inline = true},
                 {name = "Admin", value = player.Name, inline = true}})
        else
            premBox.Text = ""; premBox.PlaceholderText = "✗ User not found!"
        end
    end)
    
    -- Section: Blacklist
    local lbl4 = Instance.new("TextLabel")
    lbl4.Size = UDim2.new(0, 380, 0, 18); lbl4.Position = UDim2.new(0.5, -190, 0, 462)
    lbl4.BackgroundTransparency = 1; lbl4.Text = "Blacklist (HWID or UserID)"
    lbl4.Font = Enum.Font.GothamBold; lbl4.TextSize = 13
    lbl4.TextColor3 = Color3.fromRGB(200, 200, 210); lbl4.ZIndex = 101
    lbl4.TextXAlignment = Enum.TextXAlignment.Left; lbl4.Parent = adminPanel
    
    local blBox, _ = makeAdminInput(484, "HWID or UserID to blacklist", false)
    
    makeAdminButton(524, "🚫 Blacklist", Color3.fromRGB(255, 80, 80), function()
        local id = blBox.Text
        if id == "" then return end
        if tonumber(id) then
            table.insert(ADMIN_CONFIG.BlacklistedUserIDs, tonumber(id))
            blBox.Text = ""; blBox.PlaceholderText = "✓ UserID " .. id .. " blacklisted"
            sendWebhook("UserID Blacklisted", "UserID **" .. id .. "** has been blacklisted", 0xFF5050,
                {{name = "Blacklisted ID", value = id, inline = true},
                 {name = "Admin", value = player.Name, inline = true}})
        else
            table.insert(ADMIN_CONFIG.BlacklistedHWIDs, id)
            blBox.Text = ""; blBox.PlaceholderText = "✓ HWID blacklisted"
            sendWebhook("HWID Blacklisted", "HWID has been blacklisted", 0xFF5050,
                {{name = "HWID", value = id:sub(1, 20) .. "...", inline = true},
                 {name = "Admin", value = player.Name, inline = true}})
        end
    end)
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 380, 0, 28); closeBtn.Position = UDim2.new(0.5, -190, 0, 486)
    closeBtn.BackgroundTransparency = 1; closeBtn.Text = "Close Panel"
    closeBtn.Font = Enum.Font.Gotham; closeBtn.TextSize = 12
    closeBtn.TextColor3 = Color3.fromRGB(140, 140, 160); closeBtn.ZIndex = 101
    closeBtn.Parent = adminPanel
    
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, {TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.15) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, {TextColor3 = Color3.fromRGB(140, 140, 160)}, 0.15) end)
    closeBtn.MouseButton1Click:Connect(function()
        adminPanel:Destroy(); adminOverlay:Destroy()
        adminPanelVisible = false
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
--  LOGIC — Login, Register, Blacklist Check
-- ═══════════════════════════════════════════════════════════════════════

local attempts, locked = 0, false

local function shake()
    local base = card.Position
    local seq = {10, -10, 8, -8, 6, -6, 4, -4, 2, -2}
    for _, ox in ipairs(seq) do
        Tween(card, {Position = base + UDim2.new(0, ox, 0, 0)}, AN.ShakeDur, Enum.EasingStyle.Linear)
        task.wait(AN.ShakeDur)
    end
    Tween(card, {Position = base}, 0.06)
end

local function flashErr(s)
    Tween(s, {Color = IN.BorderError}, AN.FlashDur)
    task.delay(AN.FlashHold, function() Tween(s, {Color = IN.BorderColor}, 0.4) end)
end

btn.MouseButton1Click:Connect(function()
    if locked then return end

    local uname = userBox.Text
    local pword = passBox:GetAttribute("RealText")
    if not pword or pword == "" then pword = passBox.Text end

    -- Check blacklist first
    local isBl, blReason = isBlacklisted()
    if isBl then
        task.spawn(shake)
        flashErr(userStroke); flashErr(passStroke)
        print("[Potassium] You are blacklisted (" .. blReason .. ")")
        return
    end

    -- Admin panel trigger
    if uname == "admin" and not isRegisterMode and not adminPanelVisible then
        adminPanelVisible = true
        createAdminPanel()
        return
    end

    if uname == "" or pword == "" then
        task.spawn(shake)
        if uname == "" then flashErr(userStroke) end
        if pword == "" then flashErr(passStroke) end
        return
    end

    -- REGISTER MODE
    if isRegisterMode then
        local confirmPw = confirmBox:GetAttribute("RealText")
        if not confirmPw or confirmPw == "" then confirmPw = confirmBox.Text end
        if pword ~= confirmPw then task.spawn(shake); flashErr(passStroke); flashErr(confirmStroke); return end
        if UserDatabase[uname] then task.spawn(shake); flashErr(userStroke); return end
        
        UserDatabase[uname] = {Password = pword, Role = ADMIN_CONFIG.DefaultRole}
        sendWebhook("New Registration", "New user registered", 0x00FF80,
            {{name = "Username", value = uname, inline = true},
             {name = "Role", value = ADMIN_CONFIG.DefaultRole, inline = true},
             {name = "HWID", value = getHWID():sub(1, 20) .. "...", inline = false}})
        
        btn.Text = "✓  Account Created"; btn.TextColor3 = ST.OkTx
        Tween(btn, {BackgroundColor3 = ST.OkBg}, 0.28)
        Tween(btnStroke, {Color = ST.OkBd}, 0.28)
        task.wait(1.0)
        switchToLogin(); userBox.Text = uname; passBox.Text = ""
        passBox:SetAttribute("RealText", ""); btn.Text = BT.Text
        btn.TextColor3 = BT.TextColor
        Tween(btn, {BackgroundColor3 = BT.BgColor}, 0.25)
        Tween(btnStroke, {Color = BT.BorderColor}, 0.25)
        return
    end

    -- LOGIN MODE
    local acc = UserDatabase[uname]
    if not acc or acc.Password ~= pword then
        attempts += 1; task.spawn(shake); flashErr(userStroke); flashErr(passStroke)
        if attempts >= AU.MaxAttempts then
            locked = true; local t = AU.LockoutTime
            btn.Text = string.format("Locked — %ds", t); btn.TextColor3 = ST.LockTx
            Tween(btn, {BackgroundColor3 = ST.LockBg}, 0.2)
            Tween(btnStroke, {Color = ST.LockBd}, 0.2)
            task.spawn(function()
                while t > 0 do task.wait(1); t -= 1; btn.Text = string.format("Locked — %ds", t) end
                locked = false; attempts = 0; btn.Text = BT.Text; btn.TextColor3 = BT.TextColor
                Tween(btn, {BackgroundColor3 = BT.BgColor}, 0.25)
                Tween(btnStroke, {Color = BT.BorderColor}, 0.25)
            end)
        end
        return
    end

    sendWebhook("Successful Login", "User logged in", 0x5865F2,
        {{name = "Username", value = uname, inline = true},
         {name = "Role", value = acc.Role, inline = true},
         {name = "HWID", value = getHWID():sub(1, 20) .. "...", inline = false}})

    if acc.Role ~= "developer" then
        local ok, why = isWhitelisted()
        if not ok then task.spawn(shake); flashErr(userStroke); flashErr(passStroke); return end
    end

    -- Success — instant simultaneous fade
    local role = AU.Roles[acc.Role]
    btn.Text = "✓  Welcome back"; btn.TextColor3 = ST.OkTx
    Tween(btn, {BackgroundColor3 = ST.OkBg}, 0.28)
    Tween(btnStroke, {Color = ST.OkBd}, 0.28)
    task.wait(AN.SuccessWait)

    local allObjects = {}
    for _, d in ipairs(card:GetDescendants()) do table.insert(allObjects, d) end
    table.insert(allObjects, card); table.insert(allObjects, cardStroke)
    table.insert(allObjects, window); table.insert(allObjects, winStroke)
    
    for _, obj in ipairs(allObjects) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            Tween(obj, {TextTransparency = 1, BackgroundTransparency = 1}, AN.FadeOutDur)
        elseif obj:IsA("ImageLabel") then
            Tween(obj, {ImageTransparency = 1, BackgroundTransparency = 1}, AN.FadeOutDur)
        elseif obj:IsA("Frame") then
            Tween(obj, {BackgroundTransparency = 1}, AN.FadeOutDur)
        elseif obj:IsA("UIStroke") then
            Tween(obj, {Transparency = 1}, AN.FadeOutDur) end
    end

    if W.Shadow.Enabled and window:FindFirstChild("Shadow") then
        Tween(window.Shadow, {ImageTransparency = 1}, AN.FadeOutDur) end

    task.wait(AN.FadeOutDur + 0.15)
    print(("[Potassium] ✓ Granted | User=%s | Role=%s"):format(uname, role.name))
    if acc.Role == "developer" then print("[Potassium] Developer Mode — All features unlocked") end
    task.delay(0.2, function() gui:Destroy() end)
end)

-- ═══════════════════════════════════════════════════════════════════════
--  DRAG SYSTEM
-- ═══════════════════════════════════════════════════════════════════════

local drag, dSt, dPos = false, nil, nil
local targetPos = window.Position
local dragConn

local dragTargets = {titleBar}
if DR.DragAnywhere then table.insert(dragTargets, card); table.insert(dragTargets, window) end

local function startDrag(input)
    drag = true; dSt = input.Position; dPos = window.Position; targetPos = dPos
    Tween(uiScale, {Scale = DR.ScaleDown}, DR.ScaleDur)
    if W.Shadow.Enabled and window:FindFirstChild("Shadow") then
        local darker = math.max(0, W.Shadow.Transparency - DR.ShadowDarken)
        Tween(window.Shadow, {ImageTransparency = darker}, DR.ScaleDur) end
    if dragConn then dragConn:Disconnect() end
    dragConn = RunService.Heartbeat:Connect(function()
        if not drag then dragConn:Disconnect(); dragConn = nil; return end
        window.Position = window.Position:Lerp(targetPos, DR.Smoothness)
    end)
end

for _, target in ipairs(dragTargets) do
    target.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            startDrag(i) end
    end)
end

UserInputService.InputChanged:Connect(function(i)
    if not drag then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local delta = i.Position - dSt
        targetPos = UDim2.new(dPos.X.Scale, dPos.X.Offset + delta.X, dPos.Y.Scale, dPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if drag then drag = false
            Tween(uiScale, {Scale = 1}, DR.ScaleDur, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            if W.Shadow.Enabled and window:FindFirstChild("Shadow") then
                Tween(window.Shadow, {ImageTransparency = W.Shadow.Transparency}, DR.ScaleDur) end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════
--  INTRO ANIMATION
-- ═══════════════════════════════════════════════════════════════════════

window.Size = UDim2.new(0, 0, 0, 0); window.Position = UDim2.new(0.5, 0, 0.5, 0)
window.BackgroundTransparency = 1; winStroke.Transparency = 1
if W.Shadow.Enabled then window.Shadow.ImageTransparency = 1 end

Tween(window, {Size = UDim2.new(0, WIN_W, 0, WIN_H),
    Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2), BackgroundTransparency = 0},
    AN.Intro.WindowDur, AN.Intro.WindowEasing[1], AN.Intro.WindowEasing[2])
Tween(winStroke, {Transparency = 0}, 0.5)
if W.Shadow.Enabled then Tween(window.Shadow, {ImageTransparency = W.Shadow.Transparency}, 0.6) end

card.Position = UDim2.new(0, CARD_X, 0, CARD_Y + 25)
card.BackgroundTransparency = 1; cardStroke.Transparency = 1
if CD.Shadow.Enabled then card.Shadow.ImageTransparency = 1 end

task.delay(AN.Intro.CardDelay, function()
    Tween(card, {Position = UDim2.new(0, CARD_X, 0, CARD_Y), BackgroundTransparency = 0},
        AN.Intro.CardDur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Tween(cardStroke, {Transparency = 0}, AN.Intro.CardDur + 0.05)
    if CD.Shadow.Enabled then
        Tween(card.Shadow, {ImageTransparency = CD.Shadow.Transparency}, AN.Intro.CardDur + 0.1) end
end)

local staggerDelay = 0
for _, child in ipairs(card:GetDescendants()) do
    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
        child.TextTransparency = 1
        task.delay(AN.Intro.CardDelay + 0.15 + staggerDelay, function()
            Tween(child, {TextTransparency = 0}, 0.4) end)
        staggerDelay += AN.Intro.TextStagger
    elseif child:IsA("ImageLabel") and child.Name ~= "Shadow" then
        child.ImageTransparency = 1
        task.delay(AN.Intro.CardDelay + 0.2 + staggerDelay, function()
            Tween(child, {ImageTransparency = 0}, 0.4) end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════
