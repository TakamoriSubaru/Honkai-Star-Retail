import 'package:flutter/material.dart';
import 'main.dart';
import 'api_service.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> resource;

  const ProductPage({
    super.key,
    required this.resource,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  bool isBuying = false;
  String? quantityError;

  // ===== GETTER HELPERS =====
  String get productName => widget.resource['name'] ?? 'Unknown Product';

  double get productPrice {
    final p = widget.resource['price'];
    if (p == null) return 0.0;
    return double.tryParse(p.toString()) ?? 0.0;
  }

  String get productDescription =>
      widget.resource['description'] ??
      'Official premium anime merchandise with detailed design and high-quality material. '
          'Perfect for collectors and anime fans.';

  int get productStock {
    final s = widget.resource['stock'];
    if (s == null) return 0;
    return int.tryParse(s.toString()) ?? 0;
  }

  String? get productImage => widget.resource['image'];

  // ===== VALIDASI QUANTITY =====
  bool validateQuantity() {
    if (quantity < 1) {
      setState(() => quantityError = 'Quantity minimal 1');
      return false;
    }
    if (quantity > productStock) {
      setState(() => quantityError = 'Quantity melebihi stok tersedia ($productStock)');
      return false;
    }
    setState(() => quantityError = null);
    return true;
  }

  // ===== BUY NOW =====
  Future<void> handleBuy() async {
    if (!validateQuantity()) return;

    setState(() => isBuying = true);

    try {
      final result = await ApiService.buyResource(
        widget.resource['id'],
        quantity,
      );

      if (!mounted) return;

      if (result['success'] == true || result['message'] != null && !result.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pembelian berhasil! $quantity x $productName',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
        // Kembali ke home setelah beli
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result['message'] ?? 'Pembelian gagal, coba lagi.',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 10),
              Text('Tidak bisa terhubung ke server',
                  style: TextStyle(fontFamily: 'Poppins')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => isBuying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = productImage != null
        ? 'http://10.0.2.2:3000/uploads/$productImage'
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF7F5AF0),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Product Detail',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== IMAGE HERO =====
            Container(
              width: double.infinity,
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F5AF0), Color(0xFF4D8DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 220,
                            height: 260,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.white54,
                              );
                            },
                          )
                        : const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.white54,
                          ),
                  ),

                  // STOCK BADGE
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: productStock > 0
                            ? Colors.green.shade500
                            : Colors.red.shade500,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        productStock > 0
                            ? 'Stock: $productStock'
                            : 'Out of Stock',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA PRODUK
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1E1E2E),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // HARGA
                  Text(
                    '\$${productPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 26,
                      color: Color(0xFF7F5AF0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 25),

                  // DESKRIPSI
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    productDescription,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== QUANTITY =====
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // MINUS BUTTON
                      _quantityButton(Icons.remove, () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            quantityError = null;
                          }
                        });
                      }),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                      // PLUS BUTTON
                      _quantityButton(Icons.add, () {
                        setState(() {
                          quantity++;
                          quantityError = null;
                        });
                      }),

                      const SizedBox(width: 15),

                      Text(
                        'of $productStock available',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // ERROR VALIDASI QUANTITY
                  if (quantityError != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning_amber,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          quantityError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  // PRODUCT DETAILS CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 15),
                        _detailRow('Product ID', '#${widget.resource['id'] ?? '-'}'),
                        _detailRow('Stock', '$productStock pcs'),
                        _detailRow('Price', '\$${productPrice.toStringAsFixed(2)}'),
                        _detailRow('Status',
                            productStock > 0 ? 'Available' : 'Out of Stock'),
                        _detailRow('Category', 'Official Merchandise'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 110),
                ],
              ),
            ),
          ],
        ),
      ),

      // ===== BOTTOM BUY BUTTON =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SUBTOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal ($quantity item)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '\$${(productPrice * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7F5AF0),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // BUY NOW BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isBuying || productStock == 0) ? null : handleBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: isBuying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        productStock == 0 ? 'Out of Stock' : 'Buy Now',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // QUANTITY BUTTON WIDGET
  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF7F5AF0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // DETAIL ROW
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF7F5AF0), size: 18),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}