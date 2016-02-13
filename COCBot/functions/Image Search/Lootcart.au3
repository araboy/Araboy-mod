; #FUNCTION# ====================================================================================================================
; Name ..........: Lootcart.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: Araboy (2016)
; Modified ......: Araboy 2016 and Skatman 2016
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkLootcart()
	If $iChkCollect <> 1 Then Return False
	Local $LootcartX, $lootcartY
	Local $pixelsfound = 0
	If Not FileExists($Lootcart) Then
		SetLog("Lootcart image not found: " & $Lootcart, $COLOR_GREEN)
		Return False
	EndIf
	Local $LootcartLoc = 0
	_CaptureRegion()
	$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	If _Sleep($iDelayCheckLootcart1) Then Return
	Local $Tolerance = 0.87
	Local $DefaultCocSearchArea = "15|25|825|625"
	Local $DefaultCocDiamond = "430,25|840,335|430,645|15,333"
		If $LootcartLoc = 0 Then
			$LootcartX = 0
			$LootcartY = 0
			$res = DllCall($LibDir & "\ImgLocV6.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", $Lootcart , "float", $Tolerance, "str" ,$DefaultCocSearchArea, "str",$DefaultCocDiamond )
			Local $iLootcartLoc = StringSplit($res[0],"|")
			If $iLootcartLoc[1] > 0 then
				$LootcartX = $iLootcartLoc[2]
				$LootcartY = $iLootcartLoc[3]
				SetLog("Found Lootcart ,  Collecting...", $COLOR_GREEN)
				If $DebugSetLog = 1 Then SetLog("Lootcart found (" & $LootcartX & "," & $LootcartY & ") Tolerance:" & $Lootcart, $COLOR_PURPLE)
				If IsMainPage() Then Click($LootcartX, $LootcartY,1,0,"#0120")
				If _Sleep($iDelayCheckLootcart2) Then Return

				;( force check button loot cart)
				If _ColorCheck(_GetPixelColor($lootcartbtn1[0], $lootcartbtn1[1], True), Hex($lootcartbtn1[2], 6), $lootcartbtn1[3]) Then
					If $DebugSetLog = 1 Then Setlog ("pixel 1 lootcart find")
					$pixelsfound += 1
				EndIf
				If _ColorCheck(_GetPixelColor($lootcartbtn2[0], $lootcartbtn2[1], True), Hex($lootcartbtn2[2], 6), $lootcartbtn2[3]) Then
					If $DebugSetLog = 1 Then Setlog ("pixel 2 lootcart find")
					 $pixelsfound += 1
				EndIf
				If _ColorCheck(_GetPixelColor($lootcartbtn3[0], $lootcartbtn3[1], True), Hex($lootcartbtn3[2], 6), $lootcartbtn3[3]) Then
					If $DebugSetLog = 1 Then Setlog ("pixel 3 lootcart find")
					 $pixelsfound += 1
				EndIf
				If $pixelsfound = 3 Then
					Click(430, 650,1,0,"#0120")
					SetLog("Lootcart collected.", $COLOR_GREEN)
				EndIf

				ClickP($aAway,1,0,"#0121") ; click away
				If _Sleep($iDelayCheckLootcart1) Then Return
				Return True
			EndIf
		EndIf
	If $DebugSetLog = 1 Then SetLog("Cannot find Lootcart", $COLOR_PURPLE)
	If _Sleep($iDelayCheckLootcart1) Then Return
	checkMainScreen(False) ; check for screen errors while function was running

EndFunc   ;==>Checklootcart
