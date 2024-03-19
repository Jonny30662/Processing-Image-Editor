////////////////////////////////////////////////////////////////////
// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn
//
// 


class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();

  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;

  // this is used to set the image in image-shapes
  PImage theImageForShapeImages;

  public DrawingList() {
  }

  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }

  void setImageForImageShapes(PImage img) {
    theImageForShapeImages = img;
    theImageForShapeImages.resize(400, 0);
    imageLoaded = true;
  }

  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc) {

    if ( mouseEventType.equals("mousePressed")) {
      DrawnShape newShape = new DrawnShape(shapeType);
      newShape.startMouseDrawing(mouseLoc);

      if (shapeType.equals("image")) {
        if (imageLoaded == true) {
          newShape.setImage(theImageForShapeImages);
        }
      }

      shapeList.add(newShape);
      currentlyDrawnShape = newShape;
    }

    if ( mouseEventType.equals("mouseDragged")) {
      currentlyDrawnShape.duringMouseDrawing(mouseLoc);
    }

    if ( mouseEventType.equals("mouseReleased")) {
      currentlyDrawnShape.endMouseDrawing(mouseLoc);
    }
  }

  public void handleMouseMoveEvent(String shapeType, String mouseEventType, PVector mouseLoc) {


    for (DrawnShape s : shapeList) {
      if (s.isSelected) {
        if ( mouseEventType.equals("mousePressed")) {
          DrawnShape newShape = new DrawnShape(shapeType);
          newShape.startMouseDrawing(mouseLoc);

          if (shapeType.equals("image")) {
            if (imageLoaded == true) {
              newShape.setImage(theImageForShapeImages);
            }
          }

          shapeList.add(newShape);
          currentlyDrawnShape = newShape;
        }

        if ( mouseEventType.equals("mouseDragged")) {
          currentlyDrawnShape.duringMouseDrawing(mouseLoc);
        }

        if ( mouseEventType.equals("mouseReleased")) {
          currentlyDrawnShape.endMouseDrawing(mouseLoc);
        }
      }
    }
  }


  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if ( mouseEventType.equals("mousePressed")) {

      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
        if (selectionFound) break;
      }
    }
  }
  public void setColourOfSelectedShapes(float r, float g, float b, float stroke, float rl, float gl, float bl) {


    for (DrawnShape s : shapeList) {
      if (s.isSelected) {
        s.myFill_undecided = color(r, g, b);
        s.stroke_undecided = stroke;
        s.line_color_undecided = color(rl, gl, bl);
      }
    }
  }
  public void ChangeShapeDetails(float r, float g, float b, float stroke, float rl, float gl, float bl) {


    for (DrawnShape s : shapeList) {
      if (s.isSelected) {
        s.myFill = color(r, g, b);
        s.stroke_decided = stroke;
        s.line_color_decided = color(rl, gl, bl);
      }
    }
  }


  void deleteSelected() {
    ArrayList<DrawnShape> tempShapeList = new ArrayList<DrawnShape>();
    for (DrawnShape s : shapeList) {

      if (s.isSelected == false) tempShapeList.add(s);
    }
    shapeList = tempShapeList;
  }


  void greyscale() 

  {

    if (theImageForShapeImages != null && isShape ==  false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {

            for (int x = 0; x < s.shapeImage.width; x++) {
              for (int y = 0; y < s.shapeImage.height; y++) {
                color thisPix = theImageForShapeImages.get(x, y);
                float r = (int) red(thisPix);
                float g = (int) green(thisPix);
                float b = (int) blue(thisPix);



                // this code then changes those values to "grey" and then sets this as a standard colour. 

                int grey = (int)(( (r*0.3) + (b*0.11) + (g*0.59)));
                color greyscale = color (grey, grey, grey);
                // the image copy pixels are then changed to this colour (copy is used so that I can use the origional colours to change it back
                s.shapeImage.set(x, y, greyscale);
              }
            }
          }
        }
      }
    }
  }


  void negative()
  {

    if (theImageForShapeImages != null && isShape ==  false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {


            for (int x = 0; x < s.shapeImage.width; x++) {
              for (int y = 0; y < s.shapeImage.height; y++) {
                color thisPix = theImageForShapeImages.get(x, y);
                float r = 255 - red(thisPix);
                float g = 255 - green(thisPix);
                float b =  255 - blue(thisPix);

                color negative = color(r, g, b);
                s.shapeImage.set(x, y, negative);
              }
            }
          }
        }
      }
    }
  }





  color convolution(int Xcen, int Ycen, float[][] matrix, int matrixsize, PImage sourceImage)
  {
    float rtotal = 0.0;
    float gtotal = 0.0;
    float btotal = 0.0;
    int offset = matrixsize / 2;
    // this is where we sample every pixel around the centre pixel
    // according to the sample-matrix size
    for (int i = 0; i < matrixsize; i++) {
      for (int j= 0; j < matrixsize; j++) {

        //
        // work out which pixel are we testing
        int xloc = Xcen+i-offset;
        int yloc = Ycen+j-offset;

        // Make sure we haven't walked off our image
        if ( xloc < 0 || xloc >= sourceImage.width) continue;
        if ( yloc < 0 || yloc >= sourceImage.height) continue;


        // Calculate the convolution
        color col = sourceImage.get(xloc, yloc);
        rtotal += (red(col) * matrix[i][j]);
        gtotal += (green(col) * matrix[i][j]);
        btotal += (blue(col) * matrix[i][j]);
      }
    }
    // Make sure RGB is within range
    rtotal = constrain(rtotal, 0, 255);
    gtotal = constrain(gtotal, 0, 255);
    btotal = constrain(btotal, 0, 255);
    // Return the resulting color
    return color(rtotal, gtotal, btotal);
  }

  void Sharpen()
  {
    if (theImageForShapeImages != null && isShape ==  false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {

            int matrixSize = 3;
            for (int y = 0; y < s.shapeImage.height; y++) {
              for (int x = 0; x < s.shapeImage.width; x++) {

                color c = convolution(x, y, sharpen_matrix, matrixSize, theImageForShapeImages);

                s.shapeImage.set(x, y, c);
              }
            }
          }
        }
      }
    }
  }


  void Blur()
  {
    if (theImageForShapeImages != null && isShape ==  false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {

            int matrixSize = 3;
            for (int y = 0; y < s.shapeImage.height; y++) {
              for (int x = 0; x < s.shapeImage.width; x++) {

                color c = convolution(x, y, blur_matrix, matrixSize, theImageForShapeImages);

                s.shapeImage.set(x, y, c);
              }
            }
          }
        }
      }
    }
  }

  void Edge()
  {
    if (theImageForShapeImages != null && isShape == false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {

            int matrixSize = 3;
            for (int y = 0; y < s.shapeImage.height; y++) {
              for (int x = 0; x < s.shapeImage.width; x++) {

                color c = convolution(x, y, edge_matrix, matrixSize, theImageForShapeImages);

                s.shapeImage.set(x, y, c);
              }
            }
          }
        }
      }
    }
  }

  void Brightnesslevel()
  {
    brightnesslevel = myUI.getSliderValue("Brightness");
    refreshImage = true;
  }
  void Saturationlevel()
  {
    saturationlevel = myUI.getSliderValue("Saturation");
    refreshImage = true;
  }
  void Huelevel()
  {
    huelevel = myUI.getSliderValue("Hue")*360;
    refreshImage = true;
  }
  void Contrastlevel()
  {
    contrastlevel =  myUI.getSliderValue("Contrast")*255;
    updatecontrast = true;
  }


  void updateImage() {
    // code in this function uses the pixels functions to find the location of the pixels and then adjust the values of saturation and brightness. these values are constrained. Uses color mode HSB to adjust the saturation and brightness
    if ( refreshImage == true)
    {
      if (theImageForShapeImages != null && isShape ==  false) {
        for (DrawnShape s : shapeList) {
          if (s.isSelected) {
            if (s.shapeImage != null)
            {


              for (int y = 0; y < s.shapeImage.height; y++) {

                for (int x = 0; x < s.shapeImage.width; x++) {

                  color thisPix = theImageForShapeImages.get(x, y);
                  int r = (int) (red(thisPix));
                  int g = (int) (green(thisPix));
                  int b = (int) (blue(thisPix));

                  r = constrain(r, 0, 255);
                  g = constrain(g, 0, 255);
                  b = constrain(b, 0, 255);

                  float[] hsv = RGBtoHSV(r, g, b);
                  float hue = hsv[0];
                  float sat = hsv[1];
                  float val = hsv[2];

                  hue += huelevel;
                  sat += saturationlevel;
                  val += brightnesslevel;

                  hue = constrain(hue, 0, 360);
                  sat = constrain(sat, 0, 1);
                  val = constrain(val, 0, 1);





                  color newRGB =   HSVtoRGB(hue, sat, val);
                  s.shapeImage.set(x, y, newRGB);
                }
              }
            }
          }





          refreshImage = false;
        }
      }
    }
  }

  float[] RGBtoHSV(float r, float g, float b) {


    float minRGB = min( r, g, b );
    float maxRGB = max( r, g, b );


    float value = maxRGB/255.0; 
    float delta = maxRGB - minRGB;
    float hue = 0;
    float saturation;

    float[] returnVals = {0f, 0f, 0f};


    if ( maxRGB != 0 ) {
      // saturation is the difference between the smallest R,G or B value, and the biggest
      saturation = delta / maxRGB;
    } else { // it’s black, so we don’t know the hue
      return returnVals;
    }

    if (delta == 0) { 
      hue = 0;
    } else {
      // now work out the hue by finding out where it lies on the spectrum
      if ( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
      if ( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
      if ( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
    }
    // the above produce a hue in the range -6...6, 
    // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
    // Multiply the above by 60 to give degrees
    hue = hue * 60;
    if ( hue < 0 ) hue += 360;

    returnVals[0] = hue;
    returnVals[1] = saturation;
    returnVals[2] = value;

    return returnVals;
  }
  color HSVtoRGB(float hue, float sat, float val)
  {

    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);

    float r, g, b;


    switch (h) {
    case 0: 
      r = val; 
      g = t; 
      b = p; 
      break;
    case 1: 
      r = q; 
      g = val; 
      b = p; 
      break;
    case 2: 
      r = p; 
      g = val; 
      b = t; 
      break;
    case 3: 
      r = p; 
      g = q; 
      b = val; 
      break;
    case 4: 
      r = t; 
      g = p; 
      b = val; 
      break;
    case 5: 
      r = val; 
      g = p; 
      b = q; 
      break;
    default: 
      r = val; 
      g = t; 
      b = p;
    }

    return color(r*255, g*255, b*255);
  }

  void undo()
  {
    if (theImageForShapeImages != null && isShape ==  false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {


            for (int x = 0; x <  s.shapeImage.width; x++)
            {
              for (int y = 0; y <  s.shapeImage.height; y++)
              {
                color thisPix = s.undoImage.get(x, y);
                float r = (int) red(thisPix);
                float g = (int) green(thisPix);
                float b = (int) blue(thisPix);

                color normal = color(r, g, b);
                theImageForShapeImages.set(x, y, normal);
              }
            }
            undo = false;
            sharpen = false;
            blur = false;
            negative = false;
            greyscale = false;
            edge = false;


            Slider brightness = (Slider)myUI.getWidget("Brightness");
            brightness.setSliderValue(0);
            Slider saturation = (Slider)myUI.getWidget("Saturation");
            saturation.setSliderValue(0);
            Slider hue = (Slider)myUI.getWidget("Hue");
            hue.setSliderValue(0);
            Slider contrast = (Slider)myUI.getWidget("Contrast");
            contrast.setSliderValue(0);
          }
        }
      }
    }
  }
  void save_changes_to_image()
  {
    if (theImageForShapeImages != null && isShape == false) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          if (s.shapeImage != null)
          {




            for (int x = 0; x < s.shapeImage.width; x++)
            {
              for (int y = 0; y < s.shapeImage.height; y++)
              {
                color thisPix =  s.shapeImage.get(x, y);
                float r = (int) red(thisPix);
                float g = (int) green(thisPix);
                float b = (int) blue(thisPix);

                color saved_color = color(r, g, b);
                theImageForShapeImages.set(x, y, saved_color);
              }
            }
            saveToImage = false;
            sharpen = false;
            blur = false;
            negative = false;
            greyscale = false;
            edge = false;

            Slider brightness = (Slider)myUI.getWidget("Brightness");
            brightness.setSliderValue(0);
            Slider saturation = (Slider)myUI.getWidget("Saturation");
            saturation.setSliderValue(0);
            Slider hue = (Slider)myUI.getWidget("Hue");
            hue.setSliderValue(0);
            Slider contrast = (Slider)myUI.getWidget("Contrast");
            contrast.setSliderValue(0);
          }
        }
      }
    }
  }

  void Contrast()
  {


    if (updatecontrast == true)
    {
      if (theImageForShapeImages != null && isShape == false) {
        for (DrawnShape s : shapeList) {
          if (s.isSelected) {
            if (s.shapeImage != null)
            {
              float factor = (259 * (contrastlevel + 255)) / (255 * (259 - contrastlevel));

              colorMode(RGB, 255);   

              for (int x = 0; x < s.shapeImage.width; x++)
              {
                for (int y = 0; y < s.shapeImage.height; y++)
                {
                  color thisPix = theImageForShapeImages.get(x, y);
                  float r_new = (factor * (red(thisPix) - 128) + 128); 
                  float g_new = (factor * (green(thisPix) - 128) + 128); 
                  float b_new = (factor * (blue(thisPix) - 128) + 128); 

                  r_new = constrain(r_new, 0, 255);
                  g_new = constrain(g_new, 0, 255);
                  b_new = constrain(b_new, 0, 255);



                  color contrast_color  = color(r_new, g_new, b_new);
                  s.shapeImage.set(x, y, contrast_color );
                }
              }
              updatecontrast = false;
            }
          }
        }
      }
    }
  }
}
