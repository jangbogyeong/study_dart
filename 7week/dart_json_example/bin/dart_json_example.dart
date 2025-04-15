import 'dart:convert';

// 직렬화: 객체를 JSON 형태의 문자열로 변환할 때
//       객체 -> Map -> String
//        jsonEncode
//        객체에 toJson 메서드 구현
// 역직렬화: JSON 형태의 문자열을 객체로 변활할 때
//        String -> Map -> 객체로 바꿔준다
//        String -> Map : jsonDecode 함수
//        Map -> 객체 : 객체에 fromJson named 생성자를 구현해서 사용!

void main() {
  String easyJson = """
{
	"name": "오상구",
	"age": 7,
	"isMale" : true
}
""";

  // 1. String -> Map 형태로 바꾼다.
  // 3. Map -> class 객체로 바꾼다

  Map<String, dynamic> map = jsonDecode(easyJson);
  Pet pet = Pet.fromJson(map);
  print(pet.toJson());
}

// 2. class를 정의한다
// name, age, isMale
class Pet {
  String name;
  int age;
  bool isMale;

  Pet({required this.name, required this.age, required this.isMale});

  // fromJson named생성자 만들기

  // Map<String, dynamic> toJson 만들기

  Pet.fromJson(Map<String, dynamic> json)
    : this(name: json["name"], age: json["age"], isMale: json["isMale"]);

  Map<String, dynamic> toJson() {
    return {"name": name, "age": age, "isMale": isMale};
  }
}
