package Utils;

import com.google.gson.Gson;

import Bean.CommonResponse;

public class CommonJson {
		public static String getCommonJson(boolean state,String Json){
			Gson gson = new Gson();
			CommonResponse commonResponse = new CommonResponse();
			commonResponse.state = state;
			commonResponse.returnJson = Json;
			return gson.toJson(commonResponse);
		}
}
