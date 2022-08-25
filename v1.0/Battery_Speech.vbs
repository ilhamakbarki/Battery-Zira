Set myFSO = CreateObject("Scripting.FileSystemObject") 
If (myFSO.FileExists("Battery_Info.txt")) Then 
	Set zira = CreateObject("SAPI.spVoice")
	Set zira.voice = zira.GetVoices.Item(1)
	zira.Volume = 100
	Set readObj = myFSO.OpenTextFile("Battery_Info.txt",1)
	For i=1 to 2
		Dim S
		S = readObj.ReadLine
		zira.speak S
	Next
	readObj.Close
	Set readObj = nothing
	Set zira = nothing
End If
Set myFSO = nothing
