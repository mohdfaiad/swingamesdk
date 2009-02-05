Imports SwinGame
Imports System.Collections.Generic

Public Module GameResources

    Private Sub LoadFonts()
        NewFont("ArialLarge", "arial.ttf", 80)
        NewFont("Courier", "cour.ttf", 14)
        NewFont("CourierSmall", "cour.ttf", 8)
        NewFont("Menu", "ffaccess.ttf", 8)
    End Sub

    Private Sub LoadImages()
        'Backgrounds
        NewImage("Menu", "main_page.jpg")
        NewImage("Discovery", "discover.jpg")
        NewImage("Deploy", "deploy.jpg")

        'Deployment
        NewImage("LeftRightButton", "deploy_dir_button_horiz.png")
        NewImage("UpDownButton", "deploy_dir_button_vert.png")
        NewImage("SelectedShip", "deploy_button_hl.png")
        NewImage("PlayButton", "deploy_play_button.png")
        NewImage("RandomButton", "deploy_randomize_button.png")

        'Ships
        For i As Integer = 1 To 5
            NewImage("ShipLR" & i, "ship_deploy_horiz_" & i & ".png")
            NewImage("ShipUD" & i, "ship_deploy_vert_" & i & ".png")

        Next

        'Explosions
        NewImage("Explosion", "explosion.png")
        NewImage("Splash", "splash.png")

    End Sub

    Private Sub LoadSounds()
        NewSound("Error", "error.wav")
        NewSound("Hit", "hit.wav")
        NewSound("Sink", "sink.wav")
        NewSound("Miss", "sink.wav")
        NewSound("Winner", "winner.wav")
        NewSound("Lose", "lose.wav")
        NewSound("Deploy", "deploy.wav")

    End Sub

    Private Sub LoadMusic()
        NewMusic("Background", "horrordrone.mp3")
    End Sub

    Private Sub LoadMaps()
    End Sub

    ''' <summary>
    ''' Gets a Font Loaded in the Resources
    ''' </summary>
    ''' <param name="font">Name of Font</param>
    ''' <returns>The Font Loaded with this Name</returns>

    Public Function GameFont(ByVal font As String) As Font
        Return _Fonts(font)
    End Function

    ''' <summary>
    ''' Gets an Image loaded in the Resources
    ''' </summary>
    ''' <param name="image">Name of image</param>
    ''' <returns>The image loaded with this name</returns>

    Public Function GameImage(ByVal image As String) As Bitmap
        Return _Images(image)
    End Function

    ''' <summary>
    ''' Gets an sound loaded in the Resources
    ''' </summary>
    ''' <param name="sound">Name of sound</param>
    ''' <returns>The sound with this name</returns>

    Public Function GameSound(ByVal sound As String) As SoundEffect
        Return _Sounds(sound)
    End Function

    ''' <summary>
    ''' Gets the music loaded in the Resources
    ''' </summary>
    ''' <param name="music">Name of music</param>
    ''' <returns>The music with this name</returns>

    Public Function GameMusic(ByVal music As String) As Music
        Return _Music(music)
    End Function

    ''' <summary>
    ''' Gets a map loaded in the Resources
    ''' </summary>
    ''' <param name="map">Name of map</param>
    ''' <returns>The map with this name</returns>

    Public Function GameMap(ByVal map As String) As Map
        Return _Maps(map)
    End Function

    Private _Images As New Dictionary(Of String, Bitmap)
    Private _Fonts As New Dictionary(Of String, Font)
    Private _Sounds As New Dictionary(Of String, SoundEffect)
    Private _Music As New Dictionary(Of String, Music)
    Private _Maps As New Dictionary(Of String, Map)

    Private _Background As Bitmap
    Private _Animation As Bitmap
    Private _LoaderFull As Bitmap
    Private _LoaderEmpty As Bitmap
    Private _LoadingFont As Font
    Private _StartSound As SoundEffect

    ''' <summary>
    ''' The Resources Class stores all of the Games Media Resources, such as Images, Fonts
    ''' Sounds, Music, and Maps.
    ''' </summary>

    Public Sub LoadResources()
        Dim width, height As Integer

        width = Core.ScreenWidth()
        height = Core.ScreenHeight()

        Core.ChangeScreenSize(800, 600)

        ShowLoadingScreen()

        ShowMessage("Loading fonts...", 0)
        LoadFonts()
        Core.Sleep(100)

        ShowMessage("Loading images...", 1)
        LoadImages()
        Core.Sleep(100)

        ShowMessage("Loading sounds...", 2)
        LoadSounds()
        Core.Sleep(100)

        ShowMessage("Loading music...", 3)
        LoadMusic()
        Core.Sleep(100)

        ShowMessage("Loading maps...", 4)
        LoadMaps()
        Core.Sleep(100)

        Core.Sleep(100)
        ShowMessage("Game loaded...", 5)
        Core.Sleep(100)
        EndLoadingScreen(width, height)
    End Sub

    Private Sub ShowLoadingScreen()
        _Background = Graphics.LoadBitmap(Core.GetPathToResource("SplashBack.png", ResourceKind.ImageResource))
        Graphics.DrawBitmap(_Background, 0, 0)
        Core.RefreshScreen()
        Core.ProcessEvents()

        _Animation = Graphics.LoadBitmap(Core.GetPathToResource("SwinGameAni.jpg", ResourceKind.ImageResource))
        _LoadingFont = Text.LoadFont(Core.GetPathToResource("arial.ttf", ResourceKind.FontResource), 12)
        _StartSound = Audio.LoadSoundEffect(Core.GetPathToResource("SwinGameStart.ogg", ResourceKind.SoundResource))

		_LoaderFull = Graphics.LoadBitmap(Core.GetPathToResource("loader_full.png", ResourceKind.ImageResource))
		_LoaderEmpty = Graphics.LoadBitmap(Core.GetPathToResource("loader_empty.png", ResourceKind.ImageResource))

        PlaySwinGameIntro()
    End Sub

    Private Sub PlaySwinGameIntro()
        Const ANI_X As Integer = 143, ANI_Y As Integer = 134, ANI_W As Integer = 546, ANI_H As Integer = 327, ANI_V_CELL_COUNT As Integer = 6, ANI_CELL_COUNT As Integer = 11

        Audio.PlaySoundEffect(_StartSound)
        Core.Sleep(200)

        Dim i As Integer
        For i = 0 To ANI_CELL_COUNT - 1
	        Graphics.DrawBitmap(_Background, 0, 0)
	        Graphics.DrawBitmapPart(_Animation, (i \ ANI_V_CELL_COUNT) * ANI_W, (i mod ANI_V_CELL_COUNT) * ANI_H, ANI_W, ANI_H, ANI_X, ANI_Y)
	        Core.Sleep(20)
            Core.RefreshScreen()
            Core.ProcessEvents()
        Next i

        Core.Sleep(1500)

    End Sub

    Private Sub ShowMessage(ByVal message As String, ByVal number As Integer)
        Const TX As Integer = 310, TY As Integer = 493, TW As Integer = 200, TH As Integer = 25, STEPS As Integer = 5, BG_X As Integer = 279, BG_Y As Integer = 453
		
		Dim fullW As Integer

		fullW = 260 * number \ STEPS
		Graphics.DrawBitmap(_LoaderEmpty, BG_X, BG_Y)
		Graphics.DrawBitmapPart(_LoaderFull, 0, 0, fullW, 66, BG_X, BG_Y)
				
		Text.DrawTextLines(message, Color.White, Color.Transparent, _LoadingFont, FontAlignment.AlignCenter, TX, TY, TW, TH)

        Core.RefreshScreen()
        Core.ProcessEvents()
    End Sub

    Private Sub EndLoadingScreen(ByVal width As Integer, ByVal height As Integer)
        Core.ProcessEvents()
        Core.Sleep(500)
        Graphics.ClearScreen()
        Core.RefreshScreen()
        Text.FreeFont(_LoadingFont)
        Graphics.FreeBitmap(_Background)
        Graphics.FreeBitmap(_Animation)
        Graphics.FreeBitmap(_LoaderEmpty)
        Graphics.FreeBitmap(_LoaderFull)
        Audio.FreeSoundEffect(_StartSound)
        Core.ChangeScreenSize(width, height)
    End Sub

    Private Sub NewMap(ByVal mapName As String)
        _Maps.Add(mapName, MappyLoader.LoadMap(mapName))
    End Sub

    Private Sub NewFont(ByVal fontName As String, ByVal filename As String, ByVal size As Integer)
        _Fonts.Add(fontName, Text.LoadFont(Core.GetPathToResource(filename, ResourceKind.FontResource), size))
    End Sub

    Private Sub NewImage(ByVal imageName As String, ByVal filename As String)
        _Images.Add(imageName, Graphics.LoadBitmap(Core.GetPathToResource(filename, ResourceKind.ImageResource)))
    End Sub

    Private Sub NewTransparentColorImage(ByVal imageName As String, ByVal fileName As String, ByVal transColor As Color)
        _Images.Add(imageName, Graphics.LoadBitmap(Core.GetPathToResource(fileName, ResourceKind.ImageResource), True, transColor))
    End Sub

    Private Sub NewTransparentColourImage(ByVal imageName As String, ByVal fileName As String, ByVal transColor As Color)
        NewTransparentColorImage(imageName, fileName, transColor)
    End Sub

    Private Sub NewSound(ByVal soundName As String, ByVal filename As String)
        _Sounds.Add(soundName, Audio.LoadSoundEffect(Core.GetPathToResource(filename, ResourceKind.SoundResource)))
    End Sub

    Private Sub NewMusic(ByVal musicName As String, ByVal filename As String)
        _Music.Add(musicName, Audio.LoadMusic(Core.GetPathToResource(filename, ResourceKind.SoundResource)))
    End Sub

    Private Sub FreeFonts()
        Dim obj As Font
        For Each obj In _Fonts.Values
            Text.FreeFont(obj)
        Next
    End Sub

    Private Sub FreeImages()
        Dim obj As Bitmap
        For Each obj In _Images.Values
            Graphics.FreeBitmap(obj)
        Next
    End Sub

    Private Sub FreeSounds()
        Dim obj As SoundEffect
        For Each obj In _Sounds.Values
            Audio.FreeSoundEffect(obj)
        Next
    End Sub

    Private Sub FreeMusic()
        Dim obj As Music
        For Each obj In _Music.Values
            Audio.FreeMusic(obj)
        Next
    End Sub

    Private Sub FreeMaps()
        Dim obj As Map
        For Each obj In _Maps.Values
            MappyLoader.FreeMap(obj)
        Next
    End Sub

    Public Sub FreeResources()
        FreeFonts()
        FreeImages()
        FreeMusic()
        FreeSounds()
        FreeMaps()
		Core.ProcessEvents()
    End Sub
End Module
