Set wshell=CreateObject("WScript.Shell")
Set zira = CreateObject("SAPI.spVoice")
Set zira.voice = zira.GetVoices.Item(1)
zira.Volume = 100
zira.speak "Welcome Back! Have a nice time ahead"
wshell.Run chr(34) & "Battery_TaskV.bat" & Chr(34), 0
Set zira=nothing
Set wshell=nothing
