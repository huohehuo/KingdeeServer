package Server.prop.RegisterUtils;

import Utils.CommonJson;
import Utils.JDBCUtil;
import Utils.Lg;
import com.google.gson.Gson;

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
@WebServlet(urlPatterns = "/RegisterCheck")
public class RegisterCheck extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        Connection conn = null;
        PreparedStatement sta = null;
        ResultSet rs = null;
        String paramter = request.getParameter("json");
        String SQL="";
        Gson gson = new Gson();
        int num =0;
        Lg.e("RegisterCheck得到json：",paramter);
        if(paramter!=null&&!paramter.equals("")){
            try {
                    conn = JDBCUtil.getSQLiteConn1();
                    Lg.e("查找用户数据");
                    SQL = "SELECT * FROM REGISTER WHERE Register_code = ?";
                    sta = conn.prepareStatement(SQL);
                    sta.setString(1,paramter);
                    rs = sta.executeQuery();
                    Lg.e("rs:",rs.toString());
                    while (rs.next()){
                        num++;
                    }
                    if (num>0){
                        response.getWriter().write(CommonJson.getCommonJson(true,"OK"));
                    }else{
                        response.getWriter().write(CommonJson.getCommonJson(true,"RegisterError"));
                    }
//                    if(rs!=null){
//                        String code = rs.getString("Register_code");
//                        if(code!=null&&!code.equals("")){
//                            response.getWriter().write(CommonJson.getCommonJson(true,"OK"));
//                        }else{
//                            response.getWriter().write(CommonJson.getCommonJson(true,"RegisterError"));
//                        }
//
//                    }else{
//                        response.getWriter().write(CommonJson.getCommonJson(false,"请联系软件供应商注册"));
//                    }
            } catch (ClassNotFoundException e) {
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"1"));
            } finally {
                JDBCUtil.close(rs,sta,conn);
            }
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
