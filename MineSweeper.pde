import java.util.Set;
import java.util.HashSet;

// Parameters
final int rows = 20;
final int cols = 20;

final int totalMines = 80;

// Other Declarations
int colSize;
int rowSize;
int suspectedMines = 0;
Grid grid;
boolean firstClick = true;

void setup() {
  size( 600, 640 );
  rectMode( CENTER );

  colSize = width / cols;
  rowSize = height * 600 / ( 640 * rows );

  grid = new Grid();
}

void draw() {
  println( frameRate );
  background( 220 );


  grid.show();

  fill(0);
  textSize( 32 * height / 600 );
  textAlign( LEFT );
  text( totalMines - suspectedMines, 0, 632 * height / 640 );
  textAlign( CENTER );
  text( Time.returnTime( this ), width / 2, 632 * height / 640 );
}

void mouseClicked() {
  Cell selectedCell = grid.currentCellHovered();
  if ( selectedCell != null ) {
    if ( mouseButton == LEFT ) {
      if ( firstClick ) {
        if ( selectedCell.isMine ) {
          selectedCell.isMine = false;
          grid.addOneMine( selectedCell );
        }
        firstClick = false;
        grid.getAllChilds();
      }
      if ( !selectedCell.isFlagged ) {
        selectedCell.isRevealed = true;
        if ( selectedCell.numAdjMines == 0 && !selectedCell.isMine ) {
          selectedCell.cascade( new HashSet<Cell>() );
        }
      }
      draw();
      if ( grid.hasWon() ) {
        textAlign( RIGHT );
        text( "You won!", width, 632 * height / 640 );
        noLoop();
      }

      if ( grid.hasLost() ) {
        textAlign( RIGHT );
        text( "You lost!", width, 632 * height / 640 );
        noLoop();
      }
    }
    if ( mouseButton == RIGHT ) {
      if ( suspectedMines < totalMines ) {
        if ( selectedCell.isFlagged ) 
          suspectedMines--;
        else
          suspectedMines++;
        selectedCell.isFlagged = !selectedCell.isFlagged;
      }
    }
  }
}