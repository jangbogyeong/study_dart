import 'dart:io';

// 상품을 정의하는 Product 클래스
class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

// 쇼핑몰을 정의하는 ShoppingMall 클래스
class ShoppingMall {
  List<Product> productList;
  int totalPrice = 0; // 장바구니에 담긴 상품들의 총 가격

  ShoppingMall(this.productList);

  // 판매 상품 목록을 출력하는 메서드
  void showProducts() {
    for (var product in productList) {
      print('${product.name} / ${product.price}원');
    }
  }

  // 상품을 장바구니에 담는 메서드
  void addToCart() {
    stdout.write('장바구니에 담을 상품 이름을 입력하세요: ');
    String? productName = stdin.readLineSync();
    stdout.write('상품 개수를 입력하세요: ');
    String? countInput = stdin.readLineSync();

    // 입력한 상품명이 올바르지 않은 경우
    if (productName == null || productName.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    // 상품 목록에서 해당 상품 검색
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

    // 장바구니 총 가격 갱신
    totalPrice += selectedProduct.price * quantity;
    print('장바구니에 상품이 담겼어요 !');
  }

  // 장바구니에 담긴 상품들의 총 가격을 출력하는 메서드
  void showTotal() {
    print('장바구니에 ${totalPrice}원 어치를 담으셨네요 !');
  }
}

void main() {
  // 5개 이상의 상품을 생성자로 전달
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
    // 각 기능에 대한 메뉴 출력
    print('\n=== 쇼핑몰 메뉴 ===');
    print('[1] 상품 목록 보기');
    print('[2] 장바구니에 담기');
    print('[3] 장바구니에 담긴 상품의 총 가격 보기');
    print('[4] 프로그램 종료');
    stdout.write('원하는 기능의 번호를 입력하세요: ');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        print('\n판매하는 상품 목록:');
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
