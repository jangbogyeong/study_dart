import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/train_provider.dart';
import '../models/reservation.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  final _phoneController = TextEditingController();
  final _reservationIdController = TextEditingController();
  List<Reservation> _reservations = [];
  String _searchType = '전화번호';

  @override
  void dispose() {
    _phoneController.dispose();
    _reservationIdController.dispose();
    super.dispose();
  }

  void _searchReservations() async {
    if (_searchType == '전화번호' && _phoneController.text.isNotEmpty) {
      final reservations = await context
          .read<TrainProvider>()
          .getReservationsByPhone(_phoneController.text);
      if (mounted) {
        setState(() {
          _reservations = reservations;
        });
      }
    } else if (_searchType == '예매번호' &&
        _reservationIdController.text.isNotEmpty) {
      final reservations = await context
          .read<TrainProvider>()
          .getReservationsById(_reservationIdController.text);
      if (mounted) {
        setState(() {
          _reservations = reservations;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예매 내역'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 검색 섹션
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('검색 유형: '),
                    DropdownButton<String>(
                      value: _searchType,
                      items: const [
                        DropdownMenuItem(value: '전화번호', child: Text('전화번호')),
                        DropdownMenuItem(value: '예매번호', child: Text('예매번호')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _searchType = value;
                            _phoneController.clear();
                            _reservationIdController.clear();
                            _reservations = [];
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            _searchType == '전화번호'
                                ? _phoneController
                                : _reservationIdController,
                        decoration: InputDecoration(
                          labelText:
                              _searchType == '전화번호' ? '예매 시 입력한 전화번호' : '예매번호',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchReservations,
                          ),
                        ),
                        keyboardType:
                            _searchType == '전화번호'
                                ? TextInputType.phone
                                : TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 예매 내역 목록
          Expanded(
            child:
                _reservations.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '예매 내역이 없습니다.\n$_searchType를 입력하여 조회해주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = _reservations[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '예매번호: ${reservation.reservationId}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            reservation.status == '예약완료'
                                                ? Colors.green.shade50
                                                : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        reservation.status,
                                        style: TextStyle(
                                          color:
                                              reservation.status == '예약완료'
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text('기차번호: ${reservation.trainNumber}'),
                                Text('예매자: ${reservation.passengerName}'),
                                Text('인원: ${reservation.numberOfSeats}명'),
                                Text(
                                  '금액: ${reservation.totalPrice}원',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  '예매일: ${DateFormat('yyyy-MM-dd HH:mm').format(reservation.reservationDate)}',
                                ),
                                if (reservation.status == '예약완료') ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('예매 취소'),
                                                content: const Text(
                                                  '예매를 취소하시겠습니까?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('아니오'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await context
                                                          .read<TrainProvider>()
                                                          .updateReservationStatus(
                                                            reservation
                                                                .reservationId,
                                                            '취소됨',
                                                          );
                                                      if (mounted) {
                                                        _searchReservations();
                                                      }
                                                    },
                                                    child: const Text('예'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('예매 취소'),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
