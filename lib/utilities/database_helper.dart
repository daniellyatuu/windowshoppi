import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = 'windowshoppi.db';
  static final _databaseVersion = 1;

  /// user table
  static final table_1 = 'user';
  static final table_1ColumnId = 'id';
  static final table_1ColumnName = 'name';
  static final table_1ColumnCountryId = 'active_country_id';

  /// country table
  static final table_2 = 'country';
  static final table_2ColumnId = 'id';
  static final table_2ColumnCountryId = 'country_id';
  static final table_2ColumnCountryName = 'country_name';
  static final table_2ColumnCountryFlag = 'flag';
  static final table_2ColumnCountryIos2 = 'ios2';
  static final table_2ColumnCountryLanguage = 'language';
  static final table_2ColumnCountryCode = 'country_code';
  static final table_2ColumnCountryTimezone = 'timezone';

  /// singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    // drop first
    batch.execute("DROP TABLE IF EXISTS $table_1 ;");
    batch.execute("DROP TABLE IF EXISTS $table_2 ;");

    // then create again
    batch.execute(
        "CREATE TABLE $table_1($table_1ColumnId INTEGER PRIMARY KEY, $table_1ColumnName TEXT NOT NULL, $table_1ColumnCountryId INTEGER NOT NULL)");
    batch.execute(
        "CREATE TABLE $table_2($table_2ColumnId INTEGER PRIMARY KEY, $table_2ColumnCountryId INTEGER NOT NULL, $table_2ColumnCountryName TEXT NOT NULL, $table_2ColumnCountryFlag TEXT NOT NULL, $table_2ColumnCountryIos2 NOT NULL, $table_2ColumnCountryLanguage TEXT NOT NULL, $table_2ColumnCountryCode TEXT NOT NULL, $table_2ColumnCountryTimezone TEXT NOT NULL)");
    List<dynamic> result = await batch.commit();
    print(result);
//    await db.execute('''
//    CREATE TABLE $table_1(
//    $table_1ColumnId INTEGER PRIMARY KEY,
//    $table_1ColumnName TEXT NOT NULL,
//    $table_1ColumnAge INTEGER NOT NULL,
//    )
//    ''');
  }

  /// save data
  Future<int> insert(Map<String, dynamic> row) async {
    print('save data');
    Database db = await instance.database;
    return await db.insert(table_2, row);
  }

  /// get all data
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    print('get all data');
    Database db = await instance.database;
    return await db.query(table_2);
  }
}
