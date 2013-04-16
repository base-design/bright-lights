class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  boolean running;

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  void wait(int newTotalTime) {
    totalTime = newTotalTime;
  }
  
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
    running = true;
  }
  void stop() {
    // When the timer starts it stores the current time in milliseconds.
    running = false; 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime && running) {
      running = false;
      return true;
    } else {
      return false;
    }
  }
   boolean isRunning() { 
    return running;
  }
}
