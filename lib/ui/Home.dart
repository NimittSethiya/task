import 'package:flutter/material.dart';
import 'package:task/model/FolderDetails.dart';
import 'package:task/ui/selectionPage.dart';
import 'package:task/utils/databaseclient.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController =
  new TextEditingController();

  var db = new DatabaseHelper();
  int id=0;
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
    );
  }

  _buildListView(){
    return  ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _itemList.length,
        itemBuilder: (BuildContext context, int index) {
          return SeletedItem(
            child:  Card(child: ListTile(
              leading: Icon(Icons.folder),
              title: Text("${_itemList[index].folderName}"),
            ),),
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
          ? Icon(Icons.home)
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
           child: Card(
             child: ListTile(
               leading: Icon(Icons.folder),
               title: Text('${_itemList[index].folderName}'),
             ),
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
              _handleSubmitted(_textEditingController.text, "folder", id);
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
    List items = await db.getItems(id);
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(FolderDetails.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }
}



