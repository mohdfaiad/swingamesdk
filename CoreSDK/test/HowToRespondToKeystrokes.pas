program HowToKeyboardInput;
uses
  sgInput, sgGraphics, sgResources, sgText, sgTypes, sgUtils, sgAudio;
  
procedure Main();
var
  clr: Color;  
begin  
  OpenGraphicsWindow('Keyboard Input', 240, 180);    
  
  clr := RGBAColor(255, 255, 255, 64);
  ClearScreen(ColorWhite);
  repeat // The game loop...
    ProcessEvents();
    
    FillRectangle(clr, 0, 0, 240, 180);
    
    if KeyReleased(vk_a) then 
    begin
      DrawText('A Release', ColorBlue, 'Arial', 14, 20, 40);      
    end;
    if KeyTyped(vk_a) then 
    begin
      DrawText('A Typed', ColorGreen, 'Arial', 14, 20, 70);      
    end;    
    
    if KeyDown(vk_a) then
    begin
      DrawText('A Down', ColorRed, 'Arial', 14, 20, 100);      
    end;
    
    if KeyUp(vk_a) then 
    begin
      DrawText('A Up', ColorTurquoise, 'Arial', 14, 20, 130);      
    end;
    
    DrawText('KeyBoard Input', ColorRed, 'Arial', 18, 60, 15);
    
    RefreshScreen(60);    
  until WindowCloseRequested() OR KeyTyped(vk_ESCAPE) OR KeyTyped(VK_Q);  
  
  ReleaseAllResources();
end;

begin
  Main();
end.