import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final subject = 'Portfolio Contact from ${_nameController.text.trim()}';
    final body =
        '''
Name: ${_nameController.text.trim()}
Email: ${_emailController.text.trim()}

Message:
${_messageController.text.trim()}
''';

    final uri = Uri(
      scheme: 'mailto',
      path: 'ibrahimthswd@gmail.com',
      queryParameters: {'subject': subject, 'body': body},
    );

    final ok = await canLaunchUrl(uri);
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No email app found on this device.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
        backgroundColor: Color(0xFF00B4DB),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot open link on this device.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 80,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E3C).withOpacity(0.3),
      ),
      child: Column(
        children: [
          _buildSectionTitle('Get In Touch'),
          const SizedBox(height: 20),
          const Text(
            'Feel free to reach out for collaborations or just a friendly chat',
            style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildContactInfo()),
        const SizedBox(width: 60),
        Expanded(flex: 3, child: _buildContactForm()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactForm(),
        const SizedBox(height: 40),
        _buildContactInfo(),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Let's discuss your next project",
          style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
        ),
        const SizedBox(height: 40),

        _buildContactItem(
          icon: Icons.email,
          title: 'Email',
          value: 'ibrahimthswd@gmail.com',
          url: 'mailto:ibrahimthswd@gmail.com',
        ),
        const SizedBox(height: 25),

        _buildContactItem(
          icon: Icons.phone,
          title: 'Phone',
          value: '01070656297',
          url: 'tel:01070656297',
        ),
        const SizedBox(height: 25),

        _buildContactItem(
          icon: Icons.link,
          title: 'LinkedIn',
          value: 'linkedin.com/in/ibrahim-tharwat-18aa77323',
          url:
              'https://www.linkedin.com/in/ibrahim-tharwat-18aa77323?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
        ),

        const SizedBox(height: 30),
        const Text(
          'Social',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            _buildSocialButton(
              icon: Icons.code,
              url: 'https://github.com/itiswd',
              tooltip: 'GitHub',
            ),
            const SizedBox(width: 15),
            _buildSocialButton(
              icon: Icons.business,
              url: 'https://www.linkedin.com/in/ibrahim-tharwat-18aa77323',
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 15),
            _buildSocialButton(
              icon: Icons.facebook,
              url: 'https://www.facebook.com/abrahym.thrwt.507758',
              tooltip: 'Facebook',
            ),
            const SizedBox(width: 15),
            _buildSocialButton(
              icon: Icons.camera_alt,
              url: 'https://instagram.com',
              tooltip: 'Instagram',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required String url,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF00B4DB).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00B4DB).withOpacity(0.25),
                ),
              ),
              child: Icon(icon, color: const Color(0xFF00B4DB)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, color: Color(0xFFB0B0B0), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: () => _openUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1E3C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF00B4DB).withOpacity(0.25),
            ),
          ),
          child: Icon(icon, color: const Color(0xFF00B4DB)),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B4DB).withOpacity(0.10),
            const Color(0xFF0083B0).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF00B4DB).withOpacity(0.30)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Your Name',
              hint: 'John Doe',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Your Email',
              hint: 'john@example.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _messageController,
              label: 'Your Message',
              hint: 'Tell me about your project...',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B4DB),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.send, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
        hintStyle: TextStyle(color: const Color(0xFFB0B0B0).withOpacity(0.5)),
        prefixIcon: Icon(icon, color: const Color(0xFF00B4DB)),
        filled: true,
        fillColor: const Color(0xFF1A1E3C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color(0xFF00B4DB).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00B4DB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
