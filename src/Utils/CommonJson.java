package Utils;

import Bean.CommonResponse;
import com.google.gson.Gson;

import java.io.*;

public class CommonJson {
	private static final String PATH = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\Assist\\DownData\\";

	public static String getCommonJson(boolean state,String Json){
			Gson gson = new Gson();
			CommonResponse commonResponse = new CommonResponse();
			commonResponse.state = state;
			commonResponse.returnJson = Json;
			return gson.toJson(commonResponse);
		}
	//将异常写入文件
	public static boolean writeToSDcard(String txtName,String error){
		try {
			File filedir = new File(PATH);
			if (!filedir.exists()) {
				filedir.mkdirs();
			}
			long currenttime = System.currentTimeMillis();
			File exfile = new File(PATH+File.separator+txtName+".txt");
			PrintWriter pw = null;
			pw = new PrintWriter(new BufferedWriter(new FileWriter(exfile)));
			pw.println(error);
			pw.close();
		} catch (IOException e) {
			return false;
		}

		return true;

	}
}
