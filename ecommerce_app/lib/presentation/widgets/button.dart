import "package:ecommerce_app/presentation/controllers/auth.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ContinueButton extends StatelessWidget {
  final Function onPress;
  final LoadingController? getController;
  final Widget child;
  final double padding;
  const ContinueButton(
      {super.key,
      required this.onPress,
      required this.child,
      this.padding = 20,
      this.getController});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(padding)),
          backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.tertiary),
        ),
        onPressed: (){
          getController?.changeIsLoading(true);
          onPress().then((_) => getController?.changeIsLoading(false));
          // getController?.changeIsLoading(false);
        },
        child: getController != null
            ? Obx(() {
                return getController!.isLoading.value == true
                    ? loadingWidget()
                    : child;
              })
            : child);
  }
}

class loadingWidget extends StatelessWidget {
  const loadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Colors.white,
    );
  }
}

class ChoiceButton extends StatefulWidget {
  final String title;
  final List<dynamic> values;
  final List<Widget> representations;
  final List<Widget> choices;

  const ChoiceButton(
      {super.key,
      required this.values,
      required this.representations,
      required this.choices,
      required this.title});
  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  late Widget _currentChoice;
  late dynamic _value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentChoice = widget.representations[0];
    _value = widget.values[0];
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.primary,
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Use min to make the bottom sheet only as tall as its content
                children: <Widget>[
                  // Add a title at the top of the bottom sheet
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  // Add a divider for better visual separation
                  Divider(color: Theme.of(context).colorScheme.onSecondary),
                  // Your existing ListView.builder
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.representations.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            tileColor: Theme.of(context).colorScheme.secondary,
                            hoverColor: Theme.of(context).colorScheme.tertiary,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none),
                            title: widget.choices[index],
                            onTap: () {
                              setState(() {
                                _currentChoice = widget.representations[index];
                                _value = widget.values[index];
                              });
                              print("selected : ${widget.values[index]}");
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _currentChoice,
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "lib/assets/images/arrow_down.png",
                color: Theme.of(context).colorScheme.onSecondary,
              )
            ],
          )
        ],
      ),
    );
  }
}

// ListView(
//                 children: <Widget>[
//                  ListTile(
//                     title: Text('Small'),
//                     onTap: () {
//                       setState(() {
//                         _currentChoice = Text("S");
//                       });
//                       Navigator.pop(context);
//                       // Handle the selection of 'Small'
//                     },
//                  ),
//                  ListTile(
//                     title: Text('Medium'),
//                     onTap: () {
//                        setState(() {
//                         _currentChoice = Text("M");
//                       });
//                       Navigator.pop(context);
//                       // Handle the selection of 'Medium'
//                     },
//                  ),
//                  ListTile(
//                     title: Text('Large'),
//                     onTap: () {
//                        setState(() {
//                         _currentChoice =Text("L");
//                       });
//                       Navigator.pop(context);
//                       // Handle the selection of 'Large'
//                     },
//                  ),
//                 ],
//               ),

class HeartButton extends StatefulWidget {
  final dynamic event;
  const HeartButton({super.key, this.event});

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  bool _liked = false;
  String _link = "lib/assets/images/Vector.png";
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ImageIcon(
        AssetImage(_link),
        color: Colors.red,
        size: 40, // Adjust the size as needed
      ),
      onPressed: () {
        setState(() {
          _liked = !_liked;
          _link = _liked
              ? "lib/assets/images/heart.png"
              : "lib/assets/images/Vector.png";
        });
      },
    );
  }
}

class QuantityButton extends StatefulWidget {
  const QuantityButton({super.key});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6).copyWith(right: 20, left: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quantity",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              ContinueButton(
                  onPress: () {
                    setState(() {
                      _quantity += 1;
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 10,
              ),
              Text(
                "$_quantity",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(
                width: 10,
              ),
              ContinueButton(
                  padding: 20,
                  onPress: () {
                    setState(() {
                      if (_quantity > 1) _quantity -= 1;
                    });
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class backButton extends StatelessWidget {
  final String? nextPageName;
  const backButton({
    super.key,
    this.nextPageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: ImageIcon(
          color: Theme.of(context).colorScheme.onSecondary,
          AssetImage("lib/assets/images/arrowleft2.png"),
          size: 40, // Adjust the size as needed
        ),
        onPressed: () {
          print("$nextPageName page");

          nextPageName != null ? Get.offNamed(nextPageName!) : Get.back();
        },
      ),
    );
  }
}
