#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <GUISlider.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <Date.au3>

; Let's be strict here
Opt("MustDeclareVars", 1)

; Controls the size of the pie and also the depth
Global Const $PIE_DIAMETER = 400
Global Const $PIE_MARGIN = $PIE_DIAMETER * 0.025
Global Const $PIE_DEPTH = $PIE_DIAMETER * 0.2
Global Const $PIE_AREA = $PIE_DIAMETER + 2 * $PIE_MARGIN

; Random data for values and colours
Global Const $NUM_VALUES = 8
Global $aChartValue[$NUM_VALUES]
Global $aChartColour[$NUM_VALUES]
For $i = 0 To $NUM_VALUES - 1
    $aChartValue[$i] = Random(5, 25, 1)
    $aChartColour[$i] = (Random(0, 255, 1) * 0x10000) + (Random(0, 255, 1) * 0x100) + Random(0, 255, 1)
Next

; The value of PI
Global Const $PI = ATan(1) * 4

; Start GDI+
_GDIPlus_Startup()

; Create the brushes and pens
Global $ahBrush[$NUM_VALUES][2], $ahPen[$NUM_VALUES]
For $i = 0 To $NUM_VALUES - 1
    $ahBrush[$i][0] = _GDIPlus_BrushCreateSolid(BitOR(0xff000000, $aChartColour[$i]))
    $ahBrush[$i][1] = _GDIPlus_BrushCreateSolid(BitOR(0xff000000, _GetDarkerColour($aChartColour[$i])))
    $ahPen[$i] = _GDIPlus_PenCreate(BitOR(0xff000000, _GetDarkerColour(_GetDarkerColour($aChartColour[$i]))))
Next

; Create the GUI with sliders to control the aspect, rotation, style and hole size (for donuts)
Global $hWnd = GUICreate("Pie Chart", $PIE_AREA, $PIE_AREA + 100, Default, Default)
Global $hSlideAspect = _GUICtrlSlider_Create($hWnd, $PIE_MARGIN, $PIE_AREA + 10, $PIE_DIAMETER, 20)
_GUICtrlSlider_SetRange($hSlideAspect, 10, 100)
_GUICtrlSlider_SetPos($hSlideAspect, 50)
Global $hSlideRotation = _GUICtrlSlider_Create($hWnd, $PIE_MARGIN, $PIE_AREA + 40, $PIE_DIAMETER, 20)
_GUICtrlSlider_SetRange($hSlideRotation, 0, 360)
Global $cStyle = GUICtrlCreateCheckbox("Donut", $PIE_MARGIN, $PIE_AREA + 70, $PIE_DIAMETER / 2 - $PIE_MARGIN, 20)
Global $hStyle = GUICtrlGetHandle($cStyle)
Global $hHoleSize = _GUICtrlSlider_Create($hWnd, $PIE_MARGIN + $PIE_DIAMETER / 2, $PIE_AREA + 70, $PIE_DIAMETER / 2, 20)
_GUICtrlSlider_SetRange($hHoleSize, 2, $PIE_DIAMETER - 4 * $PIE_MARGIN)
_GUICtrlSlider_SetPos($hHoleSize, $PIE_DIAMETER / 2)
GUISetState()

; Set up GDI+
Global $hDC = _WinAPI_GetDC($hWnd)
Global $hGraphics = _GDIPlus_GraphicsCreateFromHDC($hDC)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($PIE_AREA, $PIE_AREA, $hGraphics)
Global $hBuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBuffer, 2)

; Draw the initial pie chart
_DrawPie($aChartValue, _GUICtrlSlider_GetPos($hSlideAspect) / 100, _
        _GUICtrlSlider_GetPos($hSlideRotation), _
        (GUICtrlRead($cStyle) = $GUI_CHECKED), _
        _GUICtrlSlider_GetPos($hHoleSize))

; The sliders will send WM_NOTIFY messages
GUIRegisterMsg($WM_NOTIFY, "_OnNotify")

; Wait until the user quits
While GUIGetMsg() <> $GUI_EVENT_CLOSE
    Sleep(10)
WEnd

; Release the resources
For $i = 0 To UBound($aChartColour) - 1
    _GDIPlus_PenDispose($ahPen[$i])
    _GDIPlus_BrushDispose($ahBrush[$i][0])
    _GDIPlus_BrushDispose($ahBrush[$i][1])
Next
_GDIPlus_GraphicsDispose($hBuffer)
_GDIPlus_BitmapDispose($hBitmap)
_GDIPlus_GraphicsDispose($hGraphics)
_WinAPI_ReleaseDC($hWnd, $hDC)

; Shut down GDI+
_GDIPlus_Shutdown()

; Done
Exit

; Get a darker version of a colour by extracting the RGB components
Func _GetDarkerColour($Colour)
    Local $Red, $Green, $Blue
    $Red = (BitAND($Colour, 0xff0000) / 0x10000) - 40
    $Green = (BitAND($Colour, 0x00ff00) / 0x100) - 40
    $Blue = (BitAND($Colour, 0x0000ff)) - 40
    If $Red < 0 Then $Red = 0
    If $Green < 0 Then $Green = 0
    If $Blue < 0 Then $Blue = 0
    Return ($Red * 0x10000) + ($Green * 0x100) + $Blue
EndFunc ;==>_GetDarkerColour

; Draw the pie chart
Func _DrawPie($Percentage, $Aspect, $rotation, $style = 0, $holesize = 100)
    If $style <> 0 Then $Aspect = 1
    Local $nCount, $nTotal = 0, $angleStart, $angleSweep, $X, $Y
    Local $pieLeft = $PIE_MARGIN, $pieTop = $PIE_AREA / 2 - ($PIE_DIAMETER / 2) * $Aspect
    Local $pieWidth = $PIE_DIAMETER, $pieHeight = $PIE_DIAMETER * $Aspect, $hPath

; Total up the values
    For $nCount = 0 To UBound($Percentage) - 1
        $nTotal += $Percentage[$nCount]
    Next

; Set the fractional values
    For $nCount = 0 To UBound($Percentage) - 1
        $Percentage[$nCount] /= $nTotal
    Next

; Make sure we don't over-rotate
    $rotation = Mod($rotation, 360)

; Clear the graphics buffer
    _GDIPlus_GraphicsClear($hBuffer, 0xffc0c0c0)

; Set the initial angles based on the fractional values
    Local $Angles[UBound($Percentage) + 1]
    For $nCount = 0 To UBound($Percentage)
        If $nCount = 0 Then
            $Angles[$nCount] = $rotation
        Else
            $Angles[$nCount] = $Angles[$nCount - 1] + ($Percentage[$nCount - 1] * 360)
        EndIf
    Next

    Switch $style
        Case 0
    ; Adjust the angles based on the aspect
            For $nCount = 0 To UBound($Percentage)
                $X = $PIE_DIAMETER * Cos($Angles[$nCount] * $PI / 180)
                $Y = $PIE_DIAMETER * Sin($Angles[$nCount] * $PI / 180)
                $Y -= ($PIE_DIAMETER - $pieHeight) * Sin($Angles[$nCount] * $PI / 180)
                If $X = 0 Then
                    $Angles[$nCount] = 90 + ($Y < 0) * 180
                Else
                    $Angles[$nCount] = ATan($Y / $X) * 180 / $PI
                EndIf
                If $X < 0 Then $Angles[$nCount] += 180
                If $X >= 0 And $Y < 0 Then $Angles[$nCount] += 360
                $X = $PIE_DIAMETER * Cos($Angles[$nCount] * $PI / 180)
                $Y = $pieHeight * Sin($Angles[$nCount] * $PI / 180)
            Next

    ; Decide which pieces to draw first and last
            Local $nStart = -1, $nEnd = -1
            For $nCount = 0 To UBound($Percentage) - 1
                $angleStart = Mod($Angles[$nCount], 360)
                $angleSweep = Mod($Angles[$nCount + 1] - $Angles[$nCount] + 360, 360)
                If $angleStart <= 270 And ($angleStart + $angleSweep) >= 270 Then
                    $nStart = $nCount
                EndIf
                If ($angleStart <= 90 And ($angleStart + $angleSweep) >= 90) _
                        Or ($angleStart <= 450 And ($angleStart + $angleSweep) >= 450) Then
                    $nEnd = $nCount
                EndIf
                If $nEnd >= 0 And $nStart >= 0 Then ExitLoop
            Next

    ; Draw the first piece
            _DrawPiePiece($hBuffer, $pieLeft, $pieTop, $pieWidth, $pieHeight, $PIE_DEPTH * (1 - $Aspect), $nStart, $Angles)

    ; Draw pieces "to the right"
            $nCount = Mod($nStart + 1, UBound($Percentage))
            While $nCount <> $nEnd
                _DrawPiePiece($hBuffer, $pieLeft, $pieTop, $pieWidth, $pieHeight, $PIE_DEPTH * (1 - $Aspect), $nCount, $Angles)
                $nCount = Mod($nCount + 1, UBound($Percentage))
            WEnd

    ; Draw pieces "to the left"
            $nCount = Mod($nStart + UBound($Percentage) - 1, UBound($Percentage))
            While $nCount <> $nEnd
                _DrawPiePiece($hBuffer, $pieLeft, $pieTop, $pieWidth, $pieHeight, $PIE_DEPTH * (1 - $Aspect), $nCount, $Angles)
                $nCount = Mod($nCount + UBound($Percentage) - 1, UBound($Percentage))
            WEnd

    ; Draw the last piece
            _DrawPiePiece($hBuffer, $pieLeft, $pieTop, $pieWidth, $pieHeight, $PIE_DEPTH * (1 - $Aspect), $nEnd, $Angles)
        Case 1
    ; Draw the donut pieces
            For $nCount = 0 To UBound($Percentage) - 1
                $angleStart = Mod($Angles[$nCount], 360)
                $angleSweep = Mod($Angles[$nCount + 1] - $Angles[$nCount] + 360, 360)

        ; Draw the outer arc in a darker colour
                $hPath = _GDIPlus_GraphicsPathCreate()
                _GDIPlus_GraphicsPathAddArc($hPath, $pieLeft, $pieTop, $pieWidth, $pieHeight, $angleStart, $angleSweep)
                _GDIPlus_GraphicsPathAddArc($hPath, $pieLeft + $PIE_MARGIN, $pieTop + $PIE_MARGIN, $pieWidth - $PIE_MARGIN * 2, _
                        $pieHeight - $PIE_MARGIN * 2, $angleStart + $angleSweep, -$angleSweep)
                _GDIPlus_GraphicsPathCloseFigure($hPath)
                _GDIPlus_GraphicsFillPath($hBuffer, $ahBrush[$nCount][1], $hPath)
                _GDIPlus_GraphicsDrawPath($hBuffer, $ahPen[$nCount], $hPath)
                _GDIPlus_GraphicsPathDispose($hPath)

        ; Draw the inner piece in a lighter colour - leave room for the hole
                $hPath = _GDIPlus_GraphicsPathCreate()
                _GDIPlus_GraphicsPathAddArc($hPath, $pieLeft + $PIE_MARGIN, $pieTop + $PIE_MARGIN, $pieWidth - $PIE_MARGIN * 2, _
                        $pieHeight - $PIE_MARGIN * 2, $angleStart, $angleSweep)
                _GDIPlus_GraphicsPathAddArc($hPath, $pieLeft + ($PIE_DIAMETER - $holesize) / 2, $pieTop + ($PIE_DIAMETER - $holesize) / 2, _
                        $holesize, $holesize, $angleStart + $angleSweep, -$angleSweep)
                _GDIPlus_GraphicsPathCloseFigure($hPath)
                _GDIPlus_GraphicsFillPath($hBuffer, $ahBrush[$nCount][0], $hPath)
                _GDIPlus_GraphicsDrawPath($hBuffer, $ahPen[$nCount], $hPath)
                _GDIPlus_GraphicsPathDispose($hPath)
            Next
    EndSwitch

; Now draw the bitmap on to the device context of the window
    _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
EndFunc ;==>_DrawPie

Func _OnNotify($hWnd, $iMsg, $wParam, $lParam)
    Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    Switch $hWndFrom
        Case $hSlideAspect, $hSlideRotation, $hStyle, $hHoleSize
    ; Update the pie chart
            _DrawPie($aChartValue, _GUICtrlSlider_GetPos($hSlideAspect) / 100, _
                    _GUICtrlSlider_GetPos($hSlideRotation), _
                    (GUICtrlRead($cStyle) = $GUI_CHECKED), _
                    _GUICtrlSlider_GetPos($hHoleSize))
    EndSwitch
EndFunc ;==>_OnNotify

Func _DrawPiePiece($hGraphics, $iX, $iY, $iWidth, $iHeight, $iDepth, $nCount, $Angles)
    Local $hPath, $cX = $iX + ($iWidth / 2), $cY = $iY + ($iHeight / 2), $fDrawn = False
    Local $iStart = Mod($Angles[$nCount], 360), $iSweep = Mod($Angles[$nCount + 1] - $Angles[$nCount] + 360, 360)

; Draw side
    ConsoleWrite(_Now() & @CRLF)
    $hPath = _GDIPlus_GraphicsPathCreate()
    If $iStart < 180 And ($iStart + $iSweep > 180) Then
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iWidth, $iHeight, $iStart, 180 - $iStart)
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iDepth, $iWidth, $iHeight, 180, $iStart - 180)
        _GDIPlus_GraphicsPathCloseFigure($hPath)
        _GDIPlus_GraphicsFillPath($hGraphics, $ahBrush[$nCount][1], $hPath)
        _GDIPlus_GraphicsDrawPath($hGraphics, $ahPen[$nCount], $hPath)
        $fDrawn = True
    EndIf
    If $iStart + $iSweep > 360 Then
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iWidth, $iHeight, 0, $iStart + $iSweep - 360)
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iDepth, $iWidth, $iHeight, $iStart + $iSweep - 360, 360 - $iStart - $iSweep)
        _GDIPlus_GraphicsPathCloseFigure($hPath)
        _GDIPlus_GraphicsFillPath($hGraphics, $ahBrush[$nCount][1], $hPath)
        _GDIPlus_GraphicsDrawPath($hGraphics, $ahPen[$nCount], $hPath)
        $fDrawn = True
    EndIf
    If $iStart < 180 And (Not $fDrawn) Then
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iWidth, $iHeight, $iStart, $iSweep)
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iDepth, $iWidth, $iHeight, $iStart + $iSweep, -$iSweep)
        _GDIPlus_GraphicsPathCloseFigure($hPath)
        _GDIPlus_GraphicsFillPath($hGraphics, $ahBrush[$nCount][1], $hPath)
        _GDIPlus_GraphicsDrawPath($hGraphics, $ahPen[$nCount], $hPath)
    EndIf
    _GDIPlus_GraphicsPathDispose($hPath)

; Draw top
    _GDIPlus_GraphicsFillPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $iStart, $iSweep, $ahBrush[$nCount][0])
    _GDIPlus_GraphicsDrawPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $iStart, $iSweep, $ahPen[$nCount])

EndFunc ;==>_DrawPiePiece

Func _GDIPlus_GraphicsPathCreate($iFillMode = 0)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreatePath", "int", $iFillMode, "int*", 0);
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, $aResult[2])
EndFunc ;==>_GDIPlus_GraphicsPathCreate

Func _GDIPlus_GraphicsPathAddLine($hGraphicsPath, $iX1, $iY1, $iX2, $iY2)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipAddPathLine", "hwnd", $hGraphicsPath, "float", $iX1, "float", $iY1, _
            "float", $iX2, "float", $iY2)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathAddLine

Func _GDIPlus_GraphicsPathAddArc($hGraphicsPath, $iX, $iY, $iWidth, $iHeight, $iStartAngle, $iSweepAngle)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipAddPathArc", "hwnd", $hGraphicsPath, "float", $iX, "float", $iY, _
            "float", $iWidth, "float", $iHeight, "float", $iStartAngle, "float", $iSweepAngle)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathAddArc

Func _GDIPlus_GraphicsPathAddPie($hGraphicsPath, $iX, $iY, $iWidth, $iHeight, $iStartAngle, $iSweepAngle)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipAddPathPie", "hwnd", $hGraphicsPath, "float", $iX, "float", $iY, _
            "float", $iWidth, "float", $iHeight, "float", $iStartAngle, "float", $iSweepAngle)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathAddPie

Func _GDIPlus_GraphicsPathCloseFigure($hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipClosePathFigure", "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathCloseFigure

Func _GDIPlus_GraphicsPathDispose($hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeletePath", "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathDispose

Func _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPath", "hwnd", $hGraphics, "hwnd", $hPen, "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsDrawPath

Func _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPath", "hwnd", $hGraphics, "hwnd", $hBrush, "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsFillPath