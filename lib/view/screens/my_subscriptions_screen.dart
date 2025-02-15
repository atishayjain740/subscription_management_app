import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/subscription_bloc.dart';
// import '../components/subscription_card.dart';

class MySubscriptionsScreen extends StatelessWidget {
  const MySubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Subscriptions")), body: Container()
        //   body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        //     builder: (context, state) {
        //       if (state is SubscriptionLoading) {
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (state is SubscriptionLoaded) {
        //         return ListView.builder(
        //           itemCount: state.subscriptions.length,
        //           itemBuilder: (context, index) {
        //             final subscription = state.subscriptions[index];
        //             return SubscriptionCard(subscription: subscription);
        //           },
        //         );
        //       } else {
        //         return const Center(child: Text("No subscriptions found"));
        //       }
        //     },
        //   ),
        //   floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       // Show Bottom Sheet to add a new subscription
        //       showModalBottomSheet(
        //         context: context,
        //         builder: (_) => const BottomSheetWidget(),
        //       );
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        );
  }
}
