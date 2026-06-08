import 'package:flutter/material.dart';
import 'main.dart';
import 'api_service.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  // ===== LOAD TRANSACTION HISTORY =====
  Future<void> loadTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.getTransactions();

      // Backend bisa return list langsung atau { data: [...] }
      List<dynamic> data = [];
      if (result is List) {
        data = result;
      } else if (result is Map && result.containsKey('data')) {
        data = result['data'] ?? [];
      } else if (result is Map && result.containsKey('transactions')) {
        data = result['transactions'] ?? [];
      }

      setState(() {
        transactions = data.map((e) => Map<String, dynamic>.from(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Tidak bisa memuat riwayat pembelian';
        isLoading = false;
      });
    }
  }

  // FORMAT TANGGAL
  String formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}  ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  // FORMAT HARGA
  String formatPrice(dynamic price) {
    if (price == null) return '\$0.00';
    final p = double.tryParse(price.toString()) ?? 0.0;
    return '\$${p.toStringAsFixed(2)}';
  }

  // TOTAL SPENDING
  double get totalSpent {
    double total = 0;
    for (var tx in transactions) {
      final price = double.tryParse(tx['total_price']?.toString() ?? '0') ?? 0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      // APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF7F5AF0),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),

        title: const Text(
          'Purchase History',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadTransactions,
          ),
        ],
      ),

      // BODY
      body: isLoading
          // LOADING
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7F5AF0)),
            )

          // ERROR
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 80, color: Colors.red.shade300),
                      const SizedBox(height: 20),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loadTransactions,
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

          // EMPTY
          : transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 100, color: Colors.grey.shade400),
                      const SizedBox(height: 20),
                      const Text(
                        'Belum ada pembelian',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Yuk beli produk pertamamu!',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                )

          // TRANSACTION LIST
          : Column(
              children: [
                // TOTAL SUMMARY CARD
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7F5AF0), Color(0xFF4D8DFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pengeluaran',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\$${totalSpent.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.receipt_long,
                                color: Colors.white, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              '${transactions.length} transaksi',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // LIST TRANSAKSI
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: loadTransactions,
                    color: const Color(0xFF7F5AF0),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final resourceName =
                            tx['resource_name'] ?? tx['name'] ?? 'Produk';
                        final qty = tx['quantity'] ?? 1;
                        final totalPrice = tx['total_price'] ?? tx['price'] ?? 0;
                        final createdAt = tx['created_at'] ?? tx['date'];
                        final imageFile = tx['image'];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // IMAGE / ICON
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: imageFile != null
                                    ? Image.network(
                                        'http://10.0.2.2:3000/uploads/$imageFile',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return _placeholderImage();
                                        },
                                      )
                                    : _placeholderImage(),
                              ),

                              const SizedBox(width: 14),

                              // INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      resourceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Qty: $qty',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatDate(createdAt?.toString()),
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),

                              // HARGA
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatPrice(totalPrice),
                                    style: const TextStyle(
                                      color: Color(0xFF7F5AF0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Selesai',
                                      style: TextStyle(
                                        color: Colors.green.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.shopping_bag, color: Colors.grey.shade400, size: 30),
    );
  }
}