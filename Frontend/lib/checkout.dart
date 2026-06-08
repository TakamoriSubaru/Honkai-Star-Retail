import 'package:flutter/material.dart';
import 'main.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // USER DATA EXAMPLE, CAN BE CHANGED
  String userName = "Jocelyn Harjanto";

  String userAddress = "Jl. Gacha Galaxy No. 77";

  String userCity = "Jakarta, Indonesia";

  String userPhone = "+62 812-3456-7890";

  // PAYMENT
  String paymentMethod = "Credit Card";

  // TOTAL
  double totalPrice = 94.97;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // APPBAR
      appBar: AppBar(
        elevation: 0,

        backgroundColor: const Color(0xFF7F5AF0),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Checkout",

          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // SHIPPING TITLE
            sectionTitle("Shipping Address"),

            const SizedBox(height: 15),

            // ADDRESS CARD
            infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    userName,

                    style: const TextStyle(
                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                      fontFamily: "Poppins",
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(userAddress),

                  const SizedBox(height: 5),

                  Text(userCity),

                  const SizedBox(height: 5),

                  Text(userPhone),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PAYMENT METHOD
            sectionTitle("Payment Method"),

            const SizedBox(height: 15),

            paymentTile("Credit Card", Icons.credit_card),

            paymentTile("ShopeePay", Icons.account_balance_wallet),

            paymentTile("Bank Transfer", Icons.account_balance),

            const SizedBox(height: 30),

            // ORDER SUMMARY
            sectionTitle("Order Summary"),

            const SizedBox(height: 15),

            infoCard(
              child: Column(
                children: [
                  orderRow("Kafka Figure x1", "\$39.99"),

                  const SizedBox(height: 15),

                  orderRow("Blade Plush x2", "\$49.98"),

                  const Divider(height: 35),

                  orderRow("Shipping", "\$5.00"),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Total",

                        style: TextStyle(
                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                          fontFamily: "Poppins",
                        ),
                      ),

                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}",

                        style: const TextStyle(
                          fontSize: 24,

                          color: Color(0xFF7F5AF0),

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // PAYMENT BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (_) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),

                        title: const Text("Payment Success"),

                        content: const Text("Thank you for your purchase!"),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),

                                (route) => false,
                              );
                            },

                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F5AF0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Confirm Payment",

                  style: TextStyle(
                    fontSize: 18,

                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SECTION TITLE
  Widget sectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 22,

        fontWeight: FontWeight.bold,

        fontFamily: "Poppins",
      ),
    );
  }

  // CARD
  Widget infoCard({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),

      child: child,
    );
  }

  // PAYMENT TILE
  Widget paymentTile(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),

      child: RadioListTile(
        value: title,
        groupValue: paymentMethod,

        activeColor: const Color(0xFF7F5AF0),

        onChanged: (value) {
          setState(() {
            paymentMethod = value.toString();
          });
        },

        title: Text(
          title,

          style: const TextStyle(
            fontWeight: FontWeight.bold,

            fontFamily: "Poppins",
          ),
        ),

        secondary: Icon(icon, color: const Color(0xFF7F5AF0)),
      ),
    );
  }

  // ORDER ROW
  Widget orderRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(title, style: const TextStyle(fontSize: 16)),

        Text(
          price,

          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
