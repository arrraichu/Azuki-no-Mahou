/*
  Reads line by line from a text file,
  then sends the line to the TextRoll instance.
*/

class TextReader {
  Game parent;
  
  // reader and displayer
  BufferedReader reader;
  TextRoll tr;
  
  // used only for sending next line
  final int WAIT_TIME = 30;
  int wait_counter = -1;
  
  // constructor
  TextReader(Game g, String filepath, TextRoll roll) {
    reader = createReader(filepath);
    tr = roll;
    parent = g;
  }
  
  void run() {
    if (wait_counter < 0) return;
    if (wait_counter > 0) {
      wait_counter--;
      return;
    }
    if (wait_counter == 0) {
      sendNextLine();
      wait_counter--;
    }
    
  }
  
  void stall() {
    wait_counter = WAIT_TIME;
  }
  
  // read one line and display it
  void sendNextLine() {
    if (reader == null) return;
    if (!tr.ready()) {
      tr.flushBuffer();
      return;
    }
    
    String line;
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    if (line == null) return;
    
    if (line.length() == 0) {
      stall();
    } else if (line.length() > 1 && line.charAt(0) == '<' && line.charAt(line.length()-1) == '>') {
      String command = line.substring(1, line.length()-1);
      
      handleCommands(command);
      
      sendNextLine();
      return;
    }
    
    tr.setText(line, false);
  }
  
  void handleCommands(String command) {
    if (command.equals("off")) {
        try {
          reader.close();
        } catch (IOException e) {
          
        } finally {
          reader = null;
          parent.extraOff();
        }
        return;
      }
      else if (command.equals("fight")) {
        try {
          reader.close();
        } catch (IOException e) {
        } finally {
          reader = null;
          parent.extraFight();
        }
        return;
      }
      else if (command.equals("chapterend")) {
        parent.extraFade = parent.EXTRA_FADE_LENGTH;
        parent.chapter_ending = true;
        return; 
      }
      else if (command.equals("surprise")) parent.extraPlayerSurprised();
      else if (command.equals("question")) parent.extraPlayerQuestion();
      else if (command.equals("ellipses")) parent.extraPlayerEllipses();
      
  }
}
    
