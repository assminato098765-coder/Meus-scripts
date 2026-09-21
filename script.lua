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

-- Velocidade do tween de seguir
-- 0.01 = muito lento
-- 0.05 = lento
-- 0.10 = médio
-- 0.20 = rápido
-- 0.50 = muito rápido
local TweenSpeed = 0.05

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MinhaGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local function AddCorner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
end

--==================================================
-- BOTÃO FLUTUANTE
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.fromOffset(55, 55)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "≡"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 25
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

AddCorner(ToggleButton, 100)

--==================================================
-- JANELA
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 450)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

AddCorner(MainFrame, 14)

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.fromOffset(10, 5)
Title.BackgroundTransparency = 1
Title.Text = "Minha GUI"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(115, 375)
Sidebar.Position = UDim2.fromOffset(10, 58)
Sidebar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

AddCorner(Sidebar, 10)

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -140, 1, -70)
Content.Position = UDim2.fromOffset(130, 58)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new(0, 0, 0, 500)
Content.Parent = MainFrame

--==================================================
-- LIMPAR CONTEÚDO
--==================================================

local function ClearContent()
	for _, object in ipairs(Content:GetChildren()) do
		object:Destroy()
	end
end

--==================================================
-- TÍTULO DA ABA
--==================================================

local function CreatePageTitle(text)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 35)
	label.Position = UDim2.fromOffset(5, 5)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 17
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = Content

end

--==================================================
-- CATEGORIAS
--==================================================

local Categories = {
	"Main",
	"Configurações",
	"Scripts"
}

local CategoryButtons = {}

for i, name in ipairs(Categories) do

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, -16, 0, 40)
	Button.Position =
		UDim2.new(0, 8, 0, 10 + ((i - 1) * 50))

	Button.BackgroundColor3 =
		Color3.fromRGB(45, 45, 55)

	Button.BorderSizePixel = 0
	Button.Text = name
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.TextSize = 13
	Button.Font = Enum.Font.Gotham

	Button.Parent = Sidebar

	AddCorner(Button, 8)

	CategoryButtons[name] = Button

end

--==================================================
-- ABA MAIN
--==================================================

local function OpenMain()

	ClearContent()

	CreatePageTitle("Players no Servidor")

	--==================================================
	-- LISTA DE PLAYERS
	--==================================================

	local PlayerList = Instance.new("ScrollingFrame")

	PlayerList.Size =
		UDim2.new(1, -10, 0, 190)

	PlayerList.Position =
		UDim2.fromOffset(5, 42)

	PlayerList.BackgroundTransparency = 1
	PlayerList.BorderSizePixel = 0

	PlayerList.ScrollBarThickness = 5
	PlayerList.ScrollingDirection =
		Enum.ScrollingDirection.Y

	PlayerList.CanvasSize =
		UDim2.new(0, 0, 0, 0)

	PlayerList.Parent = Content

	local PlayerLayout = Instance.new("UIListLayout")

	PlayerLayout.Padding =
		UDim.new(0, 5)

	PlayerLayout.SortOrder =
		Enum.SortOrder.Name

	PlayerLayout.Parent = PlayerList

	--==================================================
	-- ATUALIZAR PLAYERS
	--==================================================

	local function UpdatePlayers()

		for _, object in ipairs(PlayerList:GetChildren()) do
			if object:IsA("TextButton") then
				object:Destroy()
			end
		end

		for _, target in ipairs(Players:GetPlayers()) do

			if target ~= LocalPlayer then

				local Button = Instance.new("TextButton")

				Button.Size =
					UDim2.new(1, -5, 0, 34)

				Button.BackgroundColor3 =
					Color3.fromRGB(45, 45, 55)

				Button.BorderSizePixel = 0

				Button.Text =
					target.Name

				Button.TextColor3 =
					Color3.new(1, 1, 1)

				Button.TextSize = 13
				Button.Font = Enum.Font.Gotham

				Button.Parent = PlayerList

				AddCorner(Button, 8)

				Button.MouseButton1Click:Connect(function()

					selectedPlayer = target

					for _, other in ipairs(
						PlayerList:GetChildren()
					) do

						if other:IsA("TextButton") then
							other.BackgroundColor3 =
								Color3.fromRGB(45, 45, 55)
						end

					end

					Button.BackgroundColor3 =
						Color3.fromRGB(0, 120, 215)

				end)

			end

		end

		task.wait()

		PlayerList.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				PlayerLayout.AbsoluteContentSize.Y + 5
			)

	end

	UpdatePlayers()

	--==================================================
	-- BOTÃO SEGUIR
	--==================================================

	local FollowButton = Instance.new("TextButton")

	FollowButton.Size =
		UDim2.new(1, -10, 0, 38)

	FollowButton.Position =
		UDim2.fromOffset(5, 245)

	FollowButton.BackgroundColor3 =
		Color3.fromRGB(0, 140, 255)

	FollowButton.BorderSizePixel = 0

	FollowButton.Text =
		"Seguir Player"

	FollowButton.TextColor3 =
		Color3.new(1, 1, 1)

	FollowButton.TextSize = 14
	FollowButton.Font = Enum.Font.GothamBold

	FollowButton.Parent = Content

	AddCorner(FollowButton, 8)

	--==================================================
	-- SEGUIR
	--==================================================

	FollowButton.MouseButton1Click:Connect(function()

		if not selectedPlayer then

			FollowButton.Text =
				"Selecione um player"

			task.wait(1)

			FollowButton.Text =
				"Seguir Player"

			return
		end

		following = not following

		if following then

			FollowButton.Text =
				"Parar de Seguir"

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

					if not selectedPlayer
						or not selectedPlayer.Parent then

						following = false
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
						myCharacter:FindFirstChild(
							"HumanoidRootPart"
						)

					local targetRoot =
						targetCharacter:FindFirstChild(
							"HumanoidRootPart"
						)

					if not myRoot
						or not targetRoot then
						return
					end

					-- Distância que ficará do jogador
					local Distance = 5

					local Difference =
						myRoot.Position -
						targetRoot.Position

					if Difference.Magnitude < 0.01 then
						return
					end

					local Direction =
						Difference.Unit

					local TargetPosition =
						targetRoot.Position +
						Direction * Distance

					--==================================================
					-- TWEEN SPEED
					--==================================================
					--
					-- Este valor controla SOMENTE a velocidade
					-- do movimento de seguir.
					--
					-- 0.01 = extremamente lento
					-- 0.03 = muito lento
					-- 0.05 = lento
					-- 0.10 = médio
					-- 0.20 = rápido
					-- 0.50 = muito rápido
					--

					myRoot.CFrame =
						myRoot.CFrame:Lerp(
							CFrame.new(
								TargetPosition,
								targetRoot.Position
							),
							TweenSpeed
						)

				end)

		else

			FollowButton.Text =
				"Seguir Player"

			FollowButton.BackgroundColor3 =
				Color3.fromRGB(0, 140, 255)

			if followConnection then
				followConnection:Disconnect()
				followConnection = nil
			end

		end

	end)

	--==================================================
	-- TWEEN SPEED
	--==================================================

	local TweenLabel = Instance.new("TextLabel")

	TweenLabel.Size =
		UDim2.new(1, -10, 0, 25)

	TweenLabel.Position =
		UDim2.fromOffset(5, 295)

	TweenLabel.BackgroundTransparency = 1

	TweenLabel.Text =
		"Tween Speed: " ..
		string.format("%.2f", TweenSpeed)

	TweenLabel.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	TweenLabel.TextSize = 13
	TweenLabel.Font = Enum.Font.GothamBold

	TweenLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	TweenLabel.Parent = Content

	--==================================================
	-- SLIDER DO TWEEN
	--==================================================

	local SliderBackground =
		Instance.new("Frame")

	SliderBackground.Size =
		UDim2.new(1, -10, 0, 10)

	SliderBackground.Position =
		UDim2.fromOffset(5, 325)

	SliderBackground.BackgroundColor3 =
		Color3.fromRGB(50, 50, 58)

	SliderBackground.BorderSizePixel = 0

	SliderBackground.Parent = Content

	AddCorner(SliderBackground, 10)

	local SliderFill =
		Instance.new("Frame")

	SliderFill.Size =
		UDim2.new(
			TweenSpeed / 0.5,
			0,
			1,
			0
		)

	SliderFill.BackgroundColor3 =
		Color3.fromRGB(0, 140, 255)

	SliderFill.BorderSizePixel = 0
	SliderFill.Parent = SliderBackground

	AddCorner(SliderFill, 10)

	local SliderButton =
		Instance.new("TextButton")

	SliderButton.Size =
		UDim2.fromOffset(20, 20)

	SliderButton.AnchorPoint =
		Vector2.new(0.5, 0.5)

	SliderButton.Position =
		UDim2.new(
			TweenSpeed / 0.5,
			0,
			0.5,
			0
		)

	SliderButton.BackgroundColor3 =
		Color3.fromRGB(255, 255, 255)

	SliderButton.Text = ""
	SliderButton.BorderSizePixel = 0

	SliderButton.Parent =
		SliderBackground

	AddCorner(SliderButton, 100)

	--==================================================
	-- CONTROLE DO SLIDER
	--==================================================

	local sliderDragging = false

	local function UpdateTweenSlider(x)

		local relative =
			math.clamp(
				(x - SliderBackground.AbsolutePosition.X)
				/ SliderBackground.AbsoluteSize.X,
				0,
				1
			)

		-- mínimo 0.01 / máximo 0.50
		TweenSpeed =
			math.clamp(
				relative * 0.5,
				0.01,
				0.5
			)

		local normalized =
			TweenSpeed / 0.5

		SliderFill.Size =
			UDim2.new(
				normalized,
				0,
				1,
				0
			)

		SliderButton.Position =
			UDim2.new(
				normalized,
				0,
				0.5,
				0
			)

		TweenLabel.Text =
			"Tween Speed: " ..
			string.format("%.2f", TweenSpeed)

	end

	SliderButton.InputBegan:Connect(function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			sliderDragging = true

		end

	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			sliderDragging = false

		end

	end)

	UserInputService.InputChanged:Connect(function(input)

		if not sliderDragging then
			return
		end

		if input.UserInputType ==
			Enum.UserInputType.MouseMovement
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			UpdateTweenSlider(input.Position.X)

		end

	end)

	--==================================================
	-- WALK SPEED
	--==================================================

	local SpeedBox =
		Instance.new("TextBox")

	SpeedBox.Size =
		UDim2.new(0.55, 0, 0, 35)

	SpeedBox.Position =
		UDim2.fromOffset(5, 350)

	SpeedBox.BackgroundColor3 =
		Color3.fromRGB(40, 40, 48)

	SpeedBox.BorderSizePixel = 0

	SpeedBox.Text = "16"

	SpeedBox.PlaceholderText =
		"WalkSpeed 0-100"

	SpeedBox.TextColor3 =
		Color3.new(1, 1, 1)

	SpeedBox.TextSize = 13
	SpeedBox.Font = Enum.Font.Gotham

	SpeedBox.ClearTextOnFocus = false

	SpeedBox.Parent = Content

	AddCorner(SpeedBox, 8)

	--==================================================
	-- APLICAR WALKSPEED
	--==================================================

	local ApplyButton =
		Instance.new("TextButton")

	ApplyButton.Size =
		UDim2.new(0.35, 0, 0, 35)

	ApplyButton.Position =
		UDim2.new(0.62, 0, 0, 350)

	ApplyButton.BackgroundColor3 =
		Color3.fromRGB(0, 170, 80)

	ApplyButton.BorderSizePixel = 0

	ApplyButton.Text =
		"Aplicar"

	ApplyButton.TextColor3 =
		Color3.new(1, 1, 1)

	ApplyButton.TextSize = 13
	ApplyButton.Font = Enum.Font.GothamBold

	ApplyButton.Parent = Content

	AddCorner(ApplyButton, 8)

	ApplyButton.MouseButton1Click:Connect(function()

		local Value =
			tonumber(SpeedBox.Text)

		if not Value then
			return
		end

		Value =
			math.clamp(Value, 0, 100)

		local Character =
			LocalPlayer.Character

		if not Character then
			return
		end

		local Humanoid =
			Character:FindFirstChildOfClass(
				"Humanoid"
			)

		if Humanoid then
			Humanoid.WalkSpeed = Value
		end

	end)

	Content.CanvasSize =
		UDim2.new(0, 0, 0, 400)

end

--==================================================
-- CONFIGURAÇÕES
--==================================================

local function OpenSettings()

	ClearContent()

	CreatePageTitle(
		"Configurações"
	)

	local Info =
		Instance.new("TextLabel")

	Info.Size =
		UDim2.new(1, -10, 0, 100)

	Info.Position =
		UDim2.fromOffset(5, 50)

	Info.BackgroundColor3 =
		Color3.fromRGB(35, 35, 43)

	Info.BorderSizePixel = 0

	Info.Text =
		"Configurações\n\nTween Speed controla a velocidade do movimento de seguir.\nWalkSpeed controla a velocidade do personagem."

	Info.TextColor3 =
		Color3.fromRGB(220, 220, 220)

	Info.TextSize = 12
	Info.Font = Enum.Font.Gotham
	Info.TextWrapped = true

	Info.Parent = Content

	AddCorner(Info, 8)

end

--==================================================
-- SCRIPTS
--==================================================

local function OpenScripts()

	ClearContent()

	CreatePageTitle("Scripts")

	local Info =
		Instance.new("TextLabel")

	Info.Size =
		UDim2.new(1, -10, 0, 90)

	Info.Position =
		UDim2.fromOffset(5, 50)

	Info.BackgroundColor3 =
		Color3.fromRGB(35, 35, 43)

	Info.BorderSizePixel = 0

	Info.Text =
		"Área reservada para adicionar outros scripts."

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

CategoryButtons["Main"].MouseButton1Click:Connect(
	OpenMain
)

CategoryButtons["Configurações"].MouseButton1Click:Connect(
	OpenSettings
)

CategoryButtons["Scripts"].MouseButton1Click:Connect(
	OpenScripts
)

OpenMain()

--==================================================
-- ABRIR / FECHAR
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

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart =
			input.Position

		startPosition =
			MainFrame.Position

	end

end)

Title.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~=
		Enum.UserInputType.MouseMovement
		and input.UserInputType ~=
		Enum.UserInputType.Touch then

		return

	end

	local Delta =
		input.Position -
		dragStart

	MainFrame.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + Delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + Delta.Y
		)

end)
