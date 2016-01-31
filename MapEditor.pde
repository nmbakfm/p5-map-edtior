import controlP5.*;
import java.awt.*;

int col_num = 5;
int row_num = 5;
int cellSize = 0;

int[] field = new int[col_num*row_num];

int uvColNum = 4;
int uvRowNum = 4;

int uvColSize = 256;
int uvRowSize = 256;

TextField inputExportFileName = new TextField("export.txt");
TextField inputRowSize = new TextField(str(col_num));
TextField inputColSize = new TextField(str(row_num));
TextField inputDataName = new TextField("data.png");
TextField inputDataUVColNum = new TextField(str(uvColNum));
TextField inputDataUVRowNum = new TextField(str(uvRowNum));
TextField inputDataUVWidth = new TextField(str(uvColSize));
TextField inputDataUVHeight = new TextField(str(uvRowSize));
PImage uv;

// Layout
final int WIDTH = 1024;
final int HEIGHT = 768;
final int TOOL_BOX_WIDTH = 170;
final int TOOL_BOX_GAP = 5;
final int TOOL_BOX_TOP_MARGIN = 20;
ControlP5 cp5;

final int TOOL_LEFT_LINE = WIDTH - TOOL_BOX_WIDTH + TOOL_BOX_GAP;
final int TOOL_WIDTH = TOOL_BOX_WIDTH - TOOL_BOX_GAP * 2;
final int TOOL_HEIGHT = 25;

int editorWidth = WIDTH - TOOL_BOX_WIDTH - TOOL_BOX_GAP * 2;
int editorHeight = HEIGHT - TOOL_BOX_GAP * 2;


final int fontColor = 102;
final int lineColor = 200;

int uvIndex = 0;
int uvPositionRow = uvIndex/col_num;
int uvPositionCol = uvColNum * uvRowNum - uvPositionRow * col_num;

PVector selectedCell = new PVector(0,0);

void setup() {
  size(WIDTH, HEIGHT);
  uv = loadImage(inputDataName.getText());
  setLayout(null);
  
  cp5 = new ControlP5(this);
  
  inputExportFileName.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 0, TOOL_WIDTH, TOOL_HEIGHT);
  add(inputExportFileName);
  
  cp5.addButton("export")
    .setValue(0)
      .setPosition(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 1)
        .setSize(TOOL_WIDTH, TOOL_HEIGHT);
      
  inputColSize.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 2, TOOL_WIDTH, TOOL_HEIGHT);
  inputRowSize.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 3, TOOL_WIDTH, TOOL_HEIGHT);
  add(inputRowSize);
  add(inputColSize);


  

  cp5.addButton("apply_matrix_size")
    .setValue(0)
      .setPosition(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 4)
        .setSize(TOOL_WIDTH, TOOL_HEIGHT);

  inputDataName.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 6, TOOL_WIDTH, TOOL_HEIGHT);
  inputDataUVColNum.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 7, TOOL_WIDTH, TOOL_HEIGHT);
  inputDataUVRowNum.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 8, TOOL_WIDTH, TOOL_HEIGHT);
  inputDataUVWidth.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 9, TOOL_WIDTH, TOOL_HEIGHT);
  inputDataUVHeight.setBounds(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 10, TOOL_WIDTH, TOOL_HEIGHT);
  add(inputDataName);
  add(inputDataUVColNum);
  add(inputDataUVRowNum);
  add(inputDataUVWidth);
  add(inputDataUVHeight);

  cp5.addButton("apply_background")
    .setValue(0)
      .setPosition(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 11)
        .setSize(TOOL_WIDTH, TOOL_HEIGHT);

  cp5.addButton("prev")
    .setValue(0)
      .setPosition(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 13)
        .setSize((TOOL_WIDTH - TOOL_BOX_GAP) / 2, TOOL_HEIGHT);

  cp5.addButton("next")
    .setValue(0)
      .setPosition(WIDTH - (TOOL_WIDTH - TOOL_BOX_GAP) / 2 - TOOL_BOX_GAP, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 13)
        .setSize((TOOL_WIDTH - TOOL_BOX_GAP) / 2, TOOL_HEIGHT);
        
  cp5.addButton("set_cell")
    .setValue(0)
      .setPosition(TOOL_LEFT_LINE, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 14)
        .setSize(TOOL_WIDTH, TOOL_HEIGHT);
        
        
   for(int i = 0; i < col_num*row_num; ++i){
     field[i] = -1;
   }
}

void draw() {
  background(255);
  line(WIDTH - TOOL_BOX_WIDTH, 0, WIDTH - TOOL_BOX_WIDTH, HEIGHT);
  pushStyle();
  fill(fontColor);
  textSize(10);
  text("Matrix Size", width - TOOL_BOX_WIDTH + TOOL_BOX_GAP, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 2 - TOOL_BOX_GAP);
  popStyle();

  pushStyle();
  fill(fontColor);
  textSize(10);
  text("Background Data", width - TOOL_BOX_WIDTH + TOOL_BOX_GAP, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 6 - TOOL_BOX_GAP);
  popStyle();

  pushStyle();
  fill(fontColor);
  textSize(10);
  text("preview: image index( " + uvIndex + " )", width - TOOL_BOX_WIDTH + TOOL_BOX_GAP, TOOL_BOX_TOP_MARGIN + (TOOL_BOX_GAP + TOOL_HEIGHT) * 13 - TOOL_BOX_GAP);
  popStyle();
  
  if(uv != null){
    pushStyle();
    fill(255);
    textSize(10);
    image(crop(uv, uvIndex), width - TOOL_BOX_WIDTH + TOOL_BOX_GAP, TOOL_BOX_TOP_MARGIN + TOOL_BOX_GAP + (TOOL_BOX_GAP + TOOL_HEIGHT) * 15 - TOOL_BOX_GAP, TOOL_WIDTH, TOOL_WIDTH*uvRowSize/uvColSize);
    popStyle();
  }
  drawField();
}

void drawField() {
  pushStyle();
  fill(0);
  rect(0, 0, WIDTH-TOOL_BOX_WIDTH, HEIGHT);
  fill(255);
  rect(TOOL_BOX_GAP, TOOL_BOX_GAP, editorWidth, editorHeight);
  stroke(lineColor);
  for (int i=0; i<=col_num; ++i) {
    int x = i * cellSize + TOOL_BOX_GAP;
    line(x, TOOL_BOX_GAP, x, TOOL_BOX_GAP+editorHeight);
  }
  for (int i=0; i<=row_num; ++i) {
    int y = i * cellSize + TOOL_BOX_GAP;
    line(TOOL_BOX_GAP, y, TOOL_BOX_GAP+editorWidth, y);
  }
  if(uv!=null){
    for(int i=0; i<col_num; ++i){
      for(int j=0; j<row_num; ++j){
        if(field[i+j*col_num] != -1){
          image(crop(uv, field[i+j*col_num]), i*cellSize + TOOL_BOX_GAP, j*cellSize + TOOL_BOX_GAP, cellSize, cellSize);   
        }   
      }
    }
  }
  
  if(selectedCell != null){
    pushStyle();
    stroke(255,0,0);
    noFill();
    rect(selectedCell.x * cellSize + TOOL_BOX_GAP, selectedCell.y * cellSize + TOOL_BOX_GAP, cellSize, cellSize);
    popStyle();
  }
  popStyle();
}

void mouseReleased(){
  if(isInArea(mouseX, mouseY, TOOL_BOX_GAP, TOOL_BOX_GAP, editorWidth, editorHeight)){
    selectedCell = new PVector((mouseX-TOOL_BOX_GAP)/cellSize, (mouseY-TOOL_BOX_GAP)/cellSize);
  }
}

void keyReleased(){
  if(keyCode == ENTER || keyCode == RETURN){
    set_cell(0);
  }else if(keyCode == LEFT){
    selectedCell.x = (selectedCell.x - 1 < 0) ? col_num - 1 :  selectedCell.x - 1;
  }else if(keyCode == RIGHT){
    selectedCell.x = (selectedCell.x + 1 > col_num - 1) ? 0 :  selectedCell.x + 1;
  }else if(keyCode == UP){
    selectedCell.y = (selectedCell.y - 1 < 0) ? row_num - 1 :  selectedCell.y - 1;
  }else if(keyCode == DOWN){
    selectedCell.y = (selectedCell.y + 1 > row_num - 1) ? 0 :  selectedCell.y + 1;
  }
}

boolean isInArea(float x, float y, float targetX, float targetY, float targetW, float targetH){
  return x > targetX && y > targetY && x < targetX + targetW && y < targetY + targetH;
}

public void apply_matrix_size(int theValue) {
  int pColNum = col_num;
  int pRowNum = row_num;
  col_num = int(inputColSize.getText());
  row_num = int(inputRowSize.getText());
  println("MatrixSize: " + col_num + "x" + row_num);

  cellSize = min((WIDTH - TOOL_BOX_WIDTH - TOOL_BOX_GAP * 2) / col_num, (HEIGHT - TOOL_BOX_GAP * 2) / row_num);
  editorWidth = cellSize * col_num;
  editorHeight = cellSize * row_num;
  int[] tmp = new int[col_num*row_num];
    for(int i = 0; i < col_num*row_num; ++i){
    tmp[i] = -1;
  }
  for(int i=0; i<col_num; ++i){
    for(int j=0; j<row_num; ++j){
      if(i < pColNum && j < pRowNum){
        tmp[i + j*pColNum] = field[i + j*pColNum];
      }else{
        tmp[i + j*pColNum] = -1;
      }
    }
  }
  field = tmp;
}

public void apply_background(int theValue) {
  println("data: " + inputDataName.getText() + ", " + inputDataUVColNum.getText() + "x" + inputDataUVRowNum.getText() + " ");
  uv = loadImage(inputDataName.getText());
  uvColNum = int(inputDataUVColNum.getText());
  uvRowNum = int(inputDataUVRowNum.getText());
}

public void prev(int theValue) {
  uvIndex = (uvIndex == 0) ? uvColNum * uvRowNum - 1 : uvIndex - 1;
  uvPositionRow = int(uvIndex/uvColNum);
  uvPositionCol = uvIndex - uvPositionRow * uvColNum;
  println("image number: " + uvIndex + " position: " + uvPositionCol + ", " + uvPositionRow);
}

public void next(int theValue) {
  uvIndex = (uvIndex + 1 > uvColNum * uvRowNum - 1) ? 0 : uvIndex + 1;
  uvPositionRow = int(uvIndex/uvColNum);
  uvPositionCol = uvIndex - uvPositionRow * uvColNum;
  println("image number: " + uvIndex + " position: " + uvPositionCol + ", " + uvPositionRow);
}

public void set_cell(int theValue){
  field[int(selectedCell.x + selectedCell.y * col_num)] = uvIndex;
}

public void export(){
  PrintWriter output = createWriter("export/"+inputExportFileName.getText());
  println("export/"+inputExportFileName.getText());
  for(int i=0; i<row_num; ++i){
    for(int j=0; j<col_num; ++j){
      output.print(field[j+i*col_num]);
      output.print(",");
    }
    output.print("\n");
  }
  output.flush();
  output.close();
  println("exported");
}

PImage crop(PImage img, int index){
  int y = int(index/uvColNum);
  int x = index - y * uvColNum;
  return img.get(x * uvColSize, y * uvRowSize , uvColSize, uvRowSize);
}
