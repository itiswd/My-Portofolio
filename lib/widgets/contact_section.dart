import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/portfolio_theme.dart';
import 'common/section_heading.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key, required this.languageCode});

  final String languageCode;

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  bool get _isArabic => widget.languageCode == 'ar';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final uri = Uri(
      scheme: 'mailto',
      path: 'ibrahimthswd@gmail.com',
      queryParameters: {
        'subject': 'Portfolio inquiry from ${_name.text.trim()}',
        'body':
            'Name: ${_name.text.trim()}\nEmail: ${_email.text.trim()}\n\n${_message.text.trim()}',
      },
    );
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isArabic
                ? 'تعذر فتح تطبيق البريد.'
                : 'Could not open your email app.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 860;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width < 600 ? 20 : 48,
        vertical: 104,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Container(
            padding: EdgeInsets.all(width < 600 ? 24 : 44),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF13243A), Color(0xFF0A111D)],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: PortfolioColors.border),
              boxShadow: [
                BoxShadow(
                  color: PortfolioColors.primary.withValues(alpha: 0.08),
                  blurRadius: 60,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: compact
                ? Column(
                    children: [
                      _ContactCopy(isArabic: _isArabic),
                      const SizedBox(height: 38),
                      _buildForm(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _ContactCopy(isArabic: _isArabic),
                      ),
                      const SizedBox(width: 64),
                      Expanded(flex: 5, child: _buildForm()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              labelText: _isArabic ? 'الاسم' : 'Your name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? (_isArabic ? 'اكتب اسمك' : 'Please enter your name')
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: _isArabic ? 'البريد الإلكتروني' : 'Email address',
              prefixIcon: const Icon(Icons.alternate_email_rounded),
            ),
            validator: (value) =>
                value == null || !value.trim().contains('@')
                    ? (_isArabic ? 'اكتب بريدًا صحيحًا' : 'Enter a valid email')
                    : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _message,
            minLines: 5,
            maxLines: 8,
            decoration: InputDecoration(
              labelText: _isArabic ? 'تفاصيل المشروع' : 'Tell me about it',
              alignLabelWithHint: true,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? (_isArabic ? 'اكتب رسالتك' : 'Please enter your message')
                : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _send,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: Text(_isArabic ? 'إرسال الرسالة' : 'Send inquiry'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          eyebrow: isArabic ? 'تواصل معي' : 'START A CONVERSATION',
          title: isArabic
              ? 'عندك فكرة؟ خلّينا نحوّلها لمنتج.'
              : 'Have an idea? Let’s turn it into a product.',
          description: isArabic
              ? 'احكي لي عن المشروع والتحدي الذي تريد حله، وسأعود إليك بأقرب وقت.'
              : 'Tell me about your product, challenge or collaboration. I’ll get back to you as soon as possible.',
        ),
        const SizedBox(height: 30),
        const _ContactLine(
          icon: Icons.alternate_email_rounded,
          label: 'EMAIL',
          value: 'ibrahimthswd@gmail.com',
        ),
        const SizedBox(height: 14),
        _ContactLine(
          icon: Icons.location_on_outlined,
          label: isArabic ? 'الموقع' : 'LOCATION',
          value: isArabic ? 'الزقازيق، مصر' : 'Zagazig, Egypt',
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: PortfolioColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: PortfolioColors.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: PortfolioColors.accent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'متوسط الرد: خلال 24 ساعة' : 'Usually replies in 24h',
                style: const TextStyle(
                  color: PortfolioColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: PortfolioColors.primary, size: 20),
        ),
        const SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: PortfolioColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: PortfolioColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
