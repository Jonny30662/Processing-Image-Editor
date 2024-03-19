

//////////////////Fill////////////////////////////////////
void get_red()
{
  red_ = myUI.getSliderValue("Red")*255;
  shapeupdate = true;
}
void get_green()
{
  green_ = myUI.getSliderValue("Green")*255;
  shapeupdate = true;
}
void get_blue()
{
  blue_ = myUI.getSliderValue("Blue")*255;
  shapeupdate = true;
}

//////////////// Lines ///////////////////////////////
void get_linered()
{
  linered_ = myUI.getSliderValue("Line-Red")*255;
  shapeupdate = true;
}
void get_linegreen()
{
  linegreen_ = myUI.getSliderValue("Line-Green")*255;
  shapeupdate = true;
}
void get_lineblue()
{
  lineblue_ = myUI.getSliderValue("Line-Blue")*255;
  shapeupdate = true;
}
//////////////line width//////////////////////////////
void get_stroke()
{
  stroke_ =  myUI.getSliderValue("Stroke")*10;
  shapeupdate = true;
}







void UpdateShape()
{
  if (shapeupdate == true) {     



    drawingList.setColourOfSelectedShapes(red_, green_, blue_, stroke_, linered_, linegreen_, lineblue_);
  }
  shapeupdate = false;
}
void appendShape()
{
  drawingList.ChangeShapeDetails(red_, green_, blue_, stroke_, linered_, linegreen_, lineblue_);
  append_shape = false;
}
