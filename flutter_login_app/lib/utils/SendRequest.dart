import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Toast.dart';

import '../LoginPage.dart';
import 'LocalStore.dart';

var ip = "192.168.0.109:8080";

Future<dynamic> request(uri, method, header, param, body, context) async {
  print("进入request");
  if (method == "GET") {
    return getRequest(uri, header, param, body, context);
  } else {
    return postRequest(uri, header, param, body, context);
  }
}

Future<dynamic> getRequest(path, header, param, body, context) async {
  print("进入get");
  var httpClient = new HttpClient();

  var url = Uri.http(ip, path, param);
  var request = await httpClient.getUrl(url);
  //print(param);

  // 添加请求头
  request.headers.add("Content-type", "application/json");

  // 添加请求体
  //request.add(utf8.encode(json.encode(param)));

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;

  var responseBody = await response.transform(utf8.decoder).join();
  //print(responseBody);
  if (resCode == 200) {
    print("200");
    var res = json.decode(responseBody);
    print(res);
    return res;
  } else {
    print("");
  }
}

Future<dynamic> postRequest(path, header, param, body, context) async {
  print("进入post方法");

  var httpClient = new HttpClient();
  var url = Uri.http(ip, path, param);


  var request = await httpClient.postUrl(url);

  // 添加请求头 header
  request.headers.add("Content-type", "application/json");


  // 添加请求体 data/body
  request.add(utf8.encode(json.encode(body)));

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;

  var responseBody = await response.transform(utf8.decoder).join();
  print(resCode);
  if (resCode == 200) {
    // 处理返回值
    var res = json.decode(responseBody);

    if (res["code"] == 200) {
      print("返回数据");
      return res;
    } else {
      myToast(res["msg"]);
    }
    print("信息" + res["msg"]);
  } else if (resCode == 401) {
    myToast("请重新登录");
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new Login()),
        (Route<dynamic> route) => false);
  } else if(resCode == 202) {
    myToast("您的等级不够，请注意升级。");
  } else {
    myToast("请稍后重试");
  }
  
  return null;
}

Future<dynamic> getLevelRequest(path, header, param, body, context) async{
  print("进入获取权限方法");

  var httpClient = new HttpClient();
  var url = Uri.http(ip, path, param);
  var request = await httpClient.getUrl(url);

  // 构建请求头
  String userId = '';
  String token = '';

  await getStorage('user_id').then((value) => {
    userId = value
  });

  await getStorage('token').then((t) => {
    token = t
  });

  // 添加请求头 header
  request.headers.add("Content-type", "application/json");
  request.headers.add("user_id", userId);
  request.headers.add("token", token);

  var response = await request.close();

  // 返回码
  var resCode = response.statusCode;
  var responseBody = await response.transform(utf8.decoder).join();
  print(resCode);
  if (resCode == 200) {
    // 处理返回值
    var res = json.decode(responseBody);
    if(res["code"] == 200){
      print("等级足够开关锁！");
      print(res);
      return res;
    }else {
      myToast(res["msg"]);
    }
    print("信息" + res["msg"]);
  }else if (resCode == 401) {
    myToast("请重新登录");
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new Login()),
            (Route<dynamic> route) => false);
  } else if(resCode == 202) {
    myToast("您的等级不够，请注意升级。");
  } else {
    myToast("请稍后重试");
  }

  return null;
}