// 1. 관리해야될 상태 클래스 만들기
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/user.dart';

class HomeState {
  User? user;
  HomeState(this.user);
}

// 2. 뷰모델 만들기. Notifier


class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState(
      user: null, // 초기 상태 null
      fetchTime: null,
    );
  }


// 3. 뷰모델을 위젯에게 공급해줄 관리자 만들기
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
