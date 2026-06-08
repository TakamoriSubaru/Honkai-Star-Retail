import 'package:flutter/material.dart';
import 'profile.dart';
import 'product.dart';
import 'basket.dart';
import 'mail.dart';
import 'notification.dart';
import 'api_service.dart';
import 'slash.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(),
  ));
}

// ===== HOME PAGE =====
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();

    // SEARCH LISTENER
    searchController.addListener(() {
      filterProducts(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ===== LOAD PRODUCTS =====
  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.getResources();

      List<dynamic> data = [];
      if (result is List) {
        data = result;
      } else if (result is Map && result.containsKey('data')) {
        data = result['data'] ?? [];
      } else if (result is Map && result.containsKey('resources')) {
        data = result['resources'] ?? [];
      }

      setState(() {
        allProducts = data.map((e) => Map<String, dynamic>.from(e)).toList();
        filteredProducts = allProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Tidak bisa memuat produk';
        isLoading = false;
      });
    }
  }

  // ===== FILTER / SEARCH =====
  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts.where((item) {
          final name = item['name']?.toString().toLowerCase() ?? '';
          final desc = item['description']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              desc.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // ===== FORMAT PRICE =====
  String formatPrice(dynamic price) {
    if (price == null) return '\$0.00';
    final p = double.tryParse(price.toString()) ?? 0.0;
    return '\$${p.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final userName = ApiService.userName ?? 'Guest';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7F5AF0),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MailPage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationPage()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Mail'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadProducts,
          color: const Color(0xFF7F5AF0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ===== TOP HEADER =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7F5AF0), Color(0xFF4D8DFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome Back,',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),

                          // BASKET BUTTON
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BasketPage()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.shopping_basket,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // SEARCH BAR
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search merch...',
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ===== TITLE ROW =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Merch',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '${filteredProducts.length} items',
                        style: const TextStyle(
                          color: Color(0xFF7F5AF0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== LOADING =====
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(60),
                    child: CircularProgressIndicator(
                        color: Color(0xFF7F5AF0)),
                  )

                // ===== ERROR =====
                else if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline,
                            size: 70, color: Colors.red.shade300),
                        const SizedBox(height: 15),
                        Text(errorMessage!,
                            style: const TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loadProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7F5AF0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Coba Lagi',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )

                // ===== EMPTY SEARCH =====
                else if (filteredProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(60),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 70, color: Colors.grey),
                        SizedBox(height: 15),
                        Text('Produk tidak ditemukan',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.grey)),
                      ],
                    ),
                  )

                // ===== PRODUCT GRID =====
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return buildMerchCard(context, filteredProducts[index]);
                      },
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== PRODUCT CARD =====
  Widget buildMerchCard(BuildContext context, Map<String, dynamic> resource) {
    final name = resource['name'] ?? 'Unknown';
    final price = formatPrice(resource['price']);
    final imageFile = resource['image'];
    final stock = int.tryParse(resource['stock']?.toString() ?? '0') ?? 0;
    final imageUrl = imageFile != null
        ? 'http://10.0.2.2:3000/uploads/$imageFile'
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(resource: resource),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF7F5AF0),
                                  strokeWidth: 2,
                                ),
                              );
                            },
                        errorBuilder: (context, error, stackTrace) {
                          print("========== IMAGE ERROR ==========");
                          print(error);
                          print("URL: $imageUrl");
                          print("================================");

                          return const Icon(
                            Icons.image,
                            size: 70,
                            color: Colors.grey,
                            );
                          },
                        )
                    : const Icon(Icons.image, size: 70, color: Colors.grey),
                  ),

                  // OUT OF STOCK BADGE
                  if (stock == 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Habis',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // NAMA
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 4),

            // HARGA
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFF7F5AF0),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 3),

            // STOCK
            Text(
              'Stok: $stock',
              style: TextStyle(
                color: stock > 0 ? Colors.grey : Colors.red,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}