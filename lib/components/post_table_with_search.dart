import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_3/models/post.dart';

class PostTableWithSearch extends StatefulWidget {
  List<Post> posts;

  PostTableWithSearch(this.posts);

  @override
  State createState() {
    return _PostTableWithSearch();
  }
}

class _PostTableWithSearch extends State<PostTableWithSearch> {
  //用來存放已經篩選好的Post
  List<Post> filteredPosts = [];

  void changeFilteredPosts(String userInput) {
    //使用where函數，針對資料進行篩選
    filteredPosts = this.widget.posts.where((element) {
      //若用戶不輸入任何內容，則全部保留
      if(userInput == "") {
        return true;
        //若用戶有輸入內容，且在Post的title欄位內有用戶所輸入的文字，則保留 
      }
      else {
        return false;
      }
    }).toList();
    
    //若查詢後，filteredPosts的長度為0，代表差無資料，故增加一筆假資料，告知差無資料
    if(filteredPosts.length == 0) {
      filteredPosts.add(Post(999, 999, "查無資料", "查無資料"));
    }
  }

  @override
  Widget build(BuildContext context) {
    //若已過濾的Post陣列為0，代表尚未過濾
    if(filteredPosts.length == 0) {
      changeFilteredPosts("");
    }

    //建立一個新的文字控制器
    var searchTextEditingController = TextEditingController();

    //建立文字輸入框
    Widget searchBar = TextField(
      //將剛剛建立的文字控制器放入
      controller: searchTextEditingController,
      //添加外部裝飾
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term'
      ),
      //當用戶輸入內容後，調度下面函數，進行搜尋
      onSubmitted: (inputStr) {
        //渲染畫面
        setState(() {
          changeFilteredPosts(inputStr);
        });
      },
    );

    //將該字串陣列轉成DataColumn
    List<String> columnName = (jsonDecode(filteredPosts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();
    List<DataColumn> dataColumns = columnName.map((key) {
      return DataColumn(
        label: Text(key)
      );
    }).toList();

    //用已過濾的Post陣列，逐筆轉化成DataRow
    List<DataRow> dataRows = filteredPosts.map((post) {
      //轉換單筆Post，變成Map資料結構
      Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;
      //依照我們要查詢用的欄位，提取Post的資料內容，並轉化成DataCell
      List<DataCell> dataCells = columnName.map((key) {
        return DataCell(
          Text(postJson[key].toString())
        );
      }).toList();
      //將DataCell整併成一條DataRow
      return DataRow(
        cells: dataCells
      );
    }).toList();

    //擔心超過畫面高度，使用SingleChildScrollView，萬一內容超過頁面時，可以用滾輪滑動檢視
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        //先放入搜尋列至頂
        //放入資料表
        child: Column(
          children: [
            Container(
              width: 800,
              child: searchBar,
            ),
            Container(
              width: 800,
              child: DataTable(
                columns: dataColumns,
                rows: dataRows,
              ),
            )
          ],
        ),
      ),
    );
  }
}