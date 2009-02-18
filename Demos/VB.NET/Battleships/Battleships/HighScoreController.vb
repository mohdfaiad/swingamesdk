Imports System.IO
Imports SwinGame

''' <summary>
''' Controls displaying and collecting high score data.
''' </summary>
''' <remarks>
''' Data is saved to a file.
''' </remarks>
Module HighScoreController
    Private Const NAME_WIDTH As Integer = 3
    Private Const SCORES_LEFT As Integer = 490

    ''' <summary>
    ''' The score structure is used to keep the name and
    ''' score of the top players together.
    ''' </summary>
    Private Structure Score : Implements IComparable
        Public Name As String
        Public Value As Integer

        ''' <summary>
        ''' Allows scores to be compared to facilitate sorting
        ''' </summary>
        ''' <param name="obj">the object to compare to</param>
        ''' <returns>a value that indicates the sort order</returns>
        Public Function CompareTo(ByVal obj As Object) As Integer Implements System.IComparable.CompareTo
            If TypeOf obj Is Score Then
                Dim other As Score = CType(obj, Score)

                Return other.Value - Me.Value
            Else
                Return 0
            End If
        End Function
    End Structure

    Private _Scores As New List(Of Score)

    ''' <summary>
    ''' Loads the scores from the highscores text file.
    ''' </summary>
    ''' <remarks>
    ''' The format is
    ''' # of scores
    ''' NNNSSS
    ''' 
    ''' Where NNN is the name and SSS is the score
    ''' </remarks>
    Private Sub LoadScores()
        Dim filename As String
        filename = Core.GetPathToResource("highscores.txt")

        Dim input As StreamReader
        input = New StreamReader(filename)

        'Read in the # of scores
        Dim numScores As Integer
        numScores = Convert.ToInt32(input.ReadLine())

        _Scores.Clear()

        For i As Integer = 1 To numScores
            Dim s As Score
            Dim line As String

            line = input.ReadLine()

            s.Name = line.Substring(0, NAME_WIDTH)
            s.Value = Convert.ToInt32(line.Substring(NAME_WIDTH))
            _Scores.Add(s)
        Next
        input.Close()
    End Sub

    ''' <summary>
    ''' Saves the scores back to the highscores text file.
    ''' </summary>
    ''' <remarks>
    ''' The format is
    ''' # of scores
    ''' NNNSSS
    ''' 
    ''' Where NNN is the name and SSS is the score
    ''' </remarks>
    Private Sub SaveScores()
        Dim filename As String
        filename = Core.GetPathToResource("highscores.txt")

        Dim output As StreamWriter
        output = New StreamWriter(filename)

        output.WriteLine(_Scores.Count)

        For Each s As Score In _Scores
            output.WriteLine(s.Name & s.Value)
        Next

        output.Close()
    End Sub

    ''' <summary>
    ''' Draws the high scores to the screen.
    ''' </summary>
    Public Sub DrawHighScores()
        Const SCORES_HEADING As Integer = 40
        Const SCORES_TOP As Integer = 80
        Const SCORE_GAP As Integer = 30

        If _Scores.Count = 0 Then LoadScores()

        Text.DrawText("   High Scores   ", Color.White, GameFont("Courier"), SCORES_LEFT, SCORES_HEADING)

        'For all of the scores
        For i As Integer = 0 To _Scores.Count - 1
            Dim s As Score

            s = _Scores.Item(i)

            'for scores 1 - 9 use 01 - 09
            If i < 9 Then
                Text.DrawText(" " & (i + 1) & ":   " & s.Name & "   " & s.Value, Color.White, GameFont("Courier"), SCORES_LEFT, SCORES_TOP + i * SCORE_GAP)
            Else
                Text.DrawText(i + 1 & ":   " & s.Name & "   " & s.Value, Color.White, GameFont("Courier"), SCORES_LEFT, SCORES_TOP + i * SCORE_GAP)
            End If
        Next
    End Sub

    ''' <summary>
    ''' Handles the user input during the top score screen.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub HandleHighScoreInput()
        If Input.MouseWasClicked(MouseButton.LeftButton) OrElse Input.WasKeyTyped(Keys.VK_ESCAPE) OrElse Input.WasKeyTyped(Keys.VK_RETURN) Then
            EndCurrentState()
        End If
    End Sub

    ''' <summary>
    ''' Read the user's name for their highscore.
    ''' </summary>
    ''' <param name="value">the player's score.</param>
    ''' <remarks>
    ''' This verifies if the score is a highscore.
    ''' </remarks>
    Public Sub ReadHighScore(ByVal value As Integer)
        Const ENTRY_TOP As Integer = 500

        If _Scores.Count = 0 Then LoadScores()

        'is it a high score
        If value > _Scores.Item(_Scores.Count - 1).Value Then
            Dim s As New Score
            s.Value = value

            AddNewState(GameState.ViewingHighScores)

            Input.StartReadingText(Color.White, NAME_WIDTH, GameFont("Courier"), SCORES_LEFT + Text.TextWidth("Name: ", GameFont("Courier")), ENTRY_TOP)

            'Read the text from the user
            While Input.IsReadingText()
                Core.ProcessEvents()

                DrawBackground()
                DrawHighScores()
                Text.DrawText("Name: ", Color.White, GameFont("Courier"), SCORES_LEFT, ENTRY_TOP)
                Core.RefreshScreen()
            End While

            s.Name = Input.TextReadAsASCII()

            If s.Name.Length < 3 Then
                s.Name = s.Name & New String(CChar(" "), 3 - s.Name.Length)
            End If

            _Scores.RemoveAt(_Scores.Count - 1)
            _Scores.Add(s)
            _Scores.Sort()

            SaveScores()
            EndCurrentState()
        End If
    End Sub
End Module
