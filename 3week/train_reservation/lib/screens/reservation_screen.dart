import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/train.dart';
import '../models/reservation.dart';
import '../providers/train_provider.dart';

class ReservationScreen extends StatefulWidget {
  final Train? train;

  const ReservationScreen({super.key, this.train});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _numberOfSeats = 1;
  int _selectedCar = 1;
  List<int> _selectedSeats = [];
  String _selectedPaymentMethod = '신용카드';

  final List<String> _paymentMethods = ['신용카드', '무통장입금', '간편결제'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectSeats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '좌석 선택',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<int>(
                        value: _selectedCar,
                        items: List.generate(
                          8,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}호차'),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCar = value;
                              _selectedSeats = [];
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: 40,
                          itemBuilder: (context, index) {
                            final seatNumber = index + 1;
                            final isSelected = _selectedSeats.contains(
                              seatNumber,
                            );
                            return InkWell(
                              onTap:
                                  _selectedSeats.length >= _numberOfSeats &&
                                          !isSelected
                                      ? null
                                      : () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedSeats.remove(seatNumber);
                                          } else {
                                            if (_selectedSeats.length <
                                                _numberOfSeats) {
                                              _selectedSeats.add(seatNumber);
                                            }
                                          }
                                        });
                                      },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.blue
                                          : _selectedSeats.length >=
                                              _numberOfSeats
                                          ? Colors.grey.shade300
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    seatNumber.toString(),
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('선택 완료'),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final train = widget.train;
    if (train == null) {
      return const Scaffold(body: Center(child: Text('기차 정보가 없습니다.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('예매하기'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 기차 정보 카드
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${train.departureStation} → ${train.arrivalStation}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('기차번호: ${train.trainNumber}'),
                        Text(
                          '출발: ${DateFormat('HH:mm').format(train.departureTime)} - '
                          '도착: ${DateFormat('HH:mm').format(train.arrivalTime)}',
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '잔여좌석: ${train.availableSeats}석',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 예약자 정보
                const Text(
                  '예약자 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '예약자 이름',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // 예매 인원
                const Text(
                  '예매 인원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('예매 인원: '),
                    DropdownButton<int>(
                      value: _numberOfSeats,
                      items: List.generate(
                        train.availableSeats,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}명'),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _numberOfSeats = value;
                            _selectedSeats = [];
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 좌석 선택
                const Text(
                  '좌석 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectSeats,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedSeats.isEmpty
                              ? '좌석을 선택해주세요'
                              : '$_selectedCar호차 ${_selectedSeats.join(', ')}번',
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 결제 수단
                const Text(
                  '결제 수단',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _paymentMethods.map((method) {
                        final isSelected = _selectedPaymentMethod == method;
                        return ChoiceChip(
                          label: Text(method),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPaymentMethod = method;
                              });
                            }
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                // 총 금액 및 예매하기 버튼
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '총 금액',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${train.price * _numberOfSeats}원',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedSeats.length != _numberOfSeats) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('좌석을 모두 선택해주세요.')),
                              );
                              return;
                            }
                            final reservation = Reservation(
                              reservationId:
                                  DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                              trainNumber: train.trainNumber,
                              passengerName: _nameController.text,
                              passengerPhone: _phoneController.text,
                              reservationDate: DateTime.now(),
                              numberOfSeats: _numberOfSeats,
                              totalPrice: train.price * _numberOfSeats,
                              status: '예약완료',
                            );
                            context.read<TrainProvider>().addReservation(
                              reservation,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('예매하기'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
