import 'package:eksi_reader/models/query_result.dart';
import 'package:eksi_reader/models/topic.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/entries_widget.dart';
import 'package:flutter/material.dart';

class SearchWidget extends SearchDelegate<Topic> {
  EksiService service = new EksiService();
  Topic searchTopic;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query == '') {
            close(context, null);
          }
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
    // close(context, null);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => EntriesWidget(searchTopic),
    //       fullscreenDialog: false,
    //       maintainState: false),
    // );
    return getListView();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return getListView();
  }

  Widget getListView() {
    return FutureBuilder<List<Topic>>(
      future: service.autoComplete(query),
      builder: (context, snapshot) {
        searchTopic = snapshot.data != null && snapshot.data.length > 0
            ? snapshot.data[0]
            : null;
        return ListView.builder(
          itemCount: snapshot.data != null ? snapshot.data.length : 0,
          itemBuilder: (context, index) {
            var topic = snapshot.data[index];
            return snapshot.data != null
                ? ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        topic.icon,
                        Flexible(
                            child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(topic.title),
                        ))
                      ],
                    ),
                    onTap: () {
                      close(context, null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EntriesWidget(topic),
                            fullscreenDialog: false,
                            maintainState: false),
                      );
                    })
                : Row();
          },
        );
      },
    );
  }
}
