Imports SwinGame

''' <summary>
''' The battle phase is handled by the DiscoveryController.
''' </summary>
Module DiscoveryController

    ''' <summary>
    ''' Handles input during the discovery phase of the game.
    ''' </summary>
    ''' <remarks>
    ''' Escape opens the game menu. Clicking the mouse will
    ''' attack a location.
    ''' </remarks>
    Public Sub HandleDiscoveryInput()
        If Input.WasKeyTyped(Keys.VK_ESCAPE) Then
            AddNewState(GameState.ViewingGameMenu)
        End If

        If Input.MouseWasClicked(MouseButton.LeftButton) Then
            DoAttack()
        End If
    End Sub

    ''' <summary>
    ''' Attack the location that the mouse if over.
    ''' </summary>
    Private Sub DoAttack()
        Dim mouse As Point2D

        mouse = Input.GetMousePosition()

        'Calculate the row/col clicked
        Dim row, col As Integer
        row = Convert.ToInt32(Math.Floor((mouse.Y - FIELD_TOP) / (CELL_HEIGHT + CELL_GAP)))
        col = Convert.ToInt32(Math.Floor((mouse.X - FIELD_LEFT) / (CELL_WIDTH + CELL_GAP)))

        If row >= 0 And row < HumanPlayer.EnemyGrid.Height Then
            If col >= 0 And col < HumanPlayer.EnemyGrid.Width Then
                Attack(row, col)
            End If
        End If
    End Sub

    ''' <summary>
    ''' Draws the game during the attack phase.
    ''' </summary>s
    Public Sub DrawDiscovery()
        Const SCORES_LEFT As Integer = 172
        Const SHOTS_TOP As Integer = 157
        Const HITS_TOP As Integer = 206
        Const SPLASH_TOP As Integer = 256

        If Input.IsKeyPressed(Keys.VK_SHIFT) And Input.IsKeyPressed(Keys.VK_C) Then
            DrawField(HumanPlayer.EnemyGrid, ComputerPlayer, True)
        Else
            DrawField(HumanPlayer.EnemyGrid, ComputerPlayer, False)
        End If

        DrawSmallField(HumanPlayer.PlayerGrid, HumanPlayer)
        DrawMessage()

        Text.DrawText(HumanPlayer.Shots.ToString(), Color.White, GameFont("Menu"), SCORES_LEFT, SHOTS_TOP)
        Text.DrawText(HumanPlayer.Hits.ToString(), Color.White, GameFont("Menu"), SCORES_LEFT, HITS_TOP)
        Text.DrawText(HumanPlayer.Missed.ToString(), Color.White, GameFont("Menu"), SCORES_LEFT, SPLASH_TOP)
    End Sub

End Module
