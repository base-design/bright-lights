String[] data;
ArrayList <Instruction> instructions;
String[] validTypes = {
  "backAndForth", "rotate", "stop", "grow"
}; //, "move", etc 

void parseInstructions() {
  data = loadStrings("instructions.txt");
  instructions = new ArrayList();
  for (int i = 0; i < data.length; i++) {
    data[i] = data[i].split("//")[0];
    if (!data[i].trim().equals("")) {
      String[] opts = data[i].split(",");
      for (int j = 0; j < opts.length; j++) {
        opts[j] = opts[j].trim();
      }
      println(opts);
      instructions.add(new Instruction(opts) );
    }
  }
  println("valid instructions: " + instructions.size());
}

void runInstructions() {
  for (int i = 0; i < instructions.size(); i++) {
    Instruction inst = instructions.get(i);
    inst.run();
  }
}


class Instruction {
  boolean valid = false;
  boolean hasRun = false;
  boolean validOpts = false;
  int cue;
  int group;
  String type;
  String[] opts = new String[4];

  Instruction(String[] o) {
    type = o[2];
    for (int k = 0; k < validTypes.length; k++) {
      if (type.equals(validTypes[k])) valid = true;
    }
    if (valid) {
      cue = parseInt(o[0]);
      group = parseInt(o[1]);
      for (int i = 3; i < o.length; i++){
        opts[i-3] =  o[i];
      }
      validOpts = true;
    }
  }

  void run() {
    //    //    println(cue + " " + millis());
    if (cue <= millis() && !hasRun && valid) {
      execute(type);
      hasRun = true;
    }
  }

  void execute(String type) {
    if (type.equals("backAndForth")) ps[group].backAndForth( opts[0], parseInt(opts[1]) );
    if (type.equals("rotate")) ps[group].rotate( parseInt(opts[0]), parseInt(opts[1]) );
  }
}

