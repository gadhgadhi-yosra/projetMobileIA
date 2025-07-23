import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';
import 'package:supermarket_app_03072025/widgets/custom_elevated_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> dataList = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Gérez votre stock intelligemment',
      'description': 'Suivez vos produits en temps réel et optimisez \n vos inventaires.',
    },
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Comparez les prix des concurrents',
      'description': 'Notre IA recherche les meilleurs prix pour \n vous aider à rester compétitif.',
    },
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Prenez des décisions éclairées',
      'description': 'Baissez, augmentez ou maintenez vos prix grâce à nos \n recommandations intelligentes.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: PageView.builder(
        controller: _controller,
        itemCount: dataList.length,
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  dataList[index]['image']!,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: screenHeight * 0.05,
                left: screenWidth * 0.05,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's get started",
                      style: AppStyles.headline2.copyWith(
                        color: colorScheme.primary,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        dataList[index]['title']!,
                        style: AppStyles.bodyText1.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        dataList[index]['description']!,
                        style: AppStyles.bodyText2.copyWith(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.23,
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    dataList.length,
                    (index) => buildDot(index, context, colorScheme),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.all(screenWidth * 0.1),
                  child: CustomElevatedButton(
                    onPressed: () {
                      if (currentIndex == dataList.length - 1) {
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    text: currentIndex == dataList.length - 1 ? 'Commencer' : 'Suivant',
                    height: 50,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    textStyle: AppStyles.bodyText1.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.05,
                right: screenWidth * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    "Passer",
                    style: AppStyles.bodyText2.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container buildDot(int index, BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.primary.withOpacity(currentIndex == index ? 0.9 : 0.4),
      ),
    );
  }
}