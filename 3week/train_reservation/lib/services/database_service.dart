import 'package:sqflite/sqflite.dart';
import '../models/train.dart';
import '../models/reservation.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trains(
        trainNumber TEXT PRIMARY KEY,
        departureStation TEXT NOT NULL,
        arrivalStation TEXT NOT NULL,
        departureTime TEXT NOT NULL,
        arrivalTime TEXT NOT NULL,
        availableSeats INTEGER NOT NULL,
        price INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reservations(
        reservationId TEXT PRIMARY KEY,
        trainNumber TEXT NOT NULL,
        passengerName TEXT NOT NULL,
        passengerPhone TEXT NOT NULL,
        reservationDate TEXT NOT NULL,
        numberOfSeats INTEGER NOT NULL,
        totalPrice INTEGER NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (trainNumber) REFERENCES trains (trainNumber)
      )
    ''');
  }

  // Train 관련 메서드
  Future<int> insertTrain(Train train) async {
    final db = await database;
    return await db.insert('trains', train.toMap());
  }

  Future<List<Train>> getTrains() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trains');
    return List.generate(maps.length, (i) => Train.fromMap(maps[i]));
  }

  Future<List<Train>> searchTrains(
    String departure,
    String arrival,
    DateTime date,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trains',
      where:
          'departureStation = ? AND arrivalStation = ? AND date(departureTime) = ?',
      whereArgs: [departure, arrival, date.toIso8601String().split('T')[0]],
    );
    return List.generate(maps.length, (i) => Train.fromMap(maps[i]));
  }

  // Reservation 관련 메서드
  Future<int> insertReservation(Reservation reservation) async {
    final db = await database;
    return await db.insert('reservations', reservation.toMap());
  }

  Future<List<Reservation>> getReservations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reservations');
    return List.generate(maps.length, (i) => Reservation.fromMap(maps[i]));
  }

  Future<List<Reservation>> getReservationsByPhone(String phone) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reservations',
      where: 'passengerPhone = ?',
      whereArgs: [phone],
    );
    return List.generate(maps.length, (i) => Reservation.fromMap(maps[i]));
  }

  Future<int> updateReservationStatus(
    String reservationId,
    String status,
  ) async {
    final db = await database;
    return await db.update(
      'reservations',
      {'status': status},
      where: 'reservationId = ?',
      whereArgs: [reservationId],
    );
  }

  Future<int> deleteReservation(String reservationId) async {
    final db = await database;
    return await db.delete(
      'reservations',
      where: 'reservationId = ?',
      whereArgs: [reservationId],
    );
  }
}
