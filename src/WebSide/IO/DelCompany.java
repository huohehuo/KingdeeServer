package WebSide.IO;

import Utils.Lg;
import WebSide.WebResponse;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class pl_find
 */
@WebServlet(urlPatterns = "/DelCompanyIO")
public class DelCompany extends HttpServlet {
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
//			String data=request.getParameter("data");
//			Company dBean = new Gson().fromJson(data, Company.class);
//			Lg.e("得到公司Data",data);

			String name=request.getParameter("CompanyName");
			String AppID=request.getParameter("AppID");
//			Lg.e("得到公司id",name);
			CompanyWCDao dao=new CompanyWCDao();
			boolean res =dao.deleteCompany(AppID);

			WebResponse connectResponseBean = new WebResponse();
			connectResponseBean.state = res;
			connectResponseBean.size = 0;
			connectResponseBean.backString = res?"successful~":"error";
//			connectResponseBean.companies = (ArrayList<Company>) list2;
			Lg.e("删除结果：",connectResponseBean);
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
