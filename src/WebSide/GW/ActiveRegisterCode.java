package WebSide.GW;

import Utils.Lg;
import Utils.MD5;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/ActiveRegisterCode")
public class ActiveRegisterCode extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 如果不存在 session 会话，则创建一个 session 对象
        HttpSession session = request.getSession(true);
        String userIDKey = new String("userID");
        String userID = new String("Runoob");
        // 检查网页上是否有新的访问者
//        if (session.isNew()){
            session.setAttribute(userIDKey, userID);
//        } else {
//            visitCount = (Integer)session.getAttribute(visitCountKey);
//            visitCount = visitCount + 1;
//            userID = (String)session.getAttribute(userIDKey);
//        }
//        session.setAttribute(visitCountKey,  visitCount);
        // 设置响应内容类型
//        response.setContentType("text/html;charset=UTF-8");


        String sssss = (String)session.getAttribute(userIDKey);

        Lg.e("进入注册Active"+sssss);
        String wrt_ip = request.getParameter("wrt_ip");
        String wrt_port = request.getParameter("wrt_port");
        String wrt_register_code = request.getParameter("wrt_register_code");
        String register_code = wrt_register_code + "fzkj601";
        String newRegister = MD5.getMD5(register_code);
        String lastRegister = MD5.getMD5(newRegister);
        String url = "http://" + wrt_ip + ":" + wrt_port + "/Assist/RegisterCode?json=" + lastRegister;
        Lg.e("网址:"+url);
        response.sendRedirect(url);
//        String getJson = HttpRequestUtils.sendGet(url);
//        Lg.e("得到数据",getJson);
//        if ("".equals(getJson)){
//            request.setAttribute("feedback_ok", "no");
//            request.setAttribute("feedback", "注册失败，地址连接失败...");
//            request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//        }else{
//            CommonResponse commonResponse = new Gson().fromJson(getJson, CommonResponse.class);
//            if (commonResponse.state){
//                Lg.e("注册成功");
//                request.setAttribute("feedback_ok", "ok");
//                request.setAttribute("feedback", "注册成功!点击返回继续");
//                request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//            }else{
//                request.setAttribute("feedback_ok", "no");
//                request.setAttribute("feedback", "注册失败");
//                request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//                Lg.e("注册失败");
//            }
//        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
