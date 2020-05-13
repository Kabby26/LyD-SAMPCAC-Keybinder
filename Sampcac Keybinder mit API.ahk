;===============================================================================
;LyD Keybinder
Version := 1.6
;===============================================================================

IfExist update.bat
{
	FileDelete update.bat
}

UrlDownloadToFile http://80.252.107.195/LyD_Keybinder/Version.txt, version.txt

FileRead, NewestVersion, version.txt
FileDelete version.txt

if NewestVersion is not number
{
	MsgBox, 48, Fehler, Die Updateserver sind derzeit nicht erreichbar!`nBitte bei Kabby melden. Der Keybinder kann trotzdessen weiter verwendet werden.`nEs können aber keine Hintergrundbilder oder ähnliches heruntergeladen werden!
	SERVERDOWN := 1
}

if(SERVERDOWN == 1){
}else if(NewestVersion > version){
	MsgBox, 68, Update verfügbar, Es ist ein Update verfügbar!`n`nAktuelle Version:     [%Version%]`nNeue Version:          [%NewestVersion%]`n`nMöchtest du den Keybinder aktualisieren?
	IfMsgBox, YES
	{
		SplashTextOn, 200, 50, Keybinder, Der Keybinder wird geupdated! Bitte warten...
		UrlDownloadToFile http://80.252.107.195/LyD_Keybinder/Keybinder.exe, %A_ScriptName%.new
		UpdateBat=
			(
				Del "%A_ScriptName%"
				Rename "%A_ScriptName%.new" "%A_ScriptName%
				cd "%A_ScriptFullPath%"
				"%A_ScriptName%"
			)
		FileAppend, %UpdateBat%, update.bat
		Run, update.bat, , hide
		SplashTextOff
		ExitApp
		}
	IfMsgBox, NO
	{
	}
}else{
}


IfNotExist, %A_AppData%\Keybinder\LyD_Keybinder\config\
{
	FileCreateDir, %A_AppData%\Keybinder\LyD_Keybinder\config\
}

IfNotExist %A_AppData%\Keybinder\LyD_Keybinder\blau.jpg
{
	URLDownloadToFile, http://80.252.107.195/LyD_Keybinder/blau.jpg, %A_AppData%\Keybinder\LyD_Keybinder\blau.jpg
}

IfNotExist %A_AppData%\Keybinder\LyD_Keybinder\grau.jpg
{
	URLDownloadToFile, http://80.252.107.195/LyD_Keybinder/grau.jpg, %A_AppData%\Keybinder\LyD_Keybinder\grau.jpg
}

IfNotExist %A_AppData%\Keybinder\Open-SAMP-API.dll
{
	URLDownloadToFile, http://80.252.107.195/LyD_Keybinder/Open-SAMP-API.dll, %A_AppData%\Keybinder\Open-SAMP-API.dll
}



#NoEnv 
#IfWinActive, ahk_exe gta_sa.exe
#SingleInstance, Force
#MaxHotkeysPerInterval  1000000
#UseHook


RegRead, sampuser, HKEY_CURRENT_USER, Software\SAMP, PlayerName

PATH_SAMP_API := PathCombine(A_AppData, "Keybinder\Open-SAMP-API.dll")

hModule := DllCall("LoadLibrary", Str, PATH_SAMP_API)
if(hModule == -1 || hModule == 0)
{
	MsgBox, 48, Error, The dll-file couldn't be found!
	ExitApp
}

;Client.hpp
Init_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "Init")
SetParam_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "SetParam")

;GTAFunctions.hpp
GetGTACommandLine_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetGTACommandLine")
IsMenuOpen_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsMenuOpen")
ScreenToWorld_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ScreenToWorld")
WorldToScreen_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "WorldToScreen")

;PlayerFunctions.hpp
GetPlayerCPed_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerCPed")
GetPlayerHealth_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerHealth")
GetPlayerArmor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerArmor")
GetPlayerMoney_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerMoney")
GetPlayerSkinID_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerSkinID")
GetPlayerInterior_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerInterior")
IsPlayerInAnyVehicle_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerInAnyVehicle")
IsPlayerDriver_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerDriver")
IsPlayerPassenger_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerPassenger")
IsPlayerInInterior_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerInInterior")
GetPlayerX_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerX")
GetPlayerY_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerY")
GetPlayerZ_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerZ")
GetPlayerPosition_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerPosition")
IsPlayerInRange2D_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerInRange2D")
IsPlayerInRange3D_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsPlayerInRange3D")
GetCityName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetCityName")
GetZoneName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetZoneName")

;RenderFunctions.hpp
TextCreate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextCreate")
TextDestroy_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextDestroy")
TextSetShadow_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextSetShadow")
TextSetShown_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextSetShown")
TextSetColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextSetColor")
TextSetPos_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextSetPos")
TextSetString_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextSetString")
TextUpdate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "TextUpdate")
BoxCreate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxCreate")
BoxDestroy_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxDestroy")
BoxSetShown_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetShown")
BoxSetBorder_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetBorder")
BoxSetBorderColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetBorderColor")
BoxSetColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetColor")
BoxSetHeight_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetHeight")
BoxSetPos_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetPos")
BoxSetWidth_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "BoxSetWidth")
LineCreate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineCreate")
LineDestroy_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineDestroy")
LineSetShown_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineSetShown")
LineSetColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineSetColor")
LineSetWidth_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineSetWidth")
LineSetPos_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "LineSetPos")
ImageCreate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageCreate")
ImageDestroy_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageDestroy")
ImageSetShown_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageSetShown")
ImageSetAlign_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageSetAlign")
ImageSetPos_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageSetPos")
ImageSetRotation_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ImageSetRotation")
DestroyAllVisual_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "DestroyAllVisual")
ShowAllVisual_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ShowAllVisual")
HideAllVisual_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "HideAllVisual")
GetFrameRate_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetFrameRate")
GetScreenSpecs_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetScreenSpecs")
SetCalculationRatio_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "SetCalculationRatio")
SetOverlayPriority_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "SetOverlayPriority")
SetOverlayCalculationEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "SetOverlayCalculationEnabled")

;SAMPFunctions.hpp
GetServerIP_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetServerIP")
GetServerPort_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetServerPort")
SendChat_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "SendChat")
ShowGameText_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ShowGameText")
AddChatMessage_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "AddChatMessage")
ShowDialog_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "ShowDialog")
GetPlayerNameByID_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerNameByID")
GetPlayerIDByName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerIDByName")
GetPlayerName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerName")
GetPlayerId_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerId")
IsChatOpen_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsChatOpen")
IsDialogOpen_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsDialogOpen")

;VehicleFunctions.hpp
GetVehiclePointer_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehiclePointer")
GetVehicleSpeed_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleSpeed")
GetVehicleHealth_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleHealth")
GetVehicleModelId_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleModelId")
GetVehicleModelName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleModelName")
GetVehicleModelNameById_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleModelNameById")
GetVehicleType_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleType")
GetVehicleFreeSeats_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleFreeSeats")
GetVehicleFirstColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleFirstColor")
GetVehicleSecondColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleSecondColor")
GetVehicleColor_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetVehicleColor")
IsVehicleSeatUsed_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleSeatUsed")
IsVehicleLocked_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleLocked")
IsVehicleHornEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleHornEnabled")
IsVehicleSirenEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleSirenEnabled")
IsVehicleAlternateSirenEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleAlternateSirenEnabled")
IsVehicleEngineEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleEngineEnabled")
IsVehicleLightEnabled_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleLightEnabled")
IsVehicleCar_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleCar")
IsVehiclePlane_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehiclePlane")
IsVehicleBoat_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleBoat")
IsVehicleTrain_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleTrain")
IsVehicleBike_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "IsVehicleBike")

;WeaponFunctions.hpp
HasWeaponIDClip_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "HasWeaponIDClip")
GetPlayerWeaponID_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponID")
GetPlayerWeaponType_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponType")
GetPlayerWeaponSlot_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponSlot")
GetPlayerWeaponName_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponName")
GetPlayerWeaponClip_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponClip")
GetPlayerWeaponTotalClip_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponTotalClip")
GetPlayerWeaponState_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponState")
GetPlayerWeaponAmmo_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponAmmo")
GetPlayerWeaponAmmoInClip_func := DllCall("GetProcAddress", "UInt", hModule, "AStr", "GetPlayerWeaponAmmoInClip")

Init()
{
	global Init_func
	return DllCall(Init_func)
}

SetParam(_szParamName, _szParamValue)
{
	global SetParam_func
	return DllCall(SetParam_func, "AStr", _szParamName, "AStr", _szParamValue)
}

GetGTACommandLine(ByRef line, max_len)
{
	global GetGTACommandLine_func
	VarSetCapacity(line, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetGTACommandLine_func, "StrP", line, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	line := StrGet(&line, "cp0")
	return res
}

IsMenuOpen()
{
	global IsMenuOpen_func
	return DllCall(IsMenuOpen_func)
}

ScreenToWorld(x, y, ByRef worldX, ByRef worldY, ByRef worldZ)
{
	global ScreenToWorld_func
	return DllCall(ScreenToWorld_func, "Float", x, "Float", y, "FloatP", worldX, "FloatP", worldY, "FloatP", worldZ)
}

WorldToScreen(x, y, z, ByRef screenX, ByRef screenY)
{
	global WorldToScreen_func
	return DllCall(WorldToScreen_func, "Float", x, "Float", y, "Float", z, "FloatP", screenX, "FloatP", screenY)
}

GetPlayerCPed()
{
	global GetPlayerCPed_func
	return DllCall(GetPlayerCPed_func)
}

GetPlayerHealth()
{
	global GetPlayerHealth_func
	return DllCall(GetPlayerHealth_func)
}

GetPlayerArmor()
{
	global GetPlayerArmor_func
	return DllCall(GetPlayerArmor_func)
}

GetPlayerMoney()
{
	global GetPlayerMoney_func
	return DllCall(GetPlayerMoney_func)
}

GetPlayerSkinID()
{
	global GetPlayerSkinID_func
	return DllCall(GetPlayerSkinID_func)
}

GetPlayerInterior()
{
	global GetPlayerInterior_func
	return DllCall(GetPlayerInterior_func)
}

IsPlayerInAnyVehicle()
{
	global IsPlayerInAnyVehicle_func
	return DllCall(IsPlayerInAnyVehicle_func)
}

IsPlayerDriver()
{
	global IsPlayerDriver_func
	return DllCall(IsPlayerDriver_func)
}

IsPlayerPassenger()
{
	global IsPlayerPassenger_func
	return DllCall(IsPlayerPassenger_func)
}

IsPlayerInInterior()
{
	global IsPlayerInInterior_func
	return DllCall(IsPlayerInInterior_func)
}

GetPlayerX(ByRef posX)
{
	global GetPlayerX_func
	return DllCall(GetPlayerX_func, "FloatP", posX)
}

GetPlayerY(ByRef posY)
{
	global GetPlayerY_func
	return DllCall(GetPlayerY_func, "FloatP", posY)
}

GetPlayerZ(ByRef posZ)
{
	global GetPlayerZ_func
	return DllCall(GetPlayerZ_func, "FloatP", posZ)
}

GetPlayerPosition(ByRef posX, ByRef posY, ByRef posZ)
{
	global GetPlayerPosition_func
	return DllCall(GetPlayerPosition_func, "FloatP", posX, "FloatP", posY, "FloatP", posZ)
}

IsPlayerInRange2D(posX, posY, radius)
{
	global IsPlayerInRange2D_func
	return DllCall(IsPlayerInRange2D_func, "Float", posX, "Float", posY, "Float", radius)
}

IsPlayerInRange3D(posX, posY, posZ, radius)
{
	global IsPlayerInRange3D_func
	return DllCall(IsPlayerInRange3D_func, "Float", posX, "Float", posY, "Float", posZ, "Float", radius)
}

GetCityName(ByRef cityName, max_len)
{
	global GetCityName_func
	VarSetCapacity(cityName, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetCityName_func, "StrP", cityName, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	cityName := StrGet(&cityName, "cp0")
	return res
}

GetZoneName(ByRef zoneName, max_len)
{
	global GetZoneName_func
	VarSetCapacity(zoneName, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetZoneName_func, "StrP", zoneName, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	zoneName := StrGet(&zoneName, "cp0")
	return res
}

TextCreate(Font, FontSize, bBold, bItalic, x, y, color, text, bShadow, bShow)
{
	global TextCreate_func
	return DllCall(TextCreate_func, "AStr", Font, "Int", FontSize, "UChar", bBold, "UChar", bItalic, "Int", x, "Int", y, "UInt", color, "AStr", text, "UChar", bShadow, "UChar", bShow)
}

TextDestroy(ID)
{
	global TextDestroy_func
	return DllCall(TextDestroy_func, "Int", ID)
}

TextSetShadow(id, b)
{
	global TextSetShadow_func
	return DllCall(TextSetShadow_func, "Int", id, "UChar", b)
}

TextSetShown(id, b)
{
	global TextSetShown_func
	return DllCall(TextSetShown_func, "Int", id, "UChar", b)
}

TextSetColor(id, color)
{
	global TextSetColor_func
	return DllCall(TextSetColor_func, "Int", id, "UInt", color)
}

TextSetPos(id, x, y)
{
	global TextSetPos_func
	return DllCall(TextSetPos_func, "Int", id, "Int", x, "Int", y)
}

TextSetString(id, str)
{
	global TextSetString_func
	return DllCall(TextSetString_func, "Int", id, "AStr", str)
}

TextUpdate(id, Font, FontSize, bBold, bItalic)
{
	global TextUpdate_func
	return DllCall(TextUpdate_func, "Int", id, "AStr", Font, "Int", FontSize, "UChar", bBold, "UChar", bItalic)
}

BoxCreate(x, y, w, h, dwColor, bShow)
{
	global BoxCreate_func
	return DllCall(BoxCreate_func, "Int", x, "Int", y, "Int", w, "Int", h, "UInt", dwColor, "UChar", bShow)
}

BoxDestroy(id)
{
	global BoxDestroy_func
	return DllCall(BoxDestroy_func, "Int", id)
}

BoxSetShown(id, bShown)
{
	global BoxSetShown_func
	return DllCall(BoxSetShown_func, "Int", id, "UChar", bShown)
}

BoxSetBorder(id, height, bShown)
{
	global BoxSetBorder_func
	return DllCall(BoxSetBorder_func, "Int", id, "Int", height, "UChar", bShown)
}

BoxSetBorderColor(id, dwColor)
{
	global BoxSetBorderColor_func
	return DllCall(BoxSetBorderColor_func, "Int", id, "UInt", dwColor)
}

BoxSetColor(id, dwColor)
{
	global BoxSetColor_func
	return DllCall(BoxSetColor_func, "Int", id, "UInt", dwColor)
}

BoxSetHeight(id, height)
{
	global BoxSetHeight_func
	return DllCall(BoxSetHeight_func, "Int", id, "Int", height)
}

BoxSetPos(id, x, y)
{
	global BoxSetPos_func
	return DllCall(BoxSetPos_func, "Int", id, "Int", x, "Int", y)
}

BoxSetWidth(id, width)
{
	global BoxSetWidth_func
	return DllCall(BoxSetWidth_func, "Int", id, "Int", width)
}

LineCreate(x1, y1, x2, y2, width, color, bShow)
{
	global LineCreate_func
	return DllCall(LineCreate_func, "Int", x1, "Int", y1, "Int", x2, "Int", y2, "Int", width, "UInt", color, "UChar", bShow)
}

LineDestroy(id)
{
	global LineDestroy_func
	return DllCall(LineDestroy_func, "Int", id)
}

LineSetShown(id, bShown)
{
	global LineSetShown_func
	return DllCall(LineSetShown_func, "Int", id, "UChar", bShown)
}

LineSetColor(id, color)
{
	global LineSetColor_func
	return DllCall(LineSetColor_func, "Int", id, "UInt", color)
}

LineSetWidth(id, width)
{
	global LineSetWidth_func
	return DllCall(LineSetWidth_func, "Int", id, "Int", width)
}

LineSetPos(id, x1, y1, x2, y2)
{
	global LineSetPos_func
	return DllCall(LineSetPos_func, "Int", id, "Int", x1, "Int", y1, "Int", x2, "Int", y2)
}

ImageCreate(path, x, y, rotation, align, bShow)
{
	global ImageCreate_func
	return DllCall(ImageCreate_func, "AStr", path, "Int", x, "Int", y, "Int", rotation, "Int", align, "UChar", bShow)
}

ImageDestroy(id)
{
	global ImageDestroy_func
	return DllCall(ImageDestroy_func, "Int", id)
}

ImageSetShown(id, bShown)
{
	global ImageSetShown_func
	return DllCall(ImageSetShown_func, "Int", id, "UChar", bShown)
}

ImageSetAlign(id, align)
{
	global ImageSetAlign_func
	return DllCall(ImageSetAlign_func, "Int", id, "Int", align)
}

ImageSetPos(id, x, y)
{
	global ImageSetPos_func
	return DllCall(ImageSetPos_func, "Int", id, "Int", x, "Int", y)
}

ImageSetRotation(id, rotation)
{
	global ImageSetRotation_func
	return DllCall(ImageSetRotation_func, "Int", id, "Int", rotation)
}

DestroyAllVisual()
{
	global DestroyAllVisual_func
	return DllCall(DestroyAllVisual_func)
}

ShowAllVisual()
{
	global ShowAllVisual_func
	return DllCall(ShowAllVisual_func)
}

HideAllVisual()
{
	global HideAllVisual_func
	return DllCall(HideAllVisual_func)
}

GetFrameRate()
{
	global GetFrameRate_func
	return DllCall(GetFrameRate_func)
}

GetScreenSpecs(ByRef width, ByRef height)
{
	global GetScreenSpecs_func
	return DllCall(GetScreenSpecs_func, "IntP", width, "IntP", height)
}

SetCalculationRatio(width, height)
{
	global SetCalculationRatio_func
	return DllCall(SetCalculationRatio_func, "Int", width, "Int", height)
}

SetOverlayPriority(id, priority)
{
	global SetOverlayPriority_func
	return DllCall(SetOverlayPriority_func, "Int", id, "Int", priority)
}

SetOverlayCalculationEnabled(id, enabled)
{
	global SetOverlayCalculationEnabled_func
	return DllCall(SetOverlayCalculationEnabled_func, "Int", id, "UChar", enabled)
}

GetServerIP(ByRef ip, max_len)
{
	global GetServerIP_func
	VarSetCapacity(ip, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetServerIP_func, "StrP", ip, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	ip := StrGet(&ip, "cp0")
	return res
}

GetServerPort()
{
	global GetServerPort_func
	return DllCall(GetServerPort_func)
}

SendChat(msg)
{
	global SendChat_func
	return DllCall(SendChat_func, "AStr", msg)
}

ShowGameText(msg, time, style)
{
	global ShowGameText_func
	return DllCall(ShowGameText_func, "AStr", msg, "Int", time, "Int", style)
}

AddChatMessage(msg)
{
	global AddChatMessage_func
	return DllCall(AddChatMessage_func, "AStr", msg)
}

ShowDialog(id, style, caption, text, button, button2)
{
	global ShowDialog_func
	return DllCall(ShowDialog_func, "Int", id, "Int", style, "AStr", caption, "AStr", text, "AStr", button, "AStr", button2)
}

GetPlayerNameByID(id, ByRef playername, max_len)
{
	global GetPlayerNameByID_func
	VarSetCapacity(playername, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetPlayerNameByID_func, "Int", id, "StrP", playername, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	playername := StrGet(&playername, "cp0")
	return res
}

GetPlayerIDByName(name)
{
	global GetPlayerIDByName_func
	return DllCall(GetPlayerIDByName_func, "AStr", name)
}

GetPlayerName(ByRef playername, max_len)
{
	global GetPlayerName_func
	VarSetCapacity(playername, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetPlayerName_func, "StrP", playername, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	playername := StrGet(&playername, "cp0")
	return res
}

GetPlayerId()
{
	global GetPlayerId_func
	return DllCall(GetPlayerId_func)
}

IsChatOpen()
{
	global IsChatOpen_func
	return DllCall(IsChatOpen_func)
}

IsDialogOpen()
{
	global IsDialogOpen_func
	return DllCall(IsDialogOpen_func)
}

GetVehiclePointer()
{
	global GetVehiclePointer_func
	return DllCall(GetVehiclePointer_func)
}

GetVehicleSpeed(factor)
{
	global GetVehicleSpeed_func
	return DllCall(GetVehicleSpeed_func, "Float", factor)
}

GetVehicleHealth()
{
	global GetVehicleHealth_func
	return DllCall(GetVehicleHealth_func, "Cdecl float")
}

GetVehicleModelId()
{
	global GetVehicleModelId_func
	return DllCall(GetVehicleModelId_func)
}

GetVehicleModelName(ByRef name, max_len)
{
	global GetVehicleModelName_func
	VarSetCapacity(name, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetVehicleModelName_func, "StrP", name, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	name := StrGet(&name, "cp0")
	return res
}

GetVehicleModelNameById(vehicleID, ByRef name, max_len)
{
	global GetVehicleModelNameById_func
	VarSetCapacity(name, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetVehicleModelNameById_func, "Int", vehicleID, "StrP", name, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	name := StrGet(&name, "cp0")
	return res
}

GetVehicleType()
{
	global GetVehicleType_func
	return DllCall(GetVehicleType_func)
}

GetVehicleFreeSeats(ByRef seatFL, ByRef seatFR, ByRef seatRL, ByRef seatRR)
{
	global GetVehicleFreeSeats_func
	return DllCall(GetVehicleFreeSeats_func, "IntP", seatFL, "IntP", seatFR, "IntP", seatRL, "IntP", seatRR)
}

GetVehicleFirstColor()
{
	global GetVehicleFirstColor_func
	return DllCall(GetVehicleFirstColor_func)
}

GetVehicleSecondColor()
{
	global GetVehicleSecondColor_func
	return DllCall(GetVehicleSecondColor_func)
}

GetVehicleColor(ByRef color1, ByRef color2)
{
	global GetVehicleColor_func
	return DllCall(GetVehicleColor_func, "IntP", color1, "IntP", color2)
}

IsVehicleSeatUsed(seat)
{
	global IsVehicleSeatUsed_func
	return DllCall(IsVehicleSeatUsed_func, "Int", seat)
}

IsVehicleLocked()
{
	global IsVehicleLocked_func
	return DllCall(IsVehicleLocked_func)
}

IsVehicleHornEnabled()
{
	global IsVehicleHornEnabled_func
	return DllCall(IsVehicleHornEnabled_func)
}

IsVehicleSirenEnabled()
{
	global IsVehicleSirenEnabled_func
	return DllCall(IsVehicleSirenEnabled_func)
}

IsVehicleAlternateSirenEnabled()
{
	global IsVehicleAlternateSirenEnabled_func
	return DllCall(IsVehicleAlternateSirenEnabled_func)
}

IsVehicleEngineEnabled()
{
	global IsVehicleEngineEnabled_func
	return DllCall(IsVehicleEngineEnabled_func)
}

IsVehicleLightEnabled()
{
	global IsVehicleLightEnabled_func
	return DllCall(IsVehicleLightEnabled_func)
}

IsVehicleCar()
{
	global IsVehicleCar_func
	return DllCall(IsVehicleCar_func)
}

IsVehiclePlane()
{
	global IsVehiclePlane_func
	return DllCall(IsVehiclePlane_func)
}

IsVehicleBoat()
{
	global IsVehicleBoat_func
	return DllCall(IsVehicleBoat_func)
}

IsVehicleTrain()
{
	global IsVehicleTrain_func
	return DllCall(IsVehicleTrain_func)
}

IsVehicleBike()
{
	global IsVehicleBike_func
	return DllCall(IsVehicleBike_func)
}

HasWeaponIDClip(weaponID)
{
	global HasWeaponIDClip_func
	return DllCall(HasWeaponIDClip_func, "Int", weaponID)
}

GetPlayerWeaponID()
{
	global GetPlayerWeaponID_func
	return DllCall(GetPlayerWeaponID_func)
}

GetPlayerWeaponType()
{
	global GetPlayerWeaponType_func
	return DllCall(GetPlayerWeaponType_func)
}

GetPlayerWeaponSlot()
{
	global GetPlayerWeaponSlot_func
	return DllCall(GetPlayerWeaponSlot_func)
}

GetPlayerWeaponName(dwWeapSlot, ByRef _szWeapName, max_len)
{
	global GetPlayerWeaponName_func
	VarSetCapacity(_szWeapName, max_len * (A_IsUnicode ? 2 : 1), 0)
	res := DllCall(GetPlayerWeaponName_func, "Int", dwWeapSlot, "StrP", _szWeapName, "Int", max_len)
	; We need StrGet to convert the API answer (ANSI) to the charset AHK uses (ANSI or Unicode)
	_szWeapName := StrGet(&_szWeapName, "cp0")
	return res
}

GetPlayerWeaponClip(dwWeapSlot)
{
	global GetPlayerWeaponClip_func
	return DllCall(GetPlayerWeaponClip_func, "Int", dwWeapSlot)
}

GetPlayerWeaponTotalClip(dwWeapSlot)
{
	global GetPlayerWeaponTotalClip_func
	return DllCall(GetPlayerWeaponTotalClip_func, "Int", dwWeapSlot)
}

GetPlayerWeaponState()
{
	global GetPlayerWeaponState_func
	return DllCall(GetPlayerWeaponState_func)
}

GetPlayerWeaponAmmo(weaponType)
{
	global GetPlayerWeaponAmmo_func
	return DllCall(GetPlayerWeaponAmmo_func, "Int", weaponType)
}

GetPlayerWeaponAmmoInClip(weaponType)
{
	global GetPlayerWeaponAmmoInClip_func
	return DllCall(GetPlayerWeaponAmmoInClip_func, "Int", weaponType)
}


PathCombine(abs, rel) {
	VarSetCapacity(dest, (A_IsUnicode ? 2 : 1) * 260, 1) ; MAX_PATH
	DllCall("Shlwapi.dll\PathCombine", "UInt", &dest, "UInt", &abs, "UInt", &rel)
	Return, dest
}

OnPlayerEnterVehicle(){
	Sleep, 100
	if(IsPlayerDriver() == 1 && IsVehicleLocked() == 0){
		SendChat("/flock")
	}
	if(IsPlayerDriver() == 1 && IsVehicleEngineEnabled() == 0){
		SendChat("/motor")
	}
	if(IsPlayerDriver() == 1 && IsVehicleLightEnabled() == 0){
		SendChat("/licht")
	}
	if(IsPlayerDriver() == 1 && getVehicleType() == 9){
		SendChat("/helm")
		helm := true
	}
}

OnPlayerExitVehicle(){
	if(IsPlayerDriver() == 1 && IsVehicleEngineEnabled() == 1){
		SendChat("/motor")
	}
	if(IsPlayerDriver() == 1 && IsVehicleLightEnabled() == 1){
		SendChat("/licht")
	}
	if(IsPlayerDriver() == 1 && IsVehicleLocked() == 1){
		SendChat("/flock")
	}
	if(IsPlayerDriver() == 1 && getVehicleType() == 9){
		SendChat("/helm")
		helm := false
	}
}

KMSG(myText){
	return AddChatMessage("{58FA82}[Keybinder]{FBEFEF} " myText)
}

GetChatLine(Line, ByRef Output, timestamp=0, color=0){
	chatindex := 0
	FileRead, file, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	loop, Parse, file, `n, `r
	{
		if(A_LoopField)
	chatindex := A_Index
	}
	loop, Parse, file, `n, `r
	{
		if(A_Index = chatindex - line){
			output := A_LoopField
			break
		}
	}
	file := ""
	if(!timestamp)
		output := RegExReplace(output, "U)^\[\d{2}:\d{2}:\d{2}\]")
	if(!color)
		output := RegExReplace(output, "Ui)\{[a-f0-9]{6}\}")
	return
}

PlayerInput(text){
	s := A_IsSuspended
	Suspend On
	KeyWait Enter
	SendInput t^a{backspace}%text%
	Input, var, v, {enter}
	SendInput ^a{backspace 100}{enter}
	Sleep, 20
	if(!s)
	Suspend Off
	return var
}

SendBind(i){
	IniRead, myKills, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
	IniRead, myDeaths, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
	ID := getPlayerID()
	VehType := getVehicleType()
	getZoneName(Zone, 65)
	getCityName(City, 65)
	getPlayerName(Name, 65)
	StringReplace, i, i, [ID], %ID%, All
	StringReplace, i, i, [VehType], %VehType%, All
	StringReplace, i, i, [Zone], %Zone%, All
	StringReplace, i, i, [City], %City%, All
	StringReplace, i, i, [Name], %Name%, All
	StringReplace, i, i, [Kills], %myKills%, All
	StringReplace, i, i, [Deaths], %myDeaths%, All
	return SendChat(i)
}

checkKeyVar := 20

IniRead, Key01, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key01
if(Key01 == "ERROR" || Key01 == ""){
	Key01 := ""
	IniWrite, %Key01%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key01
}
IniRead, Key02, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key02
if(Key02 == "ERROR" || Key02 == ""){
	Key02 := ""
	IniWrite, %Key02%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key02
}
IniRead, Key03, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key03
if(Key03 == "ERROR" || Key03 == ""){
	Key03 := ""
	IniWrite, %Key03%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key03
}
IniRead, Key04, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key04
if(Key04 == "ERROR" || Key04 == ""){
	Key04 := ""
	IniWrite, %Key04%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key04
}
IniRead, Key05, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key05
if(Key05 == "ERROR" || Key05 == ""){
	Key05 := ""
	IniWrite, %Key05%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key05
}
IniRead, Key06, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key06
if(Key06 == "ERROR" || Key06 == ""){
	Key06 := ""
	IniWrite, %Key06%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key06
}
IniRead, Key07, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key07
if(Key07 == "ERROR" || Key07 == ""){
	Key07 := ""
	IniWrite, %Key07%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key07
}
IniRead, Key08, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key08
if(Key08 == "ERROR" || Key08 == ""){
	Key08 := ""
	IniWrite, %Key08%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key08
}
IniRead, Key09, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key09
if(Key09 == "ERROR" || Key09 == ""){
	Key09 := ""
	IniWrite, %Key09%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key09
}
IniRead, Key10, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key10
if(Key10 == "ERROR" || Key10 == ""){
	Key10 := ""
	IniWrite, %Key10%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key10
}
IniRead, Key11, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key11
if(Key11 == "ERROR" || Key11 == ""){
	Key11 := ""
	IniWrite, %Key11%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key11
}
IniRead, Key12, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key12
if(Key12 == "ERROR" || Key12 == ""){
	Key12 := ""
	IniWrite, %Key12%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key12
}
IniRead, Key13, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key13
if(Key13 == "ERROR" || Key13 == ""){
	Key13 := ""
	IniWrite, %Key13%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key13
}
IniRead, Key14, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key14
if(Key14 == "ERROR" || Key14 == ""){
	Key14 := ""
	IniWrite, %Key14%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key14
}
IniRead, Key15, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key15
if(Key15 == "ERROR" || Key15 == ""){
	Key15 := ""
	IniWrite, %Key15%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key15
}
IniRead, Key16, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key16
if(Key16 == "ERROR" || Key16 == ""){
	Key16 := ""
	IniWrite, %Key16%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key16
}
IniRead, Key17, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key17
if(Key17 == "ERROR" || Key17 == ""){
	Key17 := ""
	IniWrite, %Key17%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key17
}
IniRead, Key18, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key18
if(Key18 == "ERROR" || Key18 == ""){
	Key18 := ""
	IniWrite, %Key18%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key18
}
IniRead, Key19, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key19
if(Key19 == "ERROR" || Key19 == ""){
	Key19 := ""
	IniWrite, %Key19%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key19
}
IniRead, Key20, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key20
if(Key20 == "ERROR" || Key20 == ""){
	Key20 := ""
	IniWrite, %Key20%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key20
}
IniRead, TextString01, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 01
if(TextString01 == "ERROR"){
	TextString01 := ""
	IniWrite, %TextString01%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 01
}
IniRead, TextString02, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 02
if(TextString02 == "ERROR"){
	TextString02 := ""
	IniWrite, %TextString02%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 02
}
IniRead, TextString03, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 03
if(TextString03 == "ERROR"){
	TextString03 := ""
	IniWrite, %TextString03%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 03
}
IniRead, TextString04, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 04
if(TextString04 == "ERROR"){
	TextString04 := ""
	IniWrite, %TextString04%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 04
}
IniRead, TextString05, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 05
if(TextString05 == "ERROR"){
	TextString05 := ""
	IniWrite, %TextString05%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 05
}
IniRead, TextString06, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 06
if(TextString06 == "ERROR"){
	TextString06 := ""
	IniWrite, %TextString06%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 06
}
IniRead, TextString07, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 07
if(TextString07 == "ERROR"){
	TextString07 := ""
	IniWrite, %TextString07%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 07
}
IniRead, TextString08, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 08
if(TextString08 == "ERROR"){
	TextString08 := ""
	IniWrite, %TextString08%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 08
}
IniRead, TextString09, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 09
if(TextString09 == "ERROR"){
	TextString09 := ""
	IniWrite, %TextString09%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 09
}
IniRead, TextString10, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 10
if(TextString10 == "ERROR"){
	TextString10 := ""
	IniWrite, %TextString10%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 10
}
IniRead, TextString11, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 11
if(TextString11 == "ERROR"){
	TextString11 := ""
	IniWrite, %TextString11%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 11
}
IniRead, TextString12, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 12
if(TextString12 == "ERROR"){
	TextString12 := ""
	IniWrite, %TextString12%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 12
}
IniRead, TextString13, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 13
if(TextString13 == "ERROR"){
	TextString13 := ""
	IniWrite, %TextString13%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 13
}
IniRead, TextString14, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 14
if(TextString14 == "ERROR"){
	TextString14 := ""
	IniWrite, %TextString14%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 14
}
IniRead, TextString15, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 15
if(TextString15 == "ERROR"){
	TextString15 := ""
	IniWrite, %TextString15%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 15
}
IniRead, TextString16, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 16
if(TextString16 == "ERROR"){
	TextString16 := ""
	IniWrite, %TextString16%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 16
}
IniRead, TextString17, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 17
if(TextString17 == "ERROR"){
	TextString17 := ""
	IniWrite, %TextString17%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 17
}
IniRead, TextString18, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 18
if(TextString18 == "ERROR"){
	TextString18 := ""
	IniWrite, %TextString18%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 18
}
IniRead, TextString19, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 19
if(TextString19 == "ERROR"){
	TextString19 := ""
	IniWrite, %TextString19%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 19
}
IniRead, TextString20, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 20
if(TextString20 == "ERROR"){
	TextString20 := ""
	IniWrite, %TextString20%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 20
}
IniRead, AEngine, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Engine
if(AEngine == "ERROR" || AEngine == ""){
	AEngine := 1
	IniWrite, %AEngine%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Engine
}
IniRead, AZoll, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Zoll
if(AZoll == "ERROR" || AZoll == ""){
	AZoll := 1
	IniWrite, %AZoll%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Zoll
}
IniRead, TogKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, ToggleKey
if(TogKey == "ERROR" || TogKey == ""){
	TogKey := F12
	IniWrite, %TogKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, ToggleKey
}
IniRead, OV, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Status
if(OV == "ERROR" || OV == ""){
	OV := 0
	IniWrite, %OV%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Status
}
IniRead, OVcolor, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Color
if(OVcolor == "ERROR" || OVcolor == ""){
	OVcolor := 2
	IniWrite, %OVcolor%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Color
}
IniRead, OVsize, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Size
if(OVsize == "ERROR" || OVsize == ""){
	OVsize := 8
	IniWrite, %OVsize%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Size
}
IniRead, 1kx, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
if(1kx == "ERROR" || 1kx == ""){
	1kx := 15
	IniWrite, %1kx%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
}
IniRead, 1ky, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
if(1ky == "ERROR" || 1ky == ""){
	1ky := 250
	IniWrite, %1ky%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
}
IniRead, killMsgPrivate, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Private
if(killMsgPrivate == "ERROR" || killMsgPrivate == ""){
	killMsgPrivate := 0
	IniWrite, %killMsgPrivate%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Private
}
IniRead, killMsgPublic, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Public
if(killMsgPublic == "ERROR" || killMsgPublic == ""){
	killMsgPublic := 0
	IniWrite, %killMsgPublic%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Public
}
IniRead, killMsgFraktion, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Fraktion
if(killMsgFraktion == "ERROR" || killMsgFraktion == ""){
	killMsgFraktion := 0
	IniWrite, %killMsgFraktion%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Fraktion
}
IniRead, deathMsgPrivate, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Private
if(deathMsgPrivate == "ERROR" || deathMsgPrivate == ""){
	deathMsgPrivate := 0
	IniWrite, %deathMsgPrivate%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Private
}
IniRead, deathMsgPublic, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Public
if(deathMsgPublic == "ERROR" || deathMsgPublic == ""){
	deathMsgPublic := 0
	IniWrite, %deathMsgPublic%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Public
}
IniRead, deathMsgFraktion, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Fraktion
if(deathMsgFraktion == "ERROR" || deathMsgFraktion == ""){
	deathMsgFraktion := 0
	IniWrite, %deathMsgFraktion%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Fraktion
}
IniRead, myKills, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
if(myKills == "ERROR" || myKills == ""){
	myKills := 0
	IniWrite, %myKills%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
}
IniRead, myDeaths, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
if(myDeaths == "ERROR" || myDeaths == ""){
	myDeaths := 0
	IniWrite, %myDeaths%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
}
IniRead, KillMSG, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Nachricht
if(KillMSG == "ERROR" || KillMSG == ""){
	KillMSG := "Bruder bei mir läuft! Kills Nr. [kills]"
	IniWrite, %KillMSG%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Nachricht
}
IniRead, deathMSG, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Nachricht
if(deathMSG == "ERROR" || deathMSG == ""){
	deathMSG := "SHIT! Ich bin verreckt!!! Tod Nr. [deaths]"
	IniWrite, %deathMSG%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Nachricht
}
IniRead, DeteKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, DeteKey
if(DeteKey == "ERROR" || DeteKey == ""){
	DeteKey :=
	IniWrite, %DeteKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, DeteKey
}
IniRead, runKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Laufscript, runKey
if(runKey == "ERROR" || runKey == ""){
	runKey := 1
	IniWrite, %runKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Laufscript, runKey
}
IniRead, Adminrang, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Rang
if(Adminrang == "ERROR" || Adminrang == ""){
	Adminrang := 1
	IniWrite, %Adminrang%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Rang
}
IniRead, Ticket, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Ticket
if(Ticket == "ERROR" || Ticket == ""){
	Ticket := 0
	IniWrite, %Ticket%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Ticket
}
IniRead, Waffendealer, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Waffendealer
if(Waffendealer == "ERROR" || Waffendealer == ""){
	Waffendealer := 1
	IniWrite, %Waffendealer%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Waffendealer
}
IniRead, Drogendealer, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Drogendealer
if(Drogendealer == "ERROR" || Drogendealer == ""){
	Drogendealer := 1
	IniWrite, %Drogendealer%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Drogendealer
}
IniRead, Detektiv, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Detektiv
if(Detektiv == "ERROR" || Detektiv == ""){
	Detektiv := 1
	IniWrite, %Detektiv%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Detektiv
}
IniRead, Anwalt, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Anwalt
if(Anwalt == "ERROR" || Anwalt == ""){
	Anwalt := 1
	IniWrite, %Anwalt%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Anwalt
}
IniRead, Fraktion, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Frak
if(Fraktion == "ERROR" || Fraktion == ""){
	Fraktion := 1
	IniWrite, %Fraktion%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Frak
}
IniRead, FRang, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Rang
if(FRang == "ERROR" || FRang == ""){
	FRang := 1
	IniWrite, %FRang%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Rang
}
IniRead, Waffenteile, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
if(Waffenteile == "ERROR" || Waffenteile == ""){
	Waffenteile := 0
	IniWrite, %Waffenteile%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
}
IniRead, Drogen, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
if(Drogen == "ERROR" || Drogen == ""){
	Drogen := 0
	IniWrite, %Drogen%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
}
IniRead, Spice, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
if(Spice == "ERROR" || Spice == ""){
	Spice := 0
	IniWrite, %Spice%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
}
IniRead, Wantedcodes, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
if(Wantedcodes == "ERROR" || Wantedcodes == ""){
	Wantedcodes := 0
	IniWrite, %Wantedcodes%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
}
IniRead, Kekse, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Kekse
if(Kekse == "ERROR" || Kekse == ""){
	Kekse := 0
	IniWrite, %Kekse%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Kekse
}
IniRead, WaffenteileSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
if(WaffenteileSB == "ERROR" || WaffenteileSB == ""){
	WaffenteileSB := 0
	IniWrite, %WaffenteileSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
}
IniRead, DrogenSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
if(DrogenSB == "ERROR" || DrogenSB == ""){
	DrogenSB := 0
	IniWrite, %DrogenSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
}
IniRead, SpiceSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
if(SpiceSB == "ERROR" || SpiceSB == ""){
	SpiceSB := 0
	IniWrite, %SpiceSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
}
IniRead, WantedcodesSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
if(WantedcodesSB == "ERROR" || WantedcodesSB == ""){
	WantedcodesSB := 0
	IniWrite, %WantedcodesSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
}
IniRead, KekseKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, KekseKey
if(KekseKey == "ERROR" || KekseKey == ""){
	KekseKey :=
	IniWrite, %KekseKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, KekseKey
}
IniRead, SpiceKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, SpiceKey
if(SpiceKey == "ERROR" || SpiceKey == ""){
	SpiceKey :=
	IniWrite, %SpiceKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, SpiceKey
}
IniRead, IntKey, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, IntKey
if(IntKey == "ERROR" || IntKey == ""){
	IntKey :=
	IniWrite, %IntKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, IntKey
}

Hotkey, ~%Key01%, Hotkey01
Hotkey, ~%Key02%, Hotkey02
Hotkey, ~%Key03%, Hotkey03
Hotkey, ~%Key04%, Hotkey04
Hotkey, ~%Key05%, Hotkey05
Hotkey, ~%Key06%, Hotkey06
Hotkey, ~%Key07%, Hotkey07
Hotkey, ~%Key08%, Hotkey08
Hotkey, ~%Key09%, Hotkey09
Hotkey, ~%Key10%, Hotkey10
Hotkey, ~%Key11%, Hotkey11
Hotkey, ~%Key12%, Hotkey12
Hotkey, ~%Key13%, Hotkey13
Hotkey, ~%Key14%, Hotkey14
Hotkey, ~%Key15%, Hotkey15
Hotkey, ~%Key16%, Hotkey16
Hotkey, ~%Key17%, Hotkey17
Hotkey, ~%Key18%, Hotkey18
Hotkey, ~%Key19%, Hotkey19
Hotkey, ~%Key20%, Hotkey20
Hotkey, ~%TogKey%, ToggleKey
Hotkey, ~%DeteKey%, DKey
Hotkey, ~%KekseKey%, KKey
Hotkey, ~%SpiceKey%, SKey
HotKey, ~%IntKey%, IKey

global helm 				:= false
global OVloaded				:= false
global overlayMoveTog 		:= false
global myDeteTime			:= 10000
global DeathTime			:= 15000
global ticketTimeMin		:= 0
global ticketTimeSek		:= 0

if(AEngine == 1){
	SetTimer, engineTimer, On
}else{
	SetTimer, engineTimer, Off
}
if(Ticket == 1){
	SetTimer, Tickets, On
}else{
	SetTimer, Tickets, Off
}

SetTimer, Overlay, Off
SetTimer, mainTimer, On
SetTimer, Counter, On
SetTimer, Detektiv, Off
SetTimer, DeathTimeout, Off
SetTimer, TicketMin, Off
SetTimer, TicketSek, Off
SetTimer, SpiceTimer, Off

gosub, main

return

GuiClose:
TextDestroy(HPoverlay)
ExitApp

Main:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, Picture, x0 y0 w910 h20 , %A_AppData%\Keybinder\LyD_Keybinder\blau.jpg
Gui, Add, Picture, x0 y440 w900 h50 , %A_AppData%\Keybinder\LyD_Keybinder\grau.jpg
Gui, Add, Hotkey, x2 y39 w100 h30 vKey01, %Key01%
Gui, Add, Hotkey, x2 y79 w100 h30 vKey02, %Key02%
Gui, Add, Hotkey, x2 y119 w100 h30 vKey03, %Key03%
Gui, Add, Hotkey, x2 y159 w100 h30 vKey04, %Key04%
Gui, Add, Hotkey, x2 y199 w100 h30 vKey05, %Key05%
Gui, Add, Hotkey, x2 y239 w100 h30 vKey06, %Key06%
Gui, Add, Hotkey, x2 y279 w100 h30 vKey07, %Key07%
Gui, Add, Hotkey, x2 y319 w100 h30 vKey08, %Key08%
Gui, Add, Hotkey, x2 y359 w100 h30 vKey09, %Key09%
Gui, Add, Hotkey, x2 y399 w100 h30 vKey10, %Key10%
Gui, Add, Edit, x112 y39 w260 h30 vTextString01, %TextString01%
Gui, Add, Edit, x112 y79 w260 h30 vTextString02, %TextString02%
Gui, Add, Edit, x112 y119 w260 h30 vTextString03, %TextString03%
Gui, Add, Edit, x112 y159 w260 h30 vTextString04, %TextString04%
Gui, Add, Edit, x112 y199 w260 h30 vTextString05, %TextString05%
Gui, Add, Edit, x112 y239 w260 h30 vTextString06, %TextString06%
Gui, Add, Edit, x112 y279 w260 h30 vTextString07, %TextString07%
Gui, Add, Edit, x112 y319 w260 h30 vTextString08, %TextString08%
Gui, Add, Edit, x112 y359 w260 h30 vTextString09, %TextString09%
Gui, Add, Edit, x112 y399 w260 h30 vTextString10, %TextString10%
Gui, Add, Hotkey, x402 y39 w100 h30 vKey11, %Key11%
Gui, Add, Hotkey, x402 y79 w100 h30 vKey12, %Key12%
Gui, Add, Hotkey, x402 y119 w100 h30 vKey13, %Key13%
Gui, Add, Hotkey, x402 y159 w100 h30 vKey14, %Key14%
Gui, Add, Hotkey, x402 y199 w100 h30 vKey15, %Key15%
Gui, Add, Hotkey, x402 y239 w100 h30 vKey16, %Key16%
Gui, Add, Hotkey, x402 y279 w100 h30 vKey17, %Key17% 
Gui, Add, Hotkey, x402 y319 w100 h30 vKey18, %Key18%
Gui, Add, Hotkey, x402 y359 w100 h30 vKey19, %Key19%
Gui, Add, Hotkey, x402 y399 w100 h30 vKey20, %Key20%
Gui, Add, Edit, x512 y39 w260 h30 vTextString11, %TextString11%
Gui, Add, Edit, x512 y79 w260 h30 vTextString12, %TextString12%
Gui, Add, Edit, x512 y119 w260 h30 vTextString13, %TextString13%
Gui, Add, Edit, x512 y159 w260 h30 vTextString14, %TextString14%
Gui, Add, Edit, x512 y199 w260 h30 vTextString15, %TextString15%
Gui, Add, Edit, x512 y239 w260 h30 vTextString16, %TextString16%
Gui, Add, Edit, x512 y279 w260 h30 vTextString17, %TextString17%
Gui, Add, Edit, x512 y319 w260 h30 vTextString18, %TextString18%
Gui, Add, Edit, x512 y359 w260 h30 vTextString19, %TextString19%
Gui, Add, Edit, x512 y399 w260 h30 vTextString20, %TextString20%
Gui, Add, Text, x2 y-1 w770 h40 cWhite +Center +BackgroundTrans, Live your Dream Keybinder
Gui, Add, Button, x672 y449 w100 h30 gSave, Save
Gui, Add, Button, x552 y449 w100 h30 gSettings, Settings
Gui, Add, Button, x432 y449 w100 h30 gStats, Stats
Gui, Add, Button, x312 y449 w100 h30 gVariablen, Variablen
Gui, Add, Button, x192 y449 w100 h30 gHelp, Help
Gui, Add, Button, x72 y449 w100 h30 gBefehle, Weitere Befehle
Gui, Add, Text, x2 y19 w90 h20 +Center +BackgroundTrans, Hotkey
Gui, Add, Text, x112 y19 w250 h20 +Center +BackgroundTrans, Text
Gui, Add, Text, x402 y19 w100 h20 +Center +BackgroundTrans, Hotkey
Gui, Add, Text, x512 y19 w250 h20 +Center +BackgroundTrans, Text
Gui, Show, w775 h490, Live your Dream Keybinder | Home
return

Help:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, Text, x2 y-1 w470 h30 +Center, Live your Dream Keybinder - Help
Gui, Add, Text, x2 y39 w470 h310 , - Der Keybinder hängt oder ist verzögert?`n`tLasse für ca. 2 Sekunden das Scoreboard geöffnet`n`tStarte den Keybinder erst, wenn du dich Ingame befindest`n`n- 
Gui, Add, Button, x312 y349 w160 h30 gAbord, Zurück
Gui, Show, w476 h384, Live your Dream Keybinder | Help
return

Befehle:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, Text, x2 y-1 w470 h30 +Center, Live your Dream Keybinder - Weitere Befehle
if(Adminrang > "1"){
	Gui, Add, Text, x2 y39 w470 h310 ,- /ov `t`t`t`t`tIngame Overlay an-/ausschalten (Kann crashes verursachen)`n- /moveov `t`t`t`tOverlay verschieben`n- /laufen `t`t`t`tLaufscript an-/ausschalten`n- /setkills `t`t`t`tKills setzen`n- /setdeaths `t`t`t`tTode setzen`n`nTeammitglieder:`nAlt I: Ticket annehmen`nAlt O: Brauchst du noch Hilfe?`nAlt P: Ticket schließen
}else{
	Gui, Add, Text, x2 y39 w470 h310 , - /ov `t`t`t`t`tIngame Overlay an-/ausschalten (Kann crashes verursachen)`n- /moveov `t`t`t`tOverlay verschieben`n- /laufen `t`t`t`tLaufscript an-/ausschalten`n- /setkills `t`t`t`tKills setzen`n- /setdeaths `t`t`t`tTode setzen
}
Gui, Add, Button, x312 y349 w160 h30 gAbord, Zurück
Gui, Show, w476 h384, Live your Dream Keybinder | Weitere Befehle
return

Save:
GuiControlGet, Key01
GuiControlGet, Key02
GuiControlGet, Key03
GuiControlGet, Key04
GuiControlGet, Key05
GuiControlGet, Key06
GuiControlGet, Key07
GuiControlGet, Key08
GuiControlGet, Key09
GuiControlGet, Key10
GuiControlGet, Key11
GuiControlGet, Key12
GuiControlGet, Key13
GuiControlGet, Key14
GuiControlGet, Key15
GuiControlGet, Key16
GuiControlGet, Key17
GuiControlGet, Key18
GuiControlGet, Key19
GuiControlGet, Key20
IniWrite, %Key01%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key01
IniWrite, %Key02%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key02
IniWrite, %Key03%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key03
IniWrite, %Key04%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key04
IniWrite, %Key05%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key05
IniWrite, %Key06%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key06
IniWrite, %Key07%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key07
IniWrite, %Key08%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key08
IniWrite, %Key09%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key09
IniWrite, %Key10%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key10
IniWrite, %Key11%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key11
IniWrite, %Key12%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key12
IniWrite, %Key13%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key13
IniWrite, %Key14%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key14
IniWrite, %Key15%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key15
IniWrite, %Key16%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key16
IniWrite, %Key17%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key17
IniWrite, %Key18%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key18
IniWrite, %Key19%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key19
IniWrite, %Key20%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Hotkeys, Key20
GuiControlGet, TextString01
GuiControlGet, TextString02
GuiControlGet, TextString03
GuiControlGet, TextString04
GuiControlGet, TextString05
GuiControlGet, TextString06
GuiControlGet, TextString07
GuiControlGet, TextString08
GuiControlGet, TextString09
GuiControlGet, TextString10
GuiControlGet, TextString11
GuiControlGet, TextString12
GuiControlGet, TextString13
GuiControlGet, TextString14
GuiControlGet, TextString15
GuiControlGet, TextString16
GuiControlGet, TextString17
GuiControlGet, TextString18
GuiControlGet, TextString19
GuiControlGet, TextString20
IniWrite, %TextString01%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 01
IniWrite, %TextString02%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 02
IniWrite, %TextString03%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 03
IniWrite, %TextString04%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 04
IniWrite, %TextString05%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 05
IniWrite, %TextString06%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 06
IniWrite, %TextString07%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 07
IniWrite, %TextString08%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 08
IniWrite, %TextString09%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 09
IniWrite, %TextString10%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 10
IniWrite, %TextString11%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 11
IniWrite, %TextString12%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 12
IniWrite, %TextString13%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 13
IniWrite, %TextString14%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 14
IniWrite, %TextString15%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 15
IniWrite, %TextString16%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 16
IniWrite, %TextString17%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 17
IniWrite, %TextString18%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 18
IniWrite, %TextString19%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 19
IniWrite, %TextString20%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Text, 20
Reload
return

Variablen:
MsgBox, 0, Live your Dream Keybinder | Variablen, Variablen für den Live your Dream Keybinder:`n`n [ID] = ID`n [Zone] = Zone`n [City] = City`n [VehType] = Fahrzeug Typ`n [Kills] = Kills`n [Deaths] = Deaths
return

Settings:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, Picture, x-8 y-1 w1450 h50 , %A_AppData%\Keybinder\LyD_Keybinder\blau.jpg
Gui, Add, Picture, x-8 y559 w780 h60 , %A_AppData%\Keybinder\LyD_Keybinder\grau.jpg
Gui, Add, Text, x236 y9 w280 h20 cWhite +Center +BackgroundTrans, Live your Dream Keybinder | Einstellungen
Gui, Add, GroupBox, x12 y59 w730 h70 , 
Gui, Add, GroupBox, x12 y129 w730 h80 , 
Gui, Add, GroupBox, x12 y199 w730 h80 , 
Gui, Add, GroupBox, x12 y279 w730 h40 , 
Gui, Add, GroupBox, x12 y319 w730 h70 , 
Gui, Add, GroupBox, x12 y389 w730 h70 , 
Gui, Add, CheckBox, x22 y69 w170 h20 vkillMsgPrivate Checked%killMsgPrivate%, Killcounter Privat
Gui, Add, CheckBox, x212 y69 w170 h20 vkillMsgPublic Checked%killMsgPublic%, Killcounter IC
Gui, Add, CheckBox, x402 y69 w170 h20 vkillMsgFraktion Checked%killMsgFraktion%, Killcounter Fraktion
Gui, Add, Edit, x22 y99 w500 h20 vKillMSG, %KillMSG%
Gui, Add, Text, x532 y99 , Killspruch
Gui, Add, CheckBox, x22 y139 w170 h20 vdeathMsgPrivate Checked%deathMsgPrivate%, Deathcounter Privat
Gui, Add, CheckBox, x212 y139 w170 h20 vdeathMsgPublic Checked%deathMsgPublic%, Deathcounter IC
Gui, Add, CheckBox, x402 y139 w170 h20 vdeathMsgFraktion Checked%deathMsgFraktion%, Deathcounter Fraktion
Gui, Add, Edit, x22 y169 w500 h20 vdeathMSG, %deathMSG%
Gui, Add, Text, x532 y169 , Todesspruch
Gui, Add, Text, x22 y209 w170 h20 , Overlay
Gui, Add, DropDownList, x22 y239 w170 h120 vOVsize Choose%OVsize%, 1|2|3|4|5|6|7|8|9|10|12|13|14|15|16|17|18
Gui, Add, Text, x202 y239 w120 h20 , Größe
Gui, Add, DropDownList, x382 y239 w170 h120 vOVcolor Choose%OVcolor%, Schwarz|Weiß|Grün|Blau|Rot|Gelb
Gui, Add, Text, x562 y239 w120 h20 , Farbe
Gui, Add, CheckBox, x22 y289 w170 h20 vAEngine Checked%AEngine%, Automatisches Motorsystem
Gui, Add, CheckBox, x212 y289 w170 h20 vAZoll Checked%AZoll%, Automatischer Zoll
Gui, Add, CheckBox, x402 y289 w170 h20 , Platzhalter
Gui, Add, Hotkey, x22 y329 w80 h20 vDeteKey, %DeteKey%
Gui, Add, Text, x102 y329 w100 h20 , Detektivbot Hotkey
Gui, Add, Hotkey, x212 y329 w80 h20 vKekseKey, %KekseKey%
Gui, Add, Text, x292 y329 w100 h20 , Keksebot Hotkey
Gui, Add, Hotkey, x402 y329 w80 h20 vSpiceKey, %SpiceKey%
Gui, Add, Text, x482 y329 w100 h20 , Spicebot Hotkey
Gui, Add, Hotkey, x22 y359 w80 h20 vIntkey, %IntKey%
Gui, Add, Text, x102 y359 w100 h20 , Interaktionstaste
Gui, Add, Hotkey, x212 y359 w80 h20 , 
Gui, Add, Text, x292 y359 w100 h20 , Platzhalter
Gui, Add, Hotkey, x402 y359 w80 h20 vTogKey, %TogKey%
Gui, Add, Text, x482 y359 w140 h20 , Keybinder ein-/ausschalten
Gui, Add, Text, x22 y399 w170 h20 , Laufscript
Gui, Add, DropDownList, x22 y429 w170 h120 vrunKey Choose%runKey%, Space|Shift|Alt
Gui, Add, Text, x202 y429 w120 h20 , Sprinttaste
Gui, Add, Button, x642 y569 w100 h30 gSetSave, Speichern
Gui, Add, Button, x532 y569 w100 h30 gAbord, Abbrechen
Gui, Add, Button, x422 y569 w100 h30 gVariablen, Variablen
Gui, Show, w757 h615, Untitled GUI
return

/*
SettingsOLD:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, Text, x2 y-1 w460 h30 +Center, Live your Dream Keybinder Einstellungen
;~ Gui, Add, CheckBox, x12 y39 w450 h30 vAEngine Checked%AEngine%, Automatisches Motor System
;~ Gui, Add, CheckBox, x12 y79 w450 h30 vOV Checked%OV% , Ingame Overlay
;~ Gui, Add, DropDownList, x322 y119 w140 h100 vOVcolor Choose%OVcolor%, Schwarz|Weiß|Grün|Blau|Rot|Gelb
;~ Gui, Add, Text, x222 y119 w100 h20 +Right, Farbe:
;~ Gui, Add, DropDownList, x82 y119 w140 h100 vOVsize Choose%OVsize%, 1|2|3|4|5|6|7|8|9|10|12|13|14|15|16|17|18
;~ Gui, Add, Text, x2 y119 w80 h20 +Right, Größe:
Gui, Add, Hotkey, x12 y170 w100 h30 vTogKey, %TogKey%
Gui, Add, Text, x122 y175 w340 h30 +Left, Keybinder Aus-/Einschalten
;~ Gui, Add, CheckBox, x12 y225 w450 h30 vkillMsgPrivate Checked%killMsgPrivate% , KillCounter Privat
;~ Gui, Add, CheckBox, x12 y250 w450 h30 vkillMsgPublic Checked%killMsgPublic% , KillCounter IC
;~ Gui, Add, CheckBox, x12 y275 w450 h30 vkillMsgFraktion Checked%killMsgFraktion% , KillCounter Fraktion
Gui, Add, Edit, x12 y310 w260 h30 vKillMSG, %KillMSG%
Gui, Add, Text, x295 y315, 'Killnachricht' | Kill Nr. [KillNr]
;~ Gui, Add, Hotkey, x12 y360 w100 h30 vDeteKey, %DeteKey%
;~ Gui, Add, Text, x122 y365, Detektiv-Bot Hotkey
;~ Gui, Add, DropDownList, x12 y410 w100 h130 vrunKey Choose%runKey%, Space|Shift|Alt
Gui, Add, Text, x122 y415, Laufscript Taste
Gui, Add, Button, x352 y479 w100 h30 gSetSave, Save
Gui, Add, Button, x232 y479 w100 h30 gAbord, Abbrechen
Gui, Show, w466 h524, Live your Dream Keybinder | Settings
return
*/

SetSave:
GuiControlGet, AEngine
IniWrite, %AEngine%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Engine
GuiControlGet, OV
IniWrite, %OV%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Status
GuiControlGet, OVcolor
if(OVcolor == "Schwarz"){
	OVcolorVar := 1
}else if(OVcolor == "Weiß"){
	OVcolorVar := 2
}else if(OVcolor == "Grün"){
	OVcolorVar := 3
}else if(OVcolor == "Blau"){
	OVcolorVar := 4
}else if(OVcolor == "Rot"){
	OVcolorVar := 5
}else if(OVcolor == "Gelb"){
	OVcolorVar := 6
}else{
	OVcolorVar := 2
}
IniWrite, %OVcolorVar%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Color
GuiControlGet, OVsize
IniWrite, %OVsize%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Size
GuiControlGet, TogKey
IniWrite, %TogKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, ToggleKey
GuiControlGet, killMsgPrivate
IniWrite, %killMsgPrivate%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Private
GuiControlGet, killMsgPublic
IniWrite, %killMsgPublic%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Public
GuiControlGet, killMsgFraktion
IniWrite, %killMsgFraktion%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Fraktion
GuiControlGet, KillMSG
IniWrite, %KillMSG%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Nachricht
GuiControlGet, DeteKey
IniWrite, %DeteKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, DeteKey
GuiControlGet, runKey
if(runKey == "Space"){
	runKey := 1
}else if(runKey == "Shift"){
	runKey := 2
}else if(runKey == "Alt"){
	runKey := 3
}
IniWrite, %runKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Laufscript, runKey
GuiControlGet, deathMSG
IniWrite, %deathMSG%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Nachricht
GuiControlGet, deathMsgPrivate
IniWrite, %deathMsgPrivate%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Private
GuiControlGet, deathMsgPublic
IniWrite, %deathMsgPublic%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Public
GuiControlGet, deathMsgFraktion
IniWrite, %deathMsgFraktion%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Fraktion
GuiControlGet, AZoll
IniWrite, %AZoll%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, Automatic, Zoll
GuiControlGet, KekseKey
IniWrite, %KekseKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, KekseKey
GuiControlGet, SpiceKey
IniWrite, %SpiceKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, SpiceKey
GuiControlGet, IntKey
IniWrite, %IntKey%, %A_AppData%\Keybinder\LyD_Keybinder\config\Hotkeys.ini, Others, IntKey
Reload
return

Stats:
Gui, Destroy
Gui, Color, FFFFFFF
Gui, Add, GroupBox, x2 y69 w370 h70 , 
Gui, Add, GroupBox, x2 y139 w370 h130 , 
Gui, Add, GroupBox, x2 y269 w370 h70 , 
Gui, Add, GroupBox, x502 y69 w380 h160 , 
Gui, Add, GroupBox, x502 y229 w380 h130 , 
Gui, Add, GroupBox, x2 y339 w370 h70 , 
Gui, Add, Picture, x-8 y-1 w910 h50 , %A_AppData%\Keybinder\LyD_Keybinder\blau.jpg
Gui, Add, Picture, x-8 y549 w900 h50 , %A_AppData%\Keybinder\LyD_Keybinder\grau.jpg
Gui, Add, Text, x230 y9 w420 h40 cWhite +Center +BackgroundTrans, Live your Dream Keybinder
Gui, Add, DropDownList, x12 y79 w180 h120 vAdminrang Choose%Adminrang%, Kein Admin|Supporter|Moderator|Administrator|Entwickler|Server Manager|Serverleitung
Gui, Add, Text, x202 y79 w160 h20 , Adminrang
Gui, Add, CheckBox, x172 y109 w190 h20 vTicket Checked%Ticket%, Ticketsystem
Gui, Add, DropDownList, x12 y149 w180 h120 vWaffendealer Choose%Waffendealer%, 1|2|3|4|5
Gui, Add, Text, x202 y149 w160 h20 , Waffendealer Skill
Gui, Add, DropDownList, x12 y179 w180 h120 vDrogendealer Choose%Drogendealer%, 1|2|3|4|5
Gui, Add, Text, x202 y179 w160 h20 , Drogendealer Skill
Gui, Add, DropDownList, x12 y209 w180 h120 vDetektiv Choose%Detektiv%, 1|2|3|4|5
Gui, Add, Text, x202 y209 w160 h20 , Detektiv Skill
Gui, Add, DropDownList, x12 y239 w180 h120 vAnwalt Choose%Anwalt%, 1|2|3|4|5|6
Gui, Add, Text, x202 y239 w160 h20 , Anwalt Skill
Gui, Add, DropDownList, x12 y279 w180 h120 vFraktion Choose%Fraktion%, Zivilist|Staatsfraktion|Organisation|Gang/Mafia
Gui, Add, Text, x202 y279 w160 h20 , Fraktion
Gui, Add, DropDownList, x12 y309 w180 h120 vFRang Choose%FRang%, 0|1|2|3|4|5|6
Gui, Add, Text, x202 y309 w160 h20 , Rang
Gui, Add, Edit, x12 y349 w180 h20 vmyKills, %myKills%
Gui, Add, Text, x202 y349 w160 h20 , Kills
Gui, Add, Edit, x12 y379 w180 h20 vmyDeaths, %myDeaths%
Gui, Add, Text, x202 y379 w160 h20 , Deaths
Gui, Add, Edit, x512 y79 w180 h20 vWaffenteile, %Waffenteile%
Gui, Add, Text, x702 y79 w170 h20 , Waffenteile (Hand)
Gui, Add, Edit, x512 y109 w180 h20 vDrogen, %Drogen%
Gui, Add, Text, x702 y109 w170 h20 , Drogen (Hand)
Gui, Add, Edit, x512 y139 w180 h20 vSpice, %Spice%
Gui, Add, Text, x702 y139 w170 h20 , Spice (Hand)
Gui, Add, Edit, x512 y169 w180 h20 vWantedcodes, %Wantedcodes%
Gui, Add, Text, x702 y169 w170 h20 , Wantedcodes (Hand)
Gui, Add, Edit, x512 y199 w180 h20 vKekse, %Kekse%
Gui, Add, Text, x702 y199 w170 h20 , Kekse
Gui, Add, Edit, x512 y239 w180 h20 vWaffenteileSB, %WaffenteileSB%
Gui, Add, Text, x702 y239 w170 h20 , Waffenteile (Safebox)
Gui, Add, Edit, x512 y269 w180 h20 vDrogenSB, %DrogenSB%
Gui, Add, Text, x702 y269 w170 h20 , Drogen (Safebox)
Gui, Add, Edit, x512 y299 w180 h20 vSpiceSB, %SpiceSB%
Gui, Add, Text, x702 y299 w170 h20 , Spice (Safebox)
Gui, Add, Edit, x512 y329 w180 h20 vWantedcodesSB, %WantedcodesSB%
Gui, Add, Text, x702 y329 w170 h20 , Wantedcodes (Safebox)
Gui, Add, Button, x662 y559 w100 h30 gAbord, Abbrechen
Gui, Add, Button, x772 y559 w100 h30 gStatsSave, Speichern
Gui, Show, w891 h598, Live your Dream Keybinder | Stats
return

StatsSave:
GuiControlGet, Adminrang
if(Adminrang == "Kein Admin"){
	AdminrangVar := 1
}else if(Adminrang == "Supporter"){
	AdminrangVar := 2
}else if(Adminrang == "Moderator"){
	AdminrangVar := 3
}else if(Adminrang == "Administrator"){
	AdminrangVar := 4
}else if(Adminrang == "Entwickler"){
	AdminrangVar := 5
}else if(Adminrang == "Server Manager"){
	AdminrangVar := 6
}else if(Adminrang == "Serverleitung"){
	AdminrangVar := 7
}else{
	AdminrangVar := 1
}
IniWrite, %AdminrangVar%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Rang
GuiControlGet, Ticket
IniWrite, %Ticket%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Admin, Ticket
GuiControlGet, Waffendealer
IniWrite, %Waffendealer%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Waffendealer
GuiControlGet, Drogendealer
IniWrite, %Drogendealer%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Drogendealer
GuiControlGet, Detektiv
IniWrite, %Detektiv%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Detektiv
GuiControlGet, Anwalt
IniWrite, %Anwalt%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Skills, Anwalt
GuiControlGet, Fraktion
if(Fraktion == "Zivilist"){
	FraktionVar := 1
}else if(Fraktion == "Staatsfraktion"){
	FraktionVar := 2
}else if(Fraktion == "Organisation"){
	FraktionVar := 3
}else if(Fraktion == "Gang/Mafia"){
	FraktionVar := 4
}else{
	FraktionVar := 1
}
IniWrite, %FraktionVar%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Frak
GuiControlGet, FRang
if(FRang == "0"){
	FRangVar := 1
}else if(FRang == "1"){
	FRangVar := 2
}else if(FRang == "2"){
	FRangVar := 3
}else if(FRang == "3"){
	FRangVar := 4
}else if(FRang == "4"){
	FRangVar := 5
}else if(FRang == "5"){
	FRangVar := 6
}else if(FRang == "6"){
	FRangVar := 7
}else{
	FRangVar := 1
}
IniWrite, %FRangVar%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Fraktion, Rang
GuiControlGet, myKills
if myKills is Integer
{
	if(myKills > -1){
		IniWrite, %myKills%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
	}
}
GuiControlGet, myDeaths
if myDeaths is Integer
{
	if(myDeaths > -1){
		IniWrite, %myDeaths%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
	}
}
GuiControlGet, Waffenteile
if Waffenteile is Integer
{
	if(Waffenteile > -1){
		IniWrite, %Waffenteile%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	}
}
GuiControlGet, Drogen
if Drogen is Integer
{
	if(Drogen > -1){
		IniWrite, %Drogen%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	}
}
GuiControlGet, Spice
if Spice is Integer
{
	if(Spice > -1){
		IniWrite, %Spice%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
	}
}
GuiControlGet, Wantedcodes
if Wantedcodes is Integer
{
	if(Wantedcodes > -1){
		IniWrite, %Wantedcodes%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
	}
}
GuiControlGet, Kekse
if Kekse is Integer
{
	if(Kekse > -1){
		IniWrite, %Kekse%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Kekse
	}
}
GuiControlGet, WaffenteileSB
if WaffenteileSB is Integer
{
	if(WaffenteileSB > -1){
		IniWrite, %WaffenteileSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
	}
}
GuiControlGet, DrogenSB
if DrogenSB is Integer
{
	if(DrogenSB > -1){
		IniWrite, %DrogenSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
	}
}
GuiControlGet, SpiceSB
if SpiceSB is Integer
{
	if(SpiceSB > -1){
		IniWrite, %SpiceSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
	}
}
GuiControlGet, WantedcodesSB
if WantedcodesSB is Integer
{
	if(WantedcodesSB > -1){
		IniWrite, %WantedcodesSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
	}
}
Reload
return

Abord:
gosub, main
return

Hotkey01:
if(IsChatOpen() || IsDialogOpen() || TextString01 == "" || TextString01 == "ERROR"){
	return
}
;~ SendChat(TextString01)
SendBind(TextString01)
return

Hotkey02:
if(IsChatOpen() || IsDialogOpen() || TextString02 == "" || TextString02 == "ERROR"){
	return
}
SendBind(TextString02)
return

Hotkey03:
if(IsChatOpen() || IsDialogOpen() || TextString03 == "" || TextString03 == "ERROR"){
	return
}
SendBind(TextString03)
return

Hotkey04:
if(IsChatOpen() || IsDialogOpen() || TextString04 == "" || TextString04 == "ERROR"){
	return
}
SendBind(TextString04)
return

Hotkey05:
if(IsChatOpen() || IsDialogOpen() || TextString05 == "" || TextString05 == "ERROR"){
	return
}
SendBind(TextString05)
return

Hotkey06:
if(IsChatOpen() || IsDialogOpen() || TextString06 == "" || TextString06 == "ERROR"){
	return
}
SendBind(TextString06)
return

Hotkey07:
if(IsChatOpen() || IsDialogOpen() || TextString07 == "" || TextString07 == "ERROR"){
	return
}
SendBind(TextString07)
return

Hotkey08:
if(IsChatOpen() || IsDialogOpen() || TextString08 == "" || TextString08 == "ERROR"){
	return
}
SendBind(TextString08)
return

Hotkey09:
if(IsChatOpen() || IsDialogOpen() || TextString09 == "" || TextString09 == "ERROR"){
	return
}
SendBind(TextString09)
return

Hotkey10:
if(IsChatOpen() || IsDialogOpen() || TextString10 == "" || TextString10 == "ERROR"){
	return
}
SendBind(TextString10)
return

Hotkey11:
if(IsChatOpen() || IsDialogOpen() || TextString11 == "" || TextString11 == "ERROR"){
	return
}
SendBind(TextString11)
return

Hotkey12:
if(IsChatOpen() || IsDialogOpen() || TextString12 == "" || TextString12 == "ERROR"){
	return
}
SendBind(TextString12)
return

Hotkey13:
if(IsChatOpen() || IsDialogOpen() || TextString13 == "" || TextString13 == "ERROR"){
	return
}
SendBind(TextString13)
return

Hotkey14:
if(IsChatOpen() || IsDialogOpen() || TextString14 == "" || TextString14 == "ERROR"){
	return
}
SendBind(TextString14)
return

Hotkey15:
if(IsChatOpen() || IsDialogOpen() || TextString15 == "" || TextString15 == "ERROR"){
	return
}
SendBind(TextString15)
return

Hotkey16:
if(IsChatOpen() || IsDialogOpen() || TextString16 == "" || TextString16 == "ERROR"){
	return
}
SendBind(TextString16)
return

Hotkey17:
if(IsChatOpen() || IsDialogOpen() || TextString17 == "" || TextString17 == "ERROR"){
	return
}
SendBind(TextString17)
return

Hotkey18:
if(IsChatOpen() || IsDialogOpen() || TextString18 == "" || TextString18 == "ERROR"){
	return
}
SendBind(TextString18)
return

Hotkey19:
if(IsChatOpen() || IsDialogOpen() || TextString19 == "" || TextString19 == "ERROR"){
	return
}
SendBind(TextString19)
return

Hotkey20:
if(IsChatOpen() || IsDialogOpen() || TextString20 == "" || TextString20 == "ERROR"){
	return
}
SendBind(TextString20)
return

ToggleKey:
suspend
if(A_IsSuspended){
	AddChatMessage("Du hast den Keybinder ausgeschaltet!")
	SetTimer, Overlay, Off
	OVloaded := false
	TextDestroy(HPoverlay)
	SetTimer, mainTimer, Off
	SetTimer, engineTimer, Off
	SetTimer, Counter, Off
}
if(!A_IsSuspended){
	AddChatMessage("Du hast den Keybinder eingeschaltet!")
	SetTimer, mainTimer, On
	SetTimer, Counter, On
	if(AEngine == 1){
		SetTimer, engineTimer, On
	}else{
		SetTimer, engineTimer, Off
	}
}
return

~F::
if(AEngine != 1){
	return
}
if(IsChatOpen() || IsDialogOpen()){
	return
}
If(IsPlayerinAnyVehicle() == 1 && IsPlayerDriver() == 1 && IsVehicleEngineEnabled() == 1){
	SendChat("/motor")
	if(IsVehicleLightEnabled() == 1){
		SendChat("/licht")
	}
}
return

~Enter::
if(AEngine != 1){
	return
}
if(IsChatOpen() || IsDialogOpen()){
	return
}
If(IsPlayerinAnyVehicle() == 1 && IsPlayerDriver() == 1 && IsVehicleEngineEnabled() == 1){
	SendChat("/motor")
	if(IsVehicleLightEnabled() == 1){
		SendChat("/licht")
	}
}
return

engineTimer:
if(getVehicleType() != 9){
	if(helm == true){
		SendChat("/helm")
		helm := false
	}
}
if(DoOnce == 0){
	OldState := isPlayerDriver()
	DoOnce := 1
}
NewState := isPlayerDriver()
if(OldState == 1 && NewState != 1){
	OldState := isPlayerDriver()
	OnPlayerExitVehicle()
}else if(OldState != 1 && NewState == 1){
	OldState := isPlayerDriver()
	OnPlayerEnterVehicle()
}
return

/*
:?:/kinv::
IniRead, Waffenteile, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
IniRead, Drogen, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
IniRead, Wantedcodes, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
IniRead, Spice, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
IniRead, Kekse, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Kekse
IniRead, WaffenteileSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
IniRead, DrogenSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
IniRead, WantedcodesSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
IniRead, SpiceSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
KMSG("-   -   -   -   -   -   -   -   -")
KMSG("Waffenteile: " Waffenteile " (SB: " WaffenteileSB ")")
KMSG("Drogen: " Drogen " (SB: " DrogenSB ")")
KMSG("Spice: " Spice " (SB: " SpiceSB ")")
KMSG("Wantedcodes: " Wantedcodes " (SB: " WantedcodesSB ")")
KMSG("Kekse: " Kekse)
KMSG("-   -   -   -   -   -   -   -   -")
return
*/
mainTimer:
getChatLine(0, firstLine)
if(InStr(firstLine, "Sie stehen an einer Zollstation, der Zollübergang kostet $500! Befehl: /Zoll")){
	if(AZoll == 1){
		if(fraktion == 2){
			SendChat("/zollamt")
			return
		}
		SendChat("/zoll")
	}
}
/*
if(InStr(firstLine, "Du hast") && InStr(firstLine, "Pakete abgeliefert und") && InStr(firstLine, "Waffenteile erhalten")){
	RegExMatch(firstLine, "Du hast (.*) Pakete abgeliefert und (.*) Waffenteile erhalten\.", waffendealer)
	IniRead, Waffenteile, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	waffenteile += waffendealer2
	KMSG("Du hast nun " Waffenteile " Waffenteile auf der Hand!")
	IniWrite, %Waffenteile%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	Sleep 250
}
if(InStr(firstLine, "Du hast") && InStr(firstLine, "Pakete abgeliefert und") && InStr(firstLine, "Drogen erhalten")){
	RegExMatch(firstLine, "Du hast (.*) Pakete abgeliefert und (.*) Drogen erhalten\.", drogendealer)
	IniRead, Drogen, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	Drogen += drogendealer2
	KMSG("Du hast nun " Drogen " Drogen auf der Hand!")
	IniWrite, %Drogen%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	Sleep 250
}

;---- SAFEBOX ---- - - - - UNFERTIG - - - 
;[INFO] {FFFFFF}Du hast {FF9900}50 Gramm Drogen {FFFFFF}aus deiner Safebox entnommen.
if(InStr(fristLine, "[INFO] Du hast") && InStr(firstLine, "Drogen aus deiner Safebox entnommen.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Gramm Drogen aus deiner Safebox entnommen\.", safeboxDrogenEntnehmen)
	IniRead, Drogen, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	Drogen += safeboxDrogenEntnehmen1
	IniWrite, %Drogen%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	IniRead, DrogenSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
	DrogenSB -= safeboxDrogenEntnehmen1
	IniWrite, %DrogenSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
	KMSG("Du hast nun " Drogen " Drogen auf der Hand und " DrogenSB " Drogen in der Safebox!")
}
if(InStr(firstLine, "[INFO] Du hast") && InStr(firstLine, "Drogen in deine Safebox eingelagert.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Gramm Drogen in deine Safebox eingelagert\.", safeboxDrogenEinlagern)
	IniRead, Drogen, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	Drogen -= safeboxDrogenEinlagern1
	IniWrite, %Drogen%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Drogen
	IniRead, DrogenSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
	DrogenSB += safeboxDrogenEinlagern1
	IniWrite, %DrogenSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, DrogenSB
	KMSG("Du hast nun " Drogen " Drogen auf der Hand und " DrogenSB " Drogen in der Safebox!")
}

if(InStr(fristLine, "[INFO] Du hast") && InStr(firstLine, "Spice aus deiner Safebox entnommen.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Gramm Spice aus deiner Safebox entnommen.", safeboxSpiceEntnehmen)
	IniRead, Spice, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
	Spice += safeboxSpiceEntnehmen1
	IniWrite, %Spice%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
	IniRead, SpiceSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
	SpiceSB -= safeboxSpiceEntnehmen1
	IniWrite, %SpiceSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
	KMSG("Du hast nun " Spice " Spice auf der Hand und " SpiceSB " Spice in der Safebox!")
}

if(InStr(firstLine, "[INFO] Du hast") && InStr(firstLine, "Spice in deine Safebox eingelagert.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Gramm Spice in deine Safebox eingelagert.", safeboxSpiceEinlagern)
	IniRead, Spice, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
	Spice -= safeboxSpiceEinlagern1
	IniWrite, %Spice%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Spice
	IniRead, SpiceSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
	SpiceSB += safeboxSpiceEinlagern1
	IniWrite, %SpiceSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, SpiceSB
	KMSG("Du hast nun " Spice " Spice auf der Hand und " SpiceSB " Spice in der Safebox!")
}

if(InStr(fristLine, "[INFO] Du hast") && InStr(firstLine, "Waffenteile aus deiner Safebox entnommen.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Waffenteile aus deiner Safebox entnommen\.", safeboxWaffenteileEntnehmen)
	IniRead, Waffenteile, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	Waffenteile += safeboxWaffenteileEntnehmen1
	IniWrite, %Waffenteile%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	IniRead, WaffenteileSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
	WaffenteileSB -= safeboxWaffenteileEntnehmen1
	IniWrite, %WaffenteileSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
	KMSG("Du hast nun " Waffenteile " Waffenteile auf der Hand und " WaffenteileSB " Waffenteile in der Safebox!")
}
if(InStr(firstLine, "[INFO] Du hast") && InStr(firstLine, "Waffenteile in deine Safebox eingelagert.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Waffenteile in deine Safebox eingelagert\.", safeboxWaffenteileEinlagern)
	IniRead, Waffenteile, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	Waffenteile -= safeboxWaffenteileEinlagern1
	IniWrite, %Waffenteile%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Waffenteile
	IniRead, WaffenteileSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
	WaffenteileSB += safeboxWaffenteileEinlagern1
	IniWrite, %WaffenteileSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WaffenteileSB
	KMSG("Du hast nun " Waffenteile " Waffenteile auf der Hand und " WaffenteileSB " Waffenteile in der Safebox!")
}

if(InStr(fristLine, "[INFO] Du hast") && InStr(firstLine, "Wantedcodes aus deiner Safebox entnommen.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Wantedcodes aus deiner Safebox entnommen\.", safeboxWantedcodesEntnehmen)
	IniRead, Wantedcodes, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
	Wantedcodes += safeboxWantedcodesEntnehmen1
	IniWrite, %Wantedcodes%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
	IniRead, WantedcodesSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
	WantedcodesSB -= safeboxWantedcodesEntnehmen1
	IniWrite, %WantedcodesSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
	KMSG("Du hast nun " Wantedcodes " Wantedcodes auf der Hand und " WantedcodesSB " Wantedcodes in der Safebox!")
}
if(InStr(firstLine, "[INFO] Du hast") && InStr(firstLine, "Wantedcodes in deine Safebox eingelagert.")){
	RegExMatch(firstLine, "\[INFO\] Du hast (.*) Wantedcodes in deine Safebox eingelagert\.", safeboxWantedcodesEinlagern)
	IniRead, Wantedcodes, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
	Wantedcodes -= safeboxWantedcodesEinlagern1
	IniWrite, %Wantedcodes%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, Wantedcodes
	IniRead, WantedcodesSB, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
	WantedcodesSB += safeboxWantedcodesEinlagern1
	IniWrite, %WantedcodesSB%, %A_AppData%\Keybinder\LyD_Keybinder\config\Stats.ini, Inventar, WantedcodesSB
	KMSG("Du hast nun " Wantedcodes " Wantedcodes auf der Hand und " WantedcodesSB " Wantedcodes in der Safebox!")
}


;[INFO] Du hast 1 Gramm Drogen in deine Safebox eingelagert.
*/
return

IKey:
if(IsPlayerInRange3D(-1857.5839,-1618.8446,21.8987, 4) || IsPlayerInRange3D(-258.7010,-2182.8076,29.0138, 4)){
	SendChat("/paketentladen")
}
if(IsPlayerInRange3D(2072.5764,-1834.1595,13.5545, 2) || IsPlayerInRange3D(1484.7965,-1805.0032,15.1008, 2)){
	SendChat("/automat")
}
if(isPlayerInRange3D(918.8826,-1463.3871,2754.3459, 2)){
	SendChat("/stadthalle")
}
if(isPlayerInRange3D(1339.3666,-1805.4818,13.5469, 4)){
	SendChat("/illegalejobs")
}
if(isPlayerInRange3D(2347.8750,-2302.4368,13.5469, 4)){
	if(Waffendealer == "1"){
		SendChat("/paketeinladen 5")
	}else if(Waffendealer == "2"){
		SendChat("/paketeinladen 10")
	}else if(Waffendealer == "3"){
		SendChat("/paketeinladen 15")
	}else if(Waffendealer == "4"){
		SendChat("/paketeinladen 20")
	}else if(Waffendealer == "5"){
		SendChat("/paketeinladen 25")
	}else{
		KMSG("Um diese Funktion nutzen zu können, muss du einen Waffendealerskill festlegen!")
	}
}
if(isPlayerInRange3D(-38.5145,56.3098,3.1172, 4)){
	if(Drogendealer == "1"){
		SendChat("/paketeinladen 5")
	}else if(Drogendealer == "2"){
		SendChat("/paketeinladen 10")
	}else if(Drogendealer == "3"){
		SendChat("/paketeinladen 15")
	}else if(Drogendealer == "4"){
		SendChat("/paketeinladen 20")
	}else if(Drogendealer == "5"){
		SendChat("/paketeinladen 25")
	}else{
		KMSG("Um diese Funktion nutzen zu können, muss du einen Drogendealerskill festlegen!")
	}
}
return

:?:/ov::
if(OVloaded == false){
	SetTimer, Overlay, On
	AddChatMessage("Du hast du Overlay eingeschaltet!")
}else{
	SetTimer, Overlay, Off
	TextDestroy(HPoverlay)
	AddChatMessage("Du hast das Overlay ausgeschaltet!")
	OVloaded := false
}
return

Overlay:
IniRead, 1kx, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
IniRead, 1ky, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
IniRead, OVcolor, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Color
IniRead, OvSize, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Size
if(OVloaded == false){
	HPoverlay := TextCreate("Arial", OvSize, 0, 0, 1kx, 1ky, 0xFFFFFFFF, "", true, true)
	OVloaded := true
}
TextSetPos(HPoverlay, 1kx, 1ky)
if(OVcolor == 1){
	TextSetColor(HPoverlay, 0x000000)
}else if(OVcolor == 2){
	TextSetColor(HPoverlay, 0xFFFFFFFF)
}else if(OVcolor == 3){
	TextSetColor(HPoverlay, 0x38761D)
}else if(OVcolor == 4){
	TextSetColor(HPoverlay, 0x0000FF)
}else if(OVcolor == 5){
	TextSetColor(HPoverlay, 0xFF0000)
}else if(OVcolor == 6){
	TextSetColor(HPoverlay, 0xFFFF00)
}
getZoneName(zone, 65)
getCityName(city, 65)
if(isPlayerDriver()){
	if(IsVehicleEngineEnabled()){
		EngineStatus := "An"
	}else{
		EngineStatus := "Aus"
	}
	if(IsVehicleLightEnabled()){
		LightStatus := "An"
	}else{
		LightStats := "Aus"
	}
	if(IsVehicleLocked()){
		LockStatus := "Ja"
	}else{
		LockStatus := "Nein"
	}
	TextSetString(HPoverlay, "Name: " sampuser " (ID: " GetPlayerId() ")`nHP: " GetPlayerHealth() " AP: " GetPlayerArmor() "`n" city " - " zone "`nMotor: " EngineStatus " Licht: " LightStatus "`nLock: " LockStatus)
}else{
	TextSetString(HPoverlay, "Name: " sampuser " (ID: " GetPlayerId() ")`nHP: " GetPlayerHealth() " AP: " GetPlayerArmor() "`n" city " - " zone)
}
return

:?:/moveov::
if(overlayMoveTog == true){
	overlayMoveTog := false
	KMSG("Du hast den Movemodus ausgeschaltet! Alle änderungen wurden gespeichert!")
}else if(overlayMoveTog == false){
	if(OVloaded == false){
		KMSG("Du kannst das Overlay nur verschieben, wenn du es aktiviert hast!")
		return
	}
	overlayMoveTog := true
	KMSG("Du hast den Move-Modus angeschaltet! Zum Beenden: '/moveov'")
}
return

!~Left::
if(overlayMoveTog != true || isChatOpen() || isDialogOpen()){
	return
}
IniRead, 1kx, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
1kx--
IniWrite, %1kx%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
return

!~Right::
if(overlayMoveTog != true || isChatOpen() || isDialogOpen()){
	return
}
IniRead, 1kx, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
1kx++
IniWrite, %1kx%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, X
return

!~Down::
if(overlayMoveTog != true || isChatOpen() || isDialogOpen()){
	return
}
IniRead, 1ky, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
1ky++
IniWrite, %1ky%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
return

!~Up::
if(overlayMoveTog != true || isChatOpen() || isDialogOpen()){
	return
}
IniRead, 1ky, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
1ky--
IniWrite, %1ky%, %A_AppData%\Keybinder\LyD_Keybinder\config\Overlay.ini, Overlay Settings, Y
return

Counter:
GetChatLine(1, SecLine)
if(InStr(SecLine,"Du hast ein Verbrechen begangen! (Mord an einem Gangmitglied) Reporter: Polizeizentrale") || InStr(SecLine,"Du hast ein Verbrechen begangen! (Beamten/Zivilisten Mord) Reporter: Polizeizentrale") || InStr(SecLine, "->GANGFIGHTKILL<- " sampuser " Gangfightkill an")){
	IniRead, myKills, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
	myKills += 1
	IniWrite, %myKills%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
	if(!killMsgPrivate && !killMsgPublic && !killMsgFraktion){
		return
	}
	Sleep 250
	KMSG("   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   ")
	Sleep 250
	if(killMsgPrivate == 1){
		KMSG(killMSG " | Kill Nr. " myKills)
	}
	if(killMsgPublic == 1){
		SendBind("/ic " killMSG)
	}
	if(killMsgFraktion == 1){
		SendBind("/fc " killMSG)
	}
	Sleep 250
	KMSG("   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   ")
}
if(GetPlayerHealth() == 0 && DeathTime == 15000){
	DeathTime -= 1
	IniRead, myDeaths, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
	myDeaths += 1
	IniWrite, %myDeaths%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
	if(!killMsgPrivate && !killMsgPublic && !killMsgFraktion){
		return
	}
	Sleep 250
	KMSG("   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   ")
	Sleep 250
	if(deathMsgPrivate == 1){
		KMSG(deathMSG " | Death Nr. " myDeath)
	}
	if(deathMsgPublic == 1){
		SendBind("/ic " deathMSG)
	}
	if(deathMsgFraktion == 1){
		SendBind("/fc " deathMSG)
	}
	SetTimer, DeathTimeout, 1000
	Sleep 250
	KMSG("   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   ")
}
return

DeathTimeout:
if(DeathTime == 0){
	SetTimer, DeathTimeout, Off
	DeathTime := 15000
}
DeathTime -= 1
return

:?:/setkills::
IniRead, myKills, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
Sleep 250
newKills := PlayerInput("Anzahl Kills: ")
if newKills is not integer
	return
if(newKills < 0){
	return
}
KMSG("Du hast deine Kills von " myKills " auf " newKills " geändert!")
IniWrite, %newKills%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, KillCounter, Anzahl
return

:?:/setdeaths::
IniRead, myDeaths, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
Sleep 250
newDeaths := PlayerInput("Anzahl Tode: ")
if newDeaths is not Integer
	return
if(newDeaths < 0){
	return
}
KMSG("Du hast deine Tode von " myDeaths " auf " newDeaths " geändert!")
IniWrite, %newDeaths%, %A_AppData%\Keybinder\LyD_Keybinder\config\Settings.ini, DeathCounter, Anzahl
return

DKey:
if(isChatOpen() || isDialogOpen()){
	return
}
if(Detektiv < 5){
	KMSG("Du darf den Detektiv-Bot erst ab Skill 5 verwenden!")
	return
}
if(myDetektivID != ""){
	SetTimer, Detektiv, Off
	myDetektivID := ""
	KMSG("Du hast den Detektiv-Bot ausgeschaltet!")
	return
}
myDetektivID := PlayerInput("ID: ")
if(myDetektivID != ""){
	gosub Detektiv
	SetTimer, Detektiv, %myDeteTime%
	KMSG("Du hast den Detektiv-Bot gestartet!")
} 
return

SKey:
if(IsChatOpen() || IsDialogOpen()){
	return
}
ap := getPlayerArmor()
/*
if(spice <= 0){
	KMSG("Du hast zu wenig Spice um dich zu heilen!")
	return
}
*/
if(ap == "100"){
	KMSG("Du kannst gerade kein Spice nehmen, da du bereits 100 AP hast!")
	return
}
if(nextSpice == false){
	KMSG("Du musst noch warten, bevor du Spice nehmen kannst!")
	return
}
SendChat("/nimmspice")
spice -= 3
nextSpice := false
SetTimer, SpiceTimer, 10000
return

SpiceTimer:
nextSpice := true
KMSG("Du kannst nun wieder Spice nehmen!")
SetTimer, SpiceTimer, Off
return

KKey:
if(IsChatOpen() || IsDialogOpen()){
	return
}
/*
if(Kekse <= 0){
	KMSG("Du hast zu wenig Kekse um dich zu heilen!")
	return
}
*/
hp:=GetPlayerHealth()
if(hp > 89){
	KMSG("Du kannst keine Kekse essen, da du über 89 HP hast!")
}
if(hp = 89 || hp = 88){
	sendChat("/isskeks")
	Kekse -= 1
	sleep 100
}
if(hp = 87 || hp = 86){
	sendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	Kekse -= 2
	sleep 100
}
if(hp = 85 || hp = 84){
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendCHat("/isskeks")
	Kekse -= 3
	sleep 100
}
if(hp = 83 || hp = 82){
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	Kekse -= 4
	sleep 100
}
if(hp = 81 || hp = 80){
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	Kekse -= 5
	sleep 100
}
if(hp = 79 || hp = 78){
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	Kekse -= 6
	sleep 100
}
if(hp < 78){
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	sleep 230
	SendChat("/isskeks")
	Kekse -= 6
	sleep 100
	Sleep 5400
	KMSG("Du kannst wieder Kekse essen!")
}
return

Detektiv:
SendChat("/dfinden " myDetektivID)
return

:?:/laufen::
if(isLaufen == true){
	isLaufen := false
	KMSG("Du hast dein Laufscript ausgeschaltet!")
}else if(isLaufen == false){
	isLaufen := true
	KMSG("Du hast dein Laufscript eingeschaltet!")
}else{
	isLaufen := true
	KMSG("Du hast dein Laufscript eingeschaltet!")
}
return

TicketMin:
ticketTimeMin++
return

TicketSek:
if(ticketTimeSek > 60){
    ticketTimeSek := 0
}
ticketTimeSek++
return

Tickets:
getChatLine(0, TicketLine)
if(InStr(TicketLine, "> Ticket < - ") && InStr(TicketLine, "(ID: ") && InStr(TicketLine, "Nachricht: ")){
	RegExMatch(Ticketline, "> Ticket < - (.*) \(ID: (.*)\) Nachricht: (.*)", ticketCreateOut)
}
if(InStr(TicketLine, "> Ticket < - ") && InStr(TicketLine, "hat das Ticket von") && InStr(TicketLine, "geschlossen")){
	RegExMatch(Ticketline, "> Ticket < - (.*) hat das Ticket von (.*) geschlossen", ticketCloseOut)
	if(ticketCreateOut1 == ticketCloseOut2){
		ticketCreateOut1 := ""
	}
}
if(InStr(TicketLine, "> Ticket < - ") && InStr(TicketLine, "hat das Ticket von") && InStr(TicketLine, "angenommen")){
	RegExMatch(Ticketline, "> Ticket < - (.*) hat das Ticket von (.*) angenommen", ticketOpen)
	if(ticketCreateOut1 == ticketOpen2){
		ticketCreateOut1 := ""
	}
}
return

!i::
if(IsChatOpen() || IsDialogOpen() || Ticket != 1){
	return
}
if(ticketCreateOut1 == ""){
	return
}
SendChat("/openticket " ticketCreateOut1)
sleep, 100
GetChatLine(0, tickets)
if(InStr(tickets, "Der Spieler hat kein Ticket geschrieben.")){
	regvar2:= -1
	return
}
SendChat("/adienst")
FormatTime, time, T12, Time
FormatTime, date,, LongDate
if(Adminrang == "2"){
	AdminrangName := "Supporter"
}else if(Adminrang == "3"){
	AdminrangName := "Moderator"
}else if(Adminrang == "4"){
	AdminrangName := "Administrator"
}else if(Adminrang == "5"){
	AdminrangName := "Entwickler"
}else if(Adminrang == "6"){
	AdminrangName := "Server Manager"
}else if(Adminrang == "6"){
	AdminrangName := "Serverleitung"
}else{
	AdminrangName := "Supporter"
}
SendChat("==========================================")
SendChat("Support von: " sampuser " || Adminrank: " AdminrangName)
SendChat("Supportdatum: " date " || Supportuhrzeit: " time "")
SendChat("==========================================")
SendChat("Deine Nachricht: " ticketCreateOut3 "")
SendChat("==========================================")
SendChat("Guten Tag, Wie kann ich Dir helfen?")
SetTimer, TicketMin, 60000
SetTimer, TicketSek, 1000

return

!o::
if(IsChatOpen() || IsDialogOpen() || Ticket != 1){
	return
}
if(ticketTimeMin == 0 && ticketTimeSek == 0){
	KMSG("Bist du irgendwie hart retarded?")
	return
}
SendChat("Hast Du noch weitere Fragen oder Probleme, bei denen ich behilflich sein kann?")
return

!p::
if(IsChatOpen() || IsDialogOpen() || Ticket != 1){
	return
}
if(ticketTimeMin == 0 && ticketTimeSek == 0){
	KMSG("Bist du irgendwie hart retarded?")
	return
}
SetTimer, TicketMin, Off
SetTimer, TicketSek, Off
SendChat("Ich hoffe, dass ich Dir helfen konnte und wünsche Dir noch einen schönen Tag und viel Spaß auf LyD-Roleplay!")
SendChat("Bei weiteren Fragen oder Problemen stell einfach ein Support-Ticket mit /sup [Text]")
if(ticketTimeMin == 1 && ticketTimeSek == 1){
	SendChat("Dein Support dauerte " ticketTimeMin " Minute und " ticketTimeSek " Sekunde.")
}else if(ticketTimeMin == 1){
	SendChat("Dein Support dauerte " ticketTimeMin " Minute und " ticketTimeSek " Sekunden.")
}else if(ticketTimeSek == 1){
	SendChat("Dein Support dauerte " ticketTimeMin " Minuten und " ticketTimeSek " Sekunde.")
}else{
	SendChat("Dein Support dauerte " ticketTimeMin " Minuten und " ticketTimeSek " Sekunden.")
}
SendChat("/closeticket " ticketCreateOut1)
ticketTimeMin := 0
ticketTimeSek := 0
return

$~Space::
if(IsChatOpen() || isDialogOpen()){
	return
}
if(isLaufen && runkey == 1){
Loop {
If !GetKeyState("Space","P")
break
Send {Space down}
Sleep 1
Send {Space up}
Sleep 1
Send {Space down}
Sleep 5
Send {Space up}
}
}
return

$~Shift::
if(IsChatOpen() || isDialogOpen()){
	return
}
if(isLaufen && runkey == 2){
Loop {
If !GetKeyState("Shift","P")
break
Send {Shift down}
Sleep 1
Send {Shift up}
Sleep 1
Send {Shift down}
Sleep 5
Send {Shift up}
}
}
return

$~Alt::
if(IsChatOpen() || isDialogOpen()){
	return
}
if(isLaufen && runkey == 3){
Loop {
If !GetKeyState("Alt","P")
break
Send {Alt down}
Sleep 1
Send {Alt up}
Sleep 1
Send {Alt down}
Sleep 5
Send {Alt up}
}
}
return

:?:/moviemode::
if(movie == true){
	movie := false
	SetTimer, Video, Off
	KMSG("Video-Modus ausgeschaltet!")
}else{
	movie := true
	SetTimer, Video, 1000
	KMSG("Video-Modus eingeschaltet!")
}
return

Video:
ShowGameText(" " , 2000, 0)
return