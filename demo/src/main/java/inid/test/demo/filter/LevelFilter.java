package inid.test.demo.filter;

import inid.test.demo.utils.JwtUtil;
import io.jsonwebtoken.Claims;
import org.springframework.core.annotation.Order;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author wzh
 * @date 2020/6/4 21:24
 */
@Order(2)
@WebFilter(urlPatterns = "/api/demo/vip/getString")
public class LevelFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;

        String token = request.getHeader("token");
        String userId = request.getHeader("user_id");

        Claims claims = JwtUtil.getTokenClaim(token);
        int level = Integer.parseInt(claims.get("level").toString());
        if(level < 3) {
            response.setStatus(HttpServletResponse.SC_ACCEPTED);
            response.setHeader("Content-type","application/json");
            response.getWriter().write("level");
            return;
        }

        filterChain.doFilter(servletRequest,servletResponse);
    }

    @Override
    public void destroy() {

    }
}
