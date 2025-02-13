import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pctest/panes/editor_pane.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: FluentThemeData(
          selectionColor: material.Color.fromARGB(73, 0, 60, 255)),
      locale: Locale("ar", "eg"),
      title: 'quilltest',
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedindex = 0;
  PaneDisplayMode paneDisplayMode = PaneDisplayMode.compact;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: Text("nav app bar"),
        leading: Text("leading appbar"),
      ),
      pane: NavigationPane(
        selected: selectedindex,
        onChanged: (value) {
          setState(
            () {
              selectedindex = value;
            },
          );
        },
        displayMode: paneDisplayMode,
        items: [
          editorPaneItem,
        ],
        size: NavigationPaneSize(openWidth: 150, compactWidth: 50),
      ),
    );
  }
}
