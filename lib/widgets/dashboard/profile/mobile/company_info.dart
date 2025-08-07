import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/dashboard/dashboard_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/widgets/auth/login_mobile_portrait.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isFirstLoadFlag = true;
final UserBox _userBox = UserBox();
final CompanyBox _companyBox = CompanyBox();
TextEditingController _searchKey = TextEditingController(text: "All");

class CompanyInfoMobilePortrait extends StatefulWidget {
  CompanyInfoMobilePortrait({super.key});

  @override
  State<CompanyInfoMobilePortrait> createState() => _CompanyInfoMobilePortraitState();
}

class _CompanyInfoMobilePortraitState extends State<CompanyInfoMobilePortrait> {

  final formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  var imageByte;
  late Timer _timer;
  var fullDateFormat = DateFormat('EEEE, MMMM d, yyyy HH:mm:ss');
  String formattedDate = "";
  String phoneNumber = '';
  String type = "search_ticket";
  final TextEditingController _imageController = TextEditingController();
   


  @override
  Widget build(BuildContext context) {
    _onItemTapped(int index) {
      if (index == 3) {
        BlocProvider.of<DashboardCubit>(context).logout();
      }
    }

    DateTime parseTime(String timeStr) {
      // Parse the time string into a DateTime object
      final format = DateFormat.jm(); // Use the intl package to parse "2:30 PM"
      return format.parse(timeStr);
    }

    void _showUpdateProfileImageDialog(
      BuildContext context, String currentImageUrl) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Profile Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment
                      .bottomRight, // Aligns the pen icon to the bottom-right corner
                  children: [
                     BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              dynamic image = '';
                              // dynamic image = UserBox().data.profileImage;
                              if(state is SetProfileImage){
                                print("state.image : ${state.imageByte}");
                                  image = state.imageByte.toString();
                              }
                              return image == '' ?
                                CircleAvatar(
                                  backgroundImage: NetworkImage('https://picsum.photos/300/300'), // Replace with user profile image
                                )
                                : ClipOval(
                                  child: Image.memory(
                                    base64.decode(image),
                                    fit: BoxFit
                                        .cover, // Adjusts how the image fits in the widget
                                    width: 100, // Set the width of the image
                                    height: 100, // Set the height of the image
                                  )
                              );
                            },
                          ),
                    Positioned(
                      right: -8, // Adjust as needed for spacing from the edge
                      bottom: -12, // Adjust as needed for spacing from the edge
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final XFile? pickedImage = await _picker.pickImage(
                              // maxWidth: 150,
                              // maxHeight: 150,
                              source: ImageSource.gallery);
                          if (pickedImage != null) {
                            Uint8List imageByte = await pickedImage.readAsBytes();
                            String base64Image = base64Encode(imageByte); // Convert to base64 string
                            _imageController.text = base64Image;
                            // BlocProvider.of<ProfileCubit>(context).changeImage(base64Image);
                            // _productCubit.changeProductImage(
                            //     imageByte: imageByte);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Choose a method to update your profile image:'),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Update'),
                onPressed: () {
                  Object payload = {
                    'user_id': UserBox().data.userId.toString(),
                    'image':_imageController.text
                  };
                  // BlocProvider.of<ProfileCubit>(context).updateProfileImage(payload);
                    
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
        child: Scaffold(
        resizeToAvoidBottomInset: true,  
        backgroundColor: Color(0xffB5E5E6),
              appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go('/dashboard');
              },
            ),
            Spacer(),
            Text('Company \n Information',textAlign: TextAlign.center,),
            Spacer(),
            // Notifications
            SizedBox()
          ],
        ),
        elevation: 0,
        backgroundColor: Color(0xffB5E5E6),
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Hide the leading back button
              ),
              body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is LoadingUpdateImageState) {
                if (state.isLoading) {
                  alertDialog.showLoadingDialog(context: context, onPressed: () {});
                }
              }
        
              if (state is FailureUpdateImageState) {
                  Navigator.of(context, rootNavigator: true).pop();
                  alertDialog.showAlertDialog(
                      isError: state.isError,
                      title: 'Error Update Profile Image',
                      content: state.errorMessage,
                      onPressed: (){
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      context: context);
              }
        
              if (state is SuccessUpdateImageProfileState) {
                
                Navigator.of(context, rootNavigator: true).pop();
                alertDialog.showAlertDialog(
                    isError: state.isError,
                    title: 'Success Update Profile Image',
                    content: state.successMessage,
                    onPressed: (){
                      context.push('/profile');
                    },
                    context: context
                );
              }
            }
          ),
          BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoadingAuthState) {
                  if (state.isLoading) {
                    alertDialog.showLoadingDialog(context: context, onPressed: () {});
                  }
                }
        
                if (state is FailureLogoutState) {
                    Navigator.of(context, rootNavigator: true).pop();
                    alertDialog.showAlertDialog(
                        isError: state.isError,
                        title: 'Error Logout',
                        content: state.errorMessage,
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        context: context);
                }
        
                if (state is SuccessLogoutAuthState) {
                  Navigator.of(context, rootNavigator: true).pop();
                  context.push('/splash');
                }
              },
            ),
        ],
        child:Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Profile Image
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the column vertically
                      children: [
                        _userBox.data.profileImage == "" ||_userBox.data.profileImage == null?
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://picsum.photos/300/300'), // Replace with user profile image
                        )
                          :
                        ClipOval(
                            child: Image.memory(
                              base64.decode(_userBox.data.profileImage??''),
                              fit: BoxFit
                                  .cover, // Adjusts how the image fits in the widget
                              width: 200, // Set the width of the image
                              height: 200, // Set the height of the image
                            )
                        ),
                        const SizedBox(
                            height:
                                8), // Add some spacing between the avatar and text
                        GestureDetector(
                          onTap: () {
                            // _showUpdateProfileImageDialog(
                            //     context,_userBox.data.profileImage??'');
                          },
                          child: Text(
                            "${_userBox.data.firstname ?? ''} ${_userBox.data.middlename ?? ''} ${_userBox.data.lastname ?? ''} \n ${_userBox.data.email ?? ''}",
                            style: TextStyle(
                              fontSize: 14, // Adjust the font size as needed
                              color: Colors.black, // Blue color for the text
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 30), // Space between image and text
                    
                    Visibility(
                      visible: _userBox.data.usertype == "employer",
                      child:Column(
                        children:[
                          Text("Company Information"),
                          // Name with Arrow
                          _buildInfoRow("Company name",
                              "${_companyBox.data.companyName ?? ''}"),
                          SizedBox(height: 10), // Space between name and email
                          _buildInfoRow("Company Address",
                              "${_companyBox.data.companyAddress ?? ''}"),
                          SizedBox(height: 10), // Space between name and email
                          _buildInfoRow("Company Contact",
                              "${_companyBox.data.contactNumber ?? ''}"),
                          SizedBox(height: 10), // Space between name and email
                          _buildInfoRow("Company Email",
                              "${_companyBox.data.email ?? ''}"),
                          SizedBox(height: 10), // Space between name and email
                          _buildInfoRow("Extablished Date",
                              "${_companyBox.data.establishedDate ?? ''}"),
                          SizedBox(height: 10), // Space between name and email
                        ]
                      )
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Handle edit profile image click
                    //     context.push('/profile_update');
                    //   },
                    //   child: Text(
                    //     'Edit Profile', // Text under the avatar
                    //     style: TextStyle(
                    //       fontSize: 14, // Adjust the font size as needed
                    //       color: Color(0xff0D99FF), // Blue color for the text
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 15),
                    Container(
                      constraints: const BoxConstraints(
                          minWidth: 300.0,
                          maxWidth: 300.0,
                          minHeight: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Color(0xffE6D2DB)
                      ),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed:
                              () {
                              BlocProvider.of<AuthCubit>(context).logout();
                            },
                        child: const Text(
                          "Logout",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff1F94D4),
                            backgroundColor: Color(0xffE6D2DB),
                            fontSize: 20.0,
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
              ),
            ));
  }

  
  
}

Widget _buildInfoRow(String label, String info, [Widget? action]) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black, // Adjust color as needed
          width: 1.0, // Thickness of the border
        ),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${label} :",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                info,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


