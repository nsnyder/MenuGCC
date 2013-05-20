import 'dart:html';

void main() {  
  List<Menu> hicks = new List<Menu>();
  List<Menu> map = new List<Menu>();
  List<Menu> gedunk = new List<Menu>();
  
  parseXmlMenu(hicks,"C:/Users/SNYDERNA1/Downloads/Hicks.xml");
  
  
  /* Menu hicks_test = new Menu();
  hicks_test..setDate("Today")
            ..addMeal(0,'Breakfast')
            ..addMeal(1,'Lunch')
            ..addItems(0, ['Scrambled Eggs','Bacon','Sausage']);
  */
  
  var hicksCont = query('#hicksContainer');
  var mapCont = query('#mapContainer');
  var gedunkCont = query('#gedunkContainer');  
  try {
    hicks[0].printMenu('<h2></h2>', '<h3></h3>', '<li></li>', hicksCont);
  } catch (err) { // Fires if there is no menu
    hicksCont.text="No Menu Data";
  }
  try {
    map[0].printMenu('<h2></h2>', '<h3></h3>', '<li></li>', mapCont);
  } catch (err) { // Fires if there is no menu
    mapCont.text="No Menu Data";
  }
  try {
    gedunk[0].printMenu('<h2></h2>', '<h3></h3>', '<li></li>', gedunkCont);
  } catch (err) { // Fires if there is no menu
    gedunkCont.text="No Menu Data";
  }
}

bool connectionState() {
  // Returns true if connected
}

void parseXmlMenu(List<Menu> caf, String feed) {
  
}

class Menu {
  var meals;  // Breakfast, lunch, dinner, etc.
  var mealItems;  // Chicken strips, meatloaf, etc.
  var date;   // Date for the meal
  
  // Constructs a blank menu
  Menu() {
    meals = new List<String>(4);
    mealItems = new List<Set>(4);
    var date = "";
  }
  
  void setDate(String date) {
    this.date = date;
    return;
  }
  
  void addMeal(int mealId, String meal) {
    //if(mealId<meals)
    if(meals[mealId]==null) {
      meals[mealId] = meal;
      return;
    } else {
      // @todo('Nathan',"Implement some sort of exception if it's already here");
      return;
    }
  }
  
  void addItem(int mealId, String item) {  // adds a single item
    mealItems[mealId].add(item);
    return;
  }
  
  void addItems(int mealId, List<String> items) {  // add a list of items
    if(mealItems[mealId]==null) {
      mealItems[mealId] = new Set();
    }
    mealItems[mealId].addAll(items);
    return;
  }
  
  void printMenu(dateElement, titleElement, itemElement,
                 parent, [String titleClass="mealTitle",
                 String itemClass="mealItem"]) {
    // todo: Print date
    
    for(int i=0; i<4; i++) {
      if(meals[i]!=null) {
        var title = new Element.html(titleElement);
        title..text = meals[i]
             ..classes.add(titleClass);
        parent.children.add(title);
        if(mealItems[i]!=null) {
          for(final i in mealItems[i]) {
            var item = new Element.html(itemElement);
            item..text = '$i'
                ..classes.add(itemClass);
            parent.children.add(item);
          }
        }
      }
    }
  }
}