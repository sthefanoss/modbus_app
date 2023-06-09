import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modbus_app/controllers/test_controller.dart';
import 'package:modbus_app/pages/components/terminal_tab.dart';

import '../../controllers/communication_controller.dart';
import '../../utils/test_form.dart';
import '../decorated_dropdownButton.dart';
import '../home_page.dart';

class TestTab extends StatefulWidget {
  const TestTab({super.key});

  @override
  State<TestTab> createState() => _TestTabState();
}

class _TestTabState extends State<TestTab> {
  final testController = TestController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TestController.instance,
      builder: (c, w) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: testController.tests.length,
                reverse: true,
                itemBuilder: (_, index) => TestCard(
                  test: testController.tests[index],
                  remove: TestController.instance.removeTest,
                  play: (t) async {
                    try {
                      await TestController.instance.run(t);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (c) => SimpleDialog(
                          title: Text("Erro ao enviar mensagem!"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.toString()),
                            )
                          ],
                        ),
                      );
                      rethrow;
                    }
                  },
                  edit: (t) {
                    TestForm(
                      onSaved: (tt) =>
                          TestController.instance.editTest(index, tt),
                      test: t,
                    ).show(context);
                  },
                  copy: (t) {
                    TestForm(
                      onSaved: TestController.instance.addTest,
                      test: t,
                      isCopyMode: true,
                    ).show(context);
                  },
                  index: index,
                  isLast: index == testController.tests.length - 1,
                  reorder: TestController.instance.reorder,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    TestForm(
                      onSaved: TestController.instance.addTest,
                    ).show(context);
                  },
                  child: Text("Novo teste"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedBuilder(
                  animation: CommunicationController.instance,
                  builder: (_, __) => ElevatedButton(
                    onPressed: CommunicationController.instance.isLoading
                        ? null
                        : submitAll,
                    child: const Text("Rodar testes"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitAll() async {
    TestController.instance.resetTests();
    try {
      for (final test in TestController.instance.tests) {
        await TestController.instance.run(test);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (c) => SimpleDialog(
          title: Text("Erro ao enviar mensagem!"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.toString()),
            )
          ],
        ),
      );
    }
  }
}

class TestCard extends StatelessWidget {
  const TestCard({
    required this.test,
    required this.remove,
    required this.play,
    required this.edit,
    required this.index,
    required this.reorder,
    required this.isLast,
    required this.copy,
    super.key,
  });

  final Test test;

  final ValueChanged<Test> remove;

  final ValueChanged<Test> play;

  final ValueChanged<Test> edit;

  final ValueChanged<Test> copy;

  final void Function(int index, int newPosition) reorder;

  final int index;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      const breakpoint = 300;
      return ListTile(
        leading: constraints.maxWidth > breakpoint
            ? CircleAvatar(child: Text('${index + 1}'))
            : null,
        trailing: constraints.maxWidth > 300
            ? SizedBox(
                width: 340,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => play(test),
                      icon: Icon(
                        test.response == null
                            ? Icons.play_arrow_outlined
                            : Icons.play_arrow,
                        color: test.response == null
                            ? Colors.blueGrey
                            : test.expect == test.response
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    SizedBox(width: 24),
                    IconButton(
                      onPressed: () => edit(test),
                      icon: Icon(Icons.edit),
                      color: Colors.amber,
                    ),
                    SizedBox(width: 24),
                    IconButton(
                      onPressed: () => copy(test),
                      icon: Icon(Icons.copy),
                      color: Colors.amber,
                    ),
                    SizedBox(width: 24),
                    IconButton(
                      onPressed:
                          index == 0 ? null : () => reorder(index, index - 1),
                      icon: Icon(Icons.arrow_circle_down),
                      color: Colors.blue,
                    ),
                    IconButton(
                        onPressed:
                            isLast ? null : () => reorder(index, index + 1),
                        color: Colors.blue,
                        icon: Icon(Icons.arrow_circle_up_outlined)),
                    SizedBox(width: 24),
                    IconButton(
                      onPressed: () => remove(test),
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              )
            : null,
        title: SelectableText(
          'Descrição: ${test.name}',
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectableText(
              'Requisição: ${test.request}',
              maxLines: 1,
            ),
            SelectableText(
              'Resposta esperada: ${test.expect}',
              maxLines: 1,
            ),
            if (test.response != null)
              SelectableText(
                'Resposta: '
                '${test.response!.isEmpty ? "Sem resposta" : test.response!}',
                maxLines: 1,
              ),
          ],
        ),
      );
    });
  }
}
