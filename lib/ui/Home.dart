import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:task/model/FolderDetails.dart';
import 'package:task/ui/GoogleMap.dart';
import 'package:task/ui/selectionPage.dart';
import 'package:task/utils/databaseclient.dart';

class HomePage extends StatefulWidget {

  final int id;
  const HomePage(
      {Key key,
        this.id})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController =
  new TextEditingController();

  var db = new DatabaseHelper();


  final List<FolderDetails> _itemList = <FolderDetails>[];

  bool _validate = false;

  bool listview=false;

  bool isSelected = false;


  List selectedList;

  int folderId;

  @override
  void initState() {
    selectedList = List();
    _readNoDoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),

        children: [
          Container(
            child: ListTile(

              trailing: listview==false ? GestureDetector(child: Icon(Icons.grid_view),onTap: (){
                setState(() {
                  listview=true;
                });
              },): GestureDetector(child: Icon(Icons.list),
              onTap: (){
                setState(() {
                  listview=false;
                });
              },),
              title: Text('Home'),
            ),
          ),
          (listview) ?  _buildGridView() : _buildListView() ,

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          setState(() async {
            String path = await FilePicker.getFilePath();
            print(path);
            _handleSubmitted(path, "File", widget.id);
          });
        },
      ),
    );
  }

  _buildListView(){
    return  ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return SeletedItem(
            child:  GestureDetector(
              onTap: (){
                _itemList[index].type == 'folder' ?
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(id :  _itemList[index].id)))
                    :
                    print("file");
              },
              child: Card(child: ListTile(
                leading: Icon(_itemList[index].type == 'folder' ? Icons.folder : Icons.file_present),
                title: Text(_itemList[index].type == 'folder' ? "${_itemList[index].folderName}" : new File(_itemList[index].folderName).path.split('/').last),
              ),),
            ),
            isSelected: (bool value) {
              setState(() {
                if (value) {
                  selectedList.add(index);
                } else {
                  selectedList.remove(index);
                }
              });
              print("$index : $value");
            },
          );


        });
  }

  getAppBar() {
    return AppBar(
      leading: selectedList.length < 1
          ? GestureDetector(
          onTap: (){
            print('CLicked Map');
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MapView()));
          },
          child: Icon(Icons.map))
          : InkWell(
          onTap: () {
            setState(() {
              // for (int i = 0; i < selectedList.length; i++) {
              //   itemList.remove(selectedList[i]);
              // }
              selectedList = List();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.cancel),
          )),
      title: Text( selectedList.isEmpty
          ? "Folder"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(child: Icon(Icons.create_new_folder),onTap: (){
            _showFormDialog();
          },),
        ),
        selectedList.length < 1
            ? Container()
            : InkWell(
            onTap: () {
              setState(() {
                // for (int i = 0; i < selectedList.length; i++) {
                //   selectedList.remove(selectedList[i]);
                // }
                selectedList.clear();
                selectedList = List();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete),
            ))
      ],
    );
  }


  _buildGridView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _itemList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2),
        itemBuilder: (context, index) {
          return SeletedItem(
           child: GestureDetector(
             onTap: (){
               _itemList[index].type == 'folder' ?
               Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(id :  _itemList[index].id)))
                   :
               print("file");
             },
             child: Card(child: ListTile(
               leading: Icon(_itemList[index].type == 'folder' ? Icons.folder : Icons.file_present),
               title: Text(_itemList[index].type == 'folder' ? "${_itemList[index].folderName}" : new File(_itemList[index].folderName).path.split('/').last),
             ),),
           ),
            isSelected: (bool value) {
              setState(() {
                if (value) {
                  selectedList.add(index);
                } else {
                  selectedList.remove(index);
                }
              });
              print("$index : $value");
            },
          );
        });  }


  void _showFormDialog() {
    var alert = new AlertDialog(
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height:50,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: "Folder Name",
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                          hintText: "Enter Title Here",
                          icon: Icon(
                            Icons.title,
                            color: Colors.teal,
                          )),
                    ),
                  )
                ],
              ),
            );
          }),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text, "folder", widget.id);
              _textEditingController.clear();
              // _date = "Due Date";
              // debugPrint(_date);
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.teal),
            )),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.teal)))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitted(String text, String s, int folderId) async{

    FolderDetails noDoItem = new FolderDetails(
        text,s, folderId);
    int savedItemId = await db.saveItem(noDoItem);

    FolderDetails addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  _readNoDoList() async {
    _itemList.clear();
    List items = await db.getItems(widget.id);
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(FolderDetails.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }
}



