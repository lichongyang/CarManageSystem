import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.OrderDao;
import entity.Order;

public class test {
	public static void main(String args[]){
		String[] test = {"1","1","1","2","2","2","2","3","3","3","4","4"};
		Map<String, Integer> test1 = new HashMap<>();
		for (int i = 0; i < test.length; i++){
			test1.put(test[i], 0);
		}
		System.out.print(test1);
	}

}
