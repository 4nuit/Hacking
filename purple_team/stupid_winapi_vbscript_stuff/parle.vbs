Dim speaks, speech

Set speech=CreateObject("sapi.spvoice")

Dim oFso, f

set oFso = CreateObject("Scripting.FileSystemObject")

set f = oFso.OpenTextFile("lecture.txt",1)

while Not f.AtEndOfStream
	speech.Speak f.Readline

Wend

f.Close	