class Dimension {

  String name;
  color textColor, circleColor, backgroundColor, binAColor, binBColor;

  String definition;
  //PImage icon;

  Finding[] findings;
  int total;

  Finding currentFinding;
  int index = 0;
  int prevIndex = 0;

  Dimension(String rawData) {

    String[] data = split( rawData, "," );
    print("Dimension: ");
    println(data);

    name = data[0];
    textColor = unhex(data[1]);
    circleColor = unhex(data[2]);
    backgroundColor = unhex(data[3]);
    binAColor = unhex(data[4]);
    binBColor = unhex(data[5]);

    definition = loadStrings(data[6])[0];

    //icon = loadImage("icons/"+data[7]);

    String[] findingsRaw = loadStrings(data[7]);

    total = findingsRaw.length-1; // account for header
    findings = new Finding[total];

    for (int i=0; i<total; i++) {
      findings[i] = new Finding( findingsRaw[i+1], binAColor, binBColor, textColor );
    }

    currentFinding = findings[index];
  }

  void nextFinding() {
    prevIndex = index;
    
    index++;
    if (index >= total) index = 0;

    currentFinding = findings[index];
    
    println("Finding: "+currentFinding.question);
  }

  Boolean loopedAround() {
    if (prevIndex == total-1 && index == 0) return true;
    else return false;
  }
}
