import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/services/ai_provider_service.dart';
import 'package:neuroplan/widgets/spinner.dart';

/// Main Settings screen with tabs for different setting sections
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Define tabs for Settings screen
  final List<Tab> _tabs = const [
    Tab(text: 'AI Provider'),
    Tab(text: 'Profile'),
    Tab(text: 'Privacy'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with number of tabs
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Return content widget for each tab based on index
  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const AiSettings();
      case 1:
        return const Center(child: Text("Profile Settings Section"));
      case 2:
        return const Center(child: Text("Privacy Settings Section"));
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header title
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            // Tab bar for different settings sections
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: _tabs,
            ),
            // Display content for the selected tab
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  _tabs.length,
                  (index) => _buildTabContent(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI Settings section for managing API tokens and provider selection
class AiSettings extends StatefulWidget {
  const AiSettings({super.key});

  @override
  State<AiSettings> createState() => _AiSettingsState();
}

class _AiSettingsState extends State<AiSettings> {
  final TextEditingController _tokenController = TextEditingController();
  final AiProviderService _aiService = AiProviderService();
  Timer? _debounce;

  String _selectedProvider = '';
  bool _isLoading = false;

  // List of supported AI providers
  final List<Map<String, dynamic>> _providers = [
    {'name': 'GROQ', 'image': 'assets/images/groq.png', 'isAvailable': true},
    {
      'name': 'ChatGPT',
      'image': 'assets/images/chatgpt.png',
      'isAvailable': false,
    },
    {
      'name': 'Gemini',
      'image': 'assets/images/gemini.png',
      'isAvailable': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set default provider and load corresponding API key
    _selectedProvider = _providers[0]["name"]!;
    _loadApiKey();

    // Update API key whenever the user types into the text field
    _tokenController.addListener(_onTokenChanged);
  }

  // Debounced listener function
  void _onTokenChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      updateAiProvider(); // Call the actual update function
    });
  }

  void updateAiProvider() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _aiService.updateApiKey(
        _selectedProvider.toLowerCase(),
        _tokenController.text,
      );
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Load API key for the currently selected provider
  Future<void> _loadApiKey() async {
    setState(() => _isLoading = true);
    final key = await _aiService.getApiKey(_selectedProvider.toLowerCase());
    _tokenController.text = key ?? '';
    setState(() => _isLoading = false);
  }

  /// Called when a different provider is selected
  void _onProviderSelected(String name) async {
    if(_selectedProvider == name) return;
    setState(() {
      _selectedProvider = name;
      _tokenController.clear();
    });
    await _aiService.setSelectedProvider(name.toLowerCase());
    _loadApiKey(); // Load new provider's token
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content for settings
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configure your AI provider',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Gap(16),

                  // Show loader while API key is being fetched
                  Container(
                    width: min(600, constraints.maxWidth),
                    child: Row(
                      children: [
                        SizedBox(
                          width: min(550, constraints.maxWidth),
                          child: TextField(controller: _tokenController),
                        ),
                        Gap(8),
                        _isLoading ? Spinner(radius: 8) : SizedBox(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Select Provider',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Provider selection cards
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        _providers.map((provider) {
                          final isSelected =
                              _selectedProvider == provider['name'];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            elevation: 2,
                            child: InkWell(
                              onTap:
                                  provider['isAvailable']
                                      ? () =>
                                          _onProviderSelected(provider['name']!)
                                      : null,
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      provider['image']!,
                                      height: 40,
                                      width: 40,
                                      errorBuilder:
                                          (_, __, ___) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(provider['name']!),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
