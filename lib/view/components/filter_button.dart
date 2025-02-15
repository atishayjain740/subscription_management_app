import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class FilterButton extends StatelessWidget {
//   final String category;

//   const FilterButton({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.w),
//       child: ElevatedButton(
//         onPressed: () {
//           context.read<SubscriptionBloc>().add(FilterSubscriptions(category));
//         },
//         child: Text(category),
//       ),
//     );
//   }
// }
