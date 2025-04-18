import 'dart:convert';

import 'package:flutter_riverpod_mvvm/user.dart';

class UserRepository {
  Future<User> getUser() async {
    await Future.delayed(Duration(seconds: 1));
    String dummy = """
{
	"name": "jiwon",
	"age": 20
}
 """;
    //1. jsoonDecode 함수 사용해서 Map으로 변환
    Map<String, dynamic> map = jsonDecode(dummy);
    //2. map => 객체
    return User.fromJson(map);
  }
}
