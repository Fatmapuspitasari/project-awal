import 'package:flutter/material.dart';

class CustomBottomLabel extends StatelessWidget {
  final int currentIndex;

  const CustomBottomLabel({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final labels = ['Beranda', 'Pesan', 'Notifikasi', 'Profil'];

    return Container(
      height: 20,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(labels.length, (i) {
          return Text(
            labels[i],
            style: TextStyle(
              fontSize: 12,
              color: currentIndex == i ? Colors.blue : Colors.grey,
              fontWeight: currentIndex == i ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }),
      ),
    );
  }
}
