import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPressed;

  const SettingRow(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 18,
                width: 18,
                fit: BoxFit.contain,
                color: AppColors.secondaryColor1,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Image.asset(
                "assets/icons/p_next.png",
                height: 12,
                width: 12,
                fit: BoxFit.contain,
                color: AppColors.secondaryColor1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
