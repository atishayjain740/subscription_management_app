import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/view/components/subscriptionCards/add_subscription_card.dart';
import 'package:subsciption_management_app/view/components/subscriptionCards/subscription_card.dart';
import 'package:subsciption_management_app/view/components/subscriptionCards/upcoming_payment_card.dart';
import 'package:subsciption_management_app/view/screens/bottomsheets/add_filter_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/bottomsheets/add_subscription_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/bottomsheets/delete_filter_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/bottomsheets/delete_subscription_bottomsheet.dart';

class MySubscriptionsScreen extends StatefulWidget {
  const MySubscriptionsScreen({super.key});

  @override
  MySubscriptionsScreenState createState() => MySubscriptionsScreenState();
}

class MySubscriptionsScreenState extends State<MySubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ignore: prefer_final_fields
  List<Subscription> _subscriptions = [
    Subscription(
        name: "",
        category: "",
        price: "",
        imageUrl: ""), // Dummy data for the first add/delete subscription card
  ];
  // Animated list key
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // For building the tab header
  Widget _buildTab(String text) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // For icons in app bar
  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        onPressed: () {},
      ),
    );
  }

  // General tab. Display the total amount and the upcoming card payment.
  Widget _generalTabInfo(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoaded) {
          return Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.h),
                  child: Text(
                    "₹ ${_getTotalExpense(state)}/month",
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              state.subscriptions.isNotEmpty
                  ? UpcomingPaymentCard(
                      subscription: state.subscriptions[0],
                      color: _getCardColor(3))
                  : Container(),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Calculates the total expense of the user per month
  double _getTotalExpense(SubscriptionLoaded state) {
    try {
      double total = 0;
      for (Subscription s in state.subscriptions) {
        double? expense = double.tryParse(s.price);
        if (expense != null) {
          total += expense;
        }
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  // Get the card color based on the index.
  Color _getCardColor(int index) {
    return AppColors.cardColors[
        index % AppColors.cardColors.length]; // Cycles through colors
  }

  // For my subs tab
  Widget _buildSubscriptionList(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoaded) {
          // Show subs based on the filter selcted
          // Show all the subs if All selected as filter.
          List<Subscription>? subscriptions = state.selectedFilter == "All"
              ? state.subscriptions
              : state.subscriptions
                  .where((element) => element.category == state.selectedFilter)
                  .toList();
          _populateList(subscriptions);

          return Column(
            children: [
              _buildFilterButtons(context, state.filters, state),
              Expanded(
                child: AnimatedList(
                  // Consider other widget for better space management on scroll and overlapping
                  key: _listKey,
                  initialItemCount: _subscriptions.length,
                  itemBuilder: (context, index, animation) {
                    return _getSubCard(context, index, state, animation);
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

  // For filter buttons. Add, delete and filters
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
                    child: const AddFilterBottomSheet(),
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
                    child: const DeleteFilterBottomSheet(),
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
                          ? Theme.of(context).primaryColor
                          : Colors.transparent, // Change this to any color
                      foregroundColor: AppColors.white, // Text color
                      textStyle: TextStyle(
                          color: filter == state.selectedFilter
                              ? AppColors.white
                              : AppColors.grey),
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

  // For geting the sub card. For card will be add/remove sub card
  Widget _getSubCard(BuildContext context, int index, SubscriptionLoaded state,
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
          color: _getCardColor(index));
    } else {
      return SubscriptionCard(
          subscription: _subscriptions[index],
          color: _getCardColor(index),
          animation: animation,
          index: index);
    }
  }

  // For populating the list as per animation
  void _populateList(List<Subscription> sampleData) async {
    // Creating list of newsubs and oldsubs
    List<String> newNames = sampleData.map((sub) => sub.name).toList();
    List<String> oldNames =
        _subscriptions.skip(1).map((sub) => sub.name).toList();

    // Remove the subs from the animated list but also ignore if they are already present.
    // Also ignore the first add/delete sub
    for (int i = _subscriptions.length - 1; i >= 1; i--) {
      if (newNames.contains(_subscriptions[i].name)) continue;

      final removedSub = _subscriptions[i];
      _subscriptions.removeAt(i);

      if (_listKey.currentState != null) {
        _listKey.currentState!.removeItem(
          i,
          (context, animation) => SubscriptionCard(
            subscription: removedSub,
            color: _getCardColor(i),
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

    // Add subs to the animated list. ALso ignore if they are already present.
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
                      _buildTab("General"),
                      _buildTab("My Subs"),
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
          _generalTabInfo(context),
          _buildSubscriptionList(context),
        ],
      ),
    );
  }
}
