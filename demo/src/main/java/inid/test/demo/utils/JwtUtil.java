package inid.test.demo.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.util.Date;

/**
 * @author wzh
 * @date 2020/6/4 20:09
 */
public class JwtUtil {

    private static Long expiredTime = 1 * 24 * 60 * 60 * 1000L;

    private static String key = "NICE";

    /**
     *
     * @param userId
     * @param level
     * @return
     */
    public static String createToken (String userId, int level){
        Date nowDate = new Date();
        Date expireDate = new Date(nowDate.getTime() +  expiredTime);//过期时间

        return Jwts.builder()
                .setHeaderParam("typ", "JWT")
                .setIssuedAt(nowDate)
                .claim("user_id", userId)
                .claim("level", level)
                .setExpiration(expireDate)
                .signWith(SignatureAlgorithm.HS512, key)
                .compact();
    }
    /**
     * 获取token中注册信息
     * @param token
     * @return
     */
    public static Claims getTokenClaim (String token) {
        try {
            Claims res = Jwts.parser().setSigningKey(key).parseClaimsJws(token).getBody();
            res.get("level");
            return res;
        }catch (Exception e){
//            e.printStackTrace();
            return null;
        }
    }
}
