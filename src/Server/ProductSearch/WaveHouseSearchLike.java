package Server.ProductSearch;

import Bean.DownloadReturnBean;
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
 * Created by NB on 2017/8/7.
 */
@WebServlet(urlPatterns = "/WaveHouseSearchLike")
public class WaveHouseSearchLike extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        String parameter = request.getParameter("json");
        String version = request.getParameter("version");
        String SQL = "";
        Gson gson = new Gson();
        Connection conn = null;
        PreparedStatement sta = null;
        ResultSet rs = null;
        ArrayList<DownloadReturnBean.wavehouse> container = new ArrayList<>();
        System.out.println(parameter);
        if (parameter != null) {
            try {
                conn = JDBCUtil.getConn(request);
                SearchBean searchBean = new Gson().fromJson(parameter, SearchBean.class);
                Lg.e("search",searchBean);
                SQL = "select a.FSPID,a.FSPGroupID,a.FNumber,a.FName,a.FFullName,a.FLevel,a.FDetail,a.FParentID,"
                        + "'' as FClassTypeID,ISNULL(b.FDefaultSPID,0) as FDefaultSPID from t_StockPlace a left join "
                        + "t_StockPlaceGroup b on a.FSPID=b.FDefaultSPID where a.FDetail=1  and (a.FNumber like '%"+searchBean.val1+"%' or a.FSPID like '%"+searchBean.val1+"%' or a.FName like '%"+searchBean.val1+"%') AND a.FSPGroupID ='"+searchBean.val2+"' order by a.FNumber";//专业版
                sta = conn.prepareStatement(SQL);
                System.out.println("SQL:"+SQL);
                rs = sta.executeQuery();
                DownloadReturnBean downloadReturnBean = new DownloadReturnBean();
                if(rs!=null){
                    int i = rs.getRow();
                    System.out.println("rs的长度"+i);
                    while (rs.next()) {
                        DownloadReturnBean.wavehouse bean = downloadReturnBean.new wavehouse();
                        bean.FSPID = rs.getString("FSPID");
                        bean.FSPGroupID = rs.getString("FSPGroupID");
                        bean.FNumber = rs.getString("FNumber");
                        bean.FName = rs.getString("FName");
                        bean.FFullName = rs.getString("FFullName");
                        bean.FLevel = rs.getString("FLevel");
                        bean.FDetail = rs.getString("FDetail");
                        bean.FParentID = rs.getString("FParentID");
                        bean.FClassTypeID = rs.getString("FClassTypeID");
                        bean.FDefaultSPID = rs.getString("FDefaultSPID");
                        container.add(bean);
                    }
                    Lg.e("返回",container);
                    downloadReturnBean.wavehouse = container;
                    response.getWriter().write(CommonJson.getCommonJson(true,gson.toJson(downloadReturnBean)));
                }else{
                    response.getWriter().write(CommonJson.getCommonJson(false,"未查询到数据"));
                }


            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));

            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                response.getWriter().write(CommonJson.getCommonJson(false,"数据库错误\r\n----------------\r\n错误原因:\r\n"+e.toString()));

            }

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
