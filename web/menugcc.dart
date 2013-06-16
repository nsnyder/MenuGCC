import 'dart:html';
import 'package:xml/xml.dart';
import 'dart:async';

void main() {  
  // Each MenuCollection will encompass 1 day
  MenuCollection hicks = new MenuCollection();
  MenuCollection map = new MenuCollection();
  MenuCollection gedunk = new MenuCollection();
  
  Menu hicks_test = new Menu();
  hicks_test..setDate("Today")
            ..addMeal(0,'Breakfast')
            ..addMeal(1,'Lunch')
            ..addItems(0, ['Scrambled Eggs','Bacon','Sausage']);
  
  
  var hicksCont = query('#hicksContainer');
  var mapCont = query('#mapContainer');
  var gedunkCont = query('#gedunkContainer');  
  try {
    hicks.openXmlMenu("Hicks.xml").then((data) {
      try {
        data.print(hicksCont, '<h2></h2>', '<h3></h3>', '<li></li>', '<span></span>');
      } catch (err) {
        hicksCont.appendText("No Menu Data");
      }
    });
  } catch (err) { // Fires if there is no menu
    window.alert("Error: Could not download Hicks menu");
  }
  try {
    map.openXmlMenu("Hicks.xml").then((data) {
      try {
        data.print(mapCont, '<h2></h2>', '<h3></h3>', '<li></li>', '<span></span>');
      } catch (err) {
        mapCont.appendText("No Menu Data");
      }
    });
  } catch (err) { // Fires if there is no menu
    window.alert("Error: Could not download Hicks menu");
  }
  try {
    gedunk.openXmlMenu("Hicks.xml").then((data) {
      try {
        data.print(gedunkCont, '<h2></h2>', '<h3></h3>', '<li></li>', '<span></span>');
      } catch (err) {
        gedunkCont.appendText("No Menu Data");
      }
    });
  } catch (err) { // Fires if there is no menu
    window.alert("Error: Could not download Hicks menu");
  }
}

bool connectionState() {
  // Returns true if connected
}

class MenuCollection {
  List<Menu> menus;
  
  MenuCollection() {
    menus = new List<Menu>();
  }
  
  Future<MenuCollection> openXmlMenu(String feedUri) {
    var feedData;
    HttpRequest.getString(feedUri).then((feedData) {
      // .replaceAll(new RegExp(r'(\w\s*)/(?=\s*\w)'),"$1|$2")
      var xml=feedData.replaceAll(new RegExp(r'\<\?[\s\S]*\?\>'),'')
          .replaceAll(new RegExp(r'&lt;h3&gt;'),r'<h3>')
          .replaceAll(new RegExp(r'&lt;/h3&gt;'),r'</h3>').replaceAll(new RegExp(r'&amp;(#38;)*'),'&')
          .replaceAll(new RegExp(r'(\&lt;).{1,3}(\&gt;)'),'').replaceAll('nbsp;',' ')
          .replaceAll(new RegExp(r'&[\n\r\t\v\f\s]*\[')," \n[").replaceAll(new RegExp(r'&[\n\r\t\v\f\s]*\<'),' \n<')
          .replaceAll(new RegExp(r'\>*\s\|\['),'>[').replaceAll(']',']|').replaceAll('[','|[')
          .replaceAllMapped(new RegExp(r'([a-vx-zA-VX-Z]\s*)/(\s+[a-zA-z])'), (match) => "${match[1]}|${match[2]}");

      // .replaceAll(new RegExp(r'\>*s|\['),'>[')
      xml = XML.parse(xml);
      // window.console.debug(xml);
      xml = xml.queryAll("item");
      
      xml.forEach((myXml) {
        Menu myMenu;
        var date = myXml.queryAll('title');
        var items = myXml.queryAll('items');
        date.forEach((myDate) {
          myMenu = new Menu();
          myMenu..setDate(myDate.toString())
          ..addMeal(0,"lunch")
          ..addItem(0, 'food');
          menus.add(myMenu);
        });
        var myNode = new Element.html(date[0].toString());
        // window.console.debug(myNode.text);        
      });
    });
    return new Future<MenuCollection>(() {
      return new Future<MenuCollection>(() => this);
    });
  }
  
  void print(parent, dateElement, titleElement, itemElement, stationElement,
             [String dateClass="date", String titleClass="mealTitle",
             String itemClass="mealItem", String stationClass="stationName"]) {
    if(menus.length>0) {
      for(int i=0; i<menus.length; i++) {
        menus[i].printMenu(parent, dateElement, titleElement, itemElement, stationElement, dateClass, titleClass, itemClass, stationClass);
      }
    } else { throw 0; }
  }
}

class Menu {
  var meals;  // Breakfast, lunch, dinner, etc.
  var mealItems;  // Chicken strips, meatloaf, etc.
  var stations;   // Wok Zone, homestyle, etc.
  var stationIndices; // List of integers, corresponds to the first item at each station
  var date;   // Date for the meal
  
  // Constructs a blank menu
  Menu() {
    meals = new List<String>(4);
    mealItems = new List<Set>(4);
    stations = new List<Set>(4);
    stationIndices = new List<int>(4);
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
    if(mealItems[mealId]==null) {
      mealItems[mealId] = new Set();
    }
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
  
  void printMenu(parent, dateElement, titleElement, itemElement, stationElement,
                 [String dateClass="date", String titleClass="mealTitle",
                 String itemClass="mealItem", String stationClass="stationName"]) {
    // todo: Print date
    
    for(int i=0; i<4; i++) {
      if(meals[i]!=null) {
        var title = new Element.html(titleElement);
        title..text = meals[i]
             ..classes.add(titleClass);
        parent.children.add(title);
        if(mealItems[i]!=null) {
          int count=0, stationIndex=0;
          for(final i in mealItems[i]) {
            if(stations[stationIndex]!=null && stationIndices[stationIndex]==i) {
              var station = new Element.html(stationElement);
              station..Text = stations[stationIndex]
                     ..classes.add(stationClass);
              parent.children.add(station);
              stationIndex++;
            }
            var item = new Element.html(itemElement);
            item..text = '$i'
                ..classes.add(itemClass);
            parent.children.add(item);
            count++;
          }
        }
      }
    }
  }
}