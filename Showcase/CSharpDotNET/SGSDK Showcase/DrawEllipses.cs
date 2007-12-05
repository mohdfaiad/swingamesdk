using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Drawing;

using SwinGame;
using Graphics = SwinGame.Graphics;
using Bitmap = SwinGame.Bitmap;
using Font = SwinGame.Font;
using FontStyle = SwinGame.FontStyle;

namespace SGSDK_Showcase
{
    public static class DrawEllipses
    {
        public static void Run()
        {
            Graphics.ClearScreen();

            for (int i = 0; i < 100; i++)
            {
                Graphics.DrawEllipse(Randoms.GetRandomColor(), Randoms.GetRandomNumber(800), Randoms.GetRandomNumber(800), Randoms.GetRandomNumber(400), Randoms.GetRandomNumber(400));
                Graphics.FillEllipse(Randoms.GetRandomColor(), Randoms.GetRandomNumber(800), Randoms.GetRandomNumber(800), Randoms.GetRandomNumber(400), Randoms.GetRandomNumber(400));
            
                Overlay.DrawOverlay("Drawing Ellipses Example");

                Core.Sleep(100);

                Core.ProcessEvents();
                Core.RefreshScreen();
            }

            Graphics.ClearScreen();
        }
    }
}