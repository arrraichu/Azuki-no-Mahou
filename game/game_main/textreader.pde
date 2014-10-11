/*
  Reads line by line from a text file,
  then sends the line to the TextRoll instance.
*/

class TextReader {
  // reader and displayer
  BufferedReader reader;
  TextRoll tr;
  
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
    
    tr.setText(line, false);
  }
}
    
