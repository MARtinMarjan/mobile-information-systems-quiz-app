import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      bottomButtonColor: CupertinoColors.systemRed.resolveFrom(context),
      onPressedOnLastPage: () => {
        Navigator.of(context).pushReplacementNamed('/splash_screen'),
      },
      pages: [
        WhatsNewPage(
          title: const Text("What is MKLearner?"),
          features: [
            // Feature's type must be `WhatsNewFeature`
            WhatsNewFeature(
              icon: Icon(
                CupertinoIcons.text_bubble,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text('Learn a new language'),
              description: const Text(
                'MKLearner is a language learning app that helps you learn the Macedonian language by practicing with quizzes.',
              ),
            ),
            WhatsNewFeature(
              icon: Icon(
                //fire
                CupertinoIcons.flame_fill,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text("Don't Lose your streak!"),
              description: const Text(
                "Keep your streak going by practicing every day and competing with other users.",
              ),
            ),
            // Leaderboard
            WhatsNewFeature(
              icon: Icon(
                CupertinoIcons.person_2_fill,
                color: CupertinoColors.systemRed.resolveFrom(context),
              ),
              title: const Text('Compete with others'),
              description: const Text(
                'Compete with other users and see who has the highest score.',
              ),
            ),
          ],
        ),

        // To create custom onboarding page, use
        // `CupertinoOnboardingPage` widget:

        CupertinoOnboardingPage(
          title: const Text('Meet Miki the Lynx'),
          body: Column(
            children: [
              const Text(
                  'Miki is the mascot of MKLearner. He is a lynx and he is here to help you learn the Macedonian language. '),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/quiz_logo_3.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const CupertinoOnboardingPage(
          title: Text("Let's start!"),
          body: Column(
            children: [
              Text(
                  " Now that you know what MKLearner is, let's get started, shall we? Start by taking a quiz and see how much you know about the Macedonian language. "),
            ],
          ),
        ),
      ],
    );
  }
}
