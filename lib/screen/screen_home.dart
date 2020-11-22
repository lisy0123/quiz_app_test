import 'package:flutter/material.dart';
import 'package:quiz_app_test/model/api_adapter.dart';
import 'package:quiz_app_test/model/model_quiz.dart';
import 'package:quiz_app_test/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizs = [];
  bool isLoading = false;

  _fetchQuizs() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('https://stduy-test.herokuapp.com/quiz/3/');
    if(response.statusCode == 200) {
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else{
      throw Exception('failed to load data');
    }
  }
  // List<Quiz> quizs = [
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['a', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  // ];

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('My Quiz APP'),
            backgroundColor: Colors.green,
            leading: Container(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/quiz_title.jpg',
                  width: width * 0.45,
              ),
            ),
            Padding(padding: EdgeInsets.all(width * 0.02),),
            Text(
              'TOFEL 단어장',
              style: TextStyle(
                fontSize: width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: width * 0.039),
            ),
            Padding (padding: EdgeInsets.all(width * 0.03),),
            _buildStep(width, '1. 랜덤으로 나오는 단어 퀴즈를 풀어보세요.'),
            _buildStep(width, '2. 정답을 고른 뒤 다음 문제 버튼을 눌러주세요.'),
            _buildStep(width, '3. 만점을 향해 도전해보세요!'),
            Padding(padding: EdgeInsets.all(width * 0.05),),
            Container(
              padding: EdgeInsets.only(bottom:width * 0.1),
              child: Center(
                child: ButtonTheme(
                  minWidth: width * 0.8, 
                  height: height * 0.05, 
                  shape: RoundedRectangleBorder (
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RaisedButton(
                    child: Text(
                      '지 금   퀴 즈   풀 기 !',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.037, color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: <Widget>[
                                CircularProgressIndicator(),
                                Padding(padding: EdgeInsets.only(left: width * 0.036),),
                                Text('로딩 중...'),
                            ],
                          ),
                        )
                      );
                      _fetchQuizs().whenComplete(() {
                        return Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => QuizScreen(
                                quizs: quizs,
                              ),
                            ),
                          ); 
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.15,
        width * 0.02,
        width * 0.048,
        width * 0.024,
      ),
      child: Row(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.check_box, size: width * 0.045,),
          Padding(padding: EdgeInsets.only(right: width * 0.025),),
          Text(title, style: TextStyle(fontSize: width * 0.035),),
        ],
      ),
    );
  }
}