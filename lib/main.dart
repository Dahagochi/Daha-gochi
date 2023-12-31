//편집자:정승원,김지혜
import 'package:dahagochi/Alarm_Time_Set.dart';
import 'package:dahagochi/hallOfFame.dart';
import 'package:dahagochi/mainPage.dart';
import 'package:dahagochi/myPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bucketService.dart';
import 'calendarPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'bottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'auth_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'myCharacter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting("ko_KR", null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BucketService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => MyCharacter()),
        ChangeNotifierProvider(create: (context) => DialogState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        primarySwatch: Colors.lightGreen, // App의 기본 색상
        scaffoldBackgroundColor: Colors.white, // Scaffold의 배경 색상
      ),
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();
        return Scaffold(
          appBar: AppBar(title: Text("로그인")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    user == null ? "로그인해 주세요 🙂" : "${user.email}님 안녕하세요 👋",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "이메일",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen), // 비활성화된 상태의 밑줄 색상
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen), // 활성화된 상태의 밑줄 색상
                    ),
                  ),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: false, // 비밀번호 안보이게
                  decoration: InputDecoration(hintText: "비밀번호",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen), // 비활성화된 상태의 밑줄 색상
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen), // 활성화된 상태의 밑줄 색상
                    ),
                  ),
                ),
                SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  style:  ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 0으로 설정하면 네모로 만들어집니다
                    ),backgroundColor: Colors.lightGreen
                  ),
                  child: Text("로그인", style: TextStyle(fontSize: 21,color: Colors.white)),
                  onPressed: () {
                    // 로그인
                    authService.signIn(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 로그인 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("로그인 성공"),
                        ));

                        // HomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),

                /// 회원가입 버튼
                ElevatedButton(
                  style:  ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 0으로 설정하면 네모로 만들어집니다
                      ),backgroundColor: Colors.lightGreen),
                  child: Text("회원가입", style: TextStyle(fontSize: 21,color: Colors.white)),
                  onPressed: () {
                    // 회원가입
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 회원가입 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [MainPage(), CalendarPage(), HallOfFame(), MyPage()];
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: Scaffold(
          body: IndexedStack(
            index: _selectedIdx,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 30,
            selectedFontSize: 8,
            unselectedFontSize: 8,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.lightGreen,
            unselectedItemColor: Colors.black12,
            showUnselectedLabels: true,
            currentIndex: _selectedIdx,
            onTap: (idx) {
              setState(() {
                _selectedIdx = idx;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "오늘일정",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: "캘린더",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined),
                label: "명예의전당",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: "마이페이지",
              )
            ],
          ),
        )
    );
  }
}