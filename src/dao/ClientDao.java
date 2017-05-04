package dao;

import entity.CarFashionAnalyzeCondition;
import util.JDBCUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.CarFashionAnalyze;

public class ClientDao {
	public Connection conn = null;
	public Statement stmt = null;
	public PreparedStatement psmt = null;
	public ResultSet rs = null;

	public List<CarFashionAnalyze> findCarFashion(CarFashionAnalyzeCondition analyzeCondition){
		List<CarFashionAnalyze> result = new ArrayList<CarFashionAnalyze>();
		CarFashionAnalyze carFashionAnalyze = null;
		conn = JDBCUtil.getConnection();
		String s_name = "";
		if (analyzeCondition.getS_name().equals("����")){
			s_name = "s_name";
		}else{
			s_name = "'" + analyzeCondition.getS_name() + "'";
		}
		if (analyzeCondition.getCar_condition().equals("car_type") && analyzeCondition.getAnalyze_condition().equals("family")){
			String sql = "select elt(interval(fashionanalyze.c_family,1,2,3,4),'1','2','3','���ڵ���4') as family_level,"
					+ "sum(o_num) as count,car_type as type from fashionanalyze where o_date between '1001' and '1002' "
					+ "and s_name=1003 group by elt(interval(fashionanalyze.c_family,1,2,3,4),'1','2','3','���ڵ���4'),car_type;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String family_level = rs.getString("family_level");
					System.out.println(family_level);
					int count = rs.getInt("count");
					String car_type = rs.getString("type");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setFamily_level(family_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_type(car_type);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getCar_condition().equals("car_type") && analyzeCondition.getAnalyze_condition().equals("career")){
			String sql = "select sum(o_num) as count, car_type as type, c_profession as career from fashionanalyze "
					+ "where o_date between '1001' and  '1002' and s_name=1003 group by car_type,c_profession;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String career = rs.getString("career");
					int count = rs.getInt("count");
					String car_type = rs.getString("type");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setCareer(career);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_type(car_type);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getCar_condition().equals("car_type") && analyzeCondition.getAnalyze_condition().equals("age")){
			String sql = " select elt(interval(fashionanalyze.c_age,0,20,30,40,50,60),'С��20','20��30','30��40','40��50', '50��60',"
					+ "'���ڵ���60') as age,sum(o_num) as count,car_type as type from fashionanalyze "
					+ "where o_date between '1001' and '1002' and s_name=1003 "
					+ "group by elt(interval(fashionanalyze.c_age,0,20,30,40,50,60),'С��20','20��30','30��40','40��50','50��60','����60'),car_type;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String age_level = rs.getString("age");
					int count = rs.getInt("count");
					String car_type = rs.getString("type");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setAge_level(age_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_type(car_type);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getCar_condition().equals("car_class") && analyzeCondition.getAnalyze_condition().equals("family")){
			String sql = "select elt(interval(fashionanalyze.c_family,1,2,3,4),'1','2','3','���ڵ���4') as family_level,"
					+ "sum(o_num) as count,car_class as class from fashionanalyze where o_date between '1001' and '1002' "
					+ "and s_name=1003 group by elt(interval(fashionanalyze.c_family,1,2,3,4),'1','2','3','���ڵ���4'),car_class;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String family_level = rs.getString("family_level");
					int count = rs.getInt("count");
					String car_class = rs.getString("class");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setFamily_level(family_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_class(car_class);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getCar_condition().equals("car_class") && analyzeCondition.getAnalyze_condition().equals("career")){
			String sql = "select sum(o_num) as count, car_class as class, c_profession as career from fashionanalyze "
					+ "where o_date between '1001' and  '1002' and s_name=1003 group by car_class,c_profession;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String career = rs.getString("career");
					int count = rs.getInt("count");
					String car_class = rs.getString("class");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setCareer(career);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_class(car_class);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getCar_condition().equals("car_class") && analyzeCondition.getAnalyze_condition().equals("age")){
			String sql = " select elt(interval(fashionanalyze.c_age,0,20,30,40,50,60),'С��20','20��30','30��40','40��50', '50��60',"
					+ "'���ڵ���60') as age,sum(o_num) as count,car_class as class from fashionanalyze "
					+ "where o_date between '1001' and '1002' and s_name=1003 "
					+ "group by elt(interval(fashionanalyze.c_age,0,20,30,40,50,60),'С��20','20��30','30��40','40��50','50��60','����60'),car_class;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String age_level = rs.getString("age");
					int count = rs.getInt("count");
					String car_class = rs.getString("class");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setAge_level(age_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setCar_class(car_class);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}
		return result;
		
	}

	public List<CarFashionAnalyze> findCarPrice(CarFashionAnalyzeCondition analyzeCondition) {
		List<CarFashionAnalyze> result = new ArrayList<CarFashionAnalyze>();
		CarFashionAnalyze carFashionAnalyze = null;
		conn = JDBCUtil.getConnection();
		String s_name = "";
		if (analyzeCondition.getS_name().equals("����")){
			s_name = "s_name";
		}else{
			s_name = "'" + analyzeCondition.getS_name() + "'";
		}
		if (analyzeCondition.getAnalyze_condition().equals("family")){
			String sql = "select elt(interval(priceanalyze.c_family,1,2,3,4),'1','2','3','���ڵ���4') as family_level, "
					+ "elt(interval(priceanalyze.car_price,0,100000,200000,300000,400000,500000,600000),'С��10��','10����20��','20����30��'"
					+ ",'30����40��','40����50��','50����60��','����60��') as price_level,sum(o_num) as count "
					+ "from priceanalyze where o_date between '1001' and '1002' and s_name=1003 "
					+ "group by price_level,family_level;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String family_level = rs.getString("family_level");
					int count = rs.getInt("count");
					String price_level = rs.getString("price_level");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setFamily_level(family_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setPrice_level(price_level);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getAnalyze_condition().equals("career")){
			String sql = "select elt(interval(priceanalyze.car_price,0,100000,200000,300000,400000,500000,600000),'С��10��','10����20��',"
					+ "'20����30��','30����40��','40����50��','50����60��','����60��') as price_level,sum(o_num) as count,c_profession as career "
					+ "from priceanalyze where o_date between '1001' and '1002' and s_name=1003 group by price_level,career;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String career = rs.getString("career");
					int count = rs.getInt("count");
					String price_level = rs.getString("price_level");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setCareer(career);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setPrice_level(price_level);
					result.add(carFashionAnalyze);
				}
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				JDBCUtil.closeConnection(conn, stmt, psmt, rs);
			}
		}else if (analyzeCondition.getAnalyze_condition().equals("age")){
			String sql = " select elt(interval(priceanalyze.c_age,0,20,30,40,50,60),'С��20','20��30',"
					+ "'30��40','40��50','50��60','���ڵ���60') as age, "
					+ "elt(interval(priceanalyze.car_price,0,100000,200000,300000,400000,500000,600000),'С��10��',"
					+ "'10����20��','20����30��','30����40��','40����50��','50����60��','����60��') as price_level,"
					+ "sum(o_num) as count from priceanalyze "
					+ "where o_date between '1001' and '1002' and s_name=1003 group by price_level,age;";
			sql = sql.replaceAll("1001", analyzeCondition.getStart_time());
			sql = sql.replaceAll("1002", analyzeCondition.getEnd_time());
			sql = sql.replaceAll("1003", s_name);
			System.out.println(sql);
			try{
				psmt = conn.prepareStatement(sql);
				rs = psmt.executeQuery();
				while(rs.next()){
					String age_level = rs.getString("age");
					int count = rs.getInt("count");
					String price_level = rs.getString("price_level");
					carFashionAnalyze = new CarFashionAnalyze();
					carFashionAnalyze.setAge_level(age_level);
					carFashionAnalyze.setStatistics_num(count);
					carFashionAnalyze.setPrice_level(price_level);
					result.add(carFashionAnalyze);
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
