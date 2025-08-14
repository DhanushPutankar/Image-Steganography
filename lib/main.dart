import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(ImageSteganographyApp(isDarkMode: isDarkMode));
}

class ImageSteganographyApp extends StatefulWidget {
  final bool isDarkMode;
  const ImageSteganographyApp({super.key, required this.isDarkMode});

  @override
  _ImageSteganographyAppState createState() => _ImageSteganographyAppState();
}

class _ImageSteganographyAppState extends State<ImageSteganographyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = isDarkMode;
    });
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Steganography',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: SplashScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  const SplashScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                toggleTheme: widget.toggleTheme,
                isDarkMode: widget.isDarkMode,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            'assets/images/Top-3-Steganography-Tools.jpg'), // Replace with your app logo
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const LoginPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          toggleTheme: widget.toggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Top-3-Steganography-Tools.jpg',
                      height: 150, // Replace with your app logo
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : ElevatedButton(
                            onPressed: _login,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white), // White text color
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 16),
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Steganography'),
        backgroundColor: Colors.teal,
      ),
      drawer: AppDrawer(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/cyber-circuit-future-technology-concept-background-free-vector.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay Container with content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white
                    .withOpacity(0.8), // Semi-transparent background
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EncodePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.lock),
                        label: const Text('Encode'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white), // Increase text size
                        ),
                      ),
                      const SizedBox(height: 30), // Increase spacing
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DecodePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Decode'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white), // Increase text size
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawerItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.teal),
    title: Text(text),
    onTap: onTap,
  );
}

class AppDrawer extends StatelessWidget {
  final Function(bool)? toggleTheme;
  final bool isDarkMode;
  const AppDrawer(
      {Key? key, required this.toggleTheme, required this.isDarkMode})
      : super(key: key);

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(text),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final username = snapshot.data!.getString('username') ?? '';
          final initials = username.isNotEmpty
              ? '${username[0]}${username[username.length - 1]}'.toUpperCase()
              : 'UN';

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.teal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        initials,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.teal),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        toggleTheme: toggleTheme ?? (_) {},
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.info,
                text: 'About Us',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.help,
                text: 'Help',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.feedback,
                text: 'Feedback',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        toggleTheme: toggleTheme ?? (_) {},
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class EncodePage extends StatefulWidget {
  const EncodePage({super.key});

  @override
  _EncodePageState createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage> {
  File? _image;
  final _messageController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _pickImage() async {
    // Show an alert dialog asking for permission to access the file manager
    bool permissionGranted = await _showPermissionDialog();

    if (permissionGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } else {
      // Handle the case where permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied to access file manager.")),
      );
    }
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission Request'),
              content: Text(
                  'Do you allow this app to access your file manager to pick an image?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Deny permission
                  },
                  child: Text('Deny'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Grant permission
                  },
                  child: Text('Allow'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  Future<void> _encodeMessage() async {
    if (_image == null ||
        _messageController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      return;
    }

    final img.Image? image = img.decodeImage(await _image!.readAsBytes());
    if (image == null) return;

    final String password = _passwordController.text;
    final String message = _messageController.text;
    _hideMessage(image, password, message);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/encoded_image.png';
    final File encodedFile = File(path)..writeAsBytesSync(img.encodePng(image));

    // Save the path to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('encoded_image_path', path);

    setState(() {
      _image = encodedFile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message encoded successfully!")));
  }

  void _hideMessage(img.Image image, String password, String message) {
    List<int> passwordBytes = password.codeUnits;
    List<int> messageBytes = message.codeUnits;

    int dataIndex = 0;

    // Encode password
    for (int i = 0; i < passwordBytes.length; i++) {
      int charCode = passwordBytes[i];
      for (int bit = 0; bit < 8; bit++) {
        int bitValue = (charCode >> bit) & 1;
        image.data[dataIndex] = (image.data[dataIndex] & ~1) | bitValue;
        dataIndex++;
      }
    }

    // Add 8 bits of zeros as a separator
    for (int bit = 0; bit < 8; bit++) {
      image.data[dataIndex] = (image.data[dataIndex] & ~1);
      dataIndex++;
    }

    // Encode message
    for (int i = 0; i < messageBytes.length; i++) {
      int charCode = messageBytes[i];
      for (int bit = 0; bit < 8; bit++) {
        int bitValue = (charCode >> bit) & 1;
        image.data[dataIndex] = (image.data[dataIndex] & ~1) | bitValue;
        dataIndex++;
      }
    }

    // Add another 8 bits of zeros to signify the end of the message
    for (int bit = 0; bit < 8; bit++) {
      image.data[dataIndex] = (image.data[dataIndex] & ~1);
      dataIndex++;
    }
  }

  void _downloadEncodedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('encoded_image_path');
    if (path != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image saved at $path")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encode Message'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const AppDrawer(
        toggleTheme: null,
        isDarkMode: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.teal.shade50,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter a password',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.teal.shade50,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _encodeMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // button color
                      foregroundColor: Colors.white, // text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Encode'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _downloadEncodedImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700, // button color
                      foregroundColor: Colors.white, //text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Download Encoded Image'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class DecodePage extends StatefulWidget {
  const DecodePage({super.key});

  @override
  _DecodePageState createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  File? _image;
  final _passwordController = TextEditingController();
  String? _decodedMessage;
  bool _isPasswordVisible = false;

  Future<void> _pickImage() async {
    // Show an alert dialog asking for permission to access the file manager
    bool permissionGranted = await _showPermissionDialog();

    if (permissionGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } else {
      // Handle the case where permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied to access file manager.")),
      );
    }
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission Request'),
              content: Text(
                  'Do you allow this app to access your file manager to pick an image?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Deny permission
                  },
                  child: Text('Deny'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Grant permission
                  },
                  child: Text('Allow'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  Map<String, String> _revealMessage(img.Image image) {
    List<int> passwordBytes = [];
    List<int> messageBytes = [];
    int charCode = 0;
    int bitIndex = 0;
    bool isNullCharacterFound = false;

    for (int i = 0; i < image.data.length; i++) {
      int bitValue = image.data[i] & 1;
      charCode |= (bitValue << bitIndex);
      bitIndex++;

      // Once 8 bits are read, we've reconstructed a character
      if (bitIndex == 8) {
        if (charCode == 0) {
          if (!isNullCharacterFound) {
            isNullCharacterFound = true;
          } else {
            break; // End of message detected
          }
        } else {
          if (!isNullCharacterFound) {
            passwordBytes.add(charCode);
          } else {
            messageBytes.add(charCode);
          }
        }
        charCode = 0;
        bitIndex = 0;
      }
    }

    String password = String.fromCharCodes(passwordBytes);
    String message = String.fromCharCodes(messageBytes);

    return {
      'password': password,
      'message': message,
    };
  }

  void _decodeMessage() async {
    if (_image == null || _passwordController.text.isEmpty) {
      return;
    }

    final img.Image? image = img.decodeImage(_image!.readAsBytesSync());
    if (image == null) return;

    final result = _revealMessage(image);
    final extractedPassword = result['password'];
    final decodedMessage = result['message'];

    setState(() {
      if (extractedPassword == _passwordController.text) {
        _decodedMessage = decodedMessage;
      } else {
        _decodedMessage = "Incorrect password!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decode Message'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: const AppDrawer(
        toggleTheme: null,
        isDarkMode: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter password',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.teal.shade50,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _decodeMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // button color
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Decode'),
            ),
            const SizedBox(height: 16),
            if (_decodedMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Decoded Message: $_decodedMessage',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme; // Non-nullable and required
  final bool isDarkMode; // Non-nullable and required

  SettingsPage({
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool isDarkMode) {
    widget.toggleTheme(isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          toggleTheme: widget.toggleTheme,
          isDarkMode: _isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: (bool value) {
                  _toggleTheme(value);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  final List<FAQ> faqs = [
    FAQ(
      question: 'What is Image Steganography?',
      answer:
          'Image Steganography is the practice of hiding a message or file within an image. This app allows you to encode a message into an image and decode it later.',
    ),
    FAQ(
      question: 'How do I encode a message?',
      answer:
          'To encode a message, click on "Encode", choose an image, enter your message and a password, and then save the encoded image.',
    ),
    FAQ(
      question: 'How do I decode a message?',
      answer:
          'To decode a message, click on "Decode", choose the encoded image, and enter the correct password to reveal the hidden message.',
    ),
    FAQ(
      question: 'Where is the encoded image saved?',
      answer:
          'The encoded image is saved in the application\'s documents directory. You can view the path when the encoding is complete.',
    ),
    FAQ(
      question: 'How does the app work?',
      answer:
          'The app allows you to hide text or files within an image. You can then save or share the steganographic image. The hidden data can later be extracted using the same app.',
    ),
    FAQ(
      question: 'What types of files can I hide within an image?',
      answer:
          'You can typically hide text files, documents, and other small files. The size and type of file depend on the app’s capabilities and the original image size.',
    ),
    FAQ(
      question: 'Can I use any image for steganography?',
      answer: 'Can I use any image for steganography?',
    ),
    FAQ(
      question: 'Will hiding data in an image affect its quality?',
      answer:
          'The quality of the image may change slightly, but it’s usually imperceptible to the naked eye. The app uses techniques to minimize any visible changes.',
    ),
    FAQ(
      question: 'Is the hidden data encrypted?',
      answer:
          'Yes, most steganography apps encrypt the hidden data to add an extra layer of security, ensuring that even if someone discovers it, they cannot read it without the correct key or password.',
    ),
    FAQ(
      question: 'How do I extract hidden data from an image?',
      answer:
          'To extract hidden data, load the steganographic image into the app and use the extraction tool. If the data is encrypted, you’ll need to enter the correct password.',
    ),
    FAQ(
      question: ' What image formats are supported?',
      answer:
          'Common formats like PNG, BMP, and JPEG are usually supported. However, some formats might work better than others for hiding data.',
    ),
    FAQ(
      question: 'Can I share the steganographic image on social media?',
      answer:
          'Yes, you can share it like any other image. However, some platforms might compress images, potentially affecting the hidden data. It’s best to test with the specific platform to ensure the hidden data remains intact.',
    ),
    FAQ(
      question: ' Is it legal to use steganography?',
      answer:
          'Steganography is legal in most places, but how you use it matters. Make sure not to use it for illegal purposes, as this could lead to legal consequences.',
    ),
    FAQ(
      question: 'How much data can I hide in an image?',
      answer:
          'The amount of data you can hide depends on the images size, format, and the method used. Larger images can generally hide more data.',
    ),
    FAQ(
      question: 'Can someone detect that an image has hidden data?',
      answer:
          'While steganography is designed to be covert, advanced analysis techniques might reveal that an image contains hidden data. However, without the correct tools or keys, it’s difficult to extract or decipher the information.',
    ),
    FAQ(
      question: ' What should I do if I forget my password for a hidden file?',
      answer:
          'If the data is encrypted and you forget the password, it may be impossible to recover the hidden data. Always keep a secure backup of your passwords.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('How to use the app:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildHelpSteps(),
              const SizedBox(height: 24),
              const Text('FAQ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...faqs.map((faq) => _buildFaqTile(faq)),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(
        toggleTheme: null,
        isDarkMode: false,
      ),
    );
  }

  List<Widget> _buildHelpSteps() {
    final steps = [
      'Step 1. Select Encode icon to Encode the message in it.',
      'Step 2. Add an image to encode a message by clicking on the camera-plus button at the bottom right side.',
      'Step 3. Enter the message you want to encode, and then add the password for decoding.',
      'Step 4. Encode the image.',
      'Step 5. Download the encoded image.',
      'Step 6. Select the Decode icon to Decode the message.',
      'Step 7. Add an image to Decode a message by clicking on the camera-plus button at the bottom right side.',
      'Step 8. Enter the correct password to decode the message.',
    ];

    return steps
        .map((step) => Text(step, style: const TextStyle(fontSize: 16)))
        .toList();
  }

  Widget _buildFaqTile(FAQ faq) {
    return Card(
      child: ExpansionTile(
        title: Text(faq.question, style: const TextStyle(fontSize: 18)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(faq.answer),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Image Steganography App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.teal[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Image Steganography App, where we believe in the power of secure communication. Our mission is to provide users with a robust, user-friendly platform for embedding hidden messages within images, ensuring your confidential information remains protected.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily:
                                'CustomFont'), // oswald regular.ttf font style is used here
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Who We Are',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Image Steganography App was developed by a team of passionate security enthusiasts and software developers committed to enhancing digital privacy. With a deep understanding of the challenges in maintaining privacy in today’s digital world, we created this app to empower users to communicate securely.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'CustomFont'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'In an era where data breaches and privacy concerns are on the rise, Image Steganography App offers a unique solution for discreet communication. We aim to make cutting-edge steganography technology accessible to everyone, whether you\'re an individual looking to protect personal messages or a business seeking to secure sensitive information.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'CustomFont'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'How It Works',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Our app uses advanced steganography techniques to conceal text or files within images. Unlike traditional encryption methods, steganography hides the very existence of the message, providing an additional layer of security. The images remain visually unchanged, making it nearly impossible for unauthorized parties to detect the hidden data.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'CustomFont'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Why Choose Image Steganography?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- User-Friendly Interface: We designed this App to be intuitive and easy to use, even for those unfamiliar with steganography.\n'
                        '- Advanced Security: Utilizing state-of-the-art algorithms, our app ensures that your hidden data is both secure and undetectable.\n'
                        '- Cross-Platform Support: Whether you\'re on a computer or mobile device, Image Steganography App is available on multiple platforms to fit your needs.\n'
                        '- Continuous Innovation: We are constantly improving our technology and adding new features to stay ahead of potential threats.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'CustomFont'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Our Vision',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'At Image Steganography App, we envision a world where secure, private communication is accessible to all. We are dedicated to continually improving our app, ensuring that your privacy is always protected.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                            fontFamily: 'CustomFont'),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Thank you for choosing our App as your trusted partner in secure communication. We look forward to serving you.',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(
        toggleTheme: null,
        isDarkMode: false,
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _feedbackController = TextEditingController();
  double _rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send us your feedback:',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here...',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Rate the app:', style: TextStyle(fontSize: 18)),
            Slider(
              value: _rating,
              onChanged: (newRating) {
                setState(() {
                  _rating = newRating;
                });
              },
              divisions: 10,
              label: '$_rating',
              min: 0,
              max: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(
        toggleTheme: null,
        isDarkMode: false,
      ),
    );
  }

  void _submitFeedback() {
    final feedback = _feedbackController.text;
    if (feedback.isNotEmpty) {
      // Handle the feedback submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Thank you for your feedback! Rating: $_rating')),
      );
      _feedbackController.clear();
      setState(() {
        _rating = 3.0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your feedback before submitting.')),
      );
    }
  }
}
