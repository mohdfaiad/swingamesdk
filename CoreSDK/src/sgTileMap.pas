//=============================================================================
// sgTileMap.pas
//=============================================================================
//
// Responsible for loading and processing a "Mappy" data file exported using
// the Lua script specifically written for SwinGame to create map files.
//
// Change History:
//
// Version 3.0:
// - 2009-07-10: Andrew : Added missing const modifier for struct parameters
// - 2009-07-09: Clinton: Optimized IsPointInTile slightly (isometric)
//                        Optimized GetTileFromPoint (isometric)
// - 2009-07-08: Clinton: Code comments, TODO notes and some tweaks/optimization
// - 2009-06-22: Clinton: Comment format, cleanup and new additions.
// - 2009-06-17: Andrew : added meta tags, renamed from "mappy" to tilemap
//
// Version 2:
// - 2008-12-17: Andrew : Moved all integers to LongInt
//
// Version 1.1.5:
// - 2008-04-18: Andrew : Fix extensions to work with Delphi.
//
// Version 1.1:
// - 2008-04-02: Stephen: Added MapWidth(), MapHeight(), BlockWidth(),
//                        BlockHeight(), GapX(), GapY(), StaggerX(), StaggerY(),
//                        LoadIsometricInformation(), LoadMapv2(),
//                      : various bug fixes
// - 2008-04-02: Andrew : Removed gap loading as mappy support has not been
//                        updated on the web, and this version is unable to
//                        read the old files.
// - 2008-03-29: Stephen: MapData record now contains GapX, GapY, StaggerX,
//                        StaggerY, Isometric
//                      : LoadMapInformation, now loads the new isometric related data
//                      : DrawMap now draws isometric tiles with their correct offsets
// - 2008-01-30: Andrew : Added const to vector param, increased search for collision tests
// - 2008-01-25: Andrew : Fixed compiler hints
// - 2008-01-22: Andrew : Re-added CollidedWithMap to allow compatibility with 1.0
// - 2008-01-21: Stephen: CollidedWithMap replaced with 3 Routines,
//                        - HasSpriteCollidedWithMapTile,
//                        - MoveSpriteOutOfTile,
//                        - WillCollideOnSide
// - 2008-01-17: Aki + Andrew: Refactor
//
// Version 1.0:
// - Various
//=============================================================================

///@module TileMap
///@static
unit sgTileMap;

//=============================================================================
interface
//=============================================================================

  uses  sgTypes;

  /// Reads the map files specified by mapName and return a new `Map` with all
  /// the details.
  /// @lib
  /// @class Map
  /// @constructor
  function LoadMap(mapName: String): Map;

  /// Used by LoadMap to load map data files.
  /// @lib
  /// @class Map
  /// @constructor
  function LoadMapFiles(mapFile, imgFile: String): Map;
  //TODO: Can this be private? Only used by LoadMap...

  /// @lib
  /// @class Map
  /// @method Draw
  procedure DrawMap(m: Map);

  /// @lib
  /// @class Map
  /// @method HasSpriteCollidedWithTile
  function SpriteHasCollidedWithMapTile(m: Map; s: Sprite): Boolean; overload;

  /// @lib SpriteHasCollidedWithMapTileOutXY
  /// @class Map
  /// @overload  HasSpriteCollidedWithTile HasSpriteCollidedWithTileOutXY
  function SpriteHasCollidedWithMapTile(m: Map; s: Sprite; out collidedX, collidedY: LongInt): Boolean; overload;

  /// @lib
  /// @class Map
  /// @method WillCollideOnSide
  function WillCollideOnSide(m: Map; s: Sprite): CollisionSide;

  /// @lib
  /// @class Map
  /// @method MoveSpriteOutOfTile
  procedure MoveSpriteOutOfTile(m: Map; s: Sprite; x, y: LongInt);

  /// @lib
  /// @class Map
  /// @method EventCount
  function EventCount(m: Map; eventType: Event): LongInt;

  /// @lib
  /// @class Map
  /// @method EventPositionX
  function EventPositionX(m: Map; eventType: Event; eventnumber: LongInt): LongInt;

  /// @lib
  /// @class Map
  /// @method EventPositionY
  function EventPositionY(m: Map; eventType: Event; eventnumber: LongInt): LongInt;

  /// @lib
  /// @class Sprite
  /// @self 2
  /// @method CollisionWithMap
  function CollisionWithMap(m: Map; s: Sprite; const vec: Vector): CollisionSide;
  //TODO: reorder map/sprite - make the sprite first param. vec is what?

  /// @lib
  /// @class Map
  /// @getter Width
  function MapWidth(m: Map): LongInt;

  /// @lib
  /// @class Map
  /// @getter Height
  function MapHeight(m: Map): LongInt;

  /// @lib
  /// @class Map
  /// @getter BlockWidth
  function BlockWidth(m: Map): LongInt;

  /// @lib
  /// @class Map
  /// @getter BlockHeight
  function BlockHeight(m: Map): LongInt;

  // TODO: Do Gap/Stagger need to be public? Concept need to be documented?
  // GapX and GapY = The distance between each tile (rectangular), can be
  // different to the normal width and height of the block
  //  StaggerX and StaggerY = The isometric Offset

  /// The x distance between each tile. See StaggerX for the isometric offset.
  /// @lib
  /// @class Map
  /// @getter GapX
  function GapX(m: Map): LongInt;

  /// The y distance between each tile. See StaggerY for the isometric offset.
  /// @lib
  /// @class Map
  /// @getter GapY
  function GapY(m: Map): LongInt;

  /// The isometric x offset value.
  /// @lib
  /// @class Map
  /// @getter StaggerX
  function StaggerX(m: Map): LongInt;

  /// The isometric y offset value.
  /// @lib
  /// @class Map
  /// @getter StaggerY
  function StaggerY(m: Map): LongInt;


  /// Return the tile that is under a given Point2D. Isometric maps are taken
  /// into consideration.  A Tile knows its x,y index in the map structure,
  /// the top-right corner of the tile and the 4 points that construct the tile.
  /// For Isometric tiles, the 4 points will form a diamond.
  /// @lib
  /// @class Map
  /// @self 2
  /// @method GetTileFromPoint
  function GetTileFromPoint(const point: Point2D; m: Map): Tile;
  //TODO: Why is the map the second parameter? Inconsistent...

  /// Returns the Event of the tile at the given (x,y) map index.
  /// Note that if the tile does not have an event, will return Event(-1)
  /// @lib
  /// @class Map
  /// @method GetEventAtTile
  function GetEventAtTile(m: Map; xIndex, yIndex: LongInt): Event;

  /// @lib
  /// @class Map
  /// @dispose
  procedure FreeMap(var m: Map);


//=============================================================================
implementation
//=============================================================================

  uses
    SysUtils, Classes,  //System,
    sgGraphics, sgCamera, sgCore, sgPhysics, sgGeometry, sgResources, sgSprites, sgShared; //Swingame

  function ReadInt(var stream: text): Word;
  var
    c: char;
    c2: char;
    i: LongInt;
    i2: LongInt;
  begin
    Read(stream ,c);
    Read(stream ,c2);

    i := LongInt(c);
    i2 := LongInt(c2) * 256;

    result := i + i2;
  end;

  procedure LoadMapInformation(m: Map; var stream: text);
  var
    header: LongInt;
  begin
    header := ReadInt(stream);

    if header = 0 then
    begin
      m^.MapInfo.Version := ReadInt(stream);
      m^.MapInfo.MapWidth := ReadInt(stream);
    end
    else
    begin
      m^.MapInfo.Version := 1;
      m^.MapInfo.MapWidth := header;
    end;

    //m^.MapInfo.MapWidth := ReadInt(stream);
    m^.MapInfo.MapHeight := ReadInt(stream);
    m^.MapInfo.BlockWidth := ReadInt(stream);
    m^.MapInfo.BlockHeight := ReadInt(stream);
    m^.MapInfo.NumberOfBlocks := ReadInt(stream);
    m^.MapInfo.NumberOfAnimations := ReadInt(stream);
    m^.MapInfo.NumberOfLayers := ReadInt(stream);
    m^.MapInfo.CollisionLayer := ReadInt(stream);
    m^.MapInfo.EventLayer := ReadInt(stream);
    m^.MapInfo.GapX := 0;
    m^.MapInfo.GapY := 0;
    m^.MapInfo.StaggerX := 0;
    m^.MapInfo.StaggerY := 0;
    m^.MapInfo.Isometric := false;

      {
      //Debug
      WriteLn('MapInformation');
      WriteLn('');
      WriteLn(m^.MapInfo.MapWidth);
      WriteLn(m^.MapInfo.MapHeight);
      WriteLn(m^.MapInfo.BlockWidth);
      WriteLn(m^.MapInfo.BlockHeight);
      WriteLn(m^.MapInfo.NumberOfBlocks);
      WriteLn(m^.MapInfo.NumberOfAnimations);
      WriteLn(m^.MapInfo.NumberOfLayers);
      WriteLn(m^.MapInfo.CollisionLayer);
      WriteLn(m^.MapInfo.EventLayer);
      WriteLn('');
      ReadLn();
      }
  end;

  procedure LoadIsometricInformation(m: Map; var stream: text);
  begin
    m^.MapInfo.GapX := ReadInt(stream);
    m^.MapInfo.GapY := ReadInt(stream);
    m^.MapInfo.StaggerX := ReadInt(stream);
    m^.MapInfo.StaggerY := ReadInt(stream);

    if ((m^.MapInfo.StaggerX = 0) and (m^.MapInfo.StaggerY = 0)) then
    begin
      m^.MapInfo.Isometric := false;
      m^.MapInfo.GapX := 0;
      m^.MapInfo.GapY := 0;
    end
    else
      m^.MapInfo.Isometric := true;

  end;


  procedure LoadAnimationInformation(m: Map; var stream: text);
  var
    i, j: LongInt;
  begin

    if m^.MapInfo.NumberOfAnimations > 0 then
    begin
  
      SetLength(m^.AnimationInfo, m^.MapInfo.NumberOfAnimations);
    
      for i := 0 to m^.MapInfo.NumberOfAnimations - 1 do
      begin
      
        m^.AnimationInfo[i].AnimationNumber := i + 1;
        m^.AnimationInfo[i].Delay := ReadInt(stream);
        m^.AnimationInfo[i].NumberOfFrames := ReadInt(stream);

        SetLength(m^.AnimationInfo[i].Frame, m^.AnimationInfo[i].NumberOfFrames);
      
        for j := 0 to m^.AnimationInfo[i].NumberOfFrames - 1 do
        begin
          m^.AnimationInfo[i].Frame[j] := ReadInt(stream);
        end;
      
        m^.AnimationInfo[i].CurrentFrame := 0;
      
      end;
    
      {
      //Debug
      WriteLn('Animation Information');
      WriteLn('');
      for i := 0 to m^.MapInfo.NumberOfAnimations - 1 do
      begin
        WriteLn(m^.AnimationInfo[i].AnimationNumber);
        WriteLn(m^.AnimationInfo[i].Delay);
        WriteLn(m^.AnimationInfo[i].NumberOfFrames);
      
        for j := 0 to m^.AnimationInfo[i].NumberOfFrames - 1 do
        begin
          WriteLn(m^.AnimationInfo[i].Frame[j]);
        end;
      end;
      WriteLn('');
      ReadLn();
      }
    end;
  end;

  procedure LoadLayerData(m: Map; var stream: text);
  var
    l, y, x: LongInt;
  begin

    SetLength(m^.LayerInfo, m^.MapInfo.NumberOfLayers - m^.MapInfo.Collisionlayer - m^.MapInfo.EventLayer);

    for y := 0 to Length(m^.LayerInfo) - 1 do
    begin

      SetLength(m^.LayerInfo[y].Animation, m^.MapInfo.MapHeight);
      SetLength(m^.LayerInfo[y].Value, m^.MapInfo.MapHeight);

      for x := 0 to m^.MapInfo.MapHeight - 1 do
      begin

        SetLength(m^.LayerInfo[y].Animation[x], m^.MapInfo.MapWidth);
        SetLength(m^.LayerInfo[y].Value[x], m^.MapInfo.MapWidth);
      end;
    end;

    for l := 0 to m^.MapInfo.NumberOfLayers - m^.MapInfo.Collisionlayer - m^.MapInfo.Eventlayer - 1 do
    begin
      for y := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        for x := 0 to m^.MapInfo.MapWidth - 1 do
        begin

          m^.LayerInfo[l].Animation[y][x] := ReadInt(stream);
          m^.LayerInfo[l].Value[y][x] := ReadInt(stream);
        end;
      end;
    end;

    {
    //Debug
    WriteLn('Layer Information');
    WriteLn(Length(m^.Layerinfo));
    WriteLn('');
  
    for l := 0 to Length(m^.LayerInfo) - 1 do
    begin
      for y := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        for x := 0 to m^.MapInfo.MapWidth - 1 do
        begin
          Write(m^.LayerInfo[l].Animation[y][x]);
          Write(',');
          Write(m^.LayerInfo[l].Value[y][x]);
          Write(' ');
        end;
      end;
      WriteLn('');
      ReadLn();
    end;
    }


  end;

  procedure LoadCollisionData(m: Map; var stream: text);
  var
    y, x: LongInt;
  begin
    if m^.MapInfo.CollisionLayer = 1 then
    begin
      SetLength(m^.CollisionInfo.Collidable, m^.MapInfo.MapHeight);

      for y := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        SetLength(m^.CollisionInfo.Collidable[y], m^.MapInfo.MapWidth);
      end;
    
      for y := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        for x := 0 to m^.MapInfo.MapWidth - 1 do
        begin
          // True/False
          m^.CollisionInfo.Collidable[y][x] := (ReadInt(stream) <> 0);
//          if ReadInt(stream) <> 0 then
//            m^.CollisionInfo.Collidable[y][x] := true
//          else
//            m^.CollisionInfo.Collidable[y][x] := false
        end;
      end;


      //Debug
      {
      for y := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        for x := 0 to m^.MapInfo.MapWidth - 1 do
        begin
          if m^.CollisionInfo.Collidable[y][x] = true then
            Write('1')
          else
            Write('0')
        end;
        WriteLn('');
      end;
      ReadLn();
      }
    end;
  end;

  procedure LoadEventData(m: Map; var stream: text);
  var
    py, px, smallestEventIdx, temp: LongInt;
    evt: Event;
  begin
    //SetLength(m^.EventInfo, High(Events));
    //SetLength(m^.EventInfo.Event, m^.MapInfo.MapHeight);
    {for y := 0 to m^.MapInfo.MapHeight - 1 do
    begin
      SetLength(m^.EventInfo.Event[y], m^.MapInfo.MapWidth);
    end;}

    //The smallest "non-graphics" tile, i.e. the events
    smallestEventIdx := m^.MapInfo.NumberOfBlocks - 23;

    for py := 0 to m^.MapInfo.MapHeight - 1 do
    begin
      for px := 0 to m^.MapInfo.MapWidth - 1 do
      begin
        temp := ReadInt(stream);
        evt := Event(temp - smallestEventIdx);
        //TODO: Optimize - avoid repeated LongIng(evt) conversions
        if (evt >= Event1) and (evt <= Event24) then
        begin
          SetLength(m^.EventInfo[LongInt(evt)], Length(m^.EventInfo[LongInt(evt)]) + 1);

          with m^.EventInfo[LongInt(evt)][High(m^.EventInfo[LongInt(evt)])] do
          begin
            x := px;
            y := py;
          end;
        end
      end;
    end;


    //Debug
    {
    for y := 0 to m^.MapInfo.MapHeight - 1 do
    begin
      for x := 0 to m^.MapInfo.MapWidth - 1 do
      begin
        Write(' ');
        Write(LongInt(m^.EventInfo.Event[y][x]));
      end;
      WriteLn('');
    end;
    ReadLn();
    }
  end;

  procedure LoadBlockSprites(m: Map; fileName: String);
  var
    fpc: LongIntArray; //Array of LongInt;
  begin
    SetLength(fpc, m^.MapInfo.NumberOfBlocks);
    m^.Tiles := CreateSprite(LoadBitmap(fileName), true, fpc,
                             m^.MapInfo.BlockWidth,
                             m^.MapInfo.BlockHeight);
    m^.Tiles^.currentCell := 0;
  end;

  procedure DrawMap(m: Map);
  var
    l, y ,x: LongInt;
    XStart, YStart, XEnd, YEnd: LongInt;
    f: LongInt;
  begin
    if m = nil then raise Exception.Create('No Map supplied (nil)');

    //WriteLn('GX, GY: ', ToWorldX(0), ',' , ToWorldY(0));
    //WriteLn('bw, bh: ', m^.MapInfo.BlockWidth, ', ', m^.MapInfo.BlockHeight);

    //TODO: Optimize - the x/yStart (no need to keep re-calculating)
    //Screen Drawing Starting Point
    XStart := round((ToWorldX(0) / m^.MapInfo.BlockWidth) - (m^.MapInfo.BlockWidth * 1));
    YStart := round((ToWorldY(0) / m^.MapInfo.BlockHeight) - (m^.MapInfo.BlockHeight * 1));

    //Screen Drawing Ending point
    XEnd := round(XStart + (sgCore.ScreenWidth() / m^.MapInfo.BlockWidth) + (m^.MapInfo.BlockWidth * 1));
    YEnd := round(YStart + (sgCore.ScreenHeight() / m^.MapInfo.BlockHeight) + (m^.MapInfo.BlockHeight * 1));


    //WriteLn('DrawMap ', XStart, ',', YStart, ' - ',  XEnd, ',', YEnd);

    if YStart < 0 then YStart := 0;
    if YStart >= m^.MapInfo.MapHeight then exit;
    if YEnd < 0 then exit;
    if YEnd >= m^.MapInfo.MapHeight then YEnd := m^.MapInfo.MapHeight - 1;

    if XStart < 0 then XStart := 0;
    if XStart >= m^.MapInfo.MapWidth then exit;
    if XEnd < 0 then exit;
    if XEnd >= m^.MapInfo.MapWidth then XEnd := m^.MapInfo.MapWidth - 1;

    for y := YStart  to YEnd do
    begin
      //TODO: Optimize - no need to re-test "isometric" - separate and do it ONCE!

      //Isometric Offset for Y
      if m^.MapInfo.Isometric then
        m^.Tiles^.position.y := y * m^.MapInfo.StaggerY
      else
        m^.Tiles^.position.y := y * m^.MapInfo.BlockHeight;

      for x := XStart to XEnd do
      begin
        //Isometric Offset for X
        if (m^.MapInfo.Isometric = true) then
        begin
          m^.Tiles^.position.x := x * m^.MapInfo.GapX;
          if ((y MOD 2) = 1) then
            m^.Tiles^.position.x := m^.Tiles^.position.x + m^.MapInfo.StaggerX;
        end
        else
          m^.Tiles^.position.x := x * m^.MapInfo.BlockWidth;

        for l := 0 to m^.MapInfo.NumberOfLayers - m^.MapInfo.CollisionLayer - m^.MapInfo.EventLayer - 1 do
        begin
          if (m^.LayerInfo[l].Animation[y][x] = 0) and (m^.LayerInfo[l].Value[y][x] > 0) then
          begin
            m^.Tiles^.currentCell := m^.LayerInfo[l].Value[y][x] - 1;
            //DrawSprite(m^.Tiles, CameraX, CameraY, sgCore.ScreenWidth(), sgCore.ScreenHeight());
            DrawSprite(m^.Tiles);
          end
          else if (m^.LayerInfo[l].Animation[y][x] = 1) then
          begin
            f := round(m^.Frame/10) mod (m^.AnimationInfo[m^.LayerInfo[l].Value[y][x]].NumberOfFrames);
            m^.Tiles^.currentCell := m^.AnimationInfo[m^.LayerInfo[l].Value[y][x]].Frame[f] - 1;
            DrawSprite(m^.Tiles);
          end;
        end;
      end;
    end;

    m^.Frame := (m^.Frame + 1) mod 1000;
  end;

  function LoadMap(mapName: String): Map;
  var
    mapFile, imgFile: String;
  begin
    mapFile := GetPathToResource(mapName + '.sga', MapResource);
    imgFile := GetPathToResource(mapName + '.png', MapResource);
    result := LoadMapFiles(mapFile, imgFile);
  end;

  //mapFile and imgFile are full-path+filenames
  function LoadMapFiles(mapFile, imgFile: String): Map;
  var
    f: text;
    m: Map;
  begin
    if not FileExists(mapFile) then raise Exception.Create('Unable to locate map: ' + mapFile);
    if not FileExists(imgFile) then raise Exception.Create('Unable to locate map images: ' + imgFile);

    //Get File
    assign(f, mapFile);
    reset(f);

    //Create Map
    New(m);

    //Load Map Content
    LoadMapInformation(m, f);
    if (m^.MapInfo.Version > 1) then LoadIsometricInformation(m, f);
    LoadAnimationInformation(m, f);
    LoadLayerData(m, f);
    LoadCollisionData(m, f);
    LoadEventData(m, f);
    //Close File
    close(f);

    LoadBlockSprites(m, imgFile);
    m^.Frame := 0;
    result := m;

    //WriteLn(m^.MapInfo.Version);
  end;

  //Gets the number of Event of the specified type
  function EventCount(m: Map; eventType: Event): LongInt;
  begin
    if m = nil then
      raise Exception.Create('No Map supplied (nil)');
    if (eventType < Event1) or (eventType > Event24) then //TODO: Should be high(Event) type.. less fixed
      raise Exception.Create('EventType is out of range');

    result := Length(m^.EventInfo[LongInt(eventType)]);
    //TODO: WHY do we keep converting eventType to LongInt - just store as LongINT!!!

    {count := 0;
  
    for y := 0 to m^.MapInfo.MapWidth - 1 do
    begin
      for x := 0 to m^.MapInfo.MapHeight - 1 do
      begin
        if event = m^.EventInfo.Event[y][x] then
          count := count + 1;
      end;
    end;
    result := count;}
  end;

  // Gets the Top Left X Coordinate of the Event
  function EventPositionX(m: Map; eventType: Event; eventnumber: LongInt): LongInt;
  begin
    if (eventnumber < 0) or (eventnumber > EventCount(m, eventType) - 1) then raise Exception.Create('Event number is out of range');

    if (m^.MapInfo.Isometric = true) then
    begin
      result := m^.EventInfo[LongInt(eventType)][eventnumber].x * m^.MapInfo.GapX;
      if ((m^.EventInfo[LongInt(eventType)][eventnumber].y MOD 2) = 1) then
        result := result + m^.MapInfo.StaggerX;
      end
    
    else
      result := m^.EventInfo[LongInt(eventType)][eventnumber].x * m^.MapInfo.BlockWidth;
  
  end;

  // Gets the Top Left Y Coordinate of the Event
  function EventPositionY(m: Map; eventType: Event; eventnumber: LongInt): LongInt;
  begin
    if (eventnumber < 0) or (eventnumber > EventCount(m, eventType) - 1) then
      raise Exception.Create('Event number is out of range');
  
    if (m^.MapInfo.Isometric = true) then
    begin
      result := m^.EventInfo[LongInt(eventType)][eventnumber].y * m^.MapInfo.StaggerY;
    end
    else      
    begin
      result := m^.EventInfo[LongInt(eventType)][eventnumber].y * m^.MapInfo.BlockHeight;
    end;
  end;

  function BruteForceDetection(m: Map; s: Sprite): Boolean;
  const
    SEARCH_RANGE = 0;
  var
    XStart, XEnd, YStart, YEnd: LongInt;
    y, x, yCache: LongInt;
  begin
    result := false;

    with m^.MapInfo do begin
      XStart := round((s^.position.x / BlockWidth) - ((s^.width / BlockWidth) - SEARCH_RANGE));
      XEnd := round((s^.position.x / BlockWidth) + ((s^.width / BlockWidth) + SEARCH_RANGE));
      YStart := round((s^.position.y / BlockHeight) - ((s^.height / BlockHeight) - SEARCH_RANGE));
      YEnd := round((s^.position.y / BlockHeight) + ((s^.height / BlockHeight) + SEARCH_RANGE));

      if YStart < 0 then YStart := 0;
      if YStart >= MapHeight then exit;
      if YEnd < 0 then exit;
      if YEnd >= MapHeight then YEnd := MapHeight - 1;

      if XStart < 0 then XStart := 0;
      if XStart >= MapWidth then exit;
      if XEnd < 0 then exit;
      if XEnd >= MapWidth then XEnd := MapWidth - 1;

      for y := YStart to YEnd do
      begin
        yCache := y * BlockHeight;

        for x := XStart to XEnd do
          if m^.CollisionInfo.Collidable[y][x] then
            if SpriteRectCollision(s, x * BlockWidth, yCache, BlockWidth, BlockHeight) then
            begin
              result := true;
              exit;
            end;
      end;
    end; // with
  end;

  function BruteForceDetectionComponent(m: Map; var s: Sprite; xOffset, yOffset: LongInt): Boolean;
  begin
    s^.position.x := s^.position.x + xOffset;
    s^.position.y := s^.position.y + yOffset;

    result := BruteForceDetection(m, s);
{    if BruteForceDetection(m, s) then
    begin
      result := true;
    end
    else
      result := false;}

    s^.position.x := s^.position.x - xOffset;
    s^.position.y := s^.position.y - yOffset;
  end;

  procedure MoveOut(s: Sprite; velocity: Vector; x, y, width, height: LongInt);
  var
    kickVector: Vector;
    sprRect, tgtRect: Rectangle;
  begin
    sprRect := RectangleFrom(s);
    tgtRect := RectangleFrom(x, y, width, height);
    kickVector := VectorOutOfRectFromRect(sprRect, tgtRect, velocity);
    MoveSprite(s, kickVector);
  end;

  function GetPotentialCollisions(m: Map; s: Sprite): Rectangle;
    function GetBoundingRectangle(): Rectangle;
    var
      startPoint, endPoint: Rectangle;
      startX, startY, endX, endY: LongInt;
    begin
      with m^.MapInfo do begin
        startPoint := RectangleFrom(
          round( ((s^.position.x - s^.velocity.x) / BlockWidth) - 1) * BlockWidth,
          round( ((s^.position.y - s^.velocity.y) / BlockHeight) - 1) * BlockHeight,
          (round( s^.width / BlockWidth) + 2) * BlockWidth,
          (round( s^.height / BlockHeight) + 2) * BlockHeight
        );
        endPoint := RectangleFrom(
          round(((s^.position.x + s^.width) / BlockWidth) - 1) * BlockWidth,
          round(((s^.position.y + s^.height) / BlockHeight) - 1) * BlockHeight,
          (round(s^.width / BlockWidth) + 2) * BlockWidth,
          (round(s^.height / BlockHeight) + 2) * BlockHeight
        );
      end; // with

      //Encompassing Rectangle
      if startPoint.x < endPoint.x then
      begin
        startX := round(startPoint.x);
        endX := round(endPoint.x + endPoint.width);
      end
      else
      begin
        startX := round(endPoint.x);
        endX := round(startPoint.x + startPoint.width);
      end;

      if startPoint.y < endPoint.y then
      begin
        startY := round(startPoint.y);
        endY := round(endPoint.y + endPoint.height);
      end
      else
      begin
        startY := round(endPoint.y);
        endY := round(startPoint.y + startPoint.height);
      end;

      result := RectangleFrom(startX, startY, endX - startX, endY - startY);

      //Debug Info
      //DrawRectangle(ColorYellow, startPoint.x, startPoint.y, startPoint.width, startPoint.height);
      //DrawRectangle(ColorWhite, endPoint.x, endPoint.y, endPoint.width, endPoint.height);
      //DrawRectangle(ColorGreen, result.x, result.y, result.width, result.height);
    end;
  begin
    //Respresents the Rectangle that encompases both the Current and Previous positions of the Sprite.
    //Gets the Bounding Collision Rectangle
    result := GetBoundingRectangle();
    //TODO: Why is this an inner function with it does ALL the work??
  end;

  function WillCollideOnSide(m: Map; s: Sprite): CollisionSide;
  type
    Collisions = record
      Top, Bottom, Left, Right: Boolean;
    end;
  var
    col: Collisions;
  begin
    col.Right  := (s^.velocity.x > 0) and BruteForceDetectionComponent(m, s, s^.width, 0);
    col.Left   := (s^.velocity.x < 0) and BruteForceDetectionComponent(m, s, -s^.width, 0);
    col.Top    := (s^.velocity.y < 0) and BruteForceDetectionComponent(m, s, 0, -s^.height);
    col.Bottom := (s^.velocity.y > 0) and BruteForceDetectionComponent(m, s, 0, s^.height);

    if col.Right and col.Bottom then result := BottomRight
    else if col.Left and col.Bottom then result := BottomLeft
    else if col.Right and col.Top then result := TopRight
    else if col.Left and col.Top then result := TopLeft
    else if col.Left then result := Left
    else if col.Right then result := Right
    else if col.Top then result := Top
    else if col.Bottom then result := Bottom
    else result := None;
  end;

  procedure MoveSpriteOutOfTile(m: Map; s: Sprite; x, y: LongInt);
  begin
    //TODO: Avoid these exception tests (at least the first 2) - do them earlier during loading
    if m = nil then raise Exception.Create('No Map supplied (nil)');
    if s = nil then raise Exception.Create('No Sprite suppled (nil)');
    if (x < 0 ) or (x >= m^.mapInfo.mapWidth) then raise Exception.Create('x is outside the bounds of the map');
    if (y < 0 ) or (y >= m^.mapInfo.mapWidth) then raise Exception.Create('y is outside the bounds of the map');
    with m^.MapInfo do
      MoveOut(s, s^.velocity, x * BlockWidth, y * BlockHeight, BlockWidth, BlockHeight);
  end;


  function SpriteHasCollidedWithMapTile(m: Map; s: Sprite): Boolean; overload;
  var
    x, y: LongInt;
  begin
    result := SpriteHasCollidedWithMapTile(m, s, x, y);
  end;

  function SpriteHasCollidedWithMapTile(m: Map; s: Sprite; out collidedX, collidedY: LongInt): Boolean; overload;
  var
    y, x, yCache, dy, dx, i, j, initY, initX: LongInt;
    xStart, yStart, xEnd, yEnd: LongInt;
    rectSearch: Rectangle;
    side: CollisionSide;
  begin
    result := false;
    if m = nil then raise Exception.Create('No Map supplied (nil)');
    if s = nil then raise Exception.Create('No Sprite suppled (nil)');

    rectSearch := GetPotentialCollisions(m, s);
    side := GetSideForCollisionTest(s^.velocity);
    with m^.MapInfo do begin
      yStart := round(rectSearch.y / BlockHeight);
      yEnd := round((rectSearch.y + rectSearch.height) / BlockHeight);
      xStart := round(rectSearch.x / BlockWidth);
      xEnd := round((rectSearch.x + rectSearch.width) / BlockWidth);

      if yStart < 0 then yStart := 0;
      if yStart >= MapHeight then exit;
      if yEnd < 0 then exit;
      if yEnd >= MapHeight then yEnd := MapHeight - 1;

      if xStart < 0 then xStart := 0;
      if xStart >= MapWidth then exit;
      if xEnd < 0 then exit;
      if xEnd >= MapWidth then xEnd := MapWidth - 1;
     end; //with
//    result := false;

    case side of
      TopLeft: begin dy := 1; dx := 1; initY := yStart; initX := xStart; end;
      TopRight: begin dy := 1; dx := -1; initY := yStart; initX := xEnd; end;
      BottomLeft: begin dy := -1; dx := 1; initY := yEnd; initX := xStart; end;
      BottomRight: begin dy := -1; dx := -1; initY := yEnd; initX := xEnd; end;
      Top: begin dy := 1; dx := 1; initY := yStart; initX := xStart; end;
      Bottom: begin dy := -1; dx := 1; initY := yEnd; initX := xStart; end;
      Left: begin dy := 1; dx := 1; initY := yStart; initX := xStart; end;
      Right: begin dy := 1; dx := -1; initY := yStart; initX := xEnd; end;
      else
      begin dy := 1; dx := 1; initY := yStart; initX := xStart; end;
    end;

    with m^.MapInfo do begin
      for i := yStart to yEnd do
      begin
        y := initY + (i - yStart) * dy;
        yCache := y * BlockHeight;
        for j := xStart to xEnd do
        begin
          x := initX + (j - xStart) * dx; //TODO: Optimize - j start at 0 instead...
          if m^.CollisionInfo.Collidable[y][x] = true then
          begin
            if SpriteRectCollision(s, x * BlockWidth, yCache, BlockWidth, BlockHeight) then
            begin
              result := true;
              collidedX := x;
              collidedY := y;
              exit;
            end;
          end;
        end;
      end;
    end; // with

    collidedX := -1;
    collidedY := -1;

  end;

  procedure FreeMap(var m: Map);
  begin
    FreeBitmap(m^.Tiles^.bitmaps[0]); //TODO: Check - is there only 1 bitmap?
    FreeSprite(m^.Tiles);
    Dispose(m);
    m := nil;
  end;

  function CollisionWithMap(m: Map; s: Sprite; const vec: Vector): CollisionSide;
  var
    x, y: LongInt;
    temp: Vector;
  begin
    result := None;
    temp := s^.velocity;
    s^.velocity := vec;
    if sgTileMap.SpriteHasCollidedWithMapTile(m, s, x, y) then
    begin
      MoveSpriteOutOfTile(m, s, x, y);
      result := WillCollideOnSide(m, s);
    end;
    s^.velocity := temp;
  end;

  function MapWidth(m: Map): LongInt;
  begin
    result := m^.MapInfo.MapWidth;
  end;

  function MapHeight(m: Map): LongInt;
  begin
    result := m^.MapInfo.MapHeight;
  end;

  function BlockWidth(m: Map): LongInt;
  begin
    result := m^.MapInfo.BlockWidth;
  end;

  function BlockHeight(m: Map): LongInt;
  begin
    result := m^.MapInfo.BlockHeight;
  end;

  function GapX(m: Map): LongInt;
  begin
    result := m^.MapInfo.GapX;
  end;

  function GapY(m: Map): LongInt;
  begin
    result := m^.MapInfo.GapY;
  end;

  function StaggerX(m: Map): LongInt;
  begin
    result := m^.MapInfo.StaggerX;
  end;

  function StaggerY(m: Map): LongInt;
  begin
    result := m^.MapInfo.StaggerY;
  end;

  //Determines whether the specified point is within the tile provided
  function IsPointInTile(point: Point2D; x, y: LongInt; m: Map): Boolean;
  var
    tri: Triangle;
  begin
    with m^.MapInfo do begin
      if Isometric then
      begin
        // Create Triangle
        tri := TriangleFrom(x, y + BlockHeight / 2,
                            x + BlockWidth / 2, y,
                            x + BlockWidth / 2, y + BlockHeight);
        // Test first triangle and leave early?
        if PointInTriangle(point, tri) then
        begin
          result := True;
          exit;
        end
        // Need to test the second triangle too...
        else
        begin
          tri := TriangleFrom(x + BlockWidth, y + BlockHeight / 2,
                              x + BlockWidth / 2, y,
                              x + BlockWidth / 2, y + BlockHeight);
          // store result and done
          result := PointInTriangle(point, tri);
        end;
      end
      else
        result := PointInRect(point, x, y, BlockWidth, BlockHeight);
    end;
  end;


  function GetTileFromPoint(const point: Point2D; m: Map): Tile;
  var
    x, y, tx, ty: LongInt;
  begin
    //Returns (-1,-1) if no tile has this point
    result.xIndex := -1;
    result.yIndex := -1;
    result.topCorner := PointAt(0,0);
    result.PointA := PointAt(0,0);
    result.PointB := PointAt(0,0);
    result.PointC := PointAt(0,0);
    result.PointD := PointAt(0,0);

    with m^.MapInfo do begin
      if Isometric then
        for y := 0 to MapHeight - 1 do
        begin
          // tile y pos?
          ty := y * StaggerY;
          for x := 0  to MapWidth - 1  do
          begin
            // tile x pos?
            tx := x * GapX;
            if ((y MOD 2) = 1) then tx := tx + StaggerX;
            // test and leave?
            if IsPointInTile(point, tx, ty, m) then
            begin
              result.xIndex := x;
              result.yIndex := y;
              result.topCorner := PointAt(tx,ty);
              result.PointA := PointAt(tx, ty + BlockHeight / 2);
              result.PointB := PointAt(tx + BlockWidth / 2, ty);
              result.PointC := PointAt(tx + BlockWidth / 2, ty + BlockHeight);
              result.PointD := PointAt(tx + BlockWidth, ty + BlockHeight / 2);
              exit;
            end;
          end;
        end
      else // Simple square-map (not isometric diamonds)
        for y := 0 to MapHeight - 1 do
        begin
          ty := y * BlockHeight;
          for x := 0  to MapWidth - 1  do
          begin
            tx := x * BlockWidth;
            if IsPointInTile(point, tx, ty, m) then
            begin
              result.xIndex := x;
              result.yIndex := y;
              result.topCorner := PointAt(tx,ty);
              //TODO: Optimize - recalc of PointsA/B/C/D - store and keep.
              result.PointA := PointAt(tx, ty);
              result.PointB := PointAt(tx + BlockWidth, ty);
              result.PointC := PointAt(tx, ty + BlockHeight);
              result.PointD := PointAt(tx + BlockWidth, ty + BlockHeight);
              exit;
            end;
          end;
        end;

{ // Old code - shorter, but takes longer
      for y := 0 to MapHeight - 1 do
      begin
        //TODO: Optimize - to isometric test ONCE not multiple times...
        //Isometric Offset for Y
        if Isometric then
          ty := y * StaggerY
        else
          ty := y * BlockHeight;

        for x := 0  to MapWidth - 1  do
        begin

          //Isometric Offset for X
          if Isometric then
          begin
            tx := x * GapX;
            if ((y MOD 2) = 1) then
              tx := tx + StaggerX;
          end
          else
            tx := x * BlockWidth;

          if IsPointInTile(point, tx, ty, m) then
          begin
            result.xIndex := x;
            result.yIndex := y;
            result.topCorner := PointAt(tx,ty);
            if Isometric then
            begin
              result.PointA := PointAt(tx, ty + BlockHeight / 2);
              result.PointB := PointAt(tx + BlockWidth / 2, ty);
              result.PointC := PointAt(tx + BlockWidth / 2, ty + BlockHeight);
              result.PointD := PointAt(tx + BlockWidth, ty + BlockHeight / 2);
              exit;
            end
            else
            begin
              result.PointA := PointAt(tx, ty);
              result.PointB := PointAt(tx + BlockWidth, ty);
              result.PointC := PointAt(tx, ty + BlockHeight);
              result.PointD := PointAt(tx + BlockWidth, ty + BlockHeight);
              exit; // ARGH!
            end;
          end;
        end;
      end;
}
    end; // with
  end;

  function GetEventAtTile(m: Map; xIndex, yIndex: LongInt): Event;
  var
    i, j: LongInt;
  begin
    for i := 0 to 23 do //TODO: hard-coded magic numbers bad... MAP_EVENT_HI?
      if (Length(m^.EventInfo[i]) > 0) then
        for j := 0 to High(m^.EventInfo[i]) do
          if (m^.EventInfo[i][j].x = xIndex) and (m^.EventInfo[i][j].y = yIndex) then
          begin
            result := Event(i);
            exit;
          end;
    // default result
    result := Event(-1);
  end;
  
  
//=============================================================================

  initialization
  begin
    InitialiseSwinGame();
  end;

end.