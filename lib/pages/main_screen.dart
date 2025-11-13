import 'package:flutter/material.dart';
import 'package:foxterrier_verband/pages/regional_groups_page.dart';
import 'package:foxterrier_verband/pages/rescue_page.dart';

import 'about_page.dart';
import 'breeders_page.dart';
import 'contact_page.dart';
import 'events_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const MainScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _navBarController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isNavExpanded = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _navBarController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _navBarController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _fadeController.reset();
      _slideController.reset();
      _fadeController.forward();
      _slideController.forward();
      _isNavExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Animated background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF0A1A0A) : Color(0xFFE8F5E9),
            ),
          ),
          // Main content with SliverAppBar
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(theme, isDark),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _getPage(_selectedIndex),
                  ),
                ),
              ),
            ],
          ),
          // Floating navigation overlay
          if (_isNavExpanded)
            GestureDetector(
              onTap: () => setState(() => _isNavExpanded = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.black.withAlpha(100),
              ),
            ),
          // Floating navigation menu
          if (_isNavExpanded)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              top: _isNavExpanded ? 100 : -500,
              left: 20,
              right: 20,
              child: _buildFloatingNav(theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, bool isDark) {
    return SliverAppBar(
      expandedHeight: 400,
      collapsedHeight: 80,
      floating: true,
      surfaceTintColor: Colors.transparent,
      snap: true,
      pinned: true,

      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => setState(() => _isNavExpanded = !_isNavExpanded),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _isNavExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.apps_rounded, color: Colors.white),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: .15),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                widget.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: theme.colorScheme.tertiary,
              ),
              onPressed: widget.onToggleTheme,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Dog image background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder for dog image - replace with actual image
                  Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      'assets/images/dog.jpg',
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primary,
                          child: Icon(
                            Icons.pets,
                            size: 120,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.surface.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content overlay
          ],
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
    );
  }

  Widget _buildFloatingNav(ThemeData theme, bool isDark) {
    final items = [
      {'icon': Icons.home_rounded, 'title': 'Home', 'index': 0},
      {'icon': Icons.info_rounded, 'title': 'Über uns', 'index': 1},
      {'icon': Icons.pets_rounded, 'title': 'Welpen', 'index': 2},
      {'icon': Icons.event_rounded, 'title': 'Events', 'index': 3},
      {'icon': Icons.groups_rounded, 'title': 'Gruppen', 'index': 4},
      {'icon': Icons.favorite_rounded, 'title': 'In Not', 'index': 5},
      {'icon': Icons.mail_rounded, 'title': 'Kontakt', 'index': 6},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Navigation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => setState(() => _isNavExpanded = false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = _selectedIndex == item['index'] as int;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: GestureDetector(
                      onTap: () => _onItemTapped(item['index'] as int),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              isSelected
                                  ? LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : null,
                          color:
                              isSelected
                                  ? null
                                  : theme.colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withOpacity(
                                      0.1,
                                    ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomNav(ThemeData theme, bool isDark) {
    final quickItems = [
      {'icon': Icons.home_rounded, 'index': 0},
      {'icon': Icons.pets_rounded, 'index': 2},
      {'icon': Icons.event_rounded, 'index': 3},
      {'icon': Icons.mail_rounded, 'index': 6},
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            quickItems.map((item) {
              final index = item['index'] as int;
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 24 : 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        isSelected
                            ? LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            )
                            : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color:
                        isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                    size: 28,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const AboutPage();
      case 2:
        return const BreedersPage();
      case 3:
        return const EventsPage();
      case 4:
        return const RegionalGroupsPage();
      case 5:
        return const RescuePage();
      case 6:
        return const ContactPage();
      default:
        return const HomePage();
    }
  }
}
