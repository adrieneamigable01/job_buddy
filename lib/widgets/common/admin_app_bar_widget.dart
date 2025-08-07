import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:job_buddy/constants/dropdown_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';

final _authCubit = AuthCubit();
AlertDialogWidget alertDialog = AlertDialogWidget();

class AdminAppBar extends StatelessWidget  {
  const AdminAppBar({super.key});
  

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      // title: const Text('Brand List'),
      backgroundColor: Color(0xff1F5C9B),
      actions: [
        BlocProvider(
          create: (context) => _authCubit,
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              
                if(state is LoadingAuthState){
                  if(state.isLoading){
                    alertDialog.showLoadingDialog(context: context, onPressed: (){

                    });
                  }else{
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }

                if (state is LogoutState){
                  context.push("/");
                }
                

            },
            child: Container(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    FontAwesomeIcons.bars,
                    size: 25,
                    color: Colors.black,
                  ),
                  items: kDropDownActionButtonAppBar
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Row(
                            children: [
                              Icon(
                                kDropDownActionButtonAppBarIcon[
                                    kDropDownActionButtonAppBar.indexOf(item)],
                                color: Colors.blue.shade800,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )))
                      .toList(),
                  onChanged: (newValue) {
                    // int index = kDropDownActionButtonItemMenu
                    //     .indexOf(newValue.toString());

                    if (newValue == "Logout") {
                      // _authCubit.logout();
                    }
                  },
                  // itemHeight: 48,
                  // itemPadding: const EdgeInsets.only(left: 16, right: 16),
                  // dropdownWidth: 160,
                  // dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                  // // dropdownDecoration: BoxDecoration(
                  // //   borderRadius: BorderRadius.circular(4),
                  // //   color: Colors.redAccent,
                  // // ),
                  // dropdownElevation: 8,
                  // offset: const Offset(0, 8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  
}