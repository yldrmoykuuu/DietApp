enum TurkishMonth {
  Ocak("1"),
  Subat("2"),
  Mart("3"),
  Nisan("4"),
  Mayis("5"),
  Haziran("6"),
  Temmuz("7"),
  Agustos("8"),
  Eylul("9"),
  Ekim("10"),
  Kasim("11"),
  Aralik("12");

  final String displayName;

  const TurkishMonth(this.displayName);

  static TurkishMonth fromMonthInt(int month) {
    if (month < 1 || month > 12) {

      return TurkishMonth.values[DateTime.now().month - 1];
    }
    return TurkishMonth.values[month - 1];
  }
}