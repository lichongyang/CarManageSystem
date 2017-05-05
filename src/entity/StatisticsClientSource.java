package entity;

public class StatisticsClientSource {
	private String client_source;
	private int statistics_num;
	private String month;
	private String year;
	private String season;
	public String getClient_source() {
		return client_source;
	}
	public void setClient_source(String client_source) {
		this.client_source = client_source;
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
	public int getStatistics_num() {
		return statistics_num;
	}
	public void setStatistics_num(int statistics_num) {
		this.statistics_num = statistics_num;
	}

}
