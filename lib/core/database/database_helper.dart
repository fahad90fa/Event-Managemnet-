import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wedding_os.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Upgraded version for new schema
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Re-create everything for new spec
      await _createDB(db, newVersion);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    // Drop existing if any for clean slate with new spec
    await db.execute('DROP TABLE IF EXISTS guests');
    await db.execute('DROP TABLE IF EXISTS vendors');
    await db.execute('DROP TABLE IF EXISTS pending_syncs');

    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const textTypeNonNull = 'TEXT NOT NULL';
    const intType = 'INTEGER';
    const intTypeNonNull = 'INTEGER NOT NULL';
    const syncStatusType = 'TEXT DEFAULT "synced"'; // synced, pending, conflict

    // 1. Weddings
    await db.execute('''
      CREATE TABLE local_weddings (
        id $idType,
        title $textTypeNonNull,
        city_id $textType,
        date_start $textType,
        date_end $textType,
        created_at $textTypeNonNull,
        updated_at $textTypeNonNull,
        sync_status $syncStatusType,
        last_synced_at $textType
      )
    ''');

    // 2. Events
    await db.execute('''
      CREATE TABLE local_events (
        id $idType,
        wedding_project_id $textTypeNonNull,
        event_type_id $textType,
        title $textTypeNonNull,
        start_at $textType,
        end_at $textType,
        location_address $textType,
        latitude REAL,
        longitude REAL,
        sync_status $syncStatusType,
        last_synced_at $textType,
        local_changes $textType
      )
    ''');

    // 3. Guest Families
    await db.execute('''
      CREATE TABLE local_guest_families (
        id $idType,
        wedding_project_id $textTypeNonNull,
        display_name $textTypeNonNull,
        side $textType,
        primary_contact_phone $textType,
        expected_total $intTypeNonNull,
        vip $intType DEFAULT 0,
        sync_status $syncStatusType,
        last_synced_at $textType,
        local_changes $textType
      )
    ''');

    // 4. Event Guests RSVP
    await db.execute('''
      CREATE TABLE local_event_guest_families (
        id $idType,
        event_id $textTypeNonNull,
        guest_family_id $textTypeNonNull,
        invited $intType DEFAULT 1,
        rsvp_status $textType,
        rsvp_count_total $intType,
        rsvp_updated_at $textType,
        sync_status $syncStatusType,
        last_synced_at $textType
      )
    ''');

    // 5. Tasks
    await db.execute('''
      CREATE TABLE local_tasks (
        id $idType,
        wedding_project_id $textTypeNonNull,
        event_id $textType,
        title $textTypeNonNull,
        description $textType,
        status $textType,
        priority $textType,
        due_at $textType,
        assigned_to_user_id $textType,
        sync_status $syncStatusType,
        last_synced_at $textType
      )
    ''');

    // 6. Expenses
    await db.execute('''
      CREATE TABLE local_expenses (
        id $idType,
        wedding_project_id $textTypeNonNull,
        event_id $textType,
        category_id $textType,
        title $textTypeNonNull,
        total_amount REAL,
        currency $textType,
        status $textType,
        sync_status $syncStatusType,
        last_synced_at $textType
      )
    ''');

    // 7. Sync Queue
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type $textTypeNonNull,
        entity_id $textTypeNonNull,
        action $textTypeNonNull,
        payload $textType,
        created_at $textTypeNonNull,
        retry_count $intType DEFAULT 0,
        last_error $textType,
        status $textType DEFAULT "pending"
      )
    ''');

    // 8. Vendors (Cached for browsing)
    await db.execute('''
      CREATE TABLE vendors (
        id $idType,
        name $textTypeNonNull,
        category $textType,
        rating REAL,
        reviews_count $intType,
        start_price $textType,
        image_url $textType,
        is_featured $intType DEFAULT 0
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      db.close();
    }
  }
}
