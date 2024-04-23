import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUsers extends StatefulWidget {
  ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  final AdminUsersController controller = Get.put(AdminUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(leading: backButton(nextPageName: "/home"), backgroundColor: Theme.of(context).colorScheme.primary,),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    cursorColor: Theme.of(context).colorScheme.onPrimary,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    controller: controller.queryParam,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                            width:
                                2.0), // Define the color and width of the focused border
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Define the border radius
                      ),
                      border: InputBorder
                          .none, // This ensures no border is shown when the TextField is not focused
                      hintText: "Search users...",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) {
                      controller.changeList(value);
                    },
                  ),
                ),
            SizedBox(
              height: 30,
            ),
            // list
            Expanded(
              child: Obx(
                () {
                  if (controller.Users.value.isEmpty) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ));
                  } else if (controller.filterUsers.value.isEmpty) {
                    return Center(
                      child: Text(
                        "No User was Found with search parameter: ${controller.queryParam.text}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    );
                  } else {
                    return DynamicTable(users: controller.filterUsers.value);
                  }
                },
              ),
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    // onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                    onPressed: controller.currentPage.value > 0
                        ? () => controller
                            .changePage(controller.currentPage.value - 1)
                        : null,
                  ),
                  Text(
                    'Page ${controller.currentPage.value + 1} of ${(controller.Users.value.length / controller.rowsPerPage.value).floor() + 1}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    // onPressed: _currentPage < (widget.users.length / _rowsPerPage).floor() - 1 ? () => setState(() => _currentPage++) : null,
                    onPressed: controller.currentPage.value <
                            (controller.Users.value.length /
                                    controller.rowsPerPage.value)
                                .floor()
                        ? () => controller
                            .changePage(controller.currentPage.value + 1)
                        : null,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DynamicTable extends StatelessWidget {
  final List<GetUserModel> users;

  DynamicTable({required this.users});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2), // Outer border
          borderRadius: BorderRadius.circular(10),
          // Optional: Border radius
        ),
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Full Name',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          DataColumn(
            label: Text(
              'Phone Number',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          DataColumn(
            label: Text(
              'Options',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
        rows: users
            .map((user) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(
                        user.firstname != null && user.lastname != null
                            ? "${user.firstname}  ${user.lastname}"
                            : user.firstname != null
                                ? "${user.firstname}"
                                : user.lastname != null
                                    ? "${user.lastname}"
                                    : "N/A",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary))),
                    DataCell(Text(user.email ?? 'N/A',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary))),
                    DataCell(Text(user.phoneNumber ?? 'N/A',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary))),
                    DataCell(Row(
                      children: [
                        // IconButton(
                        //   icon: Icon(Icons.delete, ),
                        //   onPressed: () {
                        //     print("delete user: ${user.firstname}");

                        //   },
                        // ),

                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 175, 2, 2),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  titleTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 16),
                                  contentTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary)),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        // Your delete action here
                                        print("delete user: ${user.firstname}");
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            print("show user: ${user.firstname}");
                          },
                        ),
                      ],
                    )),
                  ],
                  // color: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                ))
            .toList(),
      ),
    );
  }
}
