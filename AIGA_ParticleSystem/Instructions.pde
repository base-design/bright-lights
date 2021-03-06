String[] data;
ArrayList <Instruction> instructions;
String[] validTypes = {
  "backAndForth", "rotate", "stop", "grow", "changePattern", "STOP", "falldown", "leave"
}; //, "move", etc 

void parseInstructions() {
  data = loadStrings(instructions_file);
  int actOffset = 0;
  instructions = new ArrayList();
  for (int i = 0; i < data.length; i++) {
    data[i] = data[i].split("//")[0];
    if (data[i].trim().equals("break")) break;
    if (data[i].trim().equals("clear")) { 
      println("clear!"); 
      instructions.clear(); 
      actOffset = 0; 
      continue;
    }

    if (data[i].indexOf(":") == 0) {
      String[][] parts = matchAll(data[i], "[0-9]+");
      if (parts.length == 1) actOffset += parseInt(parts[0][0]);
      else actOffset += parseInt(parts[0][0]) * parseInt(parts[1][0]);
    } 
    else if (!data[i].trim().equals("")) {
      String[] opts = (data[i]).split(",");
      for (int j = 0; j < opts.length; j++) {
        opts[j] = opts[j].trim();
      }
      //      println(opts);
      instructions.add(new Instruction(opts, actOffset, i) );
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
  String[] opts = new String[5];

  Instruction(String[] o, int ao, int l) {
    type = o[2];
    opts[4] = l + "";
    actOffset = ao;
    for (int k = 0; k < validTypes.length; k++) {
      if (type.equals(validTypes[k])) valid = true;
    }
    if (valid) {
      cue = parseInt(o[0]);
      group = (o[1].equals("all")) ? 5 :  parseInt(o[1]);

      for (int i = 3; i < o.length; i++) {
        opts[i-3] =  o[i];
      }
      validOpts = true;
    }
  }

  void run() {
    //    //    println(cue + " " + millis());
    if (cue + actOffset <= frames / 1000.0 * frame_rate && !hasRun && valid) {
      execute(type);

      println(opts[4] + " " + (cue+ actOffset) + " " +  "\texecuting " + type + " on group " + group);
      hasRun = true;
    }
  }

  void execute(String type) {
    if (opts[2] == null) opts[2] = "1"; 
    if (opts[1] == null) opts[1] = "0.1"; 
    if (group == 5) {
      for (int i = 0; i < 4; i++) {
        if (type.equals("backAndForth")) ps[i].backAndForth( opts[0], parseInt(opts[1]), parseFloat(opts[2]) );
        if (type.equals("rotate")) ps[i].rotate( parseInt(opts[0]), parseInt(opts[1]) );
        if (type.equals("grow")) ps[i].grow( parseInt(opts[0]), parseFloat(opts[1]));
        if (type.equals("stop")) ps[i].stop();
        if (type.equals("changePattern")) ps[i].changePattern(parseInt(opts[0]));
        if (type.equals("STOP")) { println("exiting on s." + (frames/30)); exit(); } 
        if (type.equals("falldown")) gravity = true;
        if (type.equals("leave")) ps[i].leave(parseFloat(opts[0]));
      }
    } 
    else {
      if (type.equals("backAndForth")) ps[group].backAndForth( opts[0], parseFloat(opts[1]), parseFloat(opts[2]) );
      if (type.equals("rotate")) ps[group].rotate( parseFloat(opts[0]), parseFloat(opts[1]) );
      if (type.equals("grow")) ps[group].grow( parseInt(opts[0]), parseFloat(opts[1]));
      if (type.equals("stop")) ps[group].stop();
      if (type.equals("changePattern")) ps[group].changePattern(parseInt(opts[0]));
      if (type.equals("falldown")) { gravity = true; }  
      if (type.equals("STOP")) { 
        println("exiting on s." + (frames/30)); 
        exit();
      }
    }
  }
}

