import 'package:flutter/material.dart';

class StepNavigationBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isLoading;
  final Widget finalAction; // tombol custom di step terakhir

  const StepNavigationBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
    this.isLoading = false,
    required this.finalAction,
  });

  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 2, left: 16, right: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isFirstStep)
              TextButton(
                  onPressed: onPrevious,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 6),
                      Text(
                        "Sebelumnya",
                      ),
                    ],
                  )),
            Spacer(),
            isLastStep
                ? finalAction
                : TextButton(
                    onPressed: onNext,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Selanjutnya",
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
