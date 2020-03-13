package WebSide;

import Bean.Company;
import Utils.Lg;

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
@WebServlet(urlPatterns = "/company_find_4log")
public class company_find_4log extends HttpServlet {
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
			Lg.e("得到公司id",appid);
			CompanyDao run=new CompanyDao();
//	          	stu.setHid(hid);
	           List<Company> list2 = run.findCompany(appid);
	           if (list2.size()>0){
				   request.setAttribute("company", list2.get(0));
				   request.getRequestDispatcher("MGM/Company_set_log.jsp").forward(request, response);
			   }else{
				   request.setAttribute("company", null);
				   request.getRequestDispatcher("MGM/Company_set.jsp").forward(request, response);
			   }

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
