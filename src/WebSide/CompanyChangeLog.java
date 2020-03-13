package WebSide;

import Bean.Company;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/CompanyChangeLog")
public class CompanyChangeLog extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("进入--程序更新日志");
//        String company_name = request.getParameter("company_name");
//        String app_version = request.getParameter("app_version");
        String app_id = request.getParameter("app_id");
//        String kd_version = request.getParameter("kd_version");
//        String address = request.getParameter("address");
//        String phone = request.getParameter("phone");
//        String end_time = request.getParameter("end_time");
//        String img_logo_url = request.getParameter("img_logo_url");
        String remark = request.getParameter("remark");
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        Date curDate = new Date();
//        String create_time = format.format(curDate);
        Company company = new Company();
        company.AppID = app_id;company.Remark = remark;
//        Lg.e("得到修改的公司",company);
        CompanyDao webDao = new CompanyDao();
        boolean ok = webDao.changeCompanyLog(company);
        if (ok) {
            response.sendRedirect("MGM/CompanyList.jsp");
        } else {
            response.sendRedirect("errorHttp.jsp");
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
