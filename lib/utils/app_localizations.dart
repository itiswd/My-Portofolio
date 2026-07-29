class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation
      'home': 'Home',
      'about': 'About',
      'skills': 'Skills',
      'projects': 'Projects',
      'contact': 'Contact Me',

      // Hero Section
      'hi_im': 'Hi, I\'m',
      'name': 'ابراهيم ثروت',
      'title': 'Flutter Developer',
      'hero_description':
          'Communications & Electronics Engineering student specializing in Flutter development. I build beautiful cross-platform mobile applications with clean code and excellent user experience.',
      'view_work': 'View My Work',
      'download_cv': 'Download CV',
      'projects_completed': 'Projects Completed',
      'years_experience': 'Years Experience',
      'client_satisfaction': 'Client Satisfaction',

      // About Section
      'about_me': 'About Me',
      'about_description_1':
          'Flutter Developer with a strong background in Communications & Electronics Engineering. Experienced in building cross-platform mobile apps with clean code and great user experience. Passionate about automation, IoT, and continuous learning.',
      'about_description_2': 'Key skills and experience since 2022:',
      'about_point_1':
          'Mobile Development: Flutter, Dart, Android Studio, VS Code, Git, GitHub',
      'about_point_2': 'State Management: Bloc/Cubit, GetX, Provider',
      'about_point_3':
          'Backend & APIs: REST APIs, Dio, Firebase (Auth, Firestore, Storage), MQTT',
      'about_point_4': 'Local Storage: Hive, SharedPreferences',
      'about_point_5': 'Hardware Integration: Bluetooth Serial, MQTT Client',
      'about_point_6':
          'Industrial Training: PLC Programming, Electric Motor Control, Control Systems',
      'about_point_7':
          'UI Development: Responsive layouts, Custom widgets, Material Design',
      'about_description_3':
          'Combining engineering and software skills to deliver innovative solutions. Always eager to learn and take on new challenges.',
      'education': 'Education',
      'education_title':
          'Bachelor of Engineering in Communications and Electronics',
      'education_period': 'Zagazig University, Egypt | 2020 - 2025',
      'experience': 'Experience',
      'experience_title': 'Flutter Developer - Freelance Projects',
      'experience_period': 'Jan 2022 - Present',
      'experience_details':
          '• Built mobile applications using Flutter with focus on clean code and user experience\n• Created monitoring system with MQTT for real-time data display from sensors and pumps\n• Developed Bluetooth car controller app for sending commands and managing connections\n• Implemented Firebase Authentication, Firestore database, and Cloud Storage in projects\n• Used Bloc/Cubit and Provider for state management across different apps\n• Designed responsive UIs that work on mobile phones and tablets\n• Published app on Google Play Store with regular updates based on user feedback',
      'certifications': 'Certifications',
      'certifications_title': 'HA Consulting Group for Automation Solutions',
      'certifications_period': '2025',
      'certifications_details':
          '• PLC Basic Programming - 3 weeks intensive training (Aug - Sep 2025) — Grade: Excellent\n• Electric Motor & Drive Programming - 2 weeks (Sep 2025) — Grade: Excellent\n• Classic Control Systems - 3 weeks (Jul - Aug 2025) — Grade: Excellent',

      // Skills Section
      'skills_tech':
          'Mobile: Flutter, Dart, Android Studio, VS Code | State Management: Bloc, Cubit, GetX, Provider | Backend: REST APIs, Dio, Firebase, MQTT | Storage: Hive, SharedPreferences | Hardware: Bluetooth, MQTT | UI: Responsive, Custom Widgets, Material Design',

      // Projects Section
      'featured_projects': 'Featured Projects',
      'projects_subtitle':
          'Here are some of my recent projects that showcase my skills',
      'view_all_github': 'View All Projects on GitHub',
      'view_code': 'View Code',

      // Project 1
      'project1_title': 'October SCADA',
      'project1_desc':
          'Mobile app for monitoring water pumping stations with real-time data from sensors. Used MQTT client to receive data about pumps, valves, tank levels, and pressure. Responsive UI with animated water tank displays, weather info, and gauges. Technologies: Flutter, MQTT Client, Riverpod, Responsive UI',

      // Project 2
      'project2_title': 'Auto Car Controller',
      'project2_desc':
          'Bluetooth app to control Arduino-based car with manual and automatic modes. Bluetooth scanning, pairing, and connection with auto-reconnect. Control interface with buttons for directions and slider for speed. Status screen showing connection info and last sent commands. Technologies: Flutter, Bluetooth Serial, Provider, SharedPreferences',

      // Project 3
      'project3_title': '3SA - Autism Support',
      'project3_desc':
          'Educational app to help autistic children learn communication and behavior skills. Interactive lessons with animations, sounds, and visual feedback. Multimedia content (images, videos, audio) that loads based on progress. Technologies: Flutter, GetX, Custom Animations, Media Players',

      // Project 4
      'project4_title': 'Fitness Tracker',
      'project4_desc':
          'App for tracking workouts, meals, and body measurements. Log weight, create workout plans, and view progress with charts. Clean Architecture pattern, Cubit for state management, Hive for local data storage. Technologies: Flutter, Cubit, Clean Architecture, Hive, Charts',

      // Project 5
      'project5_title': 'Bookify',
      'project5_desc':
          'Book reading app with bookmarks, light/dark themes, and reading history. Simple UI with easy navigation and comfortable reading experience. Used Hive to save books locally for offline reading. Technologies: Flutter, GetX, Hive, Custom Widgets',

      // Project 6
      'project6_title': 'Paqyat - Islamic App',
      'project6_desc':
          'Published app on Google Play for Quran, Azkar, prayer times, and Islamic media. Arabic support with RTL layout and multiple theme colors. Used Firebase Storage to host and deliver audio/video content. Technologies: Flutter, Firebase Storage, Media Players',

      // Contact Section
      'get_in_touch': 'Get In Touch',
      'contact_subtitle':
          'Feel free to reach out for collaborations or just a friendly chat',
      'contact_info': 'Contact Information',
      'contact_discuss': 'Let\'s discuss your next project',
      'email': 'Email',
      'phone': 'Phone',
      'linkedin': 'LinkedIn',
      'linkedin_value': 'linkedin.com/in/ibrahim-tharwat-18aa77323',
      'location': 'Location',
      'location_value': 'Zagazig, Egypt',
      'follow_me': 'Follow Me',
      'your_name': 'Your Name',
      'name_hint': 'ابراهيم ثروت',
      'your_email': 'Your Email',
      'email_hint': 'ibrahimthswd@gmail.com',
      'your_message': 'Your Message',
      'message_hint': 'Tell me about your project...',
      'send_message': 'Send Message',
      'name_required': 'Please enter your name',
      'email_required': 'Please enter your email',
      'email_invalid': 'Please enter a valid email',
      'message_required': 'Please enter your message',
      'opening_email': 'Opening email client...',

      // Footer
      'built_with': 'Built with Flutter',
      'all_rights': 'All rights reserved.',
      'quick_links': 'Quick Links',
      'services': 'Services',
      'mobile_dev': 'Mobile Development',
      'ui_ux': 'UI/UX Design',
      'consulting': 'Consulting',
      'maintenance': 'Maintenance',
      'connect': 'Connect',
      'developer_desc':
          'Flutter Developer passionate about\ncreating beautiful mobile experiences.',
    },
    'ar': {
      // Navigation
      'home': 'الرئيسية',
      'about': 'نبذة',
      'skills': 'المهارات',
      'projects': 'المشاريع',
      'contact': 'تواصل معي',

      // Hero Section
      'hi_im': 'مرحباً، أنا',
      'name': 'إبراهيم ثروت',
      'title': 'مطور Flutter',
      'hero_description':
          'طالب هندسة اتصالات وإلكترونيات متخصص في تطوير تطبيقات Flutter. أقوم ببناء تطبيقات جوال متعددة المنصات بكود نظيف وتجربة مستخدم ممتازة.',
      'view_work': 'شاهد أعمالي',
      'download_cv': 'تحميل السيرة الذاتية',
      'projects_completed': 'مشروع مكتمل',
      'years_experience': 'سنوات خبرة',
      'client_satisfaction': 'رضا العملاء',

      // About Section
      'about_me': 'نبذة عني',
      'about_description_1':
          'مطور تطبيقات Flutter بخلفية قوية في هندسة الاتصالات والإلكترونيات. خبرة في بناء تطبيقات جوال متعددة المنصات بكود نظيف وتجربة مستخدم ممتازة. شغوف بالأتمتة وإنترنت الأشياء والتعلم المستمر.',
      'about_description_2': 'أهم المهارات والخبرات منذ 2022:',
      'about_point_1':
          'تطوير تطبيقات الجوال: Flutter، Dart، Android Studio، VS Code، Git، GitHub',
      'about_point_2': 'إدارة الحالة: Bloc/Cubit، GetX، Provider',
      'about_point_3':
          'الواجهات الخلفية وAPIs: REST APIs، Dio، Firebase (Auth، Firestore، Storage)، MQTT',
      'about_point_4': 'التخزين المحلي: Hive، SharedPreferences',
      'about_point_5': 'تكامل العتاد: Bluetooth Serial، MQTT Client',
      'about_point_6':
          'تدريب صناعي: برمجة PLC، التحكم في المحركات الكهربائية، أنظمة التحكم',
      'about_point_7':
          'تطوير الواجهات: تصاميم متجاوبة، Widgets مخصصة، Material Design',
      'about_description_3':
          'أجمع بين الهندسة والبرمجة لتقديم حلول مبتكرة. دائم التعلم ومستعد لأي تحدٍ جديد.',
      'education': 'التعليم',
      'education_title': 'بكالوريوس هندسة اتصالات وإلكترونيات',
      'education_period': 'جامعة الزقازيق، مصر | 2020 - 2025',
      'experience': 'الخبرة',
      'experience_title': 'مطور Flutter - مشاريع حرة',
      'experience_period': 'يناير 2022 - حتى الآن',
      'experience_details':
          '• بناء تطبيقات جوال باستخدام Flutter مع التركيز على الكود النظيف وتجربة المستخدم\n• إنشاء نظام مراقبة بالـ MQTT لعرض البيانات الفورية من المستشعرات والمضخات\n• تطوير تطبيق تحكم بالسيارة عبر البلوتوث لإرسال الأوامر وإدارة الاتصال\n• تكامل Firebase Authentication وFirestore وCloud Storage في المشاريع\n• استخدام Bloc/Cubit وProvider لإدارة الحالة\n• تصميم واجهات متجاوبة تعمل على الجوال والتابلت\n• نشر تطبيق على Google Play مع تحديثات مستمرة بناءً على ملاحظات المستخدمين',
      'certifications': 'الشهادات',
      'certifications_title': 'HA Consulting Group لحلول الأتمتة',
      'certifications_period': '2025',
      'certifications_details':
          '• برمجة PLC الأساسية - تدريب مكثف 3 أسابيع (أغسطس - سبتمبر 2025) — التقدير: ممتاز\n• برمجة المحركات الكهربائية وقيادتها - أسبوعين (سبتمبر 2025) — التقدير: ممتاز\n• أنظمة التحكم الكلاسيكية - 3 أسابيع (يوليو - أغسطس 2025) — التقدير: ممتاز',

      // Skills Section
      'skills_tech':
          'تطوير الجوال: Flutter، Dart، Android Studio، VS Code | إدارة الحالة: Bloc، Cubit، GetX، Provider | الخلفية: REST APIs، Dio، Firebase، MQTT | التخزين: Hive، SharedPreferences | العتاد: Bluetooth، MQTT | الواجهات: تصاميم متجاوبة، Widgets مخصصة، Material Design',

      // Projects Section
      'featured_projects': 'مشاريع مميزة',
      'projects_subtitle': 'هذه بعض مشاريعي الأخيرة التي تعرض مهاراتي',
      'view_all_github': 'شاهد جميع المشاريع على GitHub',
      'view_code': 'شاهد الكود',

      // Project 1
      'project1_title': 'October SCADA',
      'project1_desc':
          'تطبيق لمراقبة محطات ضخ المياه مع بيانات فورية من المستشعرات. استخدم MQTT لاستقبال بيانات المضخات والصمامات ومستوى الخزانات والضغط. واجهة متجاوبة مع رسوم متحركة للخزانات، ومعلومات طقس وعدادات. التقنيات: Flutter، MQTT Client، Riverpod، Responsive UI',

      // Project 2
      'project2_title': 'Auto Car Controller',
      'project2_desc':
          'تطبيق بلوتوث للتحكم في سيارة أردوينو بأوضاع يدوية وتلقائية. فحص وربط تلقائي بالبلوتوث، واجهة تحكم بالأزرار وسلايدر للسرعة، شاشة حالة الاتصال وآخر الأوامر. التقنيات: Flutter، Bluetooth Serial، Provider، SharedPreferences',

      // Project 3
      'project3_title': '3SA - دعم التوحد',
      'project3_desc':
          'تطبيق تعليمي لمساعدة الأطفال المصابين بالتوحد على تعلم مهارات التواصل والسلوك. دروس تفاعلية مع رسوم متحركة وأصوات وتغذية بصرية. محتوى وسائط متعددة (صور، فيديو، صوت) حسب التقدم. التقنيات: Flutter، GetX، Animations، Media Players',

      // Project 4
      'project4_title': 'Fitness Tracker',
      'project4_desc':
          'تطبيق لتتبع التمارين والوجبات وقياسات الجسم. تسجيل الوزن، إنشاء خطط تمارين، وعرض التقدم برسوم بيانية. هندسة نظيفة، Cubit لإدارة الحالة، Hive للتخزين المحلي. التقنيات: Flutter، Cubit، Clean Architecture، Hive، Charts',

      // Project 5
      'project5_title': 'Bookify',
      'project5_desc':
          'تطبيق قراءة كتب مع إشارات مرجعية، سمات فاتحة/داكنة، وسجل قراءة. واجهة بسيطة وسهلة القراءة. استخدم Hive لحفظ الكتب محلياً. التقنيات: Flutter، GetX، Hive، Widgets مخصصة',

      // Project 6
      'project6_title': 'باقيات - تطبيق إسلامي',
      'project6_desc':
          'تطبيق منشور على Google Play للقرآن والأذكار وأوقات الصلاة ووسائط إسلامية. دعم العربية وRTL وألوان متعددة. استخدم Firebase Storage لاستضافة الوسائط. التقنيات: Flutter، Firebase Storage، Media Players',

      // Contact Section
      'get_in_touch': 'تواصل معي',
      'contact_subtitle': 'لا تتردد في التواصل للتعاون أو مجرد دردشة ودية',
      'contact_info': 'معلومات الاتصال',
      'contact_discuss': 'دعنا نناقش مشروعك القادم',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'linkedin': 'لينكد إن',
      'linkedin_value': 'linkedin.com/in/ibrahim-tharwat-18aa77323',
      'location': 'الموقع',
      'location_value': 'الزقازيق، مصر',
      'follow_me': 'تابعني',
      'your_name': 'اسمك',
      'name_hint': 'إبراهيم ثروت',
      'your_email': 'بريدك الإلكتروني',
      'email_hint': 'ibrahimthswd@gmail.com',
      'your_message': 'رسالتك',
      'message_hint': 'أخبرني عن مشروعك...',
      'send_message': 'إرسال الرسالة',
      'name_required': 'الرجاء إدخال اسمك',
      'email_required': 'الرجاء إدخال بريدك الإلكتروني',
      'email_invalid': 'الرجاء إدخال بريد إلكتروني صحيح',
      'message_required': 'الرجاء إدخال رسالتك',
      'opening_email': 'فتح تطبيق البريد...',

      // Footer
      'built_with': 'صُنع بـ Flutter',
      'all_rights': 'جميع الحقوق محفوظة.',
      'quick_links': 'روابط سريعة',
      'services': 'الخدمات',
      'mobile_dev': 'تطوير الجوال',
      'ui_ux': 'تصميم UI/UX',
      'consulting': 'استشارات',
      'maintenance': 'صيانة',
      'connect': 'تواصل',
      'developer_desc': 'مطور Flutter شغوف بإنشاء\nتجارب جوال رائعة.',
    },
  };

  final String languageCode;

  AppLocalizations(this.languageCode);

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }

  bool get isArabic => languageCode == 'ar';
}
