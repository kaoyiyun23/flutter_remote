import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/post.dart';
import 'package:http/http.dart' as http;

class PostTableWithSearchEdit extends StatefulWidget {
  List<Post> posts;

  PostTableWithSearchEdit(this.posts);

  @override
  State createState() {
    return _PostTableWithSearchEdit();
  }
}

class _PostTableWithSearchEdit extends State<PostTableWithSearchEdit> {
  List<Post> filteredPosts = [];

  void changeFilteredPosts(String userInput) {
    //使用where函數，針對資料進行篩選
    filteredPosts = this.widget.posts.where((element) {
      //若用戶不輸入任何內容，則全部保留
      if(userInput == "") {
        return true;
        //若用戶有輸入內容，且在Post的title欄位內有用戶所輸入的文字內容，則保留
      }
      else if(element.title.contains(userInput)) {
        print(element.title);
        return true;
        //若Post的title與用戶輸入內容不同則剔除
      }
      else {
        return false;
      }
    }).toList();

    //若查詢後，filteredPosts的長度為0，代表查無資料，故添加一筆假資料，告知查無資料
    if(filteredPosts.length == 0) {
      filteredPosts.add(Post(999, 999, "查無資料", "查無資料"));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(filteredPosts.length == 0) {
      changeFilteredPosts("");
    }

    var searchTextEditingController = TextEditingController();
    //searchBar
    Widget searchBar = TextField(
      controller: searchTextEditingController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter a search term"
      ),
      onSubmitted: (inputStr) {
        setState(() {
          changeFilteredPosts(inputStr);
        });
      },
    );

    //取出第一筆數據，轉換成json，並將欄位提取出來，成為一個陣列，裡面放置資料鍵的字串
    List<String> columnName = (jsonDecode(filteredPosts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();

    //將資料鍵逐個轉換成DataColumn一個一個表格欄
    List<DataColumn> dataColumns = columnName.map((key) {
      return DataColumn(
        label: Text(key)
      );
    }).toList();

    //將posts裡面的post讀取出來
    //將該post的變數與內容轉換成Datacell
    //而後整併成DataRow
    //最後將posts整理成一個List<DataRow>
    List<DataRow> dataRows = filteredPosts.map((post) {
      //將post物件轉換成一個集合鍵值
      Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String,dynamic>;

      //依據我們要呈現的欄位，把post符合該欄位的內容提取出來，並轉換成DataCell，而後整成一個List
      List<DataCell> dataCells = columnName.map((key) {
        return DataCell(
          //由於要開放用戶編輯，從先前的Text改為TextField
          //仍有顯示資料的需求，此刻透過TextEditingController的Text參數，進行顯示
          //onSubmitted編寫一個函數，使用http模組的post函數，把修改後的內容還回給遠端系統
          TextField(
            controller: TextEditingController(
              text: postJson[key].toString()),
              onSubmitted: (inputstr) {
                //將postJson該欄位內容換成用戶修改的內容
                postJson[key] = inputstr;
                print(postJson);

                //設定遠端系統位置
                var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                
                //傳回遠端
                var responseOfFuture = http.post(url, body: jsonEncode(postJson));

                //將遠端系統回傳結果印出來
                responseOfFuture.then((value) => print(value.body));
              }
          )
        );
      }).toList();
      return DataRow(
        cells: dataCells
      );
    }).toList();

    //擔心超過畫面高度，使用SingleChildScrollView
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
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