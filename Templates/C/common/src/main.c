#include <stdio.h>
#include <stdbool.h>
#include "SwinGame.h"

int main(int argc, const char* argv[])
{
    SetAppPath(argv[0], true);
    OpenAudio();
    OpenGraphicsWindow("Hello World", 800, 600);
    
    Color white = RGBAColor(255, 255, 255, 255);
    
    while (!WindowCloseRequested())
    {
        ClearScreen();
        
        //FillRectangle(white, 10, 10, 620, 460);
        DrawBitmap(GetBitmap("SplashBack"), 0, 0);
        
        ProcessEvents();
        RefreshScreen();
    }
    
    ReleaseAllResources();
    
    CloseAudio();
    return 0;
}
