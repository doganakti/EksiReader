import 'package:eksi_reader/models/query_result.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:flutter/material.dart';

class SearchWidget extends SearchDelegate<Topic> {
  EksiService service = new EksiService();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Hey'),
        );
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return FutureBuilder<List<Topic>>(
      future: service.autoComplete(query),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data != null ? snapshot.data.length : 0,
          itemBuilder: (context, index) {
            var topic = snapshot.data[index];
            return snapshot.data != null ? ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  topic.icon,
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left:15),
                      child: Text(topic.title),
                    )
                  )
                ],
              ),
              onTap: () {
                
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EntriesWidget(topic)),
                  );
              }
            ): Row();
          },
        );
      },
    );

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Hey'),
        );
      },
    );
  }
}
