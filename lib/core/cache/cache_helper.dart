import 'package:shared_preferences/shared_preferences.dart';//دي طريقة عشان اخزن البيانات بشكل دائم عشان لو قفلت التطبيق افضل logged in

abstract class CacheHelper{

  static late SharedPreferences prefs;
  static Future<void> init() async{
  
    prefs = await SharedPreferences.getInstance();
  }

  static Object? getValue(String key){
    return prefs.get(key);
  }

  static Future setValue({
    required String key,
    required dynamic value
})async{
    if(value is bool){
      return await prefs.setBool(key, value);
    }
    else if(value is int){
      return await prefs.setInt(key, value);
    }
    else if(value is double){
      return await prefs.setDouble(key, value);
    }
    else if(value is List<String>){
      return await prefs.setStringList(key, value);
    }
    else{
      return await prefs.setString(key, value.toString());
    }
  }

}