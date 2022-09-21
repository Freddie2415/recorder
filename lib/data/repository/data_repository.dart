abstract class Specification<T> {
  Future put(T item);

  Future<List<T>> get();

  Future delete(id);

  Future update(id, T item);

  Future<void> deleteAll();
}
