import 'package:isar/isar.dart';

abstract class DataBase<T> {
  final Isar isar;
  IsarCollection<T> get collection => isar.collection<T>();

  DataBase(this.isar);

  Future<List<T>> getAll() async => collection.where().findAll();

  Future<int> add(T value) => isar.writeTxn(() async => collection.put(value));

  Future<bool> delete(int id) =>
      isar.writeTxn(() async => collection.delete(id));

  Future<void> clearAll() => isar.writeTxn(isar.clear);
}
