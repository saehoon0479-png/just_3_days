class ChallengeState {
  final bool isChallengeActive;
  final String currentGoal;
  final String goalDuration;
  final String startDate;      // yyyy-MM-dd
  final int successCount;
  final String lastCheckDate;  // yyyy-MM-dd or ''

  const ChallengeState({
    required this.isChallengeActive,
    required this.currentGoal,
    required this.goalDuration,
    required this.startDate,
    required this.successCount,
    required this.lastCheckDate,
  });

  const ChallengeState.initial()
      : isChallengeActive = false,
        currentGoal = '',
        goalDuration = '',
        startDate = '',
        successCount = 0,
        lastCheckDate = '';

  ChallengeState copyWith({
    bool? isChallengeActive,
    String? currentGoal,
    String? goalDuration,
    String? startDate,
    int? successCount,
    String? lastCheckDate,
  }) {
    return ChallengeState(
      isChallengeActive: isChallengeActive ?? this.isChallengeActive,
      currentGoal: currentGoal ?? this.currentGoal,
      goalDuration: goalDuration ?? this.goalDuration,
      startDate: startDate ?? this.startDate,
      successCount: successCount ?? this.successCount,
      lastCheckDate: lastCheckDate ?? this.lastCheckDate,
    );
  }
}

