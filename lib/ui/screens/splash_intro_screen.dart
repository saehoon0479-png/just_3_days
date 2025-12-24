import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 's1_goal_setup_screen.dart';

class SplashIntroScreen extends StatefulWidget {
  const SplashIntroScreen({super.key});

  @override
  State<SplashIntroScreen> createState() => _SplashIntroScreenState();
}

class _SplashIntroScreenState extends State<SplashIntroScreen>
    with SingleTickerProviderStateMixin {
  // 컬러
  static const _bg = Color(0xFFFFFDD0);
  static const _primary = Color(0xFFFCE205);
  static const _text = Color(0xFF333333);

  late final AnimationController _ctrl;
  Timer? _toNext;

  // 한 글자씩 떨어질 문자열
  final List<String> _chars = '딱 3일만!!'.split('');

  @override
  void initState() {
    super.initState();

    // 전체 인트로 타임라인 (글자 낙하+흔들 포함)
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    // 인트로 총 길이(조금 더 길게) 후 다음 화면
    _toNext = Timer(const Duration(milliseconds: 3800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (_, __, ___) => const S1GoalSetupScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _toNext?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  // 0~1 구간에서 부드럽게 보간
  double _clamp01(double x) => x < 0 ? 0 : (x > 1 ? 1 : x);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value; // 0..1

          // 배경 어둡게: 초반에 올라와서 유지
          final dim = Curves.easeOut.transform(_clamp01((t - 0.02) / 0.10)) * 0.48;

          // 전체 페이드 인
          final alpha = Curves.easeOut.transform(_clamp01((t - 0.02) / 0.10));

          return Stack(
            fit: StackFit.expand,
            children: [
              // 어두워지는 오버레이
              Opacity(
                opacity: dim,
                child: Container(color: Colors.black),
              ),

              // 중앙 컨텐츠
              Center(
                child: Opacity(
                  opacity: alpha,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 동글 배지
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.black.withOpacity(0.12)),
                        ),
                        child: const Text(
                          '3일 챌린지',
                          style: TextStyle(
                            color: _text,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ✅ 한 글자씩 낙하 + 좌우 띠용
                      _ComicDropTitle(chars: _chars, t: t),

                      const SizedBox(height: 10),

                      Text(
                        '가볍게 시작하고, 바로 해내자',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ComicDropTitle extends StatelessWidget {
  final List<String> chars;
  final double t; // 0..1 (전체 타임라인)

  const _ComicDropTitle({
    required this.chars,
    required this.t,
  });

  double _clamp01(double x) => x < 0 ? 0 : (x > 1 ? 1 : x);

  @override
  Widget build(BuildContext context) {
    // 글자 사이 간격(공백 처리 포함)
    const baseStyle = TextStyle(
      fontSize: 38,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      letterSpacing: -0.5,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(chars.length, (i) {
        final ch = chars[i];

        // 글자별 시작 딜레이 (한 글자씩 떨어지는 느낌)
        // 값 작을수록 더 빠르게 연속됨
        final start = 0.10 + i * 0.06;      // 각 글자 시작
        final dropEnd = start + 0.22;       // 낙하가 끝나는 시점
        final wiggleEnd = dropEnd + 0.35;   // 착지 후 흔들림 끝

        // 낙하 진행도(0..1)
        final dropP = _clamp01((t - start) / (dropEnd - start));
        final dropCurve = Curves.bounceOut.transform(dropP);

        // y: 위에서 아래로 떨어짐 (픽셀)
        // 시작 -70px에서 0으로
        final y = (1.0 - dropCurve) * -70;

        // 착지 후 좌우 흔들림(만화 띠용)
        final wiggleP = _clamp01((t - dropEnd) / (wiggleEnd - dropEnd));
        // 흔들림 감쇠(처음 크고 점점 작게)
        final amp = (1.0 - wiggleP) * 0.16; // 라디안(약 9도 정도에서 시작)
        // 흔들림 빈도(횟수)
        final shake = math.sin(wiggleP * math.pi * 6.0);

        // 회전 + 살짝 좌우 이동 같이 주면 "만화" 느낌 더 남
        final rot = amp * shake;
        final x = (amp * 22) * shake; // 좌우 0~몇 px

        // 글자가 “떨어지기 전”에는 살짝 투명하게
        final appear = Curves.easeOut.transform(_clamp01((t - start) / 0.06));

        // 공백은 흔들지 않고 간격만
        if (ch.trim().isEmpty) {
          return const SizedBox(width: 10);
        }

        return Opacity(
          opacity: appear,
          child: Transform.translate(
            offset: Offset(x, y),
            child: Transform.rotate(
              angle: rot,
              child: Text(ch, style: baseStyle),
            ),
          ),
        );
      }),
    );
  }
}
