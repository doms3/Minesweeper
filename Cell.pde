public class Cell {
  // Boolean flags representing the state of the Cell
  private boolean isRevealed = false;
  private boolean isMine = false;
  private boolean isFlagged = false;

  // Position of the centre of the Cell
  private PVector position;

  private int numAdjMines = 0;

  private float tallness;
  private float wideness;

  // Set of neighbors ( A set was chosen because the same neighbor cannot be chosen twice )
  private Set<Cell> neighbors = new HashSet(8);

  public Cell( int row, int col, float tallness, float wideness ) {
    this.tallness = tallness;
    this.wideness = wideness;

    position = new PVector( (col + 0.5) * wideness, (row + 0.5) * tallness );
  }
  
  public void show() {
    if ( isRevealed )
      showMine();
    showCell();
  }
  
  // Shows mine if present or number of adjacent mines otherwise
  private void showMine( color col ) {
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

  private void showMine() {
    showMine( mineColor );
  }

  // Utilizes showMine() function and draws box on top in appropriate color
  private void showCell() {
    if ( isRevealed ) 
      noFill();
    else if ( isFlagged )
      fill( flaggedColor );
    else
      fill( cellColor );
    rect( position.x, position.y, wideness, tallness );
  }

  public void onLeftClick() {
    if ( !isFlagged ) {
      reveal();
      if ( noAdjMines() && !isMine ) {
        cascade( new HashSet<Cell>() );
      }
    }
  }

  public void onRightClick() {
    isFlagged = !isFlagged;
  }

  public void onFirstClick() {
    isMine = false;
  }

  // Returns true if the mouse position is above this Cell **DEPRECATED**
  public boolean mouseIsOver() {
    float top = position.y - tallness / 2;
    float bottom = position.y + tallness / 2;
    float left = position.x - wideness / 2;
    float right = position.x + wideness / 2;
    return mouseX > left && mouseX < right && mouseY > top && mouseY < bottom;
  }

  private void cascade( HashSet<Cell> cascaded ) {
    cascaded.add( this ); 
    for ( Cell neighbor : neighbors ) {
      neighbor.reveal();
      if ( neighbor.noAdjMines() && !cascaded.contains( neighbor ) ) {
        neighbor.cascade( cascaded );
      }
    }
  }

  public boolean isMine() {
    return isMine;
  }

  public void setMine( boolean mineState ) {
    isMine = mineState;
  }

  public void addNeighbor( Cell neighbor ) {
    if ( neighbors.add( neighbor ) && neighbor.isMine() ) {
      numAdjMines++;
    }
  }
  
  public void reveal() {
    isRevealed = true;
  }
  
  public boolean noAdjMines() {
    return numAdjMines == 0;
  }
}