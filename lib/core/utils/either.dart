class Either<L, R> {
  final L? left;
  final R? right;
  final bool isLeft;

  Either._(this.left, this.right, this.isLeft);

  factory Either.left(L value) {
    return Either._(value, null, true);
  }

  factory Either.right(R value) {
    return Either._(null, value, false);
  }

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) {
      return onLeft(left as L);
    } else {
      return onRight(right as R);
    }
  }
}