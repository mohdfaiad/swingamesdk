program HowToMoveASprite;
uses sgGraphics, sgText, sgSprites, sgTypes, sgImages, sgUtils, sgInput, sgResources, sgPhysics;

procedure Main();
var
	ball1, ball2: Sprite;
begin
    OpenGraphicsWindow('Detect Collision', 800, 600);
	
	LoadBitmapNamed('ball', 'ball_small.png');
	
	ball1 := CreateSprite(BitmapNamed('ball'));
    ball2 := CreateSprite(BitmapNamed('ball'));
    
	SpriteSetX(ball1, 400);
	SpriteSetY(ball1, 40);
	SpriteSetDx(ball1, 0);
	SpriteSetDy(ball1, 0.1);
    
    SpriteSetX(ball2, 400);
	SpriteSetY(ball2, 560);
	SpriteSetDx(ball2, 0);
	SpriteSetDy(ball2, -0.1);
	
	repeat
        ClearScreen(ColorWhite);

        if SpriteCollision(ball1, ball2) then
        begin
            DrawText('Collision Happens!!!', ColorRed, 380, 15);
        end;

        DrawSprite(ball1);
        UpdateSprite(ball1);
        DrawSprite(ball2);
        UpdateSprite(ball2);
        
        RefreshScreen();
        ProcessEvents();
	until WindowCloseRequested();

	ReleaseAllResources();  
end;

begin
	Main();
end.