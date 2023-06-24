import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  // Retrieve the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }
  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'images.db');
   // Open the database and create it if it doesn't exist
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

 // Create the database table
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path TEXT,
        date TEXT,
        plant_name TEXT,
        accuracy REAL
      )
    ''');
  }

  // Insert an image record into the database
  Future<int> insertImage(
      String filePath, String date, String plantName, double accuracy) async {
    final db = await instance.database;
    final id = await db.insert('images', {
      'file_path': filePath,
      'date': date,
      'plant_name': plantName,
      'accuracy': accuracy,
    });
    return id;
  }
  
 // Retrieve all images from the database
  Future<List<Map<String, dynamic>>> getImages() async {
    final db = await instance.database;
    return await db.query('images');
  }
  
}
