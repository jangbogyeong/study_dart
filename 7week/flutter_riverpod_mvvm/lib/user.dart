// {
//	"name": "jiwon",
//	"age": 20
//}
class User {
  String name;
  int age;
  User({required this.name, required this.age});

  // 1. 네임드 생성자 (fromJson)
  User.fromJson(Map<String, dynamic> map)
    : this(name: map['name'], age: map['age']);

  // 2. toJson 메서드
  Map<String, dynamic> toJson() {
    return {"name": name, "age": age};
  }
}
