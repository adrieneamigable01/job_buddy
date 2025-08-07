import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> kDropDownActionButtonItemMenuOrders = [
  'View',
  'Approve',
  // 'Disapprove',
];

List<dynamic> kDropDownActionButtonItemMenuIconOrders = [
  FontAwesomeIcons.eye,
  FontAwesomeIcons.thumbsUp,
  // FontAwesomeIcons.thumbsDown,
];


List<String> kDropDownActionButtonItemMenuProduct = [
  'View',
  'Update',
  // 'Delete',
];

List<dynamic> kDropDownActionButtonItemMenuIconProduct = [
  FontAwesomeIcons.eye,
  FontAwesomeIcons.pencil,
  FontAwesomeIcons.trash,
];



List<String> kDropDownActionButtonItemMenu = [
  'Update',
  // 'Delete',
];

List<dynamic> kDropDownActionButtonItemMenuIcon = [
  FontAwesomeIcons.pencil,
];


List<String> kStockDropDownActionButtonItemMenu = [
  'Update',
  'Stock Quantity',
  // 'Delete',
];

List<dynamic> kStockDropDownActionButtonItemMenuIcon = [
  FontAwesomeIcons.pencil,
  FontAwesomeIcons.plus,
];

List<String> kDropDownActionButtonItemMenuSubNoDelete = [
  'View',
  'Update',
];

List<String> kDropDownActionButtonItemMenuSub = [
  'View',
  'Update',
  // 'Delete',
];

List<dynamic> kDropDownActionButtonItemMenuIconSub = [
  FontAwesomeIcons.eye,
  FontAwesomeIcons.pencil,
  FontAwesomeIcons.trash,
];


List<String> kDropDownActionButtonAppBar = [
  'Profile',  
  'Logout',
];

List<dynamic> kDropDownActionButtonAppBarIcon = [
  FontAwesomeIcons.person,
  FontAwesomeIcons.powerOff,
];

// List kPaymentTypeService = ["Delivery","Pick up"];
List kPaymentTypeService = ["Pick up"];

// List<dynamic> kPaymentMethod = ["GCASH","PALAWAN","Cebuana","Western Union"];

// List<dynamic> kPaymentMethodImages = ["assets/images/gcash-logo-2.png","assets/images/palawan-express-logo.png","assets/images/cl_logo.png","assets/images/Western_Union_logo.png"];
  

List<dynamic> kPaymentMethod = [
  { 
    "method":"GCASH",
    "image":"assets/images/gcash-logo-2.png"
  },
  { 
    'method':'PALAWAN',
    'image':'assets/images/palawan-express-logo.png'
  },
  { 
    'method':'Cebuana',
    'image':'assets/images/cl_logo.png'
  },
  { 
    'method':'Western Union',
    'image':'assets/images/Western_Union_logo.png'
  }
];