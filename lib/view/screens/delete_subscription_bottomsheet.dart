import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';

class DeleteSubscriptionBottomSheet extends StatefulWidget {
  const DeleteSubscriptionBottomSheet({super.key});

  @override
  _DeleteSubscriptionBottomSheetState createState() =>
      _DeleteSubscriptionBottomSheetState();
}

class _DeleteSubscriptionBottomSheetState
    extends State<DeleteSubscriptionBottomSheet> {
  final List<String> _selectedSubscriptions = [];

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
              if (_selectedSubscriptions.isNotEmpty) {
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
}
