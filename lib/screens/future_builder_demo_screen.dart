import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FutureBuilderDemoScreen extends StatelessWidget {
  //跟外部要資料
  //由於跟外部系統要資料並不能確保回應時間，通常會用Future進行包覆
  //不要讓主程序等待這個行為，避免整個畫面延宕等待
  Future<dynamic> getDataFromRemote() async {
    //解析遠端系統網址
    var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    //透過http的get方法訪問該網址
    var response = await http.get(url);
    //回傳結果的封包內容
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    //使用FutureBuilder
    //此建構子的功能，當我們跟外部系統要資料的時候，可以先用一個預設資料做基礎渲染
    //等到資料取回後，再重新渲染一次
    //future接一個回傳值為Future的函數
    //initialData接預設資料，在此我們設一個空陣列
    //builder必須接一個匿名函數 有兩個可調用的參數：第一個參數為記錄所有狀態的Context，第二個參數為Future傳回的參數
    return FutureBuilder(
      future: getDataFromRemote(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<dynamic> AsyncSnapshot) {
        return Scaffold(
          body: Text(AsyncSnapshot.data),
        );
      }
    );
  }
}