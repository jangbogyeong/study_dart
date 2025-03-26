import 'package:flutter/foundation.dart';

class SeatSelectionProvider with ChangeNotifier {
  final Set<String> _selectedSeats = {};

  Set<String> get selectedSeats => _selectedSeats;

  bool isSelected(String seatId) {
    return _selectedSeats.contains(seatId);
  }

  void toggleSeatSelection(String seatId) {
    if (_selectedSeats.contains(seatId)) {
      _selectedSeats.remove(seatId);
    } else {
      _selectedSeats.add(seatId);
    }
    notifyListeners();
  }
}
