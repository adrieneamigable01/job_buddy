import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/dashboard/dashboard_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/widgets/auth/login_mobile_portrait.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isFirstLoadFlag = true;
final UserBox _userBox = UserBox();
final SubscriptionBox _subscriptionBox = SubscriptionBox();
final SubscriptionPlanBox _subscriptionPlanBox = SubscriptionPlanBox();
TextEditingController _searchKey = TextEditingController(text: "All");

class SubscriptionMobilePortrait extends StatefulWidget {
  const SubscriptionMobilePortrait({super.key});

  @override
  State<SubscriptionMobilePortrait> createState() => _SubscriptionMobilePortraitState();
}

class _SubscriptionMobilePortraitState extends State<SubscriptionMobilePortrait> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffB5E5E6),
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.go('/dashboard');
                },
              ),
              const Spacer(),
              const Text('Subscription', textAlign: TextAlign.center),
              const Spacer(),
              const SizedBox(), // Placeholder for future buttons
            ],
          ),
          elevation: 0,
          backgroundColor: const Color(0xffB5E5E6),
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Your Current Plan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Plan", _subscriptionPlanBox.getSubscription(_subscriptionBox.data.planId).first.planName.toString()),
                    _buildInfoRow("Status", "Active"),
                    _buildInfoRow("Renewal Date", _subscriptionBox.data.endDate.toString() ),
                    _buildInfoRow("Monthly Fee", _subscriptionPlanBox.getSubscription(_subscriptionBox.data.planId).first.price.toString()),
                    _buildInfoRow("Features", "- ${_subscriptionPlanBox.getSubscription(_subscriptionBox.data.planId).first.description.toString()}"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(minWidth: 300.0, maxWidth: 300.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: const Color(0xffE6D2DB),
                ),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    // Navigate to subscription upgrade or cancellation
                    context.go('/subscription_plan');
                  },
                  child: const Text(
                    "Manage Subscription",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff1F94D4),
                      backgroundColor: Color(0xffE6D2DB),
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 5),
          Text(
            info,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
