import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  Either<L, R> onSuccess(void Function(R value) action) {
    return map((r) {
      action(r);
      return r;
    });
  }
}
