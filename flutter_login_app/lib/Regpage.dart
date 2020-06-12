import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'utils/Constant.dart';
import 'utils/Toast.dart';

import 'utils/SendRequest.dart';

class Reg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'reg page',
      // 创建注册界面对象
      home: RegPage(),
    );
  }
}

class RegPage extends StatefulWidget {
  @override
  RegPageState createState() => RegPageState();
}

class RegPageState extends State<RegPage> {
  // 表单变量
  var userName = '';
  var password = '';
  var password1 = '';
  var level = '';

  var isShowPwd = false; //是否显示密码
  var isShowPwd1 = false; //是否显示密码
  var isShowClear = false; //是否显示输入框尾部的清除按钮

  //焦点
  FocusNode focusNodeUserName = new FocusNode();
  FocusNode focusNodePassword = new FocusNode();
  FocusNode focusNodePassword1 = new FocusNode();
  FocusNode focusNodeLevel = new FocusNode();

  //表单状态
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController userNameController = new TextEditingController();

  @override
  void initState() {
    //设置焦点监听
    focusNodeUserName.addListener(focusNodeListener);
    focusNodePassword.addListener(focusNodeListener);
    focusNodePassword1.addListener(focusNodeListener);
    focusNodeLevel.addListener(focusNodeListener);

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
    // 移除焦点监听
    focusNodeUserName.removeListener(focusNodeListener);
    focusNodePassword.removeListener(focusNodeListener);
    focusNodePassword1.removeListener(focusNodeListener);
    focusNodeLevel.removeListener(focusNodeListener);
    userNameController.dispose();
    super.dispose();
  }

  // 监听焦点具体执行方法
  Future<Null> focusNodeListener() async {
    if (focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消其他框焦点状态
      focusNodePassword.unfocus();
      focusNodePassword1.unfocus();
      focusNodeLevel.unfocus();
    } else if (focusNodePassword.hasFocus) {
      print("密码框获取焦点");
      // 取消其他框焦点状态
      focusNodeUserName.unfocus();
      focusNodePassword1.unfocus();
      focusNodeLevel.unfocus();
    } else if (focusNodePassword1.hasFocus) {
      print("确认密码框获取焦点");
      // 取消其他框焦点状态
      focusNodeUserName.unfocus();
      focusNodePassword.unfocus();
      focusNodeLevel.unfocus();
    } else {
      print("会员码框获取焦点");
      // 取消其他框焦点状态
      focusNodeUserName.unfocus();
      focusNodePassword.unfocus();
      focusNodePassword1.unfocus();
    }
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
            // 用户名
            new TextFormField(
              controller: userNameController,
              focusNode: focusNodeUserName,
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
                userName = value;
              },
            ),
            // 首次密码
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
              onChanged: (String value) {
                password = value;
                print(password);
              },
            ),
            // 二次密码
            new TextFormField(
              focusNode: focusNodePassword1,
              decoration: InputDecoration(
                  labelText: "确认密码",
                  hintText: "请再次输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        isShowPwd1 = !isShowPwd1;
                      });
                    },
                  )),
              obscureText: !isShowPwd1,
              //密码验证
              validator: validatePassWordCheck,
              //保存数据
              onSaved: (String value) {
                password1 = value;
              },
            ),
            // 会员码
            new TextFormField(
              focusNode: focusNodeLevel,
              decoration: InputDecoration(
                labelText: "会员级别",
                hintText: "请输入注册会员的级别",
                prefixIcon: Icon(Icons.people),
              ),
              //保存数据
              onSaved: (String value) {
                level = value;
              },
            ),
          ],
        ),
      ),
    );

    // 注册按钮区域
    Widget regButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "注册",
          style: Theme
              .of(context)
              .primaryTextTheme
              .headline,
        ),
        // 设置按钮圆角
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          focusNodePassword.unfocus();
          focusNodeUserName.unfocus();
          focusNodePassword1.unfocus();
          focusNodeLevel.unfocus();

          if (formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            formKey.currentState.save();
            Map<String, dynamic> data = {
              'userName': userName,
              'password': password,
              'level': level,
            };
            // 注册请求
            request('/api/demo/reg', 'POST', null, null, data, context).then((
                res) {
              // 返回上一层
              if (res != null) {
                myToast("注册成功");
                Navigator.pushReplacement(context,
                    new MaterialPageRoute(builder: (context) => new Login()));
              }
            }).whenComplete(() {
              print("注册请求处理完成");
            }).catchError(() {
              myToast("出现异常,请重试");
            });
          }
        },
      ),
    );

    // 返回
    return Scaffold(
      appBar: new AppBar(
        title: new Text("注册"),
        leading: Icon(Icons.verified_user),
        backgroundColor: getMainColor(),
        centerTitle: true,
      ),
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          focusNodePassword.unfocus();
          focusNodeUserName.unfocus();
          focusNodePassword1.unfocus();
          focusNodeLevel.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(height: 20.0),
            logoImageArea,
            new SizedBox(height: 20.0),
            inputTextArea,
            new SizedBox(height: 30.0),
            regButtonArea,
            new SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  /**
   * 验证用户名
   */
  String validateUserName(value) {
    if (value.isEmpty) {
      return "用户名不能为空";
    } else if (value
        .trim()
        .length < 1 && value
        .trim()
        .length > 18) {
      return "用户名长度不正确";
    }
    return null;
  }

  /**
   * 验证第一次出入的密码是否规范
   */
  String validatePassWord(String value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value
        .trim()
        .length < 6 || value
        .trim()
        .length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  /**
   * 验证第二次输入的密码是否和前面一样
   */
  String validatePassWordCheck(String value) {
    print("当前密码：" + value + "; " + "第一次：" + password);
    if (value != password) {
      return "两次输入的密码不一致";
    }
    return null;
  }

}
