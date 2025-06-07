import 'package:flutter/material.dart';
import 'shoes_repair_screen.dart';
import 'shoes_care_screen.dart';
import 'shoes_wash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController _pageController;
  int _currentPromoIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _nextSlide();
        _startAutoSlide();
      }
    });
  }

  void _nextSlide() {
    if (_currentPromoIndex < promoData.length - 1) {
      _currentPromoIndex++;
    } else {
      _currentPromoIndex = 0;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPromoIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Promo data without asset images
  final List<Map<String, dynamic>> promoData = [
    {
      'title': 'Promo!',
      'subtitle': 'Dapatkan diskon shoeswash setiap 8x pencucian sepatu',
      'description': 'Berlaku sampai akhir bulan',
      'icon': Icons.local_offer_rounded,
      'color': Colors.red.shade600,
      'gradient': [Colors.red.shade600, Colors.orange.shade500],
    },
    {
      'title': 'Paket Hemat!',
      'subtitle': 'Buruan dapatkan paket hemat Cuci + Perawatan Sepatu',
      'description': 'Mulai 35K untuk 2 layanan',
      'icon': Icons.card_giftcard_rounded,
      'color': Colors.purple.shade600,
      'gradient': [Colors.purple.shade600, Colors.blue.shade500],
    },
    {
      'title': 'Member Baru!',
      'subtitle': 'Gratis parfume untuk member baru',
      'description': 'Daftar sekarang dan nikmati gratis parfume 10ml',
      'icon': Icons.stars_rounded,
      'color': Colors.green.shade600,
      'gradient': [Colors.green.shade600, Colors.teal.shade500],
    },
  ];

  Widget _buildPromoSlideshow() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 160, // Further reduced height
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 12), // Reduced margins
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged:
                  (index) => setState(() => _currentPromoIndex = index),
              itemCount: promoData.length,
              itemBuilder: (context, index) {
                final promo = promoData[index];
                return AnimatedBuilder(
                  animation: _animation,
                  builder:
                      (context, child) => Transform.scale(
                        scale: 0.95 + (0.05 * _animation.value),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              16,
                            ), // Slightly reduced
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: promo['gradient'],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: promo['color'].withAlpha(68),
                                blurRadius: 15, // Reduced shadow
                                offset: const Offset(0, 6),
                                spreadRadius: -2,
                              ),
                              BoxShadow(
                                color:
                                    isDark
                                        ? Colors.black38
                                        : Colors.grey.withAlpha(45),
                                blurRadius: 6, // Reduced shadow
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: RadialGradient(
                                      center: Alignment.topRight,
                                      radius: 1.5,
                                      colors: [
                                        Colors.white.withAlpha(45),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(
                                  14,
                                ), // Further reduced padding
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(45),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              promo['title'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9, // Further reduced
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ), // Reduced spacing
                                          Flexible(
                                            child: Text(
                                              promo['subtitle'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12, // Further reduced
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.3,
                                                height: 1.1,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ), // Reduced spacing
                                          Flexible(
                                            child: Text(
                                              promo['description'],
                                              style: TextStyle(
                                                color: Colors.white.withAlpha(
                                                  204,
                                                ),
                                                fontSize: 10, // Further reduced
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ), // Reduced spacing
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  8, // Further reduced padding
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withAlpha(
                                                    45,
                                                  ),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Ambil Promo',
                                                  style: TextStyle(
                                                    color: promo['color'],
                                                    fontSize:
                                                        8, // Further reduced
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(width: 3),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: promo['color'],
                                                  size: 10, // Further reduced
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ), // Reduced spacing
                                    // Icon instead of image
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(34),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            promo['icon'],
                                            color: Colors.white.withAlpha(180),
                                            size: 30, // Further reduced
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              },
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              promoData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(
                  horizontal: 2,
                ), // Reduced margin
                width: _currentPromoIndex == index ? 16 : 6, // Reduced sizes
                height: 6,
                decoration: BoxDecoration(
                  color:
                      _currentPromoIndex == index
                          ? theme.primaryColor
                          : theme.hintColor.withAlpha(90),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = service['color'] as Color;

    return AnimatedBuilder(
      animation: _animation,
      builder:
          (context, child) => Transform.translate(
            offset: Offset(0, 30 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(16), // Reduced radius
                child: InkWell(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => service['screen'] as Widget,
                        ),
                      ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.cardColor,
                          theme.cardColor.withAlpha(180),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(34),
                          blurRadius: 15, // Reduced shadow
                          offset: const Offset(0, 6),
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color:
                              isDark
                                  ? Colors.black26
                                  : Colors.grey.withAlpha(23),
                          blurRadius: 6, // Reduced shadow
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.white.withAlpha(23)
                                : Colors.grey.withAlpha(23),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(service['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withAlpha(68),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6, // Reduced positioning
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6, // Reduced padding
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withAlpha(203),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(45),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    service['price'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Content Section
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              10,
                            ), // Reduced padding
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize:
                                  MainAxisSize.min, // Added to prevent overflow
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 2, // Reduced width
                                      height: 14, // Reduced height
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                    const SizedBox(width: 6), // Reduced spacing
                                    Expanded(
                                      child: Text(
                                        service['title'],
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                      : Colors.grey.shade800,
                                              letterSpacing: -0.3,
                                              fontSize: 13, // Reduced font size
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                Flexible(
                                  // Changed from Expanded to Flexible
                                  child: Text(
                                    service['description'],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor,
                                      height: 1.3,
                                      letterSpacing: 0.1,
                                      fontSize: 10, // Reduced font size
                                    ),
                                    maxLines: 2, // Reduced max lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10, // Reduced padding
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [color, color.withAlpha(180)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withAlpha(90),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Detail',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 9, // Reduced font size
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 11, // Reduced icon size
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final services = [
      {
        'title': 'Shoes Wash',
        'description':
            'Cuci dan bersihkan sepatu Anda dengan formula khusus yang aman untuk berbagai jenis material sepatu.',
        'color': Colors.blue.shade700,
        'image': 'assets/images/shoeswash.jpg',
        'price': 'Mulai dari 15K',
        'screen': const ShoesWashScreen(),
      },
      {
        'title': 'Shoes Care',
        'description':
            'Perawatan khusus untuk memperpanjang umur sepatu dengan metode profesional sesuai jenis material.',
        'color': Colors.green.shade700,
        'image': 'assets/images/shoescare1.jpg',
        'price': 'Mulai dari 25K',
        'screen': const ShoesCareScreen(),
      },
      {
        'title': 'Shoes Repair',
        'description':
            'Perbaikan sepatu rusak dengan tangan profesional menggunakan teknik dan alat terbaik di kelasnya.',
        'color': Colors.orange.shade700,
        'image': 'assets/images/shoesrepair.jpg',
        'price': 'Mulai dari 20K',
        'screen': const ShoesRepairScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  20,
                ), // Reduced padding
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.primaryColor.withAlpha(11),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5, // Reduced width
                            height: 28, // Reduced height
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.primaryColor,
                                  theme.primaryColor.withAlpha(135),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(width: 14), // Reduced spacing
                          Expanded(
                            child: Text(
                              'Layanan Terbaik Kami',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                fontSize: 20, // Reduced font size
                                color:
                                    theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Reduced spacing
                      Text(
                        'Pilih layanan profesional untuk sepatu kesayangan Anda',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          height: 1.4,
                          letterSpacing: 0.2,
                          fontSize: 13, // Reduced font size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Promo Slideshow
              _buildPromoSlideshow(),
              // Services Grid
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  24,
                ), // Reduced bottom padding
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12, // Reduced spacing
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85, // Slightly adjusted aspect ratio
                  ),
                  itemCount: services.length,
                  itemBuilder:
                      (context, index) =>
                          _buildServiceItem(services[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
