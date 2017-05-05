package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.EmployeePerformance;
import entity.FindCondition;
import entity.ShopPerformance;
import entity.StatisticsClientSource;
import util.JDBCUtil;
import util.TimeUtil;

public class EmployeeDao {
	public Connection conn = null;
	public Statement stmt = null;
	public PreparedStatement psmt = null;
	public ResultSet rs = null;


	public List<EmployeePerformance> showEmployeePerformance(FindCondition findCondition) {
		// TODO Auto-generated method stub
		List<EmployeePerformance> result = new ArrayList<EmployeePerformance>();
		EmployeePerformance employeePerformance = null;
		conn = JDBCUtil.getConnection();
		String s_name = "";
		String e_name = "";
		if (findCondition.getS_name().equals("不限")){
			s_name = "s_name";
		}else{
			s_name = "'" + findCondition.getS_name() + "'";
		}
		if (findCondition.getE_name().equals("")){
			e_name = "e_name";
		}else{
			e_name = "'" + findCondition.getE_name() + "'";
		}
		String sql = " select sum(o_num) as sales_volume,sum(o_price) as sale,e_name,s_name "
				+ "from employeeperformance where o_date between '1001' and '1002' "
				+ "and s_name=1003 and e_name=1004 group by e_name;";
		sql = sql.replaceAll("1001", findCondition.getStart_time());
		sql = sql.replaceAll("1002", findCondition.getEnd_time());
		sql = sql.replaceAll("1003", s_name);
		sql = sql.replaceAll("1004", e_name);
		try{
			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()){
				int sales_volume = rs.getInt("sales_volume");
				int sale = rs.getInt("sale");
				String e_name1 = rs.getString("e_name");
				employeePerformance = new EmployeePerformance();
				employeePerformance.setSales_volume(sales_volume);
				employeePerformance.setSale(sale);
				employeePerformance.setE_name(e_name1);
				result.add(employeePerformance);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			JDBCUtil.closeConnection(conn, stmt, psmt, rs);
		}
		return result;
	}

	public ShopPerformance findShopPerformance(FindCondition findCondition) {
		// TODO Auto-generated method stub
		ShopPerformance result = new ShopPerformance();
		String s_name = "";
		String year = "";
		if (findCondition.getS_name().equals("不限")){
			s_name = "s_name";
		}else{
			s_name = "'" + findCondition.getS_name() + "'";
		}
		//如果输入的年份为空，则自动获取当前系统年份
		if (findCondition.getYear() == ""){
			year = TimeUtil.getYear();
		}else{
			year = findCondition.getYear();
		}
		if (findCondition.getPeriod().equals("month")){
			List<String> sqlList = new ArrayList<String>();
			sqlList.add("select date_format(r_date,'%m') as month,count(r_id) as all_reception "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' group by month order by month");
			sqlList.add("select date_format(r_date,'%m') as month,count(is_record) as is_record "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_record=1 group by month order by month");
			sqlList.add("select date_format(r_date,'%m') as month,count(is_buy) as is_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_buy=1 group by month order by month");
			sqlList.add("select date_format(r_date,'%m') as month,count(is_try) as is_try "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_try=1 group by month order by month");
			sqlList.add("select date_format(r_date,'%m') as month,count(second_in) as second_in "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_in=1 group by month order by month");
			sqlList.add("select date_format(r_date,'%m') as month,count(second_buy) as second_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_buy=1 group by month order by month");
			for (int i = 0; i < sqlList.size(); i++){
				conn = JDBCUtil.getConnection();
				String sql = sqlList.get(i);
				sql = sql.replaceAll("1001", s_name);
				sql = sql.replaceAll("1002", year);
				int[] calculateArray = {0,0,0,0,0,0,0,0,0,0,0,0};
				try{
					psmt = conn.prepareStatement(sql);
					rs = psmt.executeQuery();
					if (i == 0){
						while (rs.next()){
							int num = rs.getInt("all_reception");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setAll_reception(calculateArray);
					}else if (i == 1){
						while (rs.next()){
							int num = rs.getInt("is_record");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setIs_record(calculateArray);
					}else if (i == 2){
						while (rs.next()){
							int num = rs.getInt("is_buy");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setIs_buy(calculateArray);
					}else if (i == 3){
						while (rs.next()){
							int num = rs.getInt("is_try");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setIs_try(calculateArray);
					}else if (i == 4){
						while (rs.next()){
							int num = rs.getInt("second_in");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setSecond_in(calculateArray);
					}else if (i == 5){
						while (rs.next()){
							int num = rs.getInt("second_buy");
							int month = Integer.parseInt(rs.getString("month"));
							month = month - 1;
							calculateArray[month] = num;
						}
						result.setSecond_buy(calculateArray);
					}
				}catch(SQLException e){
					e.printStackTrace();
				}finally{
					JDBCUtil.closeConnection(conn, stmt, psmt, rs);
				}
			}
			return result;
		}else if (findCondition.getPeriod().equals("season")){
			List<String> sqlList = new ArrayList<String>();
			sqlList.add("select quarter(r_date) as season,count(r_id) as all_reception "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' group by season order by season");
			sqlList.add("select quarter(r_date) as season,count(is_record) as is_record "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_record=1 group by season order by season");
			sqlList.add("select quarter(r_date) as season ,count(is_buy) as is_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_buy=1 group by season order by season");
			sqlList.add("select quarter(r_date) as season ,count(is_try) as is_try "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_try=1 group by season order by season");
			sqlList.add("select quarter(r_date) as season ,count(second_in) as second_in "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_in=1 group by season order by season");
			sqlList.add("select quarter(r_date) as season ,count(second_buy) as second_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_buy=1 group by season order by season");
			for (int i = 0; i < sqlList.size(); i++){
				conn = JDBCUtil.getConnection();
				String sql = sqlList.get(i);
				sql = sql.replaceAll("1001", s_name);
				sql = sql.replaceAll("1002", year);
				int[] calculateArray = {0,0,0,0};
				try{
					psmt = conn.prepareStatement(sql);
					rs = psmt.executeQuery();
					if (i == 0){
						while (rs.next()){
							int num = rs.getInt("all_reception");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setAll_reception(calculateArray);
					}else if (i == 1){
						while (rs.next()){
							int num = rs.getInt("is_record");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setIs_record(calculateArray);
					}else if (i == 2){
						while (rs.next()){
							int num = rs.getInt("is_buy");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setIs_buy(calculateArray);
					}else if (i == 3){
						while (rs.next()){
							int num = rs.getInt("is_try");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setIs_try(calculateArray);
					}else if (i == 4){
						while (rs.next()){
							int num = rs.getInt("second_in");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setSecond_in(calculateArray);
					}else if (i == 5){
						while (rs.next()){
							int num = rs.getInt("second_buy");
							int season = Integer.parseInt(rs.getString("season"));
							season = season - 1;
							calculateArray[season] = num;
						}
						result.setSecond_buy(calculateArray);
					}
				}catch(SQLException e){
					e.printStackTrace();
				}finally{
					JDBCUtil.closeConnection(conn, stmt, psmt, rs);
				}
			}
			return result;
		}else if (findCondition.getPeriod().equals("year")){
			List<String> sqlList = new ArrayList<String>();
			sqlList.add("select date_format(r_date,'%Y') as year,count(r_id) as all_reception "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' group by year order by year");
			sqlList.add("select date_format(r_date,'%Y') as year,count(is_record) as is_record "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_record=1 group by year order by year");
			sqlList.add("select date_format(r_date,'%Y') as year,count(is_buy) as is_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_buy=1 group by year order by year");
			sqlList.add("select date_format(r_date,'%Y') as year,count(is_try) as is_try "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and is_try=1 group by year order by year");
			sqlList.add("select date_format(r_date,'%Y') as year,count(second_in) as second_in "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_in=1 group by year order by year");
			sqlList.add("select date_format(r_date,'%Y') as year,count(second_buy) as second_buy "
					+ "from shopperformance where s_name=1001 and date_format(r_date,'%Y')='1002' and second_buy=1 group by year order by year");
			for (int i = 0; i < sqlList.size(); i++){
				conn = JDBCUtil.getConnection();
				String sql = sqlList.get(i);
				sql = sql.replaceAll("1001", s_name);
				sql = sql.replaceAll("1002", year);
				int[] calculateArray = {0};
				try{
					psmt = conn.prepareStatement(sql);
					rs = psmt.executeQuery();
					if (i == 0){
						while (rs.next()){
							int num = rs.getInt("all_reception");
							calculateArray[0] = num;
						}
						result.setAll_reception(calculateArray);
					}else if (i == 1){
						while (rs.next()){
							int num = rs.getInt("is_record");
							calculateArray[0] = num;
						}
						result.setIs_record(calculateArray);
					}else if (i == 2){
						while (rs.next()){
							int num = rs.getInt("is_buy");
							calculateArray[0] = num;
						}
						result.setIs_buy(calculateArray);
					}else if (i == 3){
						while (rs.next()){
							int num = rs.getInt("is_try");
							calculateArray[0] = num;
						}
						result.setIs_try(calculateArray);
					}else if (i == 4){
						while (rs.next()){
							int num = rs.getInt("second_in");
							calculateArray[0] = num;
						}
						result.setSecond_in(calculateArray);
					}else if (i == 5){
						while (rs.next()){
							int num = rs.getInt("second_buy");
							calculateArray[0] = num;
						}
						result.setSecond_buy(calculateArray);
					}
				}catch(SQLException e){
					e.printStackTrace();
				}finally{
					JDBCUtil.closeConnection(conn, stmt, psmt, rs);
				}
			}
			return result;
		}
		return null;
	}

}
