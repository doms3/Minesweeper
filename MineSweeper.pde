import java.util.Set;
import java.util.HashSet;

// Parameters
final int rows = 20;
final int cols = 20;

final int totalMines = 80;

final color backgroundColor = color( 220 );
final color mineColor = color( 45 );
final color cellColor = color( 145 );
final color flaggedColor = color( 200, 0, 0 );

// Other Declarations
Grid grid;

boolean firstClick = true;

float extraHeight;

void setup() {
  size( 601, 640 );
  extraHeight = height - width;
  if( extraHeight < width / 40  )
    throw new RuntimeException( "InvalidDimensionException: You must leave space for the timer! Please increase the height." );
  if( extraHeight > width / 10 )
    throw new RuntimeException( "InvalidDimensionException: The window is too tall! Please decrease the height." );
  rectMode( CENTER );

  grid = new Grid();
  grid.show();
}

void draw() {
  fill( backgroundColor );
  rect( width / 2, width + extraHeight / 2, width, extraHeight );

  fill(0);
  textSize( 32 * extraHeight / 40 );
  textAlign( LEFT, CENTER );
  text( totalMines - grid.suspectedMines, 0, width + extraHeight / 2 );
  textAlign( CENTER, CENTER );
  text( Time.returnTime( this ), width / 2, width + extraHeight / 2 );
}

void mouseClicked() {
  if ( mouseButton == LEFT ) {
    if ( firstClick ) {
      grid.onFirstClick();
      firstClick = false;
    }
    grid.onLeftClick();
  }
  if ( mouseButton == RIGHT ) {
    grid.onRightClick();
  }
  background( backgroundColor );
  grid.show();
  draw();
  grid.checkConditions();
}