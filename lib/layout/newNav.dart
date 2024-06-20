import 'package:mhfatha/settings/imports.dart';

class NewNav extends StatefulWidget {
  const NewNav({super.key});

  @override
  State<NewNav> createState() => _NewNavState();
}

class _NewNavState extends State<NewNav> {
  int adminBadgesCount = 0; // Initialize the badges count for admin
 Map<String, dynamic>? statistics; // Make it nullable
  @override
  void initState() {
    super.initState();
    // Call a function to fetch the badges count for admin from the API
    // _fetchAdminBadgesCount();
     AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAdmin) {
      // If the user is an admin, call the fetchDataFromApi method
      fetchDataFromApi(context);
    }
  }
  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      final statisticsData = await AdminApi(context).fetchStatistics(context);
      final Map<String, dynamic> statisticss = statisticsData['statistics'];


      setState(() {
        statistics = statisticss;
        adminBadgesCount =  statistics!['padges_count'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _fetchAdminBadgesCount() async {
    // Make API call to fetch the badges count for admin
    int count = await _getAdminBadgesCountFromAPI();
    setState(() {
      adminBadgesCount = count;
    });
  }

  Future<int> _getAdminBadgesCountFromAPI() async {
    // Make API call to fetch the badges count for admin
    // Replace this with your actual API call to get the badges count
    // For demonstration, returning a hardcoded value
    return 2; // Example: return badges count received from the API
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    String lang = Provider.of<AppState>(context, listen: false).display;
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      padding: const EdgeInsets.only(bottom: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, isEnglish ? 'Home' : 'الرئيسية', '/home', currentRoute == '/home'),
              if (!authProvider.isAuthenticated)
          _buildNavItem(Icons.account_circle, isEnglish ? 'Account' : 'الحساب', '/login', currentRoute == '/login'),
              if (authProvider.isAuthenticated)
          _buildNavItem(Icons.wallet, isEnglish ? 'My Wallet' : 'محفظتي', '/requests', currentRoute == '/requests'),
          if (authProvider.isVendor)
            _buildNavItem(Icons.store, isEnglish ? 'My Stores' : 'متاجري', '/mainstores', currentRoute == '/mainstores'),
          if (authProvider.isAdmin)
            _buildNavItemWithBadge(
                Icons.vaccines_outlined,
                isEnglish ? 'Manage' : 'ادارة',
                '/admin',
                currentRoute == '/admin',
                adminBadgesCount), // Pass adminBadgesCount to display badge
          _buildNavItem(Icons.settings, isEnglish ? 'Settings' : 'الإعدادات', '/settings', currentRoute == '/settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, String route, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: isSelected ? const Color(0xFF1D365C) : Colors.grey),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 14, color: isSelected ? const Color(0xFF1D365C) : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNavItemWithBadge(
      IconData icon, String label, String route, bool isSelected, int badgeCount) {
    return Stack(
      children: [
        _buildNavItem(icon, label, route, isSelected), // Build the regular navigation item
        if (badgeCount != 0) // Display badge only if badgeCount is not zero
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
