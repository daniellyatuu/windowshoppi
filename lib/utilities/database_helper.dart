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
  static final table_2ColumnId = 'country_id';
  static final table_2ColumnCountryId = 'id';
  static final table_2ColumnCountryName = 'name';
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
        "CREATE TABLE $table_2($table_2ColumnId INTEGER PRIMARY KEY, $table_2ColumnCountryId INTEGER NOT NULL, $table_2ColumnCountryName TEXT NOT NULL, $table_2ColumnCountryFlag TEXT NOT NULL, $table_2ColumnCountryIos2 NOT NULL, $table_2ColumnCountryLanguage TEXT NOT NULL, $table_2ColumnCountryCode TEXT NOT NULL, $table_2ColumnCountryTimezone TEXT NOT NULL)");
    batch.execute(
        "CREATE TABLE $table_1($table_1ColumnId INTEGER PRIMARY KEY, $table_1ColumnName TEXT NOT NULL, $table_1ColumnCountryId INTEGER NOT NULL, FOREIGN KEY ($table_1ColumnCountryId) REFERENCES $table_2($table_2ColumnId))");
    List<dynamic> result = await batch.commit();
  }

  /// save data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_2, row);
  }

  /// save data to user table
  Future insertUserData(Map<String, dynamic> row) async {
//    print('step 9: save userdata here');
    Database db = await instance.database;
    await db.insert(table_1, row);
  }

  /// get active country
  Future getActiveCountryFromUserTable() async {
//    print('step 5: inside db, get active id country');
    Database db = await instance.database;
    var _countryId = await db
        .rawQuery("SELECT $table_1ColumnCountryId FROM $table_1 LIMIT 1");

    if (_countryId.length != 0) {
      // select country data
      var activeCountry = await getCountry(_countryId[0]['active_country_id']);
//      print('step 7: pass to front page returned country');
      return activeCountry;
    } else {
      return null;
    }
  }

  Future getCountry(id) async {
//    print('step 6: get active country by using received id');
    Database db = await instance.database;
    var res = await db.query(table_2, where: "country_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? res.first : Null;
  }

  Future getCountry2(id) async {
//    print('step 2: get data by selected country id');
    Database db = await instance.database;
    var res = await db.query(table_2, where: "id = ?", whereArgs: [id]);
//    print('step 3: pass retrieved id to user table');

    await updateUser(res[0]['country_id']);
//    print('step 5: get saved result');
    return res.isNotEmpty ? true : Null;
  }

  Future updateUser(id) async {
//    print('step 4: update user table');
    Database db = await instance.database;
    await db.rawQuery(
        "UPDATE $table_1 SET $table_1ColumnCountryId=? WHERE $table_1ColumnName=?",
        [id, 'username']);
  }

  /// save country data and insert first country as ACTIVE COUNTRY to user table
  Future insertCountryData(row) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    row.asMap().forEach((index, value) => batch.insert(table_2, value));
    List<dynamic> result = await batch.commit();
//    print("step 5: return saved id's");
    return result;
  }

  /// get all data
  Future<List<Map<String, dynamic>>> queryAllRows() async {
//    print('step 2: get data from local db');
    Database db = await instance.database;
    return await db.query(table_2);
  }

  /// get user data
  Future<List<Map<String, dynamic>>> getUser() async {
    Database db = await instance.database;
    return await db.query(table_1);
  }

  /// clean database
  Future<void> cleanDatabase() async {
    try {
      Database db = await instance.database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(table_1);
        batch.delete(table_2);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  /// count query
  Future countCountry() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table_2'),
    );
  }
}
