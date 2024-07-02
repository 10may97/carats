import 'package:flutter/material.dart';
import 'package:restaurantapp/components/User/carousal_page.dart';
import 'package:restaurantapp/components/User/rewards_page.dart';
import 'package:restaurantapp/pages/coupon_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CarousalPage(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:() {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> const RewardsPage()),
                );
            } , 
            child: const Text('View Rewards')
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const CouponPage()),
                  );
              }, 
              child: const Text("Redeem Coupon")
              ),
        ],
      ),
    );
  }
}
