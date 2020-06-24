import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AsyncBuilder<T> extends FutureBuilder<T> {
  final String _loadingText;
  final String _noDataText;
  final T _initialValue;
  final Widget Function(T) _builder;
  final Future<T> _future;

  AsyncBuilder(
    this._future,
    this._loadingText,
    this._noDataText,
    this._initialValue,
    this._builder,
  ) : super(
            future: _future,
            initialData: _initialValue,
            builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
              print(snapshot.connectionState);
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if(snapshot.hasData) {
                    return _builder(snapshot.data);
                  } 
                  return _buildNoData(_noDataText);
                case ConnectionState.none:
                  return _buildNoData(_noDataText);
                default:
                  return Center(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(_loadingText),
                      ],
                    ),
                  );
              }
            });

            static Widget _buildNoData(String noDataText){
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(noDataText,
                  style: TextStyle(
                    fontSize: 20
                  ),),
                ),
              );
            }
}
