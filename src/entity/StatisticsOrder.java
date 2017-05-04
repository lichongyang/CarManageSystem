package entity;

public class StatisticsOrder {
	private int statistics_price;
	private int statistics_num;
	private String car_class;
	private String month;
	private String year;
	private String season;
	public int getStatistics_price() {
		return statistics_price;
	}
	public void setStatistics_price(int statistics_price) {
		this.statistics_price = statistics_price;
	}
	public int getStatistics_num() {
		return statistics_num;
	}
	public void setStatistics_num(int statistics_num) {
		this.statistics_num = statistics_num;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getSeason() {
		return season;
	}
	public void setSeason(String season) {
		this.season = season;
	}
	public String getCar_class() {
		return car_class;
	}
	public void setCar_class(String car_class) {
		this.car_class = car_class;
	}

}
