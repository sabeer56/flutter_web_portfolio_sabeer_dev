import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class PortFolio extends StatefulWidget {
  @override
  PortfolioPage createState() => PortfolioPage();
}

class PortfolioPage extends State<PortFolio>
    with SingleTickerProviderStateMixin {
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey educationKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Define opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Define slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void scrollToSection(GlobalKey sectionKey) {
    Scrollable.ensureVisible(
      sectionKey.currentContext!,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> sendEmail() async {
    final String mobileNumber = _phoneController.text;
    final String email = _emailController.text;
    final String message = _messageController.text;

    try {
      final response = await http.post(
        Uri.parse('https://portfolio-api-spring-boot.onrender.com'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'subject': "Message From One Of The Visitors from Your PortFolio",
          'mobileNumber': mobileNumber,
          'emailId': email,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to send email. Status code: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isScreenWidth = screenWidth > 550;
    final isScreenWidthMain = screenWidth < 900;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black87,
        actions: [
          _buildNavButton(
              'Home', () => scrollToSection(homeKey), isScreenWidth),
          _buildNavButton(
              'About Me', () => scrollToSection(aboutKey), isScreenWidth),
          _buildNavButton(
              'Education', () => scrollToSection(educationKey), isScreenWidth),
          _buildNavButton(
              'Skills', () => scrollToSection(skillsKey), isScreenWidth),
          _buildNavButton(
              'Contact', () => scrollToSection(contactKey), isScreenWidth),
          SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _buildHeroSection(screenWidth, screenHeight, !isScreenWidth),
            _buildAboutSection(!isScreenWidth, isScreenWidthMain),
            _buildEducationSection(),
            _buildSkillsSection(!isScreenWidth),
            _buildContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(
      double screenWidth, double screenHeight, bool isScreenWidth) {
    return Container(
      key: homeKey,
      height: isScreenWidth ? screenHeight * 0.6 : screenHeight,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              isScreenWidth ? 'assets/sabeerdev.jpg' : 'assets/sabeerdev.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // "HI I AM" Text
          Align(
            alignment: Alignment(
              isScreenWidth ? -0.5 : -0.6, // Horizontal position
              isScreenWidth ? -0.2 : -0.2, // Vertical position
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'HI I AM',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize:
                        isScreenWidth ? screenWidth * 0.05 : screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // "Syed Sabeer" Text
          Align(
            alignment: Alignment(
              isScreenWidth ? -0.1 : 0.2, // Horizontal position
              isScreenWidth ? -0.12 : -0.1, // Vertical position
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Syed Sabeer',
                  style: TextStyle(
                    fontSize:
                        isScreenWidth ? screenWidth * 0.03 : screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),

          // "FullStack Developer" Text
          Align(
            alignment: Alignment(
              isScreenWidth ? -0.4 : 0.6, // Horizontal position
              isScreenWidth ? -0.050 : 0.1, // Vertical position
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'FullStack Developer',
                  style: TextStyle(
                    fontSize: isScreenWidth
                        ? screenWidth * 0.025
                        : screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          ),

          // Computer Icon
          Align(
            alignment: Alignment(
              isScreenWidth ? -0.035 : -0.037, // Horizontal position
              isScreenWidth ? -0.040 : 0.1, // Vertical position
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Icon(
                  Icons.computer,
                  color: Colors.black,
                  size: isScreenWidth ? screenWidth * 0.04 : screenWidth * 0.04,
                ),
              ),
            ),
          ),

          // Download Resume Button
          Align(
            alignment: Alignment(
              isScreenWidth ? -0.090 : -0.2, // Horizontal position
              isScreenWidth ? 0.095 : 0.35, // Vertical position
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: TextButton(
                  onPressed: () async {
                    const resumeUrl =
                        'https://drive.google.com/file/d/1dq2CTNJKk6wIgFkLEbuj743ILGMWMaMD/view?usp=sharing';
                    if (await canLaunch(resumeUrl)) {
                      await launch(resumeUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Could not launch the download link')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 158, 234),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isScreenWidth ? 20 : 10,
                      vertical: isScreenWidth ? 6 : 8,
                    ),
                  ),
                  child: Text(
                    'Download Resume',
                    style: TextStyle(
                      fontSize: isScreenWidth
                          ? screenWidth * 0.02
                          : screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the code remains the same...
  Widget _buildAboutSection(bool isScreenWidth, bool isScreenWidthMain) {
    return Container(
      key: aboutKey,
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.grey[900],
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isScreenWidthMain
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 170,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/sabeer.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'software developer with 1 year of experience building scalable backend systems using Java, Spring Boot, Spring Security, and Microservices. I’m also proficient in ORM frameworks like Hibernate, relational databases such as MySQL, and modern front-end and cross-platform technologies including Vue.js, Flutter, and Go. I thrive in fast-paced environments and am passionate about writing clean, efficient code and continuously expanding my skill set across the full tech stack.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  '8608670981',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.email,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  'syedsabeera391@gmail.com',
                                  style: TextStyle(
                                    fontSize: 6,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About Me',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                  fontFamily: 'Pacifico',
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'A results-driven full-stack developer with expertise in Vue.js, Go (Golang), Flutter, and real-time application development, specializing in building scalable, user-centric solutions. Proficient in REST APIs, WebSockets, database management, and cross-platform mobile development, I have a proven track record of delivering innovative applications that solve complex problems and enhance user experiences.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        '8608670981',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.email,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        'syedsabeera391@gmail.com',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 170,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/sabeer.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isScreenWidth = screenWidth > 920;

    return Container(
      key: educationKey,
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Education',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Conditional widget based on screen width
          isScreenWidth
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEducationColumn('2006 - 2017', 'I - X',
                        'Government Higher Secondary School\nKullapuram, Theni\nGovernment Higher Secondary School in Kullapuram fostered a nurturing environment, supportive faculty, and extracurricular activities that contributed to my personal and intellectual growth, laying a strong academic foundation for future endeavors.'),
                    _buildEducationColumn('2017 - 2019', 'XI - XII',
                        'Government Higher Secondary School\nVadugapatti, Theni\nGovernment Higher Secondary School in Vadugapatti, Theni, offered a nurturing environment with dedicated faculty and modern facilities. Through extracurricular activities, it fostered holistic development and laid a strong foundation for my future.'),
                    _buildEducationColumn(
                        '2019 - 2022',
                        'Bachelor of Computer Application',
                        'Quiede Milleth College for Men\nMedavakkam, Chennai\nI pursued a Bachelor of Computer Application at Quiede Milleth College for Men in Medavakkam, Chennai. The college provided a rich learning environment with dedicated faculty and modern facilities, fostering my academic and personal growth.'),
                  ],
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildEducationColumn('2006 - 2017', 'I - X',
                        'Government Higher Secondary School\nKullapuram, Theni\nGovernment Higher Secondary School in Kullapuram fostered a nurturing environment, supportive faculty, and extracurricular activities that contributed to my personal and intellectual growth, laying a strong academic foundation for future endeavors.'),
                    SizedBox(height: 20),
                    _buildEducationColumn('2017 - 2019', 'XI - XII',
                        'Government Higher Secondary School\nVadugapatti, Theni\nGovernment Higher Secondary School in Vadugapatti, Theni, offered a nurturing environment with dedicated faculty and modern facilities. Through extracurricular activities, it fostered holistic development and laid a strong foundation for my future.'),
                    SizedBox(height: 20),
                    _buildEducationColumn(
                        '2019 - 2022',
                        'Bachelor of Computer Application',
                        'Quiede Milleth College for Men\nMedavakkam, Chennai\nI pursued a Bachelor of Computer Application at Quiede Milleth College for Men in Medavakkam, Chennai. The college provided a rich learning environment with dedicated faculty and modern facilities, fostering my academic and personal growth.'),
                  ],
                )),
        ],
      ),
    );
  }

  Widget _buildEducationColumn(String year, String level, String description) {
    return Container(
      width: 300, // Fixed width for better alignment in Row
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 5),
          Text(
            level,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isScreenWidth) {
    // List of all skills
    final List<Widget> skills = [
      _buildSkillTile(FontAwesomeIcons.html5, 'HTML', 0.8, Colors.orange),
      _buildSkillTile(FontAwesomeIcons.css3Alt, 'CSS', 0.9, Colors.blue),
      _buildSkillTile(FontAwesomeIcons.js, 'JavaScript', 0.7, Colors.yellow),
      _buildSkillTile(FontAwesomeIcons.php, 'PHP', 0.6, Colors.purple),
      _buildSkillTile(FontAwesomeIcons.c, 'C#', 0.75, Colors.purple),
      _buildSkillTile(FontAwesomeIcons.java, 'Java', 0.9, Colors.orange),
      _buildSkillTile(FontAwesomeIcons.golang, 'Go', 0.75, Colors.teal),
      _buildSkillTile(FontAwesomeIcons.database, 'SQL', 0.85, Colors.blue),
      _buildSkillTile(FontAwesomeIcons.react, 'React Js', 0.7, Colors.blue),
      _buildSkillTile(
          FontAwesomeIcons.vuejs, 'Vue Js', 0.85, Colors.lightGreen),
      _buildSkillTile(
          FontAwesomeIcons.bootstrap, 'Bootstrap', 0.7, Colors.purple),
      _buildSkillTile(FontAwesomeIcons.mobile, 'Flutter', 0.8, Colors.blue),
      _buildSkillTile(FontAwesomeIcons.codeMerge, 'Dart', 0.8, Colors.green),
    ];

    return Container(
      key: skillsKey,
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Skills',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Conditional layout based on screen width
          isScreenWidth
              ? Column(
                  children: skills, // Display all skills in a Column
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First half of the skills
                    Expanded(
                      child: Column(
                        children: skills.sublist(0, (skills.length / 2).ceil()),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Second half of the skills
                    Expanded(
                      child: Column(
                        children: skills.sublist((skills.length / 2).ceil()),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      key: contactKey,
      color: Colors.black,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'CONTACT ME',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Have a project in mind or just want to say hello? Feel free to reach out!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),
                _buildContactForm(),
                SizedBox(height: 30),
                Text(
                  'OR CONNECT WITH ME ON',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        launch(
                            'https://www.linkedin.com/in/syed-sabeer-a679a2238');
                      },
                      icon: FaIcon(FontAwesomeIcons.linkedin),
                      iconSize: 30,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        launch('https://github.com/sabeer56');
                      },
                      icon: FaIcon(FontAwesomeIcons.github),
                      iconSize: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        launch('mailto:syedsabeera391@gmail.com');
                      },
                      icon: FaIcon(FontAwesomeIcons.envelope),
                      iconSize: 30,
                      color: Colors.red[600],
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        // Replace with your WhatsApp number
                        launch('https://wa.me/918608670981');
                      },
                      icon: FaIcon(FontAwesomeIcons.whatsapp),
                      iconSize: 30,
                      color: Colors.green, // WhatsApp green color
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text(
            "© 2023 Syed Sabeer. All rights reserved.",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Email Id', _emailController, FontAwesomeIcons.user),
        SizedBox(height: 15),
        _buildTextField(
            'Mobile Number', _phoneController, FontAwesomeIcons.phone),
        SizedBox(height: 15),
        _buildTextField(
            'Purpose of Contact', _messageController, FontAwesomeIcons.message,
            maxLines: 5),
        SizedBox(height: 25),
        Center(
          child: ElevatedButton(
            onPressed: sendEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent[700],
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter your $label...',
            prefixIcon: Icon(icon, color: Colors.amber),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildNavButton(
      String title, VoidCallback onPressed, bool isScreenWidth) {
    // Define icons for each navigation button
    final Map<String, Map<String, dynamic>> navIcons = {
      'Home': {'iconTitle': Icons.home, 'iconColor': Colors.red},
      'About Me': {'iconTitle': Icons.person, 'iconColor': Colors.blue},
      'Education': {'iconTitle': Icons.school, 'iconColor': Colors.white},
      'Skills': {'iconTitle': Icons.code, 'iconColor': Colors.red},
      'Contact': {'iconTitle': Icons.contact_mail, 'iconColor': Colors.orange},
    };

    // Return IconButton if screen width is small, otherwise return TextButton
    return isScreenWidth
        ? TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(
                color: const Color.fromARGB(255, 235, 54, 244),
                fontSize: 16,
              ),
            ),
          )
        : IconButton(
            onPressed: onPressed,
            icon: Icon(
              navIcons[title]!['iconTitle'],
              color: navIcons[title]!['iconColor'],
            ),
          );
  }

  Widget _buildSkillTile(
      IconData icon, String skill, double percent, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(skill, style: TextStyle(color: Colors.white)),
      trailing: SizedBox(
        width: 100,
        child: LinearPercentIndicator(
          lineHeight: 14.0,
          percent: percent,
          backgroundColor: Colors.grey[800]!,
          progressColor: color,
          animation: true,
          animationDuration: 1000,
          center: Text(
            "${(percent * 100).toStringAsFixed(0)}%", // Display percentage
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          barRadius:
              Radius.circular(10), // Rounded corners for the progress bar
        ),
      ),
    );
  }
}
