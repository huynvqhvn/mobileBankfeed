import 'package:bank_feed_vs1/model/smsModel.dart';
import 'package:flutter/material.dart';

Widget getSms(SmsModel smsModel) {
  return Container(
    margin: const EdgeInsets.all(16),
    alignment: Alignment.center,
    child: Text('Item $smsModel', style: const TextStyle(fontSize: 26)),   
  ); // Container
}
