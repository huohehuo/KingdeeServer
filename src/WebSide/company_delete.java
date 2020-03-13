package WebSide;

import Utils.BaseData;
import Utils.CommonUtil;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class pl_find
 */
@WebServlet(urlPatterns = "/company_delete")
public class company_delete extends HttpServlet {
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
		  Lg.e("删除公司");
		try {
	         
	           String appid=request.getParameter("json");
	           String pwd=request.getParameter("pwd");
			Lg.e("得到删除公司id",appid);
			Lg.e("得到删除公司pwd",pwd);
			CompanyDao run=new CompanyDao();
			String code = CommonUtil.getString4pwd();
			Lg.e("得到密码", CommonUtil.getString4pwd());
			if (pwd.equals(code)){
				//	          	stu.setHid(hid);
				boolean okD = run.deleteCompany(appid);
				if (!okD){
					Lg.e("删除成功");
//				   response.sendRedirect("FeedBack.jsp");
					response.sendRedirect(BaseData.baseUrl+"MGM/CompanyList.jsp");
				}else{
					Lg.e("删除失败");
					response.sendRedirect(BaseData.baseUrl+"MGM/CompanyList.jsp");
//				   request.sendRedirect(BaseData.baseUrl+"MGM/CompanyList.jsp").forward(request, response);
				}
			}else{
				response.sendRedirect(BaseData.baseUrl+"MGM/CompanyList.jsp");
			}


		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
