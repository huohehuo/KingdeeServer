package WebSide.IO;

import Bean.Company;
import Utils.Lg;
import WebSide.CompanyDao;
import WebSide.WebResponse;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class pl_find
 */
@WebServlet(urlPatterns = "/GetCompanyIO")
public class GetCompany extends HttpServlet {
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
			List<Company> list2 = run.getCompany();

			WebResponse connectResponseBean = new WebResponse();
			connectResponseBean.state = true;
			connectResponseBean.size = list2.size();
			connectResponseBean.backString = "successful~";
			connectResponseBean.companies = (ArrayList<Company>) list2;
			Lg.e("请求成功：",connectResponseBean);
			response.getWriter().write(new Gson().toJson(connectResponseBean));
//	           if (list2.size()>0){
//				   request.setAttribute("company", list2.get(0));
//				   request.getRequestDispatcher("MGM/Company_set.jsp").forward(request, response);
//			   }else{
//				   request.setAttribute("company", null);
//				   request.getRequestDispatcher("MGM/Company_set.jsp").forward(request, response);
//			   }

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
