import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_buddy/constants/common_style_constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dropdown_search/dropdown_search.dart';

class TextFieldWidget {
   selectionWithItemBuilder({
      String labelText = '',
      String helperText = '',
      TextStyle? helperStyle,
      required List<String> list,
      required void Function(String?) onChanged,
      required Function(String) onFieldSubmitted,
    }){
      return Container(
        decoration: BoxDecoration(
            boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: -10, // How much the shadow spreads
                blurRadius: 4, // Blur radius for the shadow
                offset: Offset(0, -7), // Shadow only below the container
              ),
                BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: -13, // How much the shadow spreads
                blurRadius: 4,
                offset: Offset(13, -6), // Shadow slightly offset to the bottom left
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: -13, // How much the shadow spreads
                blurRadius: 4,
                offset: Offset(-13, -6), // Shadow slightly offset to the bottom left
              ),
            ],
          ),
        child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                  );
                },
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                       
                      },
                    ),
                  ),
                ),
                // disabledItemFn: (String s) => s.startsWith('I'),
            ),
            items: list.length > 0 ? list : ['No item found...'],
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: kDropdownSearchDecorationAccountReg(
                  labelText: labelText,
                  fillColor: Colors.white,
                  borderSideColor: Colors.grey,
                  helperText:helperText,
                  helperStyle:helperStyle,
                ),
            ),
            onChanged: onChanged,
            selectedItem: list.length > 0 ? list[0] : 'No item found...',
        ),
      );
    }
    selectionWithBorder({
      String labelText = '',
      String helperText = '',
      TextStyle? helperStyle,
      required List<String> list,
      Widget? prefixIcon,
      required void Function(String?) onChanged,
      required Function(String) onFieldSubmitted,
    }){
      return Container(
        
        child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
                showSelectedItems: true,
                searchFieldProps: TextFieldProps(
                ),
                // disabledItemFn: (String s) => s.startsWith('I'),
            ),
            items: list.length > 0 ? list : ['No item found...'],
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: kDropdownSearchDecorationAccountReg(
                   prefixIcon: prefixIcon,
                  labelText: labelText,
                  fillColor: Colors.white,
                  borderSideColor: Colors.grey,
                  helperText:helperText,
                  helperStyle:helperStyle,
                  
                ),
            ),
            onChanged: onChanged,
            selectedItem: list.length > 0 ? list[0] : 'No item found...',
        ),
      );
    }
    textWithBorder({
      controller,
      String labelText = '',
      String helperText = '',
      TextStyle? helperStyle,
      required Function(String) onChanged,
      Future Function()? onTap,
      Widget? prefixIcon,
      bool? obscureText,
      bool readOnly = false,
      required Function(String) onFieldSubmitted,
      String? Function(String?)? validator, // Validator as a parameter
    }){
      return TextFormField(
        validator: (value) {
          // Use the provided validator if available, otherwise apply the default logic
          if (validator != null) {
            return validator(value);
          } else {
            return (value == null || value.isEmpty) ? 'This field is required.' : null;
          }
        },
        decoration: kTextFieldInputDecorationAccountReg(
          prefixIcon: prefixIcon,
          labelText: labelText,
          fillColor: Colors.white,
          borderSideColor: Colors.grey,
          helperText:helperText,
          helperStyle:helperStyle,
        ),
        // focusNode: usernameFocus,
        obscureText:obscureText??false,
        textInputAction: TextInputAction.next,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        onTap:onTap,
        readOnly: readOnly,
      );
    }

    dropdownWithBorder({
     required TextEditingController controller, // Marked as required
      String labelText = '',
      String helperText = '',
      TextStyle? helperStyle,
      required void Function(String?) onChanged, // Change to accept String?
      Future Function()? onTap,
      Widget? prefixIcon,
      bool? obscureText,
      required Function(String) onFieldSubmitted,
      String? Function(String?)? validator, // Validator as a parameter
      List<String> options = const [],
    }){
      return FormBuilderDropdown(
          name: "type",
          decoration: kTextFieldInputDecorationAccountReg(
            prefixIcon: prefixIcon,
            labelText: labelText,
            fillColor: Colors.white,
            borderSideColor: Colors.grey,
            helperText:helperText,
            helperStyle:helperStyle,
          ),
          initialValue: controller.text,
          onChanged: onChanged,
          // onTap:onTap,
          items: options
              .map((type) => DropdownMenuItem(
              value: type, child: Text("$type")))
              .toList(),
        );
    }
    dropdownSearchWithBorder({
      TextEditingController? controller, // Marked as required
      String labelText = '',
      String helperText = '',
      TextStyle? helperStyle,
      Future Function()? onTap,
      Widget? prefixIcon,
      bool? obscureText,
      required Function(String) onFieldSubmitted,
      String? Function(String?)? validator, // Validator as a parameter
      List<dynamic> options = const [],
      String Function(dynamic)? itemAsString,
      void Function(dynamic)? onChanged,
      dynamic  selectedItem,
    }){
      return Container(
          constraints: const BoxConstraints(
              maxWidth: 370.0, minHeight: 10.0),
          child: DropdownSearch(
            selectedItem: selectedItem,
            dropdownDecoratorProps:
                DropDownDecoratorProps(
              dropdownSearchDecoration:
                  kTextFieldInputDecorationAccountReg(
                labelText: labelText,
                // prefixIcon:const Icon(Icons.type_specimen_outlined),
                prefixIcon:prefixIcon,
                fillColor: Colors.white,
              ),
            ),
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      if(controller != null){
                        controller.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
            items: options,
            itemAsString:itemAsString,
            onChanged: onChanged,
          ));
    }
}