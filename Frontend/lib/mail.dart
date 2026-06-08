import 'package:flutter/material.dart';
import 'main.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  // CONTROLLER
  final TextEditingController messageController = TextEditingController();

  // DYNAMIC CHAT DATA
  // CAN CONNECT TO BACKEND LATER
  List<Map<String, dynamic>> messages = [
    {
      "sender": "Admin",

      "message": "Welcome to Gacha Shop Support!",

      "time": "10:00 AM",

      "isMe": false,
    },

    {
      "sender": "Admin",

      "message": "How can we help you today?",

      "time": "10:01 AM",

      "isMe": false,
    },
  ];

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
            Navigator.pushReplacement(
              context,

              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),

        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,

              child: Icon(Icons.support_agent, color: Color(0xFF7F5AF0)),
            ),

            SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Customer Support",

                  style: TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.bold,

                    fontFamily: "Poppins",

                    fontSize: 18,
                  ),
                ),

                Text(
                  "Online",

                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),

      // BODY
      body: Column(
        children: [
          // CHAT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: messages.length,

              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    padding: const EdgeInsets.all(15),

                    constraints: const BoxConstraints(maxWidth: 280),

                    decoration: BoxDecoration(
                      color: msg["isMe"]
                          ? const Color(0xFF7F5AF0)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(20),

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
                        Text(
                          msg["message"],

                          style: TextStyle(
                            color: msg["isMe"] ? Colors.white : Colors.black87,

                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          msg["time"],

                          style: TextStyle(
                            color: msg["isMe"] ? Colors.white70 : Colors.grey,

                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT AREA
          Container(
            padding: const EdgeInsets.all(15),

            decoration: const BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),

                topRight: Radius.circular(30),
              ),
            ),

            child: Row(
              children: [
                // TEXTFIELD
                Expanded(
                  child: TextField(
                    controller: messageController,

                    decoration: InputDecoration(
                      hintText: "Type message...",

                      filled: true,

                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // SEND BUTTON
                GestureDetector(
                  onTap: () {
                    if (messageController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      // USER MESSAGE
                      messages.add({
                        "sender": "You",

                        "message": messageController.text,

                        "time": "Now",

                        "isMe": true,
                      });

                      // AUTO REPLY
                      messages.add({
                        "sender": "Admin",

                        "message": "Thank you for contacting support!",

                        "time": "Now",

                        "isMe": false,
                      });
                    });

                    messageController.clear();
                  },

                  child: Container(
                    padding: const EdgeInsets.all(15),

                    decoration: const BoxDecoration(
                      color: Color(0xFF7F5AF0),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

 