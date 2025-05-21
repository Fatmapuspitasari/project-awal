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
      Icons.shopping_bag,
      Icons.notifications,
      Icons.person,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (i) {
          return ScaleTransition(
            scale: currentIndex == i ? animation : const AlwaysStoppedAnimation(1.0),
            child: IconButton(
              icon: Icon(
                icons[i],
                color: currentIndex == i ? Colors.blue : Colors.black,
              ),
              iconSize: 30,
              onPressed: () => onTap(i),
            ),
          );
        }),
      ),
    );
  }
}
