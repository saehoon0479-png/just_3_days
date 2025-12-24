import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';


import '../../domain/challenge/challenge_controller.dart';
import '../widgets/jelly_tap.dart';

class S1GoalSetupScreen extends StatelessWidget {
  const S1GoalSetupScreen({super.key});

  static const _bg = Color(0xFFFFFDD0);     // 크림
  static const _primary = Color(0xFFFCE205); // 개나리
  static const _text = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChallengeController());

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('딱 3일만', style: TextStyle(color: _text, fontWeight: FontWeight.w800)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoundCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('MVP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
                  SizedBox(height: 6),
                  Text('1) 시작하기\n2) 오늘 성공\n(필요하면 초기화)',
                      style: TextStyle(color: _text, height: 1.25)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 상태 표시
            Obx(() {
              return _RoundCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('진행중: ${c.isActive.value ? "YES" : "NO"}',
                        style: const TextStyle(color: _text, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('시작일: ${c.startDate.value?.toIso8601String().split("T").first ?? "-"}',
                        style: const TextStyle(color: _text)),
                    const SizedBox(height: 4),
                    Text('성공 횟수: ${c.successDates.length}', style: const TextStyle(color: _text)),
                    const SizedBox(height: 4),
                    Text('실패 횟수: ${c.failCount.value}', style: const TextStyle(color: _text)),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // 시작하기
            _JellyButton(
              text: '시작하기',
              onTap: () async {
                await c.startChallenge();
                Get.snackbar('OK', '챌린지 시작!');
              },
            ),
            const SizedBox(height: 10),

            // 오늘 성공
            _JellyButton(
              text: '오늘 성공',
              onTap: () async {
                final ok = await c.checkTodaySuccess();
                Get.snackbar('결과', ok ? '오늘 성공 체크 ✅' : '이미 체크했거나 아직 시작 안 함 ❌');
              },
            ),
            if (kDebugMode) ...[
  const SizedBox(height: 10),
  _JellyButton(
    text: '초기화(리셋)',
    isDanger: true,
    onTap: () async {
      await c.resetAll();
      Get.snackbar('OK', '초기화 완료');
    },
  ),
],

            const Spacer(),

            _RoundCard(
              child: const Text(
                '※ 지금은 “기능 MVP” 상태야.\n'
                'UI는 동글동글 + 젤리탭으로 느낌만 살려두고,\n'
                '다음 단계에서 s2/s3 플로우로 확장하자.',
                style: TextStyle(color: _text, height: 1.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  final Widget child;
  const _RoundCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.12)),
      ),
      child: child,
    );
  }
}

class _JellyButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onTap;
  final bool isDanger;

  const _JellyButton({
    required this.text,
    required this.onTap,
    this.isDanger = false,
  });

  static const _primary = Color(0xFFFCE205);
  static const _text = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    final bg = isDanger ? Colors.white : _primary;
    final border = isDanger ? Colors.black.withOpacity(0.2) : Colors.transparent;

    return JellyTap(
      onTap: () async => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: _text,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
