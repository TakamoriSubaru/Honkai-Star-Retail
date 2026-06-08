import 'package:flutter/material.dart';
import 'main.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TEMP DATA
    List<Map<String, dynamic>> notifications = [
      {
        "product": "Kafka Figure",
        "status": "Purchased",
        "time": "2 hours ago",

        "icon": Icons.shopping_bag,
        "color": Colors.green,
      },

      {
        "product": "Blade Plush",
        "status": "Shipped",
        "time": "1 hour ago",

        "icon": Icons.local_shipping,
        "color": Colors.blue,
      },

      {
        "product": "Silver Wolf Keychain",
        "status": "Added to Basket",
        "time": "30 mins ago",

        "icon": Icons.add_shopping_cart,
        "color": Colors.orange,
      },

      {
        "product": "Kafka Plush",
        "status": "Discount Available",
        "time": "Yesterday",

        "icon": Icons.local_offer,
        "color": const Color(0xFF7F5AF0),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

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
          "Notifications",

          style: TextStyle(
            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontFamily: "Poppins",
          ),
        ),
      ),

      // BODY
      body: ListView.builder(
        padding: const EdgeInsets.all(20),

        itemCount: notifications.length,

        itemBuilder: (context, index) {
          final notif = notifications[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 18),

            padding: const EdgeInsets.all(18),

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

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ICON
                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: notif["color"].withOpacity(0.15),

                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Icon(notif["icon"], color: notif["color"]),
                ),

                const SizedBox(width: 15),

                // TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "${notif["product"]} ${notif["status"]}",

                        style: const TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          fontFamily: "Poppins",
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        getNotificationMessage(notif),

                        style: TextStyle(
                          color: Colors.grey.shade700,

                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        notif["time"],

                        style: TextStyle(
                          color: Colors.grey.shade500,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // DYNAMIC MESSAGE
  String getNotificationMessage(Map<String, dynamic> notif) {
    switch (notif["status"]) {
      case "Purchased":
        return "${notif["product"]} has been successfully purchased.";

      case "Shipped":
        return "${notif["product"]} is currently being delivered.";

      case "Added to Basket":
        return "${notif["product"]} has been added to your basket.";

      case "Discount Available":
        return "${notif["product"]} now has a special discount.";

      default:
        return "Notification updated.";
    }
  }
}
