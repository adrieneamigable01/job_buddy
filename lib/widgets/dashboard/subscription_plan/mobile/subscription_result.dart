import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionResultPage extends StatelessWidget {
  final String status;

  const SubscriptionResultPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isSuccess = status.toLowerCase() == 'success';

    return Scaffold(
      backgroundColor: isSuccess
          ? Colors.greenAccent.shade100
          : Colors.redAccent.shade100,
      appBar: AppBar(
        backgroundColor:
            isSuccess ? Colors.greenAccent.shade400 : Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          isSuccess ? 'Subscription Success' : 'Subscription Cancelled',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 100,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                isSuccess
                    ? 'You are now subscribed!'
                    : 'Subscription was cancelled.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isSuccess
                    ? 'Thank you for subscribing to JobBuddy premium services.'
                    : 'You have canceled the subscription process.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.dashboard),
                label: const Text('Go to Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
