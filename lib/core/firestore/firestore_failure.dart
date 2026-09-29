class FirestoreFailure implements Exception {
  const FirestoreFailure(this.message);

  final String message;
}
