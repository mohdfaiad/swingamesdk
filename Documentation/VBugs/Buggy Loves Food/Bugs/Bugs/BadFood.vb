﻿Public Class BadFood : Inherits Food

    Public Sub New(ByVal time As Integer)
        MyBase.New(time, GameImage("badApple"), GameImage("badApplean"))
    End Sub

    Public Overrides Sub AddScore()
        score = score - 1
    End Sub

End Class