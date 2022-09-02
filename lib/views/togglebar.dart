// ignore_for_file: use_key_in_widget_constructors

library toggle_bar;

import 'dart:collection';

import 'package:flutter/material.dart';

class ToggleBar extends StatefulWidget {
  final TextStyle labelTextStyle;
  final Color backgroundColor;
  final BoxBorder? backgroundBorder;
  final Color selectedTabColor;
  final Color selectedTextColor;
  final Color textColor;
  final List<String> labels;
  final Function(int) onSelectionUpdated;

  const ToggleBar(
      {required this.labels,
      this.backgroundColor = Colors.lightBlue,
      this.backgroundBorder,
      this.selectedTabColor = Colors.lightBlueAccent,
      this.selectedTextColor = Colors.white,
      this.textColor = Colors.black,
      this.labelTextStyle = const TextStyle(fontWeight: FontWeight.bold),
      required this.onSelectionUpdated});

  @override
  State<StatefulWidget> createState() {
    return _ToggleBarState();
  }
}

class _ToggleBarState extends State<ToggleBar> {
  LinkedHashMap<String, bool> _hashMap = LinkedHashMap();
  int _selectedIndex = 0;

  @override
  void initState() {
    _hashMap = LinkedHashMap.fromIterable(widget.labels,
        value: (value) => value = false);
    _hashMap[widget.labels[0]] = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: widget.backgroundBorder,
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
            itemCount: widget.labels.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: Container(
                      width: (MediaQuery.of(context).size.width - 32) /
                          widget.labels.length,
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 8),
                      child: Text(_hashMap.keys.elementAt(index),
                          textAlign: TextAlign.center,
                          style: widget.labelTextStyle.apply(
                              color: _hashMap.values.elementAt(index)
                                  ? widget.selectedTextColor
                                  : widget.textColor)),
                      decoration: BoxDecoration(
                          color: _hashMap.values.elementAt(index)
                              ? widget.selectedTabColor
                              : null,
                          borderRadius: BorderRadius.circular(5))),
                  onHorizontalDragUpdate: (dragUpdate) async {
                    int calculatedIndex = ((widget.labels.length *
                                    (dragUpdate.globalPosition.dx /
                                        (MediaQuery.of(context).size.width -
                                            32)))
                                .round() -
                            1)
                        .clamp(0, widget.labels.length - 1);

                    if (calculatedIndex != _selectedIndex) {
                      _updateSelection(calculatedIndex);
                    }
                  },
                  onTap: () async {
                    if (index != _selectedIndex) {
                      _updateSelection(index);
                    }
                  });
            }));
  }

  _updateSelection(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onSelectionUpdated(_selectedIndex);
      _hashMap.updateAll((label, selected) => selected = false);
      _hashMap[_hashMap.keys.elementAt(index)] = true;
    });
  }
}
