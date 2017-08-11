static class Time {
  // Utility class for the timer at the bottom
  
  static String returnTime( int millisElapsed ) {
    String time;
    int millis = millisElapsed;
    int seconds = millis / 1000;
    int minutes = seconds / 60;
    seconds = seconds % 60;
    
    if( seconds < 10 )
      time = minutes + ":0" + seconds;
    else
      time = minutes + ":" + seconds;
    return time;
  }
}