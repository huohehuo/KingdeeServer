package WebSide;

import Utils.CommonJson;
import Utils.JDBCUtil;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/FeedBack")
public class FeedBack extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Connection conn = null;
        PreparedStatement sta = null;
//        String paramter = request.getParameter("json");
//        Lg.e("反馈信息请求。。。。"+paramter);
            try {
//                if (paramter.contains("/")){
//                    String[] split = paramter.split("/", 2);
//                    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
//                    Date curDate = new Date();
//                    String str = format.format(curDate);
//                    conn = JDBCUtil.getSQLiteForFeedBack();
//                    String SQL = "INSERT INTO FeedBackOfWeb VALUES (?,?)";
//                    sta = conn.prepareStatement(SQL);
//                    sta.setString(1,split[0]);
//                    sta.setString(2,split[1]);
//                }else{
                    String username = new String(request.getParameter("name"));
                    String password = new String(request.getParameter("phone"));
                    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
                    Date curDate = new Date();
                    String str = format.format(curDate);
                    conn = JDBCUtil.getSQLiteForFeedBack();
                    String SQL = "INSERT INTO FeedBackOfWeb VALUES (?,?,?)";
                    sta = conn.prepareStatement(SQL);
                    sta.setString(1,username);
                    sta.setString(2,password);
//                }

                int i = sta.executeUpdate();
                if(i>0){
                    Lg.e("UpdateTime Success~更新时间成功");
//                    response.getWriter().write("信息反馈成功");
                    //反馈成功
                    response.sendRedirect("FeedBack.jsp");

                }else{
                    Lg.e("UpdateTime Error~更新日期失败");
                    response.sendRedirect("error.jsp");
//                    response.getWriter().write("信息反馈---失败");
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));
            }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
