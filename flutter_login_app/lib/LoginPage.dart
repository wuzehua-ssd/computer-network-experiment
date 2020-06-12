import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'utils/SendRequest.dart';
import 'utils/Constant.dart';
import 'utils/Toast.dart';
import 'utils/LocalStore.dart';
import 'Regpage.dart';
import 'LockPage.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'JWT APP',
      //创建登陆界面对象
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode focusNodeUserName = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var username = ''; //用户名
  var password = ''; //密码
  var isShowPwd = false; //是否显示密码
  var isShowClear = false; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    //设置焦点监听
    focusNodeUserName.addListener(focusNodeListener);
    focusNodePassword.addListener(focusNodeListener);
    //监听用户名框的输入改变
    userNameController.addListener(() {
      print(userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (userNameController.text.length > 0) {
        isShowClear = true;
      } else {
        isShowClear = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    focusNodeUserName.removeListener(focusNodeListener);
    focusNodePassword.removeListener(focusNodeListener);
    userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> focusNodeListener() async {
    if (focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      focusNodePassword.unfocus();
    }
    if (focusNodePassword.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      focusNodeUserName.unfocus();
    }
  }

  /**
   * 验证用户名
   */
  String validateUserName(value) {
    if (value.isEmpty) {
      return "用户名不能为空";
    } else if (value.trim().length < 1 && value.trim().length > 18) {
      return "用户名长度不正确";
    }
    return null;
  }

  /**
   * 验证密码
   */
  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6 || value.trim().length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // logo 图片区域
    Widget logoImageArea = new Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "images/login.jpg",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );

    //输入文本框区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: userNameController,
              focusNode: focusNodeUserName,
              //设置键盘类型
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (isShowClear)
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // 清空输入框内容
                    userNameController.clear();
                  },
                )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                username = value;
              },
            ),
            new TextFormField(
              focusNode: focusNodePassword,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        isShowPwd = !isShowPwd;
                      });
                    },
                  )),
              obscureText: !isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String value) {
                password = value;
              },
            )
          ],
        ),
      ),
    );

    //成功登录后的界面
    void loginSuccess() {
      var alreadySaved = true;
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context) {
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text('Authority Management'),
                ),
                body: new Center(
                  child: new Lock(),
                )
            );
          },
        ),
      );
    }

    // 登录按钮区域
    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "登录",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          focusNodePassword.unfocus();
          focusNodeUserName.unfocus();

          if (formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            formKey.currentState.save();
            Map<String, String> data = {
              "userName": username,
              "password": password
            };
            // 登录操作
            request('/api/demo/login', 'GET', null, data, null, context).then((res) {
              if (res != null) {
                print(res["data"]["userId"]);
                var userId = res["data"]["userId"];
                var token = res["data"]["token"];
                setStorage("user_id", userId);
                setStorage("token", token);
                //登陆后刷新页面
                loginSuccess();
              }
            }).whenComplete(() {
              print("登录请求处理完成");
            }).catchError(() {
              myToast("出现异常,请重试");
            });
          }
        },
      ),
    );
//第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
              Text('第三方登录'),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          new SizedBox(
            height: 18,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[500],
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: 35.0,
                onPressed: () {
                  // TODO: 微信登录解决
                },
              ),
              IconButton(
                color: Colors.blue[600],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: 35.0,
                onPressed: () {
                  // TODO: QQ登录解决
                },
              )
            ],
          )
        ],
      ),
    );

    //忘记密码  立即注册
    Widget bottomArea = new Container(
      margin: EdgeInsets.only(right: 20, left: 30),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //忘记密码按钮，点击执行事件
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              "快速注册",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //点击快速注册、执行事件
            onPressed: () {
              //跳转到新的 页面我们需要调用 navigator.push方法
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => new Reg()));
            },
          )
        ],
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("登录"),
        leading: Icon(Icons.account_box),
        backgroundColor: getMainColor(),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          focusNodePassword.unfocus();
          focusNodeUserName.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(height: 20.0),
            logoImageArea,
            new SizedBox(height: 20.0),
            inputTextArea,
            new SizedBox(height: 30.0),
            loginButtonArea,
            new SizedBox(height: 40.0),
            thirdLoginArea,
            new SizedBox(height: 15.0),
            bottomArea,
          ],
        ),
      ),
    );
  }
}