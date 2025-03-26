import 'package:flutter/material.dart';
import 'station_list_screen.dart';
import 'seat_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedOrigin;
  String? selectedDestination;

  void _selectStation(bool isOrigin) async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                StationListScreen(title: isOrigin ? '출발역 선택' : '도착역 선택'),
      ),
    );

    if (selected != null) {
      setState(() {
        if (isOrigin) {
          selectedOrigin = selected;
        } else {
          selectedDestination = selected;
        }
      });
    }
  }

  void _showSameStationWarning() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('지역 선택 오류'),
            content: const Text('출발역과 도착역이 같습니다. 다른 지역을 선택해주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  void _navigateToSeatSelection() async {
    if (selectedOrigin == selectedDestination) {
      _showSameStationWarning();
      return;
    }

    // 좌석 선택 화면으로 이동하고 결과(예매 완료 여부) 받기
    final bookingCompleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder:
            (context) => SeatSelectionScreen(
              origin: selectedOrigin!,
              destination: selectedDestination!,
            ),
      ),
    );

    // 예매 완료된 경우에만 출발지/도착지 초기화
    if (bookingCompleted == true) {
      setState(() {
        selectedOrigin = null;
        selectedDestination = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '기차 예매',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 출발역/도착역 선택 카드
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(
                        Colors.black.r.toInt(),
                        Colors.black.g.toInt(),
                        Colors.black.b.toInt(),
                        0.128,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStation(true),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '출발역',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedOrigin ?? '선택',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: 1,
                          height: 48,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectStation(false),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '도착역',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedDestination ?? '선택',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 좌석 선택 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      selectedOrigin != null && selectedDestination != null
                          ? _navigateToSeatSelection
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '좌석 선택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
