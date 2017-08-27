class Grid {
  // Contains all the cells in the Grid
  Cell[] cells = new Cell[ rows * cols ];
  int suspectedMines = 0;
  
  float colSize;
  float rowSize;

  // Grid is populated, mines are set and children are found all in the constructor
  Grid() {
    colSize = width / cols;
    rowSize = width / rows;
    
    this.createCells();
    this.spawnMines();  
  }

  // All the cells are created here
  private void createCells() {
    for ( int i = 0; i < rows; i++ ) {
      for ( int j = 0; j < cols; j++ ) {
        int index = i * cols + j;
        cells[index] = new Cell( i, j, rowSize, colSize );
      }
    }
  }

  // Mines are spawned here, special consideration 
  // is given to ensure at least one square has no mine
  private void spawnMines() {
    int minesOnField = 0;
    while ( minesOnField < totalMines && minesOnField < cells.length - 1) {
      int index = floor( random( 0, cells.length ) );
      if ( !cells[index].isMine ) {
        cells[index].isMine = true;
        minesOnField++;
      }
    }
  }

  // The specified cell's neighbors are set here
  // In addition the number of adjacent mines is set here as well
  private void getChilds( Cell cell, int row, int col ) {
    for ( int i = -1; i <= 1; i++ ) {
      for ( int j = -1; j <= 1; j++ ) {
        int targetRow = row + i;
        int targetCol = col + j;
        if ( targetRow >= 0 && targetRow < rows 
          && targetCol >= 0 && targetCol < cols ) {
          int index = targetRow * cols + targetCol;
          cell.neighbors.add( cells[index] );
          if ( cells[index].isMine )
            cell.numAdjMines++;
        }
      }
    }
  }

  private void getAllChilds() {
    for ( int i = 0; i < cells.length; i++ ) {
      int row = i / cols;
      int col = i % cols;
      getChilds( cells[i], row, col );
    }
  }

  //// *Deprecated*
  //private void setAllAdjMines() {
  //  for( int i = 0; i < cells.length; i++ ) {
  //    cells[i].getAdjMines();
  //  }
  //}

  // Returns the Cell currently hovered by the mouse
  // This function may return null thus this should be checked
  Cell currentCellHovered() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( cells[i].mouseIsOver() ) {
        return cells[i];
      }
    }
    return null;
  }

  // Shows all the cells on the screen
  void show() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( cells[i].isRevealed )
        cells[i].showMine();
      cells[i].showCell();
    }
  }

  // Checks the win condition
  boolean hasWon() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( !cells[i].isMine && !cells[i].isRevealed ) {
        return false;
      }
    }
    return true;
  }

  // Checks the loss condition
  boolean hasLost() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( cells[i].isMine && cells[i].isRevealed ) {
        return true;
      }
    }
    return false;
  }

  void addOneMine( Cell toBeIgnored ) {
    while ( true ) {
      int index = floor( random( 0, cells.length ) );
      if ( !cells[index].isMine && cells[index] != toBeIgnored ) {
        cells[index].isMine = true;
        return;
      }
    }
  }

  public void checkConditions() {
    if ( hasWon() ) {
      textAlign( RIGHT, CENTER );
      text( "You won!", width, width + extraHeight / 2 );
      noLoop();
    }

    if ( hasLost() ) {
      textAlign( RIGHT, CENTER );
      text( "You lost!", width, width + extraHeight / 2 );
      noLoop();
    }
  }

  void onRightClick() {
    Cell selectedCell = currentCellHovered();
    if ( selectedCell != null ) {
      if ( suspectedMines < totalMines ) {
        if ( selectedCell.isFlagged ) 
          suspectedMines--;
        else
          suspectedMines++;
        selectedCell.onRightClick();
      }
    }
  }

  void onLeftClick() {
    Cell selectedCell = currentCellHovered();
    if( selectedCell != null ) {
      selectedCell.onLeftClick();
    }
  }

  void onFirstClick() {
    Cell selectedCell = currentCellHovered();
    if ( selectedCell != null ) {
      if ( selectedCell.isMine ) {
        selectedCell.isMine = false;
        grid.addOneMine( selectedCell );
      }
    }
    getAllChilds();
  }
}