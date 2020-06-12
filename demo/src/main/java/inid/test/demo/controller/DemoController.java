package inid.test.demo.controller;

import inid.test.demo.dto.JsonData;
import inid.test.demo.dto.request.RegRequest;
import inid.test.demo.dto.response.LoginResponse;
import inid.test.demo.service.DemoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * @author wzh
 * @date 2020/6/4 20:28
 */
@RestController
@RequestMapping("/api/demo")
public class DemoController {

    @Autowired
    private DemoService demoService;

    @GetMapping("/login")
    public JsonData login(@RequestParam("userName") String userName, @RequestParam("password") String pwd) {

        LoginResponse loginResponse = null;
        try{
            System.out.println("开始登陆");
            loginResponse = demoService.login(userName,pwd);
        }catch (Exception e) {
            return new JsonData(0,e.getMessage(),"");
        }

        return new JsonData(200, "登录成功", loginResponse);
    }


    @PostMapping("/reg")
    public JsonData reg(@RequestBody @Valid RegRequest regRequest, BindingResult bindingResult) {

        if(bindingResult.hasErrors()) {
            return new JsonData(1, "参数错误","");
        }

        try {
            demoService.reg(regRequest.getUserName(), regRequest.getPassword(), regRequest.getLevel());
        }catch (Exception e){
            return new JsonData(0,e.getMessage(),"");
        }

        return new JsonData(200, "注册成功", "");
    }

    @GetMapping("/vip/getString")
    public JsonData getString() {
        return new JsonData(200,"你等级高，你牛","");
    }
}
