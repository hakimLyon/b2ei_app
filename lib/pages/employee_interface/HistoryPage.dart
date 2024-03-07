import 'package:b2ei_app/pages/impression/PDFPage.dart';
import 'package:b2ei_app/model/Request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Dashboard.dart';

class HistoryPage extends StatefulWidget {
  String route;
  HistoryPage(this.route);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {

    Future<void> showHistoryDialog(Request requestData) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' Service : ${requestData.client}'),
            backgroundColor: Colors.green[100],
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Date : ${DateFormat.yMMMMd('en_US').add_jm().format(requestData.timestamp.toDate())}'),
                  Text('Affaire : ${requestData.affaire}'),
                  Text('Reference : ${requestData.reference}'),
                  Text('Designation : ${requestData.designation}'),
                  Text('Quantite : ${requestData.quantite}'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.picture_as_pdf),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => PDFPage(),
                        )
                    );
                  },
                  label: Text("PDF")),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Fermer")),

            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon historique"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("demande").snapshots(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            if(!snapshot.hasData){
              return Text("Aucune demande");
            }
            List<Request> demandes = [];
            snapshot.data!.docs.forEach((data) {
              demandes.add(Request.fromData(data));
            });
            return  ListView.builder(
              itemCount: demandes.length,
              itemBuilder: (context, index){
                final demande = demandes[index];
                final client = demande.client;
                final Timestamp timestamp = demande.timestamp;
                final String date = DateFormat.yMMMMd('en_US').add_jm().format(timestamp.toDate());
                final affaire = demande.affaire;
                final reference = demande.reference;
                final designation = demande.designation;
                final quantite = demande.quantite;

                return Card(
                  child: ListTile(
                    //leading: Image.asset("assets/images/history.jpg"),
                    title: Text("REF: $reference",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                    //subtitle: Text("$affaire,$client, $date, $quantite"),
                    trailing: IconButton(
                      icon :Icon(Icons.info,
                      color: Colors.green,),
                      onPressed: () {
                        showHistoryDialog(demande);
                      },
                    ),

                    onTap: (){

                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFPage() ,
                          ));*/
                    },
                  ),
                );
              },
            );
          } ,
        )
      ),
    );
  }
}
