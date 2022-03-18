import 'package:flutter/material.dart';

class CharacterCellActivateIntent extends Intent {
  final String? keyCharacterValue;

  const CharacterCellActivateIntent({this.keyCharacterValue});
}