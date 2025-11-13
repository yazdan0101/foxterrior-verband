import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _particleController;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SnapScrollPage(
        pageController: _pageController,
        children: [
          Column(
            children: [
              DanglingLogo(imagePath: 'assets/images/logo.png'),

              _welcomeWidget(),
              ScrollHint(pageController: _pageController),
            ],
          ),

          _buildAboutSection(theme),
          _buildQuickAccessCards(theme),
          _buildFeaturedSection(theme),
          _buildStatsSection(theme),
        ],
      ),
    );
  }

  Widget _welcomeWidget() {
    return SizedBox(
      height: 100,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.clip,
        ),
        child: AnimatedTextKit(
          repeatForever: false,
          totalRepeatCount: 1,
          animatedTexts: [
            TyperAnimatedText(
              'Herzlich Willkommen beim Deutschen Foxterrier-Verband e.V.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCards(ThemeData theme) {
    final cards = [
      {
        'title': 'Welpen',
        'subtitle': 'Verfügbar',
        'icon': Icons.pets,
        'color': const Color(0xFF4A7C2C),
        'count': 12,
      },
      {
        'title': 'Züchter',
        'subtitle': 'Registriert',
        'icon': Icons.verified_user_rounded,
        'color': const Color(0xFF2D5016),
        'count': 45,
      },
      {
        'title': 'Events',
        'subtitle': 'Geplant',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFFD4AF37),
        'count': 8,
      },
      {
        'title': 'Mitglieder',
        'subtitle': 'Aktiv',
        'icon': Icons.people_rounded,
        'color': const Color(0xFF5D9B3C),
        'count': 320,
      },
    ];

    return Center(
      child: SizedBox(
        height: 200, // Fixed height for the horizontal list
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (index * 100)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 200,
                    height: 180, // Specific height for each card
                    margin: EdgeInsets.only(
                      right: index < cards.length - 1 ? 16 : 0,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: (card['color'] as Color).withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (card['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            card['icon'] as IconData,
                            color: card['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: 0,
                                end: card['count'] as int,
                              ),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                              builder: (context, count, child) {
                                return Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card['title'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageCard(
    ThemeData theme,
    String title,
    String description,
    String imageUrl,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primary,
                          child: Icon(
                            Icons.pets,
                            size: 80,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.95),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    // Text content
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.4,
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Wrap(
          runAlignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildImageCard(
              theme,
              'Ursprung',
              'Der Foxterrier stammt, wie die meisten Terrier, aus England. Sein Name setzt sich aus seinem ursprünglichen Verwendungszweck zusammen: Fox - Fuchs und Terra - Erde.',
              'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=800',
              0,
            ),
            _buildImageCard(
              theme,
              'Ein Terrier für alle Fälle',
              'Foxterrier sind sehr sportlich, ohne überdreht zu sein. Für Agility, Flyball, Dogdancing und vieles mehr, sind die Foxis leicht zu begeistern.',
              'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800',
              100,
            ),
            _buildImageCard(
              theme,
              'Wesen',
              'Der Foxterrier ist aufgeweckt, intelligent, furchtlos, freundlich, sehr lernwillig und arbeitsfreudig. Er integriert sich ausgezeichnet in die Familie.',
              'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800',
              200,
            ),
            _buildImageCard(
              theme,
              'Jagd',
              'Früher wurde der Foxterrier ausschlißlich für die Baujagd eingesetzt. Ob bei der Baujagd,beim Stöberr,Apportieren oder auf der Nachsuche- mit einem Foxterrier bekommen Sie einen treuen Jagdgefährten.',
              'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=800',
              0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schnellzugriff',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            theme,
            'Wir haben Welpen',
            'Finden Sie Ihren perfekten Begleiter',
            Icons.child_friendly_rounded,
            Colors.blue.shade400,
            0,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            theme,
            'Wurfplanung',
            'Kommende Würfe ansehen',
            Icons.calendar_month_rounded,
            Colors.purple.shade400,
            100,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            theme,
            'Foxterrier in Not',
            'Helfen Sie einem Hund',
            Icons.favorite_rounded,
            Colors.red.shade400,
            200,
          ),
          const SizedBox(height: 20),
          _buildWhyBreederCard(theme),
        ],
      ),
    );
  }

  Widget _buildWhyBreederCard(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Warum einen Hund vom Verband?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBenefitItem('1. Kontrollierte Zucht'),
                const SizedBox(height: 12),
                _buildBenefitItem(
                  '2. Gesunde, form- und leistungsgeprüfte Eltern',
                ),
                const SizedBox(height: 12),
                _buildBenefitItem('3. Unterstützung vor und nach dem Kauf'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return Center(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.tertiary.withOpacity(0.1),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.tertiary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: theme.colorScheme.tertiary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Mitgliedsverbände',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadge(theme, 'FCI'),
                _buildBadge(theme, 'VDH'),
                _buildBadge(theme, 'JGHV'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(ThemeData theme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class ScrollHint extends StatefulWidget {
  final Color color;
  final double size;
  final PageController pageController;

  const ScrollHint({
    super.key,
    required this.pageController,
    this.color = Colors.black,
    this.size = 40,
  });

  @override
  State<ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<ScrollHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Bounce animation
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Hide hint when user scrolls
    widget.pageController.addListener(() {
      if (!mounted) return;
      if (widget.pageController.page != 0 && _isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    });
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? SizedBox(
          height: 80,
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              );
            },
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: widget.size,
              color: widget.color.withOpacity(0.8),
            ),
          ),
        )
        : const SizedBox.shrink();
  }
}

class DanglingLogo extends StatefulWidget {
  final double size;
  final String imagePath;

  const DanglingLogo({super.key, required this.imagePath, this.size = 200});

  @override
  State<DanglingLogo> createState() => _DanglingLogoState();
}

class _DanglingLogoState extends State<DanglingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _swingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _swingAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),

        AnimatedBuilder(
          animation: _swingAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _swingAnimation.value,
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 225,
                width: 225,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Wire or hook
                    CustomPaint(
                      size: Size(widget.size * 0.2, widget.size * .5),
                      painter: HookPainter(),
                    ),

                    // Logo (slightly below the hook)
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        widget.imagePath,
                        height: widget.size,
                        width: widget.size,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class HookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade300
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height - 20);
    path.arcToPoint(
      Offset(size.width / 2 + 12, size.height - 5),
      radius: const Radius.circular(15),
      clockwise: false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SnapScrollPage extends StatefulWidget {
  const SnapScrollPage({
    super.key,
    required this.children,
    required this.pageController,
  });
  final List<Widget> children;
  final PageController pageController;
  @override
  State<SnapScrollPage> createState() => _SnapScrollPageState();
}

class _SnapScrollPageState extends State<SnapScrollPage> {
  void _scrollToNextSection(bool scrollDown) {
    final nextPage =
        scrollDown
            ? widget.pageController.page!.toInt() + 1
            : widget.pageController.page!.toInt() - 1;
    if (nextPage >= 0 && nextPage < 5) {
      widget.pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy > 0) {
            _scrollToNextSection(true);
          } else if (pointerSignal.scrollDelta.dy < 0) {
            _scrollToNextSection(false);
          }
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height, // full height
        child: PageView(
          controller: widget.pageController,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(), // disable drag
          children: widget.children,
        ),
      ),
    );
  }
}
