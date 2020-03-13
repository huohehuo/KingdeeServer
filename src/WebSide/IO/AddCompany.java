package WebSide.IO;

import Bean.Company;
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
@WebServlet(urlPatterns = "/AddCompanyIO")
public class AddCompany extends HttpServlet {
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

//			DownloadReturnBean dBean = new Gson().fromJson(commonResponse.returnJson, DownloadReturnBean.class);
			String name=request.getParameter("CompanyName");
			String AppID=request.getParameter("AppID");
			Lg.e("得到公司Name",name);
			Lg.e("得到公司ID",AppID);
			CompanyWCDao dao=new CompanyWCDao();
			Company company = new Company();
			company.CompanyName = name;
			company.AppID = AppID;
			dao.addCompany(company);

			WebResponse connectResponseBean = new WebResponse();
			connectResponseBean.state = true;
			connectResponseBean.size = 0;
			connectResponseBean.backString = "successful~";
//			connectResponseBean.companies = (ArrayList<Company>) list2;
			Lg.e("添加成功：",connectResponseBean);
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
