import 'package:flutter/material.dart';

class ReviewCandidatePage extends StatefulWidget {
  const ReviewCandidatePage({super.key});

  @override
  State<ReviewCandidatePage> createState() => _ReviewCandidatePageState();
}

class _ReviewCandidatePageState extends State<ReviewCandidatePage> {
  final TextEditingController firstNameController = TextEditingController(text: "Ernie");
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              // TODO: Handle Send Offer
            },
            child: const Text('Send Offer', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextField('First Name', firstNameController)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('Last Name', lastNameController)),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField('Email Address', emailController),
            const SizedBox(height: 20),
            _buildTextField('Phone Number', phoneController),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomButton('Cancel', Colors.lightBlueAccent, () {
                  Navigator.pop(context);
                }),
                _buildBottomButton('Save', Colors.pink.shade100, () {
                  // TODO: Save data
                }),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
