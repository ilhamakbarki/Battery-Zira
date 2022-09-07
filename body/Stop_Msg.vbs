Set obsh = CreateObject("WScript.Shell")
Set myFSO = CreateObject("Scripting.FileSystemObject")
Dim checkV : checkV = 1
Dim getSpkr : getSpkr = 1
Dim getR : getR = 2
Dim setBL : setBL = "Set_Battery_Level.txt"
' Read voice status and speaker
If (myFSO.FileExists(setBL)) Then
	Set readObj = myFSO.OpenTextFile(setBL,1)
	checkV = CInt(readObj.ReadLine)
	For i=2 to 6
		getSpkr = readObj.ReadLine
	Next
	getSpkr = CInt(getSpkr)
	getR = CInt(readObj.ReadLine)
	readObj.Close
	Set readObj = nothing
End If
' Check if voice is enabled
If checkV = 1 Then
	' Set the chosen speaker
	Set spkr = CreateObject("SAPI.spVoice")
	Set spkr.voice = spkr.GetVoices.Item(getSpkr)
	spkr.Volume = 100
	spkr.Rate = getR
	' Set the before and after texts
	Dim bef : bef = "I have come to an end"
	Dim af : af = "I shall continue no farther"
	Dim beftxt : beftxt = "pre\stopB.txt"
	Dim aftxt : aftxt = "post\stopA.txt"
	Dim noLines,rLine
	If (myFSO.FileExists(beftxt)) Then
		Set readObj = myFSO.OpenTextFile(beftxt,1)
		Do Until readObj.AtEndOfStream
			readObj.SkipLine
		Loop
		noLines = readObj.Line-1
		Randomize
		rLine = 1+Int(Rnd*noLines)
		Set readObj = myFSO.OpenTextFile(beftxt,1)
		For i=1 to rLine
			bef = readObj.ReadLine
		Next
		readObj.Close
		Set readObj = Nothing
	End If
	If (myFSO.FileExists(aftxt)) Then
		Set readObj = myFSO.OpenTextFile(aftxt,1)
		Do Until readObj.AtEndOfStream
			readObj.SkipLine
		Loop
		noLines = readObj.Line-1
		Randomize
		rLine = 1+Int(Rnd*noLines)
		Set readObj = myFSO.OpenTextFile(aftxt,1)
		For i=1 to rLine
			af = readObj.ReadLine
		Next
		readObj.Close
		Set readObj = Nothing
	End If
	Dim spk : spk = bef & ", " & af
	spkr.speak spk
	Set spkr = nothing
End If
Set myFSO = nothing
' Prompt for user interaction
intAns = obsh.Popup("Battery-Zira STOPPED Successfully !",,"STOP Battery-Zira !",0+16)
Dim abort : abort = 0
If intAns = vbOk Then
	abort = 1
End If
If abort = 1 Then
	obsh.Run "cmd /c taskkill /F /IM wscript.exe /T", 0, True
End If
Set obsh = Nothing