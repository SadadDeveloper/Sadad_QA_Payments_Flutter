import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               /* Image.asset(
                  "assets/success.gif",
                  height: 150,
                  width: 150,
                ),*/
                Center(
                    child: Text(
                  "Thank you for your order!",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 43),
                Text(
                  "You will receive a confirmation email with all the order details shortly.",
                  style: TextStyle(
                    color: Color(0xFF363636),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                Text(
                  "Your order has been received, and your payment was processed successfully",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF363636),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Order Number:  REQ344595",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3),
                Text(
                  "Transaction ID:  SD3445955689",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 27,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
               // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const HomePage()));
              },
              child: Container(
                height: 50,
                child: Center(
                    child: Text(
                      "Continue to dashboard",
                      style: TextStyle(color: Colors.white),
                    )),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
