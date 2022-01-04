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

ProcedureC lua_tolk_load(*l.lua_State)
tolk::Load()
EndProcedure

ProcedureC.i Lua_Tolk_IsLoaded(*l.lua_State)
lua_pushboolean(*l, tolk::IsLoaded()) 
ProcedureReturn 1 ; число возвращаемых параметров.
EndProcedure

ProcedureC Lua_Tolk_Unload(*l.lua_State)
tolk::Unload()
EndProcedure

ProcedureC Lua_Tolk_TrySAPI(*l.lua_State)
Tolk::TrySAPI(checkboolean(*l,1))
EndProcedure

ProcedureC Lua_Tolk_PreferSAPI(*l.lua_State)
Tolk::PreferSAPI(checkboolean(*l,1))
EndProcedure

ProcedureC.i Lua_Tolk_DetectScreenReader(*l.lua_State)
lua_pushstring(*l, tolk::DetectScreenReader())
ProcedureReturn 1
EndProcedure

ProcedureC.i Lua_Tolk_HasSpeech(*l.lua_State)
lua_pushboolean(*l, tolk::HasSpeech())
ProcedureReturn 1
EndProcedure

ProcedureC.i Lua_Tolk_HasBraille(*l.lua_State)
lua_pushboolean(*l, tolk::HasBraille())
ProcedureReturn 1
EndProcedure

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

ProcedureC.i Lua_Tolk_Braille(*l.lua_State)
Protected str.s = PeekS(luaL_checkstring(*l, 1),-1, #PB_UTF8)
lua_pushboolean(*l, tolk::Braille(str))
ProcedureReturn 1
EndProcedure

ProcedureC.i Lua_Tolk_IsSpeaking(*l.lua_State)
lua_pushboolean(*l, tolk::IsSpeaking())
ProcedureReturn 1
EndProcedure

ProcedureC.i Lua_Tolk_Silence(*l.lua_State)
lua_pushboolean(*l, tolk::Silence())
ProcedureReturn 1
EndProcedure

Macro AddMethod(FuncName, FuncPTR)
ReDim TolkMethods(ArraySize(TolkMethods())+1)
ArrIndex.i = ArraySize(TolkMethods())-1
TolkMethods(ArrIndex)\name = UTF8(FuncName)
TolkMethods(ArrIndex)\func = FuncPTR
EndMacro

Macro FinishMethods
ReDim TolkMethods(ArraySize(TolkMethods())+1)
ArrIndex = ArraySize(TolkMethods())-1
TolkMethods(ArrIndex)\name = #Null
TolkMethods(ArrIndex)\func = #Null
EndMacro


Global Dim TolkMethods.luaL_Reg(0)
Global ArrIndex.i
AddMethod("Load", @Lua_tolk_load())
AddMethod("IsLoaded",@LUA_Tolk_IsLoaded())
AddMethod("Unload",@Lua_Tolk_Unload())
AddMethod("TrySAPI",@Lua_Tolk_TrySAPI())
AddMethod("PreferSAPI",@Lua_Tolk_PreferSAPI())
AddMethod("DetectScreenReader",@Lua_Tolk_DetectScreenReader())
AddMethod("HasSpeech",@Lua_Tolk_HasSpeech())
AddMethod("HasBraille",@Lua_Tolk_HasBraille())
AddMethod("Output",@Lua_Tolk_Output())
AddMethod("Speak",@Lua_Tolk_Speak())
AddMethod("Braille",@Lua_Tolk_Braille())
AddMethod("IsSpeaking",@Lua_Tolk_IsSpeaking())
AddMethod("Silence",@Lua_Tolk_Silence())
FinishMethods

;  Главная экспорт процедура.
; Её название состоит из двух частей: luaopen_, и название библиотеки. Первая часть предопределена, вторая - произвольная.
ProcedureCDLL.i luaopen_tolklua(*l.lua_State)
lua_createtable(*l,1,ArraySize(TolkMethods()))
luaL_setfuncs(*l,@TolkMethods(),0)
Protected i.i
For i = 0 To ArraySize(TolkMethods())-1
FreeMemory(TolkMethods(i)\name)
Next i
ProcedureReturn 1
EndProcedure
