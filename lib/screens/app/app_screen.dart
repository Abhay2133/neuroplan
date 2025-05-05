import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/services/auth_service.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final Widget child;
  const AppScreen({super.key, required this.child});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;
  final double sidePanelWidth = 200;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Gap(16),
              list(context),
              Expanded(child: SizedBox()),

              _logoutBtn(() {
                authService.signOut();
              }),
              Gap(8),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  void onSelectItem(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _logoutBtn(VoidCallback logout) {
    return SizedBox(
      width: sidePanelWidth - 16,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: logout,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              Gap(12),
              Text("Logout", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget list(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "text": "Prompt",
        "activeIcon": Icons.message_sharp,
        "inActiveIcon": Icons.message_outlined,
        "isActive": _selectedIndex == 0,
      },
      {
        "text": "Projects",
        "inActiveIcon": Icons.book_outlined,
        "activeIcon": Icons.book_rounded,
        "isActive": _selectedIndex == 1,
      },
      {
        "text": "History",
        "activeIcon": Icons.lock_clock_sharp,
        "inActiveIcon": Icons.lock_clock_outlined,
        "isActive": _selectedIndex == 2,
      },
    ];
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        width: sidePanelWidth,
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return item(
              context,
              inActiveIcon: items[index]["inActiveIcon"],
              activeIcon: items[index]["activeIcon"],
              text: items[index]["text"],
              isActive: items[index]["isActive"] ?? false,
              onTap: (){onSelectItem(index);}
            );
          },
          separatorBuilder: (context, index) => Gap(8),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget item(
    BuildContext context, {
    required IconData inActiveIcon,
    required IconData activeIcon,
    required String text,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: sidePanelWidth - 16,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (onTap != null) onTap();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).focusColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : inActiveIcon,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              Gap(12),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
