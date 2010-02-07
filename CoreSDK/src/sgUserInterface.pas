//=============================================================================
// sgUserInterface.pas
//=============================================================================
//
// Version 0.1 - Resposible for constructing User Interfaces in 
// SwinGame projects.. eventually.
//
// Change History:
//
// Version 3:
// - 2009-12-18: Cooldave : Ability to create panels...  no regions, just panels. 
//              They can  be drawn as rectangles and read from file.
// 
// - 2010-01-19: Cooldave : Textboxes, Buttons, Checkboxes, Radiobuttons, Labels all fully functional.
//              Lists are almost completed. Can be created and used, and items can be added at runtime.
//              Need to add the ability to remove items from lists.
//=============================================================================

{$I sgTrace.inc}

unit sgUserInterface;

//=============================================================================
interface
  uses sgTypes;
//=============================================================================

type
  Panel = ^PanelData;
  Region = ^RegionData;
  GUILabel = ^GUILabelData;
  GUICheckbox = ^GUICheckboxData;
  GUIRadioGroup = ^GUIRadioGroupData;
  GUITextBox = ^GUITextBoxData;
  GUIList = ^GUIListData;
  
  GuiElementKind = ( 
    gkLabel = 1, 
    gkButton = 2, 
    gkCheckBox = 4, 
    gkRadioGroup = 8, 
    gkTextBox = 16, 
    gkList = 32,
    gkAnyKind = (1 or 2 or 4 or 8 or 16 or 32) );
  
  GUITextBoxData = record
    contentString:  String;
    font:           Font;
    lengthLimit:    LongInt;
    region:         Region;
    alignment:      FontAlignment;
  end;
  
  GUILabelData = record
    contentString:  String;
    font:           Font;
    alignment:      FontAlignment;
  end;
  
  /// Each list item has text and an image
  GUIListItem = record
    text:     String;
    image:    Bitmap;
    parent:   GUIList;
  end;

  
  GUIListData = record
    verticalScroll: Boolean;
    //The areas for the up/left down/right scrolling buttons
    scrollUp:     Rectangle;
    scrollDown:   Rectangle;
    scrollArea:   Rectangle;
    columns:      LongInt;
    rows:         LongInt;
    rowHeight:    LongInt;
    colWidth:     LongInt;
    scrollSize:   LongInt;
    placeholder:  Array of Rectangle;
    activeItem:   LongInt;
    startingAt:   LongInt;
    font:         Font;
    items:        Array of GUIListItem;
    scrollButton: Bitmap;
    alignment:    FontAlignment;
  end;
    
  GUIRadioGroupData = record
    groupID:      string;
    buttons:      Array of Region;
    activeButton: LongInt;
  end;
  
  GUICheckboxData = record
    state:        boolean;
  end;
  
  RegionData = record
    stringID:       String;
    kind:           GUIElementKind;
    regionID:       LongInt;
    elementIndex:   LongInt;
    area:           Rectangle;
    active:         Boolean;
    parent:         Panel;
  end;
  
  PanelData = record
    name:                 String;
    filename:             String;
    panelID:              LongInt;
    area:                 Rectangle;
    visible:              Boolean;
    active:               Boolean;
    panelBitmap:          Bitmap;
    panelBitmapInactive:  Bitmap;
    panelBitmapActive:    Bitmap;
    regions:              Array of RegionData;
    regionIds:            NamedIndexCollection;
    labels:               Array of GUILabelData;
    checkBoxes:           Array of GUICheckboxData;
    radioGroups:          Array of GUIRadioGroupData;
    textBoxes:            Array of GUITextBoxData;
    lists:                Array of GUIListData;
    draggable:            Boolean;
  end;
  
  FileDialogSelectType = ( fdFiles = 1, fdDirectories = 2, fdFilesAndDirectories = 3 );
  


//---------------------------------------------------------------------------
// Alter GUI global values
//---------------------------------------------------------------------------
procedure GUISetForegroundColor(c:Color);
procedure GUISetBackgroundColor(c:Color);

// Panels
procedure ShowPanel(p: Panel);
procedure HidePanel(p: Panel);
procedure ToggleShowPanel(p: Panel);
procedure DrawPanels();
procedure ActivatePanel(p: Panel);
procedure DeactivatePanel(p: Panel);
procedure ToggleActivatePanel(p: Panel);
function PanelVisible(p: Panel): boolean;
function PanelClicked(): Panel;
procedure PanelSetDraggable(p: panel; b:boolean);
function PanelDraggable(p: panel): boolean;
procedure MovePanel(p: Panel; mvmt: Vector);
function PanelAtPoint(pt: Point2D): Panel;
function PointInRegion(pt: Point2D; p: Panel; kind: GuiElementKind): Boolean; overload;
function PointInRegion(pt: Point2D; p: Panel): Boolean;
procedure ReleaseAllPanels();
procedure ReleasePanel(name: String);
procedure FreePanel(var pnl: Panel);
procedure DoFreePanel(var pnl: Panel);
function MapPanel(name, filename: String): Panel;
function LoadPanel(filename: String): Panel;
function HasPanel(name: String): Boolean;
function PanelNamed(name: String): Panel;  
function PanelName(pnl: Panel): String;  
function PanelFilename(pnl: Panel): String;
function IsDragging(): Boolean;
function PanelY(p: Panel): Single;
function PanelX(p: Panel): Single;
function PanelHeight(p: Panel): LongInt;
function PanelWidth(p: Panel): LongInt;

// Regions
function RegionClickedID(): String;
function RegionClicked(): Region;
function RegionID(r: Region): string;
function RegionWithID(pnl: Panel; ID: String): Region; overload;
function RegionWithID(ID: String): Region; overload;
function RegionPanel(r: Region): Panel;
procedure ToggleRegionActive(forRegion: Region);
procedure SetRegionActive(forRegion: Region; b: boolean);

function RegionY(r: Region): Single;
function RegionX(r: Region): Single;
function RegionHeight(r: Region): LongInt;
function RegionWidth(r: Region): LongInt;

function RegionAtPoint(p: Panel; const pt: Point2D): Region;

//Checkbox
function CheckboxState(s: String): Boolean; overload;
function CheckboxState(chk: GUICheckbox): Boolean; overload;
function CheckboxState(r: Region): Boolean; overload;
procedure CheckboxSetState(r: region; val: Boolean); overload;
procedure CheckboxSetState(chk: GUICheckbox; val: Boolean); overload;
procedure ToggleCheckboxState(c: GUICheckbox);
function CheckboxFromRegion(r: Region): GUICheckbox;

//RadioGroup
function RadioGroupFromId(pnl: Panel; id: String): GUIRadioGroup;
function RadioGroupFromRegion(r: Region): GUIRadioGroup;
function ActiveRadioButtonIndex(RadioGroup: GUIRadioGroup): integer;
function ActionRadioButton(grp: GUIRadioGroup): Region; overload;
function ActionRadioButton(r: Region): Region; overload;
procedure SelectRadioButton(r: Region); overload;
procedure SelectRadioButton(rGroup: GUIRadioGroup; r: Region); overload;


//TextBox
function TextBoxFont(tb: GUITextBox): Font; overload;
function TextBoxFont(r: Region): Font; overload;
procedure TextboxSetFont(Tb: GUITextbox; f: font);
function TextBoxText(r: Region): String; overload;
function TextBoxText(tb: GUITextBox): String; overload;
procedure TextboxSetText(r: Region; s: string); overload;
procedure TextboxSetText(tb: GUITextBox; s: string); overload;
procedure TextboxSetText(tb: GUITextBox; i: LongInt); overload;
procedure TextboxSetText(tb: GUITextBox; single: Single); overload;
procedure TextboxSetText(r: Region; single: Single); overload;
procedure TextboxSetText(r: Region; i: LongInt); overload;
function TextBoxFromRegion(r: Region): GUITextBox;
procedure GUISetActiveTextbox(r: Region); overload;
procedure GUISetActiveTextbox(t: GUITextBox); overload;
procedure DeactivateTextBox();
function ActiveTextIndex(): Integer;
function GUITextEntryComplete(): boolean;
function GUITextBoxOfTextEntered(): GUITextbox;
function RegionOfLastUpdatedTextBox(): Region;
function IndexOfLastUpdatedTextBox(): Integer;
procedure UpdateInterface();
procedure DrawGUIAsVectors(b : boolean);
procedure FinishReadingText();
function ActiveTextBoxParent() : Panel;

function TextboxAlignment(r: Region): FontAlignment;
function TextboxAlignment(tb: GUITextbox): FontAlignment;
procedure TextboxSetAlignment(tb: GUITextbox; align: FontAlignment);
procedure TextboxSetAlignment(r: Region; align: FontAlignment);


//Lists
procedure ListSetActiveItemIndex(lst: GUIList; idx: LongInt);
function ListActiveItemText(pnl: Panel; ID: String): String;
function ListFromRegion(r: Region): GUIList; overload;

function ListFont(r: Region): Font; overload;
function ListFont(lst: GUIList): Font; overload;
procedure ListSetFont(lst: GUITextbox; f: font);
function ListItemText(r: Region; idx: LongInt): String; overload;
function ListItemText(lst: GUIList; idx: LongInt): String; overload;
function ListActiveItemText(r: Region): String; overload;
function ListItemCount(r: Region): LongInt; overload;
function ListItemCount(lst:GUIList): LongInt; overload;
function ListActiveItemIndex(r: Region): LongInt; overload;
function ListActiveItemIndex(lst: GUIList): LongInt;

procedure ListRemoveItem(lst: GUIList; idx: LongInt);
procedure ListClearItems(lst: GUIList); overload;
procedure ListClearItems(r : Region); overload;
procedure ListAddItem(lst: GUIList; text: String); overload;
procedure ListAddItem(lst: GUIList; img:Bitmap); overload;
procedure ListAddItem(lst: GUIList; img:Bitmap; text: String); overload;
procedure ListAddItem(r : Region; text: String); overload;
procedure ListAddItem(r : Region; img:Bitmap); overload;
procedure ListAddItem(r : Region; img:Bitmap; text: String); overload;



function ListBitmapIndex(lst: GUIList; img: Bitmap): LongInt;
function ListTextIndex(lst: GUIList; value: String): LongInt;

function ListStartAt(lst: GUIList): LongInt;
function ListStartAt(r: Region): LongInt;

procedure ListSetStartAt(lst: GUIList; idx: LongInt);
procedure ListSetStartAt(r: Region; idx: LongInt);

function ListFontAlignment(r: Region): FontAlignment;
function ListFontAlignment(lst: GUIList): FontAlignment;
procedure ListSetFontAlignment(r: Region; align: FontAlignment);
procedure ListSetFontAlignment(lst: GUIList; align: FontAlignment);

function ListLargestStartIndex(lst: GUIList): LongInt;
function ListScrollIncrement(lst: GUIList): LongInt;

//Label
function  LabelFont(l: GUILabel): Font; overload;
function  LabelFont(r: Region): Font; overload;
procedure LabelSetFont(l: GUILabel; s: String);
  
function  LabelText(lb: GUILabel): string; overload;
function  LabelText(r: Region): string; overload;
procedure LabelSetText(lb: GUILabel; newString: String); overload;
procedure LabelSetText(r: Region; newString: String); overload;
procedure LabelSetText(pnl: Panel; id, newString: String); overload;

function  LabelFromRegion(r: Region): GUILabel;

function LabelAlignment(r: Region): FontAlignment;
function LabelAlignment(tb: GUILabel): FontAlignment;
procedure LabelSetAlignment(tb: GUILabel; align: FontAlignment);
procedure LabelSetAlignment(r: Region; align: FontAlignment);

// Dialog Code
procedure DialogSetPath(fullname: String);

function IsSet(toCheck, checkFor: FileDialogSelectType): Boolean; overload;
function DialogPath(): String;
function DialogCancelled(): Boolean;
function DialogComplete(): Boolean;
procedure ShowSaveDialog(); overload;
procedure ShowSaveDialog(select: FileDialogSelectType); overload;

procedure ShowOpenDialog(); overload;

procedure ShowOpenDialog(select: FileDialogSelectType); overload;


//=============================================================================
implementation
  uses
    SysUtils, StrUtils, Classes, Math,
    stringhash, sgUtils, sgNamedIndexCollection,   // libsrc
    sgShared, sgResources, sgTrace, sgImages, sgGraphics, sgCore, 
    sgGeometry, sgText, sgInput, sgAudio;
//=============================================================================

type
  GUIController = record
    panels:             Array of Panel;         // The panels that are loaded into the GUI
    visiblePanels:      Array of Panel;         // The panels that are currently visible (in reverse z order - back to front)
    globalGUIFont:      Font;
    foregroundClr:      Color;                  // The color of the foreground
    backgroundClr:      Color;                  // The color of the background
    VectorDrawing:      Boolean;
    lastClicked:        Region;
    activeTextBox:      Region;
    lastActiveTextBox:  Region;
    doneReading:        Boolean;
    lastTextRead:       String;                 // The text that was in the most recently changed textbox before it was changed.
    panelIds:           TStringHash;
    // Variables for dragging panels
    downRegistered:     Boolean;
    panelDragging:      Panel;
  end;

    FileDialogData = packed record
    dialogPanel:          Panel;      // The panel used to show the dialog
    currentPath:          String;     // The path to the current directory being shown
    currentSelectedPath:  String;     // The path to the file selected by the user
    cancelled:            Boolean;
    complete:             Boolean;
    allowNew:             Boolean;
    selectType:           FileDialogSelectType;
    onlyFiles:            Boolean;
    lastSelectedFile, lastSelectedPath: LongInt; // These represent the index if the selected file/path to enable double-like clicking
  end;
  
var
  GUIC: GUIController;
  // The file dialog
  dialog: FileDialogData;

procedure HandlePanelInput(pnl: Panel); forward;

function GUITextEntryComplete(): boolean;
begin
  result := GUIC.doneReading;
end;

function GUITextBoxOfTextEntered(): GUITextbox;
begin
  result := nil;
  if not assigned(GUIC.lastActiveTextBox) then exit;
  result := @GUIC.lastActiveTextBox^.parent^.textBoxes[GUIC.lastActiveTextBox^.elementIndex];
end;

function RegionOfLastUpdatedTextBox(): Region;
begin
  result := nil;
  if not assigned(GUIC.lastActiveTextBox) then exit;
  result := GUIC.lastActiveTextBox;
end;

function IndexOfLastUpdatedTextBox(): LongInt;
begin
  result := -1;
  if not assigned(GUIC.lastActiveTextBox) then exit;
  result := RegionOfLastUpdatedTextBox()^.elementIndex;
end;

function ActiveTextIndex(): LongInt;
begin
  result := -1;
  if not assigned(GUIC.activeTextBox) then exit;
  result := GUIC.activeTextBox^.elementIndex;
end;

procedure DeactivateTextBox();
begin 
  GUIC.activeTextBox := nil;
end;

function ActiveTextBoxParent() : Panel;
begin
  result := GUIC.activeTextBox^.parent;
end;

function RegionRectangleOnscreen(r: Region): Rectangle;
begin
  if not assigned(r) then begin result := RectangleFrom(0,0,0,0); exit; end;
  
  result := RectangleOffset(r^.area, RectangleTopLeft(r^.parent^.area));
end;

//---------------------------------------------------------------------------------------
// Drawing Loops
//---------------------------------------------------------------------------------------  

function BitmapToDraw(r: Region): Bitmap;
begin
  result := nil;
  if not(assigned(r)) then exit;
  
  case r^.kind of
    gkButton:     begin
                    if MouseDown(LeftButton) AND PointInRect(MousePosition(), RegionRectangleOnScreen(r)) then
                      result := r^.parent^.panelBitmapActive
                    else
                      result := r^.parent^.panelBitmap;
                  end;
    gkCheckBox:   begin
                    if CheckboxState(r) then 
                     result := r^.parent^.panelBitmapActive
                   else
                     result := r^.parent^.panelBitmap;
                  end;
    gkRadioGroup: begin
                    if r = ActionRadioButton(r) then
                      result := r^.parent^.panelBitmapActive
                    else
                      result := r^.parent^.panelBitmap;
                  end;
  end;
end;

//Helper functions used to determine the text rectangle for text boxes
function TextboxTextArea(r: Rectangle): Rectangle; overload;
begin
  result := InsetRectangle(r, 1);
end;

function TextboxTextArea(r: Region): Rectangle; overload;
begin
  result := TextboxTextArea(RegionRectangleOnScreen(r));
end;


procedure DrawVectorCheckbox(forRegion: Region; const area: Rectangle);
begin
  DrawRectangleOnScreen(GUIC.foregroundClr, area);
  
  if CheckboxState(forRegion) then 
  begin
    FillRectangleOnScreen(GUIC.foregroundClr, InsetRectangle(area, 2));
  end;
end;

procedure DrawVectorRadioButton(forRegion: Region; const area: Rectangle);
begin
  DrawEllipseOnScreen(GUIC.foregroundClr, area);
  
  if forRegion = ActionRadioButton(forRegion) then
  begin
    FillEllipseOnScreen(GUIC.foregroundClr, InsetRectangle(area, 2));
  end;
end;

procedure DrawTextbox(forRegion: Region; const area: Rectangle);
begin
  if GUIC.VectorDrawing then DrawRectangleOnScreen(GUIC.foregroundClr, area);
  
  if GUIC.activeTextBox <> forRegion then
    DrawTextLinesOnScreen(TextboxText(forRegion), 
                          GUIC.foregroundClr,
                          GUIC.backgroundClr, 
                          TextboxFont(forRegion), 
                          TextboxAlignment(forRegion),
                          TextboxTextArea(area));
end;
  
procedure DrawList(forRegion: Region; const area: Rectangle);
var
  tempList:               GUIList;
  i, itemIdx:             LongInt;
  areaPt, imagePt:        Point2D;
  itemArea, scrollArea:   Rectangle;
  itemTextArea:           Rectangle;
  placeHolderScreenRect:  Rectangle;

  procedure _DrawUpDownArrow(const rect: Rectangle; up: Boolean);
  var
    tri: Triangle;
    innerRect, arrowArea: Rectangle;
  begin
    arrowArea := RectangleOffset(rect, areaPt);
    FillRectangleOnScreen(GUIC.foregroundClr, arrowArea);
    innerRect := InsetRectangle(arrowArea, 2);
    
    if up then
    begin
      tri[0] := RectangleBottomLeft(innerRect);
      tri[1] := RectangleBottomRight(innerRect);
      tri[2] := RectangleCenterTop(innerRect);
    end
    else
    begin
      tri[0] := RectangleTopLeft(innerRect);
      tri[1] := RectangleTopRight(innerRect);
      tri[2] := RectangleCenterBottom(innerRect);
    end;
    
    FillTriangleOnScreen(GUIC.backgroundClr, tri);
  end;
  procedure _DrawLeftRightArrow(const rect: Rectangle; left: Boolean);
  var
    tri: Triangle;
    innerRect, arrowArea: Rectangle;
  begin
    arrowArea := RectangleOffset(rect, areaPt);
    FillRectangleOnScreen(GUIC.foregroundClr, arrowArea);
    innerRect := InsetRectangle(arrowArea, 2);
    
    if left then
    begin
      tri[0] := RectangleCenterLeft(innerRect);
      tri[1] := RectangleBottomRight(innerRect);
      tri[2] := RectangleTopRight(innerRect);
    end
    else
    begin
      tri[0] := RectangleCenterRight(innerRect);
      tri[1] := RectangleTopLeft(innerRect);
      tri[2] := RectangleBottomLeft(innerRect);
    end;
    
    FillTriangleOnScreen(GUIC.backgroundClr, tri);
  end;
  
  procedure _ResizeItemArea(var area: Rectangle; var imgPt: Point2D; aligned: FontAlignment; bmp: bitmap);
  begin
    
    case aligned of
      AlignLeft, AlignCenter:
      begin
        area.Width := area.Width - BitmapWidth(bmp) - 1; // 1 pixel boundry for bitmap
        area.x     := area.x + BitmapWidth(bmp);
        imgPt.x := imgPt.x + 1;
      end;
      AlignRight:
      begin
        area.Width := area.Width - BitmapWidth(bmp) - 1;
        imgPt.x := imgPt.x + area.width + 1;
      end;
    end;
  end;
  
  procedure _DrawScrollPosition();
  var
    pct:              Single;
    largestStartIdx:  Integer;
  begin
    largestStartIdx := ListLargestStartIndex(tempList);
    
    // if the number of items is >= the number shown then pct := 0
    if largestStartIdx <= 0 then 
      pct := 0
    else 
    begin
      pct := tempList^.startingAt / largestStartIdx;
    end;
    
    if tempList^.verticalScroll then
    begin
      if GUIC.VectorDrawing then
        FillRectangleOnScreen(GUIC.foregroundClr, 
                              Round(scrollArea.x),
                              Round(scrollArea.y + pct * (scrollArea.Height - tempList^.scrollSize)),
                              tempList^.scrollSize,
                              tempList^.scrollSize
                              )
      else
        DrawBitmapOnScreen(tempList^.ScrollButton,
                            Round(scrollArea.x),
                            Round(scrollArea.y + pct * (scrollArea.Height - tempList^.scrollSize)));
    end
    else
    begin
      if GUIC.VectorDrawing then
        FillRectangleOnScreen(GUIC.foregroundClr, 
                              Round(scrollArea.x + pct * (scrollArea.Width - tempList^.scrollSize)),
                              Round(scrollArea.y),
                              tempList^.scrollSize,
                              tempList^.scrollSize
                              )
      else
        DrawBitmapOnScreen(tempList^.ScrollButton,
                            Round(scrollArea.x + pct * (scrollArea.Width - tempList^.scrollSize)),
                            Round(scrollArea.y));
    end;
  end;
begin
  tempList := ListFromRegion(forRegion);
  if not assigned(tempList) then exit;
  
  if GUIC.VectorDrawing then DrawRectangleOnScreen(GUIC.foregroundClr, area);
  
  PushClip(area);
  areaPt := RectangleTopLeft(area);
  
  // Draw the up and down buttons
  if GUIC.VectorDrawing then
  begin
    if tempList^.verticalScroll then
    begin
      _DrawUpDownArrow(tempList^.scrollUp, true);
      _DrawUpDownArrow(tempList^.scrollDown, false);
    end
    else
    begin
      _DrawLeftRightArrow(tempList^.scrollUp, true);
      _DrawLeftRightArrow(tempList^.scrollDown, false);    
    end;
  end;
  
  // Draw the scroll area
  scrollArea := RectangleOffset(tempList^.scrollArea, areaPt);
  
  if GUIC.VectorDrawing then
  begin
    DrawRectangleOnScreen(GUIC.backgroundClr, scrollArea);
    DrawRectangleOnScreen(GUIC.foregroundClr, scrollArea);
  end;
  
  // Draw the scroll position indicator
  PushClip(scrollArea);
  _DrawScrollPosition();
  PopClip(); // pop the scroll area
  
  //Draw all of the placeholders
  for i := Low(tempList^.placeHolder) to High(tempList^.placeHolder) do
  begin
    itemTextArea          := RectangleOffset(tempList^.placeHolder[i], areaPt);
    itemArea              := RectangleOffset(tempList^.placeHolder[i], areaPt);
    placeHolderScreenRect := RectangleOffset(tempList^.placeHolder[i], RectangleTopLeft(forRegion^.area));
    
    // Outline the item's area
    if GUIC.VectorDrawing then
      DrawRectangleOnScreen(GUIC.foregroundClr, itemArea);
    
    // Find the index of the first item to be shown in the list
    // NOTE: place holders in col then row order 0, 1 -> 2, 3 -> 4, 5 (for 2 cols x 3 rows)
    
    if tempList^.verticalScroll then
      itemIdx := i + tempList^.startingAt
    else
      // 0, 1 => 0, 3
      // 2, 3 => 1, 4
      // 4, 5 => 2, 5
      itemIdx := tempList^.startingAt + ((i mod tempList^.columns) * tempList^.rows) + (i div tempList^.columns);
      
    // Dont draw item details if out of range, but continue to draw outlines
    if (itemIdx < 0) OR (itemIdx > High(tempList^.items)) then continue;
    
    PushClip(itemArea);
    
    //Draw the text (adjusting position for width of list item bitmap)
    if assigned(tempList^.items[itemIdx].image) then
    begin
      // Determine the location of the list item's bitmap
      imagePt   := RectangleTopLeft(itemArea);    
      imagePt.y := imagePt.y + (itemArea.height - BitmapHeight(tempList^.items[itemidx].image)) / 2;
      
      _ResizeItemArea(itemTextArea, imagePt, ListFontAlignment(tempList), tempList^.items[itemIdx].image);
    end;
    
    if (itemIdx <> tempList^.activeItem) then
    begin
      DrawTextLinesOnScreen(ListItemText(tempList, itemIdx), 
                            GUIC.foregroundClr, GUIC.backgroundClr, 
                            ListFont(tempList), ListFontAlignment(tempList), 
                            itemTextArea);
    end
    else
    begin
      if GUIC.VectorDrawing then
      begin
        FillRectangleOnScreen(GUIC.foregroundClr, itemArea);
        DrawTextLinesOnScreen(ListItemText(tempList, itemIdx), 
                              GUIC.backgroundClr, GUIC.foregroundClr,
                              ListFont(tempList), ListFontAlignment(tempList),
                              itemTextArea);
      end
      else
      begin
        DrawBitmapPartOnscreen(forRegion^.parent^.panelBitmapActive,
                       placeHolderScreenRect,
                       RectangleTopLeft(itemArea));
        DrawTextLinesOnScreen(ListItemText(tempList, itemIdx), 
                     GUIC.foregroundClr, GUIC.backgroundClr, 
                     ListFont(tempList), ListFontAlignment(tempList),
                     itemTextArea);
      end;
    end;
    
    // Draw the item's bitmap
    if  assigned(tempList^.items[itemIdx].image) then
    begin
      DrawBitmapOnScreen(tempList^.items[itemIdx].image, imagePt);
    end;
    
    PopClip(); // item area
  end;
  
  PopClip(); // region
end;

procedure DrawLabelText(forRegion: Region; const area: Rectangle);
begin
  DrawTextLinesOnScreen(LabelText(forRegion), 
                        GUIC.foregroundClr,
                        GUIC.backgroundClr, 
                        LabelFont(forRegion),
                        LabelAlignment(forRegion), 
                        TextboxTextArea(area));
end;

procedure DrawAsVectors();
var
  i, j: integer;
  current: Panel;
  currentReg: Region;
begin
  for i := Low(GUIC.visiblePanels) to High(GUIC.visiblePanels) do
  begin
    current := GUIC.visiblePanels[i];
    
    FillRectangleOnScreen(GUIC.backgroundClr, current^.area);
    DrawRectangleOnScreen(GUIC.foregroundClr, current^.area);
    PushClip(current^.area);
    
    for j := High(current^.Regions) downto Low(current^.Regions) do
    begin
      currentReg := @GUIC.visiblePanels[i]^.Regions[j];
      case currentReg^.kind of
        gkButton:     DrawRectangleOnScreen(GUIC.foregroundClr, RegionRectangleOnscreen(currentReg));
        gkLabel:      DrawLabelText(currentReg, RegionRectangleOnscreen(currentReg));
        gkCheckbox:   DrawVectorCheckbox(currentReg, RegionRectangleOnScreen(currentReg));
        gkRadioGroup: DrawVectorRadioButton(currentReg, RegionRectangleOnScreen(currentReg));
        gkTextbox:    DrawTextbox(currentReg, RegionRectangleOnScreen(currentReg));
        gkList:       DrawList(currentReg, RegionRectangleOnScreen(currentReg));
      end;
    end;
    
    PopClip();
  end;
end;

procedure DrawBitmapCheckbox(forRegion: Region; const area: Rectangle);
begin
  DrawBitmapPartOnScreen(BitmapToDraw(forRegion), forRegion^.area, RectangleTopLeft(area));
end;

procedure DrawBitmapRadioGroup(forRegion: Region; const area: Rectangle);
begin
  DrawBitmapPartOnScreen(BitmapToDraw(forRegion), forRegion^.area, RectangleTopLeft(area));
end;

procedure DrawAsBitmaps();
var
  i, j: integer;
  currentReg: Region;
begin
  for i := Low(GUIC.visiblePanels) to High(GUIC.visiblePanels) do
  begin
    if GUIC.visiblePanels[i]^.visible then
      DrawBitmapOnScreen(GUIC.visiblePanels[i]^.panelBitmap, RectangleTopLeft(GUIC.visiblePanels[i]^.area));
      
    for j := Low(GUIC.visiblePanels[i]^.Regions) to High(GUIC.visiblePanels[i]^.Regions) do
    begin
      currentReg := @GUIC.visiblePanels[i]^.Regions[j];
      case GUIC.visiblePanels[i]^.Regions[j].kind of
        gkButton: DrawBitmapPartOnscreen(BitmapToDraw(currentReg), currentReg^.area, RectangleTopLeft(RegionRectangleOnScreen(currentReg)));
        gkLabel: DrawLabelText(currentReg, RegionRectangleOnscreen(currentReg));
        gkTextbox: DrawTextbox(currentReg, RegionRectangleOnScreen(currentReg));
        gkCheckbox: DrawBitmapCheckbox(currentReg, RegionRectangleOnScreen(currentReg));
        gkRadioGroup: DrawBitmapRadioGroup(currentReg, RegionRectangleOnScreen(currentReg));
        gkList: DrawList(currentReg, RegionRectangleOnScreen(currentReg));
      end;
    end;
  end;
end;
  
procedure DrawPanels();
begin
  if GUIC.VectorDrawing then
    DrawAsVectors()
  else
    DrawAsBitmaps();
end;

//---------------------------------------------------------------------------------------
// Region Code
//---------------------------------------------------------------------------------------

function RegionWidth(r: Region): LongInt;
begin
  result := -1;
  if not(assigned(r)) then exit;
  
  result := r^.area.width;
end;

function RegionHeight(r: Region): LongInt;
begin
  result := -1;
  if not(assigned(r)) then exit;
  
  result := r^.area.height;
end;

function RegionX(r: Region): Single;
begin
  result := -1;
  
  if not(assigned(r)) then exit;
  
  result := r^.area.x;
end;

function RegionY(r: Region): Single;
begin
  result := -1;
  if not(assigned(r)) then exit;
  
  result := r^.area.y;
end;

procedure SetRegionActive(forRegion: Region; b: boolean);
begin
  if not assigned(forRegion) then exit;

  forRegion^.active := b;
end;

procedure ToggleRegionActive(forRegion: Region);
begin
  if not assigned(forRegion) then exit;
  
  forRegion^.active := not forRegion^.active;
end;

function RegionWithID(pnl: Panel; ID: String): Region; overload;
var
  idx: Integer;
begin
  result := nil;
  if not assigned(pnl) then exit;
  
  idx := IndexOf(pnl^.regionIds, ID);
  if idx >= 0 then
  begin
    result := @pnl^.regions[idx];
  end;  
end;

function RegionWithID(ID: String): Region; overload;
var
  i: integer;
begin
  result := nil;
  
  for i := Low(GUIC.panels) to High(GUIC.panels) do
  begin
    result := RegionWithID(GUIC.panels[i], ID);
    if assigned(result) then exit;
  end;
end;

function RegionID(r: Region): string;
begin
  if assigned(r) then
    result := r^.stringID
  else
    result := '';
end;

// Check which of the regions was clicked in this panel
procedure HandlePanelInput(pnl: Panel);
  procedure _ScrollWithScrollArea(lst: GUIList; mouse: Point2D);
  var
    largestStartIdx: LongInt;
    pct: Single;
  begin
    GUIC.lastClicked := nil;
    largestStartIdx := ListLargestStartIndex(lst);
    
    if lst^.verticalScroll then
      pct := (mouse.y - lst^.scrollArea.y) / lst^.scrollArea.height
    else
      pct := (mouse.x - lst^.scrollArea.x) / lst^.scrollArea.width;
    
    lst^.startingAt := Round(pct * largestStartIdx / ListScrollIncrement(lst)) * ListScrollIncrement(lst);
    exit;
  end;
  
  procedure _ScrollUp(lst: GUIList);
  var
    inc: LongInt;
  begin
    inc := ListScrollIncrement(lst);
    
    if lst^.startingAt >= inc then 
      lst^.startingAt := lst^.startingAt - inc;
  end;
  
  procedure _ScrollDown(lst: GUIList);
  var
    inc, largestStartIdx: LongInt;
  begin
    inc := ListScrollIncrement(lst);
    largestStartIdx := ListLargestStartIndex(lst);
    
    if lst^.startingAt + inc <= largestStartIdx then
      lst^.startingAt := lst^.startingAt + inc;
  end;
  
  procedure _PerformListClicked(lst: GUIList; pointClicked: Point2D);
  var
    i: LongInt;
  begin
    if not assigned(lst) then exit;
    
    // WriteLn(PointToString(pointClicked));
    // Write(lst^.startingAt);
    
    // itemCount  := Length(lst^.items);
    // placeCount := lst^.rows * lst^.columns;
    
    // Check up and down scrolling...
    if PointInRect(pointClicked, lst^.scrollUp) then
    begin
      _ScrollUp(lst);
      // WriteLn(' -> ', lst^.startingAt);
      GUIC.lastClicked := nil; // click in scroller...
      exit;
    end
    else if PointInRect(pointClicked, lst^.scrollDown) then
    begin
      _ScrollDown(lst);
      // WriteLn(' -> ', lst^.startingAt);
      GUIC.lastClicked := nil; // click in scroller...
      exit;
    end
    else if PointInRect(pointClicked, lst^.scrollArea) then
    begin
      _ScrollWithScrollArea(lst, pointClicked);
      exit;
    end;
    
    // WriteLn(' -> ', lst^.startingAt);
    
    for i := Low(lst^.placeHolder) to High(lst^.placeHolder) do
    begin
      if PointInRect(pointClicked, lst^.placeHolder[i]) then
      begin
        lst^.activeItem := lst^.startingAt + i;
        exit;
      end;
    end;
  end;
  
  procedure _PerformMouseDownOnList(lst: GUIList; mouse: Point2D);
  begin
    if PointInRect(mouse, lst^.scrollArea) then
    begin
      _ScrollWithScrollArea(lst, mouse);
    end;
  end;
  
  procedure _UpdateMouseDown(mouse: Point2D);
  var
    pointDownInRegion: Point2D;
    r: Region;
  begin
    if ReadingText() then
      FinishReadingText();
    
    r := RegionAtPoint(pnl, mouse);
    if not assigned(r) then exit;
    
    // Adjust the mouse point into the region's coordinates (offset from top left of region)
    pointDownInRegion := PointAdd(mouse, InvertVector(RectangleTopLeft(r^.area)));
    
    // Perform kind based updating
    case r^.kind of
      gkList: _PerformMouseDownOnList(ListFromRegion(r), pointDownInRegion);
    end;
  end;
  
  procedure _UpdateScrollUp(mouse: Point2D);
  var
    r: Region;
  begin
    r := RegionAtPoint(pnl, mouse);
    if not assigned(r) then exit;
    
    // Perform kind based updating
    case r^.kind of
      gkList: _ScrollUp(ListFromRegion(r));
    end;
  end;
  
  procedure _UpdateScrollDown(mouse: Point2D);
  var
    r: Region;
  begin
    r := RegionAtPoint(pnl, mouse);
    if not assigned(r) then exit;
    
    // Perform kind based updating
    case r^.kind of
      gkList: _ScrollDown(ListFromRegion(r));
    end;
  end;
  
  procedure _UpdateMouseClicked(pointClicked: Point2D);
  var
    pointClickedInRegion: Point2D;
    r: Region;
  begin
    if ReadingText() then
      FinishReadingText();
    
    r := RegionAtPoint(pnl, pointClicked);
    if not assigned(r) then exit;
    
    GUIC.lastClicked := r;
    
    // Adjust the mouse point into the region's coordinates (offset from top left of region)
    pointClickedInRegion := PointAdd(pointClicked, InvertVector(RectangleTopLeft(r^.area)));
    
    // Perform kind based updating
    case r^.kind of
      gkCheckBox:     ToggleCheckboxState (CheckboxFromRegion(r) );
      gkRadioGroup:   SelectRadioButton   (RadioGroupFromRegion(r), r );
      gkTextBox:      GUISetActiveTextbox (TextBoxFromRegion(r) );
      gkList:         _PerformListClicked(ListFromRegion(r), pointClickedInRegion);
    end;
  end;

var
  pointClickedInPnl: Point2D;
begin
  if pnl = nil then exit;
  if not pnl^.active then exit;
  
  // Adjust the mouse point into this panels area (offset from top left of pnl)
  pointClickedInPnl := PointAdd(MousePosition(), InvertVector(RectangleTopLeft(pnl^.area)));
  
  if MouseClicked(LeftButton)   then _UpdateMouseClicked(pointClickedInPnl)
  else if MouseDown(LeftButton) then _UpdateMouseDown(pointClickedInPnl)
  else if MouseClicked(WheelUpButton)   then _UpdateScrollUp(pointClickedInPnl)
  else if MouseClicked(WheelDownButton) then _UpdateScrollDown(pointClickedInPnl)
end;

function RegionClicked(): region;
begin   
  result := nil;  
  if not assigned(GUIC.lastClicked) then exit;
  
  result := GUIC.lastClicked;
end;

function RegionClickedID(): String;
begin
  result := '';
  if not assigned(GUIC.lastClicked) then exit;
  
  result := RegionID(GUIC.lastClicked);
end;

function RegionPanel(r: Region): Panel;
begin
  result := nil;
  if not assigned(r) then exit;
  
  result := r^.parent;
end;

function RegionAtPoint(p: Panel; const pt: Point2D): Region;
var
  i: Integer;
  current: Region;
begin
  result := nil;
  if not assigned(p) then exit;
  
  for i := Low(p^.Regions) to High(p^.Regions) do
  begin
    // Get the region at the i index
    current := @p^.Regions[i];
    
    //Check if it has been clicked
    if PointInRect(pt, current^.area) then
    begin
      result := current;
      exit;
    end;
  end;
end;
//---------------------------------------------------------------------------------------
// Get element from region
//---------------------------------------------------------------------------------------

function RadioGroupFromRegion(r: Region): GUIRadioGroup;
begin
  result := nil;
  
  if not assigned(r) then exit;
  if not assigned(r^.parent) then exit;
  if not (r^.kind = gkRadioGroup) then exit;
  if (r^.elementIndex < 0) or (r^.elementIndex > High(r^.parent^.radioGroups)) then exit;

  result := @r^.parent^.radioGroups[r^.elementIndex];
end;

function RadioGroupFromId(pnl: Panel; id: String): GUIRadioGroup;
var
  i: Integer;
begin
  result := nil;
  if not assigned(pnl) then exit;
  
  id := LowerCase(id);
  
  for i := 0 to High(pnl^.radioGroups) do
  begin
    if LowerCase(pnl^.radioGroups[i].groupID) = id then
    begin
      result := @pnl^.radioGroups[i];
      exit;
    end;
  end;
end;

function LabelFromRegion(r: Region): GUILabel; overload;
begin
  result := nil;
  
  if not assigned(r) then exit;
  if not assigned(r^.parent) then exit;
  if not (r^.kind = gkLabel) then exit;
  if (r^.elementIndex < 0) or (r^.elementIndex > High(r^.parent^.labels)) then exit;
  
  //Return a pointer to the label in the panel
  result := @r^.parent^.labels[r^.elementIndex]
end;

function TextBoxFromRegion(r: Region): GUITextBox;
begin
  result := nil;
  
  if not assigned(r) then exit;
  if not assigned(r^.parent) then exit;
  if not (r^.kind = gkTextbox) then exit;
  if (r^.elementIndex < 0) or (r^.elementIndex > High(r^.parent^.textBoxes)) then exit;
  
  result := @r^.parent^.textBoxes[r^.elementIndex]
end;

function ListFromRegion(r: Region): GUIList; overload;
begin
  result := nil;
  
  if not assigned(r) then exit;
  if not assigned(r^.parent) then exit;
  if not (r^.kind = gkList) then exit;
  if (r^.elementIndex < 0) or (r^.elementIndex > High(r^.parent^.lists)) then exit;
  
  result := @r^.parent^.lists[r^.elementIndex]
end;

function CheckboxFromRegion(r: Region): GUICheckbox;
begin
  result := nil;
  
  if not assigned(r) then exit;
  if not assigned(r^.parent) then exit;
  if not (r^.kind = gkCheckBox) then exit;
  if (r^.elementIndex < 0) or (r^.elementIndex > High(r^.parent^.checkboxes)) then exit;
  
  result := @r^.parent^.checkboxes[r^.elementIndex];
end;


//---------------------------------------------------------------------------------------
// RadioGroup Code
//---------------------------------------------------------------------------------------

function ActiveRadioButtonIndex(RadioGroup: GUIRadioGroup): integer;
begin
  result := -1;
  if not(assigned(RadioGroup)) then exit;
  result := RadioGroup^.activeButton;
end;

function ActionRadioButton(r: Region): Region;
begin
  result := ActionRadioButton(RadioGroupFromRegion(r));
end;

function ActionRadioButton(grp: GUIRadioGroup): Region;
begin
  result := nil;
  if not assigned(grp) then exit;
  if (grp^.activeButton < 0) or (grp^.activeButton > High(grp^.buttons)) then exit;
  
  result := grp^.buttons[grp^.activeButton];
end;

procedure SelectRadioButton(r: Region); overload;
begin
  SelectRadioButton(RadioGroupFromRegion(r), r);
end;

procedure SelectRadioButton(rGroup: GUIRadioGroup; r: Region); overload;
var
  i: integer;
begin
  if not assigned(rGroup) then exit;
  if RadioGroupFromRegion(r) <> rGroup then exit;
    
  // Remove the selection ...
  rGroup^.activeButton := -1;
  
  // Find this button in the group and select it
  for i := Low(rGroup^.buttons) to High(rGroup^.buttons) do
  begin
    if rGroup^.buttons[i] = r then
    begin
      rGroup^.activeButton := i;
      exit;
    end;
  end;
end;

//---------------------------------------------------------------------------------------
// Label Code
//---------------------------------------------------------------------------------------

procedure LabelSetText(pnl: Panel; id, newString: String); overload;
begin
  LabelSetText(LabelFromRegion(RegionWithID(pnl, id)), newString);
end;

procedure LabelSetText(r: Region; newString: String); overload;
begin
  LabelSetText(LabelFromRegion(r), newString);
end;

procedure LabelSetText(lb: GUILabel; newString: String);
begin
  if not assigned(lb) then exit;  
  
  lb^.contentString := newString;
end;

procedure LabelSetFont(l: GUILabel; s: String);
begin
  if not assigned(l) then exit;
  l^.font := FontNamed(s);
end;

function LabelFont(r: Region): Font; overload;
begin
  result := LabelFont(LabelFromRegion(r));
end;

function LabelFont(l: GUILabel): Font;
begin
  result := nil;
  if not assigned(l) then exit;
  
  result := l^.font;
end;

function LabelAlignment(r: Region): FontAlignment;
begin
  result := LabelAlignment(LabelFromRegion(r));
end;

function LabelAlignment(tb: GUILabel): FontAlignment;
begin
  result := AlignLeft;
  if not assigned(tb) then exit;
  
  result := tb^.alignment;
end;

procedure LabelSetAlignment(tb: GUILabel; align: FontAlignment);
begin
  if not assigned(tb) then exit;
  
  tb^.alignment := align;
end;

procedure LabelSetAlignment(r: Region; align: FontAlignment);
begin
  LabelSetAlignment(LabelFromRegion(r), align);
end;


function LabelText(lb: GUILabel): String; overload;
begin
  if assigned(lb) then
    result := lb^.contentString
  else
    result := '';
end;

function LabelText(r: Region): String; overload;
begin
  result := LabelText(LabelFromRegion(r));
end;

//---------------------------------------------------------------------------------------
// Textbox Code
//---------------------------------------------------------------------------------------

procedure TextboxSetFont(Tb: GUITextbox; f: font);
begin
  if not(assigned(tb)) OR not(assigned(f)) then exit;

  Tb^.font := f;
end;

function TextBoxFont(r: Region): Font; overload;
begin
  result := TextBoxFont(TextBoxFromRegion(r));
end;

function TextBoxFont(tb: GUITextBox): Font; overload;
begin
  result := nil;
  if not assigned(tb) then exit;
  
  result := tb^.font;
end;

procedure TextboxSetText(r: Region; s: string); overload;
begin
  TextboxSetText(TextBoxFromRegion(r), s);
end;

procedure TextboxSetText(r: Region; i: LongInt); overload;
begin
  TextboxSetText(TextBoxFromRegion(r), IntToStr(i));
end;

procedure TextboxSetText(r: Region; single: Single); overload;
begin
  TextboxSetText(TextBoxFromRegion(r), FloatToStr(single));
end;

procedure TextboxSetText(tb: GUITextBox; s: string); overload;
begin
  if assigned(tb) then
    tb^.contentString := s;
end;

procedure TextboxSetText(tb: GUITextBox; i: LongInt); overload;
begin
  TextboxSetText(tb, IntToStr(i));
end;

procedure TextboxSetText(tb: GUITextBox; single: Single); overload;
begin
  TextboxSetText(tb, FloatToStr(single));
end;

function TextBoxText(r: Region): String; overload;
begin
  result := TextBoxText(TextBoxFromRegion(r));
end;

function TextBoxText(tb: GUITextBox): String; overload;
begin
  result := '';
  if not assigned(tb) then exit;
  
  result := tb^.contentString;
end;

function LastTextRead(): string;
begin
  result := GUIC.lastTextRead;
end;

procedure FinishReadingText();
begin
  if not assigned(GUIC.activeTextBox) then exit;
  
  GUIC.lastTextRead := TextBoxText(GUIC.activeTextBox);
  TextboxSetText(GUIC.activeTextBox, EndReadingText());
  
  GUIC.lastActiveTextBox := GUIC.activeTextBox;
  GUIC.activeTextBox := nil;
  GUIC.doneReading := true;
end;

procedure GUISetActiveTextbox(r: Region);
begin
  GUISetActiveTextbox(TextBoxFromRegion(r));
end;

procedure GUISetActiveTextbox(t: GUITextbox);
begin
  if not assigned(t) then exit;
  
  GUIC.activeTextBox := t^.region;
  
  if ReadingText() then FinishReadingText();
  
  StartReadingTextWithText( t^.contentString, 
                            GUIC.foregroundClr, 
                            t^.lengthLimit, 
                            t^.Font, 
                            InsetRectangle(TextboxTextArea(t^.region), 1)); // Need to inset 1 further to match printing text lines
end;

function TextboxAlignment(r: Region): FontAlignment;
begin
  result := TextboxAlignment(TextBoxFromRegion(r));
end;

function TextboxAlignment(tb: GUITextbox): FontAlignment;
begin
  result := AlignLeft;
  if not assigned(tb) then exit;
  
  result := tb^.alignment;
end;

procedure TextboxSetAlignment(tb: GUITextbox; align: FontAlignment);
begin
  if not assigned(tb) then exit;
  
  tb^.alignment := align;
end;

procedure TextboxSetAlignment(r: Region; align: FontAlignment);
begin
  TextboxSetAlignment(TextBoxFromRegion(r), align);
end;

//---------------------------------------------------------------------------------------
// List Code
//---------------------------------------------------------------------------------------


function ListActiveItemText(pnl: Panel; ID: String): String; overload;
var
  r: Region;
begin
  result := '';
  if not assigned(pnl) then exit;
  r := RegionWithID(pnl, ID);

  Result := ListItemText(r, ListActiveItemIndex(r));
end;

function ListActiveItemText(r:region):String; Overload;
begin
  Result := ListItemText(r, ListActiveItemIndex(r));
end;


procedure ListSetActiveItemIndex(lst: GUIList; idx: LongInt);
begin
  if not assigned(lst) then exit;
  lst^.activeItem := idx;
end;

procedure ListSetFont(lst: GUITextbox; f: font);
begin
  if not(assigned(lst)) OR not(assigned(f)) then exit;

  lst^.font := f;
end;


function ListFont(r: Region): Font; overload;
begin
  result := ListFont(ListFromRegion(r));
end;

function ListFont(lst: GUIList): Font; overload;
begin
  result := nil;
  if not assigned(lst) then exit;
  
  result := lst^.font;
end;

function ListItemText(r: Region; idx: LongInt): String; overload;
begin
  result := ListItemText(ListFromRegion(r), idx);
end;

function ListItemText(lst: GUIList; idx: LongInt): String; overload;
begin
  result := '';
  if not assigned(lst) then exit;
  if (idx < 0) or (idx > High(lst^.items)) then exit;
  
  result := lst^.items[idx].text;
end;

function ListItemCount(r: Region): LongInt; overload;
begin
  result := ListItemCount(ListFromRegion(r));
end;

function ListItemCount(lst:GUIList): LongInt; overload;
begin
  result := 0;
  if not assigned(lst) then exit;
  
  result := Length(lst^.items);
end;

procedure ListAddItem(lst: GUIList; text: String);
begin
  ListAddItem(lst, nil, text);
end;

procedure ListAddItem(lst: GUIList; img:Bitmap);
begin
  ListAddItem(lst, img, '');
end;

procedure ListAddItem(lst: GUIList; img:Bitmap; text: String); overload;
begin
    if not assigned(lst) then exit;
    
    SetLength(lst^.items, Length(lst^.items) + 1);
    lst^.items[High(lst^.items)].text     := text;  //Assign the text to the item
    lst^.items[High(lst^.items)].image := img; //Assign the image to the item
end;

procedure ListAddItem(r : Region; text: String); overload;
begin
  ListAddItem(ListFromRegion(r), text);
end;

procedure ListAddItem(r : Region; img:Bitmap); overload;
begin
  ListAddItem(ListFromRegion(r), img);
end;

procedure ListAddItem(r : Region; img:Bitmap; text: String); overload;
begin
  ListAddItem(ListFromRegion(r),img, text);
end;

procedure ListClearItems(lst: GUIList); overload;
begin
  if not assigned(lst) then exit;
  
  SetLength(lst^.items, 0);
  lst^.activeItem := -1;
  lst^.startingAt := 0;
end;

procedure ListClearItems(r : Region); overload;
begin
  ListClearItems(ListFromRegion(r));
end;

procedure ListRemoveItem(lst: GUIList; idx: LongInt);
var
  i: LongInt;
begin
    if not assigned(lst) then exit;
    if (idx < 0) or (idx > High(lst^.items)) then exit;
    
    for i := idx to High(lst^.items) - 1 do
    begin
      lst^.items[i] := lst^.items[i + 1];
    end;
    
    SetLength(lst^.items, Length(lst^.items) - 1);
    
    if lst^.startingAt >= idx then lst^.startingAt := lst^.startingAt - 1;
    if lst^.activeItem >= idx then lst^.activeItem := lst^.activeItem - 1;
end;

function ListTextIndex(lst: GUIList; value: String): LongInt;
var
  i: LongInt;
begin
  result := -1;
  if not assigned(lst) then exit;
  
  for i := Low(lst^.items) to High(lst^.items) do
  begin
    //find the text... then exit
    if lst^.items[i].text = value then
    begin
      result := i;
      exit;
    end;
  end;
end;

function ListBitmapIndex(lst: GUIList; img: Bitmap): LongInt;
var
  i: LongInt;
begin
  result := -1;
  if not assigned(lst) then exit;
  
  for i := Low(lst^.items) to High(lst^.items) do
  begin
    //find the text... then exit
    if lst^.items[i].image = img then
    begin
      result := i;
      exit;
    end;
  end;
end;

function ListScrollIncrement(lst: GUIList): LongInt;
begin
  result := 1;
  if not assigned(lst) then exit;
  
  if lst^.verticalScroll then
    result := lst^.columns
  else
    result := lst^.rows;
    
  if result <= 0 then result := 1;
end;

function ListActiveItemIndex(r: Region): LongInt; overload;
begin
  result := ListActiveItemIndex(ListFromRegion(r));
end;

function ListActiveItemIndex(lst: GUIList): LongInt; overload;
begin
  result := -1;
  if not assigned(lst) then exit;
  result := lst^.activeItem;
end;

function ListStartAt(lst: GUIList): LongInt;
begin
  result := 0;
  if not assigned(lst) then exit;
  
  result := lst^.startingAt;
end;

function ListStartAt(r: Region): LongInt;
begin
  result := ListStartAt(ListFromRegion(r));
end;

procedure ListSetStartAt(lst: GUIList; idx: LongInt);
begin
  if not assigned(lst) then exit;
  if (idx < 0) then idx := 0
  else if (idx > High(lst^.items)) then idx := (High(lst^.items) div ListScrollIncrement(lst)) * ListScrollIncrement(lst);
  
  lst^.startingAt := idx;
end;

procedure ListSetStartAt(r: Region; idx: LongInt);
begin
  ListSetStartAt(ListFromRegion(r), idx);
end;

function ListFontAlignment(r: Region): FontAlignment;
begin
  result := ListFontAlignment(ListFromRegion(r));
end;

function ListFontAlignment(lst: GUIList): FontAlignment;
begin
  result := AlignLeft;
  if not assigned(lst) then exit;
  
  result := lst^.alignment;
end;

procedure ListSetFontAlignment(r: Region; align: FontAlignment);
begin
  ListSetFontAlignment(ListFromRegion(r), align);
end;

procedure ListSetFontAlignment(lst: GUIList; align: FontAlignment);
begin
  if not assigned(lst) then exit;
  
  lst^.alignment := align;
end;

function ListLargestStartIndex(lst: GUIList): LongInt;
var
  placeCount:       Integer;
  itemCount:        Integer;
begin
 result := 0;
 if not assigned(lst) then exit;
   
 itemCount  := Length(lst^.items);
 placeCount := lst^.rows * lst^.columns;
 result     := itemCount - placeCount;
 
 // Round
 result := Ceiling(result / ListScrollIncrement(lst)) * ListScrollIncrement(lst);
end;

//---------------------------------------------------------------------------------------
// Checkbox Code Code
//---------------------------------------------------------------------------------------

function CheckboxState(chk: GUICheckbox): Boolean; overload;
begin
  if not assigned(chk) then begin result := false; exit; end;
  
  result := chk^.state;
end;

function CheckboxState(r: Region): Boolean; overload;
begin
  result := CheckboxState(CheckboxFromRegion(r));
end;

function CheckboxState(s: String): Boolean; overload;
begin
  result := CheckboxState(CheckboxFromRegion(RegionWithID(s)));
end;

procedure CheckboxSetState(chk: GUICheckbox; val: Boolean); overload;
begin
  if not assigned(chk) then exit;
  
  chk^.state := val;
end;

procedure CheckboxSetState(r: region; val: Boolean); overload;
begin
  CheckboxSetState(CheckboxFromRegion(r), val);
end;


// function CheckboxState(ID: String): Boolean;
// var
//   reg: Region;
// begin
//   reg := GetRegionByID(ID);
//   result := reg^.parent^.checkboxes[reg^.elementIndex].state;
// end;

procedure ToggleCheckboxState(c: GUICheckbox);
begin
  if not assigned(c) then exit;

  c^.state := not c^.state;
end;

//---------------------------------------------------------------------------------------
// Panel Code
//---------------------------------------------------------------------------------------

function PanelDraggable(p: panel): boolean;
begin
  if not assigned(p) then exit;
  
  Result := p^.draggable;
end;

procedure PanelSetDraggable(p: panel; b:boolean);
begin
  if not assigned(p) then exit;
  
   p^.draggable := b;
end;

procedure PanelSetX(p: Panel; nX: LongInt);
begin
  if not(assigned(p)) then exit;
  
  p^.area.X := nX;
end;

procedure PanelSetY(p: Panel; nY: LongInt);
begin
  if not(assigned(p)) then exit;
  
  p^.area.Y := nY;
end;

function PanelWidth(p: Panel): LongInt;
begin
  result := -1;
  if not(assigned(p)) then exit;
  
  result := p^.area.width;
end;

function PanelHeight(p: Panel): LongInt;
begin
  result := -1;
  if not(assigned(p)) then exit;
  
  result := p^.area.height;
end;

function PanelX(p: Panel): Single;
begin
  result := -1;
  if not(assigned(p)) then exit;
  
  result := p^.area.x;
end;

function PanelY(p: Panel): Single;
begin
  result := -1;
  if not(assigned(p)) then exit;
  
  result := p^.area.y;
end;

function PanelVisible(p: Panel): boolean;
begin
  result := false;
  if not(assigned(p)) then exit;
  
  result := p^.visible;
end;

procedure AddPanelToGUI(p: Panel);
begin
  if assigned(p) then
  begin
    SetLength(GUIC.panels, Length(GUIC.panels) + 1);
    GUIC.panels[High(GUIC.panels)] := p;
  end;
end;

procedure ActivatePanel(p: Panel);
begin
  if assigned(p) then p^.active := true;
end;

procedure DeactivatePanel(p: Panel);
begin
  if assigned(p) then p^.active := false;
end;

procedure ToggleActivatePanel(p: Panel);
begin
  if assigned(p) then p^.active := not p^.active;
end;

procedure ShowPanel(p: Panel);
begin
  if assigned(p) and (not p^.visible) then ToggleShowPanel(p);
end;

procedure HidePanel(p: Panel);
begin
  if assigned(p) and (p^.visible) then ToggleShowPanel(p);
end;

procedure ToggleShowPanel(p: Panel);
var
  i: Integer;
  found: Boolean;
begin
  if assigned(p) then
  begin
    p^.visible := not p^.visible;
    
    if p^.visible then
    begin
      // Now visible so add to the visible panels
      SetLength(GUIC.visiblePanels, Length(GUIC.visiblePanels) + 1);
      GUIC.visiblePanels[High(GUIC.visiblePanels)] := p;
    end
    else
    begin
      // No longer visible - remove from visible panels
      found := false;
      
      // Search for panel and remove from visible panels
      for i := 0 to High(GUIC.visiblePanels) do
      begin
        if (not found) then
        begin
          if (p = GUIC.visiblePanels[i]) then found := true;
        end
        else // found - so copy over...
          GUIC.visiblePanels[i - 1] := GUIC.visiblePanels[i]
      end;
      
      SetLength(GUIC.visiblePanels, Length(GUIC.visiblePanels) - 1);
    end;
  end;
end;

function MousePointInPanel(pnl: Panel): Point2D;
begin
  result.x := -1; result.y := -1;
  if not assigned(pnl) then exit;
  
  result := PointAdd(MousePosition(), InvertVector(RectangleTopLeft(pnl^.area)));
end;

function PanelClicked(): Panel;
begin
  result := nil;
  if not MouseClicked(Leftbutton) then exit;
  
  result := PanelAtPoint(MousePosition());
end;

//=============================================================================
// Create Panels/GUI Elements/Regions etc.
//=============================================================================

function DoLoadPanel(filename, name: string): Panel;
var
  pathToFile, line, id, data: string;
  panelFile: text;
  lineNo: integer;
  regionDataArr: Array of String;
  
  function StringToKind(s: String): GUIElementKind;
  begin
    if Lowercase(s) = 'button' then
      result := gkButton
    else if Lowercase(s) = 'label' then
      result := gkLabel
    else if Lowercase(s) = 'textbox' then
      result := gkTextBox
    else if Lowercase(s) = 'checkbox' then
      result := gkCheckBox
    else if Lowercase(s) = 'radiogroup' then
      result := gkRadioGroup
    else if Lowercase(s) = 'list' then
      result := gkList
    else 
      RaiseException(s + ' is an invalid kind for region.');

  end;
  
  procedure CreateLabel(forRegion: Region; d: string);
  var
    newLbl: GUILabelData;
  begin
    //Format is
    // 1, 2, 3, 4, 5, 6,   7,    8,     9, 
    // x, y, w, h, 5, id , font, align, text
    newLbl.font           := FontNamed(Trim(ExtractDelimited(7, d, [','])));
    newLbl.alignment      := TextAlignmentFrom(Trim(ExtractDelimited(8, d, [','])));
    newLbl.contentString  := Trim(ExtractDelimited(9, d, [',']));
    
    SetLength(result^.Labels, Length(result^.Labels) + 1);
    result^.labels[High(result^.labels)] := newLbl;
    forRegion^.elementIndex := High(result^.labels);  // The label index for the region -> so it knows which label
  end;
  
  procedure AddRegionToGroup(regToAdd: Region; groupToRecieve: GUIRadioGroup);
  begin
    SetLength(groupToRecieve^.buttons, Length(groupToRecieve^.buttons) + 1);
    groupToRecieve^.buttons[High(groupToRecieve^.buttons)] := regToAdd;    
  end;
  
  procedure CreateRadioButton(forRegion: Region; data: String);
  var
    newRadioGroup: GUIRadioGroupData;
    i: Integer;
    radioGroupID: string;
  begin
    radioGroupID := Trim(ExtractDelimited(7,data,[',']));
    
    for i := Low(result^.radioGroups) to High(result^.radioGroups) do
    begin
      if (radioGroupID = result^.radioGroups[i].GroupID) then
      begin
        AddRegionToGroup(forRegion, @result^.radioGroups[i]);
        forRegion^.elementIndex := i;
        exit;
      end;
    end;
    
    SetLength(newRadioGroup.buttons, 0);
    newRadioGroup.GroupID := radioGroupID;
    AddRegionToGroup(forRegion, @newRadioGroup);
    
    newRadioGroup.activeButton := 0;
    // add to panel, record element index.
    SetLength(result^.radioGroups, Length(result^.radioGroups) + 1);
    result^.radioGroups[High(result^.radioGroups)] := newRadioGroup;
    forRegion^.elementIndex := High(result^.radioGroups);
  end;
  
  procedure CreateCheckbox(forRegion: Region; data: string);
  var
    newChkbox: GUICheckboxData;
  begin
    newChkbox.state := LowerCase(ExtractDelimited(7, data, [','])) = 'true';
    
    SetLength(result^.Checkboxes, Length(result^.Checkboxes) + 1);
    result^.Checkboxes[High(result^.Checkboxes)] := newChkbox;
    forRegion^.elementIndex := High(result^.Checkboxes);
  end;
  
  procedure CreateTextbox(r: region; data: string);
  var
    newTextbox: GUITextboxData;
  begin
    //Format is
    // 1, 2, 3, 4, 5, 6,   7,    8,      9,     10, 
    // x, y, w, h, 5, id , font, maxLen, align, text
    
    if CountDelimiter(data, ',') <> 9 then
    begin
      RaiseException('Error with textbox (' + data + ') should have 10 values (x, y, w, h, 5, id, font, maxLen, align, text)');
      exit;
    end;
    
    newTextbox.font           := FontNamed(Trim(ExtractDelimited(7, data, [','])));
    newTextbox.lengthLimit    := StrToInt(Trim(ExtractDelimited(8, data, [','])));
    newTextBox.alignment      := TextAlignmentFrom(Trim(ExtractDelimited(9, data, [','])));
    newTextBox.contentString  := Trim(ExtractDelimited(10, data, [',']));
    newTextBox.region         := r;
    
    SetLength(result^.textBoxes, Length(result^.textBoxes) + 1);
    result^.textBoxes[High(result^.textBoxes)] := newTextbox;
    r^.ElementIndex := High(result^.textBoxes);
  end;
  
  procedure CreateList(r: Region; data: string);
  var
    newList: GUIListData;
    scrollSz, rhs, btm, height, width: LongInt;
  begin
    //Format is
    // 1, 2, 3, 4, 5, 6,      7,       8,    9,          10,     11,        12,         13          14                  
    // x, y, w, h, 5, ListID, Columns, Rows, ActiveItem, fontID, alignment, scrollSize, scrollKind, scrollbutton bitmap
    
    newList.columns         := StrToInt(Trim(ExtractDelimited(7, data, [','])));
    newList.rows            := StrToInt(Trim(ExtractDelimited(8, data, [','])));
    newList.activeItem      := StrToInt(Trim(ExtractDelimited(9, data, [','])));
    newList.font            := FontNamed(Trim(ExtractDelimited(10, data, [','])));
    newList.alignment       := TextAlignmentFrom(Trim(ExtractDelimited(11, data, [','])));
    newList.scrollSize      := StrToInt(Trim(ExtractDelimited(12, data, [','])));;
    newList.verticalScroll  := LowerCase(Trim(ExtractDelimited(13, data, [',']))) = 'v';
    
    if Trim(ExtractDelimited(14, data, [','])) <> 'n' then
    begin
      //LoadBitmap(Trim(ExtractDelimited(13, data, [','])));
      newList.scrollButton    := LoadBitmap(Trim(ExtractDelimited(14, data, [',']))); //BitmapNamed(Trim(ExtractDelimited(13, data, [','])));
    end;
    
    scrollSz := newList.scrollSize;
    
    // Start at the fist item in the list, or the activeItem
    if newList.activeItem = -1 then
      newList.startingAt    := 0
    else
      newList.startingAt    := newList.activeItem;
    
    rhs     := r^.area.width - scrollSz;
    btm     := r^.area.height - scrollSz;
    height  := r^.area.height;
    width   := r^.area.width;
    
    // Calculate col and row sizes
    if newList.verticalScroll then
    begin
      newList.colWidth    := rhs    div newList.columns;
      newList.rowHeight   := height div newList.rows;
      
      // Set scroll buttons
      newList.scrollUp    := RectangleFrom( rhs, 0, scrollSz, scrollSz);
      newList.scrollDown  := RectangleFrom( rhs, btm, scrollSz, scrollSz);
      
      newList.scrollArea  := RectangleFrom( rhs, scrollSz, scrollSz, height - (2 * scrollSz));
    end
    else
    begin
      newList.colWidth    := r^.area.width div newList.columns;
      newList.rowHeight   := btm div newList.rows;
      
      // Set scroll buttons
      newList.scrollUp    := RectangleFrom( 0, btm, scrollSz, scrollSz);
      newList.scrollDown  := RectangleFrom( rhs, btm, scrollSz, scrollSz);
      
      newList.scrollArea  := RectangleFrom( scrollSz, btm, width - (2 * scrollSz), scrollSz);
    end;
    
    
    SetLength(newList.placeHolder, (newList.columns * newList.rows));
    
    SetLength(newList.items, 0);
    
    SetLength(result^.lists, Length(result^.lists) + 1);
    result^.lists[High(result^.lists)] := newList;
    r^.elementIndex := High(result^.lists);
  end;
  
  procedure CreateListItem(r: region; data: string);
  var
    newListItem: GUIListItem;
    reg: Region;
    pList: GUIList;
    bitmap: String;
  begin
    newListItem.parent := ListFromRegion(RegionWithID(Trim(ExtractDelimited(8, data, [',']))));
  
    newListItem.text := Trim(ExtractDelimited(8, data, [',']));
    
    //Load the bitmap or nil if bitmap text is 'n'
    bitmap := Trim(ExtractDelimited(9, data, [',']));
    if bitmap <> 'n' then
      newListItem.image := BitmapNamed(bitmap)
    else
      newListItem.image := nil;
    
    reg := RegionWithID(result, Trim(ExtractDelimited(8, data, [','])));
    pList := ListFromRegion(reg);
    
    SetLength(pList^.items, Length(pList^.items) + 1);
    pList^.items[High(pList^.items)] := newListItem;
  end;
  
  procedure AddRegionToPanelWithString(d: string; p: panel);
  var
    regID: string;
    regX, regY: Single;
    regW, regH, addedIdx: integer;
    r: RegionData;
  begin
    // Format is 
    // x, y, w, h, kind, id
    regX := StrToFloat(Trim(ExtractDelimited(1, d, [','])));
    regY := StrToFloat(Trim(ExtractDelimited(2, d, [','])));
    regW := StrToInt(Trim(ExtractDelimited(3, d, [','])));
    regH := StrToInt(Trim(ExtractDelimited(4, d, [','])));
    
    r.kind := StringToKind(Trim(ExtractDelimited(5, d, [','])));
    
    regID := Trim(ExtractDelimited(6, d, [',']));
    
    // this should be done when used... so that moving the panel effects this
    //
    // regX += p^.area.x;
    // regY += p^.area.y;
    
    addedIdx := AddName(result^.regionIds, regID);   //Allocate the index
    if High(p^.Regions) < addedIdx then begin RaiseException('Error creating panel - added index is invalid.'); exit; end;
    
    r.RegionID      := High(p^.Regions);
    r.area          := RectangleFrom(regX, regY, regW, regH);
    r.active        := true;
    r.stringID      := regID;
    r.elementIndex  := -1;
    r.parent        := p;
    
    p^.Regions[addedIdx] := r;
    
    case r.kind of
      gkButton:     ;
      gkLabel:      CreateLabel(@p^.Regions[addedIdx],d);
      gkCheckbox:   CreateCheckbox(@p^.Regions[addedIdx],d);
      gkRadioGroup: CreateRadioButton(@p^.Regions[addedIdx],d);
      gkTextbox:    CreateTextbox(@p^.Regions[addedIdx],d);
      gkList:       CreateList(@p^.Regions[addedIdx], d);
    end;    
  end;
  
  procedure StoreRegionData(data: String);
  begin
    SetLength(regionDataArr, Length(regionDataArr) + 1);
    regionDataArr[High(regionDataArr)] := data;
  end;
  
  procedure ProcessLine();
  begin
    // Split line into id and data around :
    id := ExtractDelimited(1, line, [':']); // where id comes before...
    data := ExtractDelimited(2, line, [':']); // ...and data comes after.
  
    // Verify that id is a single char
    if Length(id) <> 1 then
    begin
      RaiseException('Error at line ' + IntToStr(lineNo) + ' in panel: ' + filename + '. Error with id: ' + id + '. This should be a single character.');
      exit; // Fail
    end;
    // Process based on id
    case LowerCase(id)[1] of // in all cases the data variable is read
      'x': result^.area.x       := MyStrToInt(data, false);
      'y': result^.area.y       := MyStrToInt(data, false);
      'w': result^.area.width   := MyStrToInt(data, false);
      'h': result^.area.height  := MyStrToInt(data, false);
      'i': begin
             LoadBitmap(Trim(data)); 
             result^.panelBitmap := BitmapNamed(Trim(data));
           end;
      'a': begin
             LoadBitmap(Trim(data));
             result^.panelBitmapActive := BitmapNamed(Trim(data));
           end;
      'r': StoreRegionData(data);
      'd': result^.draggable    := (LowerCase(Trim(data)) = 'true');
    else
      begin
        RaiseException('Error at line ' + IntToStr(lineNo) + ' in panel: ' + filename + '. Error with id: ' + id + '. This should be one of the characters defined in the template.');
        exit;
      end;
    end;
  end;
  
  procedure CreateRegions();
  var
    i: LongInt;
  begin
    SetLength(result^.regions, Length(regionDataArr));
    
    for i := Low(regionDataArr) to High(regionDataArr) do
    begin
      AddRegionToPanelWithString(regionDataArr[i], result);
    end;
  end;
  
  procedure InitPanel();
  begin
    New(result);
    
    result^.name      := '';
    result^.filename  := '';
    result^.panelID   := -1;
    result^.area      := RectangleFrom(0,0,0,0);
    result^.visible   := false;
    result^.active    := true;      // Panels are active by default - you need to deactivate them specially...
    result^.draggable := false;
    result^.panelBitmap := nil;
    result^.panelBitmapActive   := nil;
    
    SetLength(result^.regions, 0);
    SetLength(result^.labels, 0);
    SetLength(result^.checkBoxes, 0);
    SetLength(result^.radioGroups, 0);
    SetLength(result^.textBoxes, 0);
    SetLength(result^.lists, 0);
    
    InitNamedIndexCollection(result^.regionIds);   //Setup the name <-> id mappings
  end;
  
  procedure SetupListPlaceholders();
  var
    tempListPtr: GUIList;
    workingCol, workingRow: LongInt;
    j, k: LongInt;
    
  begin
    for j := Low(result^.Regions) to High(result^.Regions) do
    begin
      //Get the region as a list (will be nil if not list...)
      tempListPtr := ListFromRegion(@result^.regions[j]);
      
      if assigned(tempListPtr) then
      begin
        workingCol := 0;
        workingRow := 0;
        
        for k := Low(tempListPtr^.placeHolder) to High(tempListPtr^.placeHolder) do
        begin
          tempListPtr^.placeHolder[k].x := (workingCol * tempListPtr^.colWidth);
          tempListPtr^.placeHolder[k].y := (workingRow * tempListPtr^.rowHeight);
          
          tempListPtr^.placeHolder[k].width := (tempListPtr^.colWidth);
          tempListPtr^.placeHolder[k].height := (tempListPtr^.rowHeight);
                    
          workingCol += 1;
          
          if workingCol >= tempListPtr^.columns then
          begin
            workingCol := 0;
            workingRow += 1;
          end;
        end;            
      end;
    end;
  end;
  
begin
  pathToFile := filename;
  
  if not FileExists(pathToFile) then
  begin
    pathToFile := PathToResource(filename, PanelResource);
    if not FileExists(pathToFile) then
    begin
      RaiseException('Unable to locate panel ' + filename);
      exit;
    end;
  end;
  
  // Initialise the resulting panel
  InitPanel();
  
  Assign(panelFile, pathToFile);
  Reset(panelFile);
  
  try  
    SetLength(regionDataArr, 0);
  
    lineNo := -1;
  
    while not EOF(panelFile) do
    begin
      lineNo := lineNo + 1;
    
      ReadLn(panelFile, line);
      line := Trim(line);
      if Length(line) = 0 then continue;  //skip empty lines
      if MidStr(line,1,2) = '//' then continue; //skip lines starting with // - the first character at index 0 is the length of the string.
  
      ProcessLine();
    end;
  
    CreateRegions();
    SetupListPlaceholders();
  finally
    Close(panelFile);
  end;
end;

procedure GUISetForegroundColor(c:Color);
begin
  GUIC.foregroundClr := c;
end;

procedure GUISetBackgroundColor(c:Color);
begin
  GUIC.backgroundClr := c;
end;

procedure DrawGUIAsVectors(b : boolean);
begin
  GUIC.VectorDrawing := b;
end;

function PanelActive(pnl: Panel): Boolean;
begin
  if assigned(pnl) then result := pnl^.active
  else result := false;
end;

function IsSet(toCheck, checkFor: GuiElementKind): Boolean; overload;
begin
  result := (LongInt(toCheck) and LongInt(checkFor)) = LongInt(checkFor);
end;

function PointInRegion(pt: Point2D; p: Panel; kind: GuiElementKind): Boolean; overload;
var
  i: LongInt;
  curr: Region;
begin
  result := false;
  if not assigned(p) then exit;
  
  for i := Low(p^.Regions) to High(p^.Regions) do
  begin
    curr := @p^.Regions[i];
    if PointInRect(MousePointInPanel(p), curr^.area) and IsSet(kind, curr^.kind) then 
    begin     
      result := true;
      exit;
    end;
  end;
end;

function PointInRegion(pt: Point2D; p: Panel): Boolean; overload;
begin
  result := PointInRegion(pt, p, gkAnyKind);
end;

function PanelAtPoint(pt: Point2D): Panel;
var
  i: LongInt;
  curPanel: Panel;
begin
  result := nil;
  
  for i := High(GUIC.visiblePanels) downto Low(GUIC.visiblePanels) do
  begin
    curPanel := GUIC.visiblePanels[i];
    
    if PointInRect(pt, GUIC.visiblePanels[i]^.area) then
    begin
      result := curPanel;
      exit;
    end;
  end;
end;

procedure DragPanel();
begin
  if not IsDragging() then exit;
  
  if IsDragging() then
  begin
    MovePanel(GUIC.panelDragging, MouseMovement());
  end;
end;

function IsDragging(): Boolean;
begin
  result := assigned(GUIC.panelDragging) and GUIC.panelDragging^.draggable;
end;

procedure StartDragging();
var
  mp: Point2D;
  curPanel: Panel;
begin
  mp := MousePosition();
  curPanel := PanelAtPoint(mp);
  
  if not PointInRegion(mp, curPanel, GuiElementKind(LongInt(gkAnyKind) and not LongInt(gkLabel))) then
  begin
    GUIC.panelDragging := curPanel;
  end
  else
  begin
    GUIC.panelDragging := nil;
  end;
end;

procedure StopDragging();
begin
  GUIC.panelDragging  := nil;
  GUIC.downRegistered := false;
end;

procedure MovePanel(p: Panel; mvmt: Vector);
begin
  if not assigned(p) then exit;
  
  p^.area := RectangleOffset(p^.area, mvmt);
end;

// function DoLoadPanel(filename, name: String): Panel;
// begin
//   {$IFDEF TRACE}
//     TraceEnter('sgUserInterface', 'DoLoadPanel', name + ' = ' + filename);
//   {$ENDIF}
//   
//   if not FileExists(filename) then
//   begin
//     filename := PathToResource(filename, PanelResource);
//     if not FileExists(filename) then
//     begin
//       RaiseException('Unable to locate panel ' + filename);
//       exit;
//     end;
//   end;
//   
//   New(result);    
//   result^.effect := Mix_LoadWAV(PChar(filename));
//   result^.filename := filename;
//   result^.name := name;
//   
//   if result^.effect = nil then
//   begin
//     Dispose(result);
//     RaiseException('Error loading panel: ' + MIX_GetError());
//     exit;
//   end;
//   
//   {$IFDEF TRACE}
//     TraceExit('sgUserInterface', 'DoLoadPanel', HexStr(result));
//   {$ENDIF}
// end;

function LoadPanel(filename: String): Panel;
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'LoadPanel', filename);
  {$ENDIF}
  
  result := MapPanel(filename, filename);
  
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'LoadPanel');
  {$ENDIF}
end;


function MapPanel(name, filename: String): Panel;
var
  obj: tResourceContainer;
  pnl: Panel;
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'MapPanel', name + ' = ' + filename);
  {$ENDIF}
  
  if GUIC.panelIds.containsKey(name) then
  begin
    result := PanelNamed(name);
    exit;
  end;
  
  pnl := DoLoadPanel(filename, name);
  obj := tResourceContainer.Create(pnl);
  
  if not GUIC.panelIds.setValue(name, obj) then
  begin
    DoFreePanel(pnl);
    result := nil;
  end
  else
  begin
    AddPanelToGUI(pnl);
    result := pnl;
  end;
  
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'MapPanel');
  {$ENDIF}
end;

// private:
// Called to actually free the resource

procedure DoFreePanel(var pnl: Panel);
var i, j: LongInt;
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'DoFreePanel', 'pnl = ' + HexStr(pnl));
  {$ENDIF}
  
  if assigned(pnl) then
  begin
    
    if GUIC.panelDragging = pnl then GUIC.panelDragging := nil;
    
    HidePanel(pnl);
    
    for i := Low(GUIC.panels) to High(GUIC.panels) do
    begin
      if GUIC.panels[i] = pnl then
      begin
        guic.panels[i] := nil;
        for j := i to (High(GUIC.panels) - 1) do
        begin
          GUIC.panels[j] := GUIC.panels[j + 1]
        end;
        SetLength(GUIC.panels, Length(GUIC.panels) - 1);
      end;
    end;
    
    CallFreeNotifier(pnl);
    
    Dispose(pnl);
  end;
  
  pnl := nil;
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'DoFreePanel');
  {$ENDIF}
end;

procedure FreePanel(var pnl: Panel);
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'FreePanel', 'pnl = ' + HexStr(pnl));
  {$ENDIF}
  
  if(assigned(pnl)) then
  begin
    ReleasePanel(pnl^.name);
  end;
  pnl := nil;
  
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'FreePanel');
  {$ENDIF}
end;

procedure ReleasePanel(name: String);
var
  pnl: Panel;
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'ReleasePanel', 'pnl = ' + name);
  {$ENDIF}
  
  pnl := PanelNamed(name);
  if (assigned(pnl)) then
  begin
    GUIC.panelIds.remove(name).Free();
    DoFreePanel(pnl);
  end;
  
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'ReleasePanel');
  {$ENDIF}
end;

procedure ReleaseAllPanels();
begin
  {$IFDEF TRACE}
    TraceEnter('sgUserInterface', 'ReleaseAllPanels', '');
  {$ENDIF}
  
  ReleaseAll(GUIC.panelIds, @ReleasePanel);
  
  {$IFDEF TRACE}
    TraceExit('sgUserInterface', 'ReleaseAllPanels');
  {$ENDIF}
end;

function HasPanel(name: String): Boolean;
  begin
    {$IFDEF TRACE}
      TraceEnter('sgUserInterface', 'HasPanel', name);
    {$ENDIF}
    
    result := GUIC.panelIds.containsKey(name);
    
    {$IFDEF TRACE}
      TraceExit('sgUserInterface', 'HasPanel', BoolToStr(result, true));
    {$ENDIF}
  end;

  function PanelNamed(name: String): Panel;
  var
    tmp : TObject;
  begin
    {$IFDEF TRACE}
      TraceEnter('sgUserInterface', 'PanelNamed', name);
    {$ENDIF}
    
    tmp := GUIC.panelIds.values[name];
    if assigned(tmp) then result := Panel(tResourceContainer(tmp).Resource)
    else result := nil;
    
    {$IFDEF TRACE}
      TraceExit('sgUserInterface', 'PanelNamed', HexStr(result));
    {$ENDIF}
  end;
  
  function PanelName(pnl: Panel): String;
  begin
    {$IFDEF TRACE}
      TraceEnter('sgUserInterface', 'PanelName', HexStr(pnl));
    {$ENDIF}
    
    if assigned(pnl) then result := pnl^.name
    else result := '';
    
    {$IFDEF TRACE}
      TraceExit('sgUserInterface', 'PanelName', result);
    {$ENDIF}
  end;
  
  function PanelFilename(pnl: Panel): String;
  begin
    {$IFDEF TRACE}
      TraceEnter('sgUserInterface', 'PanelFilename', HexStr(pnl));
    {$ENDIF}
    
    if assigned(pnl) then result := pnl^.filename
    else result := '';
    
    {$IFDEF TRACE}
      TraceExit('sgUserInterface', 'PanelFilename', result);
    {$ENDIF}
  end;

procedure UpdateDrag();
begin
  // if mouse is down and this is the first time we see it go down
  if MouseDown(LeftButton) and not GUIC.downRegistered then
  begin
    GUIC.downRegistered := true;
    
    if ReadingText() then
      FinishReadingText();
    
    StartDragging();
  end
  // if mouse is now up... and it was down before...
  else if MouseUp(LeftButton) and GUIC.downRegistered then
  begin
    StopDragging();
  end;
  
  // If it is dragging then...
  if IsDragging() then
    DragPanel();
end;

// Dialog code
procedure InitialiseFileDialog();
begin
  with dialog do
  begin
    dialogPanel := PanelNamed('fdFileDialog');
    
    lastSelectedFile := -1;
    lastSelectedPath := -1;
    
    cancelled     := false;
  end;
end;

procedure ShowOpenDialog(select: FileDialogSelectType); overload;
begin
  InitialiseFileDialog();
  
  with dialog do
  begin
    LabelSetText(dialogPanel, 'OkLabel', 'Open');
    LabelSetText(dialogPanel, 'FileEntryLabel', 'Open');
    
    allowNew      := false;
    selectType    := select;
    ShowPanel(dialogPanel);
    
    if length(currentPath) = 0 then 
      DialogSetPath(GetUserDir());
  end;
end;

procedure ShowOpenDialog(); overload;
begin
  ShowOpenDialog(fdFilesAndDirectories);
end;

procedure ShowSaveDialog(select: FileDialogSelectType); overload;
begin
  InitialiseFileDialog();
  
  with dialog do
  begin
    LabelSetText(dialogPanel, 'OkLabel', 'Save');
    LabelSetText(dialogPanel, 'FileEntryLabel', 'Save');
    
    allowNew      := true;
    selectType    := select;
    ShowPanel(dialogPanel);
    
    if length(currentPath) = 0 then 
      DialogSetPath(GetUserDir());
  end;
end;

procedure ShowSaveDialog(); overload;
begin
  ShowSaveDialog(fdFilesAndDirectories);
end;

function DialogComplete(): Boolean;
begin
  result := (dialog.complete) and (Not(dialog.cancelled));
end;

function DialogCancelled(): Boolean;
begin
  result := dialog.cancelled;
end;

function DialogPath(): String;
begin
  if dialog.cancelled then result := ''
  else result := ExpandFileName(dialog.currentSelectedPath);
end;

procedure UpdateDialogPathText();
var
  selectedPath: String;
  pathTxt: Region;
begin
  selectedPath  := dialog.currentSelectedPath;
  
  pathTxt := RegionWithId(dialog.dialogPanel,'PathTextbox');
  
  // WriteLn('tw: ', TextWidth(TextboxFont(pathTxt), selectedPath));
  // WriteLn('rw: ', RegionWidth(pathTxt));
  if TextWidth(TextboxFont(pathTxt), selectedPath) > RegionWidth(pathTxt) then
    TextboxSetAlignment(pathTxt, AlignRight)
  else TextboxSetAlignment(pathTxt, AlignLeft);
  
  TextboxSetText(pathTxt, selectedPath);
end;

function IsSet(toCheck, checkFor: FileDialogSelectType): Boolean; overload;
begin
  result := (LongInt(toCheck) and LongInt(checkFor)) = LongInt(checkFor);
end;

procedure ShowErrorMessage(msg: String);
begin
  LabelSetText(dialog.dialogPanel, 'ErrorLabel', msg);
  PlaySoundEffect(SoundEffectNamed('fdDialogError'), 0.5);
end;

procedure DialogSetPath(fullname: String);
var
  tmpPath, path, filename: String;
  paths: Array [0..255] of PChar;
  
  procedure _PopulatePathList();
  var
    pathList: GUIList;
    i, len: Integer;
  begin
    pathList  := ListFromRegion(RegionWithId(dialog.dialogPanel, 'PathList'));
    
    // Clear the list of all of its items
    ListClearItems(pathList);
    
    // Add the drive letter at the start
    if Length(ExtractFileDrive(path)) = 0 then
      ListAddItem(pathList, PathDelim)
    else
      ListAddItem(pathList, ExtractFileDrive(path));
    
    // Set the details in the path list
    len := GetDirs(tmpPath, paths); //NOTE: need to use tmpPath as this strips separators from pass in string...
    
    // Loop through the directories adding them to the list
    for i := 0 to len - 1 do
    begin
      ListAddItem(pathList, paths[i]);
    end;
    
    // Ensure that the last path is visible in the list
    ListSetStartAt(pathList, ListLargestStartIndex(pathList));
  end;
  
  procedure _PopulateFileList();
  var
    filesList: GUIList;
    info : TSearchRec;
  begin
    filesList := ListFromRegion(RegionWithId(dialog.dialogPanel, 'FilesList'));
    
    // Clear the files in the filesList
    ListClearItems(filesList);
    
    //Loop through the directories
    if FindFirst (dialog.currentPath + '*', faAnyFile and faDirectory, info) = 0 then
    begin
      repeat
        with Info do
        begin
          if (attr and faDirectory) = faDirectory then 
          begin
            // its a directory... always add it
            ListAddItem(filesList, BitmapNamed('fdFolder'), name);
          end
          else
          begin
            // Its a file ... add if not dir only
            if IsSet(dialog.selectType, fdFiles) then
            begin
              ListAddItem(filesList, BitmapNamed('fdFile'), name);
            end;
          end;
        end;
      until FindNext(info) <> 0;
    end;
    FindClose(info);
  end;
  
  procedure _SelectFileInList();
  var
    filesList: GUIList;
    fileIdx: Integer;
  begin
    filesList := ListFromRegion(RegionWithId(dialog.dialogPanel, 'FilesList'));
    if Length(filename) > 0 then
    begin
      fileIdx := ListTextIndex(filesList, filename);
      ListSetActiveItemIndex(filesList, fileIdx);
      ListSetStartAt(filesList, fileIdx);
    end;
  end;
begin
  // expand the relative path to absolute
  if not ExtractFileAndPath(fullname, path, filename, dialog.allowNew) then 
  begin
    ShowErrorMessage('Unable to find file or path.');
    exit;
  end;
  
  // Get the path without the ending delimiter (if one exists...)
  tmpPath := ExcludeTrailingPathDelimiter(path);
  
  with dialog do
  begin
    currentPath         := IncludeTrailingPathDelimiter(tmpPath);
    currentSelectedPath := path + filename;
    lastSelectedPath    := -1;
    lastSelectedFile    := -1;
  end;
  
  UpdateDialogPathText();
  
  _PopulatePathList();
  _PopulateFileList();
  _SelectFileInList();
end;

procedure DialogCheckComplete();
var
  path: String;
begin
  path := DialogPath();
  
  if (not dialog.allowNew) and (not FileExists(path)) then
  begin
    ShowErrorMessage('Select an existing file or path.');
    exit;
  end;
  
  // The file exists, but is not a directory and files cannot be selected
  if (not IsSet(dialog.selectType, fdFiles)) and FileExists(path) and (not DirectoryExists(path)) then
  begin
    ShowErrorMessage('Please select a directory.');
    exit;
  end;
  
  if (not IsSet(dialog.selectType, fdDirectories)) and DirectoryExists(path) then
  begin
    ShowErrorMessage('Please select a file.');
    exit;
  end;
  Dialog.Complete := true;
  HidePanel(dialog.dialogPanel);
end;

procedure UpdateFileDialog();
var
  clicked: Region;
  
  procedure _PerformFileListClick();
  var
    selectedText, selectedPath: String;
    selectedIdx: Integer;
  begin
    // Get the idx of the item selected in the files list
    selectedIdx := ListActiveItemIndex(clicked);
    
    if (selectedIdx >= 0) and (selectedIdx < ListItemCount(clicked)) then
    begin
      selectedText := ListItemText(clicked, selectedIdx);
      selectedPath := dialog.currentPath + selectedText;
    end
    else exit;
    
    // if it is double click...
    if (dialog.lastSelectedFile = selectedIdx) then
    begin
      if DirectoryExists(selectedPath) then
        DialogSetPath(selectedPath)
      else
        DialogCheckComplete();
    end
    else
    begin
      // Update the selected file for double click
      dialog.lastSelectedFile     := selectedIdx;
      
      // Update the selected path and its label
      dialog.currentSelectedPath  := selectedPath;
      UpdateDialogPathText();
    end;
  end;
  
  procedure _PerformPathListClick();
  var
    tmpPath, newPath: String;
    selectedIdx, i, len: Integer;
    paths: Array [0..256] of PChar;
  begin
    // Get the idx of the item selected in the paths
    selectedIdx := ListActiveItemIndex(clicked);
    
    // if it is double click...
    if (dialog.lastSelectedPath = selectedIdx) and (selectedIdx >= 0) and (selectedIdx < ListItemCount(clicked)) then
    begin
      // Get the parts of the current path, and reconstruct up to (and including) selectedIdx
      tmpPath := dialog.currentPath;
      len := GetDirs(tmpPath, paths); //NOTE: need to use tmpPath as this strips separators from pass in string...
      
      newPath := ExtractFileDrive(dialog.currentPath) + PathDelim;
      for i := 0 to Min(selectedIdx - 1, len) do
      begin
        //Need to exclude trailing path delimiter as some paths will include this at the end...
        newPath := newPath + ExcludeTrailingPathDelimiter(paths[i]) + PathDelim;
      end;
      
      DialogSetPath(newPath);
    end
    else
      dialog.lastSelectedPath := selectedIdx;
  end;
  
  procedure _PerformCancelClick();
  begin
    HidePanel(dialog.dialogPanel);
    dialog.cancelled := true;
  end;
  
  procedure _PerformOkClick();
  begin
    DialogCheckComplete();
  end;
  
  procedure _PerformChangePath();
  var
    newPath: String;
  begin
    newPath := TextboxText(RegionWithID(dialog.dialogPanel, 'PathTextbox'));
    
    DialogSetPath(newPath);
  end;
begin
  if PanelClicked() = dialog.dialogPanel then
  begin
    clicked := RegionClicked();
    
    if clicked = RegionWithID(dialog.dialogPanel, 'FilesList') then
      _PerformFileListClick()
    else if clicked = RegionWithID(dialog.dialogPanel, 'PathList') then
      _PerformPathListClick()
    else if clicked = RegionWithID(dialog.dialogPanel, 'CancelButton') then
      _PerformCancelClick()
    else if clicked = RegionWithID(dialog.dialogPanel, 'OkButton') then
      _PerformOkClick();
  end;
  
  if GUITextEntryComplete() and (RegionOfLastUpdatedTextBox() = RegionWithID(dialog.dialogPanel, 'PathTextbox')) then
  begin
    _PerformChangePath();
  end;
end;

procedure UpdateInterface();
var
  pnl: Panel;
begin
  dialog.Complete := false;
  GUIC.doneReading := false;
  GUIC.lastClicked := nil;
  
  UpdateDrag();
  
  pnl := PanelAtPoint(MousePosition());
  
  if PanelActive(pnl) then
  begin
    HandlePanelInput(pnl)
  end;
  
  if assigned(GUIC.activeTextbox) and not ReadingText() then
    FinishReadingText();
    
  if PanelVisible(dialog.dialogPanel) then UpdateFileDialog();
end;




//=============================================================================
  initialization
  begin
    {$IFDEF TRACE}
      TraceEnter('sgUserInterface', 'Initialise', '');
    {$ENDIF}
    
    InitialiseSwinGame();
    
    SetLength(GUIC.panels, 0);
    SetLength(GUIC.visiblePanels, 0);
    GUIC.globalGUIFont := nil;
    // Color set on loading window
    GUIC.VectorDrawing      := false;
    GUIC.lastClicked        := nil;
    GUIC.activeTextBox      := nil;
    GUIC.lastActiveTextBox  := nil;
    GUIC.doneReading        := false;
    GUIC.lastTextRead       := '';
    GUIC.downRegistered     := false;
    GUIC.panelDragging      := nil;
    
    GUIC.panelIds := TStringHash.Create(False, 1024);
    
    with dialog do
    begin
      dialogPanel           := nil;
      currentPath           := '';     // The path to the current directory being shown
      currentSelectedPath   := '';     // The path to the file selected by the user
      cancelled             := false;
      allowNew              := false;
      selectType            := fdFilesAndDirectories;
      onlyFiles             := false;
      lastSelectedFile      := -1;
      lastSelectedPath      := -1;
      complete              := false;
    end;
        
    {$IFDEF TRACE}
      TraceExit('sgUserInterface', 'Initialise');
    {$ENDIF}
  end;

end.
