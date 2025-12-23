import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChallengeController extends GetxController {
  final _box = GetStorage();

  // --- storage keys ---
  static const _kIsActive = 'challenge_is_active';
  static const _kStartDate = 'challenge_start_date'; // "yyyy-MM-dd"
  static const _kSuccessDates = 'challenge_success_dates'; // List<String>
  static const _kFailCount = 'challenge_fail_count';

  // --- reactive state ---
  final isActive = false.obs;
  final startDate = Rxn<DateTime>();
  final successDates = <String>{}.obs; // store as yyyy-MM-dd
  final failCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // ----------------------------
  // helpers
  // ----------------------------
  String _fmtDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  DateTime _parseDate(String s) {
    final parts = s.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _loadFromStorage() {
    isActive.value = _box.read(_kIsActive) ?? false;

    final sd = _box.read(_kStartDate);
    if (sd is String && sd.isNotEmpty) {
      startDate.value = _parseDate(sd);
    } else {
      startDate.value = null;
    }

    final list = _box.read(_kSuccessDates);
    if (list is List) {
      successDates.value = list.map((e) => e.toString()).toSet();
    } else {
      successDates.clear();
    }

    failCount.value = _box.read(_kFailCount) ?? 0;
  }

  Future<void> _persistAll() async {
    await _box.write(_kIsActive, isActive.value);
    await _box.write(_kStartDate, startDate.value == null ? '' : _fmtDate(startDate.value!));
    await _box.write(_kSuccessDates, successDates.toList());
    await _box.write(_kFailCount, failCount.value);
  }

  // =========================================================
  // 1) startChallenge
  // - 새 챌린지 시작(기존 진행 중이면 초기화 후 시작하거나 막기)
  // =========================================================
  Future<void> startChallenge() async {
    // 이미 활성화면 그냥 리턴(원하면 reset 후 시작으로 바꿔도 됨)
    if (isActive.value) return;

    final t = _today();
    isActive.value = true;
    startDate.value = t;
    successDates.clear();
    failCount.value = 0;

    await _persistAll();
  }

  // =========================================================
  // 2) checkTodaySuccess
  // - 오늘 성공 처리(하루 1번만)
  // - 활성화 안 돼 있으면 false
  // =========================================================
  Future<bool> checkTodaySuccess() async {
    if (!isActive.value || startDate.value == null) return false;

    final todayKey = _fmtDate(_today());

    // 이미 오늘 성공 체크했으면 false(중복 방지)
    if (successDates.contains(todayKey)) return false;

    successDates.add(todayKey);
    await _persistAll();
    return true;
  }

  // =========================================================
  // 3) failChallenge
  // - 챌린지 실패 처리(즉시 종료)
  // - 실패횟수 올리고 비활성화
  // =========================================================
  Future<void> failChallenge() async {
    if (!isActive.value) return;

    failCount.value = failCount.value + 1;
    isActive.value = false;

    await _persistAll();
  }

  // =========================================================
  // 4) resetAll
  // - 모든 데이터 완전 초기화
  // =========================================================
  Future<void> resetAll() async {
    isActive.value = false;
    startDate.value = null;
    successDates.clear();
    failCount.value = 0;

    await _box.remove(_kIsActive);
    await _box.remove(_kStartDate);
    await _box.remove(_kSuccessDates);
    await _box.remove(_kFailCount);
  }
}
