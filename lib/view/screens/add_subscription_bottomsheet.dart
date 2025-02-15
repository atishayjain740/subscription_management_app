import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddSubscriptionBottomSheet extends StatefulWidget {
  final String category;

  const AddSubscriptionBottomSheet({super.key, required this.category});
  @override
  _AddSubscriptionBottomSheetState createState() =>
      _AddSubscriptionBottomSheetState();
}

class _AddSubscriptionBottomSheetState
    extends State<AddSubscriptionBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 500.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Subscription Name"),
          ),
          SizedBox(
            height: 20.h,
          ),
          TextField(
            controller: _priceController,
            decoration:
                const InputDecoration(labelText: "Monthly subscription price"),
          ),
          // Expanded(
          //   child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          //     builder: (context, state) {
          //       if (state is SubscriptionLoaded) {
          //         return ListView(
          //           children: state.subscriptions.map((subscription) {
          //             return CheckboxListTile(
          //               title: Text(subscription.name),
          //               value:
          //                   _selectedSubscriptions.contains(subscription.name),
          //               onChanged: (bool? value) {
          //                 setState(() {
          //                   if (value == true) {
          //                     _selectedSubscriptions.add(subscription.name);
          //                   } else {
          //                     _selectedSubscriptions.remove(subscription.name);
          //                   }
          //                 });
          //               },
          //             );
          //           }).toList(),
          //         );
          //       }
          //       return const Center(child: CircularProgressIndicator());
          //     },
          //   ),
          // ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                BlocProvider.of<SubscriptionBloc>(context).add(
                  AddSubscriptionEvent(
                      subscriptionName: _nameController.text,
                      subscriptionPrice: _priceController.text,
                      subscriptionCategory:
                          widget.category == "All" ? "" : widget.category),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Save Subscription"),
          ),
        ],
      ),
    );
  }
}
