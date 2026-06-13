import 'package:drift/drift.dart';

class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text().named('file_path')();
  TextColumn get thumbnailPath => text().named('thumbnail_path').nullable()();
  IntColumn get takenAt => integer().named('taken_at').nullable()();
  TextColumn get tags => text().nullable()();
  IntColumn get albumId => integer().named('album_id').nullable().references(Albums, #id)();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get coverPhotoId => integer().named('cover_photo_id').nullable().references(Photos, #id)();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class WardrobeItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get photoPath => text().named('photo_path')();
  TextColumn get category => text()();
  TextColumn get season => text()();
  TextColumn get color => text().nullable()();
  TextColumn get style => text().nullable()();
  TextColumn get occasion => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class OutfitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get items => text()();
  TextColumn get photoPath => text().named('photo_path').nullable()();
  TextColumn get weatherSnapshot => text().named('weather_snapshot').nullable()();
  IntColumn get rating => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get date => text()();
  TextColumn get type => text()();
  TextColumn get repeatRule => text().named('repeat_rule').nullable()();
  BoolColumn get lunarFlag => boolean().named('lunar_flag').withDefault(const Constant(false))();
  IntColumn get photoId => integer().named('photo_id').nullable().references(Photos, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
}

class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().named('event_id').references(Events, #id)();
  IntColumn get advanceDays => integer().named('advance_days')();
  TextColumn get timeOfDay => text().named('time_of_day')();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}
