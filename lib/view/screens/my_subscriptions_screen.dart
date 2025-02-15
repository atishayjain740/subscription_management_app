import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';
import 'package:subsciption_management_app/view/components/add_subscription_card.dart';
import 'package:subsciption_management_app/view/components/subscription_card.dart';
import 'package:subsciption_management_app/view/screens/add_filter_bottomsheet.dart';
import 'package:subsciption_management_app/view/screens/add_subscription_bottomsheet.dart';
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
  String selectedFilter = 'All';

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
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "General"),
              Tab(text: "My Subscription"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text("General Content")),
                _buildSubscriptionList(context),
              ],
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
          List<Subscription>? subscriptions = selectedFilter == "All"
              ? state.subscriptions
              : state.subscriptions
                  .where((element) => element.category == selectedFilter)
                  .toList();

          return Column(
            children: [
              _buildFilterButtons(context, state.filters),
              Expanded(
                child: ListView.builder(
                  itemCount: subscriptions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddSubscriptionCard(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<SubscriptionBloc>(context),
                              child: AddSubscriptionBottomSheet(
                                  category: state.selectedFilter),
                            ),
                          );
                        },
                      );
                    }
                    return SubscriptionCard(
                        subscription: subscriptions[index - 1]);
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

  Widget _buildFilterButtons(BuildContext context, List<String> filters) {
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
            ...filters.map((filter) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ElevatedButton(
                    onPressed: () => setState(() => selectedFilter = filter),
                    child: Text(filter),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
