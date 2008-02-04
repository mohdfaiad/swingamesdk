Attribute VB_Name = "SwinGame"
Option Explicit
' DO NOT EDIT!!!


Public Core As SGSDKVB6.Core
Public Graphics As SGSDKVB6.Graphics
Public Text As SGSDKVB6.Text
Public Audio As SGSDKVB6.Audio
Public MouseAndKey As New SGSDKVB6.Input
Public Physics As New SGSDKVB6.Physics
Public Camera As New SGSDKVB6.Camera
Public MappyLoader As New SGSDKVB6.MappyLoader
Public DebugLog As New SGSDKVB6.Log
Public Shapes As New SGSDKVB6.Shapes


Sub Load()
    Set Shapes = New SGSDKVB6.Shapes
    Set DebugLog = New SGSDKVB6.Log
    Set Core = New SGSDKVB6.Core
    Set Graphics = New SGSDKVB6.Graphics
    Set Text = New SGSDKVB6.Text
    Set Audio = New SGSDKVB6.Audio
    Set Physics = New SGSDKVB6.Physics
    Set Camera = New SGSDKVB6.Camera
    Set MouseAndKey = New SGSDKVB6.Input
    Set MappyLoader = New SGSDKVB6.MappyLoader
    Set DebugLog = New SGSDKVB6.Log
    Set Shapes = New SGSDKVB6.Shapes
End Sub

