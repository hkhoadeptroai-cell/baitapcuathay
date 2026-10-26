import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../widgets/common.dart';

const _blue = Color(0xFF2F5BEA);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _blue,
    body: SafeArea(
      child: Column(
        children: [
          const Spacer(),
          const AppLogo(size: 96, inverted: true),
          const SizedBox(height: 16),
          const Text(
            'UTH Todo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Việc học, việc nhà – gọn gàng mỗi ngày',
            style: TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                color: Colors.white,
                backgroundColor: Colors.white24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Phiên bản 2.1.0',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

class _OnbPage {
  const _OnbPage(this.icon, this.title, this.desc);
  final IconData icon;
  final String title, desc;
}

const _pages = [
  _OnbPage(
    Icons.checklist_rounded,
    'Mọi việc, gọn trong một chỗ',
    'Ghi lại bài tập, việc nhà, lịch hẹn. Không còn quên việc nào.',
  ),
  _OnbPage(
    Icons.label_outline,
    'Chia theo Học tập và Cuộc sống',
    'Mỗi việc có nhóm riêng, nhìn là biết hôm nay cần lo gì.',
  ),
  _OnbPage(
    Icons.notifications_none,
    'Nhắc đúng lúc',
    'Bật thông báo để UTH Todo nhắc bạn trước hạn chót.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  bool get _isLast => _page == _pages.length - 1;
  void _toLogin() => Navigator.pushReplacementNamed(context, AppRoutes.login);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const AppLogo(size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'UTH Todo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(onPressed: _toLogin, child: const Text('Bỏ qua')),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) {
                    final p = _pages[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 240,
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(p.icon, size: 80, color: cs.primary),
                            ),
                          ),
                        ),
                        Text(
                          p.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(p.desc),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 6),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? cs.primary : cs.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isLast
                      ? _toLogin
                      : () => _ctrl.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                  child: Text(_isLast ? 'Bắt đầu ngay' : 'Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _enter(BuildContext c) =>
      Navigator.pushNamedAndRemoveUntil(c, AppRoutes.home, (_) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogo(size: 64),
          const SizedBox(height: 20),
          Text(
            'Chào mừng đến với\nUTH Todo',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đồng bộ để lưu công việc và đồng bộ trên mọi thiết bị của bạn.',
          ),
          const SizedBox(height: 16),
          const _Benefit(
            Icons.cloud_done_outlined,
            'Tự động sao lưu, không lo mất dữ liệu',
          ),
          const _Benefit(Icons.devices, 'Dùng trên iPhone, iPad và Mac'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _enter(context),
              icon: const Icon(Icons.g_mobiledata, size: 28),
              label: const Text('Tiếp tục với Google'),
            ),
          ),
          const Center(child: Text('hoặc')),
          Center(
            child: TextButton(
              onPressed: () => _enter(context),
              child: const Text('Dùng thử không cần tài khoản'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}
