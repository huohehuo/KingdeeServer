package WebApp;

import Utils.Lg;

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
@WebServlet(urlPatterns = "/LoginAppIO")
public class LoginAppIO extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("进入LoginAppIO");
        // 如果不存在 session 会话，则创建一个 session 对象
        HttpSession session = request.getSession(true);
//        String sssss = (String)session.getAttribute(Info.UserNameKey);
//        Lg.e("之前session"+sssss);
        String userName = request.getParameter("user_name");
        String pwd = request.getParameter("pwd");
        String ip = request.getParameter("ip");
        String port = request.getParameter("port");
        String sname = request.getParameter("server_name");
        String  spwd = request.getParameter("server_pwd");
        String database = request.getParameter("database");

        if (!"".equals(userName) && !"".equals(pwd)){
            session.setAttribute(Info.UserNameKey, userName);
            session.setAttribute(Info.UserPwdKey, pwd);
            session.setAttribute(Info.ServerIPKey, ip);
            session.setAttribute(Info.ServerPortKey, port);
            session.setAttribute(Info.ServerNameKey, sname);
            session.setAttribute(Info.ServerPwdKey, spwd);
            session.setAttribute(Info.DatabaseKey, database);


            Lg.e("获得数据:"+userName+pwd+ip+port+sname+spwd+database);
            response.sendRedirect(request.getContextPath()+"/WebApp/home.jsp");
        }else{
            response.sendRedirect("errorHttp.jsp");
        }

        // 检查网页上是否有新的访问者
//        if (session.isNew()){
//        session.setAttribute(userIDKey, userID);
//        } else {
//            visitCount = (Integer)session.getAttribute(visitCountKey);
//            visitCount = visitCount + 1;
//            userID = (String)session.getAttribute(userIDKey);
//        }
//        session.setAttribute(visitCountKey,  visitCount);
        // 设置响应内容类型
//        response.setContentType("text/html;charset=UTF-8");


//        String sssss = (String)session.getAttribute(userIDKey);
//        Lg.e("进入--公司信息修改"+sssss);
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        Date curDate = new Date();
//        String create_time = format.format(curDate);
//        Company company = new Company(company_name,app_version,app_version2,app_version3,kd_version,app_id,img_logo_url,phone,address,remark,end_time,"0",create_time,user_max);
//        Lg.e("得到修改的公司",company);
//        CompanyDao webDao = new CompanyDao();
//        boolean ok = webDao.changeCompany(company);
//        if (ok) {
//            response.sendRedirect("MGM/CompanyList.jsp");
//        } else {
//            response.sendRedirect("errorHttp.jsp");
//        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
