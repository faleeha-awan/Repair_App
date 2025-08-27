import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'my_guides_screen.dart';
import 'manuals_chat_screen.dart';
import 'profile_screen.dart';
import '../utils/accessibility_utils.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const MyGuidesScreen(),
    const ManualsChatScreen(),
    const ProfileScreen(),
  ];

  final List<String> _screenTitles = [
    'Home',
    'Search',
    'My Guides',
    'Manuals & Chat',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      // Provide haptic feedback for better accessibility
      HapticFeedback.selectionClick();
      
      // Announce screen change for screen readers
      AccessibilityUtils.announceScreenChange(context, _screenTitles[index]);
      
      setState(() {
        _currentIndex = index;
      });
      
      // Restart animation for smooth transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(colorScheme, isLargeScreen),
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme colorScheme, bool isLargeScreen) {
    return Semantics(
      label: 'Main navigation',
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.primary.withValues(alpha: 0.6),
        backgroundColor: colorScheme.surface,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        selectedFontSize: isLargeScreen ? 14 : 12,
        unselectedFontSize: isLargeScreen ? 12 : 10,
        iconSize: isLargeScreen ? 28 : 24,
        items: [
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Home tab',
              child: const Icon(Icons.home),
            ),
            activeIcon: Semantics(
              label: 'Home tab, currently selected',
              child: Icon(
                Icons.home,
                color: colorScheme.primary,
              ),
            ),
            label: 'Home',
            tooltip: 'Navigate to Home screen',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Search tab',
              child: const Icon(Icons.search),
            ),
            activeIcon: Semantics(
              label: 'Search tab, currently selected',
              child: Icon(
                Icons.search,
                color: colorScheme.primary,
              ),
            ),
            label: 'Search',
            tooltip: 'Navigate to Search screen',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'My Guides tab',
              child: const Icon(Icons.bookmark),
            ),
            activeIcon: Semantics(
              label: 'My Guides tab, currently selected',
              child: Icon(
                Icons.bookmark,
                color: colorScheme.primary,
              ),
            ),
            label: 'My Guides',
            tooltip: 'Navigate to My Guides screen',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Manuals and Chat tab',
              child: const Icon(Icons.chat),
            ),
            activeIcon: Semantics(
              label: 'Manuals and Chat tab, currently selected',
              child: Icon(
                Icons.chat,
                color: colorScheme.primary,
              ),
            ),
            label: 'Manuals & Chat',
            tooltip: 'Navigate to Manuals and Chat screen',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Profile tab',
              child: const Icon(Icons.person),
            ),
            activeIcon: Semantics(
              label: 'Profile tab, currently selected',
              child: Icon(
                Icons.person,
                color: colorScheme.primary,
              ),
            ),
            label: 'Profile',
            tooltip: 'Navigate to Profile screen',
          ),
        ],
      ),
    );
  }
}