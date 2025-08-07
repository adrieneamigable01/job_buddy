import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/subscription/subscription_cubit.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:http/http.dart' as http;
import 'package:job_buddy/widgets/dashboard/subscription_plan/mobile/paypall_webview.dart';

bool isFirstLoadFlag = true;
final UserBox _userBox = UserBox();
final SubscriptionPlanBox _subscriptionPlanBox = SubscriptionPlanBox();
final SubscriptionBox _subscriptionBox = SubscriptionBox();
final alertDialog = AlertDialogWidget();
List<Color> colors = [
  Colors.blue[100]!,
  Colors.green[100]!,
  Colors.purple[100]!,
  Colors.orange[100]!,
];

class SubscriptionPlanMobilePortrait extends StatelessWidget {
  const SubscriptionPlanMobilePortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) async {
        if (state is SuccessSubscriptionState) {
          alertDialog.showConfirmDialog(
            isError: false,
            title: 'Success',
            content: state.successMessage,
            onPressCancel: () {
              context.push('/subscription_plan');
            },
            onPressedConfirm: () async {
              context.go('/subscription');
            },
            context: context,
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffB5E5E6),
          appBar: AppBar(
            title: const Text("Choose Your Subscription"),
            backgroundColor: const Color(0xffB5E5E6),
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.push('/dashboard'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _subscriptionPlanBox.items.isEmpty
                ? const Center(child: Text("No Subscription Plan"))
                : ListView.separated(
                    itemCount: _subscriptionPlanBox.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final plan = _subscriptionPlanBox.items[index];
                     final isSubscribed = _userBox.data!.alreadySubscribe ?? false;
                     print("plan.id: ${plan.id}");
                     print("isSubscribed: ${_userBox.data!.alreadySubscribe}");
                      return !isSubscribed 
                      ? 
                        _buildPlanCard(
                          context: context,
                          id: plan.id,
                          plan_id: plan.planId,
                          title: plan.planName ?? '',
                          price: plan.price ?? '',
                          features: plan.description ?? '',
                          color: colors[index % colors.length],
                        ) 
                      : plan.id != "4" 
                      ? _buildPlanCard(
                          context: context,
                          id: plan.id,
                          plan_id: plan.planId,
                          title: plan.planName ?? '',
                          price: plan.price ?? '',
                          features: plan.description ?? '',
                          color: colors[index % colors.length],
                        )
                      :
                      const SizedBox(); // or null, depending on context
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required dynamic id,
    required dynamic plan_id,
    required String title,
    required String price,
    required String features,
    Color? color,
  }) {
    bool isCurrentSubscription = _subscriptionBox.isEmpty
        ? false
        : _subscriptionBox.data.planId == plan_id;

    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("₱$price",
              style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 12),
          Text(features,
              style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 20),
          isCurrentSubscription
              ? const Center(
                  child: Text(
                    "Current Plan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1,
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (title == "Free") {
                        BlocProvider.of<SubscriptionCubit>(context)
                            .subscribe(plan_id: plan_id);
                        return;
                      } else {
                        final userId = _userBox.data.userId;
                        final planId =
                            plan_id; // Replace with actual planId per plan
                        Uri backendSubscribeUri = Uri.parse(
                            "http://$kProductionDomain/job_buddy_api_repo/paypal/subscription/subscribe?user_id=$userId&plan_id=$planId");
                        print("backendSubscribeUri : ${backendSubscribeUri}");
                        final response = await http.get(backendSubscribeUri);

                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final links = data['links'] as List<dynamic>;
                          final approveLink = links.firstWhere(
                            (link) => link['rel'] == 'approve',
                            orElse: () => null,
                          );

                          if (approveLink != null) {
                            Uri approvalUrl = Uri.parse(approveLink['href']);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaypalWebViewPage(
                                      approvalUrl: approvalUrl.toString()),
                                ),
                              );
                            }
                          } else {
                            print("No approve link found");
                          }
                        } else {
                          print("Backend error: ${response.statusCode}");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Pay with PayPal"),
                  ),
                ),
        ],
      ),
    );
  }
}
