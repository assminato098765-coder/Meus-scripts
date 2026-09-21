--==================================================
-- SERVIÇOS
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- VARIÁVEIS
--==================================================

local selectedPlayer = nil
local following = false
local followConnection = nil

--==================================================
-- SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinhaGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- BOTÃO FLUTUANTE
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.fromOffset(55, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleButton.Text = "≡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 25
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

--==================================================
-- JANELA PRINCIPAL
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(360, 430)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.fromOffset(10, 5)
Title.BackgroundTransparency = 1
Title.Text = "Minha GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(115, 355)
Sidebar.Position = UDim2.fromOffset(10, 58)
Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

--==================================================
-- ÁREA DE CONTEÚDO
--==================================================

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -140, 1, -70)
Content.Position = UDim2.fromOffset(130, 58)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame

--==================================================
-- FUNÇÃO PARA CRIAR CANTOS
--==================================================

local function AddCorner(object, radius)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object

end

--==================================================
-- FUNÇÃO PARA LIMPAR CONTEÚDO
--==================================================

local function ClearContent()

	for _, object in ipairs(Content:GetChildren()) do
		object:Destroy()
	end

end

--==================================================
-- BOTÕES DAS CATEGORIAS
--==================================================

local Categories = {
	"Main",
	"Configurações",
	"Scripts"
}

local CategoryButtons = {}

local function CreateCategoryButton(name, order)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -16, 0, 40)
	Button.Position = UDim2.new(0, 8, 0, 10 + ((order - 1) * 50))

	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	Button.BorderSizePixel = 0

	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 13
	Button.Font = Enum.Font.Gotham

	Button.Parent = Sidebar

	AddCorner(Button, 8)

	CategoryButtons[name] = Button

	return Button

end

for i, name in ipairs(Categories) do
	CreateCategoryButton(name, i)
end

--==================================================
-- FUNÇÃO DE TÍTULO DAS ABAS
--==================================================

local function CreatePageTitle(text)

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -10, 0, 35)
	Label.Position = UDim2.fromOffset(5, 5)

	Label.BackgroundTransparency = 1

	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 17
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.Parent = Content

end

--==================================================
-- ABA MAIN
--==================================================

local function OpenMain()

	ClearContent()

	CreatePageTitle("Players no Servidor")

	-- Lista de jogadores
	local PlayerList = Instance.new("Frame")

	PlayerList.Size = UDim2.new(1, -10, 0, 200)
	PlayerList.Position = UDim2.fromOffset(5, 42)

	PlayerList.BackgroundTransparency = 1
	PlayerList.Parent = Content

	local function UpdatePlayers()

		for _, object in ipairs(PlayerList:GetChildren()) do
			object:Destroy()
		end

		local y = 0

		for _, target in ipairs(Players:GetPlayers()) do

			if target ~= LocalPlayer then

				local PlayerButton = Instance.new("TextButton")

				PlayerButton.Size = UDim2.new(1, 0, 0, 34)
				PlayerButton.Position = UDim2.fromOffset(0, y)

				PlayerButton.BackgroundColor3 =
					Color3.fromRGB(45, 45, 55)

				PlayerButton.BorderSizePixel = 0

				PlayerButton.Text = target.Name

				PlayerButton.TextColor3 =
					Color3.fromRGB(255, 255, 255)

				PlayerButton.TextSize = 13
				PlayerButton.Font = Enum.Font.Gotham

				PlayerButton.Parent = PlayerList

				AddCorner(PlayerButton, 8)

				PlayerButton.MouseButton1Click:Connect(function()

					selectedPlayer = target

					for _, button in ipairs(PlayerList:GetChildren()) do

						if button:IsA("TextButton") then

							button.BackgroundColor3 =
								Color3.fromRGB(45, 45, 55)

						end

					end

					PlayerButton.BackgroundColor3 =
						Color3.fromRGB(0, 120, 215)

				end)

				y += 39

			end

		end

		PlayerList.Size =
			UDim2.new(1, 0, 0, math.max(y, 40))

	end

	UpdatePlayers()

	-- Atualiza quando alguém entra
	Players.PlayerAdded:Connect(function()

		if MainFrame.Visible then
			UpdatePlayers()
		end

	end)

	-- Atualiza quando alguém sai
	Players.PlayerRemoving:Connect(function(target)

		if selectedPlayer == target then
			selectedPlayer = nil
		end

		if MainFrame.Visible then
			UpdatePlayers()
		end

	end)

	--==================================================
	-- BOTÃO SEGUIR
	--==================================================

	local FollowButton = Instance.new("TextButton")

	FollowButton.Size = UDim2.new(1, -10, 0, 38)
	FollowButton.Position = UDim2.fromOffset(5, 255)

	FollowButton.BackgroundColor3 =
		Color3.fromRGB(0, 140, 255)

	FollowButton.BorderSizePixel = 0

	FollowButton.Text = "Seguir Player"

	FollowButton.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	FollowButton.TextSize = 14
	FollowButton.Font = Enum.Font.GothamBold

	FollowButton.Parent = Content

	AddCorner(FollowButton, 8)

	FollowButton.MouseButton1Click:Connect(function()

		if not selectedPlayer then
			FollowButton.Text = "Selecione um player"
			task.wait(1)
			FollowButton.Text = "Seguir Player"
			return
		end

		following = not following

		if following then

			FollowButton.Text = "Parar de Seguir"

			FollowButton.BackgroundColor3 =
				Color3.fromRGB(200, 50, 50)

			if followConnection then
				followConnection:Disconnect()
			end

			followConnection =
				RunService.Heartbeat:Connect(function()

					if not following then
						return
					end

					local myCharacter =
						LocalPlayer.Character

					local targetCharacter =
						selectedPlayer.Character

					if not myCharacter
						or not targetCharacter then
						return
					end

					local myRoot =
						myCharacter:FindFirstChild("HumanoidRootPart")

					local targetRoot =
						targetCharacter:FindFirstChild("HumanoidRootPart")

					if not myRoot or not targetRoot then
						return
					end

					local distance = 4

					local difference =
						myRoot.Position - targetRoot.Position

					if difference.Magnitude < 0.01 then
						return
					end

					local direction =
						difference.Unit

					local targetPosition =
						targetRoot.Position
						+ direction * distance

					myRoot.CFrame =
						myRoot.CFrame:Lerp(
							CFrame.new(
								targetPosition,
								targetRoot.Position
							),
							0.18
						)

				end)

		else

			FollowButton.Text = "Seguir Player"

			FollowButton.BackgroundColor3 =
				Color3.fromRGB(0, 140, 255)

			if followConnection then
				followConnection:Disconnect()
				followConnection = nil
			end

		end

	end)

	--==================================================
	-- VELOCIDADE
	--==================================================

	local SpeedBox = Instance.new("TextBox")

	SpeedBox.Size = UDim2.new(0.55, 0, 0, 35)
	SpeedBox.Position = UDim2.fromOffset(5, 305)

	SpeedBox.BackgroundColor3 =
		Color3.fromRGB(40, 40, 48)

	SpeedBox.BorderSizePixel = 0

	SpeedBox.Text = "16"
	SpeedBox.PlaceholderText = "0 - 100"

	SpeedBox.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	SpeedBox.TextSize = 13
	SpeedBox.Font = Enum.Font.Gotham

	SpeedBox.ClearTextOnFocus = false

	SpeedBox.Parent = Content

	AddCorner(SpeedBox, 8)

	-- Botão aplicar
	local ApplyButton = Instance.new("TextButton")

	ApplyButton.Size = UDim2.new(0.35, 0, 0, 35)
	ApplyButton.Position = UDim2.new(0.62, 0, 0, 305)

	ApplyButton.BackgroundColor3 =
		Color3.fromRGB(0, 170, 80)

	ApplyButton.BorderSizePixel = 0

	ApplyButton.Text = "Aplicar"

	ApplyButton.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	ApplyButton.TextSize = 13
	ApplyButton.Font = Enum.Font.GothamBold

	ApplyButton.Parent = Content

	AddCorner(ApplyButton, 8)

	ApplyButton.MouseButton1Click:Connect(function()

		local value =
			tonumber(SpeedBox.Text)

		if not value then
			return
		end

		value = math.clamp(value, 0, 100)

		local Character =
			LocalPlayer.Character

		if not Character then
			return
		end

		local Humanoid =
			Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid.WalkSpeed = value
		end

	end)

	Content.CanvasSize =
		UDim2.new(0, 0, 0, 360)

end

--==================================================
-- ABA CONFIGURAÇÕES
--==================================================

local function OpenSettings()

	ClearContent()

	CreatePageTitle("Configurações")

	local Info = Instance.new("TextLabel")

	Info.Size = UDim2.new(1, -10, 0, 80)
	Info.Position = UDim2.fromOffset(5, 50)

	Info.BackgroundColor3 =
		Color3.fromRGB(35, 35, 43)

	Info.BorderSizePixel = 0

	Info.Text =
		"Configurações da GUI\n\nUse as outras abas para acessar as funções."

	Info.TextColor3 =
		Color3.fromRGB(220, 220, 220)

	Info.TextSize = 13
	Info.Font = Enum.Font.Gotham

	Info.TextWrapped = true

	Info.Parent = Content

	AddCorner(Info, 8)

end

--==================================================
-- ABA SCRIPTS
--==================================================

local function OpenScripts()

	ClearContent()

	CreatePageTitle("Scripts")

	local Info = Instance.new("TextLabel")

	Info.Size = UDim2.new(1, -10, 0, 80)
	Info.Position = UDim2.fromOffset(5, 50)

	Info.BackgroundColor3 =
		Color3.fromRGB(35, 35, 43)

	Info.BorderSizePixel = 0

	Info.Text =
		"Área para adicionar seus próprios scripts."

	Info.TextColor3 =
		Color3.fromRGB(220, 220, 220)

	Info.TextSize = 13
	Info.Font = Enum.Font.Gotham

	Info.TextWrapped = true

	Info.Parent = Content

	AddCorner(Info, 8)

end

--==================================================
-- NAVEGAÇÃO
--==================================================

CategoryButtons["Main"].MouseButton1Click:Connect(OpenMain)
CategoryButtons["Configurações"].MouseButton1Click:Connect(OpenSettings)
CategoryButtons["Scripts"].MouseButton1Click:Connect(OpenScripts)

-- Abre Main inicialmente
OpenMain()

--==================================================
-- ABRIR / FECHAR GUI
--==================================================

local GuiOpen = false

ToggleButton.MouseButton1Click:Connect(function()

	GuiOpen = not GuiOpen

	MainFrame.Visible = GuiOpen

end)

--==================================================
-- ARRASTAR GUI
--==================================================

local dragging = false
local dragStart = nil
local startPosition = nil

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = MainFrame.Position

	end

end)

Title.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta =
		input.Position - dragStart

	MainFrame.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

end)
