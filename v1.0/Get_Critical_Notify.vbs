Set obsh=CreateObject("WScript.Shell")
Set myFSO=CreateObject("Scripting.FileSystemObject")
Set zira=CreateObject("SAPI.spVoice")
Set zira.voice=zira.GetVoices.Item(1)
zira.Volume=100
zira.speak "Battery critical, you must connect the charger"
intAns=obsh.Popup("Battery CRITICAL ! Wanna snooze this ?",10,"CRITICAL Battery Alert !",3+48)
Set writeObj=myFSO.OpenTextFile("Set_LowCr_Rem.txt",2,true)
Dim abort : abort=0
writeObj.writeLine("0")
If intAns=vbNo Then
	writeObj.writeLine("0")
	abort=1
Else
	writeObj.writeLine("1")
	If intAns=vbCancel Then
		abort=1
	End If
End If
writeObj.Close
Set zira=nothing
Set writeObj=nothing
Set myFSO=nothing
If abort=1 Then
	obsh.Run "cmd /c taskkill /F /IM wscript.exe", 0, True
End If
Set obsh=nothing
