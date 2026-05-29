/// Copyright (c) 2026 Deon Kayele. All rights reserved.
/// PROPRIETARY AND CONFIDENTIAL: CallShield MTC Elite
/// Unauthorized copying or distribution is strictly prohibited.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'providers/caller/lookup_provider.dart';
import 'screens/home_screen.dart';
import 'screens/lookup_screen.dart';
import 'screens/call_log_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/identity_sync_screen.dart';
import 'screens/premium_status_screen.dart';
import 'screens/report_form_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/blocked_list_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/native_shield_screen.dart';
import 'screens/simulation_screen.dart';
import 'screens/settings_screen.dart';

import 'database/local/database_helper.dart';
import 'screens/app_lock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  _registerNativeCallBridge(container);
  runApp(
      UncontrolledProviderScope(container: container, child: const MTCApp()));
}

void _registerNativeCallBridge(ProviderContainer container) {
  const channel = MethodChannel('com.mtc.callshield/call_events');
  channel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'incomingCall':
        final phone = call.arguments['phone'] as String?;
        if (phone == null || phone.trim().isEmpty) {
          return {
            'shouldBlock': false,
            'reason': 'Missing phone number',
          };
        }

        return container.read(currentCallProvider.notifier).processIncomingCall(
            phone,
            callerName: call.arguments['callerName'] as String?);
      default:
        throw PlatformException(
          code: 'unimplemented',
          message: 'Method ${call.method} not implemented',
        );
    }
  });
}

class MTCApp extends StatelessWidget {
  const MTCApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CallShield',
      theme: MTCTheme.light,
      home: const InitialFlow(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialFlow extends StatefulWidget {
  const InitialFlow({super.key});
  @override
  State<InitialFlow> createState() => _InitialFlowState();
}

class _InitialFlowState extends State<InitialFlow> {
  bool _showSplash = true;
  bool _needsSync = true;
  bool _needsLock = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final isSyncedStr = await DatabaseHelper.instance.getSetting('is_synced');
    if (isSyncedStr == 'true') {
      setState(() {
        _needsSync = false;
        _needsLock = true;
      });
    } else {
      setState(() {
        _needsSync = true;
        _needsLock = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
          onFinished: () => setState(() => _showSplash = false));
    }
    if (_needsSync) {
      return IdentitySyncScreen(onSyncComplete: () {
        setState(() {
          _needsSync = false;
          _needsLock = false;
        });
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    }
    if (_needsLock) {
      return AppLockScreen(onUnlock: () {
        setState(() {
          _needsLock = false;
        });
      });
    }
    return const MainNavigation();
  }
}

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});
  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _idx = 2; // Default to Shield/Home as requested
  final _screens = [
    const CallLogScreen(), // Primary "Phone" view
    const MessagesScreen(), // "Messages" view
    const HomeScreen(), // "Shield/Home" view
    const ContactsScreen(), // "Contacts" view
    const LookupScreen(), // "Global Search" view
  ];

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(lookupProvider).isPremium;
    final appTitle = isPremium ? 'CallShield Elite' : 'CallShield';

    return Scaffold(
      appBar: _idx == 2
          ? null
          : AppBar(
              title: Text(appTitle),
              elevation: 0,
            ),
      drawer: _buildAppDrawer(context),
      body: _screens[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        backgroundColor: MTCTheme.primaryNavy,
        selectedItemColor: MTCTheme.accentTeal,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        selectedLabelStyle:
            GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.call_rounded), label: 'Calls'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shield_rounded), label: 'Shield'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded), label: 'Contacts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
        ],
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: MTCTheme.primaryNavy,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [MTCTheme.primaryBlue, MTCTheme.primaryNavy]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.shield_rounded,
                    color: MTCTheme.accentTeal, size: 40),
                const SizedBox(height: 10),
                Text('CallShield Modules',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _drawerItem(context, 'Elite Premium', Icons.star_rounded,
              const PremiumStatusScreen(),
              color: MTCTheme.accentTeal),
          _drawerItem(context, 'Report a Threat', Icons.report_rounded,
              const ReportFormScreen()),
          _drawerItem(context, 'Call Simulator', Icons.phone_in_talk_rounded,
              const SimulationScreen()),
          _drawerItem(context, 'Native OS Shield', Icons.security_rounded,
              const NativeShieldScreen()),
          _drawerItem(context, 'Global Analytics', Icons.analytics_rounded,
              const AnalyticsScreen()),
          _drawerItem(context, 'Blocked Calls', Icons.block_flipped,
              const BlockedListScreen()),
          _drawerItem(context, 'My Reports', Icons.list_alt_rounded,
              const ReportsScreen()),
          _drawerItem(context, 'Live Alerts',
              Icons.notification_important_rounded, const AlertsScreen()),
          const Divider(color: Colors.white12),
          _drawerItem(context, 'Settings', Icons.settings_rounded,
              const SettingsScreen()),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String title, IconData icon, Widget screen,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(title,
          style: GoogleFonts.outfit(
              color: color ?? Colors.white, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
