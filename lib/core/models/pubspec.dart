import 'package:freezed_annotation/freezed_annotation.dart';

part 'pubspec.freezed.dart';
part 'pubspec.g.dart';

@freezed
abstract class Pubspec with _$Pubspec {
  const factory Pubspec({
    required String name,
    required String version,
    required String description,
    String? homepage,
    String? repository,
    @JsonKey(name: 'issue_tracker') String? issueTracker,
    List<String>? topics,
    Map<String, String>? environment,
    Map<String, dynamic>? dependencies,
    @JsonKey(name: 'dev_dependencies')
    Map<String, dynamic>? devDependencies,
  }) = _Pubspec;

  factory Pubspec.fromJson(Map<String, dynamic> json) =>
      _$PubspecFromJson(json);
}
