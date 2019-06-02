import 'package:eksi_reader/models/author.dart';
import 'package:eksi_reader/models/user.dart';
import 'package:eksi_reader/services/eksi_service.dart';
import 'package:eksi_reader/views/author_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountWidget {
  static final focus = FocusNode();
  presentModal(BuildContext context, {Author user}) {
    if (user == null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Color(0xFF737373),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  //color: Theme.of(context).accentColor,
                  padding:
                      EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text('Giriş', style: TextStyle(color: Colors.white)),
                ),
                emailField(context),
                passwordField(context),
              ]),
            );
          });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Color(0xFF737373),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: new BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0))),
                        //color: Theme.of(context).accentColor,
                        padding: EdgeInsets.only(
                            left: 20, top: 15, right: 20, bottom: 15),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(user.name, style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AuthorWidget(user)),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                await EksiService().logout();
                                Navigator.pop(context);
                              },
                                child: Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text('Çıkış',
                                        style: TextStyle(color: Colors.white))),
                                Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(Icons.exit_to_app,
                                        color: Colors.white))
                              ],
                            )),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 15, right: 20, bottom: 15),
                      child: Text(user.stats,
                          style: TextStyle(color: Colors.white)),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 15, right: 20, bottom: 55),
                      child: Text(user.badges[0],
                          style: TextStyle(color: Colors.white)),
                    ),
                  ]),
            );
          });
    }
  }

  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  static Widget emailField(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        child: TextFormField(
            obscureText: false,
            autocorrect: false,
            autofocus: true,
            controller: emailController,
            style: Theme.of(context).textTheme.body1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email adresi",
            ),
            onFieldSubmitted: (email) {
              FocusScope.of(context).requestFocus(focus);
            }));
  }

  static Widget passwordField(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        child: TextFormField(
          scrollPadding: EdgeInsets.all(20),
          obscureText: true,
          focusNode: focus,
          style: Theme.of(context).textTheme.body1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Şifre",
          ),
          onFieldSubmitted: (password) async {
            await EksiService().setCredentials(emailController.text, password);
            await EksiService().login();
            print(emailController.text);
            print(password);
            Navigator.pop(context);
          },
        ));
  }
}
