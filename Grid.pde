class Grid {
  // Contains all the cells in the Grid
  Cell[] cells = new Cell[ rows * cols ];

  // Grid is populated, mines are set and children are found all in the constructor
  Grid() {
    this.createCells();
    this.spawnMines();
    this.getAllChilds();
  }

  // All the cells are created here
  private void createCells() {
    for( int i = 0; i < rows; i++ ) {
      for( int j = 0; j < cols; j++ ) {
        int index = i * cols + j;
        cells[index] = new Cell( i, j );
      }
    }
  }

  // Mines are spawned here, special consideration 
  // is given to ensure at least one square has no mine
  private void spawnMines() {
    int minesOnField = 0;
    while ( minesOnField < totalMines && minesOnField < cells.length ) {
      int index = floor( random( 0, cells.length ) );
      if ( !cells[index].isMine ) {
        cells[index].isMine = true;
        minesOnField++;
      }
    }
  }

  // The specified cell's neighbors are set here
  // In addition the number of adjacent mines is set here as well
  private void getChilds( Cell cell ) {
    for ( int i = -1; i <= 1; i++ ) {
      for ( int j = -1; j <= 1; j++ ) {
        int targetRow = cell.row + i;
        int targetCol = cell.col + j;
        if( targetRow >= 0 && targetRow < rows 
         && targetCol >= 0 && targetCol < cols ) {
          int index = targetRow * cols + targetCol;
          cell.neighbors.add( cells[index] );
          if( cells[index].isMine )
            cell.numAdjMines++;
        }
      }
    }
  }
  
  private void getAllChilds() {
    for( int i = 0; i < cells.length; i++ ) {
      getChilds( cells[i] );
    }
  }
  
  //// *Deprecated*
  //private void setAllAdjMines() {
  //  for( int i = 0; i < cells.length; i++ ) {
  //    cells[i].getAdjMines();
  //  }
  //}
  
  // Returns the Cell currently hovered by the mouse
  // This function may return null and this should be checked
  Cell currentCellHovered() {
   for( int i = 0; i < cells.length; i++ ) {
     if( cells[i].mouseIsOver() ) {
       return cells[i];
     }
   }
   return null;
  }
  
  // Shows all the cells on the screen
  void show() {
    for( int i = 0; i < cells.length; i++ ) {
      cells[i].show();
    }
  }
  
  // Checks the win condition
  boolean hasWon() {
    for( int i = 0; i < cells.length; i++ ) {
      if( !cells[i].isMine && !cells[i].isRevealed ) {
        return false;
      }
    }
    return true;
  }
  
  // Checks the loss condition
  boolean hasLost() {
    for( int i = 0; i < cells.length; i++ ) {
      if( cells[i].isMine && cells[i].isRevealed ) {
        return true;
      }
    }
    return false;
  }
}