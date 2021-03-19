import 'package:flutter/material.dart';
import 'package:final_task/model/buku.dart';

class Bukudeskripsi extends StatefulWidget {
  Bukudeskripsi({Key key, this.model}) : super(key: key);
  final Buku model;
  @override
  _BukudeskripsiState createState() => _BukudeskripsiState();
}

class _BukudeskripsiState extends State<Bukudeskripsi> {
  Buku model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('asset/bgdetail.png'),
                  fit: BoxFit.fill,
                )),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                height: MediaQuery.of(context).size.height / 1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 50),
                        child: Text(
                          model.judul,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 1.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(model.foto),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Kutipan Dari : ' + model.penerbit,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        model.deskripsi,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              BackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
