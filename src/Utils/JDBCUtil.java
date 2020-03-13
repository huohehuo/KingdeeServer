package Utils;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;

public class JDBCUtil {
	public static Connection getSQLite4Company() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbCompany.db");
		return conn;
	}
	public static Connection getSQLite4Company4WC() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbWeChatTest.db");
		return conn;
	}
	public static Connection getSQLite4Statistical() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbStatistical.db");
		return conn;
	}
	public static Connection getSQLite4UserControl() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbUserControl.db");
		return conn;
	}
	public static Connection getSQLiteForFeedBack() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbWebFeedBack.db");
		return conn;
	}
	
	public static Connection getConn(String url,String password,String user) throws SQLException, ClassNotFoundException{
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		return DriverManager.getConnection(url, user, password);
		
	}
	//简化getConn连接
	public static Connection getConn(HttpServletRequest request) throws SQLException, ClassNotFoundException{
		System.out.println(request.getParameter("sqlip") + " " + request.getParameter("sqlport") + " " + request.getParameter("sqlname") + " " + request.getParameter("sqlpass") + " " + request.getParameter("sqluser"));
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		return DriverManager.getConnection(getDataBaseUrl.getUrl(request), request.getParameter("sqluser"), request.getParameter("sqlpass"));
	}
	
	public static Connection getSQLiteConn() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbsetfile.db");
		return conn;
	}

	public static Connection getSQLiteConn1() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbother.db");
		return conn;
	}
	//获取时间表的时间
	public static Connection getSQLiteForTime() throws ClassNotFoundException, SQLException{
		Class.forName("org.sqlite.JDBC");
		Connection conn = DriverManager.getConnection("jdbc:sqlite://c:/properties/dbManager.db");
		return conn;
	}
	public static void close(ResultSet rs,PreparedStatement sta,Connection connection){
		if(rs!=null){
			try {

				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(sta!=null){
			try {
				sta.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(connection!=null){
			try {
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}


	/*
	String getbody=null;
        String parameter= null;
		Lg.e("到达");
		try{
//            getbody = ReadAsChars(request);//获取post请求中的body数据
//            PostBean postBean = gson.fromJson(getbody, PostBean.class);//解析
            parameter = postBean.json;//解密数据
        }catch (Exception e){
            response.getWriter().write(gson.toJson(new WebResponse(false,"上传失败,请求体解析错误")));
        }

	* */
	// 字符串读取post请求中的body数据
	public static String ReadAsChars(HttpServletRequest request)
	{

		BufferedReader br = null;
		StringBuilder sb = new StringBuilder("");
		try
		{
			br = request.getReader();
			String str;
			while ((str = br.readLine()) != null)
			{
				sb.append(str);
			}
			br.close();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (null != br)
			{
				try
				{
					br.close();
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
		}
		return sb.toString();
	}


}
