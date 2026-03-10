import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signup_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Bienvenue dans E-Bar",
      description:
          "Votre application mobile complète pour la gestion moderne de votre bar",
      image: Icons.local_bar,
      color: Colors.blue,
    ),
    OnboardingData(
      title: "Gestion Intelligente",
      description: "Suivez vos stocks, ventes et performances en temps réel",
      image: Icons.analytics,
      color: Colors.blue,
    ),
    OnboardingData(
      title: "Multi-Rôles",
      description: "Adaptée aux administrateurs, gérants et vendeurs",
      image: Icons.people,
      color: Colors.blue,
    ),
    OnboardingData(
      title: "Statistiques Avancées",
      description: "Dashboard complet avec indicateurs de performance",
      image: Icons.dashboard,
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: TextButton(
                onPressed: () => _goToSignup(),
                child: Text(
                  "Passer",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // PageView for onboarding screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),

            // Page indicator
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),

            // Navigation buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button (hidden on first page)
                  _currentPage > 0
                      ? TextButton(
                          onPressed: () => _previousPage(),
                          child: Text(
                            "Précédent",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      : SizedBox(width: 80.w),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: () => _nextPage(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _onboardingData[_currentPage].color,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 15.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? "Commencer"
                          : "Suivant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Icon
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.image, size: 100.sp, color: data.color),
          ),
          SizedBox(height: 40.h),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 40.h),

          // Additional visual elements
          Container(
            height: 3.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: _currentPage == index ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _onboardingData[_currentPage].color
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage == _onboardingData.length - 1) {
      _goToSignup();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
