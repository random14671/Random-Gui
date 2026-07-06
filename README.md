# Random-Gui

**This will be a script that will be able to generate a gui**

TO USE DO ```local MainModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/random14671/Random-Gui/refs/heads/main/Main.luau"))()```
```
--EXAMPLE :

local MainModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/random14671/Random-Gui/refs/heads/main/Main.luau"))()

local window = MainModule:CreateWindow({
	MainTitle = "Cool Cheats",
	MainFont = Enum.Font.Code,
	Draggable = true
})

local tab = window:CreateTab({
	TabName = "Extreme cool cheating player"
})

tab:CreateButton("Hack EVERYONE", function()
	print("Hello world")
end)

local isfarming = false

tab:CreateToggle("Toggle Test", function(bool)
	isfarming = bool
	if isfarming then
		task.spawn(function()
			while isfarming do
				print("hello worrrrrrrrrrrrrrrrrrrld toggle")
				task.wait(0.5)
			end
		end)
	end
end)

window:CreateTab({
	TabName = "Hacks"
})
```
### Inspired by rayfield / orion
