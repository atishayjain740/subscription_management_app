import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
import 'package:subsciption_management_app/view/components/show_dialog.dart';

class AddFilterBottomSheet extends StatefulWidget {
  @override
  _AddFilterBottomSheetState createState() => _AddFilterBottomSheetState();
}

class _AddFilterBottomSheetState extends State<AddFilterBottomSheet> {
  final TextEditingController _filterNameController = TextEditingController();
  final List<String> _selectedSubscriptions = [];
  List<String> _allFilters = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: EdgeInsets.all(16.w),
        height: 700.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _filterNameController,
              decoration: const InputDecoration(labelText: "Filter Name"),
            ),
            Expanded(
              child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  if (state is SubscriptionLoaded) {
                    _allFilters = state.filters;
                    return NotificationListener(
                      onNotification: (t) {
                        if (t is UserScrollNotification) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                        return true;
                      },
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: state.subscriptions.map((subscription) {
                          return CheckboxListTile(
                            activeColor: Theme.of(context).primaryColor,
                            checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Text(subscription.name),
                            value: _selectedSubscriptions
                                .contains(subscription.name),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedSubscriptions.add(subscription.name);
                                } else {
                                  _selectedSubscriptions
                                      .remove(subscription.name);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            CustomButton(
              onPressed: () {
                if (validateInput()) {
                  BlocProvider.of<SubscriptionBloc>(context).add(
                    AddFilterEvent(
                      filterName: _filterNameController.text,
                      selectedSubscriptions: _selectedSubscriptions,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              text: "Save Filter",
            ),
          ],
        ),
      ),
    );
  }

  bool validateInput() {
    if (_filterNameController.text.isEmpty) {
      showMessageDialog(context, "Please enter a filter name");
      return false;
    }
    if (_selectedSubscriptions.isEmpty) {
      showMessageDialog(context, "Please select atleast one subscription");
      return false;
    }

    if (_filterNameController.text.toLowerCase() == "all") {
      showMessageDialog(context, "Please enter a valid filter name");
      return false;
    }

    return true;
  }
}
