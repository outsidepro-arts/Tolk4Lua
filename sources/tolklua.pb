; TolkLua - a bridge of Tolk library and Lua
; Copyright (C), Outsidepro Arts & Electrik-SPB, 2021-2022
; Tolk library written by Davy Kager (Copyright:      (c) 2014-2016, Davy Kager <mail@davykager.nl>)

EnableExplicit
XIncludeFile "..\includefix\tolk.pb"
XIncludeFile "..\modules\Lua-PureBasic\Libraries\Lua\lua.pbi"

UseModule Lua


Procedure.i checkboolean(*l.lua_State, Index.i)
If lua_isboolean(*l, Index)
ProcedureReturn lua_toboolean(*l, Index)
Else
Protected *tpName = lua_typename(*l, lua_type(*l, Index))
Protected tpName.s = PeekS(*tpName, -1, #PB_UTF8)
luaL_error(*l, "Bad argument "+Str(Index)+" type: a boolean expected (got "+tpName+")")
EndIf
EndProcedure

Global NewList TolkMethods.luaL_Reg()

Macro AddMethod(FuncName, FuncPTR)
AddElement(TolkMethods())
TolkMethods()\name = UTF8(FuncName)
TolkMethods()\func = FuncPTR
EndMacro

Macro FinishMethods
AddElement(TolkMethods())
TolkMethods()\name = #Null
TolkMethods()\func = #Null
EndMacro

ProcedureC Lua_Tolk_TrySAPI(*l.lua_State)
Tolk::TrySAPI(checkboolean(*l,1))
EndProcedure
AddMethod("trySAPI",@Lua_Tolk_TrySAPI())

ProcedureC Lua_Tolk_PreferSAPI(*l.lua_State)
Tolk::PreferSAPI(checkboolean(*l,1))
EndProcedure
AddMethod("preferSAPI",@Lua_Tolk_PreferSAPI())

ProcedureC.i Lua_Tolk_DetectScreenReader(*l.lua_State)
lua_pushstring(*l, tolk::DetectScreenReader())
ProcedureReturn 1
EndProcedure
AddMethod("detectScreenReader",@Lua_Tolk_DetectScreenReader())

ProcedureC.i Lua_Tolk_HasSpeech(*l.lua_State)
lua_pushboolean(*l, tolk::HasSpeech())
ProcedureReturn 1
EndProcedure
AddMethod("hasSpeech",@Lua_Tolk_HasSpeech())

ProcedureC.i Lua_Tolk_HasBraille(*l.lua_State)
lua_pushboolean(*l, tolk::HasBraille())
ProcedureReturn 1
EndProcedure
AddMethod("hasBraille",@Lua_Tolk_HasBraille())

ProcedureC.i Lua_Tolk_Output(*l.lua_State)
Protected str.s = PeekS(luaL_checkstring(*l, 1),-1, #PB_UTF8) ; получим первый параметр.
Protected interrupt.i
If lua_isnoneornil(*l, 2)
interrupt = #False
Else
interrupt = checkboolean(*l,2) ; получим второй параметр.
EndIf
lua_pushboolean(*l, tolk::Output(str, interrupt))
ProcedureReturn 1
EndProcedure
AddMethod("output",@Lua_Tolk_Output())

ProcedureC.i Lua_Tolk_Speak(*l.lua_State)
Protected str.s = PeekS(luaL_checkstring(*l, 1),-1, #PB_UTF8) ; получим первый параметр.
Protected interrupt.i
If lua_isnoneornil(*l, 2)
interrupt = #False
Else
interrupt = checkboolean(*l,2) ; получим второй параметр.
EndIf
lua_pushboolean(*l, tolk::Speak(str, interrupt))
ProcedureReturn 1
EndProcedure
AddMethod("speak",@Lua_Tolk_Speak())

ProcedureC.i Lua_Tolk_Braille(*l.lua_State)
Protected str.s = PeekS(luaL_checkstring(*l, 1),-1, #PB_UTF8)
lua_pushboolean(*l, tolk::Braille(str))
ProcedureReturn 1
EndProcedure
AddMethod("braille",@Lua_Tolk_Braille())

ProcedureC.i Lua_Tolk_IsSpeaking(*l.lua_State)
lua_pushboolean(*l, tolk::IsSpeaking())
ProcedureReturn 1
EndProcedure
AddMethod("isSpeaking",@Lua_Tolk_IsSpeaking())

ProcedureC.i Lua_Tolk_Silence(*l.lua_State)
lua_pushboolean(*l, tolk::Silence())
ProcedureReturn 1
EndProcedure
AddMethod("silence",@Lua_Tolk_Silence())

ProcedureC mtm_Destroy(*l.lua_State)
Tolk::Unload()
EndProcedure

FinishMethods

;  Главная экспорт процедура.
; Её название состоит из двух частей: luaopen_, и название библиотеки. Первая часть предопределена, вторая - произвольная.
ProcedureCDLL.i luaopen_tolklua(*l.lua_State)
Tolk::Load()
If Tolk::IsLoaded()
Protected Dim FuncsArray.luaL_Reg(ListSize(TolkMethods()))
ForEach TolkMethods()
FuncsArray(ListIndex(TolkMethods())) = TolkMethods()
Next
lua_createtable(*l,1,ArraySize(FuncsArray()))
luaL_setfuncs(*l,@FuncsArray(),0)
ForEach TolkMethods()
FreeMemory(TolkMethods()\name)
Next
FreeArray(FuncsArray())
FreeList(TolkMethods())
lua_newtable(*l)
lua_pushvalue(*l, -2)
lua_setfield(*l, -2, "__index")
lua_pushcfunction(*l, @mtm_Destroy())
lua_setfield(*l, -2, "__gc")
lua_setmetatable(*l, -2)
ProcedureReturn 1
EndIf
ProcedureReturn 0
EndProcedure
