package WebSide.GW;

import Bean.StatisticalBean;
import Utils.Lg;
import WebSide.StatisticalDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class pl_find
 */
@WebServlet(urlPatterns = "/ActiveUser_find")
public class ActiveUser_find extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		  request.setCharacterEncoding("UTF-8");
		  response.setCharacterEncoding("UTF-8");
		try {
	         
	           String appid=request.getParameter("json");
			Lg.e("得到活跃查询的公司id",appid);
			StatisticalDao run=new StatisticalDao();
//	          	stu.setHid(hid);
	           List<StatisticalBean> list2 = run.getUpgradeListByAppID(appid);
	           if (list2.size()>0){
				   request.setAttribute("statistical", list2);
				   request.getRequestDispatcher("MGM/ActiveUserList4AppID.jsp").forward(request, response);
			   }else{
				   request.setAttribute("statistical", null);
				   request.getRequestDispatcher("MGM/ActiveUserList4AppID.jsp").forward(request, response);
			   }

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
