class Cell {
  // Boolean flags representing the state of the Cell
  boolean isRevealed = false;
  boolean isMine = false;
  boolean isFlagged = false;

  // Position of the centre of the Cell
  PVector position;

  int numAdjMines = 0;
  
  float tallness;
  float wideness;

  // Set of neighbors ( A set was chosen because the same neighbor cannot be chosen twice )
  Set<Cell> neighbors = new HashSet(8);

  Cell( int row, int col, float tallness, float wideness ) {
    this.tallness = tallness;
    this.wideness = wideness;
    
    position = new PVector( (col + 0.5) * wideness, (row + 0.5) * tallness );
  }

  // Shows mine if present or number of adjacent mines otherwise
  void showMine( color col ) {
    if ( isMine ) {
      fill( col );
      ellipse( position.x, position.y, wideness/2, tallness/2 );
    } else if ( numAdjMines > 0 ) {
      fill(10);
      textSize( width / 30 );
      textAlign( CENTER, CENTER );
      text( numAdjMines, position.x, position.y );
    }
  }

  void showMine() {
    showMine( mineColor );
  }

  // Utilizes showMine() function and draws box on top in appropriate color
  void showCell() {
    if ( isRevealed ) 
      noFill();
    else if ( isFlagged )
      fill( flaggedColor );
    else
      fill( cellColor );
    rect( position.x, position.y, wideness, tallness );
  }

  // Returns true if the mouse position is above this Cell
  boolean mouseIsOver() {
    float top = position.y - tallness / 2;
    float bottom = position.y + tallness / 2;
    float left = position.x - wideness / 2;
    float right = position.x + wideness / 2;
    return mouseX > left && mouseX < right && mouseY > top && mouseY < bottom;
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

  void onLeftClick() {
    if ( !isFlagged ) {
      isRevealed = true;
      if ( numAdjMines == 0 && !isMine ) {
        cascade( new HashSet<Cell>() );
      }
    }
  }

  void onRightClick() {
    isFlagged = !isFlagged;
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