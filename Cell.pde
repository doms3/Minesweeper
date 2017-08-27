class Cell {
  // Boolean flags representing the state of the Cell
  boolean isRevealed = false;
  boolean isMine = false;
  boolean isFlagged = false;

  // Position of the centre of the Cell
  PVector position;

  // Other useful PVectors for checking mouse position (could improve?)
  PVector topCorner;
  PVector bottomCorner;

  // Row and column info, used exactly once in Grid.getChilds() (could improve?)
  int col;
  int row;

  int numAdjMines = 0;

  // Set of neighbors ( A set was chosen because the same neighbor cannot be chosen twice )
  Set<Cell> neighbors = new HashSet(8);

  Cell( int row, int col ) {
    this.col = col;
    this.row = row;
    position = new PVector( (col + 0.5) * colSize, (row + 0.5) * rowSize );
    topCorner = new PVector( col * colSize, row * rowSize );
    bottomCorner = new PVector( (col + 1) * colSize, (row + 1) * rowSize );
  }

  // Shows mine if present or number of adjacent mines otherwise
  void showMine( color col ) {
    if ( isMine ) {
      fill( col );
      ellipse( position.x, position.y, colSize/2, rowSize/2 );
    } else if ( numAdjMines > 0 ) {
      fill(10);
      textSize(20);
      textAlign( CENTER, CENTER );
      text( numAdjMines, position.x, position.y );
    }
  }
  
  void showMine() {
    showMine( 45 );
  }

  // Utilizes showMine() function and draws box on top in appropriate color
  void showCell() {
    if( isRevealed ) 
      noFill();
    else if ( isFlagged )
      fill( 200, 0, 0 );
    else
      fill( 145 );
    rect( position.x, position.y, colSize, rowSize );
  }

  // Returns true if the mouse position is above this Cell
  boolean mouseIsOver() {
    return mouseX > topCorner.x && mouseX < bottomCorner.x 
        && mouseY > topCorner.y && mouseY < bottomCorner.y;
  }

  void cascade( HashSet<Cell> cascaded ) {
    cascaded.add( this ); 
    for ( Cell neighbor : neighbors ) {
      neighbor.isRevealed = true;
      if ( neighbor.numAdjMines == 0 && !cascaded.contains( neighbor ) ) {
        neighbor.cascade( cascaded );
      }
    }
  }

  //// *Deprecated*
  //private int numAdjMines() {
  //  int count = 0;
  //  for( Cell neighbor : neighbors ) {
  //    if( neighbor.isMine )
  //      count++;
  //  }
  //  return count;
  //}

  //void getAdjMines() {
  //  this.numAdjMines = numAdjMines();
  //}
}