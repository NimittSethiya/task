import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool listview=true;

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folder'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.create_new_folder),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.delete),
          ),
        ],
      ),
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
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return new Card(child: ListTile(
            leading: Icon(Icons.folder),
            title: Text("Text"),
            subtitle: Text("SubTitle"),
          ),);
        });
  }

  _buildGridView() {
    return GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.56,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2),
        itemBuilder: (context, index) {
          return Card(
            child: Text('hellp'),
          );
        });  }
}
