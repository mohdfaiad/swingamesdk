unit sgDriverImages;
//=============================================================================
// sgDriverImages.pas
//=============================================================================
//
// The Graphics driver is responsible for acting as the interface between driver
// code and swingame code. Swingame code uses the images driver to access the 
// current active driver. 
//
// Changing this driver will probably cause graphics drivers to break.
//
// Notes:
//		- Pascal PChar is equivalent to a C-type string
// 		- Pascal Word is equivalent to a Uint16
//		- Pascal LongWord is equivalent to a Uint32
//		- Pascal SmallInt is equivalent to Sint16
//
//=============================================================================
interface
	uses sgTypes;
	
	type
	  InitBitmapColorsProcedure            = procedure (bmp : Bitmap);
	  CreateBitmapProcedure                = procedure(bmp : Bitmap; width, height : LongInt);
	  SurfaceExistsProcedure               = function(bmp : Bitmap) : Boolean;
	  DoLoadBitmapProcedure                = function(filename: String; transparent: Boolean; transparentColor: Color): Bitmap;

	ImagesDriverRecord = record
	  InitBitmapColors            : InitBitmapColorsProcedure;
	  SurfaceExists               : SurfaceExistsProcedure;
	  CreateBitmap                : CreateBitmapProcedure;
	  DoLoadBitmap                : DoLoadBitmapProcedure;
	end;
	
	var
		ImagesDriver : ImagesDriverRecord;
		
implementation
  uses
    sgDriverImagesSDL;
    
	procedure LoadDefaultDriver();
	begin
		LoadSDLImagesDriver();
	end;
	
	procedure DefaultInitBitmapColorsProcedure(bmp : Bitmap);
	begin	  
  		LoadSDLImagesDriver();
  		ImagesDriver.InitBitmapColors(bmp);
	end;
	
	function DefaultSurfaceExistsProcedure(bmp : Bitmap) : Boolean;
	begin
	  LoadDefaultDriver();
		result := ImagesDriver.SurfaceExists(bmp);
	end;
	
	procedure DefaultCreateBitmapProcedure (bmp : Bitmap; width, height : LongInt);
	begin
		LoadDefaultDriver();
		ImagesDriver.CreateBitmap(bmp, width, height);
	end;  
	
	function DefaultDoLoadBitmapProcedure (filename: String; transparent: Boolean; transparentColor: Color): Bitmap;
	begin
		LoadDefaultDriver();
		result := ImagesDriver.DoLoadBitmap(filename, transparent, transparentColor);
	end;

	initialization
	begin
	  ImagesDriver.InitBitmapColors           := @DefaultInitBitmapColorsProcedure;
	  ImagesDriver.SurfaceExists              := @DefaultSurfaceExistsProcedure;
		ImagesDriver.CreateBitmap               := @DefaultCreateBitmapProcedure;
		ImagesDriver.DoLoadBitmap               := @DefaultDoLoadBitmapProcedure;
	end;
end.
	