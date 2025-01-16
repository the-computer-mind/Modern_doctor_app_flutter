import 'package:flutter/material.dart';

class ChatWIthDoctor extends StatefulWidget {
  const ChatWIthDoctor({super.key});

  @override
  State<ChatWIthDoctor> createState() => _ChatWIthDoctorState();
}

class _ChatWIthDoctorState extends State<ChatWIthDoctor> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Chat With Socket.IO(io.on -- io.emit) Coming Soon... "),
      ),
    );
  }
}
