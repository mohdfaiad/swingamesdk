//=============================================================================
//          sgGeometry.pas
//----------------------------------------------------------------------------
//
// Contains code to create points, vectors and matrices and operations for use
// between them (addition, multiplication). This unit is particularly useful 
// for the sgPhysics unit with uses such operations for collision testing.
//  
// Most of the code in this unit was in sgPhysics prior to version 3. See 
// there for possible relevant change notes.
//
// Change History:
//
// Version 3.0:
// - 2009-06-26: Andrew : Completed ClosestPointOnRectFromCircle
//                      : Completed
//                      : Fixed overloads of PointAt
//                      : Added RectangleCenter
//                      : GetRayCircleIntersectDistance heading can now be non-unit vector
//                      : Add DistantPointOnCircle
//                      : Added DistantPointOnCircleWithVector
//                      : Added VectorOutOfRectFromCircle
//                      : Added PointInCircle
//                      : Added RectangleFrom Triangle
// - 2009-06-24: Andrew : Renamed to sgGeometry and combined with Shapes
//                      : Moved CenterPoint to sgSprite.
//                      : VectorFromCenterSpriteToPoint
//                      : VectorFromTo
// - 2009-06-23: Clinton: Created unit. Moved math routines from physics and
//                      : shapes units. 
//----------------------------------------------------------------------------


/// @module Geometry
/// @static
unit sgGeometry;

//----------------------------------------------------------------------------
interface
//----------------------------------------------------------------------------

  uses sgTypes;
  
  /// @lib
  function LineSegmentsIntersect(const line1, line2: LineSegment): boolean;
  
  /// @lib
  function LineOfLinesCircleHit(const fromPt: Point2D; radius: Single; const movement: Vector; const lines: LinesArray; out found: LineSegment): Boolean;
  
  /// @lib
  function LineCircleHit(const fromPt: Point2D; radius: Single; movement: Vector; rect: Rectangle; out found: LineSegment): Boolean;
  
  /// @lib
  procedure GetWidestPoints(const center: Point2D; radius: Single; along: Vector; out pt1, pt2: Point2D);
  
  /// @lib
  function GetTangentPoints(const fromPt, centre: Point2D; radius: Single; out p1, p2: Point2D): Boolean;
  
  /// @lib
  function GetRayCircleIntersectDistance(const ray_origin: Point2D; const ray_heading:Vector; const circle_origin: Point2D; radius: Single): Single;
  
  //  Returns distance from the line, or if the intersecting point on the line nearest
  //    the point tested is outside the endpoints of the line, the distance to the
  //    nearest endpoint.
  //
  //  Returns -1 on zero-valued denominator conditions to return an illegal distance. (
  //    modification of Brandon Crosby's VBA code)

  /// @lib PointLineDistance
  function PointLineDistance(const pt: Point2D; const line: LineSegment): Single; overload;
  /// @lib PointXYLineDistance
  function PointLineDistance(x, y: Single; const line: LineSegment): Single; overload;
  /// @lib ClosestPointOnLineXY
  function ClosestPointOnLine(x, y: Single; const line: LineSegment): Point2D; overload;
  /// @lib ClosestPointOnLine
  function ClosestPointOnLine(const fromPt: Point2D; const line: LineSegment): Point2D; overload;
  
  /// Returns the closest point on a rectangle from a given circle.
  /// @lib
  
  function ClosestPointOnRectFromCircle(const center: Point2D; radius: Single; const rect: Rectangle): Point2D;
  /// @lib
  function ClosestPointOnLinesFromCircle(const center: Point2D; radius: Single; const lines: LinesArray): Point2D;  
  /// @lib
  function ClosestPointOnCircle(const fromPt, center: Point2D; radius: Single): Point2D;
  
  /// Returns the point at the opposite side of a circle from a given point `pt`.
  ///
  /// @lib
  function DistantPointOnCircle(const pt, center: Point2D; radius: Single): Point2D;
  
  /// Finds the opposite side of a circle from a given point `pt` when travelling along the
  /// vector `heading`. Returns False if the ray projected from point `pt` misses the circle.
  ///
  /// @lib
  function DistantPointOnCircleWithVector(const pt, center: Point2D; radius: Single; heading: Vector; out oppositePt: Point2D): Boolean;
  
  /// @lib PointAt
  function PointAt(x, y: Single): Point2D; overload;
  
  /// @lib PointAtStartWithOffset
  function PointAt(const startPoint: Point2D; offset: Vector): Point2D; overload;
  
  /// @lib
  function RectangleCenter(const rect: Rectangle): Point2D;
  
  /// @lib LinesFromRect
  function LinesFromRect(const rect: Rectangle): LinesArray;
  
  /// @lib LinesFromTriangle
  function LinesFrom(const tri: Triangle): LinesArray;

  /// @lib
  function LineFrom(x1, y1, x2, y2: Single): LineSegment;
  
  /// @lib LineFromPointToPoint
  function LineFrom(pt1, pt2: Point2D): LineSegment;

  /// @lib LineFromVectorWithStartPoint
  function LineFromVector(const pt: Point2D; const mv: Vector): LineSegment; overload;
  
  /// @lib LineFromVectorWithStartXY
  function LineFromVector(x, y: Single; const mv: Vector): LineSegment; overload;
  /// @lib
  function LineFromVector(const mv: Vector): LineSegment; overload;

  /// @lib
  function LineMidPoint(const line: LineSegment): Point2D;

  /// @lib
  function RectangleFrom(x, y: Single; w, h: LongInt): Rectangle; overload;
  /// @lib RectangleForBitmap
  function RectangleFrom(bmp: Bitmap): Rectangle; overload;
  /// @lib RectangleForBitmapAtXY
  function RectangleFrom(x, y: Single; bmp: Bitmap): Rectangle; overload;
  /// @lib RectangleForBitmapAtPoint
  function RectangleFrom(const pt: Point2D; bmp: Bitmap): Rectangle; overload;
  /// @lib RectangleAtPoint
  function RectangleFrom(const pt: Point2D; width, height: LongInt): Rectangle; overload;
  /// @lib RectangleFromSprite
  function RectangleFrom(s: Sprite): Rectangle; overload;
  /// @lib RectangleFromLine
  function RectangleFrom(const line: LineSegment): Rectangle; overload;
  /// @lib RectangleFromCircle
  function RectangleFrom(const center: Point2D; radius: Single): Rectangle; overload;
  /// @lib RectangleFromTriangle
  function RectangleFrom(const tri: Triangle): Rectangle; overload;
  /// @lib RectangleFromLines
  function RectangleFrom(const lines: LinesArray): Rectangle; overload;
  
  /// @lib
  function TriangleFrom(ax, ay, bx, by, cx, cy: Single): Triangle; overload;

  /// @lib TriangleFromPoints
  function TriangleFrom(const a, b, c: Point2D): Triangle; overload;

  /// @lib
  function TriangleBarycenter(const tri: Triangle): Point2D;
  
  /// @lib
  function RectangleAfterMove(const rect: Rectangle; const mv: Vector): Rectangle;

  /// @lib
  function RectangleTop (const rect: Rectangle): Single;
  /// @lib
  function RectangleBottom(const rect: Rectangle): Single;
  /// @lib
  function RectangleLeft  (const rect: Rectangle): Single;
  /// @lib
  function RectangleRight (const rect: Rectangle): Single;
  
  /// @lib
  function RectanglesIntersect(const rect1, rect2: Rectangle): Boolean;
  
  /// @lib
  function Intersection(const rect1, rect2: Rectangle): Rectangle;
  
  /// @lib
  function GetLineIntersectionPoint(const line1, line2: LineSegment; out pt: Point2D) : boolean;
  
  /// @lib
  function GetRayIntersectionPoint(const fromPt: Point2D; const heading: Vector; const line: LineSegment; out pt: Point2D) : boolean;
  
  /// @lib
  function LineIntersectsLines(const line: LineSegment; const lines: LinesArray): boolean;
  
  /// @lib
  function LineIntersectsRect(const line: LineSegment; const rect: Rectangle): boolean;
  
  
  
  
  //---------------------------------------------------------------------------
  // Point test operations
  //---------------------------------------------------------------------------
  
  /// Returns true if the point `pt` is in the Triangle `tri`.
  ///
  /// @lib
  function PointInTriangle(const pt: Point2D; const tri: Triangle): Boolean;
  
  /// @lib PointInRectXY
  function PointInRect(const pt: Point2D; x, y, w, h: Single): Boolean; overload;
  
  /// Returns True if point `pt` is in the Rectangle `rect`.
  ///
  /// @lib 
  function PointInRect(const pt: Point2D; const rect: Rectangle): Boolean; overload;
  
  /// @lib PointXYInRectXY
  function PointInRect(ptX, ptY, x, y, w, h: Single): Boolean; overload;
  
  /// @lib PointXYInRect
  function PointInRect(x, y: Single; const rect: Rectangle): Boolean; overload;
  
  /// Returns True if the point `pt` is in the circle.
  ///
  /// @lib
  function PointInCircle(const pt, center: Point2D; radius: Single): Boolean;
  
  /// Returns True if point `pt` is on the line segment `line`.
  ///
  /// @lib PointOnLine
  function PointOnLine(const pt: Point2D; const line: LineSegment): Boolean;
  
  //---------------------------------------------------------------------------
  // Vector Creation and Operations
  //---------------------------------------------------------------------------
  
  /// Returns a new `Vector` using the ``x`` and ``y`` values provided. 
  ///
  /// @lib VectorFrom(x, y, False)
  /// @uname VectorFrom
  function VectorFrom(x, y: Single): Vector; overload;
  
  
  /// Creates a new `Vector` with the ``x`` and ``y`` values provided, and will 
  /// invert the ``y`` value if the `invertY`` parameter is True. The inversion 
  /// of the ``y`` value provides a convienient option for handling screen 
  /// related vectors.
  ///
  /// @lib
  /// @uname VectorFromWithInvertY
  function VectorFrom(x, y: Single; invertY: boolean): Vector; overload;
  
  /// Adds the two parameter vectors (``v1`` and ``v2``) together and returns 
  /// the result as a new `Vector`.
  ///
  /// @lib
  function AddVectors(const v1, v2: Vector): Vector;
  
  /// Subtracts the second vector parameter (``v2``) from the first vector 
  /// (``v1``) and returns the result as new `Vector`.
  ///
  /// @lib
  function SubtractVectors(const v1, v2: Vector): Vector;
  
  /// Multiplies each component (``x`` and ``y`` values) of the ``v1`` vector 
  /// by the ``s`` scalar value and returns the result as a new `Vector`.
  /// 
  /// @lib
  function VectorMultiply(const v: Vector; s: Single): Vector;
  
  /// Calculates the dot product (scalar product) between the two vector 
  /// parameters  rovided (``v1`` and ``v2``). It returns the result as a 
  /// scalar value.
  ///
  /// If the result is 0.0 it means that the vectors are orthogonal (at right
  /// angles to each other). If ``v1`` and ``v2`` are unit vectors (length of 
  /// 1.0) and the dot product is 1.0, it means that ``v1`` and ``v2`` vectors 
  /// are parallel.
  ///
  /// @lib
  function DotProduct(const v1, v2: Vector): Single;
  
  /// Returns a new `Vector` that is perpendicular ("normal") to the parameter
  /// vector ``v`` provided. The concept of a "normal" vector is usually 
  /// extracted from (or associated with) a line. See `LineNormal`. 
  ///
  /// @lib
  function VectorNormal(const v: Vector): Vector;
  
  /// Returns a unit vector (lenght is 1.0) that is "normal" (prependicular) to
  /// the ``line`` parameter. A normal vector is useful for calculating the
  /// result of a collision such as sprites bouncing off walls (lines).
  /// @lib
  function LineNormal(const line: LineSegment): Vector;
  
  /// Returns a new Vector that is an inverted version of the parameter 
  /// vector (v). In other words, the -/+ sign of the x and y values are changed.
  ///
  /// @lib
  function InvertVector(const v: Vector): Vector;
  
  /// Returns a new `Vector` that is a based on the parameter `v` however
  /// its magnitude (length) will be limited (truncated) if it exceeds the 
  /// specified limit value.
  ///
  /// @lib
  function LimitVector(const v: Vector; limit: Single): Vector;

  /// Returns the unit vector of the parameter vector (v). The unit vector has a
  /// magnitude of 1, resulting in a vector that indicates the direction of
  /// the original vector.
  ///
  /// @lib
  function UnitVector(const v: Vector): Vector;

  /// Test to see if the ``x`` and ``y`` components of the provided vector 
  /// parameter ``v`` are zero. 
  /// 
  /// @lib
  function VectorIsZero(const v: Vector): Boolean;

  /// Returns the magnitude (or "length") of the parameter vector (v) as a 
  /// scalar value.
  ///
  /// @lib
  function VectorMagnitude(const v: Vector): Single;
  
  /// Returns the squared magnitude (or "length") of the parameter vector (v) as a 
  /// scalar value.
  ///
  /// @lib
  function VectorMagnitudeSq(const v: Vector): Single;
  
  
  /// Returns a new `Vector` created using the angle and magnitude (length). 
  /// The angle and magnitude are scalar values and the angle is in degrees.
  ///
  /// @lib
  function VectorFromAngle(angle, magnitude: Single): Vector;
  
  /// Returns a new `Vector` using the x and y value of a Point2D parameter.
  ///
  /// @lib
  function VectorFromPoint(const p1: Point2D): Vector;
  
  /// Returns a `Vector` created from the difference from the ``p1`` to 
  /// the second ``p2`` points (`Point2D`).
  ///
  /// @lib
  function VectorFromPoints(const p1, p2: Point2D): Vector;
  
  /// Returns a new `Vector` created from the start and end points of a 
  /// `lineSegment`. Useful for calculating angle vectors or extracting a 
  /// normal vector (see `LineNormal`) for the line.
  ///
  /// @lib
  function LineAsVector(const line: lineSegment): Vector;
  
  //TODO: are these really "point" in rect test?
  /// Return true if the vector (used as a point) is within the rectangle
  /// @lib
  function VectorInRect(const v: Vector; x, y, w, h: Single): Boolean; overload;

  /// @lib VectorInRectangle
  function VectorInRect(const v: Vector; const rect: Rectangle): Boolean; overload;
  
  /// @lib VectorFromPointToRect
  function VectorFromPointToRect(x, y, rectX, rectY: Single; rectWidth, rectHeight: LongInt): Vector; overload;
  
  /// @lib VectorFromPointToRectangle
  function VectorFromPointToRect(x, y: Single; const rect: Rectangle): Vector; overload;
  
  /// @lib VectorFromPointPtToRectangle
  function VectorFromPointToRect(const pt: Point2D; const rect: Rectangle): Vector; overload;
  
  /// Determines the vector needed to move from x, y out of rectangle assuming movement specified
  /// @lib
  function VectorOutOfRectFromPoint(const pt: Point2D; const rect: Rectangle; const movement: Vector): Vector; 
  
  /// @lib
  function VectorOutOfRectFromRect(const srcRect, targetRect: Rectangle; const movement: Vector): Vector;  
  
  /// @lib
  function VectorOutOfCircleFromPoint(const pt, center: Point2D; radius: Single; const movement: Vector): Vector;
  
  /// @lib
  function VectorOutOfCircleFromCircle(const pt: Point2D; radius: Single; const center: Point2D; radius2: Single; const movement: Vector): Vector;
  
  /// @lib
  function VectorOutOfRectFromCircle(const center: Point2D; radius: Single; const rect: Rectangle; const movement: Vector): Vector;
  
  //TODO: OverLine...
  /// @lib
  function VectorOverLinesFromCircle(const center: Point2D; radius: Single; lines: LinesArray; movement: Vector; out maxIdx: Integer): Vector;
  
  //---------------------------------------------------------------------------
  // Angle Calculation
  //---------------------------------------------------------------------------

  /// @lib
  function CalculateAngle(x1, y1, x2, y2: Single): Single; overload;

  // / @lib CalculateAngleFromPoints
  //function CalculateAngle(const pt1, pt2: Point2D): Single; overload;

  /// @lib CalculateAngleFromSprites
  /// @class Sprite
  /// @method AngleTo
  function CalculateAngle(s1, s2: Sprite): Single; overload;

  /// @lib CalculateAngleFromVectors
  function CalculateAngle(const v1, v2: Vector): Single; overload;

  //---------------------------------------------------------------------------
  // Distance / Magnitude Calculation
  //---------------------------------------------------------------------------

  /// @lib
  function LineMagnitudeSq(x1, y1, x2, y2: single): Single; overload;

  /// @lib LineMagnitudeSqFromLine
  function LineMagnitudeSq(const line: LineSegment): Single; overload;

  /// @lib
  function PointPointDistance(const pt1, pt2: Point2D): Single;



  //---------------------------------------------------------------------------
  // Matrix2D Creation and Operations
  //---------------------------------------------------------------------------
  
  /// @lib
  /// @class Matrix2D
  /// @static
  /// @method TranslationMatrix
  function TranslationMatrix(dx, dy: Single): Matrix2D;
  
  /// @lib
  /// @class Matrix2D
  /// @static
  /// @method ScaleMatrix
  function ScaleMatrix(scale: Single): Matrix2D;

  /// @lib
  /// @class Matrix2D
  /// @static
  /// @method RotationMatrix
  function RotationMatrix(deg: Single): Matrix2D;
  
  /// Multiplies the two `Matrix2D` parameters, ``m1`` by ``m2``, and returns
  /// the result as a new `Matrix2D`. Use this to combine the effects to two 
  /// matrix transformations.
  ///
  /// @lib
  /// @class Matrix2D
  /// @method Multiply
  function MatrixMultiply(const m1, m2: Matrix2D): Matrix2D; overload;

  /// Multiplies the `Vector` parameter ``v`` with the `Matrix2D` ``m`` and 
  /// returns the result as a `Vector`. Use this to transform the vector with 
  /// the matrix (to apply scaling, rotation or translation effects).
  ///
  /// @lib MatrixMultiplyVector
  /// @class Matrix2D
  /// @overload Multiply MultiplyVector
  function MatrixMultiply(const m: Matrix2D; const v: Vector): Vector; overload;

  // / Multiplies the Point2D parameter `pt` with the Matrix2D `m` and returns 
  // / the result as a `Point2D`. Use this to transform the point with the 
  // / matrix (to apply scaling, rotation or translation effects).
  // /
  // / @lib MatrixMultiplyPoint
  // / @class Matrix2D
  // / @overload Multiply MultiplyPoint
  //function MatrixMultiply(const m: Matrix2D; const pt: Point2D): Point2D; overload;
  
  /// @lib
  procedure ApplyMatrix(const m: Matrix2D; var tri: Triangle);
  
  
  
  //----------------------------------------------------------------------------
  // Cos/Sin/Tan accepting degrees
  //----------------------------------------------------------------------------
  
  /// Returns the cosine of the passed in angle (in degrees).
  ///
  /// @lib
  function Cos(angle: Single): Single;
  
  /// Returns the sine of the passed in angle (in degrees).
  ///
  /// @lib
  function Sin(angle: Single): Single;
  
  /// Returns the tangent of the passed in angle (in degrees).
  ///
  /// @lib
  function Tan(angle: Single): Single;
  
  
  
//----------------------------------------------------------------------------
implementation
//----------------------------------------------------------------------------

  uses 
    Classes, SysUtils, Math,  // system
    sgCore, sgCamera, sgGraphics, sgSprites, sgPhysics, sgShared;     // SwinGame
  
  const 
    DEG_TO_RAD = 0.0174532925;
  
  //---------------------------------------------------------------------------
  // Vector operations on Vectors (usally returning vectors)
  //---------------------------------------------------------------------------


  function VectorFrom(x, y: Single; invertY: boolean): Vector; overload;
  begin
    {$IFDEF TRACE}
      TraceEnter('sgGeometry', 'VectorFrom');
    {$ENDIF}

    if invertY then y := y * -1;

    result.x := x;
    result.y := y;
    //result.w := 1;
  
    {$IFDEF TRACE}
      TraceExit('sgGeometry', 'VectorFrom');
    {$ENDIF}
  end;

  function VectorFrom(x, y: Single): Vector; overload;
  begin
    result := VectorFrom(x, y, false);
  end;

  function VectorFromPoint(const p1: Point2D): Vector;
  begin
    result := VectorFrom(p1.x, p1.y);
  end;

  function VectorFromPoints(const p1, p2: Point2D): Vector;
  begin
    result := VectorFrom(p2.x - p1.x, p2.y - p1.y, false);
  end;

  function AddVectors(const v1, v2: Vector): Vector;
  begin
    result.x := v1.x + v2.x;
    result.y := v1.y + v2.y;
  end;

  function SubtractVectors(const v1, v2: Vector): Vector;
  begin
    result.x := v1.x - v2.x;
    result.y := v1.y - v2.y;
  end;

  function VectorMultiply(const v: Vector; s: Single): Vector;
  begin
    result.x := v.x * s;
    result.y := v.y * s;
  end;

  function InvertVector(const v: Vector): Vector;
  begin
    result.x := v.x * -1;
    result.y := v.y * -1;
  end;

  function LimitVector(const v: Vector; limit: Single): Vector;
  var
    mag: Single;
    tmp: Vector;
  begin
    mag := VectorMagnitude(v);
    if mag > limit then 
    begin
      tmp := UnitVector(v);
      result.x := tmp.x * limit;
      result.y := tmp.y * limit;
      //result := VectorMultiply(UnitVector(v), limit);
      //result := Multiply(ScaleMatrix(limit), GetUnitVector(v));
    end
    else
      result := v;
  end;

  function UnitVector(const v: Vector): Vector;
  var
    mag, tmp: Single; 
  begin
    mag := VectorMagnitude(v);
  
    if mag = 0 then
      tmp := 0
    else
      tmp := 1 / mag; //VectorMagnitude(v);
  
    result.x := tmp * v.x;
    result.y := tmp * v.y;
  end;

  function VectorIsZero(const v: Vector): Boolean;
  begin
    result := (v.x = 0) and (v.y = 0);
  end;

  function VectorMagnitude(const v: Vector): Single;
  begin
    result := Sqrt((v.x * v.x) + (v.y * v.y));
  end;
  
  function VectorMagnitudeSq(const v: Vector): Single;
  var
    m: Single;
  begin
    m := VectorMagnitude(v);
    result := m * m;
  end;

  function DotProduct(const v1, v2: Vector): Single;
  begin
    result := (v1.x * v2.x) + (v1.y * v2.y);
  end;

  function VectorFromAngle(angle, magnitude: Single): Vector;
  begin
    result := VectorFrom(magnitude * sgGeometry.Cos(angle), magnitude * sgGeometry.Sin(angle));
  end;

  function LineAsVector(const line: lineSegment): Vector;
  begin
    result.x := line.endPoint.x - line.startPoint.x;
    result.y := line.endPoint.y - line.startPoint.y;
  end;

  function VectorNormal(const v: Vector): Vector;
  var   
    //sqrY, sqrX, 
    tmp: Single;
  begin
    //sqrX := vect.x * vect.x;
    //sqrY := vect.y * vect.y;
    tmp := Sqrt( (v.x * v.x) + (v.y * v.y) );
    result.x := -v.y / tmp; // -S2y / ::sqrt(S2y*S2y + S2x*S2x);
    result.y :=  v.x / tmp; //  S2x / ::sqrt(S2y*S2y + S2x*S2x);
  end;

  function LineNormal(const line: LineSegment): Vector;
  begin
    result := VectorNormal(LineAsVector(line));
  end;

  
  //---------------------------------------------------------------------------
  // Angle Calculation 
  //---------------------------------------------------------------------------


  function CalculateAngle(x1, y1, x2, y2: Single): Single; overload;
  var
    o, a, oa, rads: Single;
  begin
    if (x1 = x2) and (y2 < y1) then result := -90
    else if (x1 = x2) and (y2 >= y1) then result := 90
    else if (y1 = y2) and (x2 < x1) then result := 180
    else if (y1 = y2) and (x2 >= x1) then result := 0
    else
    begin
      o := (y2 - y1);
      a := (x2 - x1);
      oa := o / a;
      rads := arctan(oa);
      result := RadToDeg(rads);

      if x2 < x1 then
      begin
        if (y2 < y1) then result := result - 180
        else result := result + 180;
      end;
    end;
  end;

  // function CalculateAngle(const pt1, pt2: Point2D): Single; overload;
  // begin
  //   result := CalculateAngle(pt1.x, pt1.y, pt2.x, pt2.y);
  // end;

  function CalculateAngle(s1, s2: Sprite): Single; overload;
  var
    cx1, cy1, cx2, cy2: Single;
  begin
    cx1 := s1^.x + CurrentWidth(s1) / 2;
    cy1 := s1^.y + CurrentHeight(s1) / 2;
    cx2 := s2^.x + CurrentWidth(s2) / 2;
    cy2 := s2^.y + CurrentHeight(s2) / 2;

    result := CalculateAngle(cx1, cy1, cx2, cy2);
  end;

  function CalculateAngle(const v1, v2: Vector): Single; overload;
  var
    t1, t2: Single;
  begin
    t1 := CalculateAngle(0, 0, v1.x, v1.y);
    t2 := CalculateAngle(0, 0, v2.x, v2.y);
  
    result := t2 - t1;
  
    if result > 180 then result := result - 360
    else if result <= -180 then result := result + 360
  end;


  //----------------------------------------------------------------------------
  // Distance / Magnitude Calculations
  //----------------------------------------------------------------------------

  //
  //  Returns the square of the magnitude of the line
  //    to cut down on unnecessary Sqrt when in many cases
  //    DistancePointLine() squares the result
  //
  function LineMagnitudeSq(const line: LineSegment): Single; overload;
  begin
    result := (line.endPoint.x - line.startPoint.x) * (line.endPoint.x - line.startPoint.x) +
              (line.endPoint.y - line.startPoint.y) * (line.endPoint.y - line.startPoint.y);
  end;

  function LineMagnitudeSq(x1, y1, x2, y2: single): single; overload;
  begin
   result := (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
  end;

  function PointPointDistance(const pt1, pt2: Point2D): Single;
  var
    temp: Vector;
  begin
    temp := VectorFrom(pt2.x - pt1.x, pt2.y - pt1.y);
    result := VectorMagnitude(temp);
  end;
  
  //----------------------------------------------------------------------------
  // Matrix2D Creation and Operation / Translation of Point/Vector Types
  //----------------------------------------------------------------------------

  function RotationMatrix(deg: Single): Matrix2D;
  var
    rads: Double;
  begin
    rads := -deg * DEG_TO_RAD;

    result[0, 0] := System.Cos(rads);
    result[0, 1] := System.Sin(rads);
    result[0, 2] := 0;
  
    result[1, 0] := -System.Sin(rads);
    result[1, 1] := System.Cos(rads);
    result[1, 2] := 0;
  
    result[2, 0] := 0;
    result[2, 1] := 0;
    result[2, 2] := 1;
  end;

  function ScaleMatrix(scale: Single): Matrix2D;
  begin
    result[0, 0] := scale;
    result[0, 1] := 0;
    result[0, 2] := 0;

    result[1, 0] := 0;
    result[1, 1] := scale;
    result[1, 2] := 0;

    result[2, 0] := 0;
    result[2, 1] := 0;
    result[2, 2] := 1;
  end;

  function TranslationMatrix(dx, dy: Single): Matrix2D;
  begin
    result := ScaleMatrix(1);

    result[0, 2] := dx;
    result[1, 2] := dy;
  end;

  function MatrixMultiply(const m1, m2: Matrix2D): Matrix2D; overload;
    // procedure ShowMatrix(const m: Matrix2D);
    // var
    //   i, j: LongInt;
    // begin
    //   WriteLn('---');
    //   for i := 0 to 2 do
    //   begin
    //     Write('|');
    //     for j := 0 to 2 do
    //     begin
    //       Write(' ', m[i,j]);
    //     end;
    //     WriteLn('|');
    //   end;
    //   WriteLn('---');
    // end;
  begin
      //unwound for performance optimisation
    result[0, 0] := m1[0, 0] * m2[0, 0] +
                    m1[0, 1] * m2[1, 0] +
                    m1[0, 2] * m2[2, 0];
    result[0, 1] := m1[0, 0] * m2[0, 1] +
                    m1[0, 1] * m2[1, 1] +
                    m1[0, 2] * m2[2, 1];
    result[0, 2] := m1[0, 0] * m2[0, 2] +
                    m1[0, 1] * m2[1, 2] +
                    m1[0, 2] * m2[2, 2];

    result[1, 0] := m1[1, 0] * m2[0, 0] +
                    m1[1, 1] * m2[1, 0] +
                    m1[1, 2] * m2[2, 0];
    result[1, 1] := m1[1, 0] * m2[0, 1] +
                    m1[1, 1] * m2[1, 1] +
                    m1[1, 2] * m2[2, 1];
    result[1, 2] := m1[1, 0] * m2[0, 2] +
                    m1[1, 1] * m2[1, 2] +
                    m1[1, 2] * m2[2, 2];

    result[2, 0] := m1[2, 0] * m2[0, 0] +
                    m1[2, 1] * m2[1, 0] +
                    m1[2, 2] * m2[2, 0];
    result[2, 1] := m1[2, 0] * m2[0, 1] +
                    m1[2, 1] * m2[1, 1] +
                    m1[2, 2] * m2[2, 1];
    result[2, 2] := m1[2, 0] * m2[0, 2] +
                    m1[2, 1] * m2[1, 2] +
                    m1[2, 2] * m2[2, 2];
  end;

  function MatrixMultiply(const m: Matrix2D; const v: Vector): Vector; overload;
  begin
    result.x := v.x * m[0,0]  +  v.y * m[0,1] + m[0,2]; 
    result.y := v.x * m[1,0]  +  v.y * m[1,1] + m[1,2]; 
  end;

  // function MatrixMultiply(const m: Matrix2D; const pt: Point2D): Point2D; overload;
  // begin
  //   result.x := pt.x * m[0,0] + pt.y * m[0,1] + m[0,2];
  //   result.y := pt.x * m[1,0] + pt.y * m[1,1] + m[1,2];
  // end;


  procedure ApplyMatrix(const m: Matrix2D; var tri: Triangle);
  begin
    tri[0] := MatrixMultiply(m, tri[0]);
    tri[1] := MatrixMultiply(m, tri[1]);
    tri[2] := MatrixMultiply(m, tri[2]);
  end;
  
  //----------------------------------------------------------------------------
  // Cos/Sin/Tan accepting degrees
  //----------------------------------------------------------------------------
  
  function Cos(angle: Single): Single;
  begin
    result := System.Cos(DegToRad(angle));
  end;
  
  function Sin(angle: Single): Single;
  begin
    result := System.Sin(DegToRad(angle));
  end;
  
  function Tan(angle: Single): Single;
  begin
    result := Math.Tan(DegToRad(angle));
  end;
  
  const
    EPS    = 0.01;         // smallest positive value: less than that to be considered zero
    EPSEPS = EPS * EPS;        // and its square



  function PointLineDistance(x, y: Single; const line: LineSegment): Single; overload;
  begin
    result := PointLineDistance(PointAt(x, y), line);
  end;

  function PointLineDistance(const pt: Point2D; const line: LineSegment): Single; overload;
  var
    sqLineMag, u: Single;
    intersect: Point2D;
  begin
    // see Paul Bourke's original article(s)
    // square of line's magnitude (see note in function LineMagnitude)
    sqLineMag := LineMagnitudeSq(line);
    if SqLineMag < EPSEPS then
    begin
      raise Exception.Create('Cannot determine intersection point on line, line is too short');
    end;

    //squared unit vector
    u := ( (pt.x - line.startPoint.x) * (line.endPoint.x - line.startPoint.x) +
           (pt.y - line.startPoint.y) * (line.endPoint.y - line.startPoint.y) ) / sqLineMag;

    if (u < EPS) or (u > 1) then
    begin
      //  Closest point does not fall within the line segment,
      //    take the shorter distance to an endpoint
      intersect.x := LineMagnitudeSq(pt.x, pt.y, line.startPoint.x, line.startPoint.y);
      intersect.y := LineMagnitudeSq(pt.x, pt.y, line.endPoint.x, line.endPoint.y);
      result := min(intersect.x, intersect.y);
    end //  if (u < EPS) or (u > 1)
    else
    begin
      //  Intersecting point is on the line, use the formula
      intersect.x := line.startPoint.x + u * (line.endPoint.x - line.startPoint.x);
      intersect.y := line.startPoint.y + u * (line.endPoint.y - line.startPoint.y);
      result := LineMagnitudeSq(pt.x, pt.y, intersect.x, intersect.y);
    end; //  else NOT (u < EPS) or (u > 1)

    // finally convert to actual distance not its square
    result := sqrt(result);
  end;
  
  function ClosestPointOnCircle(const fromPt, center: Point2D; radius: Single): Point2D;
  begin
    //result := AddVectors(VectorMultiply(UnitVector(VectorFromPoints(fromPt, center)), radius), center);
    result := AddVectors(VectorMultiply(UnitVector(VectorFromPoints(center, fromPt)), radius), center);
  end;
  
  function ClosestPointOnLine(x, y: Single; const line: LineSegment): Point2D; overload;
  begin
    result := ClosestPointOnLine(PointAt(x, y), line);
  end;
  
  function ClosestPointOnLine(const fromPt: Point2D; const line: LineSegment): Point2D; overload;
  var
    sqLineMag, u: Single;
  begin
    // see Paul Bourke's original article(s)
    // square of line's magnitude (see note in function LineMagnitude)
    sqLineMag := LineMagnitudeSq(line);
    if SqLineMag < EPSEPS then
    begin
      raise Exception.Create('Cannot determine intersection point on line, line is too short');
    end;

    u := ( (fromPt.x - line.startPoint.x)*(line.endPoint.x - line.startPoint.x) + (fromPt.y - line.startPoint.y) * (line.endPoint.y - line.startPoint.y) ) / sqLineMag;

    if (u < EPS) or (u > 1) then
    begin
      //  Closest point does not fall within the line segment,
      //    take the shorter distance to an endpoint
      if LineMagnitudeSq(fromPt.x, fromPt.y, line.startPoint.x, line.startPoint.y) < LineMagnitudeSq(fromPt.x, fromPt.y, line.endPoint.x, line.endPoint.y) then
        result := line.startPoint
      else
        result := line.endPoint;
    end //  if (u < EPS) or (u > 1)
    else
    begin
      //  Intersecting point is on the line, use the formula
      result.x := line.startPoint.x + u * (line.endPoint.x - line.startPoint.x);
      result.y := line.startPoint.y + u * (line.endPoint.y - line.startPoint.y);
    end; //  else NOT (u < EPS) or (u > 1)
  end;
  
  function ClosestPointOnRectFromCircle(const center: Point2D; radius: Single; const rect: Rectangle): Point2D;
  begin
    result := ClosestPointOnLinesFromCircle(center, radius, LinesFromRect(rect));
  end;
  
  function ClosestPointOnLinesFromCircle(const center: Point2D; radius: Single; const lines: LinesArray): Point2D;
  var
    i, min: Integer;
    pts: Array of Point2D;
    dst, minDist: Single;
  begin
    SetLength(pts, Length(lines));
    minDist := -1;
    min := 0;
    
    for i := Low(lines) to High(lines) do
    begin
      pts[i] := ClosestPointOnLine(center, lines[i]);
      dst := PointPointDistance(pts[i], center);
      if (minDist > dst) or (minDist < 0) then
      begin
        minDist := dst;
        min := i;
      end;
    end;
    
    result := pts[min];
  end;
  
  function RectangleFrom(const center: Point2D; radius: Single): Rectangle; overload;
  begin
    if radius < 0 then radius := -radius;
    
    result.x := center.x - radius;
    result.y := center.y - radius;
    result.width := Round(2 * radius);
    result.height := Round(result.width);
  end;
  
  function RectangleFrom(const tri: Triangle): Rectangle; overload;
  var
    minX, minY, maxX, maxY: Single;
    i: Integer;
  begin
    minX := tri[0].x; maxX := tri[0].x;
    minY := tri[0].y; maxY := tri[0].y;
    
    for i := 1 to 2 do
    begin
      if tri[i].x < minX then minX := tri[i].x
      else if tri[i].x > maxX then maxX := tri[i].x;
      
      if tri[i].y < minY then minY := tri[i].y
      else if tri[i].y > maxY then maxY := tri[i].y;
    end;
    
    result.x := minX;
    result.y := minY;
    result.width := Ceiling(maxX - minX);
    result.height := Ceiling(maxY - minY);
  end;
  
  function RectangleFrom(const lines: LinesArray): Rectangle; overload;
  var
    minX, minY, maxX, maxY: Single;
    i: Integer;
  begin
    if Length(lines) = 0 then exit;
    
    minX := lines[0].startPoint.x; maxX := lines[0].startPoint.x;
    minY := lines[0].startPoint.y; maxY := lines[0].startPoint.y;
    
    for i := 0 to High(lines) do
    begin
      if lines[i].startPoint.x < minX then minX := lines[i].startPoint.x
      else if lines[i].startPoint.x > maxX then maxX := lines[i].startPoint.x;
      
      if lines[i].startPoint.y < minY then minY := lines[i].startPoint.y
      else if lines[i].startPoint.y > maxY then maxY := lines[i].startPoint.y;
      
      if lines[i].endPoint.x < minX then minX := lines[i].endPoint.x
      else if lines[i].endPoint.x > maxX then maxX := lines[i].endPoint.x;
      
      if lines[i].endPoint.y < minY then minY := lines[i].endPoint.y
      else if lines[i].endPoint.y > maxY then maxY := lines[i].endPoint.y;
    end;
    
    result.x := minX;
    result.y := minY;
    result.width := Ceiling(maxX - minX);
    result.height := Ceiling(maxY - minY);
  end;
  
  function RectangleFrom(const line: LineSegment): Rectangle; overload;
  begin
    result.x := Min(line.startPoint.x, line.endPoint.x);
    result.y := Min(line.startPoint.y, line.endPoint.y);
    result.width := Round(Max(line.startPoint.x, line.endPoint.x) - result.x);
    result.height := Round(Max(line.startPoint.y, line.endPoint.y) - result.y);
  end;
    
  function PointOnLine(const pt: Point2D; const line: LineSegment): Boolean;
  const SMALL = 0.9;
    function SimpleComparisonXSame(): Boolean;
    var
      minY, maxY: Single;
    begin
      minY := Min(line.startPoint.y, line.endPoint.Y);
      maxY := Max(line.startPoint.y, line.endPoint.Y);
      
      result := 
        (pt.x >= line.startPoint.x - SMALL) and (pt.x <= line.startPoint.x + SMALL) and
        (pt.y >= minY) and (pt.y <= maxY);
    end;
    
    function SimpleComparisonYSame(): Boolean;
    var
      minX, maxX: Single;
    begin
      minX := Min(line.startPoint.x, line.endPoint.x);
      maxX := Max(line.startPoint.x, line.endPoint.x);
      
      result := 
        (pt.y >= line.startPoint.y - SMALL) and (pt.y <= line.startPoint.y + SMALL) and
        (pt.x >= minX) and (pt.x <= maxX);
    end;
  var
    sqLineMag, lx, ly, m, c : Single;
  begin
    //Lines Magnitude must be at least 0.0001
    sqLineMag := LineMagnitudeSq(line);
    if SqLineMag < EPSEPS then
    begin
      raise Exception.Create('Cannot determine if point is on line, line is too short');
    end;
          
    //Obtain the other variables for the Line Algorithm
    if line.endPoint.x = line.startPoint.x then
    begin
      result := SimpleComparisonXSame();
      exit;
    end;
    if line.endPoint.y = line.startPoint.y then
    begin
      result := SimpleComparisonYSame();
      exit;     
    end;
    
    m := (line.endPoint.y - line.startPoint.y) / (line.endPoint.x - line.startPoint.x);
    c := line.startPoint.y - (m * line.startPoint.x);

    ly := (m * pt.x) + c;
    lx := (pt.y - c) / m;

    result := (lx >= pt.x - SMALL) and
              (lx <= pt.x + SMALL) and
              (ly >= pt.y - SMALL) and
              (ly <= pt.y + SMALL) and
              PointInRect(pt, RectangleFrom(line));
  end;
  
  function LineFrom(pt1, pt2: Point2D): LineSegment;
  begin
    result := LineFrom(pt1.x, pt1.y, pt2.x, pt2.y);
  end;
  
  function LineFrom(x1, y1, x2, y2: Single): LineSegment;
  begin
    result.startPoint.x := x1;
    result.startPoint.y := y1;
    result.endPoint.x := x2;
    result.endPoint.y := y2;
  end;
  
  function LinesFrom(const tri: Triangle): LinesArray;
  begin
    SetLength(result, 3);
    result[0] := LineFrom(tri[0], tri[1]);
    result[1] := LineFrom(tri[1], tri[2]);
    result[2] := LineFrom(tri[2], tri[0]);
  end;
  
  function LinesFromRect(const rect: Rectangle): LinesArray;
  begin
    SetLength(result, 4);
    with rect do
    begin
      result[0] := LineFrom(x, y, x + width, y);
      result[1] := LineFrom(x, y, x, y + height);
      result[2] := LineFrom(x + width, y, x + width, y + height);
      result[3] := LineFrom(x, y + height, x + width, y + height);
    end;
  end;
  
  function RectangleCenter(const rect: Rectangle): Point2D;
  begin
    result.x := rect.x + (rect.width / 2);
    result.y := rect.y + (rect.height / 2);
  end;
  
  
  function PointAt(x, y: Single): Point2D; overload;
  begin
    result.x := x;
    result.y := y;
  end;
  
  function PointAt(const startPoint: Point2D; offset: Vector): Point2D; overload;
  begin
    result.x := startPoint.x + offset.x;
    result.y := startPoint.y + offset.y;
  end;

  function LineFromVector(const pt: Point2D; const mv: Vector): LineSegment; overload;
  begin
    result := LineFromVector(pt.x, pt.Y, mv);
  end;
  
  function LineFromVector(x, y: Single; const mv: Vector): LineSegment; overload;
  begin
    result.startPoint.x := x;
    result.startPoint.y := y;
    result.endPoint.x := x + mv.x;
    result.endPoint.y := y + mv.y;
  end;
  
  function LineFromVector(const mv: Vector): LineSegment; overload;
  begin
    result := LineFromVector(0, 0, mv);
  end;

  function RectangleAfterMove(const rect: Rectangle; const mv: Vector): Rectangle;
  begin
    result := rect;
    result.x := result.x + mv.x;
    result.y := result.y + mv.y;
  end;
  
  function RectangleTop(const rect: Rectangle): Single;
  begin
    if rect.height > 0 then result := rect.y
    else result := rect.y + rect.height - 1; //add negative height
  end;
  
  function RectangleBottom(const rect: Rectangle): Single;
  begin
    if rect.height > 0 then result := rect.y + rect.height - 1
    else result := rect.y; //y is bottom most
  end;

  function RectangleLeft(const rect: Rectangle): Single;
  begin
    if rect.width > 0 then result := rect.x
    else result := rect.x + rect.width - 1; //add negative width
  end;

  function RectangleRight(const rect: Rectangle): Single;
  begin
    if rect.width > 0 then result := rect.x + rect.width - 1
    else result := rect.x; //x is right most
  end;

  function RectangleFrom(x, y: Single; w, h: LongInt): Rectangle; overload;
  begin
    result.x := x;
    result.y := y;
    result.width := w;
    result.height := h;
  end;
  
  function RectangleFrom(s: Sprite): Rectangle;
  begin
    result := RectangleFrom(s^.x, s^.y, CurrentWidth(s), CurrentHeight(s));
  end;
  
  function RectangleFrom(const pt: Point2D; width, height: LongInt): Rectangle; overload;
  begin
    result := RectangleFrom(pt.x, pt.y, width, height);
  end;
  
  function RectangleFrom(const pt: Point2D; bmp: Bitmap): Rectangle; overload;
  begin
    result := RectangleFrom(pt.x, pt.y, bmp^.width, bmp^.height);
  end;
  
  function RectangleFrom(x, y: Single; bmp: Bitmap): Rectangle; overload;
  begin
    result := RectangleFrom(x, y, bmp^.width, bmp^.height);
  end;
  
  function RectangleFrom(bmp: Bitmap): Rectangle; overload;
  begin
    result := RectangleFrom(0, 0, bmp);
  end;
  
  function TriangleFrom(ax, ay, bx, by, cx, cy: Single): Triangle; overload;
  begin
    result := TriangleFrom(PointAt(ax, ay), PointAt(bx, by), PointAt(cx, cy));
  end;
  
  function TriangleFrom(const a, b, c: Point2D): Triangle; overload;
  begin
    result[0] := a;
    result[1] := b;
    result[2] := c;
  end;
  
  function PointInTriangle(const pt : Point2D; const tri : Triangle): Boolean;
  var
    v0, v1, v2 : Vector;
    a, b, c, p: Vector;
    dot00, dot01, dot02, dot11, dot12 : Single;
    invDenom, u, v: Single;
  begin
    //Convert Points to vectors
    p := VectorFromPoint(pt);
    a := VectorFromPoint(tri[0]);
    b := VectorFromPoint(tri[1]);
    c := VectorFromPoint(tri[2]);
    
    // Compute vectors    
    v0 := SubtractVectors(c, a);
    v1 := SubtractVectors(b, a);
    v2 := SubtractVectors(p, a);
  
    // Compute dot products
    dot00 := DotProduct(v0, v0);
    dot01 := DotProduct(v0, v1);
    dot02 := DotProduct(v0, v2);
    dot11 := DotProduct(v1, v1);
    dot12 := DotProduct(v1, v2);
  
    // Compute barycentric coordinates
    invDenom := 1 / (dot00 * dot11 - dot01 * dot01);
    u := (dot11 * dot02 - dot01 * dot12) * invDenom;
    v := (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    // Check if point is in triangle
    result := ((u > 0) and (v > 0) and (u + v < 1));
  end;
  
  function PointInCircle(const pt, center: Point2D; radius: Single): Boolean;
  begin
    result := PointPointDistance(pt, center) <= radius;
  end;
  

  
  function TriangleBarycenter(const tri: Triangle): Point2D;
  begin
    result.x := (tri[0].x + tri[1].x + tri[2].x) / 3;
    result.y := (tri[0].y + tri[1].y + tri[2].y) / 3;
  end;
  
  function LineMidPoint(const line: LineSegment): Point2D;
  begin
    result.x := line.startPoint.x + (line.endPoint.x - line.startPoint.x) / 2;
    result.y := line.startPoint.y + (line.endPoint.y - line.startPoint.y) / 2;
  end;
  
  function RectanglesIntersect(const rect1, rect2: Rectangle): Boolean;
  begin
    if RectangleBottom(rect1) < RectangleTop(rect2) then result := false
    else if RectangleTop(rect1) > RectangleBottom(rect2) then result := false
    else if RectangleRight(rect1) < RectangleLeft(rect2) then result := false
    else if RectangleLeft(rect1) > RectangleRight(rect2) then result := false
    else result := true;
  end;

  function Intersection(const rect1, rect2: Rectangle): Rectangle;
  var
    r, l, b, t: Single;
  begin
    if RectangleBottom(rect1) > RectangleBottom(rect2) then b := RectangleBottom(rect2)
    else b := RectangleBottom(rect1);

    if RectangleTop(rect1) < RectangleTop(rect2) then t := RectangleTop(rect2)
    else t := RectangleTop(rect1);

    if RectangleRight(rect1) > RectangleRight(rect2) then r := RectangleRight(rect2)
    else r := RectangleRight(rect1);

    if RectangleLeft(rect1) < RectangleLeft(rect2) then l := RectangleLeft(rect2)
    else l := RectangleLeft(rect1);
    
    if (r < l) or (b > t) then
    begin
      result := RectangleFrom(0, 0, 0, 0);
      exit;
    end;
    
    result := RectangleFrom(l, t, Round(r - l), Round(b - t));
  end;
  
  function GetRayCircleIntersectDistance(const ray_origin: Point2D; const ray_heading:Vector; const circle_origin: Point2D; radius: Single): Single;
  var
    to_circle, unit_heading: Vector;
    length, v, d: Single;
  begin
      unit_heading := UnitVector(ray_heading);
      to_circle := VectorFromPoints(ray_origin, circle_origin);
      length := VectorMagnitude(to_circle);
      
      v := DotProduct(to_circle, unit_heading);
      d := radius*radius - (length*length - v*v);
      // if there was no intersection, return -1
      if d < 0.0 then
          result := -1.0
      // return the distance to the (first) intersection point
      else
          result := (v - sqrt(d));
  end;
  
  
  procedure GetWidestPoints(const center: Point2D; radius: Single; along: Vector; out pt1, pt2: Point2D);
  begin
    pt1 := AddVectors(center, VectorMultiply(UnitVector(along), radius));
    pt2 := AddVectors(center, VectorMultiply(UnitVector(along), -radius));
  end;
  
  {
  ''' Given a point P and a circle of radius R centered at C, determine the 
      two points T1, T2 on the circle that intersect with the tangents from P
      to the circle. Returns False if P is within the circle '''
  }
  function GetTangentPoints(const fromPt, centre: Point2D; radius: Single; out p1, p2: Point2D): Boolean;
  var
    pmC: Vector;
    sqr_len, r_sqr, inv_sqr_len, root: Single;
  begin
    pmC := VectorFromPoints(fromPt, centre);
    
    sqr_len := VectorMagnitudeSq(PmC);
    r_sqr := radius*radius;
    
    // Quick check for P inside the circle, return False if so
    if sqr_len <= r_sqr then
    begin
        result := False; // tangent objects are not returned.
        exit;
    end;
    
    // time to work out the real tangent points then
    inv_sqr_len := 1.0 / sqr_len;
    root := sqrt(abs(sqr_len - r_sqr));
    
    p1.x := centre.x + radius*(radius*pmC.x - pmC.y*root)*inv_sqr_len;
    p1.y := centre.y + radius*(radius*pmC.y + pmC.x*root)*inv_sqr_len;
    p2.x := centre.x + radius*(radius*pmC.x + pmC.y*root)*inv_sqr_len;
    p2.y := centre.y + radius*(radius*pmC.y - pmC.x*root)*inv_sqr_len;
    
    result := True;
  end;
  
  function GetRayIntersectionPoint(const fromPt: Point2D; const heading: Vector; const line: LineSegment; out pt: Point2D) : boolean;
  var
    rayLine: LineSegment;
    combMag: Single;
  begin
    result := False;
    rayLine := LineFromVector(fromPt, heading);
    
    // Get where the line intersect
    if not GetLineIntersectionPoint(rayLine, line, pt) then exit;
    //DrawLine(ColorWhite, fromPt, pt);
    
    combMag := VectorMagnitude(AddVectors(UnitVector(VectorFromPoints(fromPt, pt)), UnitVector(heading)));
    // WriteLn(combMag:4:2);
    // Test that pt is forward of fromPt (given heading)
    if combMag < 1 then exit; //behind point
    
    result := True;
  end;
  
  function GetLineIntersectionPoint(const line1, line2: LineSegment; out pt: Point2D) : boolean;
  var
    // convert lines to the eqn
    // c = ax + by
    a1, b1, c1: Single;
    a2, b2, c2: Single;
    det: Single;
  begin
    pt.x := 0;
    pt.y := 0;

    //Convert lines to eqn c = ax + by
    a1 := line1.endPoint.y - line1.startPoint.y; //y12 - y11;
    b1 := line1.startPoint.x - line1.endPoint.x; //x11 - x12;
    c1 := a1 * line1.startPoint.x + b1 * line1.startPoint.y; //a1 * x11 + b1 * y11;

    a2 := line2.endPoint.y - line2.startPoint.y; //y22 - y21;
    b2 := line2.startPoint.x - line2.endPoint.x; //x21 - x22;
    c2 := a2 * line2.startPoint.x + b2 * line2.startPoint.y; //a2 * x21 + b2 * y21;

    det := (a1 * b2) - (a2 * b1);

    if det = 0 then
      result := false
    else
    begin
      pt.x := (b2*c1 - b1*c2) / det;
      pt.y := (a1*c2 - a2*c1) / det;
      result := true;
    end;    
  end;
  
  function LineSegmentsIntersect(const line1, line2: LineSegment): boolean;
  var
    pt: Point2D;
  begin
    result := GetLineIntersectionPoint(line1, line2, pt) and PointOnLine(pt, line2) and PointOnLine(pt, line1);
  end;
  
  function LineIntersectsLines(const line: LineSegment; const lines: LinesArray): boolean;
  var
    i: LongInt;
    pt: Point2D;
  begin
    for i := 0 to High(lines) do
    begin     
      if GetLineIntersectionPoint(line, lines[i], pt) and PointOnLine(pt, lines[i]) then
      begin
        result := true;
        exit;
      end;
    end;
    result := false;
  end;
  
  function LineIntersectsRect(const line: LineSegment; const rect: Rectangle): boolean;
  var
    lines: LinesArray;
  begin
    lines := LinesFromRect(rect);
    result := LineIntersectsLines(line, lines);
  end;
  
  function PointInRect(const pt: Point2D; x, y, w, h: Single): Boolean; overload;
  begin
    if pt.x < x then result := false
    else if pt.x > x + w then result := false
    else if pt.y < y then result := false
    else if pt.y > y + h then result := false
    else result := true;
  end;

  function PointInRect(const pt: Point2D; const rect: Rectangle): Boolean; overload;
  begin
    result := PointInRect(pt, rect.x, rect.y, rect.width, rect.height);
  end;
  
  function PointInRect(ptX, ptY, x, y, w, h: Single): Boolean; overload;
  begin
    if ptX < x then result := false
    else if ptX > x + w then result := false
    else if ptY < y then result := false
    else if ptY > y + h then result := false
    else result := true;
  end;
  
  function PointInRect(x, y: Single; const rect: Rectangle): Boolean; overload;
  begin
    result := PointInRect(x, y, rect.x, rect.y, rect.width, rect.height);
  end;

  function VectorFromPointToRect(x, y, rectX, rectY: Single; rectWidth, rectHeight: LongInt): Vector; overload;
  var
    px, py: Single;
  begin
    if x < rectX then px := rectX
    else if x > (rectX + rectWidth) then px := rectX + rectWidth
    else px := x;
      
    if y < rectY then py := rectY
    else if y > (rectY + rectHeight) then py := rectY + rectHeight
    else py := y;
      
    result := VectorFrom(px - x, py - y);
  end;

  function VectorFromPointToRect(x, y: Single; const rect: Rectangle): Vector; overload;
  begin
    result := VectorFromPointToRect(x, y, rect.x, rect.y, rect.width, rect.height);
  end;
  
  function VectorFromPointToRect(const pt: Point2D; const rect: Rectangle): Vector; overload;
  begin
    result := VectorFromPointToRect(pt.x, pt.y, rect.x, rect.y, rect.width, rect.height);
  end;
  
  function VectorOut(const pt: Point2D; const rect: Rectangle; const movement: Vector; rectCollisionSide: CollisionSide): Vector; 
    function GetVectorDiagonal(edgeX, edgeY: Single): Vector;
    var
      toEdge: Vector;
      angle: Single;
      mvOut: Vector;
      xMag, yMag, outMag: Single;
    begin
      mvOut := UnitVector(InvertVector(movement));
      
      // WriteLn('Movement: ', movement.x:4:2, ':', movement.y:4:2);
      // WriteLn('mvOut: ', mvOut.x:4:2, ':', mvOut.y:4:2);
      // WriteLn('edge: ', edgeX:4:2, ':', edgeY:4:2);
      // WriteLn('pt: ', pt.X:4:2, ':', pt.Y:4:2);
      //Do X
      toEdge := VectorFrom(edgeX - pt.x, 0);
      angle := CalculateAngle(mvOut, toEdge);      
      xMag := VectorMagnitude(toEdge) * 1 / sgGeometry.Cos(angle);
      // WriteLn('xMag: ', xMag:4:2);
      
      //Do Y
      toEdge := VectorFrom(0, edgeY - pt.y);
      angle := CalculateAngle(mvOut, toEdge);      
      yMag := VectorMagnitude(toEdge) * 1 / sgGeometry.Cos(angle);
      // WriteLn('yMag: ', yMag:4:2);
          
      if (yMag < 0) or (xMag < yMag) then outMag := xMag
      else outMag := yMag;
      
      if outMag < 0 then outMag := 0;
      
      // WriteLn('outMag: ', outMag);
      
      //TODO: Calculate this better...
      result := VectorMultiply(mvOut, outMag + 1.5);
    end;    
  begin   
    case rectCollisionSide of
      TopLeft: begin
          if (pt.x < rect.x) or (pt.y < rect.y) then result := VectorFrom(0,0)
          else result := GetVectorDiagonal(rect.x, rect.y);
        end;
      TopRight: begin
          if (pt.x > rect.x + rect.width) or (pt.y < rect.y) then result := VectorFrom(0,0)
          else result := GetVectorDiagonal(rect.x + rect.width, rect.y);
        end;
      BottomLeft: begin
          if (pt.x < rect.x) or (pt.y > rect.y + rect.height) then result := VectorFrom(0,0)
          else result := GetVectorDiagonal(rect.x, rect.y + rect.height);
        end;
      BottomRight: begin
          if (pt.x > rect.x + rect.width) or (pt.y > rect.y + rect.height) then result := VectorFrom(0,0)
          else result := GetVectorDiagonal(rect.x + rect.width, rect.y + rect.height);
        end;
      Left: begin
          if (pt.x < rect.x) or (pt.y < rect.y) or (pt.y > rect.y + rect.height) then result := VectorFrom(0, 0)
          else result := VectorFrom(rect.x - pt.x - 1, 0);
          exit;
        end;
      Right: begin
          if (pt.x > rect.x + rect.width) or (pt.y < rect.y) or (pt.y > rect.y + rect.height) then result := VectorFrom(0, 0)
          else result := VectorFrom(rect.x + rect.width - pt.x + 1, 0);
          exit;
        end;
      Top: begin
          if (pt.y < rect.y) or (pt.x < rect.x) or (pt.x > rect.x + rect.width) then result := VectorFrom(0, 0)
          else result := VectorFrom(0, rect.y - pt.y - 1);
          exit;
        end;
      Bottom: begin
          if (pt.y > rect.y + rect.height) or (pt.x < rect.x) or (pt.x > rect.x + rect.width) then result := VectorFrom(0, 0)
          else result := VectorFrom(0, rect.y + rect.height + 1 - pt.y);
          exit;
        end;
      else //Not moving... i.e. None
        begin
          result := VectorFrom(0, 0);
        end;
    end;
    
    // WriteLn('VectorOut: ', result.x:4:2, ',', result.y:4:2);
    //, '  angle: ', angle:4:2, ' mag: ', outMag:4:2, ' xmag: ', xMag:4:2, ' ymag: ', yMag:4:2);
  end;

  function VectorOutOfRectFromPoint(const pt: Point2D; const rect: Rectangle; const movement: Vector): Vector; 
  begin
    result := VectorOut(pt, rect, movement, GetSideForCollisionTest(movement));
    // WriteLn(result.x:4:2, ':', result.y:4:2);
    
    if (result.x = 0) and (result.y = 0) then exit; 
    
    if not LineIntersectsRect(LineFromVector(pt, movement), rect) then
      result := VectorFrom(0, 0);
  end;

  function VectorOutOfCircleFromPoint(const pt, center: Point2D; radius: Single; const movement: Vector): Vector;
  var
    dx, dy, cx, cy: Single;
    mag, a, b, c, det, t, mvOut: single;
    ipt2: Point2D;
  begin
    // If the point is not in the radius of the circle, return a zero vector 
    if PointPointDistance(pt, center) > radius then
    begin
      result := VectorFrom(0, 0);
      exit;
    end;
    
    // If the magnitude of movement is very small, return a zero vector
    mag := VectorMagnitude(movement);
    if mag < 0.1 then
    begin
      result := VectorFrom(0, 0);
      exit;
    end;
    
    // Calculate the determinant (and components) from the center circle and 
    // the point+movement details
    cx := center.x;       
    cy := center.y;
    dx := movement.x; 
    dy := movement.y; 
    
    a := dx * dx + dy * dy;
    b := 2 * (dx * (pt.x - cx) + dy * (pt.y - cy));
    c := (pt.x - cx) * (pt.x - cx) + (pt.y - cy) * (pt.y - cy) - radius * radius;
    
    det := b * b - 4 * a * c;
    
    // If the determinate is very small, return a zero vector
    if det <= 0 then
      result := VectorFrom(0, 0)
    else
    begin
      // Calculate the vector required to "push" the vector out of the circle
      t := (-b - Sqrt(det)) / (2 * a);
      ipt2.x := pt.x + t * dx;
      ipt2.y := pt.y + t * dy;
  
      mvOut := PointPointDistance(pt, ipt2) + 1;
      result := VectorMultiply(UnitVector(InvertVector(movement)), mvOut);
    end;
  end;

  function VectorOutOfCircleFromCircle(const pt: Point2D; radius: Single; const center: Point2D; radius2: Single; const movement: Vector): Vector;
  begin
    result := VectorOutOfCircleFromPoint(pt, center, radius + radius2, movement);
  end;
  
  //
  // Find the extreme edge point (top left, bottom right, etc..).
  // Given collision side (inverse direction :) )
  //
  function DistantPoint(const srcRect, inRect: Rectangle; side: CollisionSide): Point2D;
  begin
    //Get the top left out - default then adjust for other points out
    result.x := srcRect.x; result.y := srcRect.y;
    
    case side of
      //Hit top or left of wall... bottom right in
      TopLeft:    begin result.x := result.x + srcRect.width; result.y := result.y + srcRect.height;  end;
      //Hit top or right of wall... bottom left in
      TopRight:   result.y := result.y + srcRect.height;
      //Hit bottom or left of wall... top right in
      BottomLeft:   result.x := result.x + srcRect.width;
      //Hit bottom or right of wall... top left is in
      BottomRight:  ;
      //Hit left of wall... right in
      Left:
        begin
          result.x := result.x + srcRect.width;
          if srcRect.y < inRect.y then  result.y := result.y + srcRect.height;
        end;
      Right:
        begin
          if srcRect.y < inRect.y then  result.y := result.y + srcRect.height;
        end;
      //Hit top of wall... bottom in
      Top:
        begin
          result.y := result.y + srcRect.height;
          if srcRect.x < inRect.x then result.x := result.x + srcRect.width;
        end;
      Bottom: //hit bottom of wall get the top out
        begin
          if srcRect.x < inRect.x then result.x := result.x + srcRect.width;
        end;
    end; //end case
  end;
  
  function VectorOutOfRectFromRect(const srcRect, targetRect: Rectangle; const movement: Vector): Vector;  
  var
    rectCollisionSide: CollisionSide;
    p: Point2D; // p is the most distant point from the collision on srcRect
    destRect: Rectangle;
  begin
    //Which side of the rectangle did we collide with.
    rectCollisionSide := GetSideForCollisionTest(movement);
    if rectCollisionSide = None then
    begin 
      result := VectorFrom(0, 0);
      exit; 
    end;
    
    p := DistantPoint(srcRect, targetRect, rectCollisionSide);
    //WriteLn('p = ', p.x, ',', p.y);
    
    result := VectorOut(p, targetRect, movement, rectCollisionSide);
    
    if (result.x = 0) and (result.y = 0) then exit; 
    
    destRect := RectangleAfterMove(srcRect, result);
    //Check diagonal miss...
    case rectCollisionSide of
      //Hit top left, check bottom and right;
      TopLeft: if (RectangleTop(destRect) > RectangleBottom(targetRect))  or 
              (RectangleLeft(destRect) > RectangleRight(targetRect))  then result := VectorFrom(0,0);
      //Hit top right, check bottom and left
      TopRight: if  (RectangleTop(destRect) > RectangleBottom(targetRect))  or 
                (RectangleRight(destRect) < RectangleLeft(targetRect))  then result := VectorFrom(0,0);
      //Hit bottom left, check top and right
      BottomLeft: if (RectangleBottom(destRect) < RectangleTop(targetRect))   or 
                (RectangleLeft(destRect) > RectangleRight(targetRect))  then result := VectorFrom(0,0);
      //Hit bottom right, check top and left
      BottomRight: if   (RectangleBottom(destRect) < RectangleTop(targetRect))  or 
                  (RectangleRight(destRect) < RectangleLeft(targetRect))  then result := VectorFrom(0,0);
    end   
  end;
  
  function VectorInRect(const v: Vector; x, y, w, h: Single): Boolean; overload;
  begin
    if v.x < x then result := false
    else if v.x > x + w then result := false
    else if v.y < y then result := false
    else if v.y > y + h then result := false
    else result := true;
  end;
  
  function VectorInRect(const v: Vector; const rect: Rectangle): Boolean; overload;
  begin
    result := VectorInRect(v, rect.x, rect.y, rect.width, rect.height);
  end;
  
  //
  // Get the lines from the rectangle that are required to be checked given
  // a collision on the given side (eg Top + Left lines for TopLeft collision side).
  //
  function LinesForCollisionTest(const rect: Rectangle; side: CollisionSide): LinesArray;
  var
    lines: LinesArray;
    // Inner procedure....
    // set only one line to check
    procedure SetLinesToChk(line: LineSegment); overload;
    begin
      SetLength(result, 1);
      result[0] := line;
    end;
    // Inner procedure....
    // set two lines to check
    procedure SetLinesToChk(line1, line2: LineSegment); overload;
    begin
      SetLength(result, 2);
      result[0] := line1;
      result[1] := line2;
    end;
  begin
    lines := LinesFromRect(rect);
    
    case side of
      TopLeft:      SetLinesToChk( lines[0], lines[1] );
      Top:          SetLinesToChk( lines[0] );
      TopRight:     SetLinesToChk( lines[0], lines[2] );
      Left:         SetLinesToChk( lines[1] );
      Right:        SetLinesToChk( lines[2] );
      BottomLeft:   SetLinesToChk( lines[3], lines[1] );
      Bottom:       SetLinesToChk( lines[3] );
      BottomRight:  SetLinesToChk( lines[3], lines[2] );
      else SetLength(result, 0);
    end;
  end;
  
  //TODO: Replace LineCircleHit
  function LineOfLinesCircleHit(const fromPt: Point2D; radius: Single; const movement: Vector; const lines: LinesArray; out found: LineSegment): Boolean;
  var
    projection: LineSegment;
    // side: CollisionSide;
    iPts: Array of Point2D;
    //edgePt: Point2D;
    //boundRect: Rectangle;
    i, j: Integer;
    dist, minDist: Single;
    min: Integer;
  begin
    // side := GetSideForCollisionTest(movement);
    result := False;
    
    //boundRect := RectangleFrom(lines);
    //DrawRectangle(ColorWhite, boundRect);
    
    //edgePt := DistantPoint(RectangleFrom(fromPt, radius), boundRect, side);
    //DrawCircle(ColorWhite, edgePt, 2);
    
    projection := LineFromVector(fromPt, InvertVector(movement));
    minDist := -1;
    min := -1;
    
    //DrawLines(ColorWhite, lines);
    DrawLine(ColorWhite, projection);
    
    SetLength(iPts, length(lines));
    j := 0;
    for i := 0 to High(lines) do
    begin
      if GetLineIntersectionPoint(lines[i], projection, iPts[j]) then
      begin
        dist := PointPointDistance(fromPt, iPts[j]);
        
        if (dist < minDist) or (minDist < 0) then
        begin
          minDist := dist;
          min := i;
        end;
        
        DrawCircle(ColorWhite, iPts[j], 2);
        j := j + 1;
      end;
    end;
    
    DrawLine(ColorBlue, lines[min]);
    
  end;
  
  function LineCircleHit(const fromPt: Point2D; radius: Single; movement: Vector; rect: Rectangle; out found: LineSegment): Boolean;
  var
    projection: LineSegment;
    edgePt, closePt: Point2D;
    side: CollisionSide;
    lines: LinesArray;
    dist, minDist: Single;
    i, min: Integer;
  begin
    side := GetSideForCollisionTest(movement);
    result := false;
    if side = None then exit; 
    
    //Find distant point from
    edgePt := DistantPoint(RectangleFrom(fromPt, radius), rect, side);
    //DrawCircle(ColorYellow, edgePt, 2);
    
    //find the line with the shortest distance
    //from the edgePt along theprojected line using movement.
    projection := LineFromVector(edgePt, movement); //project a line in movement dir, from edgePt
    
    lines := LinesForCollisionTest(rect, side);
    minDist := -1;
    min := -1;
    for i := Low(lines) to High(lines) do
    begin
      //get points from lines vs projection
      if GetLineIntersectionPoint(projection, lines[i], closePt) then
      begin
        dist := PointPointDistance(closePt, edgePt);
        if (dist < minDist) or (minDist < 0) then
        begin
          minDist := dist;
          min := i;
        end;
      end; // end check intersection
    end; //end for
    
    if min >= 0 then
    begin
      found := lines[min];
      result := True;
    end;
  end;
  
  function DistantPointOnCircle(const pt, center: Point2D; radius: Single): Point2D;
  var
    ptOnCircle: Point2D;
    toCircle: Vector;
  begin
    //Get the closest point
    ptOnCircle := ClosestPointOnCircle(pt, center, radius);
    
    // Get other side... follow toCircle vector 2 * radius
    toCircle := VectorFromPoints(pt, ptOnCircle);
    result := AddVectors(ptOnCircle, VectorMultiply(UnitVector(toCircle), radius * 2));
  end;
  
  function DistantPointOnCircleWithVector(const pt, center: Point2D; radius: Single; heading: Vector; out oppositePt: Point2D): Boolean;
  var
    dist, dotProd: Single;
    ptOnCircle, chkPt: Point2D;
    toCenter, toPoint: Vector;
  begin
    result := False;
    heading := UnitVector(heading);
    
    //Move pt back 2 * radius to ensure it is outside of the circle... 
    //  but still on same alignment
    chkPt := AddVectors(pt, VectorMultiply(InvertVector(heading), 2 * radius));
    //DrawCircle(ColorBlue, chkPt, 1);
    
    dist := GetRayCircleIntersectDistance(chkPt, heading, center, radius);
    if dist < 0 then exit;
    
    // Get point on circle by moving from chkPt dist distance in heading direction
    ptOnCircle := AddVectors(chkPt, VectorMultiply(heading, dist));
    //DrawLine(ColorMagenta, chkPt, ptOnCircle);
    //DrawCircle(ColorMagenta, ptOnCircle, 2);
    
    //Project the ray to the other side of the circle
    toCenter := VectorFromPoints(ptOnCircle, center);
    dotProd := DotProduct(toCenter, heading);
    //WriteLn(dotProd:4:2);
    
    result := True;
    oppositePt := AddVectors(ptOnCircle, VectorMultiply(heading, 2 * dotProd));
    //FillCircle(ColorRed, oppositePt, 2);
  end;
  
  function VectorOutOfRectFromCircle(const center: Point2D; radius: Single; const rect: Rectangle; const movement: Vector): Vector;
  var
    distPt, linePt, edge: Point2D;
    normalLine, found: LineSegment;
    toEdge, normal: Vector;
    side: CollisionSide;
    dotProd: Single;
  begin
    result := VectorFrom(0, 0);
    
    // 1: Find the line we hit... exit if no line
    if not LineCircleHit(center, radius, movement, rect, found) then exit;
    
    // 2: Get the most distant edge from the ``line`` (not segment) - most distant is based on direction of movement
    // 2a: Get the normal of the line we hit, we will project along this direction
    normal := VectorNormal(LineAsVector(found));
    
    // 2b: Get the most distant edge point (corner of bounding rectangle)
    side := GetSideForCollisionTest(movement);
    edge := DistantPoint(RectangleFrom(center, radius), rect, side);
    //FillCircle(ColorYellow, edge, 2); // Draws corner pt
    
    // 2c: Project vect to edge point (corner) along the normal of the line we hit to get its components
    toEdge := VectorFromPoints(center, edge);
    dotProd := DotProduct(toEdge, normal);
    
    // 2d: Most distant edge pt is this distance (dotProd) from the center
    edge := AddVectors(center, VectorMultiply(normal, dotProd));
    //FillCircle(ColorGreen, edge, 2); // Draws distant pt
    
    //  Find the point we hit on the line...
    if not GetLineIntersectionPoint(LineFromVector(edge, movement), found, linePt) then exit;
    // Move back onto line segment... linePt -> closest point on line to intersect point
    //DrawCircle(ColorWhite, linePt, 1); // point on line, but not segment
    
    linePt := ClosestPointOnLine(linePt, found);
    //DrawCircle(ColorYellow, linePt, 1); // point on segment
    
    // Find the most distant point on the circle, given the movement vector
    if not DistantPointOnCircleWithVector(linePt, center, radius, movement, distPt) then exit;
    
    result := VectorOut(distPt, rect, movement, side);
  end;
  
  
  function VectorOverLinesFromCircle(const center: Point2D; radius: Single; lines: LinesArray; movement: Vector; out maxIdx: Integer): Vector;
  type
    DoublePt = record ptOnCircle, ptOnLine: Point2D; end;
  var
    pt1, pt2, ptOnLine, ptOnCircle, hitPt, maxHitPtOnLine, maxHitPtOnCircle: Point2D;
    tmp: Array [0..3] of Point2D;
    chkPts: Array [0..3] of DoublePt;
    lineVec, normalMvmt, normalLine, toEdge, edge, ray, vOut: Vector;
    i, j, hits: Integer;
    dotProd, dist, maxDist: Single;
  begin
    // Cast ray searching for points back from shape
    ray := InvertVector(movement);
    normalMvmt := VectorNormal(movement);
    vOut := VectorFrom(0,0);
    
    maxIdx := -1;
    maxDist := -1;

    //Search all lines for hit points
    for i := 0 to High(lines) do
    begin
      lineVec := LineAsVector(lines[i]);
      //Get the normal of the line we hit
      normalLine := VectorNormal(lineVec);
      hits := 0;

      //tmp 0 and tmp 1 are the widest points to detect collision with line
      GetWidestPoints(center, radius, normalMvmt, tmp[0], tmp[1]);
      //tmp 2 and tmp 3 are the closest and furthest points from the line
      GetWidestPoints(center, radius, normalLine, tmp[2], tmp[3]);

      // for both points...
      for j := 0 to 3 do
      begin
        //DrawCircle(ColorWhite, tmp[j], 2);

        // Cast a ray back from the test points to find line pts... out on ptOnLine
        if GetRayIntersectionPoint(tmp[j], ray, lines[i], ptOnLine) then
        begin
          //DrawCircle(ColorRed, ptOnLine, 1);
          //DrawLine(ColorRed, tmp[j], ptOnLine);

          chkPts[hits].ptOnLine := ptOnLine;
          chkPts[hits].ptOnCircle := tmp[j];
          hits := hits + 1;
        end;
      end;

      // for each of the hits on this line...
      // search for the longest hit.
      for j := 0 to hits - 1 do
      begin
        //DrawCircle(ColorWhite, chkPts[j].ptOnCircle, 1);
        toEdge := VectorFromPoints(center, chkPts[j].ptOnCircle);
        //DrawLine(ColorRed, center, chkPts[j].ptOnCircle);
        dotProd := DotProduct(toEdge, normalLine);

        // 2d: Most distant edge pt is on a line this distance (dotProd) from the center
        edge := AddVectors(center, VectorMultiply(normalLine, dotProd));
        //DrawPixel(ColorWhite, edge); // Draws pt on line to distant pt

        //  Find the point we hit on the line... ptOnLine receives intersection point...
        if not GetLineIntersectionPoint(LineFromVector(edge, movement), lines[i], ptOnLine) then continue;
        // Move back onto line segment... linePt -> closest point on line to intersect point
        //DrawCircle(ColorRed, ptOnLine, 1); // point on line, but not necessarily the line segment
        //DrawLine(ColorWhite, edge, ptOnLine);

        ptOnLine := ClosestPointOnLine(ptOnLine, lines[i]);
        //FillCircle(ColorBlue, ptOnLine, 1); // point on segment

        // Find the most distant point on the circle, given the movement vector
        if not DistantPointOnCircleWithVector(ptOnLine, center, radius, movement, ptOnCircle) then continue;
        //FillCircle(ColorBlue, ptOnCircle, 2); // point on segment
        //DrawLine(ColorBlue, ptOnLine, ptOnCircle);

        // GetTangentPoints(lines[i].endPoint, center, radius, pt1, pt2);
        // DrawCircle(ColorRed, pt1, 2);
        // DrawCircle(ColorRed, pt2, 2);

        dist := PointPointDistance(ptOnLine, ptOnCircle);
        //WriteLn(dist);
        if (dist > maxDist) or (maxIdx = -1) then
        begin
          maxDist := dist;
          maxIdx := i;
          vOut := VectorFromPoints(ptOnCircle, ptOnLine);
          //dotProd := DotProduct(UnitVector(vOut), VectorFrom(0.5,0.5));
          vOut := VectorMultiply(UnitVector(vOut), VectorMagnitude(vOut) + 1.42);
          //WriteLn(dotProd:4:2);
        end;      
      end;
    end;
    
    result := vOut;
  end;
  
end.