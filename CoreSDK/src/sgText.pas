//=============================================================================
// sgText.pas
//=============================================================================
//
// The Font unit relates to writing text to the screen,
// and to loading and styling the associated fonts.
//
// Change History:
//
// Version 3.0:
// - 2010-03-18: Andtew : Altered font loading to provide mappings for all fonts.
// - 2010-02-02: Andrew : Added string to FontAlignment
// - 2009-12-07: Andrew : Added font loading and freeing code..
// - 2009-06-05: Andrew : Using sgShared
//
// Version 2.0:
// - 2009-07-14: Andrew : Removed loading and freeing code.
// - 2009-01-05: Andrew : Added Unicode rendering
// - 2008-12-17: Andrew : Moved all integers to LongInt
// - 2008-12-12: Andrew : Added simple string printing
// - 2008-12-10: Andrew : Fixed printing of string
//
// Version 1.1:
// - 2008-03-09: Andrew : Added extra exception handling
// - 2008-01-30: Andrew : Fixed Print strings for EOL as last char
// - 2008-01-25: Andrew : Fixed compiler hints
// - 2008-01-21: Andrew : Added Point/Rectangle overloads
// - 2008-01-17: Aki + Andrew: Refactor
//
// Version 1.0:
// - Various
//=============================================================================

/// Supports the presentation (drawing) of text to screen using loaded `Font`s 
/// to style the text. Load a different ``Font`` for each unique text 
/// presentation style (colour and size) you need in your game.
///
///@module Text
///@static
unit sgText;

//=============================================================================
interface
  uses sgTypes;
//=============================================================================


//----------------------------------------------------------------------------
// Font mapping routines
//----------------------------------------------------------------------------
  
  /// Loads a font from file with the specified side. Fonts must be freed using
  /// the FreeFont routine once finished with. Once the font is loaded you
  /// can set its style using SetFontStyle. Fonts are then used to draw and
  /// measure text in your programs.
  /// 
  /// @lib
  /// @sn loadFontFile:%s size:%s
  ///
  /// @class Font
  /// @constructor
  /// @csn initWithFontName:%s andSize:%s
  function LoadFont(fontName: String; size: LongInt): Font;
  
  /// Frees the resources used by the loaded Font.
  /// 
  /// @lib
  ///
  /// @class Font
  /// @dispose
  procedure FreeFont(var fontToFree: Font);
  
  /// Loads and returns a font that can be used to draw text. The supplied
  /// ``filename`` is used to locate the font to load. The supplied ``name`` indicates the 
  /// name to use to refer to this Font in SwinGame. The `Font` can then be
  /// retrieved by passing this ``name`` to the `FontNamed` function.
  ///
  /// @lib
  /// @sn loadFontNamed:%s fromFile:%s size:%s
  ///
  /// @class Font
  /// @constructor
  /// @csn initWithName:%s fromFile:%s size:%s
  function LoadFontNamed(name, filename: String; size: LongInt): Font;
  
  /// Determines if SwinGame has a font loaded for the supplied name.
  /// This checks against all fonts loaded, those loaded without a name
  /// are assigned the filename as a default.
  /// 
  /// @lib
  function HasFont(name: String): Boolean;
  
  /// Determines the name that will be used for a font loaded with
  /// the indicated fontName and size.
  /// 
  /// @lib
  /// @sn fontName:%s size:%s
  function FontNameFor(fontName: String; size: LongInt): String;
  
  /// Returns the `Font` that has been loaded with the specified name,
  /// and font size using `LoadFont`.
  ///
  /// @lib FontNamedWithSize
  /// @sn fontNamed:%s withSize:%s
  function FontNamed(name: String; size: LongInt): Font; overload;
  
  /// Returns the `Font` that has been loaded with the specified name,
  /// see `LoadFontNamed`.
  ///
  /// @lib
  function FontNamed(name: String): Font; overload;
  
  /// Releases the SwinGame resources associated with the font of the
  /// specified ``name``.
  ///
  /// @lib
  procedure ReleaseFont(name: String);
  
  /// Releases all of the fonts that have been loaded.
  ///
  /// @lib
  procedure ReleaseAllFonts();
  
  
  //---------------------------------------------------------------------------
  // Font properties
  //---------------------------------------------------------------------------
  
  /// Alters the style of the font.
  ///
  /// @lib
  /// @sn font:%s setStyle:%s
  /// 
  /// @class Font
  /// @setter FontStyle
  procedure FontSetStyle(font: Font; value: FontStyle);
  
  /// Returns the style settings for the font.
  ///
  /// @lib
  ///
  /// @class Font
  /// @getter FontStyle
  function FontFontStyle(font: Font): FontStyle;
  
  /// Returns the width (in pixels) of the passed in text and the font it will be drawn with.
  ///
  /// @lib
  /// @sn font:%s widthOf:%s
  ///
  /// @class Font
  /// @method TextWidth
  function TextWidth(theFont: Font; theText: String): LongInt; overload;

  /// Returns the height (in pixels) of the passed in text and the font it will be drawn with.
  ///
  /// @lib
  /// @sn font:%s heightOf:%s
  ///
  /// @class Font
  /// @method TextHeight
  function TextHeight(theFont: Font; theText: String): LongInt; overload;

{  
  function TextWidth(theText: WideString; theFont: Font): LongInt; overload;
  function TextHeight(theText: WideString; theFont: Font): LongInt; overload;
}  

  /// Returns the font alignment for the passed in character (l = left. r = right, c = center).
  /// 
  /// @lib
  function TextAlignmentFrom(str: String): FontAlignment;
  
  
  //---------------------------------------------------------------------------
  // Draw Text - using font
  //---------------------------------------------------------------------------
  
  /// Draws theText onto the screen at the specified x,y location using the color and font indicated.
  /// As the text is draw directly onto the screen the camera location does not effect its position.
  /// This is useful for drawing text on a HUD or similar actions.
  ///
  /// This version only draws a single line of text, to draw text that contains line breaks use the
  /// `DrawTextLinesOnScreen` procedure.
  ///
  /// @lib
  /// @sn drawText:%s color:%s font:%s onScreenAtX:%s y:%s
  procedure DrawTextOnScreen(theText: String; textColor: Color; theFont: Font; x, y: LongInt); overload;
    
  /// Draws theText onto the screen at the specified point using the color and font indicated.
  /// As the text is draw directly onto the screen the camera location does not effect its position.
  /// This is useful for drawing text on a HUD or similar actions.
  ///
  /// This version only draws a single line of text, to draw text that contains line breaks use the
  /// `DrawTextLinesOnScreen` procedure.
  ///
  /// @lib DrawTextOnScreenAtPoint
  /// @sn drawText:%s color:%s font:%s onScreenAtPt:%s
  procedure DrawTextOnScreen(theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
    
  /// Draws theText at the specified point using the color and font indicated.
  ///
  /// This version only draws a single line of text, to draw text that contains line breaks use the
  /// `DrawTextLines` procedure.
  ///
  /// @lib
  /// @sn drawText:%s color:%s font:%s x:%s y:%s
  procedure DrawText(theText: String; textColor: Color; theFont: Font; x, y: Single); overload;
  
  /// Draws theText at the specified point using the color and font indicated.
  ///
  /// This version only draws a single line of text, to draw text that contains line breaks use the
  /// `DrawTextLines` procedure.
  /// 
  /// @lib DrawTextAtPoint
  /// @sn drawText:%s color:%s font:%s pt:%s
  procedure DrawText(theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
    
  /// Draws theText onto the bitmap at the specified x,y location using the color and font indicated.
  ///
  /// This version only draws a single line of text, to draw text that contains line breaks use the
  /// `DrawTextLines` procedure.
  ///
  /// @lib DrawTextOnBitmap
  /// @sn bitmap:%s drawText:%s color:%s font:%s atX:%s y:%s
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; theFont: Font; x, y: LongInt); overload;
  
  /// Draws theText onto the bitmap at the specified point using the color and font indicated.
  ///
  /// @lib DrawTextOnBitmapAtPoint
  /// @sn bitmap:%s drawText:%s color:%s font:%s atPt:%s
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
  
{  procedure DrawUnicodeOnScreen(theText: WideString; textColor: Color; theFont: Font; x, y: LongInt); overload;
  procedure DrawUnicodeOnScreen(theText: WideString; textColor: Color; theFont: Font; const pt: Point2D); overload;
  procedure DrawUnicode(theText: WideString; textColor: Color; theFont: Font; x, y: Single); overload;
  procedure DrawUnicode(theText: WideString; textColor: Color; theFont: Font; const pt: Point2D); overload; }
  
  
  //---------------------------------------------------------------------------
  // Draw Text Lines
  //---------------------------------------------------------------------------
  
  /// Draws theText onto the screen at the specified x,y location using the fore and back colors, and the font indicated.
  /// As the text is draw directly onto the screen the camera location does not effect its position.
  /// This is useful for drawing text on a HUD or similar actions.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawTextOnScreen` procedure.
  ///
  /// @lib
  /// @sn drawTextLines:%s color:%s font:%s align:%s onScreenAtX:%s y:%s w:%s h:%s
  procedure DrawTextLinesOnScreen(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y, w, h: LongInt); overload;
  
  /// Draws theText at the specified x,y location using the fore and back colors, and the font indicated.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawText` procedure.
  ///
  /// @lib
  /// @sn drawTextLines:%s textColor:%s backColor:%s font:%s align:%s atX:%s y:%s w:%s h:%s
  procedure DrawTextLines(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y: Single; w, h: LongInt); overload;

  /// Draws theText onto the screen in the specified rectangle using the fore and back colors, and the font indicated.
  /// As the text is draw directly onto the screen the camera location does not effect its position.
  /// This is useful for drawing text on a HUD or similar actions.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawTextOnScreen` procedure.
  ///
  /// @lib DrawTextLinesInRectOnScreen
  /// @sn drawTextLines:%s color:%s font:%s align:%s onScreenInRect:%s
  procedure DrawTextLinesOnScreen(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;

  /// Draws theText in the specified rectangle using the fore and back colors, and the font indicated.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawTextOnScreen` procedure.
  ///
  /// @lib DrawTextLinesInRect
  /// @sn drawTextLines:%s color:%s font:%s align:%s inRect:%s
  procedure DrawTextLines(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;
  
  
  /// Draws theText onto the bitmap at the specified x,y location using the fore and back colors, and the font indicated.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawText` procedure.
  ///
  /// @lib DrawTextLinesOnBitmap
  /// @sn bitmap:%s drawTextLines:%s color:%s font:%s align:%s onScreenAtX:%s y:%s w:%s h:%s
  procedure DrawTextLines(dest: Bitmap; theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y, w, h: LongInt); overload;
  
  /// Draws theText onto the bitmap in the rectangle using the fore and back colors, and the font indicated.
  ///
  /// This version should be used to draw text that contains multiple lines, to draw a single line of text
  /// use the `DrawText` procedure.
  ///
  /// @lib DrawTextLinesInRectOnBitmap
  /// @sn bitmap:%s drawTextLines:%s color:%s font:%s align:%s in:%s
  procedure DrawTextLines(dest: Bitmap; theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;
  
  
  //---------------------------------------------------------------------------
  // Draw Text - without font
  //---------------------------------------------------------------------------
  
  /// Draws text using a simple bitmap font that is built into SwinGame.
  ///
  /// @lib DrawSimpleText
  /// @sn drawText:%s color:%s x:%s y:%s
  procedure DrawText(theText: String; textColor: Color; x, y: Single); overload;
  
  /// Draws text using a simple bitmap font that is built into SwinGame.
  ///
  /// @lib DrawSimpleTextPt
  /// @sn drawText:%s color:%s pt:%s
  procedure DrawText(theText: String; textColor: Color; const pt: Point2D); overload;
  
  /// Draws text using a simple bitmap font that is built into SwinGame.
  /// As the text is draw directly onto the screen the camera location does not effect its position.
  /// This is useful for drawing text on a HUD or similar actions.
  ///
  /// @lib DrawSimpleTextOnScreen
  /// @sn drawText:%s color:%s onScreenAtPt:%s
  procedure DrawTextOnScreen(theText: String; textColor: Color; x, y: Single); overload;
  
  /// Draws text using a simple bitmap font that is built into SwinGame.
  ///
  /// @lib DrawSimpleTextOnBitmap
  /// @sn bitmap:%s drawText:%s color:%s onScreenAtX:%s y:%s
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; x, y: Single); overload;
  
  
  /// @lib
  procedure DrawFramerate(x, y: LongInt; font: Font); overload;
  
  /// @lib DrawFrameRateWithSimpleFont
  procedure DrawFramerate(x, y: LongInt); overload;
  
  
//=============================================================================
implementation
  uses SysUtils, Classes, 
       stringhash,         // libsrc
       sgCore, sgGeometry, sgGraphics, sgCamera, sgShared, sgResources, sgImages,
       SDL, SDL_TTF, SDL_gfx;
//=============================================================================

  const EOL = LineEnding; // from sgShared

  var
    _Fonts: TStringHash;

//----------------------------------------------------------------------------
  
  function LoadFont(fontName: String; size: LongInt): Font;
  begin
    result := LoadFontNamed(FontNameFor(fontName, size), fontName, size);
  end;
  
  procedure FreeFont(var fontToFree: Font);
  begin
    if Assigned(fontToFree) then
    begin
      {$IFDEF TRACE}
        Trace('Resources', 'IN', 'FreeFont', 'After calling free notifier');
      {$ENDIF}
      try
        {$IFDEF TRACE}
            Trace('Resources', 'IN', 'FreeFont', 'Before calling close font');
        {$ENDIF}

        TTF_CloseFont(fontToFree);
        CallFreeNotifier(fontToFree);
        fontToFree := nil;
        {$IFDEF TRACE}
            Trace('Resources', 'IN', 'FreeFont', 'At end of free font');
        {$ENDIF}
      except
        RaiseException('Unable to free the specified font');
        exit;
      end;
    end;
  end;

//----------------------------------------------------------------------------

  function LoadFontNamed(name, filename: String; size: LongInt): Font;
  var
    obj: tResourceContainer;
    fnt: Font;
    
    function _DoLoadFont(fontName: String; size: LongInt): Font;
    var
      filename: String;
    begin
      filename := fontName;
      if not FileExists(filename) then
      begin
        filename := PathToResource(filename, FontResource);
        
        if not FileExists(filename) then
        begin
          RaiseException('Unable to locate font ' + fontName);
          exit;
        end;
      end;
      
      result := TTF_OpenFont(PChar(filename), size);
      
      if result = nil then
      begin
        RaiseException('LoadFont failed: ' + TTF_GetError());
        exit;
      end;
    end;
  begin
    
    if _Fonts.containsKey(name) then
    begin
      result := FontNamed(name);
      exit;
    end;
    
    fnt := _DoLoadFont(filename, size);
    obj := tResourceContainer.Create(fnt);
    if not _Fonts.setValue(name, obj) then raise Exception.create('Error loaded Font resource twice, ' + name);
    result := fnt;
  end;

  function HasFont(name: String): Boolean;
  begin
    result := _Fonts.containsKey(name);
  end;
  
  function FontNameFor(fontName: String; size: LongInt): String;
  begin
    result := fontName + '|' + IntToStr(size);
  end;
  
  function FontNamed(name: String; size: LongInt): Font;
  begin
    result := FontNamed(FontNameFor(name, size));
  end;
  
  function FontNamed(name: String): Font;
  var
    tmp : TObject;
  begin
    tmp := _Fonts.values[name];
    if assigned(tmp) then result := Font(tResourceContainer(tmp).Resource)
    else result := nil;
  end;

  procedure ReleaseFont(name: String);
  var
    fnt: Font;
  begin
    fnt := FontNamed(name);
    if (assigned(fnt)) then
    begin
      _Fonts.remove(name).free();
      FreeFont(fnt);
    end;
  end;

  procedure ReleaseAllFonts();
  begin
    ReleaseAll(_Fonts, @ReleaseFont);
  end;

  //----------------------------------------------------------------------------



  /// Sets the style of the passed in font. This is time consuming, so load
  /// fonts multiple times and set the style for each if needed.
  ///
  /// @param font:   The font to set the style of
  /// @param style:  The new style for the font, values can be read together
  ///
  /// Side Effects:
  /// - The font's style is changed
  procedure FontSetStyle(font: Font; value: FontStyle);
  begin
    if not Assigned(font) then begin RaiseException('No font supplied'); exit; end;
    TTF_SetFontStyle(font, LongInt(value));
  end;
  
  function FontFontStyle(font: Font): FontStyle;
  begin
    if not Assigned(font) then begin RaiseException('No font supplied'); exit; end;
    result := FontStyle(TTF_GetFontStyle(font));
  end;

  function IsSet(toCheck, checkFor: FontAlignment): Boolean; overload;
  begin
    result := (LongInt(toCheck) and LongInt(checkFor)) = LongInt(checkFor);
  end;
  
  /// This function prints "str" with font "font" and color "clrFg"
  ///  * onto a rectangle of color "clrBg".
  ///  * It does not pad the text.
  procedure PrintStrings(dest: PSDL_Surface; font: Font; str: String; rc: PSDL_Rect; clrFg, clrBg:Color; flags:FontAlignment);
  var
    sText: Bitmap;
    temp: PSDL_Surface;
    lineSkip, width, height: LongInt;
    lines: Array of String;
    subStr: String;
    n, w, h, i: LongInt;
    rect: TSDL_Rect;
    colorFG: TSDL_Color;
    bgTransparent: Boolean;
  begin
    if Length(str) = 0 then exit;
    if dest = nil then begin RaiseException('Error Printing Strings: There was no surface.'); exit; end;

    colorFG := ToSDLColor(clrFg);
    bgTransparent := TransparencyOf(clrBg) < 255;
    
    // If there's nothing to draw, return NULL
    if (Length(str) = 0) or (font = nil) then exit;

    // This is the surface that everything is printed to.
    lineSkip  := TTF_FontLineSkip( font );
    width    := rc^.w;
    height    := 10;
    SetLength(lines, 1);

    // Break the String into its lines:
    n := -1; i := 0;
    while n <> 0 do
    begin
      // Get until either "\n" or "\0":
      n := Pos(eol, str);

      //Copy all except EOL
      if n = 0 then subStr := str
      else if n = 1 then subStr := ' '
      else subStr := Copy(str, 1, n - 1);

      if Length(subStr) < 1 then subStr := ' ';

      //Remove the line from the original string
      if n <> 0 then
      begin
        str := Copy( str, n + Length(eol), Length(str)); //excess not copied...
      end;

      i := i + 1;
      SetLength(lines, i);
      lines[i - 1] := subStr;

      w := 0;
      // Get the size of the rendered text.
      if Length(subStr) > 0 then TTF_SizeText(font, PChar(subStr), w, height);
      
      if w > width then width := w;
    end;
    
    if (width = 0) or (height = 0) then exit;
    
    // Length(lines) = Number of Lines.
    // we assume that height is the same for all lines.
    height := (Length(lines) - 1) * lineSkip + height;

    sText := CreateBitmap(width, height);
    ClearSurface(sText, clrBg);

    // Actually render the text:
    for i := 0 to High(lines) do
    begin
      // The rendered text:
      if length(lines[i]) = 0 then continue;
      
      temp := TTF_RenderText_Blended(font, PChar(lines[i]), colorFG);
      //temp := TTF_RenderUNICODE_Blended(font, PUint16(lines[i]), colorFG);
      
      // Put it on the surface:
      if IsSet(flags, AlignLeft) or
         (not (IsSet(flags, AlignCenter) or
               IsSet(flags, AlignRight))) then
      begin
        // If it's specifically LEFT or none of the others:
        rect := NewSDLRect(0,i*lineSkip,0,0);
      end
      else if IsSet(flags, AlignCenter) then
      begin
        w := 0;
        h := 0;

        TTF_SizeText(font, PChar(lines[i]), w, h);
        rect := NewSDLRect(width div 2 - w div 2, i * lineSkip, 0, 0)
      end
      else if IsSet(flags, AlignRight) then
      begin
        // Get w and h from the size of the text...
        w := 0; h := 0;
        TTF_SizeText(font, PChar(lines[i]), w, h);
        rect := NewSDLRect(rc^.w - w, i * lineSkip, 0, 0);
      end
      else begin RaiseException('Invalid font alignment'); exit; end;

      // Render the current line. Ignore alpha in this draw
      if bgTransparent then SDL_SetAlpha(temp, 0, SDL_ALPHA_TRANSPARENT);
      SDL_BlitSurface(temp, nil, sText^.surface, @rect);

      // Clean up:
      SDL_FreeSurface(temp);
    end;

    // Draw the text on top of that:
    rect.x := 0; rect.y := 0; rect.w := rc^.w; rect.h := rc^.h;
    if (not bgTransparent) then SDL_SetAlpha(sText^.surface, 0, SDL_ALPHA_TRANSPARENT);  
    SDL_BlitSurface(sText^.surface, @rect, dest, rc );
    
    FreeBitmap(sText);
  end;

  /// This function prints "str" with font "font" and color "clrFg"
  ///  * onto a rectangle of color "clrBg".
  ///  * It does not pad the text.
  procedure PrintWideStrings(dest: PSDL_Surface; font: Font; str: WideString; rc: PSDL_Rect; clrFg, clrBg:Color; flags:FontAlignment);
  var
    sText: Bitmap;
    temp: PSDL_Surface;
    lineSkip, width, height: LongInt;
    lines: Array of String;
    subStr: String;
    n, w, h, i: LongInt;
    rect: TSDL_Rect;
    colorFG: TSDL_Color;
    bgTransparent: Boolean;
  begin
    if dest = nil then begin RaiseException('Error Printing Strings: There was no surface.'); exit; end;

    colorFG := ToSDLColor(clrFg);
    bgTransparent := TransparencyOf(clrBg) < 255;
    
    // If there's nothing to draw, return NULL
    if (Length(str) = 0) or (font = nil) then exit;

    // This is the surface that everything is printed to.
    lineSkip  := TTF_FontLineSkip( font );
    width    := rc^.w;
    height    := 10;
    SetLength(lines, 1);

    // Break the String into its lines:
    n := -1; i := 0;
    while n <> 0 do
    begin
      // Get until either "\n" or "\0":
      n := Pos(eol, str);

      //Copy all except EOL
      if n = 0 then subStr := str
      else if n = 1 then subStr := ' '
      else subStr := Copy(str, 1, n - 1);

      if Length(subStr) < 1 then subStr := ' ';

      //Remove the line from the original string
      if n <> 0 then
      begin
        str := Copy( str, n + Length(eol), Length(str)); //excess not copied...
      end;

      i := i + 1;
      SetLength(lines, i);
      lines[i - 1] := subStr;

      w := 0;
      
      // Get the size of the rendered text.
      if Length(subStr) > 0 then TTF_SizeUNICODE(font, PUint16(subStr), w, height);
        
      //Keep widest rendered text size
      if w > width then width := w;
    end;

    // Length(lines) = Number of Lines.
    // we assume that height is the same for all lines.
    height := (Length(lines) - 1) * lineSkip + height;

    sText := CreateBitmap(width, height);
    ClearSurface(sText, clrBg);

    // Actually render the text:
    for i := 0 to High(lines) do
    begin
      if length(lines[i]) = 0 then continue;
      // The rendered text:
      //temp := TTF_RenderText_Blended(font, PUint16(lines[i]), colorFG);
      temp := TTF_RenderUNICODE_Blended(font, PUint16(lines[i]), colorFG);
      
      // Put it on the surface:
      if IsSet(flags, AlignLeft) or
         (not (IsSet(flags, AlignCenter) or
               IsSet(flags, AlignRight))) then
      begin
        // If it's specifically LEFT or none of the others:
        rect := NewSDLRect(0,i*lineSkip,0,0);
      end
      else if IsSet(flags, AlignCenter) then
      begin
        w := 0;
        h := 0;

        TTF_SizeUNICODE(font, PUint16(lines[i]), w, h);
        rect := NewSDLRect(width div 2 - w div 2, i * lineSkip, 0, 0)
      end
      else if IsSet(flags, AlignRight) then
      begin
        w := 0;
        h := 0;

        TTF_SizeUNICODE(font, PUint16(lines[i]), w, h);
        rect := NewSDLRect(width - w, i * lineSkip, 0, 0);
      end
      else begin RaiseException('Invalid font alignment'); exit; end;

      // Render the current line. Ignore alpha in this draw
      if bgTransparent then SDL_SetAlpha(temp, 0, SDL_ALPHA_TRANSPARENT);
      SDL_BlitSurface(temp, nil, sText^.surface, @rect);

      // Clean up:
      SDL_FreeSurface(temp);
    end;

    // Draw the text on top of that:
    rect.x := 0; rect.y := 0; rect.w := rc^.w; rect.h := rc^.h;
    if (not bgTransparent) then SDL_SetAlpha(sText^.surface, 0, SDL_ALPHA_TRANSPARENT);  
    SDL_BlitSurface(sText^.surface, @rect, dest, rc );

    FreeBitmap(sText);
  end;

  /// Draws texts to the destination bitmap. Drawing text is a slow operation,
  /// and drawing it to a bitmap, then drawing the bitmap to screen is a
  /// good idea. Do not use this technique if the text changes frequently.
  ///
  /// @param dest:         The destination bitmap - not optimised!
  /// @param theText:     The text to be drawn onto the destination
  /// @param textColor:   The color to draw the text
  /// @param theFont:     The font used to draw the text
  /// @param x,y:         The x,y location to draw the text at (top left)
  ///
  /// Side Effects:
  /// - The text is drawn in the specified font, at the indicated location
  ///   in the destination bitmap.
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; theFont: Font; x, y: LongInt); overload;
  var
    rect: TSDL_Rect;
  begin
    if theFont = nil then begin RaiseException('The specified font is nil'); exit; end;
    if dest = nil then begin RaiseException('Cannot draw text, as no destination was supplied'); exit; end;
      
    rect := NewSDLRect(x + 1, y + 1, TextWidth(theFont, theText) + 2, TextHeight(theFont, theText) + 2);
    PrintStrings(dest^.surface, theFont, theText, @rect, textColor, ColorTransparent, AlignLeft);
  end;

  procedure DrawUnicode(dest: Bitmap; theText: WideString; textColor: Color; theFont: Font; x, y: LongInt); overload;
  var
    rect: TSDL_Rect;
  begin
    if theFont = nil then begin RaiseException('The specified font is nil'); exit; end;
    if dest = nil then begin RaiseException('Cannot draw text, as no destination was supplied'); exit; end;
      
    rect := NewSDLRect(x, y, TextWidth(theFont, theText), TextHeight(theFont, theText));    
    PrintWideStrings(dest^.surface, theFont, theText, @rect, textColor, ColorTransparent, AlignLeft);
  end;
  
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawText(dest, theText, textColor, theFont, Round(pt.x), Round(pt.y));
  end;

  procedure DrawUnicode(dest: Bitmap; theText: WideString; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawUnicode(dest, theText, textColor, theFont, Round(pt.x), Round(pt.y));
  end;


  /// Draws multiple lines of text to the destination bitmap. This is a very
  /// slow operation, so if the text is not frequently changing save it to a
  /// bitmap and draw that bitmap to screen instead.
  ///
  /// @param dest:         The destination bitmap - not optimised!
  /// @param theText:     The text to be drawn onto the destination
  /// @param textColor:   The color to draw the text
  /// @param backColor:   The color to draw behind the text
  /// @param theFont:     The font used to draw the text
  /// @param align:       The alignment for the text in the region
  /// @param x,y:         The x,y location to draw the text at (top left)
  /// @param w, h:         The width and height of the region to draw inside
  ///
  /// Side Effects:
  /// - The text is drawn in the specified font, at the indicated location
  ///   in the destination bitmap.
  procedure DrawTextLines(dest: Bitmap; theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y, w, h: LongInt); overload;
  var
    rect: TSDL_Rect;
  begin
    rect := NewSDLRect(x + 1, y + 1, w - 2, h - 2);
    PrintStrings(dest^.surface, theFont, theText, @rect, textColor, backColor, align);
  end;

  procedure DrawTextLines(dest: Bitmap; theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;
  begin
    DrawTextLines(dest, theText, textColor, backColor, theFont, align, Round(withinRect.x), Round(withinRect.y), withinRect.width, withinRect.height);
  end;


  /// Draws multiple lines of text to the screen. This is a very
  /// slow operation, so if the text is not frequently changing save it to a
  /// bitmap and draw that bitmap to screen instead.
  ///
  /// @param theText:     The text to be drawn onto the destination
  /// @param textColor:   The color to draw the text
  /// @param backColor:   The color to draw behind the text
  /// @param theFont:     The font used to draw the text
  /// @param align:       The alignment for the text in the region
  /// @param x,y:         The x,y location to draw the text at (top left)
  /// @param w, h:         The width and height of the region to draw inside
  ///
  /// Side Effects:
  /// - The text is drawn in the specified font, at the indicated location
  ///   on the screen.
  procedure DrawTextLinesOnScreen(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y, w, h: LongInt); overload;
  begin
    DrawTextLines(screen, theText, textColor, backColor, theFont, align, x, y, w, h);
  end;
  
  procedure DrawTextLinesOnScreen(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;
  begin
    DrawTextLines(screen, theText, textColor, backColor, theFont, align, Round(withinRect.x), Round(withinRect.y), withinRect.width, withinRect.height);
  end;

  procedure DrawTextLines(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; x, y:Single; w, h: LongInt); overload;
  begin
    DrawTextLines(screen, theText, textColor, backColor, theFont, align, ToScreenX(x), ToScreenY(y), w, h);
  end;

  procedure DrawTextLines(theText: String; textColor, backColor: Color; theFont: Font; align: FontAlignment; const withinRect: Rectangle); overload;
  begin
    DrawTextLines(screen, theText, textColor, backColor, theFont, align, ToScreenX(withinRect.x), ToScreenY(withinRect.y), withinRect.width, withinRect.height);
  end;



  /// Draws texts to the screen. Drawing text is a slow operation,
  /// and drawing it to a bitmap, then drawing the bitmap to screen is a
  /// good idea. Do not use this technique if the text changes frequently.
  ///
  /// @param theText:     The text to be drawn onto the screen
  /// @param textColor:   The color to draw the text
  /// @param theFont:     The font used to draw the text
  /// @param x,y:         The x,y location to draw the text at (top left)
  ///
  /// Side Effects:
  /// - The text is drawn in the specified font, at the indicated location
  ///   on the screen.
  procedure DrawTextOnScreen(theText: String; textColor: Color; theFont: Font; x, y: LongInt);
  begin
    DrawText(screen, theText, textColor, theFont, x, y);
  end;

  procedure DrawTextOnScreen(theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawText(screen, theText, textColor, theFont, Round(pt.x), Round(pt.y));
  end;

  procedure DrawUnicodeOnScreen(theText: WideString; textColor: Color; theFont: Font; x, y: LongInt); overload;
  begin
    DrawUnicode(screen, theText, textColor, theFont, x, y);
  end;

  procedure DrawUnicodeOnScreen(theText: WideString; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawUnicode(screen, theText, textColor, theFont, Round(pt.x), Round(pt.y));
  end;


  procedure DrawText(theText: String; textColor: Color; theFont: Font; x, y: Single);
  begin
    DrawText(screen, theText, textColor, theFont, ToScreenX(x), ToScreenY(y));
  end;
  
  procedure DrawText(theText: String; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawText(screen, theText, textColor, theFont, ToScreenX(pt.x), ToScreenY(pt.y));
  end;

  procedure DrawUnicode(theText: WideString; textColor: Color; theFont: Font; x, y: Single); overload;
  begin
    DrawUnicode(screen, theText, textColor, theFont, ToScreenX(x), ToScreenY(y));
  end;

  procedure DrawUnicode(theText: WideString; textColor: Color; theFont: Font; const pt: Point2D); overload;
  begin
    DrawUnicode(screen, theText, textColor, theFont, ToScreenX(pt.x), ToScreenY(pt.y));
  end;

  
  /// Calculates the width of a string when drawn with a given font.
  ///
  /// @param theText:   The text to measure
  /// @param theFont:   The font used to draw the text
  /// @returns           The width of the drawing in pixels
  function TextWidth(theFont: Font; theText: String): LongInt; overload;
  var
    y: LongInt; //SizeText returns both... store and ignore y
  begin
    if not Assigned(theFont) then begin RaiseException('No font supplied'); exit; end;
    try
      y := 0; result := 0;
      if length(theText) = 0 then result := 0 
      else TTF_SizeText(theFont, PChar(theText), result, y);
    except
      begin RaiseException('Unable to get the text width'); exit; end;
    end;
  end;

  function TextWidth(theText: WideString; theFont: Font): LongInt; overload;
  var
    y: LongInt; //SizeText returns both... store and ignore y
  begin
    if not Assigned(theFont) then begin RaiseException('No font supplied'); exit; end;
    try
      y := 0; result := 0;
      if length(theText) = 0 then result := 0
      else TTF_SizeUNICODE(theFont, PUInt16(theText), result, y);
    except
      begin RaiseException('Unable to get the text width'); exit; end;
    end;
  end;


  /// Calculates the height of a string when drawn with a given font.
  ///
  /// @param theText:   The text to measure
  /// @param theFont:   The font used to draw the text
  /// @returns           The height of the drawing in pixels
  function TextHeight(theFont: Font; theText: String): LongInt; overload;
  var
    w: LongInt; //SizeText returns both... store and ignore w
  begin
    if not Assigned(theFont) then begin RaiseException('No font supplied'); exit; end;
    try
      w := 0; result :=  0;
      TTF_SizeText(theFont, PChar(theText), w, result);
    except
      begin RaiseException('Unable to get the text height'); exit; end;
    end;
  end;

  function TextHeight(theText: WideString; theFont: Font): LongInt; overload;
  var
    w: LongInt; //SizeText returns both... store and ignore w
  begin
    if not Assigned(theFont) then begin RaiseException('No font supplied'); exit; end;
    try
      w := 0; result :=  0;
      TTF_SizeUNICODE(theFont, PUInt16(theText), w, result);
    except
      begin RaiseException('Unable to get the text height'); exit; end;
    end;
  end;
  
  /// Draws the frame rate using the specified font at the indicated x, y.
  /// Draws the FPS (min, max) current average
  ///
  /// @param x,y:     The x, y location to draw to
  /// @param font:     The font used to draw the framerate
  ///
  /// Side Effects:
  /// - Framerate is drawn to the screen
  procedure DrawFramerate(x, y: LongInt; font: Font); overload;
  var
    textColor : Color;
    average, highest, lowest : String;
  begin
    //Draw framerates
    CalculateFramerate(average, highest, lowest, textColor);

    if not Assigned(font) then
      DrawTextOnScreen('FPS: (' + highest + ', ' + lowest + ') ' + average, textColor, x + 2, y + 2)
    else
      DrawTextOnScreen('FPS: (' + highest + ', ' + lowest + ') ' + average, textColor, font, x + 2, y + 2);
  end;
  
  procedure DrawFramerate(x, y: LongInt); overload;
  begin
   DrawFramerate(x, y, nil);
  end;
  
  procedure DrawText(theText: String; textColor: Color; x, y: Single); overload;
  begin
    DrawText(screen, theText, textColor, ToScreenX(x), ToScreenY(y));
  end;

  procedure DrawText(theText: String; textColor: Color; const pt: Point2D);
  begin
    DrawText(theText, textColor, pt.x, pt.y);
  end;

  procedure DrawTextOnScreen(theText: String; textColor: Color; x, y: Single); overload;
  begin
    DrawText(screen, theText, textColor, x, y);
  end;
  
  procedure DrawText(dest: Bitmap; theText: String; textColor: Color; x, y: Single); overload;
  begin
    stringColor(dest^.surface, Round(x), Round(y), PChar(theText), ToGFXColor(textColor));
  end;
  
  function TextAlignmentFrom(str: String): FontAlignment;
  var ch: Char;
  begin
    str := trim(str);
    if length(str) > 0 then ch := str[1] else ch := 'l';
    
    case ch of
      'c', 'C': result := AlignCenter;
      'r', 'R': result := AlignRight;
      else result := AlignLeft;
    end;
  end;

//=============================================================================

//=============================================================================

  initialization
  begin
    InitialiseSwinGame();
    
    _Fonts := TStringHash.Create(False, 1024);
    
    if TTF_Init() = -1 then
    begin
      begin RaiseException('Error opening font library. ' + string(TTF_GetError)); exit; end;
    end;
  end;

//=============================================================================

  finalization
  begin
    TTF_Quit();
  end;

end.
