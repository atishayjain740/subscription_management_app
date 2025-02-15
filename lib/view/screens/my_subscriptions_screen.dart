import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/view/components/add_subscription_card.dart';
import 'package:subsciption_management_app/view/components/delete_subscription_card.dart';
import 'package:subsciption_management_app/view/components/subscription_card.dart';
import 'package:subsciption_management_app/view/screens/add_filter_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/add_subscription_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/delete_filter_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/delete_subscription_bottomsheet.dart';
import '../components/filter_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySubscriptionsScreen extends StatefulWidget {
  const MySubscriptionsScreen({super.key});

  @override
  _MySubscriptionsScreenState createState() => _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends State<MySubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Subscriptions")),
      body: Column(
        children: [
          Container(
            height: 80.h,
            padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorPadding: EdgeInsets.all(5.w),
                  labelColor: AppColors.white,
                  indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  tabs: [
                    Tab(
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "General",
                            //style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    ),
                    Tab(
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "My subs",
                            //style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text("General Content")),
                  _buildSubscriptionList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionList(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoaded) {
          List<Subscription>? subscriptions = state.selectedFilter == "All"
              ? state.subscriptions
              : state.subscriptions
                  .where((element) => element.category == state.selectedFilter)
                  .toList();

          // selectedFilter = state.selectedFilter;

          return Column(
            children: [
              _buildFilterButtons(context, state.filters, state),
              Expanded(
                child: ListView.builder(
                  itemCount: subscriptions.length + 2,
                  itemBuilder: (context, index) {
                    double offset = index * -30.h;
                    if (index == 0) {
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: AddSubscriptionCard(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => BlocProvider.value(
                                value:
                                    BlocProvider.of<SubscriptionBloc>(context),
                                child: AddSubscriptionBottomSheet(
                                    category: state.selectedFilter),
                              ),
                            );
                          },
                          color: getCardColor(index),
                        ),
                      );
                    } else if (index == 1) {
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: DeleteSubscriptionCard(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => BlocProvider.value(
                                value:
                                    BlocProvider.of<SubscriptionBloc>(context),
                                child: DeleteSubscriptionBottomSheet(),
                              ),
                            );
                          },
                          color: getCardColor(index),
                        ),
                      );
                    }

                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: SubscriptionCard(
                        subscription: subscriptions[index - 2],
                        color: getCardColor(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildFilterButtons(
      BuildContext context, List<String> filters, SubscriptionLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<SubscriptionBloc>(context),
                    child: AddFilterBottomSheet(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<SubscriptionBloc>(context),
                    child: DeleteFilterBottomSheet(),
                  ),
                );
              },
            ),
            ...filters.map((filter) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<SubscriptionBloc>(context).add(
                        ChangeFilterEvent(
                          filter,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: filter == state.selectedFilter
                          ? Colors.blue
                          : Colors.transparent, // Change this to any color
                      foregroundColor: Colors.white, // Text color
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(
                          color: filter == state.selectedFilter
                              ? AppColors.white
                              : Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50), // Optional: Rounded corners
                      ),
                    ),
                    child: Text(
                      filter,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  final List<Color> cardColors = [
    Color(0xFF4A90E2), // Soft Blue
    Color(0xFF50E3C2), // Mint Green
    Color(0xFFFFA726), // Warm Orange
    Color(0xFF7B61FF), // Vibrant Purple
    Color(0xFFEF5350), // Soft Red
    Color(0xFF26C6DA), // Light Cyan
    Color(0xFFAB47BC), // Soft Lavender
    Color(0xFFFFD54F), // Warm Yellow
  ];

  Color getCardColor(int index) {
    return cardColors[index % cardColors.length]; // Cycles through colors
  }
}
