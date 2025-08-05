enum Position {
  p1(1, 'P1', 'Back Right - Server'),
  p2(2, 'P2', 'Front Right'),
  p3(3, 'P3', 'Front Center'),
  p4(4, 'P4', 'Front Left'),
  p5(5, 'P5', 'Back Left'),
  p6(6, 'P6', 'Back Center');

  const Position(this.number, this.shortName, this.description);

  final int number;
  final String shortName;
  final String description;

  bool get isBackRow => [p1, p5, p6].contains(this);
  bool get isFrontRow => [p2, p3, p4].contains(this);
  bool get isServer => this == p1;

  static Position fromNumber(int number) {
    return Position.values.firstWhere((pos) => pos.number == number);
  }

  /// Rotation clockwise order based on Volleyball-Simplified logic
  static List<Position> get rotationOrder => [p1, p2, p3, p4, p5, p6];
}