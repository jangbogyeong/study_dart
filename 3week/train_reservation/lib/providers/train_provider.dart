import 'package:flutter/foundation.dart';
import '../models/train.dart';
import '../models/reservation.dart';
import '../services/database_service.dart';

class TrainProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Train> _trains = [];
  List<Reservation> _reservations = [];
  List<Train> _searchResults = [];

  List<Train> get trains => _trains;
  List<Reservation> get reservations => _reservations;
  List<Train> get searchResults => _searchResults;
  List<Reservation> get recentReservations => _reservations.take(5).toList();

  TrainProvider() {
    _initSampleData();
  }

  Future<void> _initSampleData() async {
    // 기존 데이터가 있는지 확인
    final existingTrains = await _databaseService.getTrains();
    if (existingTrains.isNotEmpty) {
      _trains = existingTrains;
      notifyListeners();
      return;
    }

    final sampleTrains = [
      Train(
        trainNumber: 'KTX001',
        departureStation: '서울',
        arrivalStation: '부산',
        departureTime: DateTime.now().add(const Duration(hours: 1)),
        arrivalTime: DateTime.now().add(const Duration(hours: 4)),
        availableSeats: 40,
        price: 59000,
      ),
      Train(
        trainNumber: 'KTX002',
        departureStation: '서울',
        arrivalStation: '대전',
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
        availableSeats: 30,
        price: 35000,
      ),
      Train(
        trainNumber: 'KTX003',
        departureStation: '부산',
        arrivalStation: '서울',
        departureTime: DateTime.now().add(const Duration(hours: 3)),
        arrivalTime: DateTime.now().add(const Duration(hours: 6)),
        availableSeats: 35,
        price: 59000,
      ),
    ];

    for (final train in sampleTrains) {
      await _databaseService.insertTrain(train);
    }
    await loadTrains();
  }

  Future<void> loadTrains() async {
    _trains = await _databaseService.getTrains();
    notifyListeners();
  }

  Future<void> loadReservations() async {
    _reservations = await _databaseService.getReservations();
    notifyListeners();
  }

  Future<void> searchTrains(
    String departure,
    String arrival,
    DateTime date,
  ) async {
    _searchResults = await _databaseService.searchTrains(
      departure,
      arrival,
      date,
    );
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    await _databaseService.insertReservation(reservation);
    await loadReservations();
  }

  Future<void> updateReservationStatus(
    String reservationId,
    String status,
  ) async {
    await _databaseService.updateReservationStatus(reservationId, status);
    await loadReservations();
  }

  Future<void> deleteReservation(String reservationId) async {
    await _databaseService.deleteReservation(reservationId);
    await loadReservations();
  }

  Future<List<Reservation>> getReservationsByPhone(String phone) async {
    return await _databaseService.getReservationsByPhone(phone);
  }

  Future<List<Reservation>> getReservationsById(String reservationId) async {
    // 실제로는 API 호출을 통해 예매 내역을 가져와야 합니다.
    // 현재는 메모리에서 필터링하여 반환합니다.
    return _reservations
        .where((reservation) => reservation.reservationId == reservationId)
        .toList();
  }
}
