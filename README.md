# TolkLua #
TolkLua is a a bridge of [Tolk library](https://github.com/dkager/tolk) and Lua. Here is fully provided all API of.
+ [Lua5.3](https://lua.org)
## Dependencies ##
+ [Tolk](https://github.com/dkager/tolk)

## Installation ##
+ Place the Tolk DLLS either into your project directory or into Lua distributive binaries directory.
+ Place the bridge DLL either into your project directory or into your Lua distributive directory where Lua searches the modules (see at package.path).

Please note that both the Tolk content and this Tolk bridge should be positioned at the same directory.

## Usage ##
The bridge translates all API functions presented in Tolk library in mixed case excluding the status Tolk loading check. All types converts to appropriated native, so you not have to convert it by itself.
### Including the Tolk using TolkLua wrapper ###
When you include the bridge it returns the table with all methods without "Tolk_" prefix and in mixed case on successfull loading.
```lua
tolk = require "tolklua"
if tolk then
	print("Tolk successfully loaded!")
else
	Print("An error has occurred when Tolk loading. The library is not loaded.")
end
```
  ### Using the Tolk library through the TolkLua bridge ###
As I said above, all types converts into native type both one way and the other.
```lua
tolk.hasSpeech()
  > true
tolk.output("This is a test", true)
  > true
```
You don't need to do any manipulations with returning and passing strings.
```lua
tolk.detectScreenReader()
  > NVDA
tolk.speak("This is a test", true)
```
Please note: you have not need to unload the Tolk library using "Tolk_Unload()" method. Lua will do it itself when either script will be ended or when Lua garbage cleaner will decide collect this object due non-using in your code.
## Tests ##
I am gonna replenish the tests examples where you can look how it works and how it can be used. Please look at "test" directory and explore the interesting one.
<em>Please note:</em> if you would run these test examples, you have to either place the tolk content and this bridge to main Lua distributive directory or place it at the tests directory before run each of (see the installation section).
## License ##
This bridge obeys under Tolk library license. Please look it at main Tolk repository.

## Contribution ##
This bridge written in collaboration of [Sergey Parshakoff](https://github.com/electrik-spb). Sergey teaches me in programming skills from 2015-th and we made many projects together. When I've asked him the help to understand this trouble,  he has started this first, then I've kept developing and finalizing of. Thank you, Sergey!
