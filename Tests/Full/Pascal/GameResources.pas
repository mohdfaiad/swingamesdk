unit GameResources;

interface
	uses SysUtils, SGSDK_Core, SGSDK_Font, SGSDK_Audio, SGSDK_Graphics, SGSDK_Input, SGSDK_Physics, SGSDK_MappyLoader;

	procedure LoadResources();
	procedure FreeResources();
	function GameFont(font: String): Font;
	function GameImage(image: String): Bitmap;
	function GameSound(sound: String): SoundEffect;
	function GameMusic(music: String): Music;
	function GameMap(mapName: String): Map;
 
implementation
	var
		_Images: Array of Bitmap;
		_Fonts: Array of Font;
		_Sounds: Array of SoundEffect;
		_Music: Array of Music;
		_Maps: Array of Map;

		_ImagesStr: Array of String;
		_FontsStr: Array of String;
		_SoundsStr: Array of String;
		_MusicStr: Array of String;
		_MapsStr: Array of String;

		_Background: Bitmap;
		_Animation: Bitmap;
		_LoaderEmpty: Bitmap;
		_LoaderFull: Bitmap;
		_LoadingFont: Font;
		_StartSound: SoundEffect;

	procedure PlaySwinGameIntro();
	const
		ANI_X = 143;
		ANI_Y = 134;
		ANI_W = 546;
		ANI_H = 327;
		ANI_V_CELL_COUNT = 6;
		ANI_CELL_COUNT = 11;
	var
		i : Integer;
	begin
		PlaySoundEffect(_StartSound);
		Sleep(200);
		for i:= 0 to ANI_CELL_COUNT - 1 do
		begin
			DrawBitmap(_Background, 0, 0);
			DrawBitmapPart(_Animation, 
				(i div ANI_V_CELL_COUNT) * ANI_W, (i mod ANI_V_CELL_COUNT) * ANI_H,
				ANI_W, ANI_H, ANI_X, ANI_Y);
			RefreshScreen();
			ProcessEvents();
			Sleep(20);
		end;
		Sleep(1500);
	end;

	procedure ShowLoadingScreen();
	begin
		_Background := LoadBitmap(GetPathToResource('SplashBack.png', ImageResource));
		DrawBitmap(_Background, 0, 0);
		RefreshScreen(60);
		ProcessEvents();

		_Animation := LoadBitmap(GetPathToResource('SwinGameAni.png', ImageResource));
		_LoaderEmpty := LoadBitmap(GetPathToResource('loader_empty.png', ImageResource));
		_LoaderFull := LoadBitmap(GetPathToResource('loader_full.png', ImageResource));
		_LoadingFont := LoadFont(GetPathToResource('arial.ttf', FontResource), 12);
		_StartSound := LoadSoundEffect(GetPathToResource('SwinGameStart.ogg', SoundResource));

		PlaySwinGameIntro();
	end;

	procedure ShowMessage(message: String; number: Integer);
	const
		TX = 310; TY = 493; 
		TW = 200; TH = 25;
		STEPS = 5;
		BG_X = 279; BG_Y = 453;
	var
		fullW: Integer;
	begin
		fullW := 260 * number div STEPS;
		DrawBitmap(_LoaderEmpty, BG_X, BG_Y);
		DrawBitmapPart(_LoaderFull, 0, 0, fullW, 66, BG_X, BG_Y);

		DrawTextLines(message, ColorWhite, ColorTransparent, _LoadingFont, AlignCenter, TX, TY, TW, TH);
		RefreshScreen(60);
		ProcessEvents();
	end;

	procedure EndLoadingScreen();
	begin
		ProcessEvents();
		Sleep(500);
		ClearScreen();
		RefreshScreen(60);
		FreeFont(_LoadingFont);
		FreeBitmap(_Background);
		FreeBitmap(_Animation);
    FreeBitmap(_LoaderEmpty);
    FreeBitmap(_LoaderFull);
		FreeSoundEffect(_StartSound);
	end;
	
	procedure NewMap(mapName: String);
	begin
		SetLength(_Maps, Length(_Maps) + 1);
		SetLength(_MapsStr, Length(_MapsStr) + 1);
		_Maps[High(_Maps)] := LoadMap(mapName);
		_MapsStr[High(_MapsStr)] := mapName;
	end;
	
	procedure NewFont(fontName, fileName: String; size: Integer);
	begin
		SetLength(_Fonts, Length(_Fonts) + 1);
		SetLength(_FontsStr, Length(_FontsStr) + 1);
		_Fonts[High(_Fonts)] := LoadFont(GetPathToResource(fileName, FontResource), size);
		_FontsStr[High(_FontsStr)] := fontName;
	end;
	
	procedure NewImage(imageName, fileName: String);
	begin
		SetLength(_Images, Length(_Images) + 1);
		SetLength(_ImagesStr, Length(_ImagesStr) + 1);
		_Images[High(_Images)] := LoadBitmap(GetPathToResource(fileName, ImageResource));
		_ImagesStr[High(_ImagesStr)] := imageName;
	end;
	
	procedure NewTransparentColourImage(imageName, fileName: String; transColour: Colour);
	begin
		SetLength(_Images, Length(_Images) + 1);
		SetLength(_ImagesStr, Length(_ImagesStr) + 1);
		_Images[High(_Images)] := LoadBitmap(GetPathToResource(fileName, ImageResource), true, transColour);
		_ImagesStr[High(_ImagesStr)] := imageName;
	end;
	
	procedure NewTransparentColorImage(imageName, fileName: String; transColor: Color);
	begin
		NewTransparentColourImage(imageName, fileName, transColor);
	end;
	
	procedure NewSound(soundName, fileName: String);
	begin
		SetLength(_Sounds, Length(_Sounds) + 1);
		SetLength(_SoundsStr, Length(_SoundsStr) + 1);
		_Sounds[High(_Sounds)] := LoadSoundEffect(GetPathToResource(fileName, SoundResource));
		_SoundsStr[High(_SoundsStr)] := soundName;
	end;
	
	procedure NewMusic(musicName, fileName: String);
	begin
		SetLength(_Music, Length(_Music) + 1);
		SetLength(_MusicStr, Length(_MusicStr) + 1);
		_Music[High(_Music)] := LoadMusic(GetPathToResource(fileName, SoundResource));
		_MusicStr[High(_MusicStr)] := musicName;
	end;
	
	procedure LoadFonts();
	begin
		NewFont('ArialLarge', 'arial.ttf', 80);
		NewFont('Courier', 'cour.ttf', 15);
		NewFont('CourierLarge', 'cour.ttf', 28);
	end;

	procedure FreeFonts();
	var
		i: Integer;
	begin
		for i := Low(_Fonts) to High(_Fonts) do
		begin
			FreeFont(_Fonts[i]);
		end;
	end;

	procedure LoadImages();
	var
		i: Integer;
	begin
		NewImage('SmallBall', 'ball_small.png');
		NewImage('BallImage1', 'ball.png');
		NewImage('BallImage2', 'ball2.png');
		NewImage('SmallBall', 'ball_small.png');
		NewImage('Running', 'running.png');
		NewImage('Explosion', 'Explosion.png');
		NewImage('Ship', 'ship.png');
		NewImage('Sea', 'sea.png');
		NewImage('BGA', 'BackgroundDrawArea.png');
		NewImage('BG', 'BackgroundMain.png');
		NewImage('Frame1', 'F01.png');
		NewImage('Frame2', 'F02.png');
		NewImage('Frame3', 'F03.png');
		NewImage('Frame4', 'F04.png');
		NewImage('Frame5', 'F05.png');
		NewImage('Frame6', 'F06.png');
		NewImage('enShip', 'enShip.png');
		NewTransparentColourImage('BlueExplosion', 'explosion_pro.jpg', ColourBlack);
		for i := 0 to 39 do
		begin
			NewTransparentColourImage('Explode_' + IntToStr(i), 'explode_' + IntToStr(i) + '.jpg', ColourBlack);
		end;
		//NewImage('NoImages', 'Ufo.png');
	end;

	procedure FreeImages();
	var
		i: Integer;
	begin
		for i := Low(_Images) to High(_Images) do
		begin
			FreeBitmap(_Images[i]);
		end;
	end;

	procedure LoadSounds();
	begin
		NewSound('Shock', 'shock.wav');
		//NewSound('NoSound', 'sound.ogg');
	end;
	
	procedure LoadMaps();
	begin
		NewMap('test');
		NewMap('test3');
	end;
	
	procedure FreeSounds();
	var
		i: Integer;
	begin
		for i := Low(_Sounds) to High(_Sounds) do
		begin
			FreeSoundEffect(_Sounds[i]);
		end;
	end;

	procedure LoadMusics();
	begin
		NewMusic('Fast', 'Fast.mp3');
		//NewMusic('NoMusic', 'sound.mp3');
	end;

	procedure FreeMusics();
	var
		i: Integer;
	begin
		for i := Low(_Music) to High(_Music) do
		begin
			FreeMusic(_Music[i]);
		end;
	end;
	
	procedure FreeMaps();
	var
		i: Integer;
	begin
		for i := Low(_Maps) to High(_Maps) do
		begin
			FreeMap(_Maps[i]);
		end;
	end;

	procedure LoadResources();
	var
		oldW, oldH: Integer;
	begin
		oldW := ScreenWidth();
		oldH := ScreenHeight();

		ChangeScreenSize(800, 600);

		//Remove sleeps once "real" game resources are being loaded
		ShowLoadingScreen();
		ShowMessage('Loading fonts...', 0); 
		LoadFonts();
		Sleep(50);

		ShowMessage('Loading images...', 1);
		LoadImages();
		Sleep(50);

		ShowMessage('Loading sounds...', 2);
		LoadSounds();
		Sleep(50);

		ShowMessage('Loading music...', 3);
		LoadMusics();
		Sleep(50);
		
		ShowMessage('Loading maps...', 4);
		LoadMaps();
		Sleep(50);

		ShowMessage('Game loaded...', 5);
		Sleep(50);
		EndLoadingScreen();

		ChangeScreenSize(oldW, oldH);
	end;

	procedure FreeResources();
	begin
		FreeFonts();
		FreeImages();
		FreeMusics();
		FreeSounds();
		FreeMaps();
	end;

	function GameFont(font: String): Font; 
	var
		i: Integer;
	begin
		for i := Low(_FontsStr) to High(_FontsStr) do
		begin
			if _FontsStr[i] = font then begin
				result := _Fonts[i];
				exit;
			end;
		end;
		raise exception.create('Font ' + font + ' does not exist...');
	end;

	function GameImage(image: String): Bitmap;
	var
	i: Integer;
	begin
		for i := Low(_ImagesStr) to High(_ImagesStr) do
		begin
			if _ImagesStr[i] = image then begin
				result := _Images[i];
				exit;
			end;
		end;
		raise exception.create('Image ' + image + ' does not exist...');
	end;

	function GameSound(sound: String): SoundEffect; 
	var
		i: Integer;
	begin
		for i := Low(_SoundsStr) to High(_SoundsStr) do
		begin
			if _SoundsStr[i] = sound then begin
				result := _Sounds[i];
				exit;
			end;
		end;
		raise exception.create('Sound ' + sound + ' does not exist...');
	end;
	
	function GameMap(mapName: String): Map;
	var
		i: Integer;
	begin
		for i := Low(_MapsStr) to High(_MapsStr) do
		begin
			if _MapsStr[i] = mapName then begin
				result := _Maps[i];
				exit;
			end;
		end;
		raise exception.create('Map ' + mapName + ' does not exist...');
	end;
	
	function GameMusic(music: String): Music;
	var
		i: Integer;
	begin
		for i := Low(_MusicStr) to High(_MusicStr) do
		begin
			if _MusicStr[i] = music then begin
				result := _Music[i];
				exit;
			end;
		end;
		raise exception.create('Music ' + music + ' does not exist...');
	end;
end.