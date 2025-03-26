class Reservation {
  final String reservationId;
  final String trainNumber;
  final String passengerName;
  final String passengerPhone;
  final DateTime reservationDate;
  final int numberOfSeats;
  final int totalPrice;
  final String status;

  Reservation({
    required this.reservationId,
    required this.trainNumber,
    required this.passengerName,
    required this.passengerPhone,
    required this.reservationDate,
    required this.numberOfSeats,
    required this.totalPrice,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'reservationId': reservationId,
      'trainNumber': trainNumber,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'reservationDate': reservationDate.toIso8601String(),
      'numberOfSeats': numberOfSeats,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      reservationId: map['reservationId'],
      trainNumber: map['trainNumber'],
      passengerName: map['passengerName'],
      passengerPhone: map['passengerPhone'],
      reservationDate: DateTime.parse(map['reservationDate']),
      numberOfSeats: map['numberOfSeats'],
      totalPrice: map['totalPrice'],
      status: map['status'],
    );
  }
}
