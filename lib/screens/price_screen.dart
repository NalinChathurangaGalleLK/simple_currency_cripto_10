import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:simple_currency_cripto_10/components/conversion_card.dart';
import 'package:simple_currency_cripto_10/services/coin_data.dart';
import 'package:simple_currency_cripto_10/services/conversion.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  ConversionModel conversion = ConversionModel();
  String currency = 'CAD';
  Map<String, double> lastValue = {};

  @override
  void initState() {
    super.initState();
  }

  void updateUI() async {
    for (String c in cryptoList) {
      try {
        var conversionData = await conversion.getConversion(c, currency);

        setState(() {
          lastValue[c] = conversionData['last'];
        });
      } catch (e) {
        print(e);
      }
    }
  }

  List<Widget> getCryptoCards() {
    List<Widget> cryptoCards = [];
    for (String c in cryptoList) {
      var newCard = ConversionCard(
        crypto: c,
        currency: currency,
        lastValue: lastValue[c] ?? 0,
      );

      cryptoCards.add(newCard);
    }

    return cryptoCards;
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String c in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(c),
        value: c,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: currency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            currency = value.toString();
            updateUI();
          });
        });
  }

  NotificationListener iosPicker() {
    List<Widget> pickerItems = [];
    for (String c in currenciesList) {
      pickerItems.add(Text(c));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics is FixedExtentMetrics) {
          final selectIndex =
              (scrollNotification.metrics as FixedExtentMetrics).itemIndex;
          currency = currenciesList[selectIndex];
          updateUI();
          return true;
        } else {
          return false;
        }
      },
      child: CupertinoPicker(
        itemExtent: 32.0,
        scrollController: FixedExtentScrollController(initialItem: 2),
        onSelectedItemChanged: null,
        children: pickerItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ðŸ¤‘ Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCryptoCards(),
            ),
          ),
          Container(
            height: 70.0,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          )
        ],
      ),
    );
  }
}
