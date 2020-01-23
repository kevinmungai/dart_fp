
import 'dart:math';

import 'package:dart_fp/either/either.dart';
import 'package:dart_fp/exceptions/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("creating a left and matching on it", () {
    final either = Left(1);
    final message = either.iSwitch(
      left: (val) => val.toString(),
      right: (val) => val.toString(),
    );
    expect(message, "1");
    expect(message is String, true);
  });

  test("creating a right and matching on it", () {
    final result = Right(1);
    final message = result.iSwitch(
        left: (val) {
          print(val);
          return "some string";
        },
        right: (val) {
          print("right: ${val + 1}");
          return val + 1;
        }
    );
    expect(message, 2);
  });

  test("are the types equal", () {
    final right = Right(1);
    final rightTwo = Right(1);
    final left = Left("two");
    final leftTwo = Left("two");

    expect(right, rightTwo);
    expect(left, leftTwo);
  });

  test("testing isRight", () {
    final right = Right(1);

    expect(right.isRight, true);
    expect(right.isLeft, false);
  });

  test("testing isLeft", () {
    final left =Left("left");

    expect(left.isLeft, true);
    expect(left.isRight, false);
  });

  test("testing left projection getter", () {
    final left = Left("left");
    final leftProjection = left.left;

    expect(leftProjection is LeftProjection, true);
    expect(leftProjection is RightProjection, false);
  });

  test("testing right projection getter", () {
    final right = Right("right");
    final rightProjection = right.right;

    expect(rightProjection is RightProjection, true);
    expect(rightProjection is LeftProjection, false);
  });

  test("testing rightProjection bind", () {
    Either<String, double> safeDiv (int a, int b) {
      return b == 0 ? Left("no zeros please") : Right(a / b);
    }

    Either<String, double> addByTen(double a) {
      return Right(a + 10);
    }

    expect(safeDiv(10, 0), Left<String, double>("no zeros please"));
    expect(addByTen(20.00), Right<String, double>(20.00 + 10));
    expect(safeDiv(10, 20).right.bind(addByTen), Right<String, double>((10 / 20) + 10));
    expect(safeDiv(10, 0).right.bind(addByTen), Left<String, double>("no zeros please"));

  });
}