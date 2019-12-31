class DimensionManager {

  Dimension[] dimensions;

  int total;
  int index = 0;
  int prevIndex = 0;

  DimensionManager() {

    String[] dataAll = loadStrings("DimensionsMeta.csv");
    total = dataAll.length-1;

    dimensions = new Dimension[total];

    for (int i=0; i< total; i++) {
      String rawData = dataAll[i+1]; // skip header row
      dimensions[i] = new Dimension(rawData);
    }
  }

  Dimension nextDimension() {
    prevIndex = index;
    
    index++;
    if (index > total-1) index = 0;
    
    println("Next Dimension: "+dimensions[index].name);
    
    return currentDimension();
  }

  Dimension currentDimension() {
    
    return dimensions[index];
  }
  
  Boolean loopedAround() {
    if( (prevIndex == total-1 && index == 0) && dimensions[index].loopedAround() ) return true;
    else return false;
  }
}
