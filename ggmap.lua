--[[
    GG MAP - VERSÃO BETA V14 (KEY NO MENU + COPIAR SERVER)
]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURAÇÕES E SISTEMA DE KEY
-- ==========================================
local KEY_CORRETA = "GGEXPLOITS26"
local TEMPO_TESTE = 3600 -- 1 HORA
local ARQUIVO_TEMPO = "GG_MAP_V14_Beta.txt" 
local ARQUIVO_KEY = "GG_MAP_KeySalva_V14.txt"

local function PegaTempoSalvo()
    local sucesso, conteudo = pcall(function()
        if readfile and isfile and isfile(ARQUIVO_TEMPO) then return readfile(ARQUIVO_TEMPO) end
    end)
    return sucesso and tonumber(conteudo) or nil
end

local function PegaKeySalva()
    local sucesso, conteudo = pcall(function()
        if readfile and isfile and isfile(ARQUIVO_KEY) then return readfile(ARQUIVO_KEY) end
    end)
    return sucesso and conteudo or nil
end

local function SalvarTempo(tempo)
    pcall(function() if writefile then writefile(ARQUIVO_TEMPO, tostring(tempo)) end end)
end

local function SalvarKey(key)
    pcall(function() if writefile then writefile(ARQUIVO_KEY, key) end end)
end

local KeySalva = PegaKeySalva()
local temKey = (KeySalva == KEY_CORRETA)
local tempoRestante = PegaTempoSalvo() or TEMPO_TESTE
local TimeLabelGlobal = nil

-- ==========================================
-- FUNÇÃO DE DRAG (ARRASTAR)
-- ==========================================
local function MakeDraggable(guiObject, dragArea)
    local dragging, dragInput, dragStart, startPos
    local area = dragArea or guiObject
    
    area.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    area.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- SKYS (BÁSICOS E EXTRAS)
-- ==========================================
local SkysBasicos = {
    Realista = { Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293", Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288" },
    Espaco = { Bk = "rbxassetid://1417494030", Dn = "rbxassetid://1417494146", Ft = "rbxassetid://1417494253", Lf = "rbxassetid://1417494375", Rt = "rbxassetid://1417494486", Up = "rbxassetid://1417494600" },
    Sunset = { Bk = "rbxassetid://271042516", Dn = "rbxassetid://271077243", Ft = "rbxassetid://271042556", Lf = "rbxassetid://271042310", Rt = "rbxassetid://271042467", Up = "rbxassetid://271041815" },
    Tropical = { Bk = "rbxassetid://169210090", Dn = "rbxassetid://169210108", Ft = "rbxassetid://169210121", Lf = "rbxassetid://169210133", Rt = "rbxassetid://169210143", Up = "rbxassetid://169210149" },
    Sombrio = { Bk = "rbxassetid://114128626690223", Dn = "rbxassetid://114128626690223", Ft = "rbxassetid://114128626690223", Lf = "rbxassetid://114128626690223", Rt = "rbxassetid://114128626690223", Up = "rbxassetid://114128626690223" }
}

local SkysExtras = {
    Vaporwave = { Bk = "rbxassetid://191546360", Dn = "rbxassetid://191546360", Ft = "rbxassetid://191546391", Lf = "rbxassetid://191546427", Rt = "rbxassetid://191546632", Up = "rbxassetid://191546647" },
    Galaxia = { Bk = "rbxassetid://77457117307953", Dn = "rbxassetid://77457117307953", Ft = "rbxassetid://77457117307953", Lf = "rbxassetid://77457117307953", Rt = "rbxassetid://77457117307953", Up = "rbxassetid://77457117307953" },
    Skeleton = { Bk = "rbxassetid://169585459", Dn = "rbxassetid://169585475", Ft = "rbxassetid://169585485", Lf = "rbxassetid://169585502", Rt = "rbxassetid://169585515", Up = "rbxassetid://169585459" }
}

local CeuAtual = "Realista"

local function AplicarGraficos(tipoCeu, isExtra)
    pcall(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("ColorCorrectionEffect") then v:Destroy() end
        end

        Lighting.Brightness = 3
        Lighting.EnvironmentDiffuseScale = 0.6
        Lighting.EnvironmentSpecularScale = 0.8
        Lighting.GlobalShadows = true
        
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = 2
        bloom.Size = 30
        bloom.Parent = Lighting
        
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Intensity = 0.2
        sunRays.Parent = Lighting
        
        local sky = Instance.new("Sky")
        local dados
        
        if isExtra and SkysExtras[tipoCeu] then
            dados = SkysExtras[tipoCeu]
        elseif SkysBasicos[tipoCeu] then
            dados = SkysBasicos[tipoCeu]
        else
            dados = SkysBasicos["Realista"]
        end
        
        sky.SkyboxBk = dados.Bk; sky.SkyboxDn = dados.Dn; sky.SkyboxFt = dados.Ft
        sky.SkyboxLf = dados.Lf; sky.SkyboxRt = dados.Rt; sky.SkyboxUp = dados.Up
        sky.Parent = Lighting
        
        if tipoCeu == "Espaco" or tipoCeu == "Sombrio" or tipoCeu == "Galaxia" then
            Lighting.ClockTime = 0; Lighting.Brightness = 0.5
        elseif tipoCeu == "Sunset" or tipoCeu == "Vaporwave" then
            Lighting.ClockTime = 18; Lighting.Brightness = 1.5
        else
            Lighting.ClockTime = 14; Lighting.Brightness = 3
        end
        
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Density = 0.3; atmosphere.Offset = 0.2; atmosphere.Parent = Lighting
    end)
end

local function LimparGraficos()
    pcall(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("ColorCorrectionEffect") then 
                v:Destroy() 
            end
        end
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
    end)
end

-- ==========================================
-- FUNÇÕES DE FLY E SPEED
-- ==========================================
local voando = false
local velocidade = 16

local function ConfigurarFly()
    voando = not voando
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    if voando then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "GG_Fly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
        task.spawn(function()
            while voando and bv.Parent do
                task.wait()
                bv.Velocity = Vector3.new(0, 50, 0)
            end
        end)
    else
        if hrp:FindFirstChild("GG_Fly") then hrp.GG_Fly:Destroy() end
    end
end

local function MudarSpeed()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if velocidade == 16 then
            char.Humanoid.WalkSpeed = 100
            velocidade = 100
        else
            char.Humanoid.WalkSpeed = 16
            velocidade = 16
        end
    end
end

-- ==========================================
-- CONSTRUÇÃO DA UI
-- ==========================================
if CoreGui:FindFirstChild("GG_MAP_HUB") then CoreGui.GG_MAP_HUB:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GG_MAP_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999 
ScreenGui.Parent = CoreGui

local CorFundo = Color3.fromRGB(15, 15, 20)
local CorNeon = Color3.fromRGB(0, 255, 255)
local CorTexto = Color3.fromRGB(255, 255, 255)
local CorErro = Color3.fromRGB(255, 50, 50)
local CorOuro = Color3.fromRGB(255, 215, 0)

local AbrirMenuPrincipal 

local function CriarTelaKey()
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 380, 0, 300)
    KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
    KeyFrame.BackgroundColor3 = CorFundo
    KeyFrame.Parent = ScreenGui
    MakeDraggable(KeyFrame)

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 12)
    KeyCorner.Parent = KeyFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "GG MAP | AUTENTICAÇÃO"
    Title.TextColor3 = CorNeon
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = KeyFrame

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -40, 0, 40)
    Subtitle.Position = UDim2.new(0, 20, 0, 50)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = (tempoRestante <= 0) and "Seu tempo acabou! Use a Key oficial." or "Copie o convite do Discord abaixo e insira sua Key."
    Subtitle.TextColor3 = (tempoRestante <= 0) and CorErro or CorTexto
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 13
    Subtitle.TextWrapped = true
    Subtitle.Parent = KeyFrame

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.8, 0, 0, 40)
    DiscordBtn.Position = UDim2.new(0.1, 0, 0, 100)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.Text = "Copiar Convite (Discord)"
    DiscordBtn.TextColor3 = CorTexto
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 15
    DiscordBtn.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0, 155)
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    KeyInput.TextColor3 = CorNeon
    KeyInput.PlaceholderText = "Digite a Key de Acesso..."
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 15
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyFrame

    local BtnOK = Instance.new("TextButton")
    BtnOK.Size = UDim2.new(0, 50, 0, 30)
    BtnOK.Position = UDim2.new(1, -55, 0, 5)
    BtnOK.BackgroundColor3 = CorNeon
    BtnOK.Text = "OK"
    BtnOK.TextColor3 = CorFundo
    BtnOK.Font = Enum.Font.GothamBold
    BtnOK.TextSize = 14
    BtnOK.Parent = KeyInput

    local EnterBtn = Instance.new("TextButton")
    EnterBtn.Size = UDim2.new(0.8, 0, 0, 40)
    EnterBtn.Position = UDim2.new(0.1, 0, 0, 215)
    EnterBtn.BackgroundColor3 = (tempoRestante <= 0) and CorOuro or CorNeon
    EnterBtn.Text = (tempoRestante <= 0) and "ENTRAR COM KEY" or "ENTRAR (TESTE ATIVO)"
    EnterBtn.TextColor3 = CorFundo
    EnterBtn.Font = Enum.Font.GothamBold
    EnterBtn.TextSize = 15
    EnterBtn.Parent = KeyFrame

    DiscordBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("https://discord.gg/XSaycraHjN")
                DiscordBtn.Text = "LINK COPIADO!"
                DiscordBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                task.wait(2)
                DiscordBtn.Text = "Copiar Convite (Discord)"
                DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            end
        end)
    end)
    
    BtnOK.MouseButton1Click:Connect(function()
        KeyInput:ReleaseFocus() 
    end)

    EnterBtn.MouseButton1Click:Connect(function()
        if UserInputService:GetFocusedTextBox() then
            UserInputService:GetFocusedTextBox():ReleaseFocus()
        end

        if KeyInput.Text == KEY_CORRETA then
            temKey = true
            SalvarKey(KEY_CORRETA)
            KeyFrame:Destroy()
            if AbrirMenuPrincipal then AbrirMenuPrincipal() end
        elseif tempoRestante > 0 then
            KeyFrame:Destroy()
            if AbrirMenuPrincipal then AbrirMenuPrincipal() end
        else
            KeyInput.Text = "KEY INCORRETA OU EXPIRADA!"
            KeyInput.TextColor3 = CorErro
            task.wait(2)
            KeyInput.Text = ""
            KeyInput.TextColor3 = CorNeon
        end
    end)
end

local BotaoAbrir = Instance.new("TextButton")
BotaoAbrir.Name = "BotaoAbrir"
BotaoAbrir.Size = UDim2.new(0, 50, 0, 50)
BotaoAbrir.Position = UDim2.new(0, 20, 0.5, -25)
BotaoAbrir.BackgroundColor3 = CorFundo
BotaoAbrir.Text = "GG"
BotaoAbrir.TextColor3 = CorNeon
BotaoAbrir.Font = Enum.Font.GothamBold
BotaoAbrir.TextSize = 18
BotaoAbrir.BorderSizePixel = 2
BotaoAbrir.BorderColor3 = CorNeon
BotaoAbrir.Visible = false
BotaoAbrir.Parent = ScreenGui
MakeDraggable(BotaoAbrir)

local BtnAbrirCorner = Instance.new("UICorner")
BtnAbrirCorner.CornerRadius = UDim.new(1, 0)
BtnAbrirCorner.Parent = BotaoAbrir

-- ==========================================
-- MENU PRINCIPAL
-- ==========================================
AbrirMenuPrincipal = function()
    AplicarGraficos(CeuAtual, false)

    if ScreenGui:FindFirstChild("MainFrame") then ScreenGui.MainFrame:Destroy() end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    -- Aumentei a altura para caber os botões de key no modo teste
    MainFrame.Size = UDim2.new(0, 280, 0, 560) 
    MainFrame.Position = UDim2.new(0, 20, 0.5, -280)
    MainFrame.BackgroundColor3 = CorFundo
    MainFrame.Parent = ScreenGui
    MakeDraggable(MainFrame)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TopBar.Parent = MainFrame
    MakeDraggable(MainFrame, TopBar)

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Size = UDim2.new(1, -80, 1, 0)
    MainTitle.Position = UDim2.new(0, 15, 0, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = temKey and "GG MAP | PREMIUM 👑" or "GG MAP | MENU"
    MainTitle.TextColor3 = temKey and CorOuro or CorNeon
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.TextSize = 16
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Parent = TopBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = CorFundo
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = CorErro
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = CorTexto
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TopBar

    local startY = 50

    -- Se NÃO tem Key, mostra o tempo e as opções de Key
    if not temKey then
        TimeLabelGlobal = Instance.new("TextLabel")
        TimeLabelGlobal.Size = UDim2.new(0.9, 0, 0, 30)
        TimeLabelGlobal.Position = UDim2.new(0.05, 0, 0, startY)
        TimeLabelGlobal.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TimeLabelGlobal.TextColor3 = CorErro
        TimeLabelGlobal.Font = Enum.Font.GothamBold
        TimeLabelGlobal.TextSize = 14
        TimeLabelGlobal.Parent = MainFrame
        
        local mins = math.floor(tempoRestante / 60)
        local secs = tempoRestante % 60
        TimeLabelGlobal.Text = string.format("⏳ Teste: %02d:%02d restantes", mins, secs)
        
        -- BOTÃO PARA COPIAR O LINK DO SERVIDOR
        local BtnCopyServer = Instance.new("TextButton")
        BtnCopyServer.Size = UDim2.new(0.9, 0, 0, 30)
        BtnCopyServer.Position = UDim2.new(0.05, 0, 0, startY + 35)
        BtnCopyServer.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        BtnCopyServer.Text = "📋 Copiar Link do Servidor"
        BtnCopyServer.TextColor3 = CorTexto
        BtnCopyServer.Font = Enum.Font.GothamBold
        BtnCopyServer.TextSize = 12
        BtnCopyServer.Parent = MainFrame
        
        BtnCopyServer.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then
                    setclipboard("https://discord.gg/XSaycraHjN")
                    BtnCopyServer.Text = "✅ LINK COPIADO!"
                    task.wait(2)
                    BtnCopyServer.Text = "📋 Copiar Link do Servidor"
                end
            end)
        end)

        -- CAIXA PARA COLOCAR A KEY DIRETO NO MENU
        local KeyInputMenu = Instance.new("TextBox")
        KeyInputMenu.Size = UDim2.new(0.6, 0, 0, 30)
        KeyInputMenu.Position = UDim2.new(0.05, 0, 0, startY + 75)
        KeyInputMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        KeyInputMenu.TextColor3 = CorNeon
        KeyInputMenu.PlaceholderText = "Inserir Key VIP..."
        KeyInputMenu.Font = Enum.Font.Gotham
        KeyInputMenu.TextSize = 12
        KeyInputMenu.ClearTextOnFocus = false
        KeyInputMenu.Parent = MainFrame

        local BtnAtivarKey = Instance.new("TextButton")
        BtnAtivarKey.Size = UDim2.new(0.25, 0, 0, 30)
        BtnAtivarKey.Position = UDim2.new(0.7, 0, 0, startY + 75)
        BtnAtivarKey.BackgroundColor3 = CorOuro
        BtnAtivarKey.Text = "Ativar"
        BtnAtivarKey.TextColor3 = CorFundo
        BtnAtivarKey.Font = Enum.Font.GothamBold
        BtnAtivarKey.TextSize = 12
        BtnAtivarKey.Parent = MainFrame

        BtnAtivarKey.MouseButton1Click:Connect(function()
            if KeyInputMenu.Text == KEY_CORRETA then
                temKey = true
                SalvarKey(KEY_CORRETA)
                ScreenGui:Destroy()
                -- Recria o script do zero como Premium
                loadstring(game:HttpGet("https://pastefy.app/VlcX1klE/raw"))() -- ou apenas reinicie a UI
            else
                KeyInputMenu.Text = "Key Incorreta!"
                KeyInputMenu.TextColor3 = CorErro
                task.wait(1.5)
                KeyInputMenu.Text = ""
                KeyInputMenu.TextColor3 = CorNeon
            end
        end)

        startY = startY + 120 -- Empurra o resto do menu para baixo
    else
        TimeLabelGlobal = nil
    end

    local function CriarBotao(texto, posY, tamanhoX, corTexto)
        local btn = Instance.new("TextButton")
        btn.Size = tamanhoX or UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.Text = texto
        btn.TextColor3 = corTexto or CorTexto
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = MainFrame
        return btn
    end

    -- CÉUS
    local LabelCeu = Instance.new("TextLabel")
    LabelCeu.Size = UDim2.new(0.9, 0, 0, 20)
    LabelCeu.Position = UDim2.new(0.05, 0, 0, startY)
    LabelCeu.BackgroundTransparency = 1
    LabelCeu.Text = "Céus Básicos:"
    LabelCeu.TextColor3 = CorNeon
    LabelCeu.Font = Enum.Font.GothamBold
    LabelCeu.TextSize = 12
    LabelCeu.TextXAlignment = Enum.TextXAlignment.Left
    LabelCeu.Parent = MainFrame

    local BtnRealista = CriarBotao("Realista", startY + 25, UDim2.new(0.42, 0, 0, 30))
    BtnRealista.Position = UDim2.new(0.05, 0, 0, startY + 25
