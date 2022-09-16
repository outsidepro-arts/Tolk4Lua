tolk = require "tolklua"
gui = require "iuplua"
gui.SetGlobal("UTF8MODE", "Yes")

-- We need the IUPP values conversion
iuptoboolean = {
["ON"] = true,
[1] = true,
["OFF"] = false,
[0] = false
}

checkLoadedBtn = gui.button{title="Check Tolk loading status"}
function checkLoadedBtn:action(	)
local msg = string.format("Tolk library now is %s!", ({[false]="not loaded", [true]="loaded"})[tolk ~= nil])
msg = msg..string.format('\nTolk %s send a text to speech synthesizer.', ({[true]="can",[false]="cannot"})[tolk.hasSpeech()])
msg = msg..string.format('\nTolk %s send a text to braille display.', ({[true]="can",[false]="cannot"})[tolk.hasBraille()])
gui.Message("Tolk library check", msg)
return gui.DEFAULT
end

detectSRBtn = gui.button{title="Detect currently running screenreader"}
function detectSRBtn:action()
gui.Message("Tolk library check", string.format("The currently running screenreader is %s.", tolk.detectScreenReader()))
return gui.DEFAULT
end

trySAPICheck = gui.toggle{title="Try SAPI 5 when output is used"}

function trySAPICheck:action(state)
tolk.trySAPI(iuptoboolean[state])
updateOutputMethods()
return gui.DEFAULT
end

preferSAPICheck = gui.toggle{title="Prefer SAPI 5 when it is trying"}

function preferSAPICheck:action(state)
tolk.preferSAPI(iuptoboolean[state])
updateOutputMethods()
return gui.DEFAULT
end

interruptWhenOutputCheck = gui.toggle{title="Interrupt any message before speak new one"}

usedOutputMethodCombo = gui.list{DROPDOWN="Yes"}
function usedOutputMethodCombo:action(text, item, state)
if item == 3 then
interruptWhenOutputCheck.ACTIVE = "No"
else
interruptWhenOutputCheck.ACTIVE = "Yes"
end
return gui.DEFAULT
end

-- Quick update output methods combobox
function updateOutputMethods()
	usedOutputMethodCombo[1] = nil
	usedOutputMethodCombo[1] = "Output through all available methods"
	if tolk.hasSpeech() then
		usedOutputMethodCombo.APPENDITEM = "Speak"
	end
	if tolk.hasBraille() then
		usedOutputMethodCombo.APPENDITEM = "Braille"
	end
	usedOutputMethodCombo.value = 1
end


textForSpeakEdit = gui.text{}
function textForSpeakEdit:action(c, newText)
if self.value ~= "" then
outputBtn.ACTIVE = "Yes"
else
outputBtn.ACTIVE = "No"
end
return gui.DEFAULT
end



outputBtn = gui.button{title="Output!", ACTIVE="No"}

function outputBtn:action()
local methods = {
function(text)
return tolk.output(text, iuptoboolean[interruptWhenOutputCheck.value])
end,
function(text)
return tolk.speak(text, iuptoboolean[interruptWhenOutputCheck.value])
end,
function(text)
return tolk.braille(text)
end
}
if not methods[tonumber(usedOutputMethodCombo.value)](textForSpeakEdit.value) then
gui.Message("Error", "Could not output anything...")
end
return gui.DEFAULT
end

mainWindow = gui.dialog{
title="Tolk library test",
gui.hbox{
gui.frame{
title="Testing",
gui.vbox{
checkLoadedBtn,
detectSRBtn
}
},
gui.frame{
title="Configuration",
ACTIVE=({[true]="Yes",[false]="No"})[tolk ~= nil],
gui.vbox{
trySAPICheck,
preferSAPICheck
}
},
gui.frame{
title="Output",
ACTIVE=({[true]="Yes",[false]="No"})[tolk ~= nil],
gui.vbox{
gui.label{title="Output method:"},
usedOutputMethodCombo,
interruptWhenOutputCheck,
gui.label{title="Output text:"},
textForSpeakEdit,
outputBtn
}
}
}
}

mainWindow:showxy(gui.CENTER, gui.TOP)

updateOutputMethods()

gui.MainLoop()
