package WebSide;

import Bean.LiveDataBean;
import Bean.UserControlBean;
import Utils.CommonUtil;
import Utils.JDBCUtil;
import Utils.Lg;
import Utils.MathUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserControlDao {

	protected static final String FIELDS_INSERT = "rid,name,password,sex,age,clue,vip";
	protected static String INSERT_SQL = "insert into user(" + FIELDS_INSERT
			+ ")" + "values(?,?,?,?)";
	protected static String SELECT_SQL = "select " + FIELDS_INSERT
			+ " from user where name=?";
	protected static String UPDATE_SQL = "update user set "
			+ "name=?,password=?,sex=?,age=? where name=?";
	protected static String DELETE_SQL = "delete from user where name=?";

	public PreparedStatement prepStmt = null;
	Connection conn = null;
	PreparedStatement sta = null;
	ResultSet rs = null;

	//获取存在的控制公司用户信息
	public List<UserControlBean> getUserControlList(){
		List<UserControlBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT * FROM Tb_UserControl  GROUP BY imie ORDER BY realTime DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				list.add(backBean(rs));
			}
			Lg.e("获取存在的控制公司用户信息",list);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}

	//通过id获取活跃度信息
	public List<UserControlBean> getUserControlByAppID(String id){
		List<UserControlBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT * FROM Tb_UserControl where AppID = '"+id+"'  GROUP BY imie ORDER BY realTime DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				list.add(backBean(rs));
			}
			Lg.e("得到活跃度信息列表",list);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}
	//根据当天时间，查询出当天存在活跃用户的项目
	public List<UserControlBean> getUpgradeListByData(String time){
		List<UserControlBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT AppID  FROM Tb_UserControl where realtime like '"+time+"%' GROUP BY AppID";
			Lg.e("获取活跃数据："+SQL);
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				UserControlBean bean = new UserControlBean();
				bean.AppID = rs.getString("AppID");
//				bean.imie = rs.getString("num");
				list.add(bean);
			}
			Lg.e("获取活跃数据",list);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}

	//获取统计信息表中相应公司项目的IMIE用户数的数量
	public String getUserControlNum4Appid(String appid){
		int num=0;
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT distinct imie FROM Tb_UserControl WHERE AppID=?";
			sta = conn.prepareStatement(SQL);
			sta.setString(1,appid);
//			sta.setString(2,CommonUtil.getTime(true));
			rs = sta.executeQuery();
			while (rs.next()) {
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
				num++;
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num+"";
	}
	//获取统计信息表中相应公司项目的IMIE用户数的数量
	public String getUserNum4Appid(String appid){
		int num=0;
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT distinct imie FROM Tb_UserControl WHERE AppID=?";
			sta = conn.prepareStatement(SQL);
			sta.setString(1,appid);
			rs = sta.executeQuery();
			while (rs.next()) {
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
				num++;
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num+"";
	}

	//获取统计信息表中的IMIE用户数的数量
	public String getStatisticalNum(){
		int num=0;
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT distinct imie FROM Tb_UserControl";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
				num++;
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num+"";
	}
	//获取统计信息表中的当天的活跃用户数
	public String getStatisticalLiveUserNum(){
		int num=0;
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT * FROM Tb_UserControl WHERE realTime =?";
			sta = conn.prepareStatement(SQL);
			sta.setString(1,CommonUtil.getTime(true));
			rs = sta.executeQuery();
			while (rs.next()) {
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
				num++;
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num+"";
	}
	//获取统计信息表中的当天的活跃度
	public String getStatisticalActiveNum(){
		int num=0;
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT sum(num) as 总数 FROM Tb_UserControl WHERE realTime =? GROUP by realTime";
//			String SQL = "Select sum(num) as 总数,realtime From Tb_UserControl WHERE realTime =? GROUP by realTime";
			sta = conn.prepareStatement(SQL);
			sta.setString(1,CommonUtil.getTime(true));
			rs = sta.executeQuery();
			while (rs.next()) {
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
				Lg.e("得到数量",rs.getString("总数"));
				num+=MathUtil.toInt(rs.getString("总数"));
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num+"";
	}
	//获取统计信息表中的当天的活跃用户数
	public List<LiveDataBean> getStatisticalLiveData4User(String time){
		List<LiveDataBean> liveDataBeans = new ArrayList<>();
		try {

			conn = JDBCUtil.getSQLite4UserControl();
//			String SQL = "SELECT distinct realTime FROM Tb_UserControl WHERE realTime =?";
			String SQL = "Select count(1) as 行数,realtime From Tb_UserControl  where realtime like '"+time+"%' group by  realtime";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				LiveDataBean bean = new LiveDataBean();
				bean.LNum = rs.getString("行数");
				bean.LTime = rs.getString("realtime");
				bean.LDay = bean.LTime.substring(bean.LTime.length()-2,bean.LTime.length());
				liveDataBeans.add(bean);
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		Lg.e("得到当天活跃用户数据",liveDataBeans);
		return liveDataBeans;
	}
	//获取统计信息表中的当月的活跃用户数
	public List<LiveDataBean> getStatisticalLiveData4Num(String time){
		List<LiveDataBean> liveDataBeans = new ArrayList<>();
		try {

			conn = JDBCUtil.getSQLite4UserControl();
//			String SQL = "SELECT distinct realTime FROM Tb_UserControl WHERE realTime =?";
			String SQL = "Select sum(num) as 总数,realtime From Tb_UserControl  where realtime like '"+time+"%' group by  realtime";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				LiveDataBean bean = new LiveDataBean();
				bean.LNum = rs.getString("总数");
				bean.LTime = rs.getString("realtime");
				bean.LDay = bean.LTime.substring(bean.LTime.length()-2,bean.LTime.length());
				liveDataBeans.add(bean);
//			Lg.e("得到行数"+rs.getRow());
//			num=rs.getRow();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		Lg.e("得到当月活跃用户数据Num",liveDataBeans);
		return liveDataBeans;
	}



	//获取版本信息
	public List<UserControlBean> findStatisticalBean(String appid){
		List<UserControlBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "SELECT * FROM Tb_UserControl WHERE AppID='"+appid+"' ORDER BY uid DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				list.add(backBean(rs));
			}
			Lg.e("通过appid找到版本信息列表",list);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}

	//更新统计信息：目前只能更新当前appid和当前手机的用户；现阶段无法实现高并发，可研究Firebird
	public synchronized boolean updataStatis(UserControlBean company){
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String findSQL ="select num from Tb_UserControl where AppID=? and realTime=? and imie=?";
			sta = conn.prepareStatement(findSQL);
			sta.setString(1,company.AppID);
			sta.setString(2,company.realTime);
			sta.setString(3,company.imie);
			rs = sta.executeQuery();
			String num="";
			while (rs.next()) {
				num = rs.getString("num");
			}
			Lg.e("需要修改的版本信息："+num);
			//若本地无该公司的版本信息，则新增
			if (MathUtil.toD(num)<=0){
				String SQL = "INSERT INTO Tb_UserControl (CompanyName, App_Version,AppID,imie," +
						"realTime,num,onActivity,phone) VALUES (?,?,?,?,?,?,?,?)";
				sta = conn.prepareStatement(SQL);
				sta.setString(1,company.CompanyName);
				sta.setString(2,company.AppVersion);
				sta.setString(3,company.AppID);
				sta.setString(4,company.imie);
				sta.setString(5,company.realTime);
				sta.setString(6,"1");
				sta.setString(7,company.can_use);
				int i = sta.executeUpdate();
				if(i>0){
					//更新公司信息表的app版本号
//					changeCompanyVersion(company);
					//更新公司信息表的log日志
//					changeCompanyLog(company.AppID,company.UpgradeLog);
					return true;
				}else{
					return false;
				}
			}else{
				int addnum=MathUtil.toInt(num)+1;
				Lg.e("写入数量:"+addnum);
				String SQL = "UPDATE Tb_UserControl set num=?,realTime =?,phone=? WHERE AppID=? AND imie = ?";
//				Lg.e("更新数据库语句"+SQL);
				sta = conn.prepareStatement(SQL);
				sta.setString(1,addnum+"");
				sta.setString(2,company.realTime);
//				sta.setString(3,company.phone);
				sta.setString(4,company.AppID);
				sta.setString(5,company.imie);
				int i = sta.executeUpdate();
				if(i>0){
					//更新公司信息表的app版本号
//					changeCompanyVersion(company);
					//更新公司信息表的log日志
//					changeCompanyLog(company.AppID,company.UpgradeLog);
					return true;
				}else{
//					JDBCUtil.close(rs,sta,conn);
					return false;
				}
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			JDBCUtil.close(rs,sta,conn);
		} catch (SQLException e) {
			e.printStackTrace();
//			JDBCUtil.close(rs,sta,conn);
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return false;
	}
	//更新版本信息表时，同时更新公司信息表的app版本号
	private void changeCompanyVersion(UserControlBean company){
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String findSQL ="select COUNT(*) as 数量 from Tb_Company where AppID='"+company.AppID+"'";
			sta = conn.prepareStatement(findSQL);
			rs = sta.executeQuery();
			String num="";
			while (rs.next()) {
				num = rs.getString("数量");
			}
			Lg.e("存在需要修改的公司信息"+num);
			if (MathUtil.toD(num)<=0){
				return;
			}
			String SQL = "UPDATE Tb_Company set App_Version=?,App_Version2=?,App_Version3=? WHERE AppID='"+company.AppID+"'";
			Lg.e("更新数据库语句"+SQL);
			sta = conn.prepareStatement(SQL);
			sta.setString(1,company.AppVersion);
//			sta.setString(2,company.AppVersion2);
//			sta.setString(3,company.AppVersion3);
			int i = sta.executeUpdate();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
//			JDBCUtil.close(rs,sta,conn);
		}
	}
	//更新版本信息表时，同时更新公司信息表的Log日志信息
	private void changeCompanyLog(String appid,String log){
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String findSQL ="select COUNT(*) as 数量,Remark from Tb_Company where AppID='"+appid+"'";
			sta = conn.prepareStatement(findSQL);
			rs = sta.executeQuery();
			String num="";
			String remark="";
			while (rs.next()) {
				num = rs.getString("数量");
				remark=rs.getString("Remark");
			}
			Lg.e("存在需要修改的公司信息"+num+"-"+remark);
			if (MathUtil.toD(num)<=0){
				return;
			}
			StringBuilder builder = new StringBuilder();
			builder.append(CommonUtil.getTimeLong(true)).append("\n").append(log).append("\n").append("\n").append(remark);
			String SQL = "UPDATE Tb_Company set Remark=? WHERE AppID='"+appid+"'";
			Lg.e("更新数据库语句"+SQL);
			sta = conn.prepareStatement(SQL);
			sta.setString(1,builder.toString());
			int i = sta.executeUpdate();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
	}


	public boolean deleteCompany(String appid){
		try {
			conn = JDBCUtil.getSQLite4UserControl();
			String SQL = "DELETE FROM Tb_Company WHERE AppID = '"+appid+"'";
			Lg.e("删除项目："+SQL);
			sta = conn.prepareStatement(SQL);
			boolean b = sta.execute();
			Lg.e("删除",b);
			return b;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return false;
	}

	//统一获取表数据
	private UserControlBean backBean(ResultSet rs) throws SQLException{
		UserControlBean bean = new UserControlBean();
		bean.sid = rs.getInt("sid");
		bean.CompanyName = rs.getString("CompanyName");
		bean.AppVersion = rs.getString("App_Version");
		bean.AppID = rs.getString("AppID");
		bean.imie = rs.getString("imie");
		bean.realTime = rs.getString("realTime");
		bean.can_use = rs.getString("can_use");
		return bean;
	}
}
