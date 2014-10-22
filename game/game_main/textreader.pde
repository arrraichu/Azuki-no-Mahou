/*
  Reads line by line from a text file,
  then sends the line to the TextRoll instance.
*/

class TextReader {
  // reader and displayer
  BufferedReader reader;
  TextRoll tr;
  
  public String feedback = "";
  
  // constructor
  TextReader(String filepath, TextRoll roll) {
    reader = createReader(filepath);
    tr = roll;
  }
  
  // read one line and display it
  void sendNextLine() {
    if (!tr.ready()) return;
    
    String line;
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    
    if (line == null) return;
    
    if (line.length() == 0) {
      tr.stall();
      sendNextLine();
    } else if (line.length() > 1 && line.charAt(0) == '<' && line.charAt(line.length()-1) == '>') {
      String command = line.substring(1, line.length()-1);
      if (command.equals("surprise")) feedback = "surprise";
      sendNextLine();
      return;
    }
    
    tr.setText(line, false);
  }
}
    
