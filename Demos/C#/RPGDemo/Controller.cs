using System;
using System.Drawing;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;

using SwinGame;
using Graphics = SwinGame.Graphics;
using Bitmap = SwinGame.Bitmap;
using Font = SwinGame.Font;
using FontStyle = SwinGame.FontStyle;
using Event = SwinGame.Event;
using CollisionSide = SwinGame.CollisionSide;
using Sprite = SwinGame.Sprite;

using GameResources;

namespace GameProject
{
    public static class Controller
    {
        public static void UpdatePlayer(ref Character thePlayer, Map theMap)
        {
            if (Input.IsKeyPressed(SwinGame.Keys.VK_UP))
            {
                Characters.MoveCharacter(thePlayer, theMap, 0, -1);
            }
            else if (Input.IsKeyPressed(SwinGame.Keys.VK_DOWN))
            {
                Characters.MoveCharacter(thePlayer, theMap, 0, 1);
            }
            else if (Input.IsKeyPressed(SwinGame.Keys.VK_LEFT))
            {
                Characters.MoveCharacter(thePlayer, theMap, -1, 0);
            }
            else if (Input.IsKeyPressed(SwinGame.Keys.VK_RIGHT))
            {
                Characters.MoveCharacter(thePlayer, theMap, 1, 0);
            }
            else
            {
                Characters.MoveCharacter(thePlayer, theMap, 0, 0);
            }

            Characters.UpdateCharacterAnimation(ref thePlayer);
        }
    }
}