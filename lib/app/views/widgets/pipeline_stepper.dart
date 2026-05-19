import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class PipelineStepperWidget extends StatelessWidget {
  final int activeStep;
  final Map<int, String> stepResults;

  const PipelineStepperWidget({
    super.key,
    required this.activeStep,
    required this.stepResults,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Sequence Ingestion',
      'K-mer Novelty',
      'ESM-2 Danger',
      'Structural Analysis',
      'Gemini Brief',
      'Action Dispatch'
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(primary: AppTheme.infoBlue),
      ),
      child: Stepper(
        physics: const NeverScrollableScrollPhysics(),
        currentStep: activeStep.clamp(0, steps.length - 1),
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: List.generate(steps.length, (index) {
          final isCompleted = index < activeStep;
          final isActive = index == activeStep;
          
          return Step(
            title: Text(
              steps[index],
              style: GoogleFonts.outfit(
                color: isCompleted ? AppTheme.safeGreen : (isActive ? AppTheme.infoBlue : AppTheme.secondaryText),
                fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: isCompleted && stepResults.containsKey(index)
                ? Text(
                    stepResults[index]!, 
                    style: GoogleFonts.outfit(
                      color: AppTheme.primaryText,
                    ),
                  )
                : null,
            content: isActive
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppTheme.infoBlue)),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            state: isCompleted ? StepState.complete : (isActive ? StepState.editing : StepState.indexed),
            isActive: isActive || isCompleted,
          );
        }),
      ),
    );
  }
}
