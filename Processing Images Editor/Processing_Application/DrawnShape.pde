//
// DrawnShape
// This class stores a draw shapes active on the canvas, and is responsible for
// 1/ Interpreting the mouse moves to successfully draw a shape
// 2/ Redrawing the shape every frame, once it is drawn
// 3/ Detecting selection events, and selecting the shape if necessary
// 4/ modifying the shape once it is drawn through further actions

class DrawnShape {
  // type of shape
  // line
  // ellipse
  // Rect 
  // Image
  // arc
  String shapeType;

  float w;
  float h;
  float x1; 
  float y1;
  float x2;
  float y2;
  // used to define the shape bounds during drawing and after
  PVector shapeStartPoint, shapeEndPoint;

  boolean isSelected = false;
  PImage shapeImage;

  final float selectionstroke = 0; 
  final color selectionbox = color(125, 125, 100);
  color myFill_undecided = color(0, 0, 0);
  color myFill = color(0, 0, 0);
  float stroke_undecided = 0;
  float stroke_decided = 0;
  color line_color_undecided = color(0, 0, 0);
  color line_color_decided = color(0, 0, 0);



  PImage undoImage;

  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }

  void setImage(PImage img) {
    shapeImage = img.copy();
    undoImage = img.copy();
    shapeImage.resize(400, 0);

    undoImage.resize(400, 0);
  }

  public void startMouseDrawing(PVector startPoint) {
    this.shapeStartPoint = startPoint;
    this.shapeEndPoint = startPoint;
  }



  public void duringMouseDrawing(PVector dragPoint) {
    this.shapeEndPoint = dragPoint;
  }


  public void endMouseDrawing(PVector endPoint) {
    this.shapeEndPoint = endPoint;
  }


  public boolean tryToggleSelect(PVector p) {

    UIRect boundingBox = new UIRect(shapeStartPoint, shapeEndPoint);

    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
  }



  public void drawMe() {

    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    w = x2-x1;
    h = y2-y1;

    if (this.isSelected) {
      drawSelectionBox(x1, y1, x2, y2);
      setSelectedDrawingStyle(myFill_undecided, stroke_undecided, line_color_undecided);
    } else {
      //setSelectedDrawingStyle(myFill_undecided, stroke_undecided, line_color_undecided);
      setDefaultDrawingStyle(myFill, stroke_decided, line_color_decided);
    }


    if ( shapeType.equals("rectangle"))
    { 
      rect(x1, y1, w, h);
    }
    if ( shapeType.equals("ellipse"))
    { 

      ellipse(x1+ w/2, y1 + h/2, w, h);
    }

    if ( shapeType.equals("line"))
    {
      line(x1, y1, x2, y2);
    }
    if ( shapeType.equals("image")) {
      if (shapeImage == null) return;
      rect(x1, y1, w, h);
      image(shapeImage, x1, y1, w, h);
    }

    if (shapeType.equals("arc")) {

      arc(x1 + w/2, y1 + h/2, w, h, -PI, 0);
    }
  }

  void drawSelectionBox(float x1_, float y1_, float x2_, float y2_) {

    float shapewidth = x2_-x1_;
    float shapeheight = y2_-y1_ ;


    noFill();
    strokeWeight( 5);
    stroke(selectionbox);


    if ((x2_ < x1_) && (y2_ > y1_)) { 
      rect(x1_* 1.05, y1_ *0.95, shapewidth*1.2, shapeheight*1.2);
    }


    if ((x2_ < x1_) && (y2_ < y1_)) { 
      rect(x1_* 1.05, y1_ *1.05, shapewidth*1.2, shapeheight*1.2);
    }


    if ((x2_ > x1_) && (y2_ < y1_)) { 
      rect(x1_* 0.95, y1_ *1.05, shapewidth*1.2, shapeheight*1.2);
    }

    if ((x2_ > x1_) && (y2_ > y1_)) { 
      rect(x1_* 0.95, y1_ *0.95, shapewidth*1.2, shapeheight*1.2);
    }
  }
  void setSelectedDrawingStyle(color colorDefault, float stroke, color line_color) {
    strokeWeight(stroke);
    stroke(line_color);
    fill(colorDefault);
  }

  void setDefaultDrawingStyle(color colorDefault, float stroke, color line_color) {
    strokeWeight(stroke);
    stroke(line_color);
    fill(colorDefault);
  }
}     // end DrawnShape
