String[] data;
ArrayList <Instruction> instructions;
String[] validTypes = {
  "backAndForth", "rotate", "stop", "grow"
}; //, "move", etc 

void parseInstructions() {
  data = loadStrings("instructions.txt");
  int actOffset = 0;
  instructions = new ArrayList();
  for (int i = 0; i < data.length; i++) {
    data[i] = data[i].split("//")[0];
    if (data[i].trim().equals("break")) break;
    
    if (data[i].indexOf(":") == 0) {
      String[][] parts = matchAll(data[i], "[0-9]+");
      if (parts.length == 1) actOffset = parseInt(parts[0][0]);
      else actOffset = parseInt(parts[0][0]) * parseInt(parts[1][0]);
    } 
    else if (!data[i].trim().equals("")) {
      String[] opts = data[i].split(",");
      for (int j = 0; j < opts.length; j++) {
        opts[j] = opts[j].trim();
      }
      //      println(opts);
      instructions.add(new Instruction(opts, actOffset) );
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
  int cue, group, actOffset;
  String type;
  String[] opts = new String[4];

  Instruction(String[] o, int ao) {
    type = o[2];
    actOffset = ao;
    for (int k = 0; k < validTypes.length; k++) {
      if (type.equals(validTypes[k])) valid = true;
    }
    if (valid) {
      cue = parseInt(o[0]);
      group = parseInt(o[1]);
      
      for (int i = 3; i < o.length; i++) {
        opts[i-3] =  o[i];
      }
      validOpts = true;
    }
  }

  void run() {
    //    //    println(cue + " " + millis());
    if (cue + actOffset <= millis() / 1000.0 && !hasRun && valid) {
      execute(type);
      println((cue + actOffset) + "\texecuting " + type + " on group " + group ); 
      hasRun = true;
    }
  }

  void execute(String type) {
    if (type.equals("backAndForth")) ps[group].backAndForth( opts[0], parseInt(opts[1]) );
    if (type.equals("rotate")) ps[group].rotate( parseInt(opts[0]), parseInt(opts[1]) );
    if (type.equals("grow")) ps[group].grow( parseInt(opts[0]));
    if (type.equals("stop")) ps[group].stop();
  }
}

