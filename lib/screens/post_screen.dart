import 'package:flutter/material.dart';
//import 'package:flutter_application_3/components/post_text.dart';
//import 'package:flutter_application_3/components/post_table.dart';
import 'package:flutter_application_3/components/post_table_with_search.dart';
import 'package:flutter_application_3/components/post_table_with_search_and_edit.dart';
import 'package:flutter_application_3/daos/post_dao.dart';
import 'package:flutter_application_3/models/post.dart';

class PostScreen extends StatefulWidget {
  //將組件直接貼到Scaffold內
  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostText(),
    );
  } */

  @override
  State createState() {
    return _PostScreen();
  }
}

class _PostScreen extends State<PostScreen> {
  //透過PostDao去用遠端系統資料，此資料會返還Future
  //故使用FutureBuilder，當資料取回時，可以進行畫面重渲染
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //讀取遠端資料
      future: PostDao.getPosts(),
      //設計取用遠端資料之後的操作方法
      builder: (BuildContext context, AsyncSnapshot<List<Post>> asyncOfPosts) {
        return Scaffold(
          //將載入的資料當作PostTable的建構子，創建一個PostTable物件
          //body: PostTable(asyncOfPosts.requireData),
          body: PostTableWithSearch(asyncOfPosts.requireData),
        );
      }
    );
  }
}