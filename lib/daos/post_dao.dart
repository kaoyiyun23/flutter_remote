import 'package:flutter_application_3/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostDao {
  //插入，從本地緩存，若無，則重新提取外部資料
  //撰寫一個讀取資料的方式
  static Future<List<Post>> getPosts() async {
    //建立一個專門跟Cache溝通的客戶端物件
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    //設定cache位置的索引
    String cacheKey = "posts";
    
    //用客戶端物件 依照索引向緩存取得資料
    List<String>? postDataStringInCache = await _prefs.getStringList(cacheKey);

    //若有資料，則將資料從String陣列，轉成Post陣列
    if(postDataStringInCache != null) {
      print("從Cache載入資料");
      List<Post> posts = postDataStringInCache.map((postJsonString) => Post.fromJson(jsonDecode(postJsonString))).toList();
      return posts;
      //若查無資料，則向遠端系統索取資料
    }
    else {
      print("爬取資料");
      //設定遠端系統位置
      //解析外部系統格式
      var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      //透過http組件，使用get函數向外部系統索取內容
      var response = await http.get(url);

      //將取用的內容轉化成List<dynamic>，並透過map這個迴圈方式，將dynamic逐一轉換成Post物件
      List<Post> posts = (jsonDecode(response.body) as List<dynamic>).map((jsonObject) {
        return Post.fromJson(jsonObject);
      }).toList();

      //將Post陣列轉換成String陣列，存一份回緩存內
      List<String> postsStringList = posts.map((e) => e.toJsonObjectString()).toList();
      _prefs.setStringList(cacheKey, postsStringList);

      //將一系列Post物件傳回
      return posts;
    }
  }
}