<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=request.getContextPath() %>/css/bootstrap.css" rel="stylesheet" type="text/css" /> 
<link href="<%=request.getContextPath() %>/css/bootstrap-datepicker.css" rel="stylesheet" type="text/css" /> 
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/css/work_situation_query.css" rel="stylesheet" type="text/css" /> 
<title>Insert title here</title>
</head>
<body>
<div class="crumbs">
        <i class="crumbs-arrow"></i>
        <a href="javascript:;" class="crumbs-label">基本订单信息查询</a>
    </div>
    <div id="inner-bd">
        <div class="kv-group-outer">
            <div class="kv-group clearfix">
                  	<div class="kv-item">
                      	<div class="item-lt">店名：</div>
                      		<div class="item-rt">
                          		<select id="shop_name">
                          	  		<option value="不限">不限</option>
                              		<option value="海淀">海淀</option>
                          		</select>
                      		</div>
                  	</div>
                   	<div class="kv-item">
                   		<div class="item-lt">年份：</div>
                      		<div class="item-rt">
                          		<div class="date">
                            		<input type="text" id="select_date" />
                          		</div>
                      		</div>
                  		</div>
                  	<div class="kv-item">
                    	<div class="item-lt">周期：</div>
                      		<div class="item-rt">
                    			<select id="period">
                            		<option value="month">按月</option>
                              		<option value="season">按季度</option>
                              		<option value="year">按年</option>
                          		</select>
                      		</div>
                  </div>
            </div>
        </div>
    </div>
    <div class="button-group">
        <div class="button current">
            <i class="iconfont">&#xe625;</i>
            <span class="button-label" id="find">查询</span>
        </div>
         <div class="button current">
                  <i class="iconfont">&#xe61b;</i>
                  <span class="button-label" id="chart-find">查看图表</span>
         </div>
    </div>
    <div class="table-zone" id="table-zone">
         <table class="no-data">
            <thead id="table-header">
            </thead>
            <tbody  id="table-body">
            </tbody> 
         </table>
    </div>
    <div id="main" style="width: 1000px;height:400px;"></div>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/global.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.select.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/core.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.zh-CN.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/echarts.common.min.js"></script>
    <script type="text/javascript">

    	$('select').select();
    	$("#find").live('click', function(){
    		$("#main").hide();
    		$("#table-zone").show();
    		var s_name = document.getElementById("shop_name").value;
    		var year = document.getElementById("select_date").value;
    		var period = document.getElementById("period").value;
    		var post_json = {
					"s_name":s_name,
					"year":year,
					"period":period
			};
    		$.ajax({
    			url:"EmployeeServlet?methods=ShopPerformanceAnalyze",
    			type:"post",
    			dataType:"json",
    			data:{info:JSON.stringify(post_json)},
    			success:function(data){
    				$("#table-header").empty();
    				$("#table-body").empty();
    				var header_html = "";
    				var body_html = "";
    				if (period == "season"){
    					header_html = "<tr><td>类别</td><td>1季度</td><td>2季度</td><td>3季度</td><td>4季度</td></tr>"
        					body_html += "<tr><td>来店客流量</td><td>" + data.all_reception[0] + "</td><td>" + data.all_reception[1] + "</td><td>"+ data.all_reception[2] + "</td><td>"
        								+ data.all_reception[3] + "</td></tr>";
        					body_html += "<tr><td>来店留档人数</td><td>" + data.is_record[0] + "</td><td>" + data.is_record[1] + "</td><td>"+ data.is_record[2] + "</td><td>"
    									+ data.is_record[3] + "</td></tr>";
        					body_html += "<tr><td>来店成交人数</td><td>" + data.is_buy[0] + "</td><td>" + data.is_buy[1] + "</td><td>"+ data.is_buy[2] + "</td><td>"
    									+ data.is_buy[3] + "</td></tr>";
        					body_html += "<tr><td>来店试驾人数</td><td>" + data.is_try[0] + "</td><td>" + data.is_try[1] + "</td><td>"+ data.is_try[2] + "</td><td>"
    									+ data.is_try[3] + "</td></tr>";
        					body_html += "<tr><td>二次进店人数</td><td>" + data.second_in[0] + "</td><td>" + data.second_in[1] + "</td><td>"+ data.second_in[2] + "</td><td>"
    									+ data.second_in[3] + "</td></tr>";
        					body_html += "<tr><td>二次进店成交数</td><td>" + data.second_buy[0] + "</td><td>" + data.second_buy[1] + "</td><td>"+ data.second_buy[2] + "</td><td>"
    									+ data.second_buy[3] + "</td></tr>";
    				}else if (period == "month"){
    					header_html = "<td>类别</td><td>1月</td><td>2月</td><td>3月</td><td>4月</td><td>5月</td><td>6月</td><td>7月</td><td>8月</td><td>9月</td><td>10月</td><td>11月</td><td>12月</td>"
    					body_html += "<tr><td>来店客流量</td><td>" + data.all_reception[0] + "</td><td>" + data.all_reception[1] + "</td><td>"+ data.all_reception[2] + "</td><td>"
    								+ data.all_reception[3] + "</td><td>"+ data.all_reception[4] + "</td><td>"+ data.all_reception[5] + "</td><td>"+ data.all_reception[6] 
    								+ "</td><td>"+ data.all_reception[7] + "</td><td>" + data.all_reception[8] + "</td><td>" + data.all_reception[9] + "</td><td>"
    								+ data.all_reception[10] + "</td><td>"+ data.all_reception[11] + "</td></tr>";
    					body_html += "<tr><td>来店留档人数</td><td>" + data.is_record[0] + "</td><td>" + data.is_record[1] + "</td><td>"+ data.is_record[2] + "</td><td>"
									+ data.is_record[3] + "</td><td>"+ data.is_record[4] + "</td><td>"+ data.is_record[5] + "</td><td>"+ data.is_record[6] 
									+ "</td><td>"+ data.is_record[7] + "</td><td>" + data.is_record[8] + "</td><td>" + data.is_record[9] + "</td><td>"
									+ data.is_record[10] + "</td><td>"+ data.is_record[11] + "</td></tr>";
    					body_html += "<tr><td>来店成交人数</td><td>" + data.is_buy[0] + "</td><td>" + data.is_buy[1] + "</td><td>"+ data.is_buy[2] + "</td><td>"
									+ data.is_buy[3] + "</td><td>"+ data.is_buy[4] + "</td><td>"+ data.is_buy[5] + "</td><td>"+ data.is_buy[6] 
									+ "</td><td>"+ data.is_buy[7] + "</td><td>" + data.is_buy[8] + "</td><td>" + data.is_buy[9] + "</td><td>"
									+ data.is_buy[10] + "</td><td>"+ data.is_buy[11] + "</td></tr>";
    					body_html += "<tr><td>来店试驾人数</td><td>" + data.is_try[0] + "</td><td>" + data.is_try[1] + "</td><td>"+ data.is_try[2] + "</td><td>"
									+ data.is_try[3] + "</td><td>"+ data.is_try[4] + "</td><td>"+ data.is_try[5] + "</td><td>"+ data.is_try[6] 
									+ "</td><td>"+ data.is_try[7] + "</td><td>" + data.is_try[8] + "</td><td>" + data.is_try[9] + "</td><td>"
									+ data.is_try[10] + "</td><td>"+ data.is_try[11] + "</td></tr>";
    					body_html += "<tr><td>二次进店人数</td><td>" + data.second_in[0] + "</td><td>" + data.second_in[1] + "</td><td>"+ data.second_in[2] + "</td><td>"
									+ data.second_in[3] + "</td><td>"+ data.second_in[4] + "</td><td>"+ data.second_in[5] + "</td><td>"+ data.second_in[6] 
									+ "</td><td>"+ data.second_in[7] + "</td><td>" + data.second_in[8] + "</td><td>" + data.second_in[9] + "</td><td>"
									+ data.second_in[10] + "</td><td>"+ data.second_in[11] + "</td></tr>";
    					body_html += "<tr><td>二次进店成交数</td><td>" + data.second_buy[0] + "</td><td>" + data.second_buy[1] + "</td><td>"+ data.second_buy[2] + "</td><td>"
									+ data.second_buy[3] + "</td><td>"+ data.second_buy[4] + "</td><td>"+ data.second_buy[5] + "</td><td>"+ data.second_buy[6] 
									+ "</td><td>"+ data.second_buy[7] + "</td><td>" + data.second_buy[8] + "</td><td>" + data.second_buy[9] + "</td><td>"
									+ data.second_buy[10] + "</td><td>"+ data.second_buy[11] + "</td></tr>";
    				}else if (period == "year"){
    					header_html = "<tr><td>类别</td><td>" + year + "年</td></tr>";
        				body_html += "<tr><td>来店客流量</td><td>" + data.all_reception[0] + "</td></tr>";
        				body_html += "<tr><td>来店留档人数</td><td>" + data.is_record[0] + "</td></tr>";
        				body_html += "<tr><td>来店成交人数</td><td>" + data.is_buy[0] + "</td></tr>"; 
        				body_html += "<tr><td>来店试驾人数</td><td>" + data.is_try[0] + "</td></tr>";
        				body_html += "<tr><td>二次进店人数</td><td>" + data.second_in[0] + "</td></tr>";
        				body_html += "<tr><td>二次进店成交数</td><td>" + data.second_buy[0] + "</td></tr>";
    				}
    				$("#table-header").html(header_html);
    				$("#table-body").html(body_html);
    			}
    		});
    	});
    	$("#chart-find").live('click', function(){
    		$("#table-zone").hide();
    		$("#main").show();
    		var myChart = echarts.init(document.getElementById('main'));
    		var s_name = document.getElementById("shop_name").value;
    		var year = document.getElementById("select_date").value;
    		var period = document.getElementById("period").value;
    		var post_json = {
					"s_name":s_name,
					"year":year,
					"period":period
			};
        	$.ajax({
        		url:"EmployeeServlet?methods=ShopPerformanceAnalyze",
        		type:"post",
        		dataType:"json",
        		data:{info:JSON.stringify(post_json)},
        		success:function(result){
        			if (period == "season"){
        				var option = {
        						title: {
        				        	text: '季度数据统计'
        				        },
        				        tooltip: {},
        				        legend: {
        				                data:['来店客流量', '来店留档人数','来店成交人数','来店试驾人数','二次进店人数','二次进店成交数']
        				            },
        				       	toolbox: {
        				        },
        				        xAxis: {
        				                data: ["1季度","2季度","3季度","4季度"]
        				        },
        				        yAxis: {
        				        },
        				        series: [
        				                     {
        				                    	 name: '来店客流量',
        				                         type: 'bar',
        				                         data: result.all_reception
        				                     },
        				                     {
        				                    	 name: '来店留档人数',
        				                         type: 'bar',
        				                         data: result.is_record
        				                     },
        				                     {
        				                    	 name: '来店成交人数',
        				                         type: 'bar',
        				                         data: result.is_buy
        				                     },
        				                     {
        				                    	 name: '来店试驾人数',
        				                         type: 'bar',
        				                         data: result.is_try
        				                     },
        				                     {
        				                    	 name: '二次进店人数',
        				                         type: 'bar',
        				                         data: result.second_in
        				                     },
        				                     {
        				                    	 name: '二次进店成交数',
        				                         type: 'bar',
        				                         data: result.second_buy
        				                     }
        				         ]
        				        };
        				myChart.setOption(option);
        			}else if (period == "month"){
        				var option = {
        						title: {
        				        	text: '各月数据统计'
        				        },
        				        tooltip: {},
        				        legend: {
        				                data:['来店客流量', '来店留档人数','来店成交人数','来店试驾人数','二次进店人数','二次进店成交数']
        				            },
        				       	toolbox: {
        				        },
        				        xAxis: {
        				                data: ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        				        },
        				        yAxis: {
        				        },
        				        series: [
        				                     {
        				                    	 name: '来店客流量',
        				                         type: 'bar',
        				                         data: result.all_reception
        				                     },
        				                     {
        				                    	 name: '来店留档人数',
        				                         type: 'bar',
        				                         data: result.is_record
        				                     },
        				                     {
        				                    	 name: '来店成交人数',
        				                         type: 'bar',
        				                         data: result.is_buy
        				                     },
        				                     {
        				                    	 name: '来店试驾人数',
        				                         type: 'bar',
        				                         data: result.is_try
        				                     },
        				                     {
        				                    	 name: '二次进店人数',
        				                         type: 'bar',
        				                         data: result.second_in
        				                     },
        				                     {
        				                    	 name: '二次进店成交数',
        				                         type: 'bar',
        				                         data: result.second_buy
        				                     }
        				         ]
        				        };
        				myChart.setOption(option);
        				}else if (period == "year"){
        					var yearString = year + "年";
        					var option = {
            						title: {
            				        	text: '各月数据统计'
            				        },
            				        tooltip: {},
            				        legend: {
            				                data:['来店客流量', '来店留档人数','来店成交人数','来店试驾人数','二次进店人数','二次进店成交数']
            				            },
            				       	toolbox: {
            				        },
            				        xAxis: {
            				                data: [yearString]
            				        },
            				        yAxis: {
            				        },
            				        series: [
            				                     {
            				                    	 name: '来店客流量',
            				                         type: 'bar',
            				                         data: result.all_reception
            				                     },
            				                     {
            				                    	 name: '来店留档人数',
            				                         type: 'bar',
            				                         data: result.is_record
            				                     },
            				                     {
            				                    	 name: '来店成交人数',
            				                         type: 'bar',
            				                         data: result.is_buy
            				                     },
            				                     {
            				                    	 name: '来店试驾人数',
            				                         type: 'bar',
            				                         data: result.is_try
            				                     },
            				                     {
            				                    	 name: '二次进店人数',
            				                         type: 'bar',
            				                         data: result.second_in
            				                     },
            				                     {
            				                    	 name: '二次进店成交数',
            				                         type: 'bar',
            				                         data: result.second_buy
            				                     }
            				         ]
            				};
            				myChart.setOption(option);
        			}
        		}
        	});
    	});
	</script>
</body>

</html>

