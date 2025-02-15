import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/view/components/add_subscription_card.dart';
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
  List<Subscription> _subscriptions = [
    Subscription(name: "", category: "", price: "", imageUrl: ""),
  ];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // void _populateList(List<Subscription> sampleData) async {
  //   List<String> newNames = [];
  //   for (int i = 0; i < sampleData.length; i++) {
  //     newNames.add(sampleData[i].name);
  //   }

  //   List<String> oldNames = [];
  //   for (int i = 1; i < _subscriptions.length; i++) {
  //     oldNames.add(_subscriptions[i].name);
  //   }

  //   for (int i = _subscriptions.length - 1; i >= 1; i--) {
  //     if (newNames.contains(_subscriptions[i].name)) {
  //       continue;
  //     }
  //     final removedSub = _subscriptions[i];
  //     _subscriptions.removeAt(i);
  //     if (_listKey.currentState != null) {
  //       _listKey.currentState!.removeItem(
  //           i,
  //           (context, animation) => SubscriptionCard(
  //                 subscription: removedSub,
  //                 color: getCardColor(i),
  //                 animation: animation,
  //                 index: i,
  //               ),
  //           duration: Duration(milliseconds: 600));
  //     }
  //   }

  //   int k = _subscriptions.length;
  //   for (int i = 0; i < sampleData.length; i++) {
  //     if (oldNames.contains(sampleData[i].name)) {
  //       continue;
  //     }
  //     final addedSub = sampleData[i];
  //     _subscriptions.add(addedSub);

  //     if (_listKey.currentState != null) {
  //       _listKey.currentState!
  //           .insertItem(k, duration: const Duration(microseconds: 600));
  //     }
  //     k++;
  //   }
  // }

  void _populateList(List<Subscription> sampleData) async {
    List<String> newNames = sampleData.map((sub) => sub.name).toList();
    List<String> oldNames =
        _subscriptions.skip(1).map((sub) => sub.name).toList();

    // Remove items smoothly one by one
    for (int i = _subscriptions.length - 1; i >= 1; i--) {
      if (newNames.contains(_subscriptions[i].name)) continue;

      final removedSub = _subscriptions[i];
      _subscriptions.removeAt(i);

      if (_listKey.currentState != null) {
        _listKey.currentState!.removeItem(
          i,
          (context, animation) => SubscriptionCard(
            subscription: removedSub,
            color: getCardColor(i),
            animation: animation,
            index: i,
          ),
          duration: const Duration(milliseconds: 400), // Faster remove
        );
      }
      await Future.delayed(
          const Duration(milliseconds: 300)); // Delay for smooth removal
    }

    int k = _subscriptions.length;

    // Add items smoothly one by one
    for (int i = 0; i < sampleData.length; i++) {
      if (oldNames.contains(sampleData[i].name)) continue;

      final addedSub = sampleData[i];
      _subscriptions.add(addedSub);

      if (_listKey.currentState != null) {
        _listKey.currentState!.insertItem(
          k,
          duration: const Duration(milliseconds: 600), // Smooth addition
        );
      }

      k++;
      await Future.delayed(
          const Duration(milliseconds: 300)); // Delay for smooth addition
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.grey,
                    labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    tabs: [
                      _buildTab(Icons.grid_view, "General"),
                      _buildTab(Icons.work, "My Subs"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        leading: _buildIcon(Icons.menu),
        actions: [
          _buildIcon(Icons.notifications),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
              child: Text("General Tab",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp))),
          _buildSubscriptionList(context),
        ],
      ),
      //appBar: AppBar(title: const Text("My Subscriptions")),
      // body: Column(
      //   children: [
      //     Container(
      //       height: 80.h,
      //       padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
      //       color: Theme.of(context).scaffoldBackgroundColor,
      //       child: Container(
      //           height: 20.h,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: TabBar(
      //             controller: _tabController,
      //             indicatorPadding: EdgeInsets.all(5.w),
      //             labelColor: AppColors.white,
      //             indicator: BoxDecoration(
      //                 color: Theme.of(context).primaryColor,
      //                 borderRadius: BorderRadius.circular(10)),
      //             tabs: [
      //               Tab(
      //                 child: Container(
      //                     alignment: Alignment.center,
      //                     child: const Text(
      //                       "General",
      //                       //style: Theme.of(context).textTheme.bodyLarge,
      //                     )),
      //               ),
      //               Tab(
      //                 child: Container(
      //                     alignment: Alignment.center,
      //                     child: const Text(
      //                       "My subs",
      //                       //style: Theme.of(context).textTheme.bodyLarge,
      //                     )),
      //               ),
      //             ],
      //           )),
      //     ),
      //     Expanded(
      //       child: AnimatedSwitcher(
      //         duration: const Duration(milliseconds: 1000),
      //         transitionBuilder: (Widget child, Animation<double> animation) {
      //           return SlideTransition(
      //             position: Tween<Offset>(
      //               begin: const Offset(1.0, 0.0),
      //               end: const Offset(0.0, 0.0),
      //             ).animate(CurvedAnimation(
      //               parent: animation,
      //               curve: Curves.easeInOut,
      //             )),
      //             child: child,
      //           );
      //         },
      //         child: TabBarView(
      //           controller: _tabController,
      //           children: [
      //             const Center(child: Text("General Content")),
      //             _buildSubscriptionList(context),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
          _populateList(subscriptions);

          //double offset = index * -100.h;

          return Column(
            children: [
              _buildFilterButtons(context, state.filters, state),
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _subscriptions.length,
                  itemBuilder: (context, index, animation) {
                    return getSubCard(context, index, state, animation);
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

  Widget getSubCard(BuildContext context, int index, SubscriptionLoaded state,
      Animation<double> animation) {
    if (index == 0) {
      return AddSubscriptionCard(
          onAddPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<SubscriptionBloc>(context),
                child:
                    AddSubscriptionBottomSheet(category: state.selectedFilter),
              ),
            );
          },
          onDeletePressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<SubscriptionBloc>(context),
                child: const DeleteSubscriptionBottomSheet(),
              ),
            );
          },
          color: getCardColor(index));
    } else {
      return SubscriptionCard(
          subscription: _subscriptions[index],
          color: getCardColor(index),
          animation: animation,
          index: index);
    }
  }

  Color getCardColor(int index) {
    return AppColors.cardColors[
        index % AppColors.cardColors.length]; // Cycles through colors
  }

  Widget _buildTab(IconData icon, String text) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(icon, size: 20.sp),
          //SizedBox(width: 8.w),
          Text(text, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22.sp),
        onPressed: () {},
      ),
    );
  }
}
