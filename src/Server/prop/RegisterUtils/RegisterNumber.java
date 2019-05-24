package Server.prop.RegisterUtils;

import Utils.CommonJson;
import Utils.JDBCUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by NB on 2017/8/7.
 */
@WebServlet(urlPatterns = "/RegisterNumber")
public class RegisterNumber extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        Connection conn = null;
        PreparedStatement sta = null;
        ResultSet rs = null;
        String paramter = request.getParameter("json");
        int num =0;
        if(paramter!=null&&!paramter.equals("")){
            try {
                conn = JDBCUtil.getSQLiteConn1();
                String SQL = "SELECT * FROM REGISTER";
                sta = conn.prepareStatement(SQL);
                rs = sta.executeQuery();
                while (rs.next()) {
                    num++;
                }
                response.getWriter().write(CommonJson.getCommonJson(true,num+""));
            } catch (ClassNotFoundException e) {
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"1"));
            }finally {
                JDBCUtil.close(rs,sta,conn);
            }
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
