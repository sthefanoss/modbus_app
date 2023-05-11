import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/test_controller.dart';
import '../pages/components/terminal_tab.dart';

class TestForm extends StatefulWidget {
  const TestForm({
    this.test,
    required this.onSaved,
    super.key,
    this.isCopyMode = false,
  }) : assert(!isCopyMode || (isCopyMode && test != null));

  final Test? test;
  final bool isCopyMode;
  final Future<void> Function(Test) onSaved;

  void show(BuildContext context) {
    showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (c) => this,
    );
  }

  @override
  State<TestForm> createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final requestTextController = TextEditingController();
  final resultTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.test != null) {
      requestTextController.text = widget.test!.request;
      nameTextController.text = widget.test!.name;
      resultTextController.text = widget.test!.expect;
    }
    super.initState();
  }

  @override
  void dispose() {
    requestTextController.dispose();
    resultTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  void submit() async {
    if (!key.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    await widget.onSaved(Test(
      name: nameTextController.text,
      request: requestTextController.text,
      expect: resultTextController.text,
    ));
    navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (c) => Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.test != null && !widget.isCopyMode? "Editar teste" : "Criar teste",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: submit,
                        icon: Icon(Icons.save),
                      ),
                      SizedBox(width: 32),
                      IconButton(
                        onPressed: Navigator.of(context).maybePop,
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: nameTextController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text('Descrição'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: requestTextController,
                    textInputAction: TextInputAction.next,
                    // onEditingComplete: send,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'\d|[a-fA-F]'),
                      ),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                          composing: newValue.composing,
                        ),
                      ),
                    ],
                    validator: (v) {
                      if (v?.isEmpty == true) return "Campo obrigatório";
                      final lint = lintVerifications(v!);
                      if (lint != null) return lint;
                      if (v.length % 2 != 0)
                        return "Quantidade inválida de símbolos";
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Requisição'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: resultTextController,
                    textInputAction: TextInputAction.next,
                    // onEditingComplete: send,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'\d|[a-fA-F]'),
                      ),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                          composing: newValue.composing,
                        ),
                      ),
                    ],
                    validator: (v) {
                      if (v?.isEmpty == true) return "Campo obrigatório";
                      // final lint = lintVerifications(v!);
                      // if (lint != null) return lint;
                      if (v!.length % 2 != 0)
                        return "Quantidade inválida de símbolos";
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Resposta esperada'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
