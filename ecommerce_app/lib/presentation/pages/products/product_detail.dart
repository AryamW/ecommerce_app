import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/presentation/controllers/product_controller.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import "package:http/http.dart" as http;
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/controllers/auth.dart';
import 'package:ecommerce_app/presentation/controllers/cart.dart';
import 'package:ecommerce_app/presentation/pages/ErrorPage.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    super.key,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  PDetailController pDetailController = Get.put(PDetailController());

  @override
  Widget build(BuildContext context) {
    print(Get.arguments["id"].runtimeType);
    return body(
        pDetailController: pDetailController,
        runtimeType: runtimeType,
        id: Get.arguments['id'] ?? 3);
  }
}

class body extends StatelessWidget {
  const body({
    super.key,
    required this.pDetailController,
    required this.runtimeType,
    required this.id,
  });

  final PDetailController pDetailController;
  final Type runtimeType;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: pDetailController.retrieveProduct(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return page(
              shimmer: true,
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null &&
              !snapshot.hasError) {
            // return ErrorPage(
            //   message: "Error loading.",
            // );

            return ErrorPage(
              message:
                  "An Unexpected Error has occured while fetching product. please try again later.",
              backDest: "/home",
            );
          } else if (snapshot.hasError) {
            return ErrorPage(
              message:
                  "Error: ${snapshot.error.runtimeType} has occured while trying to fetch data. please try again.",
              backDest: "/home",
            );
          } else {
            PDetailModel product = snapshot.data!;
            return page(
              product: product,
              shimmer: false,
            );
          }
        },
      ),
    );
  }
}

class page extends StatelessWidget {
  Core core = Core();
  final PDetailModel? product;
  final bool shimmer;
  PDetailController detailController = Get.put(PDetailController());
  CartController cartController = Get.put(CartController());
  final _formKey = GlobalKey<FormState>();
  page({
    super.key,
    this.product,
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    bool side = false;
    var screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    double minWidth = 500;
    double minDiff = 500;
    double maxGap = 150;
    final diff = (() {
      var diff = screenWidth - minWidth;
      if (screenWidth > minWidth) {
        if (diff > minDiff) {
          side = true;
        } else
          side = false;
      } else {
        side = false;
      }
      return diff;
    })();
    print("accessible: ${core.role == Roles.CUSTOMER} ${core.role}");
    return Container(
      color: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth > minWidth ? minWidth : screenWidth,
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primary,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: backButton(),
                actions: [HeartButton()],
              ),
              body: Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // the rest of the page
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image part >
                          // ImageSection(product: product),
                          shimmer
                              ? ImageSectionShimmer()
                              : ImageSection(product: product!),
                          // end of image part
                          // start of name and choices
                          // NameSection(product: product),
                          const SizedBox(
                            height: 30,
                          ),
                          shimmer
                              ? NameSectionShimmer()
                              : NameSection(product: product!),
                          // choiceContainer(product: product),
                          const SizedBox(
                            height: 30,
                          ),
                          // ReviewWrite(
                          //     formKey: _formKey,
                          //     detailController: detailController),
                          if (core.role == Roles.CUSTOMER)
                            shimmer
                                ? ReviewWriteShimmer()
                                : ReviewWrite(
                                    pid: product!.id,
                                    formKey: _formKey,
                                    detailController: detailController),
                          // end of name and choices
                          // description
                          // DescriptionSection(product: product),
                          const SizedBox(
                            height: 30,
                          ),
                          shimmer
                              ? DescriptionSectionShimmer()
                              : DescriptionSection(product: product!),
                        ],
                      ),
                      side == true
                          ? const SizedBox(
                              width: 0,
                              height: 0,
                            )
                          : shimmer
                              ? myReveiwsShimmer()
                              : myReviews(product: product!),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: (core.role == Roles.CUSTOMER)
                  ? GestureDetector(
                      onTap: () async {
                        Get.find<CartController>().addToCart(
                            {"productId": product!.id, "quantity": 1});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.tertiary),
                        margin: EdgeInsets.all(20.0),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product == null ? "" : "${product!.price} ETB",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Add to Bag",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // reviews
          side
              ? SizedBox(
                  width: ((diff - minDiff <= 0))
                      ? 10
                      : (diff - minDiff > maxGap)
                          ? maxGap
                          : diff - minDiff)
              : const SizedBox(
                  width: 0,
                ),
          side
              ? shimmer
                  ? myReveiwsShimmer(
                      side: side,
                    )
                  : myReviews(
                      product: product!,
                      side: side,
                    )
              : const SizedBox(
                  width: 0,
                  height: 0,
                )
        ],
      ),
    );
  }
}

class DescriptionSectionShimmer extends StatelessWidget {
  const DescriptionSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(
            width: double.infinity,
            height: 300,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
    ;
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
    required this.product,
  });

  final PDetailModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product != null
                ? product!.details == null
                    ? "No details"
                    : product!.details!
                : "",
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ReviewWriteShimmer extends StatelessWidget {
  const ReviewWriteShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerContainer(
              width: double.infinity,
              height: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            ShimmerContainer(
              width: double.infinity,
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            ShimmerContainer(
              width: 200,
              height: 40,
            ),
            SizedBox(
              height: 10,
            ),
            ShimmerContainer(
              width: 100,
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class ReviewWrite extends StatelessWidget {
  final int pid;
  const ReviewWrite({
    super.key,
    required this.pid,
    required GlobalKey<FormState> formKey,
    required this.detailController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final PDetailController detailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Write Review",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: detailController.reviewController,
              maxLines: 4,
              minLines: 4,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
              decoration: InputDecoration(
                label: Text(
                  "review",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                hintText: "Write you review of this product.",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                fillColor: Theme.of(context).colorScheme.secondary,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
              ),
            ),
            ratingWidget(
              detailController: detailController,
            ),
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    detailController.submitForm(pid);

                    // Get.offNamed("/productDetail");
                  }
                },
                icon: Icon(
                  Icons.send,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimary,
                ))
          ],
        ),
      ),
    );
  }
}

class NameSectionShimmer extends StatelessWidget {
  const NameSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      height: 30,
      width: 200,
    );
  }
}

class NameSection extends StatelessWidget {
  const NameSection({
    super.key,
    required this.product,
  });

  final PDetailModel product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product == null ? "" : product!.name,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

class ImageSectionShimmer extends StatelessWidget {
  const ImageSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: [1, 2, 3, 4, 5]
                .map((e) => Row(
                      children: [
                        ShimmerContainer(width: 200),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ))
                .toList()),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double? height;
  const ShimmerContainer({super.key, required this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Color.fromRGBO(169, 168, 168, 0.696),
      child: Container(
          width: width,
          height: height,
          color: Theme.of(context)
              .colorScheme
              .primary // Adjust the height as needed
          ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.product,
  });

  final PDetailModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: product.images!.map(
          (e) {
            var s;
            try {
              s = Image.network(
                e,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Return a Container as a fallback if the image fails to load
                  return Container(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 120,
                  );
                },
              );
            } catch (e) {
              s = Container(
                color: Theme.of(context).colorScheme.secondary,
                width: 120,
              );
            }
            return Row(
              children: [
                s,
                const SizedBox(
                  width: 10,
                )
              ],
            );
          },
        ).toList()),
      ),
    );
  }
}

class ratingWidget extends StatelessWidget {
  const ratingWidget({
    super.key,
    required this.detailController,
  });

  final PDetailController detailController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Row(
          mainAxisSize: MainAxisSize.min,
          children: [1, 2, 3, 4, 5]
              .map(
                (e) => GestureDetector(
                  onTap: () => detailController.changeRating(e),
                  child: (detailController.rating.value != null &&
                          (detailController.rating.value! >= e))
                      ? Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      : Icon(
                          Icons.star_border,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                ),
              )
              .toList(),
        )));
  }
}

class myReveiwsShimmer extends StatelessWidget {
  final bool side;
  const myReveiwsShimmer({
    super.key,
    this.side = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10.0),
      child: side
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: reColumns(
                context,
              ),
            )
          : reColumns(context),
    );
  }

  Column reColumns(BuildContext context) {
    double commentsWidth = 350;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(
          width: 200,
          height: 30,
        ),
        SizedBox(
          height: 10,
        ),
        ShimmerContainer(
          width: 300,
          height: 40,
        ),
        SizedBox(
          height: 10,
        ),
        ShimmerContainer(
          width: 220,
          height: 25,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          // height: MediaQuery.of(context).size.height,
          width: commentsWidth,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)),
                                clipBehavior: Clip.hardEdge,
                                child: CircleAvatar(
                                  child: ShimmerContainer(
                                    width: commentsWidth,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ShimmerContainer(width: 100),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ShimmerContainer(
                        width: double.infinity,
                        height: 100,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class myReviews extends StatelessWidget {
  final bool side;
  final PDetailModel product;
  const myReviews({
    this.side = false,
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    if (product!.reviews == null) {
      return Text("No Review To Show");
    }
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10.0),
      child: side
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: reColumns(context, product),
            )
          : reColumns(context, product),
    );
  }

  Column reColumns(BuildContext context, PDetailModel product) {
    double commentsWidth = 400;
    var rating = product.reviews!["rating"];
    var reviews = product.reviews!["reviews"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reviews",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          "${rating} Rating",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Text(
          "${reviews.length} Reviews",
          style: TextStyle(
              fontSize: 12, color: Theme.of(context).colorScheme.onSecondary),
        ),
        Container(
          // height: MediaQuery.of(context).size.height,
          width: commentsWidth,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: reviews!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(reviews[index].name![0]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      reviews[index].name!,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                  ),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [1, 2, 3, 4, 5].map(
                                        (e) {
                                          var color = Theme.of(context)
                                              .colorScheme
                                              .onSecondary;
                                          var icon = Icons.star_border;
                                          if (e <= reviews[index].rating) {
                                            icon = Icons.star;
                                            color = Colors.yellow;
                                          }
                                          return Icon(icon, color: color);
                                        },
                                      ).toList()),
                                ],
                              ),
                            ],
                          ),

                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.more_vert,
                          //     color: Theme.of(context).colorScheme.onSecondary,
                          //   ),
                          // ),

                          reviews[index].isMine == true
                              ? PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  onSelected: (String result) async {
                                    // Handle your logic here based on the selected menu item
                                    if (result == 'edit') {
                                      Get.find<PDetailController>()
                                          .reviewController
                                          .text = reviews[index].review;

                                      Get.find<PDetailController>()
                                          .changeRating(reviews[index].rating);
                                    } else if (result == 'delete') {
                                      var r =
                                          await Get.find<PDetailController>()
                                              .delete(product.id);
                                      if (r == true)
                                      // Get.find<PDetailController>()
                                      //     .retrieveProduct(product.id);
                                      {
                                        Get.offNamed("/productDetail",
                                            arguments: {"id": product.id});
                                      }
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        reviews[index].review,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

var mokeReviews = [
  {
    "name": "Anonymous",
    "comment":
        "Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.",
  },
  {
    "name": "User99",
    "comment":
        "Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.",
  },
  {
    "name": "John",
    "comment":
        "Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.",
  },
  {
    "name": "FirstUser",
    "comment":
        "Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.",
  },
];
