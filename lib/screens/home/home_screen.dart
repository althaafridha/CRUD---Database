import 'dart:convert';

import 'package:crud_database/screens/add_data/add_data_screen.dart';
import 'package:crud_database/screens/edit_data/edit_data_screen.dart';
import 'package:flutter/material.dart';

import '../../constant/url.dart';
import '../../model/barang_model.dart';
import 'package:http/http.dart' as http;

import '../profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  const HomePage(this.signOut);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final list = <BarangModel>[];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _lihatdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            signOut: () {
                              _signOut();
                            },
                          )));
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: loading == true
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _lihatdata,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: list.length,
                  // shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditDataPage(
                                      data: data,
                                      id: data.idBarang!,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        // height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffF2F2F2),
                                ),
                                child: data.image == null
                                    ? const Icon(Icons.image)
                                    : Image.network(
                                        BaseUrl.insertImage + data.title!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.description!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Rp. ${data.price!}"),
                                ],
                              )
                            ]),
                            IconButton(
                                onPressed: () {
                                  _showMyDialog(data.idBarang!.toString());
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddDataPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final url = Uri.parse(BaseUrl.detailBarang);
    final response = await http.get(url);

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BarangModel(
          api['id_barang'],
          api['image'],
          api['title'],
          api['price'],
          api['description'],
          api['id_users'],
          api['username'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _showMyDialog(idBarang) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _delete(idBarang);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _delete(String idBarang) async {
    final url = Uri.parse(BaseUrl.deleteBarang);
    final response = await http.post(url, body: {
      "id_barang": idBarang,
    });
  }

  _signOut() {
    setState(() {
      widget.signOut();
    });
  }
}
