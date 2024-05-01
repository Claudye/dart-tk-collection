class Operator {
  static const String equals = "=";
  static const String lessThanOrEqual = "<=";
  static const String lessThan = "<";
  static const String greaterThan = ">";
  static const String notEqual = "!=";
  static const String like = "like";

  /// Checks if the provided value is a supported operator for filtering.
  static bool isOperator(Object? operator) {
    return operator is String &&
        [
          Operator.equals,
          Operator.lessThanOrEqual,
          Operator.lessThan,
          Operator.greaterThan,
          Operator.notEqual,
          Operator.like,
        ].contains(operator);
  }
}
