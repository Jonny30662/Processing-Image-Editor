// Foolowing on from the example
// DrawSingleShape_CodeExample in week 1 of this unit.
// This example can draw multiple shapes

// Each shape is now contained in a DrawnShape object
// It uses a "DrawingList" to contain all the DrawnShape instances
// as the user creates them
float[][] edge_matrix = { { 0, -2, 0 }, 
  { -2, 8, -2 }, 
  { 0, -2, 0 } }; 

float[][] blur_matrix = {  {0.1, 0.1, 0.1 }, 
  {0.1, 0.1, 0.1 }, 
  {0.1, 0.1, 0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 }, 
  {-1, 5, -1 }, 
  { 0, -1, 0 } };  

final color displayshapes = color(255, 225, 200);
final color StrokeDisplay = color(0, 0, 0);
final int StrokeWeightDisplay = 1;
SimpleUI myUI;
DrawingList drawingList;

boolean imageLoaded = false;

float brightnesslevel;
float saturationlevel;
float huelevel;
float contrastlevel;

boolean updatecontrast = false;
boolean saveToImage = false;
boolean edge = false;
boolean sharpen = false;
boolean blur = false;
boolean undo = false;
boolean refreshImage;
boolean greyscale = false;
boolean negative = false;
boolean enablecontrast = false;
boolean filter = false;

String toolMode = "";

boolean append_shape = false;
boolean shapeupdate = false;
float red_ = 0, green_ = 0, blue_ = 0;
float stroke_;
float lineblue_ = 0, linered_ = 0, linegreen_ = 0;


int canvasWidth = 780;
int canvasHeight = 700;
int canvasstartXpos = 110;
int canvasstartYpos = 10; 
int canvasendXpos = canvasstartXpos +  canvasWidth;
int canvasendYpos = canvasstartYpos +  canvasHeight;
boolean saveSelectedImage = false;
boolean isShape = false;
boolean setup = true;
void setup() {
  size(1200, 1000);

  myUI = new SimpleUI();
  drawingList = new DrawingList();


  ButtonBaseClass  rectButton = myUI.addRadioButton("rectangle", 20, 300, "group1");
  myUI.addRadioButton("ellipse", 20, 330, "group1");
  myUI.addRadioButton("line", 20, 360, "group1");
  myUI.addRadioButton("arc", 20, 390, "group1");
  myUI.addRadioButton("image", 20, 420, "group1");
  rectButton.selected = true;
  toolMode = rectButton.UILabel;

  // add a new tool .. the select tool
  myUI.addRadioButton("select", 20, 200, "group1");
  myUI.addPlainButton("Delete", 20, 230);







  myUI.addPlainButton("LOAD Image", 200, 50);
  myUI.addPlainButton("SAVE Image", 270, 50);
  myUI.addPlainButton("COMMIT", 340, 50);
  myUI.addPlainButton("UNDO", 410, 50);


  myUI.addSlider("Red", 20, 550);
  myUI.addSlider("Green", 20, 580);
  myUI.addSlider("Blue", 20, 610);

  myUI.addSlider("Stroke", 20, 690);
  myUI.addSlider("Line-Red", 20, 720);
  myUI.addSlider("Line-Green", 20, 750);
  myUI.addSlider("Line-Blue", 20, 780);



  myUI.addPlainButton("Update", 20, 850);


  String[] items = { "GreyScale", "Negative", "Sharpen", "Blur", "Edge", "No filter"  };
  myUI.addMenu("Photo Filter", 480, 50, items );

  myUI.addSlider("Brightness", 580, 50);
  myUI.addSlider("Saturation", 680, 50);
  myUI.addSlider("Hue", 780, 50);
  myUI.addSlider("Contrast", 880, 50);

  myUI.addToggleButton("EnableCon", 880, 80);



  myUI.addCanvas(200, 200, canvasWidth, canvasHeight);
}

void draw() {
  background(250, 230, 220);

  //might remove this rect as not really needed
  rect(145, 650, 40, 40);




  strokeWeight(StrokeWeightDisplay);
  stroke(StrokeDisplay);
  fill(displayshapes);
  rect(175, 25, 830, 100);
  rect(10, 190, 120, 700);


  drawingList.drawMe();
  myUI.update();
  drawingList.Brightnesslevel();
  drawingList.Saturationlevel();
  drawingList.Huelevel();
  drawingList.Contrastlevel();
  get_red();
  get_green();
  get_blue();
  get_stroke();
  get_linered();
  get_linegreen();
  get_lineblue();
  UpdateShape();

  if (refreshImage && enablecontrast == false) { 
    drawingList.updateImage();
  }    
  if (greyscale == true)
  {
    drawingList.greyscale();
  }
  if (negative == true)
  {
    refreshImage = false;
    drawingList.negative();
  }
  if (sharpen == true)
  {
    drawingList.Sharpen();
  }
  if (blur == true)
  {
    drawingList.Blur();
  }
  if (edge == true)
  {
    drawingList.Edge();
  }
  if (saveToImage == true)
  {
    drawingList.save_changes_to_image();
  }
  if (enablecontrast == true) {
    if (updatecontrast == true) {
      drawingList.Contrast();
    }
  }



  if (undo == true)
  {
    drawingList.undo();
  }
  if (append_shape == true)
  {
    appendShape();
  }
}


void handleUIEvent(UIEventData uied) {




  if (uied.eventIsFromWidget("LOAD Image"))
  {
    myUI.openFileLoadDialog("load an image");
  }

  //this catches the file load information when the file load dialogue's "open" button is hit
  if (uied.eventIsFromWidget("fileLoadDialog"))
  {
    drawingList.setImageForImageShapes(  loadImage(uied.fileSelection) );
  }
  if (uied.eventIsFromWidget("Update"))
  {
    append_shape = true;
  }

  if ( uied.eventIsFromWidget("GreyScale"))
  {
    greyscale = true;
    negative = false;
    sharpen = false;
    blur = false;
    edge = false;
  }
  if ( uied.eventIsFromWidget("Negative"))
  {
    negative = true;
    greyscale = false;
    sharpen = false;
    blur = false;
    edge = false;
  }
  if ( uied.eventIsFromWidget("Sharpen"))
  {
    sharpen = true;
    blur = false;
    negative = false;
    greyscale = false;
    edge = false;
  }


  if ( uied.eventIsFromWidget("No filter"))
  {
    negative = false;
    greyscale = false;
    sharpen = false;
    blur = false;
    edge = false;
  }
  if ( uied.eventIsFromWidget("Blur"))
  {
    sharpen = true;
    blur = true;
    negative = false;
    greyscale = false;
    edge = false;
  }

  if ( uied.eventIsFromWidget("Edge"))
  {
    edge = true;
    negative = false;
    greyscale = false;
    sharpen = false;
    blur = false;
  }
  if (uied.eventIsFromWidget("EnableCon")) 
  {
    enablecontrast = uied.toggleSelectState;
  }


  if (uied.eventIsFromWidget("UNDO"))
  {
    undo = true;
  }


  if ( uied.eventIsFromWidget("COMMIT"))
  {

    saveToImage = true;
  }
  if ( uied.eventIsFromWidget("Delete"))
  {

    drawingList.deleteSelected();
  }

  if (uied.eventIsFromWidget("SAVE Image"))
  {
    myUI.openFileSaveDialog("save an image");
  }

  //this catches the file save information when the file save dialogue's "save" button is hit
  if (uied.eventIsFromWidget("fileSaveDialog"))  
  {


    drawingList.theImageForShapeImages.save(uied.fileSelection);
  }
  // if from a tool-mode button, the just set the current tool mode string 
  if (uied.uiComponentType == "RadioButton") {
    toolMode = uied.uiLabel;
    return;
  }

  // only canvas events below here! First get the mouse point
  if (uied.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(uied.mousex, uied.mousey);

  // this next line catches all the tool shape-drawing modes 
  // so that drawing events are sent to the display list class only if the current tool 
  // is a shape drawing tool
  if ( toolMode.equals("rectangle") || 
    toolMode.equals("ellipse") || 
    toolMode.equals("line")  ||
    toolMode.equals("image") ||
    toolMode.equals("arc")) {    
    drawingList.handleMouseDrawEvent(toolMode, uied.mouseEventType, p);
    return;
  }

  // if the current tool is "select" then do this
  if ( toolMode.equals("select") ) 
  {    
    drawingList.trySelect(uied.mouseEventType, p);
  }
  // this responds to the "load file" button and opens the file-load dialogue
}

void keyPressed() 
{
  if (key == BACKSPACE) {
    drawingList.deleteSelected();
  }
}
