import 'package:json_annotation/json_annotation.dart';
import 'volleyball_term.dart';

part 'content_section.g.dart';

/// Represents a content section with title and list of terms
@JsonSerializable()
class ContentSection {
  final String title;
  final List<VolleyballTerm> terms;

  const ContentSection({
    required this.title,
    required this.terms,
  });

  factory ContentSection.fromJson(Map<String, dynamic> json) =>
      _$ContentSectionFromJson(json);

  Map<String, dynamic> toJson() => _$ContentSectionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentSection &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          _listEquals(terms, other.terms);

  @override
  int get hashCode => title.hashCode ^ terms.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'ContentSection{title: $title, terms: $terms}';
  }
}