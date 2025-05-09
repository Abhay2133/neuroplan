import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:neuroplan/services/auth_service.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final Widget child;
  final String href;
  const AppScreen({super.key, required this.child, required this.href});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  bool isCollapsed = false;

  double get sidePanelWidth => isCollapsed ? 60 : 200;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Row(
        children: <Widget>[
          SidePanel(
            href: widget.href,
            width: sidePanelWidth,
            isCollapsed: isCollapsed,
            onToggle: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            onLogout: () => authService.signOut(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class SidePanel extends StatelessWidget {
  final String href;
  final double width;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final VoidCallback onLogout;

  const SidePanel({
    super.key,
    required this.width,
    required this.isCollapsed,
    required this.onToggle,
    required this.onLogout,
    required this.href,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        children: [
          isCollapsed
              ? IconButton(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                iconSize: 20,
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: onToggle,
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "NeuroPlan",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    iconSize: 20,
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: onToggle,
                  ),
                ],
              ),
          const Gap(4),
          _sidepanelList(context),
          const Spacer(),
          _logoutBtn(context),
          const Gap(8),
        ],
      ),
    );
  }

  Widget _logoutBtn(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? 'Logout' : '',
      child: SizedBox(
        width: max(0, width - 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onLogout,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                if (!isCollapsed) ...[
                  const Gap(12),
                  Text("Logout", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sidepanelList(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "text": "Prompt",
        "activeIcon": Icons.message_sharp,
        "inActiveIcon": Icons.message_outlined,
        "href": "/app/prompt",
      },
      {
        "text": "Projects",
        "inActiveIcon": Icons.book_outlined,
        "activeIcon": Icons.book_rounded,
        "href": "/app/projects",
      },
      {
        "text": "History",
        "activeIcon": Icons.lock_clock_sharp,
        "inActiveIcon": Icons.lock_clock_outlined,
        "href": "/app/history",
      },
      {
        "text": "Settings",
        "activeIcon": Icons.settings_sharp,
        "inActiveIcon": Icons.settings_outlined,
        "href": "/app/settings",
      },
    ];
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, idx) {
          final item = items[idx];
          return _panelItem(
            context,
            inActiveIcon: item["inActiveIcon"],
            activeIcon: item["activeIcon"],
            text: item["text"],
            isActive: href == item["href"],
            onTap: () => context.go(item["href"]),
          );
        },
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: items.length,
      ),
    );
  }

  Widget _panelItem(
    BuildContext context, {
    required IconData inActiveIcon,
    required IconData activeIcon,
    required String text,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: isCollapsed ? text : '',
      child: SizedBox(
        width: max(0, width - 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 2 : 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
                  isActive ? Theme.of(context).focusColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment:
                  isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              children: [
                Icon(
                  isActive ? activeIcon : inActiveIcon,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                if (!isCollapsed) ...[
                  const Gap(12),
                  Text(text, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
