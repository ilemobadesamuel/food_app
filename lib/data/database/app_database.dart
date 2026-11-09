import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();
}

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  TextColumn get ingredients => text()();

  TextColumn get instructions => text()();

  TextColumn get creatorName => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Users, Recipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'food_app_database'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(users);
        await m.addColumn(recipes, recipes.creatorName);
      }
    },
  );
}
