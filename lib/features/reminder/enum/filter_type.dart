enum FilterType { all, active, completed }

enum PriorityFilter {
  all,
  low,
  medium,
  high,
}

extension PriorityFilterExt on PriorityFilter {
  String get name {
    switch (this) {
      case PriorityFilter.low:
        return 'low';
      case PriorityFilter.medium:
        return 'medium';
      case PriorityFilter.high:
        return 'high';
      case PriorityFilter.all:
      default:
        return 'all';
    }
  }
}
