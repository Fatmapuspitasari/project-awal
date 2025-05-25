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

class _HomePageState extends State<HomePage> {
  Widget _buildServiceItem({
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required String imagePath,
    required String price,
  }) {
    final theme = Theme.of(context);
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.grey.shade800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(23),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Lihat Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const String shoesWashImage = 'assets/images/shoeswash.jpg';
    const String shoesCareImage = 'assets/images/shoescare1.jpg';
    const String shoesRepairImage = 'assets/images/shoesrepair.jpg';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: null,  
        centerTitle: true,
        toolbarHeight: 0, 
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layanan Terbaik Kami',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                _buildServiceItem(
                  title: 'Shoes Wash',
                  description:
                      'Cuci dan bersihkan sepatu Anda dengan formula khusus yang aman untuk berbagai jenis material sepatu.',
                  color: Colors.blue.shade700,
                  imagePath: shoesWashImage,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShoesWashScreen(),
                    ),
                  ),
                  price: 'Mulai dari 15K',
                ),
                _buildServiceItem(
                  title: 'Shoes Care',
                  description:
                      'Perawatan khusus untuk memperpanjang umur sepatu dengan metode profesional sesuai jenis material.',
                  color: Colors.green.shade700,
                  imagePath: shoesCareImage,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShoesCareScreen(),
                    ),
                  ),
                  price: 'Mulai dari 25K',
                ),
                _buildServiceItem(
                  title: 'Shoes Repair',
                  description:
                      'Perbaikan sepatu rusak dengan tangan profesional menggunakan teknik dan alat terbaik di kelasnya.',
                  color: Colors.orange.shade700,
                  imagePath: shoesRepairImage,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShoesRepairScreen(),
                    ),
                  ),
                  price: 'Mulai dari 20K',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}