import 'package:flutter/material.dart';

class FolderDetails extends StatelessWidget {

  String _folderName;
  String _type ;
  int _folderId ;
  int _id;

  FolderDetails(this._folderName, this._type, this._folderId);

  FolderDetails.map(dynamic obj) {
      this._folderName = obj['folderName'];
      this._type = obj['type'];
      this._folderId = obj['folderId'];
      this._id=obj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["folderName"] = _folderName;
    map["type"] = _type;
    map["folderId"] = _folderId;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  FolderDetails.fromMap(Map<String, dynamic> map) {
    this._folderName = map["folderName"];
    this._type = map["type"];
    this._id = map["id"];
    this._folderId = map["folderId"];
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get folderName => _folderName;

  set folderName(String value) {
    _folderName = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }


  int get folderId => _folderId;

  set folderId(int value) {
    _folderId = value;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


}
