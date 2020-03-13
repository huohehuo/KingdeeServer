package WebSide;

import Bean.FeedBackBean;
import Bean.RegisterBean;
import Utils.JDBCUtil;
import Utils.Lg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WebDao {

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

	public List<RegisterBean> getRegister(){
		List<RegisterBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLiteConn1();
			String SQL = "SELECT * FROM REGISTER ORDER BY version DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				RegisterBean bean = new RegisterBean();
				bean.Register_code = rs.getString("Register_code");
				bean.val1 = rs.getString("Phone_msg");
				bean.val2 = rs.getString("version");
				bean.val3 = rs.getString("Last_use_date");
//				bean.Register_code = rs.getString("Register_code");
				list.add(bean);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}
	public void deleteUser(String user){
		try {
			conn = JDBCUtil.getSQLiteConn1();
			String SQL = "DELETE Register_code="+user+" FROM REGISTER";
			sta = conn.prepareStatement(SQL);
			boolean b = sta.execute();
			Lg.e("删除",b);
			if (!b){
//                response.sendRedirect("error.jsp");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
	}

	public List<FeedBackBean> getFeedBack(){
		List<FeedBackBean> list = new ArrayList<>();
		try {
			conn = JDBCUtil.getSQLiteForFeedBack();
			String SQL = "SELECT * FROM FeedBackOfWeb ORDER BY id DESC ";
			sta = conn.prepareStatement(SQL);
			rs = sta.executeQuery();
			while (rs.next()) {
				FeedBackBean bean = new FeedBackBean();
				bean.id = rs.getString("id");
				bean.name = rs.getString("name");
				bean.phone = rs.getString("phone");
				list.add(bean);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
		return list;
	}
	public void deleteFeedBack(String id){
		try {
			conn = JDBCUtil.getSQLiteForFeedBack();
			String SQL = "DELETE id="+id+" FROM FeedBackOfWeb";
			sta = conn.prepareStatement(SQL);
			boolean b = sta.execute();
			Lg.e("删除",b);
			if (!b){
//                response.sendRedirect("error.jsp");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs,sta,conn);
		}
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
