import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';

class DeleteFilterBottomSheet extends StatefulWidget {
  @override
  _DeleteFilterBottomSheetState createState() =>
      _DeleteFilterBottomSheetState();
}

class _DeleteFilterBottomSheetState extends State<DeleteFilterBottomSheet> {
  final List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 700.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
              builder: (context, state) {
                if (state is SubscriptionLoaded) {
                  return ListView(
                    children: state.filters.map((filter) {
                      if (filter == "All") {
                        return Container();
                      }
                      return CheckboxListTile(
                        activeColor: Theme.of(context).primaryColor,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: Text(filter),
                        value: _selectedFilters.contains(filter),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedFilters.add(filter);
                            } else {
                              _selectedFilters.remove(filter);
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
              if (_selectedFilters.isNotEmpty) {
                BlocProvider.of<SubscriptionBloc>(context).add(
                  DeleteFilterEvent(
                    selectedFilters: _selectedFilters,
                  ),
                );
                Navigator.pop(context);
              }
            },
            text: "Delete Filter",
          ),
        ],
      ),
    );
  }
}
