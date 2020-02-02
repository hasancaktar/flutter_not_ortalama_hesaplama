import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String DersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var fromKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesaplama"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (fromKey.currentState.validate()) {
            fromKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulamaGovdesi();
        } else {
          return uygulamaGovdesiYan();
        }
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      //  margin: EdgeInsets.all(10),
      //   padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Stataik alanı tutan container
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
              key: fromKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.brown, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.brown, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: "Ders Adı",
                        labelStyle:
                            TextStyle(fontSize: 25, color: Colors.indigo),
                        hintStyle: TextStyle(fontSize: 20),
                        hintText: "Ders adını girin..."),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else
                        return "Ders adı boş olamaz!";
                    },
                    onSaved: (kaydedilecekDeger) {
                      DersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.add(Ders(DersAdi, dersHarfDegeri, dersKredi,
                            rastgeleRenk()));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: dersKredileriItems(),
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                            value: dersKredi,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown, width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: dersHarfDegerleriItems(),
                              value: dersHarfDegeri,
                              onChanged: (secilenHarf) {
                                setState(() {
                                  dersHarfDegeri = secilenHarf;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.cyan.shade300,
              border: BorderDirectional(
                top: BorderSide(color: Colors.indigo, width: 2),
                bottom: BorderSide(color: Colors.indigo, width: 2),
                end: BorderSide(color: Colors.indigo, width: 2),
                start: BorderSide(color: Colors.indigo, width: 2),
              ),
            ),
            height: 70,
            // color: Colors.lightBlue,
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: tumDersler.length == 0
                        ? "Lütfen Ders Ekleyin"
                        : "Ortalama : ",
                    style: TextStyle(color: Colors.black, fontSize: 30)),
                TextSpan(
                    text: tumDersler.length == 0
                        ? ""
                        : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 40, color: Colors.purple))
              ]),
            )),
          ),
          //dinamik liste tutan container
          Expanded(
              child: Container(
            //color: Colors.green,
            child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: tumDersler.length,
            ),
            //child: ListView.builder(itemBuilder: _listeElemanlariniOlustur,itemCount: ,),
          ))
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));

    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;

    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tumDersler[index].renk, width: 2)),
        child: ListTile(
          trailing: Icon(
            Icons.arrow_right,
            color: tumDersler[index].renk,
            size: 40,
          ),
          leading: Icon(
            Icons.school,
            color: tumDersler[index].renk,
          ),
          title: Text(tumDersler[index].ad),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " kredi Ders Not Değeri" +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var oAnkiDers in tumDersler) {
      var kredi = oAnkiDers.kredi;
      var harfDegeri = oAnkiDers.harfDegeri;

      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color rastgeleRenk() {
    return Color.fromARGB(150 + Random().nextInt(10), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }

  Widget uygulamaGovdesiYan() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Form(
                    key: fromKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.brown, width: 2)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: "Ders Adı",
                              labelStyle:
                                  TextStyle(fontSize: 25, color: Colors.indigo),
                              hintStyle: TextStyle(fontSize: 20),
                              hintText: "Ders adını girin..."),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders adı boş olamaz!";
                          },
                          onSaved: (kaydedilecekDeger) {
                            DersAdi = kaydedilecekDeger;
                            setState(() {
                              tumDersler.add(Ders(DersAdi, dersHarfDegeri,
                                  dersKredi, rastgeleRenk()));
                              ortalama = 0;
                              ortalamayiHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.brown, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: dersKredileriItems(),
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  },
                                  value: dersKredi,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.brown, width: 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                    items: dersHarfDegerleriItems(),
                                    value: dersHarfDegeri,
                                    onChanged: (secilenHarf) {
                                      setState(() {
                                        dersHarfDegeri = secilenHarf;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade300,
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.indigo, width: 2),
                        bottom: BorderSide(color: Colors.indigo, width: 2),
                        end: BorderSide(color: Colors.indigo, width: 2),
                        start: BorderSide(color: Colors.indigo, width: 2),
                      ),
                    ),
                    // color: Colors.lightBlue,
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: tumDersler.length == 0
                                ? "Lütfen Ders Ekleyin"
                                : "Ortalama : ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 30)),
                        TextSpan(
                            text: tumDersler.length == 0
                                ? ""
                                : "${ortalama.toStringAsFixed(2)}",
                            style:
                                TextStyle(fontSize: 40, color: Colors.purple))
                      ]),
                    )),
                  ),
                )
              ],
            ),
            flex: 1,
          ),
          Expanded(
              child: Container(
            //color: Colors.green,
            child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: tumDersler.length,
            ),
            //child: ListView.builder(itemBuilder: _listeElemanlariniOlustur,itemCount: ,),
          )),
        ],
      ),
    );
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.harfDegeri, this.kredi, this.renk);
}
