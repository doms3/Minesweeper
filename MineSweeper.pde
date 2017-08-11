import java.util.*;

// Parameters
final int rows = 20;
final int cols = 20;

final int totalMines = 100;

// Other Declarations
int colSize;
int rowSize;
int suspectedMines = 0;
Grid grid;

void setup() {
  size( 600, 640 );
  rectMode( CENTER );
  textSize( 32 * height / 600 );
  
  colSize = width / cols;
  rowSize = height * 600 / ( 640 * rows );

  grid = new Grid();
}

void draw() {
  background( 220 );
  grid.show();
  
  fill(0);
  textAlign( LEFT );
  text( totalMines - suspectedMines, 0, 632 * height / 640 );
  textAlign( CENTER );
  text( Time.returnTime( millis() ), width / 2, 632 * height / 640 );
  
  if( grid.hasWon() ) {
    textAlign( RIGHT );
    text( "You won!", width, 632 * height / 640 );
    noLoop();
  }
  
  if( grid.hasLost() ) {
    textAlign( RIGHT );
    text( "You lost!", width, 632 * height / 640 );
    noLoop();
  }
}

void mouseClicked() {
  if ( mouseButton == LEFT ) {
    Cell selectedCell = grid.currentCellHovered();
    if ( selectedCell != null && !selectedCell.isFlagged ) {
      selectedCell.isRevealed = true;
      if ( selectedCell.numAdjMines == 0 && !selectedCell.isMine ) {
        selectedCell.cascade( new HashSet<Cell>() );
      }
    }
  }
  if ( mouseButton == RIGHT ) {
    Cell selectedCell = grid.currentCellHovered();
    if ( selectedCell != null && suspectedMines < totalMines ) {
      if( selectedCell.isFlagged ) 
        suspectedMines--;
      else
        suspectedMines++;
      selectedCell.isFlagged = !selectedCell.isFlagged;
    }
  }
}