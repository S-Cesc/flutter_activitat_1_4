import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../validators/string_validator.dart';

class TextFieldValidated extends StatefulWidget {
  const TextFieldValidated(
      {super.key,
      this.keyboardType = TextInputType.text,
      this.textAlign = TextAlign.center,
      this.hintText = 'Enter the zip code',
      required this.textFieldStyle,
      required this.submitText,
      this.inputFormatter,
      this.submitValidator,
      required this.onSubmit});

  final TextInputType keyboardType;
  final TextAlign textAlign;
  final String hintText;
  final TextStyle textFieldStyle;
  final String submitText;
  final TextInputFormatter? inputFormatter;
  final StringValidator? submitValidator;
  final ValueChanged<String> onSubmit;

  @override
  State<TextFieldValidated> createState() => _TextFieldValidatedState();
}

class _TextFieldValidatedState extends State<TextFieldValidated> {
  final _focusNode = FocusNode();
  String _value = '';

  late TextEditingController controler = TextEditingController();
  late bool isValid;

  @override
  void initState() {
    controler = TextEditingController();
    isValid = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(child: _buildTextField()),
        ),
        //Expanded(child: Container()),
        _buildDoneButton(context),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controler.dispose();
    super.dispose();
  }

  Widget _buildTextField() {
    return TextField(
      style: widget.textFieldStyle,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      autofocus: true,
      autocorrect: false,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: controler.text.isEmpty
                    ? Colors.blueGrey
                    : isValid
                        ? Colors.green
                        : Colors.red)),
        hintText: widget.hintText,
      ),
      textInputAction: TextInputAction.done,
      focusNode: _focusNode,
      inputFormatters: widget.inputFormatter != null
          ? [
              widget.inputFormatter!,
            ]
          : null,
      onChanged: (value) {
        setState(() => _value = value);
      },
      onEditingComplete: _submit,
      // onSubmitted: (String value) async {
      //   getHttpInfo(_selectedCountry!.code, value);
      // },
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    bool valid = widget.submitValidator?.isValid(_value) ?? true;
    return Opacity(
      opacity: valid ? 1.0 : 0.0,
      child: Container(
        constraints:
            BoxConstraints.expand(width: double.infinity, height: 60.0),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green[400])),
          onPressed: _submit,
          child: Text(widget.submitText, style: TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }

  void _submit() async {
    bool valid = widget.submitValidator?.isValid(_value) ?? true;
    if (valid) {
      _focusNode.unfocus();
      widget.onSubmit(_value);
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
