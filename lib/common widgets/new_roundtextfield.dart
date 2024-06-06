import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class NewRoundTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextInputType textInputType;
  final bool isObscureText;
  final Widget? rightIcon;

  const NewRoundTextField(
      {Key? key,
      this.textEditingController,
      this.validator,
      this.onChanged,
      required this.hintText,
      required this.textInputType,
      this.isObscureText = false,
      this.rightIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightGrayColor,
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: isObscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelText: hintText,
            suffixIcon: rightIcon,
            hintStyle: TextStyle(fontSize: 12, color: AppColors.grayColor)),
        validator: validator,
      ),
    );
  }
}
