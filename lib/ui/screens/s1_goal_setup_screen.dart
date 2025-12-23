import 'package:flutter/material.dart';
import '../../core/spec_constants.dart';
import '../../core/spec_copy.dart';
import '../../domain/challenge/challenge_controller.dart';
import '../widgets/jelly_tap.dart';

class S1GoalSetupScreen extends StatefulWidget {
  final ChallengeController controller;
  const S1GoalSetupScreen({super.key, required this.controller});

  @override
  State<S1GoalSetupScreen> createState() => _S1GoalSetupScreenState();
}

class _S1GoalSetupScreenState extends State<S1GoalSetupScreen> {
  final _goalCtrl = TextEditingController();
  String _durationText = Copy.t10;

  @override
  void dispose() {
    _goalCtrl.dispose();
    super.dispose();
  }

  void _setTemplate(String goal) {
    setState(() => _goalCtrl.text = goal);
  }

  Future<void> _start() async {
    final goal = _goalCtrl.text.trim();
    if (goal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표를 입력해줘')),
      );
      return;
    }

    // 지금 단계: 저장까지만 하고 다음 단계(S2) 연결은 다음 턴에서 추가
    await widget.controller.startChallenge(goal: goal, durationText: _durationText);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장 완료 ✅ 다음 단계에서 S2로 연결할게')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpecConst.pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Copy.s1Header, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 14),

              // 템플릿 버튼(물/책/운동)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Chip(text: Copy.templateWater, onTap: () => _setTemplate(Copy.templateWater)),
                  _Chip(text: Copy.templateBook, onTap: () => _setTemplate(Copy.templateBook)),
                  _Chip(text: Copy.templateWorkout, onTap: () => _setTemplate(Copy.templateWorkout)),
                ],
              ),

              const SizedBox(height: 14),

              // 입력 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SpecConst.pad),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SpecConst.radius),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _goalCtrl,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: const InputDecoration(
                        hintText: Copy.hintGoal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Copy.intensityLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: [
                        _DurationChoice(
                          text: Copy.t10,
                          selected: _durationText == Copy.t10,
                          onTap: () => setState(() => _durationText = Copy.t10),
                        ),
                        _DurationChoice(
                          text: Copy.t30,
                          selected: _durationText == Copy.t30,
                          onTap: () => setState(() => _durationText = Copy.t30),
                        ),
                        _DurationChoice(
                          text: Copy.t60,
                          selected: _durationText == Copy.t60,
                          onTap: () => setState(() => _durationText = Copy.t60),
                        ),
                        _DurationChoice(
                          text: Copy.hard,
                          selected: _durationText == Copy.hard,
                          onTap: () => setState(() => _durationText = Copy.hard),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 시작하기 버튼(젤리 바운스)
              JellyTap(
                onTap: _start,
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: SpecConst.primary,
                    borderRadius: BorderRadius.circular(SpecConst.radius),
                    border: Border.all(color: Colors.black.withOpacity(0.10)),
                  ),
                  child: Text(
                    Copy.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _Chip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return JellyTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

class _DurationChoice extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _DurationChoice({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return JellyTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SpecConst.primary.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black.withOpacity(0.10)),
        ),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
