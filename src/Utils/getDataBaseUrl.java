package Utils;

public class getDataBaseUrl {
	public static String getUrl(String ip ,String port,String database){
		return "jdbc:sqlserver://"+ip+":"+port+";DatabaseName="+database;
	}
}
