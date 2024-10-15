import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../validators/string_validator.dart';

class TextFieldValidated extends StatefulWidget {
  const TextFieldValidated(
      {super.key,
      this.keyboardType = TextInputType.text,
      this.textAlign = TextAlign.center,
      this.hintLabel = 'Enter the zip code',
      this.submitLabel = 'Submit',
      required this.textFieldStyle,
      this.inputFormatter,
      this.submitValidator,
      required this.onSubmit, required this.onUnselected});

  final TextInputType keyboardType;
  final TextAlign textAlign;
  final String hintLabel;
  final TextStyle textFieldStyle;
  final String submitLabel;
  final TextInputFormatter? inputFormatter;
  final StringValidator? submitValidator;
  final ValueChanged<String> onSubmit;
  final void Function() onUnselected;

  @override
  State<TextFieldValidated> createState() => _TextFieldValidatedState();
}

class _TextFieldValidatedState extends State<TextFieldValidated> {
  final _focusNode = FocusNode();
  String _value = '';
  bool submited = false;

  bool get isValid => widget.submitValidator?.isValid(_value) ?? true;

  late TextEditingController controler = TextEditingController();

  @override
  void initState() {
    controler = TextEditingController();
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
        hintText: widget.hintLabel,
      ),
      textInputAction: TextInputAction.done,
      focusNode: _focusNode,
      inputFormatters: widget.inputFormatter != null
          ? [
              widget.inputFormatter!,
            ]
          : null,
      onChanged: (value) {
        setState(() {
          _value = value;
          if (submited) {
            submited = false;
            widget.onUnselected();
          }
        });
      },
      onEditingComplete: _submit,
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return Visibility(
      visible: isValid && !submited,
      child: Container(
        constraints:
            BoxConstraints.expand(width: double.infinity, height: 60.0),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green[400])),
          onPressed: _submit,
          child: Text(widget.submitLabel, style: TextStyle(fontSize: 20.0)),
        ),
      ),
    );
  }

  void _submit() async {
    if (isValid) {
      _focusNode.unfocus();
      submited = true;
      widget.onSubmit(_value);
    } else {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }
}
