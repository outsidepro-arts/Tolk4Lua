# TolkLua #
TolkLua is a a bridge of [Tolk library](https://github.com/dkager/tolk) and Lua. Here is fully provided all API of.
## Dependencies ##
+ [Lua any version](https://lua.org)
+ [Tolk](https://github.com/dkager/tolk)

## Installation ##
+ Place the Tolk DLLS either into your project directory or into Lua distributive binaries directory.
+ Place the bridge DLL either into your project directory or into your Lua distributive directory where Lua searches the modules (see at package.path).

Please note that both the Tolk content and this Tolk bridge should be positioned at the same directory.

## Usage ##
The bridge translates all API functions presented in Tolk library. All types converts to appropriated native, so you not have to convert it by itself.
### Including the Tolk using TolkLua wrapper ###
When you include the bridge it returns the table with all methods without "Tolk_" prefix.
```lua
tolk = require "tolklua"
tolk.Load()
```
  ### Using the Tolk library through the TolkLua bridge ###
As I said above, all types converts into native type both one way and the other.
```lua
tolk.IsLoaded()
  > true
tolk.Output("This is a test", true)
```
You don't need to do any manipulations with returning and passing strings.
```lua
tolk.DetectScreenReader()
  > NVDA
tolk.Speak("This is a test", true)
```
## Tests ##
I am gonna replenish the tests examples where you can look how it works and how it can be used. Please look at "test" directory and explore the interesting one.
<em>Please note:</em> if you would run these test examples, you have to either place the tolk content and this bridge to main Lua distributive directory or place it at the tests directory before run each of (see the installation section).
## License ##
This bridge obeys under Tolk library license. Please look it at main Tolk repository.
