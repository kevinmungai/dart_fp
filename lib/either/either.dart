import 'package:dart_fp/exceptions/exceptions.dart';
import 'package:meta/meta.dart';


abstract class Either<A, B> {
  Z iSwitch<Z> ({
    @required Z Function(A a) left,
    @required Z Function(B b) right,
  });

  bool get isRight;
  bool get isLeft;

  LeftProjection<A, B> get left => LeftProjection(this);
  RightProjection<A, B> get right => RightProjection(this);
}

class Left<A, B> extends Either<A, B> {
  final A _a;
  A get value => _a;
  Left(this._a);

  @override
  bool operator ==(other) {
    return identical(this, other) ||
     other is Left &&
     runtimeType == other.runtimeType &&
     _a == other._a;
  }

  @override
  int get hashCode => _a.hashCode;

  @override
  Z iSwitch<Z>({Z Function(A a) left, Z Function(B b) right}) {
    assert(left != null, "left should not be null");
    assert(right != null, "right should not be null");
    return left(_a);
  }

  @override
  bool get isLeft => this is Left;

  @override
  bool get isRight => this is Right;
}

class LeftProjection<A, B> {
  final Either<A, B> _either;
  LeftProjection(this._either);

  Either<Z, X> bind<Z, X> (Either<Z, X> Function (A) func) {
    return _either.iSwitch(
        left: (A a) => func(this._value),
        right: (_) => Right<Z, X>((_either as Right)._b),
    );
  }

  Either<Z, X> map<Z, X>(Z Function(A) func) {
    return _either.iSwitch(
      left: (_) => Left<Z, X>(func(this._value)),
      right: (_) => Right<Z, X>((_either as Right)._b),
    );
  }

  A get _value => _either.isLeft
      ? (_either as Left<A, B>)._a
      : throw LeftProjectionException("Either.left.value on Right");

}

class Right<A, B> extends Either<A, B> {
  final B _b;
  B get value => _b;

  Right(this._b);

  @override
  bool operator ==(other) {
   return identical(this, other) ||
    other is Right &&
    runtimeType == other.runtimeType &&
    _b == other._b;
  }

  @override
  int get hashCode => _b.hashCode;

  @override
  Z iSwitch<Z>({Z Function(A a) left, Z Function(B b) right}) {
    assert(left != null, "left should not be null");
    assert(right != null, "right should not be null");
    return right(_b);
  }

  @override
  bool get isLeft => this is Left;

  @override
  bool get isRight => this is Right;
}

class RightProjection<A, B> {
  final Either<A, B> _either;
  RightProjection(this._either);

  Either<Z, X> bind<Z, X> (Either<Z, X> Function(B) func) {
    return _either.iSwitch(
        left: (_) => Left<Z, X>((_either as Left)._a),
        right: (_) => func(this._value),
    );
  }

  Either<Z, X> map<Z, X>(X Function (B) func) {
    return _either.iSwitch(
      left: (_) => Left<Z, X>((_either as Left)._a),
      right: (_) => Right<Z, X>(func(this._value)),
    );
  }

  B get _value => _either.isRight
      ? (_either as Right)._b
      : throw RightProjectionException("Either.right.value noSuchElement");
}