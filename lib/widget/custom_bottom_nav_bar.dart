import 'package:flutter/material.dart';
import 'package:Ardefva/screens/perawatan_sepatu_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Animation<double> animation;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.animation,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingButtonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _floatingButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _floatingButtonController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (0.125 * 2π)
    ).animate(
      CurvedAnimation(
        parent: _floatingButtonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _floatingButtonController.dispose();
    super.dispose();
  }

  void _onFloatingButtonPressed() async {
    // Trigger animation
    await _floatingButtonController.forward();
    await _floatingButtonController.reverse();

    // Navigate to PerawatanSepatuScreen
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerawatanSepatuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home,
      Icons.history,
      Icons.add, // Tombol tengah
      Icons.store,
      Icons.person,
    ];

    final labels = [
      'Beranda',
      'Riwayat',
      'Care', // Label untuk tombol tengah
      'Store',
      'Profil',
    ];

    return Container(
      height: 60, // Ukuran tinggi navigation bar (lebih kecil)
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Padding kecil
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (i) {
          if (i == 2) {
            // Tombol tengah dengan animasi
            return Container(
              margin: const EdgeInsets.only(bottom: 20), // naikkan sedikit
              child: GestureDetector(
                onTap: _onFloatingButtonPressed,
                child: AnimatedBuilder(
                  animation: _floatingButtonController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 2 * 3.14159,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.blue.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withAlpha(68),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.cleaning_services,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          final actualIndex = i > 2 ? i - 1 : i;
          final isSelected = widget.currentIndex == actualIndex;

          return GestureDetector(
            onTap: () => widget.onTap(actualIndex),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale:
                      isSelected
                          ? widget.animation
                          : const AlwaysStoppedAnimation(1.0),
                  child: Icon(
                    icons[i],
                    color: isSelected ? Colors.blue : Colors.black,
                    size: 22, // ukuran icon lebih kecil
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10, // ukuran font lebih kecil
                    color: isSelected ? Colors.blue : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
