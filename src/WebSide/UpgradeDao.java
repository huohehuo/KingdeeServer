package WebSide;

import Bean.UpgradeBean;
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

public class UpgradeDao {

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

	//获取所有版本信息
	public List<UpgradeBean> getUpgradeList(){
		List<UpgradeBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4Company();
			String SQL = "SELECT * FROM Tb_UpgradeBean ORDER BY UpgradeTime DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				list.add(backBean(rs));
			}
			Lg.e("得到公司列表",list);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}
	//获取版本信息表数量
	public String getUpgradeNum(){
		String num="";
		try {
			conn = JDBCUtil.getSQLite4Company();
			String SQL = "SELECT COUNT(*) AS 数量 FROM Tb_UpgradeBean";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				num = rs.getString("数量");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return num;
	}
	//获取版本信息表数量
	public String getUpgradeTime(String id){
		String name="";
		try {
			conn = JDBCUtil.getSQLite4Company();
			String SQL = "SELECT UpgradeTime AS 更新时间 FROM Tb_UpgradeBean WHERE AppID = '"+id+"'";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				name = rs.getString("更新时间");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return name;
	}


	//获取版本信息
	public List<UpgradeBean> findUpgradeBean(String appid){
		List<UpgradeBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLite4Company();
			String SQL = "SELECT * FROM Tb_UpgradeBean WHERE AppID='"+appid+"' ORDER BY uid DESC ";
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

	//修改版本信息，当存在时，更新，不存在就新增;之后更新公司信息表中的app版本号和日志信息
	public boolean changeUpgrade(UpgradeBean company){
		try {
			conn = JDBCUtil.getSQLite4Company();
			String findSQL ="select COUNT(*) as 数量 from Tb_UpgradeBean where AppID='"+company.getAppID()+"'";
			sta = conn.prepareStatement(findSQL);
			rs = sta.executeQuery();
			String num="";
			while (rs.next()) {
				num = rs.getString("数量");
			}
			Lg.e("需要修改的版本信息："+num);
			//若本地无该公司的版本信息，则新增
			if (MathUtil.toD(num)<=0){
				String SQL = "INSERT INTO Tb_UpgradeBean (CompanyName, App_Version,AppID," +
						"UpgradeUrl,UpgradeTime,UpgradeLog,App_Version2,App_Version3,UpgradeLog2,UpgradeLog3,UpgradeUrl2,UpgradeUrl3) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
				sta = conn.prepareStatement(SQL);
				sta.setString(1,company.CompanyName);
				sta.setString(2,company.AppVersion);
				sta.setString(3,company.AppID);
				sta.setString(4,company.UpgradeUrl);
				sta.setString(5,company.UpgradeTime);
				sta.setString(6,company.UpgradeLog);
				sta.setString(7,company.AppVersion2);
				sta.setString(8,company.AppVersion3);
				sta.setString(9,company.UpgradeLog2);
				sta.setString(10,company.UpgradeLog3);
				sta.setString(11,company.UpgradeUrl2);
				sta.setString(12,company.UpgradeUrl3);
				int i = sta.executeUpdate();
				if(i>0){
					//更新公司信息表的app版本号
					changeCompanyVersion(company);
					//更新公司信息表的log日志
					changeCompanyLog(company);
					return true;
				}else{
					return false;
				}
			}else{
				String SQL = "UPDATE Tb_UpgradeBean set CompanyName=?, App_Version=?,AppID=?," +
						"UpgradeUrl=?,UpgradeTime=?,UpgradeLog=? ,App_Version2=?,App_Version3=?,UpgradeLog2=?,UpgradeLog3=?,UpgradeUrl2=?,UpgradeUrl3=? WHERE AppID='"+company.getAppID()+"'";
				Lg.e("更新数据库语句"+SQL);
				sta = conn.prepareStatement(SQL);
				sta.setString(1,company.CompanyName);
				sta.setString(2,company.AppVersion);
				sta.setString(3,company.AppID);
				sta.setString(4,company.UpgradeUrl);
				sta.setString(5,company.UpgradeTime);
				sta.setString(6,company.UpgradeLog);
				sta.setString(7,company.AppVersion2);
				sta.setString(8,company.AppVersion3);
				sta.setString(9,company.UpgradeLog2);
				sta.setString(10,company.UpgradeLog3);
				sta.setString(11,company.UpgradeUrl2);
				sta.setString(12,company.UpgradeUrl3);
				int i = sta.executeUpdate();
				if(i>0){
					//更新公司信息表的app版本号
					changeCompanyVersion(company);
					//更新公司信息表的log日志
					changeCompanyLog(company);
					return true;
				}else{
					JDBCUtil.close(rs,sta,conn);
					return false;
				}
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			JDBCUtil.close(rs,sta,conn);
		} catch (SQLException e) {
			e.printStackTrace();
			JDBCUtil.close(rs,sta,conn);
		}finally {
//			JDBCUtil.close(rs,sta,conn);
		}
		return false;
	}
	//更新版本信息表时，同时更新公司信息表的app版本号
	private void changeCompanyVersion(UpgradeBean company){
		try {
			conn = JDBCUtil.getSQLite4Company();
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
			sta.setString(2,company.AppVersion2);
			sta.setString(3,company.AppVersion3);
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
	private void changeCompanyLog(UpgradeBean company){
		try {
			conn = JDBCUtil.getSQLite4Company();
			String findSQL ="select COUNT(*) as 数量,Remark from Tb_Company where AppID='"+company.AppID+"'";
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
			//拼接原有的Log信息
			StringBuilder builder = new StringBuilder();
			builder.append(CommonUtil.getTimeLong(true))
					.append("\n")
					.append(company.UpgradeLog)
					.append("\n").append("\n")
					.append(remark);
			String SQL = "UPDATE Tb_Company set Remark=? WHERE AppID='"+company.AppID+"'";
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
			conn = JDBCUtil.getSQLite4Company();
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
	private UpgradeBean backBean(ResultSet rs) throws SQLException{
		UpgradeBean bean = new UpgradeBean();
		bean.uid = rs.getInt("uid");
		bean.CompanyName = rs.getString("CompanyName");
		bean.AppVersion = rs.getString("App_Version");
		bean.AppVersion2 = rs.getString("App_Version2");
		bean.AppVersion3 = rs.getString("App_Version3");
		bean.AppID = rs.getString("AppID");
		bean.UpgradeLog = rs.getString("UpgradeLog");
		bean.UpgradeLog2 = rs.getString("UpgradeLog2");
		bean.UpgradeLog3 = rs.getString("UpgradeLog3");
		bean.UpgradeTime = rs.getString("UpgradeTime");
		bean.UpgradeUrl = rs.getString("UpgradeUrl");
		bean.UpgradeUrl2 = rs.getString("UpgradeUrl2");
		bean.UpgradeUrl3 = rs.getString("UpgradeUrl3");
		return bean;
	}

	/*
	admin  set
	*/
	// ����Ա��½
//	public boolean login(Admin user) throws Exception {
//		DbUtil lk = new DbUtil();
//		lk.connDb();
//		boolean i = false;
//		String sql = "select * from admin where name=? and pwd=?";
//		PreparedStatement ps = lk.getPstm(sql);
//		ps.setString(1, user.getName());
//		ps.setString(2, user.getPwd());
//		ResultSet rs1 = (ResultSet) ps.executeQuery();
//		if (rs1.next()) {
//			i = true;
//			rs1.close();
//			ps.close();
//		} else {
//			i = false;
//			rs1.close();
//			ps.close();
//		}
//		lk.closeDb();
//		return i;
//	}
//
//	// �����µ��û� ------------------------------------------------------
//	public PUser create(PUser use) {
//		try {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("insert into user(name,password,sex,age,clue,vip,mishi)"
//							+ "values(?,?,?,?,?,?,?)");
//
//			prepStmt.setString(1, use.getName());
//			prepStmt.setString(2, use.getPassword());
//			prepStmt.setString(3, use.getSex());
//			prepStmt.setInt(4, use.getAge());
//			prepStmt.setString(5, use.getClue());
//			prepStmt.setString(6, use.getVip());
//			prepStmt.setString(7, use.getMishi());
//			prepStmt.executeUpdate();
//			dbu.closeDb();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//		}
//		return use;
//	}
//
//	// �����û�����
//	public int update(PUser stu) {
//		// TODO Auto-generated method stub
//		int rowCount = 0;
//		DbUtil dbu = new DbUtil();
//		try {
//
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("update user set name=?,password=?,sex=?,age=?,clue=? where name=?");
//			prepStmt.setString(1, stu.getName());
//			prepStmt.setString(2, stu.getPassword());
//			prepStmt.setString(3, stu.getSex());
//			prepStmt.setInt(4, stu.getAge());
//			prepStmt.setString(5, stu.getName());
//			rowCount = prepStmt.executeUpdate();
//			if (rowCount == 0) {
//				throw new Exception("Update Error:Student Name:"
//						+ stu.getName());
//			}
//
//		} catch (Exception e) {
//		} finally {
//			dbu.closeDb();
//		}
//		return rowCount;
//	}
//
//	// ����ָ�����û�
//	public List<PUser> findupdate(String name) throws Exception {
//
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<PUser> puser = new ArrayList<PUser>();
//		PreparedStatement prepStmt = dbu
//				.getPstm("select * from user where name=?");
//		prepStmt.setString(1, name);
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			PUser pu = new PUser();
//			pu.setRid(rs.getInt(1));
//			pu.setName(rs.getString(2));
//			pu.setPassword(rs.getString(3));
//			pu.setSex(rs.getString(4));
//			pu.setAge(rs.getInt(5));
//			pu.setClue(rs.getString(6));
//			pu.setVip(rs.getString(7));
//			pu.setMishi(rs.getString(8));
//			puser.add(pu);
//
//		}
//		dbu.closeDb();
//		return puser;
//	}
//
//	// ���������û�
//	public List<PUser> findAll() throws Exception {
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<PUser> pus = new ArrayList<PUser>();
//		PreparedStatement prepStmt = dbu.getPstm("select * from user");
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			PUser pu = new PUser();
//			pu.setRid(rs.getInt(1));
//			pu.setName(rs.getString(2));
//			pu.setPassword(rs.getString(3));
//			pu.setSex(rs.getString(4));
//			pu.setAge(rs.getInt(5));
//			pu.setClue(rs.getString(6));
//			pu.setVip(rs.getString(7));
//			pu.setMishi(rs.getString(8));
//			pus.add(pu);
//		}
//		dbu.closeDb();
//		return pus;
//	}
//
//	// ɾ���û�-------------------------web------------------------------
//	public void remove(PUser stu) throws Exception {
//		// TODO Auto-generated method stub
//		try {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("delete from user where name=?");
//			prepStmt.setString(1, stu.getName());
//			prepStmt.executeUpdate();
//			dbu.closeDb();
//		} catch (Exception e) {
//
//		} finally {
//		}
//	}
//
//	// �� ���� ����-----------------web------------------------------------
//	public List<PUser> finduserby(String name) throws Exception {
//		List<PUser> users = new ArrayList<PUser>();
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		PreparedStatement prepStmt = dbu
//				.getPstm("select rid,name,password,sex,age,clue,vip,mishi from user where name=?");
//		prepStmt.setString(1, name);
//		ResultSet rs = prepStmt.executeQuery();
//		try {
//			while (rs.next()) {
//				PUser u = new PUser();
//				u.setRid(rs.getInt("rid"));
//				u.setName(rs.getString("name"));
//				u.setPassword(rs.getString("password"));
//				u.setAge(rs.getInt("age"));
//				u.setSex(rs.getString("sex"));
//				u.setClue(rs.getString("clue"));
//				u.setVip(rs.getString("vip"));
//				u.setMishi(rs.getString("mishi"));
//				// u.setName(rs.getString("name"));
//				users.add(u);
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		} finally {
//			dbu.closeDb();
//		}
//		return users;
//	}
//
//	// ���������û�
//	public List<PUser> show_user() throws Exception {
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<PUser> pus = new ArrayList<PUser>();
//		PreparedStatement prepStmt = dbu.getPstm("select * from user");
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			PUser pu = new PUser();
//			pu.setRid(rs.getInt(1));
//			pu.setName(rs.getString(2));
//			pu.setPassword(rs.getString(3));
//			pu.setSex(rs.getString(4));
//			pu.setAge(rs.getInt(5));
//			pu.setClue(rs.getString(6));
//			pu.setVip(rs.getString(7));
//			pu.setMishi(rs.getString(8));
//			pus.add(pu);
//		}
//		dbu.closeDb();
//		return pus;
//	}
//				/*
//					HuoDong
//					�
//					��ط���
//
//
//					*/
//
//	// �����µĻ ------------------------------------------------------
//	public HuoDong createhd(HuoDong use) {
//		try {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("insert into huodong(rid,hname,htitle,htime,hword) values(?,?,?,?,?)");
//			prepStmt.setInt(1, use.getRid());
//			prepStmt.setString(2, use.getHname());
//			prepStmt.setString(3, use.getHtitle());
//			prepStmt.setString(4, use.getHtime());
//			prepStmt.setString(5, use.getHword());
//
//			prepStmt.executeUpdate();
//			dbu.closeDb();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//		}
//		return use;
//	}
//
//	// ��ʾ���л---------------------------------------------------
//	public List<HuoDong> show_hd() throws Exception {
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<HuoDong> pus = new ArrayList<HuoDong>();
//		PreparedStatement prepStmt = dbu.getPstm("select * from huodong");
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			HuoDong pu = new HuoDong();
//			pu.setHid(rs.getInt(1));
//			pu.setRid(rs.getInt(2));
//			pu.setHname(rs.getString(3));
//			pu.setHtitle(rs.getString(4));
//			pu.setHtime(rs.getString(5));
//			pu.setHword(rs.getString(6));
//			pus.add(pu);
//		}
//		dbu.closeDb();
//		return pus;
//	}
//
//	// ɾ��ָ���------------------delete-------------------------------
//	public void deletehd(HuoDong stu) throws Exception {
//		// TODO Auto-generated method stub
//		try {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("delete from huodong where hid=?");
//			prepStmt.setInt(1, stu.getHid());
//			prepStmt.executeUpdate();
//			dbu.closeDb();
//		} catch (Exception e) {
//
//		} finally {
//		}
//	}
//				/*
//				 *
//					PingLun
//					������ط���
//				*/
//	// �����µ����� ------------------------------------------------------
//	public PingLun createpl(PingLun use) {
//		try {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			PreparedStatement prepStmt = dbu
//					.getPstm("insert into pinglun(hid,rid,pname,pword) values(?,?,?,?)");
//			prepStmt.setInt(1, use.getHid());
//			prepStmt.setInt(2, use.getRid());
//			prepStmt.setString(3, use.getPname());
//			prepStmt.setString(4, use.getPword());
//			prepStmt.executeUpdate();
//			dbu.closeDb();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//		}
//		return use;
//	}
//
//	// ��ʾ��������---------------------------------------------------
//	public List<PingLun> show_pl() throws Exception {
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<PingLun> pus = new ArrayList<PingLun>();
//		PreparedStatement prepStmt = dbu.getPstm("select * from pinglun");
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			PingLun pu = new PingLun();
//			pu.setPid(rs.getInt(1));
//			pu.setHid(rs.getInt(2));
//			pu.setRid(rs.getInt(3));
//			pu.setPname(rs.getString(4));
//			pu.setPword(rs.getString(5));
//			pus.add(pu);
//		}
//		dbu.closeDb();
//		return pus;
//	}
//
//	// ����ָ��������
//	public List<PingLun> findpl(int hid) throws Exception {
//
//		DbUtil dbu = new DbUtil();
//		dbu.connDb();
//		List<PingLun> puser = new ArrayList<PingLun>();
//		PreparedStatement prepStmt = dbu
//				.getPstm("select * from pinglun where hid=?");
//		prepStmt.setInt(1, hid);
//		ResultSet rs = prepStmt.executeQuery();
//		while (rs.next()) {
//			PingLun pu = new PingLun();
//			pu.setPid(rs.getInt(1));
//			pu.setHid(rs.getInt(2));
//			pu.setRid(rs.getInt(3));
//			pu.setPname(rs.getString(4));
//			pu.setPword(rs.getString(5));
//			puser.add(pu);
//
//		}
//		dbu.closeDb();
//		return puser;
//	}
//	 //ɾ��ָ������-----------------------delete--------------------------
//	 public void deletepl(PingLun stu) throws Exception {
//			// TODO Auto-generated method stub
//			try{
//				DbUtil dbu=new DbUtil();
//				dbu.connDb();
//				PreparedStatement prepStmt=dbu.getPstm("delete from pinglun where pid=?");
//				prepStmt.setInt(1,stu.getPid());
//				prepStmt.executeUpdate();
//				dbu.closeDb();
//			}catch(Exception e){
//
//			}finally{
//			}
//		}
//
//	/*�糤����
//	 * forvip
//	 * ��ط���
//	 *
//	 */
//
//	// �����糤����
//		public int add_vip(PUser stu) {
//			// TODO Auto-generated method stub
//			int rowCount = 0;
//			DbUtil dbu = new DbUtil();
//			try {
//
//				dbu.connDb();
//				PreparedStatement prepStmt = dbu
//						.getPstm("update user set vip=? where rid=?");
//				prepStmt.setString(1,stu.getVip());
//				prepStmt.setInt(2, stu.getRid());
//				rowCount = prepStmt.executeUpdate();
//				if (rowCount == 0) {
//					throw new Exception("Update Error:Student Name:"
//							+ stu.getName());
//				}
//
//			} catch (Exception e) {
//			} finally {
//				dbu.closeDb();
//			}
//			return rowCount;
//		}
//		 //ɾ���Ѿ�ȷ��������-----------------------delete--------------------------
//		 public void del_forvip(Forvip stu) throws Exception {
//				// TODO Auto-generated method stub
//				try{
//					DbUtil dbu=new DbUtil();
//					dbu.connDb();
//					PreparedStatement prepStmt=dbu.getPstm("delete from forvip where rid=?");
//					prepStmt.setInt(1,stu.getRid());
//					prepStmt.executeUpdate();
//					dbu.closeDb();
//				}catch(Exception e){
//
//				}finally{
//				}
//			}
//		// ��ʾ��������---------------------------------------------------
//		public List<Forvip> show_forvip() throws Exception {
//			DbUtil dbu = new DbUtil();
//			dbu.connDb();
//			List<Forvip> pus = new ArrayList<Forvip>();
//			PreparedStatement prepStmt = dbu.getPstm("select * from forvip");
//			ResultSet rs = prepStmt.executeQuery();
//			while (rs.next()) {
//				Forvip pu = new Forvip();
//
//				pu.setRid(rs.getInt(1));
//				pu.setName(rs.getString(2));
//				pu.setReason(rs.getString(3));
//				pus.add(pu);
//			}
//			dbu.closeDb();
//			return pus;
//		}
//
//		//��ʾ����---------------------------------------------------
//		 public List<Gonggao> show_allgg() throws Exception {
//					DbUtil dbu=new DbUtil();
//					dbu.connDb();
//					List<Gonggao> pus =new ArrayList<Gonggao>();
//					PreparedStatement prepStmt=dbu.getPstm("select * from xgonggao");
//					ResultSet rs=prepStmt.executeQuery();
//						while(rs.next()){
//							Gonggao pu = new Gonggao();
//							pu.setGid(rs.getInt(1));
//							pu.setGname(rs.getString(2));
//							pu.setGclue(rs.getString(3));
//							pu.setGonggao(rs.getString(4));
//							pu.setOfschool(rs.getString(5));
//							pus.add(pu);
//						}
//						dbu.closeDb();
//					return pus;
//				}
//		// ɾ������------------------------------------------------------
//					public void removegg(String gname) throws Exception {
//						// TODO Auto-generated method stub
//						try {
//							DbUtil dbu = new DbUtil();
//							dbu.connDb();
//							PreparedStatement prepStmt = dbu
//									.getPstm("delete from xgonggao where gname=?");
//							prepStmt.setString(1, gname);
//							prepStmt.executeUpdate();
//							dbu.closeDb();
//						} catch (Exception e) {
//
//						} finally {
//						}
//					}
//
//					//��ʾ���е�������Ϣ---------------------------------------------------
//					 public List<Nmchat> show_nmchat() throws Exception {
//								DbUtil dbu=new DbUtil();
//								dbu.connDb();
//								List<Nmchat> pus =new ArrayList<Nmchat>();
//								PreparedStatement prepStmt=dbu.getPstm("select * from nmchat");
//								ResultSet rs=prepStmt.executeQuery();
//									while(rs.next()){
//										Nmchat pu = new Nmchat();
//										pu.setNid(rs.getInt(1));
//										pu.setName(rs.getString(2));
//										pu.setSex(rs.getString(3));
//										pu.setClue(rs.getString(4));
//										pu.setSchool(rs.getString(5));
//										pu.setSaytext(rs.getString(6));
//
//										pus.add(pu);
//									}
//									dbu.closeDb();
//								return pus;
//							}
//					// ɾ��ָ��������Ϣ------------------delete-------------------------------
//						public void deletenm(Nmchat stu) throws Exception {
//							// TODO Auto-generated method stub
//							try {
//								DbUtil dbu = new DbUtil();
//								dbu.connDb();
//								PreparedStatement prepStmt = dbu
//										.getPstm("delete from nmchat where nid=?");
//								prepStmt.setInt(1, stu.getNid());
//								prepStmt.executeUpdate();
//								dbu.closeDb();
//							} catch (Exception e) {
//
//							} finally {
//							}
//						}
}
