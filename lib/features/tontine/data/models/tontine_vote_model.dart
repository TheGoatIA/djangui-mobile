import 'package:equatable/equatable.dart';

/// Option d'un vote de tontine (texte + nombre de voix).
class TontineVoteOption extends Equatable {
  final String text;
  final int count;

  const TontineVoteOption({required this.text, required this.count});

  factory TontineVoteOption.fromJson(Map<String, dynamic> json) =>
      TontineVoteOption(
        text: (json['text'] ?? '').toString(),
        count: (json['count'] is num) ? (json['count'] as num).toInt() : 0,
      );

  @override
  List<Object?> get props => [text, count];
}

/// Vote de gouvernance d'une tontine.
///
/// `kind == 'closure'` : vote de CLÔTURE d'une tontine en cours. Le créateur ne
/// peut plus clôturer seul une tontine active (arnaque classique : toucher sa
/// cagnotte puis tout arrêter) ; la majorité absolue des membres décide.
/// Option 0 = clôturer, option 1 = continuer.
class TontineVoteModel extends Equatable {
  final String id;
  final String kind;
  final String question;
  final List<TontineVoteOption> options;
  final DateTime? expiresAt;
  final String status; // open | closed
  final String? outcome; // approved | rejected
  final bool hasVoted;
  final int votersCount;

  /// Voix nécessaires (majorité absolue des membres acceptés), 0 si inconnue.
  final int majority;

  const TontineVoteModel({
    required this.id,
    required this.kind,
    required this.question,
    required this.options,
    required this.expiresAt,
    required this.status,
    required this.outcome,
    required this.hasVoted,
    this.votersCount = 0,
    this.majority = 0,
  });

  bool get isClosure => kind == 'closure';
  int get yesCount => options.isNotEmpty ? options[0].count : 0;
  int get noCount => options.length > 1 ? options[1].count : 0;
  bool get isOpen =>
      status == 'open' &&
      (expiresAt == null || expiresAt!.isAfter(DateTime.now()));

  /// Lecture défensive : un vote mal formé ne doit jamais faire planter l'écran.
  factory TontineVoteModel.fromJson(
    Map<String, dynamic> json,
  ) => TontineVoteModel(
    id: (json['_id'] ?? json['id'] ?? '').toString(),
    kind: (json['kind'] ?? 'general').toString(),
    question: (json['question'] ?? '').toString(),
    options: (json['options'] is List)
        ? (json['options'] as List)
              .whereType<Map>()
              .map(
                (o) => TontineVoteOption.fromJson(Map<String, dynamic>.from(o)),
              )
              .toList()
        : const [],
    expiresAt: DateTime.tryParse((json['expiresAt'] ?? '').toString()),
    status: (json['status'] ?? 'open').toString(),
    outcome: json['outcome']?.toString(),
    hasVoted: json['hasVoted'] == true,
    votersCount: (json['votersCount'] is num)
        ? (json['votersCount'] as num).toInt()
        : 0,
    majority: (json['majority'] is num) ? (json['majority'] as num).toInt() : 0,
  );

  @override
  List<Object?> get props => [
    id,
    kind,
    question,
    options,
    expiresAt,
    status,
    outcome,
    hasVoted,
    votersCount,
    majority,
  ];
}
