@if defined talk (echo on) else (echo off)
setlocal EnableDelayedExpansion
echo.pi.bat - By Don Cross - http://cosinekitty.com
set /a NumQuads = 30
set /a MaxQuadIndex = NumQuads - 1

echo.
echo.%time% - started
echo.

call :PiEngine 48 18 32 57 -20 239
call :PiEngine 16 5 -4 239
goto :EOF

:PiEngine
call :SetToInteger Pi 0
set Formula=
:PiTermLoop
if "%1" == "" (
call :Print pi
echo.
echo.!time! - finished !Formula!
echo.
goto :EOF
)
call :ArctanRecip PiTerm %2
set /a PiEngineFactor=%1
if !PiEngineFactor! lss 0 (
set /a PiEngineFactor *= -1
set Formula=!Formula!
call :MultiplyByInteger PiTerm !PiEngineFactor!
call :Subtract Pi PiTerm
set Operator=-
) else (
call :MultiplyByInteger PiTerm %1
call :Add Pi PiTerm
set Operator=+
)
if defined Formula (
set Formula=!Formula! !Operator! !PiEngineFactor!*arctan^(1/%2^)
) else (
set Formula=pi = %1*arctan^(1/%2^)
)
shift
shift
goto PiTermLoop

:SetToInteger
for /L %%i in (0, 1, !MaxQuadIndex!) do (
set /a %1_%%i = 0
)
set /a %1_!MaxQuadIndex! = %2
goto :EOF

:Print
set PrintBuffer=x
REM Omit a couple of least significant quads, because they will have roundoff errors.
if defined PiDebug (
set /a PrintMinQuadIndex=0
) else (
set /a PrintMinQuadIndex=2
)
set /a PrintMaxQuadIndex = MaxQuadIndex - 1
for /L %%i in (!PrintMinQuadIndex!, 1, !PrintMaxQuadIndex!) do (
set PrintDigit=!%1_%%i!
if !PrintDigit! lss 1000 (
if !PrintDigit! lss 100 (
if !PrintDigit! lss 10 (
set PrintDigit=000!PrintDigit!
) else (
set PrintDigit=00!PrintDigit!
)
) else (
set PrintDigit=0!PrintDigit!
)
)
set PrintBuffer=!PrintDigit!!PrintBuffer!
)
set PrintBuffer=!%1_%MaxQuadIndex%!.!PrintBuffer:x=!
echo.%1 = !PrintBuffer!
goto :EOF

:DivideByInteger
if defined PiDebug echo.DivideByInteger %1 %2
set /a DBI_Carry = 0
for /L %%i in (!MaxQuadIndex!, -1, 0) do (
set /a DBI_Digit = DBI_Carry*10000 + %1_%%i
set /a DBI_Carry = DBI_Digit %% %2
set /a %1_%%i = DBI_Digit / %2
)
goto :EOF

:MultiplyByInteger
if defined PiDebug echo.MultiplyByInteger %1 %2
set /a MBI_Carry = 0
for /L %%i in (0, 1, !MaxQuadIndex!) do (
set /a MBI_Digit = %1_%%i * %2 + MBI_Carry
set /a %1_%%i = MBI_Digit %% 10000
set /a MBI_Carry = MBI_Digit / 10000
)
goto :EOF

:ArctanRecip
if defined PiDebug echo.ArctanRecip %1 %2
call :SetToInteger %1 1
call :DivideByInteger %1 %2
call :CopyValue AR_Recip %1
set /a AR_Toggle = -1
set /a AR_K = 3
:ArctanLoop
if defined PiDebug (
echo.
echo.ArctanRecip AR_K=!AR_K! ---------------------------------------------------------
)
call :DivideByInteger AR_Recip %2
call :DivideByInteger AR_Recip %2
call :CopyValue AR_Term AR_Recip
call :DivideByInteger AR_Term !AR_K!
call :CopyValue AR_PrevSum %1
if !AR_Toggle! lss 0 (
call :Subtract %1 AR_Term
) else (
call :Add %1 AR_Term
)
call :Compare AR_EqualFlag %1 AR_PrevSum
if !AR_EqualFlag! == true goto :EOF
set /a AR_K += 2
set /a AR_Toggle *= -1
goto ArctanLoop

:CopyValue
if defined PiDebug echo.CopyValue %1 %2
for /L %%i in (0, 1, !MaxQuadIndex!) do (
set /a %1_%%i = %2_%%i
)
goto :EOF

:Add
if defined PiDebug echo.Add %1 %2
if defined PiDebug call :Print %1
if defined PiDebug call :Print %2
set /a Add_Carry = 0
for /L %%i in (0, 1, !MaxQuadIndex!) do (
set /a Add_Digit = Add_Carry + %1_%%i + %2_%%i
set /a %1_%%i = Add_Digit %% 10000
set /a Add_Carry = Add_Digit / 10000
)
goto :EOF

:Subtract
if defined PiDebug echo.Subtract %1 %2
if defined PiDebug call :Print %1
if defined PiDebug call :Print %2
set /a Subtract_Borrow = 0
for /L %%i in (0, 1, !MaxQuadIndex!) do (
set /a Subtract_Digit = %1_%%i - %2_%%i - Subtract_Borrow
if !Subtract_Digit! lss 0 (
set /a Subtract_Digit += 10000
set /a Subtract_Borrow = 1
) else (
set /a Subtract_Borrow = 0
)
set /a %1_%%i = Subtract_Digit
)
goto :EOF

:Compare
if defined PiDebug echo.Compare %1 %2 %3
if defined PiDebug call :Print %2
if defined PiDebug call :Print %3
set /a Compare_Index = 0
set %1=true
:CompareLoop
if not !%2_%Compare_Index%! == !%3_%Compare_Index%! (
if defined PiDebug echo.!%2_%Compare_Index%! neq !%3_%Compare_Index%!
set %1=false
goto :EOF
)
set /a Compare_Index += 1
if !Compare_Index! gtr !MaxQuadIndex! (
if defined PiDebug echo.Compare equal
goto :EOF
)
goto CompareLoop

REM $Log: pi.bat,v $
REM Revision 1.2 2007/09/06 21:49:15 Don.Cross
REM Added time stamps and display of formula.
REM
REM Revision 1.1 2007/09/06 21:12:36 Don.Cross
REM Batch file for calculating pi
REM
