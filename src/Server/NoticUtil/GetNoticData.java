package Server.NoticUtil;

import Bean.DownloadReturnBean;
import Bean.NoticBean;
import Bean.SearchBean;
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
import java.util.ArrayList;

/**
 * 获取消息推送，app获取一次保存本地后，下次会为空
 */
@WebServlet(urlPatterns = "/GetNoticData")
public class GetNoticData extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        String parameter = request.getParameter("json");
        Gson gson = new Gson();
        Connection conn = null;
        PreparedStatement sta = null;
        boolean execute = true;
        ResultSet rs = null;
        ArrayList<NoticBean> list = new ArrayList<>();
        if(parameter!=null&&!parameter.equals("")){
            try {
                DownloadReturnBean downloadReturnBean = new DownloadReturnBean();
                System.out.println(parameter);
                conn = JDBCUtil.getConn(request);
                System.out.println(request.getParameter("sqlip")+" "+request.getParameter("sqlport")+" "+request.getParameter("sqlname")+" "+request.getParameter("sqlpass")+" "+request.getParameter("sqluser"));

                SearchBean bean = gson.fromJson(parameter, SearchBean.class);
                sta = conn.prepareStatement("exec proc_PDAPushNoneCheck ?,?");

                sta.setString(1, bean.val1);
                sta.setString(2, bean.val2);
                rs = sta.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
                        NoticBean cBean = new NoticBean();
                        cBean.FBillNo					=rs.getString("推送单号");
                        cBean.FActivityType					=rs.getString("单据类型");
                        cBean.FNumAll					=rs.getString("总行数");
                        list.add(cBean);
                    }
                }

                downloadReturnBean.noticBeans = list;
                Lg.e("得到推送列表",list);
                response.getWriter().write(CommonJson.getCommonJson(true,gson.toJson(downloadReturnBean)));
//				response.getWriter().write(CommonJson.getCommonJson(true, ""));
            } catch (ClassNotFoundException | SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));

            }finally {
                JDBCUtil.close(null,sta,conn);
            }
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}
