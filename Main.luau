local MainModule = {
	Windows = {}
}

-- Services --
local TweenService = game:GetService("TweenService")

-- Types --
export type WindowSettings = {
	MainTitle : string,
	Draggable : boolean,
	MainFont : Enum.Font,
}

export type TabSettings = {
	TabName : string
}

-- Variables --
local parentforgui = identifyexecutor and game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MainGui = parentforgui:FindFirstChild("RandomGui")
if not MainGui then
	MainGui = Instance.new("ScreenGui")
	MainGui.Name = "RandomGui"
	MainGui.Parent = parentforgui
	MainGui.IgnoreGuiInset = true
	MainGui.ResetOnSpawn = false
end

local CurrentTab = nil

local ObjectsToTweenTransparency = {
	"Frame",
	"UIStroke",
	"TextLabel",
	"TextButton"
}

-- Tween --
local WindowTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

-- Functions --
local function CustomText(TextLabel : TextLabel, Text : string, Bold : boolean)
	TextLabel.RichText = true
	TextLabel.Text = "<b>" .. Text  .."</b>"
end

local function WindowEnabled(Window : Frame, state : boolean)
	local SizeToUse = state and UDim2.fromScale(0.6, 0.6) or UDim2.fromScale(0, 0)

	local Tween = TweenService:Create(Window, WindowTween, {Size = SizeToUse})
	Tween:Play()

	local WindowData = MainModule.Windows[Window]

	if state then
		for _, v in Window:GetDescendants() do
			if table.find(ObjectsToTweenTransparency, v.ClassName) then
				local customTransparency = WindowData.SavedTransparency[v] or 0
				v.Transparency = customTransparency
				if v:IsA("TextLabel") then
					v.TextTransparency = 0
				end
			end
		end
	else
		-- Tween Transparency
		for _, v in Window:GetDescendants() do
			if table.find(ObjectsToTweenTransparency, v.ClassName) then
				local vt = TweenService:Create(v, WindowTween, {Transparency = 1})
				vt:Play()
				if v:IsA("TextLabel") then
					vt.Completed:Once(function()
						v.TextTransparency = 1
					end)
				end
			end
		end
	end

	local ReOpenButton = WindowData.ReOpenButton

	ReOpenButton.Visible = not state
	ReOpenButton.Active = not state
end

local function SwitchTab(Tab : TextButton, WindowData)
	if CurrentTab == Tab then return end

	CurrentTab.BackgroundColor3 = Color3.new(0.352941, 0.352941, 0.352941)
	for _, v in WindowData.Tabs[CurrentTab].Objects do
		v.Visible = false
	end

	Tab.BackgroundColor3 = Color3.new(0.478431, 0.478431, 0.478431)
	for _, v in WindowData.Tabs[Tab].Objects do
		v.Visible = true
	end

	CurrentTab = Tab
end

-- Main

function MainModule:CreateWindow(WindowSettings : WindowSettings)
	local Window = Instance.new("Frame", MainGui)
	Window.Name = WindowSettings.MainTitle
	Window.Size = UDim2.fromScale(0.6, 0.6)
	Window.Position = UDim2.fromScale(0.5, 0.5)
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.BackgroundColor3 = Color3.new(0.168627, 0.168627, 0.168627)

	local RoundedCorners = Instance.new("UICorner", Window)
	RoundedCorners.CornerRadius = UDim.new(0, 5)

	local Border = Instance.new("UIStroke", Window)
	Border.Color = Color3.new(0.101961, 0.101961, 0.101961)
	Border.Thickness = 5

	local CloseButton = Instance.new("TextButton", Window)
	CloseButton.Position = UDim2.new(0.95, 0)
	CloseButton.Size = UDim2.fromScale(0.05, 0.04)
	CloseButton.BackgroundTransparency = 1
	CustomText(CloseButton, "X", true)
	CloseButton.ZIndex = 2
	CloseButton.TextColor3 = Color3.new(1, 1, 1)
	CloseButton.Font = WindowSettings.MainFont
	CloseButton.Name = "CloseButton"
	CloseButton.TextScaled = true

	CloseButton.MouseButton1Click:Connect(function()
		WindowEnabled(Window, false)
	end)

	local UIAspectRatio = Instance.new("UIAspectRatioConstraint", CloseButton)
	UIAspectRatio.AspectRatio = 1

	local Title = Instance.new("TextLabel", Window)
	Title.Text = WindowSettings.MainTitle
	Title.Size = UDim2.fromScale(1, 0.05)
	Title.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
	Title.Font = WindowSettings.MainFont
	Title.TextScaled = true
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Name = "Title"

	local Separator = Instance.new("Frame", Window)
	Separator.Position = UDim2.fromScale(0, 0.05)
	Separator.Size = UDim2.fromScale(1, 0.0035)
	Separator.BackgroundColor3 = Color3.new(1, 1, 1)
	Separator.Name = "Separator"

	local TabHolder = Instance.new("Frame", Window)
	TabHolder.Name = "TabHolder"
	TabHolder.Position = UDim2.fromScale(0, 0.051)
	TabHolder.Size = UDim2.fromScale(1, 0.1)
	TabHolder.BackgroundColor3 =Color3.new(0.0666667, 0.0666667, 0.0666667)
	TabHolder.BackgroundTransparency = 0.9

	local MainTabData = Instance.new("Frame", Window)
	MainTabData.Position = UDim2.fromScale(0.5, 0.57)
	MainTabData.AnchorPoint = Vector2.new(0.5, 0.5)
	MainTabData.Size = UDim2.fromScale(1, 0.85)
	MainTabData.BackgroundTransparency = 1

	local UIGridLayout = Instance.new("UIGridLayout", MainTabData)
	UIGridLayout.CellSize = UDim2.fromScale(0.9, 0.1)
	UIGridLayout.CellPadding = UDim2.fromScale(0.01, 0.01)
	UIGridLayout.FillDirection = Enum.FillDirection.Vertical
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local UIPaddingC = Instance.new("UIPadding", MainTabData)
	UIPaddingC.PaddingTop = UDim.new(0.05, 0)

	local UIListLayout = Instance.new("UIListLayout", TabHolder)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.Padding = UDim.new(0.05, 0)

	local UIPadding = Instance.new("UIPadding", TabHolder)
	UIPadding.PaddingLeft = UDim.new(0.01, 0)

	local ReOpenButton = Instance.new("TextButton",  MainGui)
	ReOpenButton.Position = UDim2.fromScale(0.85, 0.5)
	ReOpenButton.Size = UDim2.fromScale(0.1,0.1)
	ReOpenButton.Visible = false
	ReOpenButton.Active = false
	ReOpenButton.Name = "ReOpenButton"
	ReOpenButton.Text = "open " .. WindowSettings.MainTitle
	ReOpenButton.TextScaled = true
	ReOpenButton.Font = WindowSettings.MainFont

	ReOpenButton.MouseButton1Click:Connect(function()
		WindowEnabled(Window, true)
	end)

	MainModule.Windows[Window] = {
		TabHolder = TabHolder :: Frame ,
		Border = Border :: UIStroke ,
		ReOpenButton = ReOpenButton :: TextButton,
		SavedTransparency = {},
		Tabs = {},
	}

	local WindowData = MainModule.Windows[Window]

	for _, v in pairs(Window:GetDescendants()) do
		if table.find(ObjectsToTweenTransparency, v.ClassName) then
			WindowData.SavedTransparency[v] = v.Transparency
		end
	end

	local WindowFunctions = {}

	function WindowFunctions:CreateTab(TabSettings : TabSettings)
		local Tab = Instance.new("TextButton", TabHolder)
		Tab.Size = UDim2.fromScale(0.15, 0.55)
		Tab.TextScaled = true
		Tab.TextColor3 = Color3.new(1, 1, 1)
		Tab.BackgroundColor3 = Color3.new(0.352941, 0.352941, 0.352941)
		Tab.Text = TabSettings.TabName
		Tab.Font = WindowSettings.MainFont
		Tab.AutoButtonColor = false

		WindowData.Tabs[Tab] = {
			Objects = {}
		}

		if not CurrentTab then
			CurrentTab = Tab
			Tab.BackgroundColor3 = Color3.new(0.478431, 0.478431, 0.478431)
		end

		Tab.MouseButton1Click:Connect(function()
			SwitchTab(Tab, WindowData)
		end)

		local OutLine = Instance.new("UIStroke", Tab)
		OutLine.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		OutLine.Thickness = 2.3
		OutLine.LineJoinMode = Enum.LineJoinMode.Miter

		local TabFunctions = {}

		function TabFunctions:CreateButton(name : string, scriptfunc)
			local Button = Instance.new("TextButton", MainTabData)
			Button.Visible = CurrentTab == Tab
			Button.MouseButton1Click:Connect(scriptfunc)
			Button.ZIndex = 3
			Button.Text = name
			Button.TextColor3 = Color3.new(1, 1, 1)

			local Round = Instance.new("UICorner", Button)
			Round.CornerRadius = UDim.new(0, 5)

			Button.BackgroundColor3 = Color3.new(0.0941176, 0.0941176, 0.0941176)
			Button.AutoButtonColor = false

			Button.MouseButton1Down:Connect(function()
				Button.BackgroundColor3 = Color3.new(0.223529, 0.223529, 0.223529)
			end)

			Button.MouseButton1Up:Connect(function()
				Button.BackgroundColor3 = Color3.new(0.0941176, 0.0941176, 0.0941176)
			end)

			Button.MouseLeave:Connect(function()
				Button.BackgroundColor3 = Color3.new(0.0941176, 0.0941176, 0.0941176)
			end)

			table.insert(WindowData.Tabs[Tab].Objects, Button)
		end

		function TabFunctions:CreateToggle(name : string, scriptfunc)
			local Button = Instance.new("TextButton", MainTabData)
			Button.Visible = CurrentTab == Tab
			local bool = false
			Button.ZIndex = 3
			Button.Text = name
			Button.TextColor3 = Color3.new(1, 1, 1)

			local Round = Instance.new("UICorner", Button)
			Round.CornerRadius = UDim.new(0, 5)

			Button.BackgroundColor3 = Color3.new(0.0941176, 0.0941176, 0.0941176)
			Button.AutoButtonColor = false

			Button.MouseButton1Click:Connect(function()
				bool = not bool
				Button.BackgroundColor3 = bool and Color3.new(0.223529, 0.223529, 0.223529) or Color3.new(0.0941176, 0.0941176, 0.0941176)
				scriptfunc(bool)
			end)

			table.insert(WindowData.Tabs[Tab].Objects, Button)
		end

		return TabFunctions
	end

	return WindowFunctions
end

return MainModule
