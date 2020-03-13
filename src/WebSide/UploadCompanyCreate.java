package WebSide;

import Bean.Company;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/UploadCompanyCreate")
public class UploadCompanyCreate extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("进入添加公司");
        String company_name = request.getParameter("company_name");
        String app_version = request.getParameter("app_version");
        String app_version2 = request.getParameter("app_version2");
        String app_version3 = request.getParameter("app_version3");
        String app_id = request.getParameter("app_id");
        String kd_version = request.getParameter("kd_version");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String end_time = request.getParameter("end_time");
        String img_logo_url = request.getParameter("img_logo_url");
        String user_max = request.getParameter("user_max");
//        String remark = request.getParameter("remark");
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date curDate = new Date();
        String create_time = format.format(curDate);
        Company company = new Company(company_name,app_version,app_version2,app_version3,kd_version,app_id,img_logo_url,phone,address,"",end_time,"0",create_time,user_max);
        Lg.e("得到添加公司",company);
        CompanyDao webDao = new CompanyDao();
        //检查本地是否已存在相同的appid，有则中断添加(总会有一个空的数据)
        List<Company> list2 = webDao.findCompany(app_id);
        if (list2.size()>0){
            Lg.e("检测是否存在appid",list2);
            if ("".equals(list2.get(0).getAppID())){
                boolean ok = webDao.addCompany(company);
                if (ok) {
                    response.sendRedirect("MGM/CompanyList.jsp");
                } else {
                    response.sendRedirect("errorHttp.jsp");
                }
            }else{
                response.sendRedirect("errorHttp.jsp");
            }
        }else{
            response.sendRedirect("errorHttp.jsp");
        }



    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
