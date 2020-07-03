class FilterDto {
  final DateTime monthYear;
  int wrapperId;
  final String query;

  FilterDto(
    this.monthYear, {
    this.wrapperId,
    this.query,
  });

  FilterDto copyWith({
    DateTime monthYear,
    int wrapperId,
    String query,
  }) {
    return FilterDto(
      monthYear ?? this.monthYear,
      wrapperId: wrapperId ?? this.wrapperId,
      query: query ?? this.query,
    );
  }
}
