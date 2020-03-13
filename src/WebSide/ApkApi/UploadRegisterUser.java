package WebSide.ApkApi;

import Bean.RegisterCodeBean;
import Utils.CommonJson;
import Utils.Lg;
import WebSide.StatisticalDao;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/UploadRegisterUser")
public class UploadRegisterUser extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        String parameter = request.getParameter("json");
        PrintWriter writer = response.getWriter();
        Gson gson = new Gson();
        RegisterCodeBean statisticalBean = gson.fromJson(parameter, RegisterCodeBean.class);
        Lg.e("更细请求注册的信息",statisticalBean);
        StatisticalDao webDao = new StatisticalDao();
        boolean ok =webDao.updataRegisterUser(statisticalBean);
        if (ok){
            Lg.e("更新成功");
            writer.write(CommonJson.getCommonJson(true,""));
        }else{
            Lg.e("更新失败。。。");
            writer.write(CommonJson.getCommonJson(true,""));
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
