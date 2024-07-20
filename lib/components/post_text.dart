import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/daos/post_dao.dart';
import 'package:flutter_application_3/models/post.dart';

//一個視覺化組件，將遠端系統數據以純文字方式表達
class PostText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //由於需要透過PostDao跟外部系統調度資料，而跟外部系統調部資料時，是不可預期效能的
    // 故PostDao在跟外部系統溝通時，用Future隔離環境
    //為了要能夠讓跟外部系統調度數據的Future能夠有效地將資料做渲染，可透過FutureBuilder配置Future起始數據/渲染方式
    return FutureBuilder(
      //請PostDao使用調度外部系統資料的Future函數
      future: PostDao.getPosts(),
      //告知Flutter取用資料後必須如何進行資料渲染
      builder: (BuildContext context, AsyncSnapshot<List<Post>> asyncSnapshot) {
        //一個空陣列
        List<Widget> widgets = [];

        //確認與遠端系統交互的連線狀態
        print(asyncSnapshot.connectionState);

        //確認是否已取得資料
        print(asyncSnapshot.hasData);

        //如果連線狀態為已完成，則取用數據，並轉換成Text
        if(asyncSnapshot.connectionState == ConnectionState.done) {
          widgets = asyncSnapshot.requireData.map((post) {
            return Text(post.toJsonObjectString());
          }).toList();
        }

        //由於數據量過大，使用SingleChildScrollView
        return SingleChildScrollView(
          child: Column(
            children: widgets,
          ),
        );
      }
    );
  }
}