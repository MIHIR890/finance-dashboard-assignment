import 'package:flutter/material.dart';
import 'package:flutter_assignment/transaction_model.dart';



class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          surface: const Color(0xFFF8F9FF),
        ),
      ),
      home:  SpendSummaryScreen(),
    );
  }
}

class SpendSummaryScreen extends StatelessWidget {
   SpendSummaryScreen({super.key});

  final List<TransactionItemModel> mockTransactions = List.generate(
    57,
        (index) {
      final items = [
        {
          'title': 'Starbucks',
          'category': 'Food',
          'icon': Icons.coffee_outlined,
          'bg': const Color(0xFFE0E7FF),
          'color': const Color(0xFF4F46E5),
        },
        {
          'title': 'Uber',
          'category': 'Travel',
          'icon': Icons.directions_car_outlined,
          'bg': const Color(0xFFECFDF5),
          'color': const Color(0xFF10B981),
        },
        {
          'title': 'Amazon',
          'category': 'Shopping',
          'icon': Icons.shopping_cart_outlined,
          'bg': const Color(0xFFEFF6FF),
          'color': const Color(0xFF3B82F6),
        },
        {
          'title': 'Netflix',
          'category': 'Entertainment',
          'icon': Icons.movie_outlined,
          'bg': const Color(0xFFFEE2E2),
          'color': const Color(0xFFEF4444),
        },
        {
          'title': 'Zomato',
          'category': 'Food',
          'icon': Icons.restaurant_outlined,
          'bg': const Color(0xFFFFF1F2),
          'color': const Color(0xFFE11D48),
        },
        {
          'title': 'Swiggy',
          'category': 'Food',
          'icon': Icons.delivery_dining_outlined,
          'bg': const Color(0xFFFFEDD5),
          'color': const Color(0xFFF97316),
        },
      ];

      final item = items[index % items.length];

      return TransactionItemModel(
        icon: item['icon'] as IconData,
        iconBg: item['bg'] as Color,
        iconColor: item['color'] as Color,
        title: item['title'] as String,
        category: item['category'] as String,
        time:
        '${(8 + index) % 12 + 1}:${(index * 7) % 60}'.padLeft(2, '0'),
        amount: '-₹${(index + 1) * 23.75}',
        date: DateTime.now().subtract(Duration(days: index ~/ 4)),
      );
    },
  );
   Map<String, List<TransactionItemModel>> groupedTransactions() {
     final Map<String, List<TransactionItemModel>> grouped = {};

     for (final transaction in mockTransactions) {
       String key;

       final now = DateTime.now();
       final difference =
           now.difference(transaction.date).inDays;

       if (difference == 0) {
         key = 'TODAY';
       } else if (difference == 1) {
         key = 'YESTERDAY';
       } else {
         key =
         '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}';
       }

       grouped.putIfAbsent(key, () => []);
       grouped[key]!.add(transaction);
     }

     return grouped;
   }

  @override
  Widget build(BuildContext context) {
    final grouped = groupedTransactions();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FF),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Color(0xFF0F172A)),
        title: const Text(
          'Spend Summary',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_circle_outlined, color: Color(0xFF0F172A)),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalSpendCard(),
                _buildSectionHeader('Categories', trailing: 'View Details'),
                _buildCategoryList(),
                _buildSectionHeader('Recent Transactions', showFilter: true),
      ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: grouped.entries.map((entry) {
          return _buildTransactionGroup(
            entry.key,
            entry.value.map((e) {
              return TransactionItem(
                icon: e.icon,
                iconBg: e.iconBg,
                iconColor: e.iconColor,
                title: e.title,
                category: e.category,
                time: e.time,
                amount: e.amount,
              );
            }).toList(),
          );
        }).toList(),
      )
              ],
            ),
          ),
          _buildFloatingActionButton(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTotalSpendCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL MONTHLY SPEND',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\₹2,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Color(0xFF4ADE80), size: 16),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'vs last month',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing, bool showFilter = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (title == 'Categories')
                Text(
                  'Where your money goes',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.w600,
              ),
            ),
          if (showFilter)
            const Icon(Icons.filter_list, color: Color(0xFF0F172A)),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: const [
          CategoryCard(icon: Icons.restaurant, label: 'Food', amount: '\₹640', color: Color(0xFF4F46E5)),
          CategoryCard(icon: Icons.flight, label: 'Travel', amount: '\₹1,200', color: Color(0xFF10B981)),
          CategoryCard(icon: Icons.shopping_bag, label: 'Shopping', amount: '\₹320', color: Color(0xFF3B82F6)),
          CategoryCard(icon: Icons.hotel, label: 'Hotel Booking', amount: '\₹600', color: Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildTransactionGroup(String date, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'ADD SPEND',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Spend'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Budgets'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final String time;
  final String amount;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹category • ₹time',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
