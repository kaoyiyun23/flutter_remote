import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/post.dart';

class PostTable extends StatelessWidget {
  //List<Post>之後要進行畫面渲染，必須要有資料，故設此變數，後續用於建構子，之後他人使用時，必須給予一個List<Post>
  List<Post> posts;
  PostTable(this.posts);

  @override
  Widget build(BuildContext context) {
    //取出第一筆數據，轉換成json，並將欄位提取出來，成為一個陣列，裡面放置資料鍵的字串
    List<String> columnName = (jsonDecode(posts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();

    //將資料鍵逐個轉換成DataColumn一個一個的表格欄位
    List<DataColumn> dataColumns = columnName.map((key) {
      return DataColumn(
        label: Text(key),
      );
    }).toList();

    //將posts裡面的post讀取出來
    //將該post的變數與內容，將其轉換成DataCell
    //而後整併成一個DataRow
    //最後將posts整理成一個List<DataRow>
    List<DataRow> dataRows = posts.map((post) {
      //將post物件轉換成一個集合鍵值
      Map<String, dynamic> postJosn = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;

      //依據我們要呈現的欄位把post符合該欄位的內容提取出來，並轉換成DataCell，而後整成一個List
      List<DataCell> dataCells = columnName.map((key) {
        return DataCell(
          Text(postJosn[key].toString())
        );
      }).toList();

      //每一列DataRow要生成時，必須要用List<DataCell>當建構子，將先前的List<DataCell>放入
      return DataRow(
        cells: dataCells
      );
    }).toList();

    //每一列DataTable將身為List<DataColumn>的dataColumns與List<DataRow>的dataRows當作建構子放入
    return DataTable(
      columns: dataColumns,
      rows: dataRows,
    );
  }
}