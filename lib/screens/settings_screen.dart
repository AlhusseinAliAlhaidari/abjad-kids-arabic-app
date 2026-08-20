import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool musicEnabled = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeProvider.primaryColor,
                  themeProvider.secondaryColor,
                  themeProvider.secondaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(themeProvider),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildProfileCard(themeProvider),
                            SizedBox(height: 20),
                            _buildSettingsSection(
                              'الصوت والموسيقى',
                              [
                                _buildSwitchTile(
                                  'المؤثرات الصوتية',
                                  'تشغيل الأصوات في التطبيق',
                                  Icons.volume_up,
                                  soundEnabled,
                                  (value) => setState(() => soundEnabled = value),
                                  themeProvider,
                                ),
                                _buildSwitchTile(
                                  'الموسيقى الخلفية',
                                  'تشغيل الموسيقى أثناء اللعب',
                                  Icons.music_note,
                                  musicEnabled,
                                  (value) => setState(() => musicEnabled = value),
                                  themeProvider,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildSettingsSection(
                              'التنبيهات',
                              [
                                _buildSwitchTile(
                                  'الإشعارات',
                                  'تلقي تذكيرات للتعلم',
                                  Icons.notifications,
                                  notificationsEnabled,
                                  (value) => setState(() => notificationsEnabled = value),
                                  themeProvider,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildSettingsSection(
                              'البيانات',
                              [
                                _buildActionTile(
                                  'إعادة تعيين التقدم',
                                  'حذف جميع البيانات والبدء من جديد',
                                  Icons.refresh,
                                  () => _showResetDialog(),
                                  themeProvider,
                                  Colors.orange,
                                ),
                                _buildActionTile(
                                  'حذف الحساب',
                                  'حذف الملف الشخصي نهائياً',
                                  Icons.delete_forever,
                                  () => _showDeleteDialog(),
                                  themeProvider,
                                  Colors.red,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildAboutSection(themeProvider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Icon(Icons.settings, color: Colors.white, size: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard(ThemeProvider themeProvider) {
    final profile = DatabaseService.getChildProfile();
    if (profile == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 35, color: themeProvider.primaryColor),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'العمر: ${profile.age} سنوات',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
    ThemeProvider themeProvider,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: themeProvider.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: themeProvider.primaryColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textLight,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: themeProvider.primaryColor,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    ThemeProvider themeProvider,
    Color iconColor,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textLight,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: AppTheme.textLight),
      onTap: onTap,
    );
  }

  Widget _buildAboutSection(ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 50, color: themeProvider.primaryColor),
          SizedBox(height: 10),
          Text(
            'تطبيق تعلم العربية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'الإصدار 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Text('تأكيد إعادة التعيين'),
          ],
        ),
        content: Text('هل أنت متأكد من إعادة تعيين جميع التقدم؟ سيتم حذف جميع البيانات!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseService.deleteProfile();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إعادة تعيين التقدم بنجاح'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('إعادة تعيين', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف الحساب نهائياً؟ لا يمكن التراجع عن هذا الإجراء!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseService.deleteProfile();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف الحساب بنجاح'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
