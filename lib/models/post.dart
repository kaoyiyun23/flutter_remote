import 'dart:convert';

//資料類別的重要性在於其為建構資料系統的核心
//因此必須為其設計，如何有效轉換為外部系統，或從外部數據匯入的函數
class Post {
  //設定該遠端系統資料的欄位
  int userId;
  int id;
  String title;
  String body;

  //建構子
  Post(this.userId, this.id, this.title, this.body);

  //可將物件轉換成符合json規格的String
  //後續要傳數據給外部系統，可透過此函數轉換成外部系統需要json格式
  String toJsonObjectString() {
    return jsonEncode({
      "userId": this.userId,
      "id": this.id,
      "title": this.title,
      "body": this.body
    });
  }

  //建構子的一種
  //能將符合json規格的dynamic建置成Post物件
  //因應未來跟外部系統取得數據後，轉換成Post物件
  factory Post.fromJson(dynamic jsonObject) {
    return Post(
      jsonObject['userId'],
      jsonObject['id'],
      jsonObject['title'],
      jsonObject['body']
    );
  }
}