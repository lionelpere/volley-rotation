import 'package:json_annotation/json_annotation.dart';

part 'volleyball_term.g.dart';

/// Represents a volleyball term with description and optional link
@JsonSerializable()
class VolleyballTerm {
  final String term;
  final String description;
  final String? link;

  const VolleyballTerm({
    required this.term,
    required this.description,
    this.link,
  });

  factory VolleyballTerm.fromJson(Map<String, dynamic> json) =>
      _$VolleyballTermFromJson(json);

  Map<String, dynamic> toJson() => _$VolleyballTermToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolleyballTerm &&
          runtimeType == other.runtimeType &&
          term == other.term &&
          description == other.description &&
          link == other.link;

  @override
  int get hashCode => term.hashCode ^ description.hashCode ^ link.hashCode;

  @override
  String toString() {
    return 'VolleyballTerm{term: $term, description: $description, link: $link}';
  }
}