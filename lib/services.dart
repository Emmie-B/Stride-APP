import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  // make a get request

  checkBalance(address) async {
    try {
      var response = await http.post(
          Uri.parse("https://stride-api.onrender.com/checkbalance"),
          body: {
            'publickey': address,
          });

      if (response.statusCode == 200) {
        var balance = jsonDecode(response.body);
        return balance['balance'];
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  transfer(phone, amount, transactionkey) async {
    try {
      var response = await http.post(
          Uri.parse("https://stride-api.onrender.com/makeTransfer"),
          body: {
            "id": "65e0e876b39f0d84c7e9f90f",
            "phone": phone,
            "amount": amount,
            "transactionkey": transactionkey
          });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print(res);

        return true;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
