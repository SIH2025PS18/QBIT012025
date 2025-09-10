import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'consent_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to consent screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ConsentScreen()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildTutorialPage(
                    icon: Icons.queue,
                    title: 'Join the Queue',
                    description:
                        'Tap "CONSULT DOCTOR NOW" to join the consultation queue. '
                        'Select urgency level based on your symptoms.',
                    image: Icons.queue_play_next_outlined,
                  ),
                  _buildTutorialPage(
                    icon: Icons.hourglass_empty,
                    title: 'Wait for Your Turn',
                    description:
                        'You\'ll receive SMS updates about your position in the queue. '
                        'Estimated wait time is shown on your screen.',
                    image: Icons.access_time_outlined,
                  ),
                  _buildTutorialPage(
                    icon: Icons.videocam,
                    title: 'Video Consultation',
                    description:
                        'When it\'s your turn, you\'ll receive a call notification. '
                        'Connect with your doctor via secure video call.',
                    image: Icons.video_call_outlined,
                  ),
                  _buildTutorialPage(
                    icon: Icons.medication,
                    title: 'Get Prescription',
                    description:
                        'Your doctor will send digital prescription during the call. '
                        'Medicine availability is checked automatically.',
                    image: Icons.description_outlined,
                  ),
                ],
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: List.generate(_totalPages, (index) {
          return Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTutorialPage({
    required IconData icon,
    required String title,
    required String description,
    required IconData image,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, size: 64, color: Theme.of(context).primaryColor),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Visual representation
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Icon(image, size: 80, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
              onPressed: _nextPage,
              icon: _currentPage == _totalPages - 1
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
