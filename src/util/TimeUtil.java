package util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeUtil {
	public static String getYear(){
		SimpleDateFormat df = new SimpleDateFormat("yyyy");
		return (df.format(new Date()));
	}

}
