import 'package:eksi_reader/models/section.dart';
import 'package:eksi_reader/models/settings_section.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class SettingsWidget extends StatefulWidget {
  @override
  State createState() => new SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget>
    with SingleTickerProviderStateMixin {
  List<SettingsSection> sections = [];
  EksiService service = EksiService();
  PickerWidget picker;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    sections = await service.getSettingsSectionList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ayarlar'),
        ),
        body: getListView());
  }

  Widget getListView() {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        var section = sections[index];
        return ListTile(
            onTap: () {
              picker = PickerWidget(section.contentList, (value) async{
                print(value);
                section.selectedValue = value;
                await FlutterKeychain.put(key: section.key, value: value);
                setState(() {
                  
                });
              });
              picker.mainBottomSheet(context);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(section.title,
                          style: Theme.of(context).textTheme.body1),
                      section.newRoute
                          ? Icon(Icons.arrow_right)
                          : Text(section.selectedValue)
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
