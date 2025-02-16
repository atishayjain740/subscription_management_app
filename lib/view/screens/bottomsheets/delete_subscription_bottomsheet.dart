import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
import 'package:subsciption_management_app/view/components/show_dialog.dart';

// Bottomsheet for deleting an existing subscription
class DeleteSubscriptionBottomSheet extends StatefulWidget {
  const DeleteSubscriptionBottomSheet({super.key});

  @override
  DeleteSubscriptionBottomSheetState createState() =>
      DeleteSubscriptionBottomSheetState();
}

class DeleteSubscriptionBottomSheetState
    extends State<DeleteSubscriptionBottomSheet> {
  final List<String> _selectedSubscriptions =
      []; // List fo subs selected to delete

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 500.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                if (state is SubscriptionLoaded) {
                  return ListView(
                    children: state.subscriptions
                        .where(
                      (element) =>
                          element.category == state.selectedFilter ||
                          state.selectedFilter == "All",
                    )
                        .map((subscription) {
                      return CheckboxListTile(
                        activeColor: Theme.of(context).primaryColor,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: Text(subscription.name),
                        value:
                            _selectedSubscriptions.contains(subscription.name),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedSubscriptions.add(subscription.name);
                            } else {
                              _selectedSubscriptions.remove(subscription.name);
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          CustomButton(
            onPressed: () {
              if (_validateInput()) {
                BlocProvider.of<SubscriptionBloc>(context).add(
                  DeleteSubscriptionEvent(
                    selectedSubscriptions: _selectedSubscriptions,
                  ),
                );
                Navigator.pop(context);
              }
            },
            text: "Delete Subscription",
          ),
        ],
      ),
    );
  }

  bool _validateInput() {
    if (_selectedSubscriptions.isEmpty) {
      showMessageDialog(context, "Please select atleast one subscription");
      return false;
    }
    return true;
  }
}
