package inid.test.demo.filter;

import inid.test.demo.dao.TokenCache;
import inid.test.demo.service.DemoService;
import inid.test.demo.utils.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author wzh
 * @date 2020/6/4 21:14
 */
@Order(1)
@WebFilter(urlPatterns = "/*")
public class ApiFliter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(ApiFliter.class);
    String [] needFilterPath = {"/api/demo/reg", "/api/demo/login"};

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("开始过滤");
    }

    @Autowired
    private TokenCache tokenCache;

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;

        String path = request.getServletPath();
        logger.info("请求路径： {}", path);
        if(isNeedFiltter(path)) {
            String token = request.getHeader("token");
            String userId = request.getHeader("user_id");
            System.out.println(token);
            System.out.println(userId);
            if(token.isEmpty() || JwtUtil.getTokenClaim(token) == null) {
                logger.info("token.isEmpty() || JwtUtil.getTokenClaim(token) == null");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setHeader("Content-type","application/json");
                response.getWriter().write("reLogin");
                return;
            }
            else if(!token.equals(tokenCache.getToken(userId))){
                logger.info("!token.equals(tokenCache.getToken(userId)");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setHeader("Content-type","application/json");
                response.getWriter().write("reLogin");
                return;
            }
            // 判断有没有过期
        }
        filterChain.doFilter(servletRequest,servletResponse);
    }

    @Override
    public void destroy() {
        System.out.println("结束过滤");
    }

    private boolean isNeedFiltter(String url) {
        for(String u : needFilterPath) {
            if(url.startsWith(u)){
                return false;
            }
        }
        return true;
    }
}
