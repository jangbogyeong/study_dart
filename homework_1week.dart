import 'dart:io';

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

class ShoppingMall {
  List<Product> productList;
  int totalPrice = 0; 

  ShoppingMall(this.productList);

  void showProducts() {
    for (var product in productList) {
      print('${product.name} / ${product.price}원');
    }
  }

  void addToCart() {
    stdout.write('상품 이름을 입력해 주세요!');
    String? productName = stdin.readLineSync();
    stdout.write('상품 개수를 입력해 주세요!');
    String? countInput = stdin.readLineSync();

    if (productName == null || productName.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    Product? selectedProduct;
    for (var product in productList) {
      if (product.name == productName) {
        selectedProduct = product;
        break;
      }
    }
    if (selectedProduct == null) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    int quantity = 0;
    try {
      quantity = int.parse(countInput!);
    } catch (e) {
      print('입력값이 올바르지 않아요 !');
      return;
    }
    if (quantity <= 0) {
      print('0개보다 많은 개수의 상품만 담을 수 있어요 !');
      return;
    }

    totalPrice += selectedProduct.price * quantity;
    print('장바구니에 상품이 담겼어요 !');
  }

  void showTotal() {
    print('장바구니에 ${totalPrice}원 어치를 담으셨네요 !');
  }
}

void main() {
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];

  ShoppingMall mall = ShoppingMall(products);
  bool running = true;

  while (running) {
    
    print('\n----------------------------------------------------------------------------------------------');
    print('[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    print('\n----------------------------------------------------------------------------------------------');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        mall.showProducts();
        break;
      case '2':
        mall.addToCart();
        break;
      case '3':
        mall.showTotal();
        break;
      case '4':
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요 !');
        running = false;
        break;
      default:
        print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
    }
  }
}
