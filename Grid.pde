class Grid {
  // Contains all the cells in the Grid
  private Cell[] cells = new Cell[ rows * cols ];
  
  private int suspectedMines = 0;
  
  private float colSize;
  private float rowSize;

  // Grid is populated, mines are set and children are found all in the constructor
  public Grid() {
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
        if ( targetRow >= 0 && targetRow < rows && targetCol >= 0 && targetCol < cols ) {
          int index = targetRow * cols + targetCol;
          cell.addNeighbor( cells[index] );
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
  
  private Cell currentCellHovered() {
    int row = floor( mouseY / rowSize );
    int col = floor( mouseX / colSize );
    
    if( row >= 0 && row < rows && col >= 0 && col < cols ) {
      int index = row * cols + col;
      return cells[ index ];
    }
    
    return null;
  }

  // Shows all the cells on the screen
  public void show() {
    for ( int i = 0; i < cells.length; i++ ) {
      cells[i].show();
    }
  }

  // Checks the win condition
  private boolean hasWon() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( !cells[i].isMine && !cells[i].isRevealed ) {
        return false;
      }
    }
    return true;
  }

  // Checks the loss condition
  private boolean hasLost() {
    for ( int i = 0; i < cells.length; i++ ) {
      if ( cells[i].isMine && cells[i].isRevealed ) {
        return true;
      }
    }
    return false;
  }

  private void addOneMine( Cell toBeIgnored ) {
    while ( true ) {
      int index = floor( random( 0, cells.length ) );
      if ( !cells[index].isMine() && cells[index] != toBeIgnored ) {
        cells[index].setMine( true );
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

  public void onRightClick() {
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

  public void onLeftClick() {
    Cell selectedCell = currentCellHovered();
    if( selectedCell != null ) {
      selectedCell.onLeftClick();
    }
  }

  public void onFirstClick() {
    Cell selectedCell = currentCellHovered();
    if ( selectedCell != null ) {
      if ( selectedCell.isMine() ) {
        selectedCell.onFirstClick();
        grid.addOneMine( selectedCell );
      }
    }
    getAllChilds();
  }
  
  public int getSuspectedMines() {
    return suspectedMines;
  }
}