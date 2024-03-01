import 'dart:async';

import 'package:first_sol/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: MyHomePage(
              title: "Gist's Flutter Floating Bottom Bar Example",
            ),
            builder: EasyLoading.init(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink
  ];

  final List<String> top_picks = [
    'All',
    'LifeStyle',
    'Entertainment',
    'Food',
    'Health',
    'Shopping',
    'Travel',
    'Utilities'
  ];

  ApiServices? apiServices;
  @override
  void initState() {
    apiServices = ApiServices();
    currentPage = 0;
    tabController = TabController(length: 2, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    getBalance();
    super.initState();
  }

  getBalance() async {
    var balance = await apiServices!
        .checkBalance("5N3emoVvPKAycLQr5AFWfGB99FVSQtCaT682cRAjnhxC");
    print('balance: $balance');
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = Colors.white;
    // remove statusbar height from the height of the screen

    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: BottomBar(
          fit: StackFit.expand,
          icon: (width, height) => Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: unselectedColor,
                size: width,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(500),
          duration: Duration(seconds: 1),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.5,
          barColor: Colors.black,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const BouncingScrollPhysics(),
              children: [
                HomeScreen(height: height),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Container(
                      height: 120.h,
                      width: 0.8.sw,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Cash Back"),
                                  Text("SLE 120"),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Cash Back Rate"),
                                  Text("1.5%"),
                                ],
                              ),
                            ],
                          ),
                          Text("Riding Points"),
                          Text("3608"),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    const Text("Top Picks for you"),
                    10.verticalSpace,
                    SizedBox(
                      height: 29.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: top_picks.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            height: 15.h,
                            // width: 120.w,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(top_picks[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: top_picks.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            height: 220.h,
                            // width: 120.w,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(top_picks[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ]),
          child: TabBar(
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: currentPage == 0
                        ? colors[0]
                        : currentPage == 1
                            ? colors[0]
                            : currentPage == 2
                                ? colors[0]
                                : unselectedColor,
                    width: 4),
                insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.home,
                  color: currentPage == 0 ? colors[0] : unselectedColor,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.money,
                  color: currentPage == 2 ? colors[0] : unselectedColor,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.height,
  });
  final double height;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices? apiServices;
  void initState() {
    apiServices = ApiServices();

    getBalance();
    super.initState();
  }

  String? balance;
  bool loading = false;
  int count = 0;
  TextEditingController amount = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController key = TextEditingController();

  getBalance() async {
    var _balance = await apiServices!
        .checkBalance("5N3emoVvPKAycLQr5AFWfGB99FVSQtCaT682cRAjnhxC");
    setState(() {
      balance = _balance;
    });
    print('balance: ${balance}');
  }

  transfer(phone, amount, key) async {
    await apiServices!.transfer(phone, amount, key).then((value) {
      print(value);
      setState(() {
        loading = false;
      });
    });
  }

  void showMsg(context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  showSuccess() {
    Future.delayed(Duration(seconds: 2), () {
      // Increment a counter to simulate page content change
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Transaction Completed'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ));
    });
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: Column(children: [
        SizedBox(
          height: 0.2.sh,
          child: Column(
            children: [
              Text(
                "SLE ${balance == null ? 0 : balance}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text("Top up"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 0.6.sh,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                //
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // see all transactions
                                      const SizedBox(
                                        // height: 0.1.sh,
                                        child: Text(
                                          "Pay",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      SizedBox(
                                        child: TextFormField(
                                          controller: amount,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "Enter Amount",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      TextFormField(
                                        controller: phone,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText:
                                              "Enter Receiver's phone number",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      TextFormField(
                                        controller: key,
                                        decoration: InputDecoration(
                                          labelText: "Enter transaction key",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          transfer(phone.text, amount.text,
                                              key.text);
                                          showMsg(context);

                                          setState(() {
                                            loading = false;
                                          });
                                          print(loading);
                                          showSuccess();

                                          // Navigator.pop(context);
                                        },
                                        child: loading
                                            ? const Text("Processing..")
                                            : const Text("Pay"),
                                      ),
                                      // transactions
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("Pay"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text("Receive"),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Spacer(),
        Container(
          height: 0.7.sh,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            //
          ),
          child: Column(
            children: [
              // see all transactions
              const SizedBox(
                // height: 0.1.sh,
                child: Text(
                  "See all transactions",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // transactions

              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Transaction $index"),
                      subtitle: Text("Transaction $index"),
                      leading: CircleAvatar(
                        child: Text("Pay"),
                      ),
                      trailing: Text("SLE ${index + 12}"),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
