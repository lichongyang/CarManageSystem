package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import entity.Order;
import entity.OrderFindCondition;
import entity.StatisticsOrder;
import util.JDBCUtil;
import util.TimeUtil;

/*
 * 订单相关操作类 
 */
public class OrderDao{
	public Connection conn = null;
	public Statement stmt = null;
	public PreparedStatement psmt = null;
	public ResultSet rs = null;

	/*
	 * 显示所有订单
	 * */
	public List<Order> showAllOrder(){
		List<Order> result = new ArrayList<Order>();
		Order order = null;
		String sql = "select * from orderview";
		conn = JDBCUtil.getConnection();
		try{
			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()){
				String o_id = rs.getString("o_id");
				Date o_date = rs.getDate("o_date");
				String s_name = rs.getString("s_name");
				String car_type = rs.getString("car_type");
				String car_class = rs.getString("car_class");
				String car_model = rs.getString("car_model");
				int o_num = rs.getInt("o_num");
				int o_price = rs.getInt("o_price");
				order = new Order();
				order.setO_id(o_id);
				order.setO_date(o_date);
				order.setS_name(s_name);
				order.setCar_type(car_type);
				order.setCar_class(car_class);
				order.setCar_model(car_model);
				order.setO_num(o_num);
				order.setO_price(o_price);
				result.add(order);
			}
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			JDBCUtil.closeConnection(conn, stmt, psmt, rs);
		}
		return result;
	}
	
	/*
	 * 按条件检索订单信息
	 * */
	public List<Order> findOrderByCondition(OrderFindCondition condition){
		List<Order> result = new ArrayList<>();
		Order order = null;
		String sql = this.getSqlStringByCondition(condition);
		System.out.print(sql);
		if(sql.equals("")){
			result = this.showAllOrder();
		}else{
			conn = JDBCUtil.getConnection();
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String o_id = rs.getString("o_id");
					Date o_date = rs.getDate("o_date");
					String s_name = rs.getString("s_name");
					String car_type = rs.getString("car_type");
					String car_class = rs.getString("car_class");
					String car_model = rs.getString("car_model");
					int o_num = rs.getInt("o_num");
					int o_price = rs.getInt("o_price");
					order = new Order();
					order.setO_id(o_id);
					order.setO_date(o_date);
					order.setS_name(s_name);
					order.setCar_type(car_type);
					order.setCar_class(car_class);
					order.setCar_model(car_model);
					order.setO_num(o_num);
					order.setO_price(o_price);
					result.add(order);
				}	
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}
		return result;
	}
	
	/*
	 * 根据条件返回sql语句
	 * */
	private String getSqlStringByCondition(OrderFindCondition condition){
		String sql = "select * from orderview where s_name like 1 and car_type like 2 and car_class like 3 and car_model like 4 and o_date between 5 and 6";
		if (condition.getS_name().equals("不限") && condition.getCar_type().equals("不限") 
				&& condition.getCar_class().equals("不限") && condition.getCar_model().equals("不限")
				&& condition.getStart_time() == null && condition.getEnd_time() == null){
			sql="";
			return sql;
		}
		if (condition.getS_name().equals("不限")){
			sql = sql.replace("1", "s_name");
		}else{
			sql = sql.replace("1", "'%"+condition.getS_name()+"%'");
		}
		if (condition.getCar_type().equals("不限")){
			sql = sql.replace("2", "car_type");
		}else{
			sql = sql.replace("2", condition.getCar_type());
		}
		if (condition.getCar_class().equals("不限")){
			sql = sql.replace("3", "car_class");
		}else{
			sql = sql.replace("3", condition.getCar_class());
		}
		if (condition.getCar_model().equals("不限")){
			sql = sql.replace("4", "car_model");
		}else{
			sql = sql.replace("4", condition.getCar_model());
		}
		if (condition.getStart_time().equals("")){
			sql = sql.replace("5", "'1970-01-01'");
		}else{
			sql = sql.replace("5", "'" + condition.getStart_time() + "'");
		}
		if (condition.getEnd_time().equals("")){
			sql = sql.replace("6", "'2050-12-31'");
		}else{
			sql = sql.replace("6", "'"+ condition.getEnd_time() + "'");
		}
		return sql;
	}

	/*
	 * 根据不同的周期查询销售统计结果
	 * */
	public List<StatisticsOrder> showOrderByPeriod(OrderFindCondition orderFindCondition) {
		List<StatisticsOrder> result = new ArrayList<>();
		StatisticsOrder order = null;
		conn = JDBCUtil.getConnection();
		String s_name = "";
		String year = "";
		if (orderFindCondition.getS_name().equals("不限")){
			s_name = "s_name";
		}else{
			s_name = "'" + orderFindCondition.getS_name() + "'";
		}
		//如果输入的年份为空，则自动获取当前系统年份
		if (orderFindCondition.getYear() == ""){
			year = TimeUtil.getYear();
		}else{
			year = orderFindCondition.getYear();
		}
		if (orderFindCondition.getPeriod().equals("month")){
			String sql = "select month, num, class from (select date_format(o_date,'%m') as month, sum(o_num) as num, car_class as class from orderview where s_name=1 and date_format(o_date,'%Y')='2' group by month,car_class order by month) as a";
			sql = sql.replace("1", s_name);
			sql = sql.replace("2", year);
			//System.out.print(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String month = rs.getString("month");
					String car_class = rs.getString("class");
					int num = rs.getInt("num");
					order = new StatisticsOrder();
					order.setMonth(month);
					order.setCar_class(car_class);
					order.setStatistics_num(num);
					result.add(order);
				}
			}catch(SQLException e){
					e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (orderFindCondition.getPeriod().equals("season")){
			String sql = "select season, num, class from (select sum(o_num) as num, car_class as class, quarter(o_date) as season from orderview where s_name=1 and date_format(o_date,'%Y')='2' group by quarter(o_date),car_class order by season) as a";
			sql = sql.replace("1", s_name);
			sql = sql.replace("2", year);
			//System.out.print(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String month = rs.getString("season");
					String car_class = rs.getString("class");
					int num = rs.getInt("num");
					order = new StatisticsOrder();
					order.setSeason(month);
					order.setCar_class(car_class);
					order.setStatistics_num(num);
					result.add(order);
				}
			}catch(SQLException e){
					e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (orderFindCondition.getPeriod().equals("year")){
			String sql = "select year, num, class from (select date_format(o_date,'%Y') as year, sum(o_num) as num, car_class as class from orderview where date_format(o_date,'%Y')='1' group by date_format(o_date,'%Y'),car_class order by year) as a";
			sql = sql.replace("1", year);
			System.out.print(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String month = rs.getString("year");
					String car_class = rs.getString("class");
					int num = rs.getInt("num");
					order = new StatisticsOrder();
					order.setYear(month);
					order.setCar_class(car_class);
					order.setStatistics_num(num);
					result.add(order);
				}
			}catch(SQLException e){
					e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}
		return result;
	}
	
}
