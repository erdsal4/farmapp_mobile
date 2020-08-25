import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'HomePage.dart';

class SiteSelection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final myInheritedWidget = MyInheritedWidget.of(context);
    print(myInheritedWidget.jwt);
    
    return Scaffold(
      body: Column(
          children: <Widget>[
            Text("Select a site", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
            SizedBox(height: 15),
            MyDropdown()          
          ]
        )
      );
    
    }
  
}

class Site {

 // @JsonKey(name: '_id')  
  
  final String name;
  final String id;

  const Site({this.name, this.id});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json['name'],
      id: json['_id']
    );
  }
  
  
}


class MyDropdown extends StatefulWidget {
  MyDropdown({Key key}) : super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

Future<List<Site>> fetchSites(jwt) async {

    print(jwt);
    final Map<String,String> headers = {
      "x-access-token": jwt
    };
    final response = await http.get('$SERVER_DOMAIN/sites', headers: headers);
//    print(response.statusCode);
//    print(response.body);
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Site> sites = List<Site>.from(l.map((i) => Site.fromJson(i)));
      return sites;
    } else {
      throw Exception('Failed to load sites');
    }
    
  }
  

class _MyDropdownState extends State<MyDropdown> {

  Site selectedSite;
  List<Site> sites = <Site>[
    const Site(name: "Site 1", id: "1"),
    const Site(name: "Site 2", id: "2"),
    const Site(name: "Site 3", id: "3"),
    const Site(name: "Site 4", id: "4")
    ];
  
  @override
  void initState() {
    super.initState();
   /* WidgetsBinding.instance.addPostFrameCallback((_) {
        print(MyInheritedWidget.of(context).jwt);
        future =  fetchSites(json.decode(MyInheritedWidget.of(context).jwt)['token']);
    }); */
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 300.0,
      decoration: BoxDecoration(
        border: Border.all(width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Site>(
          icon: Icon(Icons.arrow_downward),
          iconSize: 16,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          value: selectedSite,
          onChanged: (Site newSite) {
            setState(() {
                selectedSite = newSite;
            });
            
          },
          items: sites.map<DropdownMenuItem<Site>>((Site site) {
              return DropdownMenuItem<Site>(
                value: site,
                child: Text(site.name, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)),
              );
          }).toList(),
          hint: Text('Select Site')
        )
      )
    )
  );
    
   /* return FutureBuilder<List<Site>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Site>> snapshot) {
        if(snapshot.hasData) {
          return DropdownButton<Site>(
             icon: Icon(Icons.arrow_downward),
             iconSize: 14,
             elevation: 16,
             style: TextStyle(color: Colors.black),
             underline: Container(
               height: 2,
               color: Colors.deepPurpleAccent,
             ),
             value: select,
             onChanged: (Site newSite) {
               setState(() {
                   select = newSite;
               });
               
             },
             items: snapshot.data.map<DropdownMenuItem<Site>>((Site site) {
                return DropdownMenuItem<Site>(
                  value: site,
                  child: Text(site.name),
                );
            }).toList(),
            hint: Text('Select Site')
          ); 
        } else if (snapshot.hasError) {
          return Text("there was an error");
          
        } else {
          return Column(
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ]
          );
        }
      }
    ); */
    }
  }

   
