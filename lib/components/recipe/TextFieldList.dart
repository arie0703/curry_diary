import 'package:flutter/material.dart';
import 'package:curry_app/CustomClass.dart';

class TextFieldList extends StatefulWidget {
  const TextFieldList({Key? key, required this.list}) : super(key: key);
  final List list;
  _TextFieldListState createState() => _TextFieldListState();
}

class _TextFieldListState extends State<TextFieldList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.list.length,
          itemBuilder: (BuildContext context, index) {
            return Row(
              children: [
                Text((index + 1).toString() + "."),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: widget.list[index]),
                    onChanged: (text) {
                      setState(() {
                        widget.list[index] = text;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      widget.list.removeAt(index);
                    });
                  },
                )
              ],
            );
          },
        ),
        if (widget.list.length < 10)
          ElevatedButton(
            child: const Text("追加"),
            onPressed: () {
              setState(() {
                widget.list.add("");
              });
            },
          ),
      ],
    );
  }
}
