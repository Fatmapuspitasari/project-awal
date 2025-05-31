import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final icons = [
      Icons.home,
      Icons.history,
      Icons.payment,
      Icons.person,
    ];

    final labels = [
      'Beranda',
      'Riwayat',
      'Promo',
      'Profil',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (i) {
          final isSelected = currentIndex == i;

          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: isSelected ? animation : const AlwaysStoppedAnimation(1.0),
                  child: Icon(
                    icons[i],
                    color: isSelected ? Colors.blue : Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.blue : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
