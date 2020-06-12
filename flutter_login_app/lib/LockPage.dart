import 'package:flutter/material.dart';
import 'utils/SendRequest.dart';
import 'utils/Toast.dart';

class Lock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lock page',
      // 创建锁界面对象
      home: LockPage(),
    );
  }
}

class LockPage extends StatefulWidget {
  LockPage({Key key}) : super(key: key);
  @override
  _LockState createState() => _LockState();
}

class _LockState extends State<LockPage> {
  bool _isLock = false;
  getHttpClient() async {
    getLevelRequest('/api/demo/vip/getString', null, null, null, context).then((
        res) {
      if(res != null){
        if(res["code"] == 200){
          _isLock = !_isLock;
          myToast("解锁成功！");
        }else{
          //失败，不可以解锁
          myToast("您级别不够，无法解锁！");
        }
        setState(() {});
      }else{
        //失败，不可以解锁
        myToast("失败，无法解锁！");
      }
    });
  }


  void _handleTap() {
    setState(() {
      if(_isLock == false){
        _isLock = true;
      }else{
        getHttpClient();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _handleTap,
      child: new Container(
        child: new Center(
          child: new Icon(
            _isLock ? Icons.lock : Icons.lock_open ,
            size: 200,
          ),
        ),
      ),
    );
  }
}