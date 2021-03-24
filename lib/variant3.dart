abstract class Variant3<A, B, C> {
  T map<T>(T Function(A) caseA, T Function(B) caseB, T Function(C) caseC);
}

abstract class CaseA<A, B, C> extends Variant3<A, B, C> {
  A get self;
  T map<T>(T Function(A) caseA, T Function(B) caseB, T Function(C) caseC) => caseA(self);
}

abstract class CaseB<A, B, C> extends Variant3<A, B, C> {
  B get self;
  T map<T>(T Function(A) caseA, T Function(B) caseB, T Function(C) caseC) => caseB(self);
}

abstract class CaseC<A, B, C> extends Variant3<A, B, C> {
  C get self;
  T map<T>(T Function(A) caseA, T Function(B) caseB, T Function(C) caseC) => caseC(self);
}
