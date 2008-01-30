using System;
using System.Collections.Generic;
using System.Text;
using Color = System.Drawing.Color;
using Rectangle = System.Drawing.Rectangle;
using SwinGame;
using Graphics = SwinGame.Graphics;

namespace Tests
{
    class PhysicsTests : IGameTestLoader
    {
        #region IGameTestLoader Members

        public void AddTo(List<TestSuite> list)
        {
            TestSuite result = new TestSuite("Physics Tests");
            result.Add(new CollisionSpriteTest());
            result.Add(new CollissionBitmapTest());
			result.Add(new CircleCollissionTest());
            result.Add(new CircleCollissionTest2());
            result.Add(new RectangleCollissionTest());
				result.Add(new VectorAngle());
				result.Add(new PointOutOfRect());				

            list.Add(result);
        }

        #endregion

        private class RectangleCollissionTest : TestSet
        {
            private readonly static string METHS =
                "RectangleHasCollidedWithLine";

            private readonly static string INST =
                "Arrow keys to move the rectangle" + Environment.NewLine + "of  around" + Environment.NewLine;


            private SwinGame.Sprite ball = Graphics.CreateSprite(GameResources.GameImage("SmallBall"));
            private SwinGame.Sprite bigball = Graphics.CreateSprite(GameResources.GameImage("BallImage1"));

            private static SwinGame.Bitmap draw = SwinGame.Graphics.CreateBitmap(300, 32);

            public RectangleCollissionTest()
                : base(METHS, INST)
            {


            }


            private int X = 0;
            private int Y = 0;

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                if (Input.IsKeyPressed(Keys.VK_LEFT))
                {
                    X = X - 1;
                }
                if (Input.IsKeyPressed(Keys.VK_RIGHT))
                {
                    X = X + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_DOWN))
                {
                    Y = Y + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_UP))
                {
                    Y = Y - 1;
                }
                //RectangleHasCollidedWithLine
                if (Physics.RectangleHasCollidedWithLine(Shapes.CreateRectangle(X,Y, 50,50), Shapes.CreateLine(100, 0, 100, 418)))
                {
                    Graphics.FillRectangle(Color.Red, 98, 0, 5, 418);
                }
                if (Physics.RectangleHasCollidedWithLine(Shapes.CreateRectangle(X, Y, 50, 50), Shapes.CreateLine(200, 0, 200, 418)))
                {
                    Graphics.FillRectangle(Color.Red, 198, 0, 5, 418);
                }
                Graphics.DrawRectangle(Color.White, Shapes.CreateRectangle(X, Y, 50, 50));
                Graphics.DrawLine(Color.Yellow, Shapes.CreateLine(100, 0, 100, 418));
                Graphics.DrawLine(Color.Yellow, Shapes.CreateLine(200, 0, 200, 418));
            }
        }


        private class CircleCollissionTest2 : TestSet
        {
            private readonly static string METHS =
                "CircularCollision";

            private readonly static string INST =
                "Arrow keys to change the vector" + Environment.NewLine + "of  the big ball" + Environment.NewLine +
                "AWSD keys to change the vector" + Environment.NewLine + "of  the small ball";


            private SwinGame.Sprite ball = Graphics.CreateSprite(GameResources.GameImage("SmallBall"));
            private SwinGame.Sprite bigball = Graphics.CreateSprite(GameResources.GameImage("BallImage1"));

            private static SwinGame.Bitmap draw = SwinGame.Graphics.CreateBitmap(300, 32);

            public CircleCollissionTest2()
                : base(METHS, INST)
            {
                ball.Movement.X = 1;
                ball.Movement.Y = 1;
                ball.Mass = 1;
                ball.X = 150;
                ball.Y = 150;
                bigball.Movement.X = 1;
                bigball.Movement.Y = 1;
                bigball.Mass = 5;
                bigball.X = 155;
                bigball.Y = 155;
            }


            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                if (Input.IsKeyPressed(Keys.VK_DOWN))
                {
                    if (Physics.Magnitude(bigball.Movement) > 2)
                    {
                        bigball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(bigball.Movement), Physics.Magnitude(bigball.Movement) - 1));
                    }
                }
                if (Input.IsKeyPressed(Keys.VK_UP))
                {
                    bigball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(bigball.Movement), Physics.Magnitude(bigball.Movement) + 1));
                }
                if (Input.IsKeyPressed(Keys.VK_LEFT))
                {
                    bigball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(-1), bigball.Movement));
                }
                if (Input.IsKeyPressed(Keys.VK_RIGHT))
                {
                    bigball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(1), bigball.Movement));
                }

                if (Input.IsKeyPressed(Keys.VK_S))
                {
                    if (Physics.Magnitude(ball.Movement) > 2)
                    {
                        ball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(ball.Movement), Physics.Magnitude(ball.Movement) - 1));
                    }
                }
                if (Input.IsKeyPressed(Keys.VK_W))
                {
                    ball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(ball.Movement), Physics.Magnitude(ball.Movement) + 1));
                }
                if (Input.IsKeyPressed(Keys.VK_A))
                {
                    ball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(-1), ball.Movement));
                }
                if (Input.IsKeyPressed(Keys.VK_D))
                {
                    ball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(1), ball.Movement));
                }
                if (Input.WasKeyTyped(Keys.VK_SPACE))
                {
                    if (Physics.HaveSpritesCollided(ball, bigball))
                    {
                        Physics.CircularCollision(ball, bigball);
                        Graphics.UpdateSprite(ball);
                        Graphics.UpdateSprite(bigball);
                    }
                    else
                    {
                        ball.X = 150;
                        ball.Y = 150;
                        bigball.X = 155;
                        bigball.Y = 155;
                    }
                }

                Graphics.DrawSprite(bigball);
                Graphics.DrawSprite(ball);
                float tempX = ball.X + (Graphics.CurrentWidth(ball) / 2);
                float tempY = ball.Y + (Graphics.CurrentHeight(ball) / 2);
                float bigtempX = bigball.X + (Graphics.CurrentWidth(bigball) / 2);
                float bigtempY = bigball.Y + (Graphics.CurrentHeight(bigball) / 2);
                Graphics.DrawLine(Color.RoyalBlue, tempX, tempY, tempX + ball.Movement.X, tempY + ball.Movement.Y);
                Graphics.DrawLine(Color.RoyalBlue, bigtempX, bigtempY, bigtempX + bigball.Movement.X, bigtempY + bigball.Movement.Y);
                //Graphics.DrawRectangle(Color.White, ball.X, ball.Y, Graphics.CurrentWidth(ball), Graphics.CurrentHeight(ball));
            }
        }


        private class CircleCollissionTest : TestSet
        {
            private readonly static string METHS =
                "HaveBitmapsCollided, CircleHasCollidedWithLine, GetUnitVector, RotationMatrix...";

            private readonly static string INST =
                "Arrow keys to move the sprite " + Environment.NewLine + "around" +Environment.NewLine+
                "AWSD keys to change the vector " + Environment.NewLine;


            private SwinGame.Sprite ball = Graphics.CreateSprite(GameResources.GameImage("SmallBall"));
            private SwinGame.Bitmap mediumball = GameResources.GameImage("BallImage1");

            private static SwinGame.Bitmap draw = SwinGame.Graphics.CreateBitmap(300, 32);

            public CircleCollissionTest() : base(METHS, INST) 
            {
                ball.Movement.X = 1;
                ball.Movement.Y = 1;
            }

            private int X = 0;
            private int Y = 0;

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                if (Input.IsKeyPressed(Keys.VK_LEFT))
                {
                    ball.X = ball.X - 1;
                }
                if (Input.IsKeyPressed(Keys.VK_RIGHT))
                {
                    ball.X = ball.X + 1;
                }

                if (Input.IsKeyPressed(Keys.VK_S))
                {
                    if (Physics.Magnitude(ball.Movement) > 2)
                    {
                        ball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(ball.Movement), Physics.Magnitude(ball.Movement) - 1));
                    }
                }
                if (Input.IsKeyPressed(Keys.VK_DOWN))
                {
                    ball.Y = ball.Y + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_UP))
                {
                    ball.Y = ball.Y - 1;
                }

                if (Input.IsKeyPressed(Keys.VK_W))
                {
                    ball.Movement.SetTo(Physics.MultiplyVector(Physics.GetUnitVector(ball.Movement), Physics.Magnitude(ball.Movement) + 1));
                }
                if (Input.IsKeyPressed(Keys.VK_A))
                {
                    ball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(1),ball.Movement));
                }
                if (Input.IsKeyPressed(Keys.VK_D))
                {
                    ball.Movement.SetTo(Physics.Multiply(Physics.RotationMatrix(-1),ball.Movement));
                }
                //CircleHasCollidedWithLine
                if (Physics.CircleHasCollidedWithLine(ball, Shapes.CreateLine(300, 0, 300, 418)))
                {
                    Graphics.FillRectangle(Color.LightCyan, 298, 0, 5, 418);
                }
                Graphics.DrawVerticalLine(Color.Red, 300, 0, 418);

                //CircleHasCollidedWithLine
                if (Physics.CircleHasCollidedWithLine(ball, Shapes.CreateLine(300, 0, 300, 418)) && Input.IsKeyPressed(Keys.VK_SPACE))
                {
                    Physics.CircleCollisionWithLine(ball, Shapes.CreateLine(300, 0, 300, 418));
                    Graphics.UpdateSprite(ball);
                }
                

                Graphics.DrawSprite(ball);
                float tempX = ball.X + (Graphics.CurrentWidth(ball) /2);
                float tempY = ball.Y + (Graphics.CurrentHeight(ball) / 2);
                Graphics.DrawLine(Color.RoyalBlue, tempX, tempY, tempX + ball.Movement.X, tempY + ball.Movement.Y);
                Graphics.DrawRectangle(Color.White, ball.X, ball.Y, Graphics.CurrentWidth(ball), Graphics.CurrentHeight(ball));
            }
        }


        private class CollissionBitmapTest : TestSet
        {
            private readonly static string METHS =
                "HaveBitmapsCollided, HasBitmapCollidedWithRect";

            private readonly static string INST =
                "Arrow keys to move the bitmap " + Environment.NewLine + "around";

            private SwinGame.Bitmap smallball = GameResources.GameImage("SmallBall");
            private SwinGame.Bitmap mediumball = GameResources.GameImage("BallImage1");

            private static SwinGame.Bitmap draw = SwinGame.Graphics.CreateBitmap(300, 32);

            public CollissionBitmapTest() : base(METHS, INST) { }

            private int X = 0;
            private int Y = 0;

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                if (Input.IsKeyPressed(Keys.VK_LEFT))
                {
                    X = X - 1;
                }
                if (Input.IsKeyPressed(Keys.VK_RIGHT))
                {
                    X = X + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_DOWN))
                {
                    Y = Y + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_UP))
                {
                    Y = Y - 1;
                }
                //HaveBitmapsCollided
                Text.DrawText("All Bound", Color.White, GameResources.GameFont("Courier"), 10, 5);
                if (Physics.HaveBitmapsCollided(mediumball, 10, 30, smallball, X, Y))
                {
                    Graphics.FillRectangle(Color.Pink, 5, 25, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 10, 30);
                
                Graphics.DrawRectangle(Color.White, 10, 30, mediumball.Width, mediumball.Height);

                if (Physics.HaveBitmapsCollided(mediumball, Shapes.CreatePoint(10, 150), smallball, Shapes.CreatePoint(X, Y)))
                {
                    Graphics.FillRectangle(Color.Pink, 5, 145, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 10, 150);
                Graphics.DrawRectangle(Color.White, 10, 150, mediumball.Width, mediumball.Height);

                if (Physics.HaveBitmapsCollided(mediumball, Shapes.CreatePoint(10, 270), Shapes.CreateRectangle(mediumball), smallball, Shapes.CreatePoint(X, Y), Shapes.CreateRectangle(smallball)))
                {
                    Graphics.FillRectangle(Color.Pink, 5, 265, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 10, 270);
                Graphics.DrawRectangle(Color.White, 10, 270, mediumball.Width, mediumball.Height);



                Text.DrawText("No Bound", Color.White, GameResources.GameFont("Courier"), 120, 5);
                if (Physics.HaveBitmapsCollided(mediumball, 120, 30, false, smallball, X, Y, false))
                {
                    Graphics.FillRectangle(Color.Blue, 115, 25,  mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 120, 30);
                Graphics.DrawRectangle(Color.White, 120, 30, mediumball.Width, mediumball.Height);

                if (Physics.HaveBitmapsCollided(mediumball, Shapes.CreatePoint(120, 150),false, smallball, Shapes.CreatePoint(X, Y), false))
                {
                    Graphics.FillRectangle(Color.Blue, 115, 145, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 120, 150);
                Graphics.DrawRectangle(Color.White, 120, 150, mediumball.Width, mediumball.Height);

                if (Physics.HaveBitmapsCollided(mediumball, Shapes.CreatePoint(120, 270),Shapes.CreateRectangle(mediumball), false, smallball, Shapes.CreatePoint(X, Y),  Shapes.CreateRectangle(smallball),false))
                {
                    Graphics.FillRectangle(Color.Blue, 115, 265, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 120, 270);
                Graphics.DrawRectangle(Color.White, 120, 270, mediumball.Width, mediumball.Height);




                Text.DrawText("Big ball Bound", Color.White, GameResources.GameFont("Courier"), 240, 5);
                if (Physics.HaveBitmapsCollided(mediumball, 240, 30, true, smallball, X, Y, false))
                {
                    Graphics.FillRectangle(Color.Blue, 235, 25, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 240, 30);
                Graphics.DrawRectangle(Color.White, 240, 30, mediumball.Width, mediumball.Height);

                Text.DrawText("small ball Bound", Color.White, GameResources.GameFont("Courier"), 240, 150);
                if (Physics.HaveBitmapsCollided(mediumball, Shapes.CreatePoint(240, 170), false, smallball, Shapes.CreatePoint(X, Y), true))
                {
                    Graphics.FillRectangle(Color.Blue, 235, 165, mediumball.Height + 10, mediumball.Width + 10);
                }
                Graphics.DrawBitmap(mediumball, 240, 170);
                Graphics.DrawRectangle(Color.White, 240, 170, mediumball.Width, mediumball.Height);

                //HasBitmapCollidedWithRect
                Graphics.DrawRectangle(Color.DarkGreen, 400, 350, 10, 10);
                if (Physics.HasBitmapCollidedWithRect(smallball, X, Y, 400, 350, 10, 10))
                {
                    Graphics.FillRectangle(Color.LightGreen, 400, 350, 10, 10);
                }

                Graphics.DrawRectangle(Color.DarkGreen, 400, 365, 10, 10);
                if (Physics.HasBitmapCollidedWithRect(smallball, X, Y, Shapes.CreateRectangle(400, 365, 10, 10)))
                {
                    Graphics.FillRectangle(Color.LightGreen, 400, 365, 10, 10);
                }




                Graphics.DrawBitmap(smallball,X,Y);
                Graphics.DrawRectangle(Color.White, X, Y, smallball.Width, smallball.Height);
            }
        }


        private class CollisionSpriteTest : TestSet
        {
            private readonly static string METHS =
                "HasSpriteCollidedWith..., HaveSpritesCollided";

            private readonly static string INST =
                "Arrow keys to move the sprite "+ Environment.NewLine +"around"+ Environment.NewLine +
                "Pink for bounded collissions"+ Environment.NewLine +
                "Blue for non bounded collissions";

            private Sprite ship = Graphics.CreateSprite(GameResources.GameImage("Ship"),1,2,40,43);

            private Sprite explosion = Graphics.CreateSprite(/*GameResources.GameImage("Explosion")*/Graphics.LoadBitmap(Core.GetPathToResource("explosion_blue.jpg", ResourceKind.ImageResource), true, Color.Black), 20, 40, 72, 72);
            

            private SwinGame.Bitmap smallball = GameResources.GameImage("SmallBall");

            private static SwinGame.Bitmap draw = SwinGame.Graphics.CreateBitmap(300, 32);

            public CollisionSpriteTest() : base(METHS, INST) { }

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                //Graphics.ClearScreen(Color.White);
                //ship.Movement.SetTo(Physics.CreateVector(1,1));
                Graphics.UpdateSpriteAnimation(ship);
                ship.UsePixelCollision = true;
                //Text.DrawText(ship.Movement.X + ", " + ship.Movement.Y, Color.White, GameResources.GameFont("Courier"), 10, 200);
                
                if (Input.IsKeyPressed(Keys.VK_LEFT))
                {
                    ship.X = ship.X - 1;
                }
                if (Input.IsKeyPressed(Keys.VK_RIGHT))
                {
                    ship.X = ship.X + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_DOWN))
                {
                    ship.Y = ship.Y + 1;
                }
                if (Input.IsKeyPressed(Keys.VK_UP))
                {
                    ship.Y = ship.Y - 1;
                }

                //HasSpriteCollidedX
                Graphics.DrawVerticalLine(Color.Red, 400, 0, 418);
                if (Physics.HasSpriteCollidedX(ship, 400, CollisionDetectionRange.CollisionRangeEquals))
                {
                    Graphics.DrawRectangle(Color.White, 395, 405, 10, 10);
                }
                if (Physics.HasSpriteCollidedX(ship, 400, CollisionDetectionRange.CollisionRangeGreaterThan))
                {
                    Graphics.DrawRectangle(Color.White, 407, 405, 10, 10);
                }
                if (Physics.HasSpriteCollidedX(ship, 400, CollisionDetectionRange.CollisionRangeLessThan))
                {
                    Graphics.DrawRectangle(Color.White, 383, 405, 10, 10);
                }

                //HasSpriteCollidedY
                Graphics.DrawHorizontalLine(Color.LightBlue, 400, 0, 418);
                if (Physics.HasSpriteCollidedY(ship, 400, CollisionDetectionRange.CollisionRangeEquals))
                {
                    Graphics.DrawRectangle(Color.White, 10, 395, 10, 10);
                }
                if (Physics.HasSpriteCollidedY(ship, 400, CollisionDetectionRange.CollisionRangeGreaterThan))
                {
                    Graphics.DrawRectangle(Color.White, 10, 407, 10, 10);
                }
                if (Physics.HasSpriteCollidedY(ship, 400, CollisionDetectionRange.CollisionRangeLessThan))
                {
                    Graphics.DrawRectangle(Color.White, 10, 383, 10, 10);
                }

                //HasSpriteCollidedWithRect
                
                Graphics.DrawRectangle(Color.DarkGreen, 10, 10, 10, 10);
                if (Physics.HasSpriteCollidedWithRect(ship, 10, 10, 10, 10))
                {
                    Graphics.FillRectangle(Color.LightGreen, 10, 10, 10, 10);
                }

                Graphics.DrawRectangle(Color.DarkGreen, 10, 25, 10, 10);
                if (Physics.HasSpriteCollidedWithRect(ship, Shapes.CreateRectangle(10, 25, 10, 10)))
                {
                    Graphics.FillRectangle(Color.LightGreen, 10, 25, 10, 10);
                }

                //HaveSpritesCollided
                explosion.UsePixelCollision = true;

                explosion.X = 70;
                explosion.Y = 10;
                Graphics.UpdateSpriteAnimation(explosion);
                //Graphics.FillRectangle(Color.White, 64, 4, 45, 45);
                if (Physics.HaveSpritesCollided(ship, explosion))
                {
                    Graphics.DrawRectangle(Color.Blue, 65, 5, 78, 78);
                    Graphics.DrawRectangle(Color.Blue, 64, 4, 80, 80);
                }
                Graphics.DrawSprite(explosion);

                //HasSpriteCollidedWithBitmap
                if (Physics.HasSpriteCollidedWithBitmap(ship, smallball, 10,100))
                {
                    Graphics.DrawRectangle(Color.Pink, true, 5, 95, smallball.Width + 10, smallball.Height + 10);
                }
                Graphics.DrawBitmap(smallball, 10, 100);
                Graphics.DrawRectangle(Color.White, 10, 100, smallball.Width, smallball.Height);

                if (Physics.HasSpriteCollidedWithBitmap(ship, smallball, 10, 150, false))
                {
                    Graphics.DrawRectangle(Color.Blue, true, 5, 145, smallball.Width + 10, smallball.Height + 10);
                }
                Graphics.DrawBitmap(smallball, 10, 150);
                Graphics.DrawRectangle(Color.White, 10, 150, smallball.Width, smallball.Height);
                //using points
                if (Physics.HasSpriteCollidedWithBitmap(ship, smallball, Shapes.CreatePoint(70,100),Shapes.CreateRectangle(smallball), false))
                {
                    Graphics.DrawRectangle(Color.Blue, true, 65, 95, smallball.Width + 10, smallball.Height + 10);
                }
                Graphics.DrawBitmap(smallball, 70, 100);
                Graphics.DrawRectangle(Color.White, 70, 100, smallball.Width, smallball.Height);

                if (Physics.HasSpriteCollidedWithBitmap(ship, smallball, Shapes.CreatePoint(70, 150), false))
                {
                    Graphics.DrawRectangle(Color.Blue, true, 65, 145, smallball.Width + 10, smallball.Height + 10);
                }
                Graphics.DrawBitmap(smallball, 70, 150);
                Graphics.DrawRectangle(Color.White, 70, 150, smallball.Width, smallball.Height);


                Graphics.DrawSprite(ship);
                Graphics.DrawRectangle(Color.White, ship.X, ship.Y, Graphics.CurrentWidth(ship), Graphics.CurrentHeight(ship));
            }
        }

			private class VectorAngle : TestSet
			{
				private readonly static int CX = 209;
				private readonly static int CY = 209;
				private readonly static int RADIUS = 20;
				private readonly static int LINE_LENGTH = 100;
				
				private Vector v1, v2;
				
            private readonly static string METHS =
                "CalculateAngle, Matrix Multiply, Rotation Matrix";

            private readonly static string INST =
                "Left/Right controls White" + Environment.NewLine +
					 "Up/Down controls Red" + Environment.NewLine +
                "Space moved red over white" + Environment.NewLine +
                "Blue for non bounded collissions";

            public VectorAngle() : base(METHS, INST) 
				{
					v1 = Physics.CreateVector(LINE_LENGTH, 0);
					v2 = Physics.CreateVector(0 , LINE_LENGTH); 
				}

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
                Graphics.FillCircle(Color.Red, CX, CY, RADIUS);
                Graphics.DrawLine(Color.Red, CX, CY, CX + v1.X, CY + v1.Y);
					 Graphics.DrawLine(Color.White, CX, CY, CX + v2.X, CY + v2.Y);
					
 					 float angle = Physics.CalculateAngleBetween(v1, v2);
					 float v1a = Physics.CalculateAngle(0, 0, v1.X, v1.Y);
					 float v2a = Physics.CalculateAngle(0, 0, v2.X, v2.Y);
					 
					 Text.DrawText("White: " + v2a, Color.White, GameResources.GameFont("Courier"), 5, 50);
					 Text.DrawText("Red: " + v1a, Color.Red, GameResources.GameFont("Courier"), 5, 70);
					 Text.DrawText("Between: " + angle, Color.White, GameResources.GameFont("Courier"), 5, 90);
					
					 float rot = 0;
					 Matrix2D rm = null;

					 if (Input.IsKeyPressed(Keys.VK_LEFT)) rot = 5;
					 else if (Input.IsKeyPressed(Keys.VK_RIGHT)) rot = -5;

					 if (rot != 0)
					 {
						rm = Physics.RotationMatrix(rot);
						v2 = Physics.Multiply(rm, v2);
					 }

					 rot = 0;

					 if (Input.IsKeyPressed(Keys.VK_UP)) rot = 5;
					 else if (Input.IsKeyPressed(Keys.VK_DOWN)) rot = -5;

					 if (rot != 0)
					 {
						rm = Physics.RotationMatrix(rot);
						v1 = Physics.Multiply(rm, v1);
					 }

					 if (Input.WasKeyTyped(Keys.VK_SPACE))
					 {
						rm = Physics.RotationMatrix(angle);
						v1 = Physics.Multiply(rm, v1);
					 }
				}				
			}

			private class PointOutOfRect : TestSet
			{
				private readonly static int RW = 100;
				private readonly static int RH = 100;
				private readonly static int RX = 159;
				private readonly static int RY = 159;
				private readonly static int LINE_LENGTH = 100;
				
				private Point2D p;
				private Rectangle rect;
				private Vector movement, mvOut;
				
            private readonly static string METHS =
                "VectorOutOfRectFromPoint";

            private readonly static string INST =
                "Arrows move point" + Environment.NewLine +
					 "A/Z rotate movement" + Environment.NewLine +
                "Space move point out";

            public PointOutOfRect() : base(METHS, INST) 
				{
					p = Shapes.CreatePoint(100 / 2 + RX, 100 / 2 + RY);
					rect = Shapes.CreateRectangle(RX, RY, RW, RH);

					movement = Physics.CreateVector(100, 0);
				}

            protected override void ToRun(System.Drawing.Rectangle toDrawIn)
            {
					int r = 1, r2 = 2;
					
					if ( Input.IsKeyPressed(Keys.VK_A)) movement = Physics.Multiply(Physics.RotationMatrix(-4.0f), movement);
					if ( Input.IsKeyPressed(Keys.VK_Z)) movement = Physics.Multiply(Physics.RotationMatrix(4.0f), movement);

					if ( Input.IsKeyPressed(Keys.VK_UP)) p.Y = p.Y - 5;
					if ( Input.IsKeyPressed(Keys.VK_DOWN)) p.Y = p.Y + 5;
					if ( Input.IsKeyPressed(Keys.VK_LEFT)) p.X = p.X - 5;
					if ( Input.IsKeyPressed(Keys.VK_RIGHT)) p.X = p.X + 5;

					mvOut = Physics.VectorOutOfRectFromPoint(p, rect, movement);
					
					if ( Input.IsKeyPressed(Keys.VK_SPACE))
					{
						p.Y += mvOut.Y;
						p.X += mvOut.X;
						mvOut = Physics.CreateVector(0, 0);
					}

					Graphics.ClearScreen(Color.Black);

					Graphics.DrawRectangle(Color.Red, RX, RY, RW, RH);			
					Graphics.DrawRectangle(Color.White, p.X - r, p.Y - r, r2, r2);
					Graphics.DrawLine(Color.White, p.X, p.Y, p.X + movement.X, p.Y + movement.Y);

					if (false == ((mvOut.X == 0) && (mvOut.Y == 0)))
					{
						Graphics.DrawLine(Color.Green, p.X, p.Y, p.X + mvOut.X, p.Y + mvOut.Y);
					}

				}
				
			}
    }
}
