import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/widgets/onboarding/small_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';

class PhoneNumberCollector extends StatelessWidget {
  const PhoneNumberCollector({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.black87),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      width: double.infinity,
      height: 55,
      child: Row(
        children: [
          CountryCodePicker(
            dialogSize: const Size(double.infinity, 250.0),
            showFlag: false,
            showFlagDialog: true,
            textStyle: kButtonText,
            padding: const EdgeInsets.all(1),
            initialSelection: 'CA',
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              cursorWidth: 2,
              inputFormatters: [
                PhoneFormatter(seperator: ' ', sample: 'xxx xxx xxxx'),
                LengthLimitingTextInputFormatter(16)
              ],
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: ' Phone number',
                hintStyle: kHintStyle,
                border: InputBorder.none,
              ),
            ),
          ),
          SmallIconButton(
            onTap: onTap,
            icon: Icons.send,
          )
        ],
      ),
    );
  }
}
