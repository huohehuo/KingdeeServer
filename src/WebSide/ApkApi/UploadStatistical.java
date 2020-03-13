package WebSide.ApkApi;

import Bean.StatisticalBean;
import Utils.Lg;
import WebSide.StatisticalDao;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/UploadStatistical")
public class UploadStatistical extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        String parameter = request.getParameter("json");
        Gson gson = new Gson();
        Lg.e("更细统计信息");
        StatisticalBean statisticalBean = gson.fromJson(parameter, StatisticalBean.class);
        StatisticalDao webDao = new StatisticalDao();
        //检查本地是否已存在相同的appid，有则中断添加
        statisticalBean.realTimeShort = statisticalBean.realTime.substring(0,10);//保存短的时间段
        boolean ok =webDao.updataStatis(statisticalBean);
        if (ok){
            Lg.e("更新成功");
        }else{
            Lg.e("更新失败。。。");
        }
//        List<StatisticalBean> list2 = webDao.updataStatis(statisticalBean);
//        if (list2.size()>0){
//            response.sendRedirect("errorHttp.jsp");
//        }else{
//            boolean ok = webDao.addCompany(company);
//            if (ok) {
//                response.sendRedirect("MGM/CompanyList.jsp");
//            } else {
//                response.sendRedirect("errorHttp.jsp");
//            }
//        }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
