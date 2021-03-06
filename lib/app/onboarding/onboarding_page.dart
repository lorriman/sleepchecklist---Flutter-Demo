import 'package:custom_buttons/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insomnia_checklist/app/onboarding/onboarding_view_model.dart';
import 'package:insomnia_checklist/constants/keys.dart';

/// Copyright Andrea Bozito, with modifications.
/// Notable additions and classes by Greg Lorriman as noted.

class OnboardingPage extends ConsumerWidget {
  Future<void> onGetStarted(BuildContext context, WidgetRef ref) async {
    final onboardingViewModel = ref.read(onboardingViewModelProvider.notifier);
    await onboardingViewModel.completeOnboarding();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Track yourself.\nBecause sleep counts.',
                //style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/sleep.png',
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomRaisedButton(
                key: Key(Keys.testOnBoardingOnGetStartedButton),
                onPressed: () => onGetStarted(context,ref),
                color: Colors.indigo,
                borderRadius: 30,
                child: Text(
                  'Get Started',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
