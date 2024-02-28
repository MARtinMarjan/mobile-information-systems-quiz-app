import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Future<void> pushAndReplace(String routeName) async {
  //   final current = ModalRoute.of(context);
  //   Navigator.pushNamed(context, routeName);
  //   await Future.delayed(const Duration(milliseconds: 1));
  //   Navigator.removeRoute(context, current!);
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      bottomButtonColor: CupertinoColors.systemRed.resolveFrom(context),
      onPressedOnLastPage: () => {
        Navigator.of(context).pushReplacementNamed('/welcome_screen'),
        // pushAndReplace('/welcome_screen')
      },
      bottomButtonBorderRadius: BorderRadius.lerp(
        BorderRadius.circular(10),
        BorderRadius.circular(20),
        10,
      ),
      pages: [
        CupertinoOnboardingPage(
          title: const Text("Welcome to MKLearner!"),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                  "MKLearner is a language learning app that helps you learn the Macedonian language"),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/level_map/random_images/macedonia.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/quiz_logo_2.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        WhatsNewPage(
          // scrollPhysics: const BouncingScrollPhysics(),
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
                "Keep your streak going by practicing every day!",
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
                    image: AssetImage('assets/images/quiz_logo_3.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        CupertinoOnboardingPage(
          title: const Text("Let's start!"),
          body: Column(
            children: [
              const Text(
                  " Now that you know what MKLearner is, let's get started, shall we? Start by taking a quiz and see how much you know about the Macedonian language. "),
              Hero(
                tag: "logoImage",
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/quiz_logo_2.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
