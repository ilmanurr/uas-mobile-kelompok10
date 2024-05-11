import 'package:drift/drift.dart';

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50).customConstraint('UNIQUE')();
  TextColumn get email => text().withLength(max: 100).customConstraint('UNIQUE')();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
