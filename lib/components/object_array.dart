import 'package:flutter/cupertino.dart';

class ObjectArray<T> {
  final List<T> _records;
  final Widget Function(T t, int index) _builder;

  ObjectArray(this._records, this._builder);

  List<Widget> getObjects(){
    List<Widget> result = [];
    for(int i = 0; i < this._records.length; i++){
      result.add(_builder(this._records[i], i));
    }

    return result;
  }
}