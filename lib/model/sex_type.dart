enum SexType {
  NONE,
  PROTECTED,
  UNPROTECTED;

  String toDisplayString() {
    switch (this) {
      case SexType.NONE:
        return "No";
      case SexType.PROTECTED:
        return "Yes (protected)";
      case SexType.UNPROTECTED:
        return "Yes (unprotected)";
    }
  }
}
