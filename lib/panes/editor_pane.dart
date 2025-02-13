import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:io';
import 'package:flutter/services.dart';

final editorPaneItem = PaneItem(
    icon: Icon(material.Icons.edit),
    title: Text("editor section"),
    body: editorpanebody());

class editorpanebody extends StatefulWidget {
  const editorpanebody({super.key});

  @override
  State<editorpanebody> createState() => _editorpanebodyState();
}

class _editorpanebodyState extends State<editorpanebody> {
  QuillController _quillcontroller = QuillController.basic();

  @override
  void dispose() {
    _quillcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: const Color.fromARGB(255, 239, 239, 239),
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: _quillcontroller,
            configurations: QuillSimpleToolbarConfigurations(
              showAlignmentButtons: true,
              showLineHeightButton: true,
              fontFamilyValues: {
                "calibri": "calibri",
                "Rubik": "Rubik",
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: QuillEditor.basic(
                focusNode: FocusNode(
                  onKey: (foc, event) {
                    // print("event = $event");

                    // print("char = ${event.character}");
                    // print("physical key = ${event.physicalKey}");
                    // print(
                    //     "control =  ${HardwareKeyboard.instance.isControlPressed}");
                    final numberpressed = event.logicalKey.keyLabel;
                    if ((numberpressed == "1" ||
                            numberpressed == "2" ||
                            numberpressed == "3") &&
                        HardwareKeyboard.instance.isControlPressed) {
                      print(numberpressed);
                      switch (numberpressed) {
                        case "1":
                          _quillcontroller
                              .formatSelection(ColorAttribute("black"));
                        case "2":
                          _quillcontroller
                              .formatSelection(ColorAttribute("red"));
                        case "3":
                          _quillcontroller
                              .formatSelection(ColorAttribute("blue"));
                      }

                      return KeyEventResult.handled;
                    }
                    // _quillcontroller.formatTextStyle(
                    //     _quillcontroller.selection.baseOffset,
                    //     0,
                    //     Style.fromJson({'color': '#fcba03', 'size': 24.0}));
                    // print(_quillcontroller.getSelectionStyle().attributes);

                    return KeyEventResult.ignored;
                  },
                ),
                controller: _quillcontroller,
                configurations: QuillEditorConfigurations(),
                scrollController: ScrollController(),
              ),
            ),
          ),
          Button(
            child: Text("save"),
            onPressed: () async {
              final appdirdoc = await getApplicationDocumentsDirectory();
              final json =
                  jsonEncode(_quillcontroller.document.toDelta().toJson());
              print(appdirdoc.path);
              print(json);
              File jsonfile = File("${appdirdoc.path}/assets/test1.json");
              await jsonfile.writeAsString(json);
            },
          ),
          Button(
            child: Text("load"),
            onPressed: () async {
              final appdirdoc = await getApplicationDocumentsDirectory();
              final jsonfile = File("${appdirdoc.path}/assets/test1.json");
              final content = await jsonfile.readAsString();
              final json = await jsonDecode(content);
              print(appdirdoc.path);
              print(json);
              _quillcontroller.document = Document.fromJson(json);
            },
          ),
          Button(
              child: Text("copy"),
              onPressed: () {
                final controllerselection = _quillcontroller.selection;
                final baseindex = controllerselection.baseOffset;
                final extentindex = controllerselection.extentOffset;
                int start, end;
                if (baseindex >= extentindex) {
                  start = extentindex;
                  end = baseindex;
                } else {
                  start = baseindex;
                  end = extentindex;
                }
                final selectedtext =
                    _quillcontroller.document.getPlainText(start, end - start);
                print(baseindex);
                print(extentindex);
                print(selectedtext);
                Clipboard.setData(ClipboardData(text: selectedtext));
              })
        ],
      ),
    );
  }
}
