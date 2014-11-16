/*
  Reads line by line from a text file,
  then sends the line to the TextRoll instance.
*/

class TextReader {
  
  /* MEMBERS */
  Game parent;               // Game parent
  BufferedReader reader;     // processes a text file
  TextRoll tr;               // where to place the text
  
  /* CONTROL VARIABLES */
  // none
  
  /* CONSTANTS */
  // none
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  TextReader(Game g, String filepath, TextRoll roll) {
    parent = g;
    
    reader = createReader(filepath);
    
    tr = roll;
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  public void run() {
    // does nothing at the moment
  }
  
  /*
      READS THE NEXT LINE AND PROCESSES IT, POSSIBLY TO THE SCREEN
  */
  public void sendNextLine() {
    
    // check to see if reader exists
    if (reader == null) return;
    
    // if not ready, user wants to see all the text, so flush all the text
    if (!tr.readyNext) {
      tr.flushBuffer();
      return;
    }
    
    // grab the next line from the reader
    String line;
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    // error checking
    if (line == null) return;
    
    // skip over blank lines
    if (line.length() == 0) {
      sendNextLine();
      return;
    } 
    // if the line is a comamnd, process it, and process next line
    else if (line.length() > 1 && line.charAt(0) == '<' && line.charAt(line.length()-1) == '>') {
      String command = line.substring(1, line.length()-1);
      
      handleCommands(command);
      
      sendNextLine();
      return;
    }
    
    // otherwise, send the line to the text roller
    tr.setText(line, false);
  }
  
  
  /*
      HANDLES THE COMMANDS SENT BY THE READER
  */
  private void handleCommands(String command) {
    
    // <off> closes the reader and tells the parent to close the window
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
      
      // <fight> closes the reader and tells the parent to initiate fighting sequence
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
      
      // <chapterend> tells the parent the chapter is ending
      else if (command.equals("chapterend")) {
        parent.extraFade = parent.EXTRA_FADE_LENGTH;
        parent.chapter_ending = true;
        return; 
      }
      
      // emoticon functions <surprise>, <question>, <ellipses>
      else if (command.equals("surpise") || command.equals("question") || command.equals("ellipses"))
        parent.extraEmoticon(command);
      
  }
}
    
