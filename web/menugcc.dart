import 'dart:html';

void main() {
  // var elem = new Element.html('<h3>Test</h3>');
  // elem.text="New Element w/ new text";
  // query('body').children.add(elem);
  
  List<String> cafes = new List<String>();
  cafes.add('Hicks');
  Menu hicks_test = new Menu();
  hicks_test..setDate("Today")
            ..addMeal(0,'Breakfast')
            ..addMeal(1,'Lunch')
            ..addItems(0, ['Scrambled Eggs','Bacon','Sausage']);
  
  
  var menu1 = new DivElement();
  menu1..id = cafes[0]
       ..classes.add('cafeContainer');
  query('body').children.add(menu1);
  var heading1 = new HeadingElement.h2();
  heading1..classes.add('cafe')
          ..text = cafes[0];
  menu1.children.add(heading1);

  hicks_test.printMenu('<h3></h3>', '<li></li>', menu1);
}

bool connectionState() {
  // Returns true if connected
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
  
  void printMenu(titleElement, itemElement,
                 parent, [String titleClass="mealTitle",
                 String itemClass="mealItem"]) {
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