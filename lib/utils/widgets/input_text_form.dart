import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils.dart';

class BuildInputText extends StatefulWidget {
  final InputTextModel inputTextFormModel;

  BuildInputText(this.inputTextFormModel);

  @override
  _BuildInputTextState createState() => _BuildInputTextState();
}

class _BuildInputTextState extends State<BuildInputText> {
  RxBool _isShowButtonClear = false.obs;
  RxBool _showPassword = false.obs;

  @override
  void initState() {
    widget.inputTextFormModel.controller.addListener(() {
      if (widget.inputTextFormModel.controller.text.isNotEmpty) {
        _isShowButtonClear.value = true;
      }
    });
    _showPassword.value = widget.inputTextFormModel.obscureText;
    super.initState();
  }

  List<TextInputFormatter> getFormatters() {
    switch (widget.inputTextFormModel.inputFormatters) {
      case 1:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(
              widget.inputTextFormModel.maxLengthInputForm),
        ];
      case 2:
        return [
          TaxCodeFormatter(),
          FilteringTextInputFormatter.allow(RegExp(r"[0-9-]")),
          LengthLimitingTextInputFormatter(14),
        ];
      case 3:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-_\.]')),
        ];
      case 4:
        return [
          NumericTextFormatter(),
        ];
      default:
        return [
          LengthLimitingTextFieldFormatterFixed(
              widget.inputTextFormModel.maxLengthInputForm)
        ];
    }
  }

  Widget? _suffixIcon() {
    if (widget.inputTextFormModel.suffixIcon != null)
      return widget.inputTextFormModel.suffixIcon;
    if (!_isShowButtonClear.value || widget.inputTextFormModel.isReadOnly)
      return null;
    return widget.inputTextFormModel.obscureText
        ? GestureDetector(
            onTap: () {
              _showPassword.toggle();
            },
            child: Icon(
              _showPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.remove_red_eye_outlined,
              color: widget.inputTextFormModel.suffixColor ??
                  AppColors.textColor(),
            ),
          )
        : Visibility(
            visible: _isShowButtonClear.value &&
                !widget.inputTextFormModel.isReadOnly,
            child: GestureDetector(
              onTap: () {
                widget.inputTextFormModel.controller..clear();
                _isShowButtonClear.value = false;
              },
              child: Icon(
                Icons.clear,
                color: widget.inputTextFormModel.suffixColor ??
                    AppColors.textColor(),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        maxLines: widget.inputTextFormModel.maxLines,
        inputFormatters: getFormatters(),
        validator: widget.inputTextFormModel.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (v) {
          if (!_isShowButtonClear.value || v.isEmpty) {
            _isShowButtonClear.value = v.isNotEmpty;
          }
          widget.inputTextFormModel.onChanged?.call(v);
        },
        textInputAction: widget.inputTextFormModel.iconNextTextInputAction,
        style: TextStyle(
            color:
                widget.inputTextFormModel.textColor ?? AppColors.textColor()),
        controller: widget.inputTextFormModel.controller,
        obscureText: _showPassword.value,
        autofocus: widget.inputTextFormModel.autoFocus,
        focusNode: widget.inputTextFormModel.currentNode,
        keyboardType: widget.inputTextFormModel.textInputType,
        readOnly: widget.inputTextFormModel.isReadOnly,
        maxLength: widget.inputTextFormModel.maxLengthInputForm,
        onFieldSubmitted: (v) {
          if (widget.inputTextFormModel.iconNextTextInputAction.toString() ==
              TextInputAction.next.toString()) {
            FocusScope.of(context)
                .requestFocus(widget.inputTextFormModel.nextNode);

            widget.inputTextFormModel.onNext?.call(v);
          } else {
            widget.inputTextFormModel.submitFunc?.call(v);
          }
        },
        decoration: InputDecoration(
          counterText: widget.inputTextFormModel.isShowCounterText ? null : '',
          filled: true,
          fillColor:
              widget.inputTextFormModel.fillColor ?? AppColors.inputText(),
          hintStyle: TextStyle(
            fontSize: widget.inputTextFormModel.hintTextSize ??
                AppDimens.fontMedium(),
            color: widget.inputTextFormModel.hintTextColor ??
                AppColors.hintTextColor(),
          ),
          hintText: widget.inputTextFormModel.hintText,
          errorStyle: TextStyle(
            color: widget.inputTextFormModel.errorTextColor ??
                AppColors.errorText(),
          ),
          prefixIcon: widget.inputTextFormModel.iconLeading != null
              ? Icon(
                  widget.inputTextFormModel.iconLeading,
                  color: widget.inputTextFormModel.prefixIconColor ??
                      AppColors.hintTextColor(),
                  size: 20,
                )
              : null,
          prefixStyle:
              const TextStyle(color: Colors.red, backgroundColor: Colors.white),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(widget.inputTextFormModel.borderRadius),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(AppDimens.paddingSmall),
          suffixIcon: _suffixIcon(),
        ),
      ),
    );
  }
}
