import 'package:flutter/material.dart';
import 'package:project_awal/screens/shoes_repair_screen.dart';
import 'shoes_wash_screen.dart';
import 'shoes_care_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildServiceItem(Map<String, dynamic> service, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = service['color'] as Color;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 30 * (1 - _animation.value)),
        child: Opacity(
          opacity: _animation.value,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => service['screen'] as Widget),
              ),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [theme.cardColor, theme.cardColor.withAlpha(180)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(34),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -3,
                    ),
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.withAlpha(23),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isDark ? Colors.white.withAlpha(23) : Colors.grey.withAlpha(23),
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
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              image: DecorationImage(
                                image: AssetImage(service['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withAlpha(68)],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withAlpha(203),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(45),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                service['price'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
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
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    service['title'],
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : Colors.grey.shade800,
                                      letterSpacing: -0.3,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                service['description'],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                  height: 1.4,
                                  letterSpacing: 0.1,
                                  fontSize: 11,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [color, color.withAlpha(180)]),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withAlpha(90),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
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
                                        fontSize: 10,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
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
        'description': 'Cuci dan bersihkan sepatu Anda dengan formula khusus yang aman untuk berbagai jenis material sepatu.',
        'color': Colors.blue.shade700,
        'image': 'assets/images/shoeswash.jpg',
        'price': 'Mulai dari 15K',
        'screen': const ShoesWashScreen(),
      },
      {
        'title': 'Shoes Care',
        'description': 'Perawatan khusus untuk memperpanjang umur sepatu dengan metode profesional sesuai jenis material.',
        'color': Colors.green.shade700,
        'image': 'assets/images/shoescare1.jpg',
        'price': 'Mulai dari 25K',
        'screen': const ShoesCareScreen(),
      },
      {
        'title': 'Shoes Repair',
        'description': 'Perbaikan sepatu rusak dengan tangan profesional menggunakan teknik dan alat terbaik di kelasnya.',
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.primaryColor.withAlpha(11), Colors.transparent],
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
                            width: 6,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [theme.primaryColor, theme.primaryColor.withAlpha(135)],
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Layanan Terbaik Kami',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pilih layanan profesional untuk sepatu kesayangan Anda',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Services Grid
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8, // Adjust this ratio to control card height
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) => _buildServiceItem(services[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}