import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
import 'package:subsciption_management_app/view/components/show_dialog.dart';

// Bottomsheet for deleting an existing filter
class DeleteFilterBottomSheet extends StatefulWidget {
  const DeleteFilterBottomSheet({super.key});

  @override
  DeleteFilterBottomSheetState createState() => DeleteFilterBottomSheetState();
}

class DeleteFilterBottomSheetState extends State<DeleteFilterBottomSheet> {
  final List<String> _selectedFilters =
      []; // Filter that the user selects to delete

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
                      // Cannot delete all filter
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
              if (_validateInput()) {
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

  bool _validateInput() {
    if (_selectedFilters.isEmpty) {
      showMessageDialog(context, "Please select atleast one filter");
      return false;
    }

    return true;
  }
}
