class Train {
  final String trainNumber;
  final String departureStation;
  final String arrivalStation;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int availableSeats;
  final int price;

  Train({
    required this.trainNumber,
    required this.departureStation,
    required this.arrivalStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'trainNumber': trainNumber,
      'departureStation': departureStation,
      'arrivalStation': arrivalStation,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'availableSeats': availableSeats,
      'price': price,
    };
  }

  factory Train.fromMap(Map<String, dynamic> map) {
    return Train(
      trainNumber: map['trainNumber'],
      departureStation: map['departureStation'],
      arrivalStation: map['arrivalStation'],
      departureTime: DateTime.parse(map['departureTime']),
      arrivalTime: DateTime.parse(map['arrivalTime']),
      availableSeats: map['availableSeats'],
      price: map['price'],
    );
  }
}
