tolk = require "tolklua"

answerMap = setmetatable(
{
["yes"]=true,
["y"]=true,
[1]=true,
["no"]=false,
["n"]=false,
[0]=false
},
{
__index = function(self, value)
error(string.format("Input error: expected one of declared values, got %s.", value))
end
})

os.execute([[
@echo off
chcp 65001
]])
print([[Welcome to Tolk ScreenReader library wrapper test!
The Tolk library written by Davy Kager.
The wrapper written by denis Shishkin.
You may close this test at any time just typing the \"exit\" in this console."
]])
print("Attempting to load the Tolk library...")
tolk.Load()
if tolk.IsLoaded() then
print("The Tolk library successfully loaded!")
print(string.format("Currently running screenreader: %s", tolk.DetectScreenReader()))
print("Checking the currently loaded Tolk abilities...")
if tolk.HasSpeech() then
print("Tolk can output the passed text to a speech synthesizer.")
else
print("Tolk cannot output the passed text to a speech synthesizer.")
end
if tolk.HasBraille() then
print("Tolk can send the passed text to a braille device.")
else
print("Tolk cannot send the passed text to a braille device.")
end
print("Press return key to continue.")
io.read()
print("Initial settings up:")
print(string.format('Do you wish to use SAPI 5 voices instead of %s output? Type \"yes\" or \"no\":', tolk.DetectScreenReader()))
answer = io.read()
if answer == "exit" then goto terminate end
tolk.TrySAPI(answerMap[answer])
print("Accepted!")
if answerMap[answer] then
print('Do you wish to use SAPI 5 voices preferly? Type \"yes\" or \"no\":')
answer = io.read()
if answer == "exit" then goto terminate end
tolk.PreferSAPI(answerMap[answer])
print("Accepted!")
end
print("Should Tolk terminate any currently speaking message when it start output new one?")
answer = io.read()
if answer == "exit" then goto terminate end
interrupt = answerMap[answer]
print("Accepted!")
print("All settings done!")
print([[The tolk library is ready to output.
Use the following preffixes in your input:
output [text]: use standart output method to output the given [text].]])
if tolk.HasSpeech() then
print("speak [text]: only speak the given [text].")
end
if tolk.HasBraille() then
print("braille [text]: only pass the given [text] to the braille.")
end
print("exit: finish the test program and terminate the process.")
while true do
local answer = io.read()
if answer == "exit" then goto terminate end
local command, text = answer:match("^(%w+)%s(.+)")
if text == nil then
if answer ~= "" then
tolk.Output(answer, interrupt)
else
print("Empty text input.")
goto next
end
end
if text and text:match("%w+") == nil then
print("Unsupported text symbols.")
goto next
end
if command == "output" then
tolk.Output(text, interrupt)
elseif command == "speak" then
if tolk.HasSpeech() then
tolk.Speak(text, interrupt)
else
print(string.format("Unsuported method: %s", command))
end
elseif command == "braille" then
if tolk.HasBraille() then
tolk.Braille(text)
else
print(string.format("Unsuported method: %s", command))
end
else
tolk.Output(answer, interrupt)
end
::next::
end
else
error("Unable to load the Tolk library... Suddenly...")
goto terminate
end
::terminate::
print("Terminating the process...")
tolk.Unload()
