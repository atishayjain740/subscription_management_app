import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFilterBottomSheet extends StatefulWidget {
  @override
  _AddFilterBottomSheetState createState() => _AddFilterBottomSheetState();
}

class _AddFilterBottomSheetState extends State<AddFilterBottomSheet> {
  final TextEditingController _filterNameController = TextEditingController();
  final List<String> _selectedSubscriptions = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 500.h,
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
                  return ListView(
                    children: state.subscriptions.map((subscription) {
                      return CheckboxListTile(
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
          ElevatedButton(
            onPressed: () {
              if (_filterNameController.text.isNotEmpty &&
                  _selectedSubscriptions.isNotEmpty) {
                BlocProvider.of<SubscriptionBloc>(context).add(
                  AddFilterEvent(
                    filterName: _filterNameController.text,
                    selectedSubscriptions: _selectedSubscriptions,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Save Filter"),
          ),
        ],
      ),
    );
  }
}
