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
                    <div class="item-lt">4s店：</div>
                    <div class="item-rt">
                        <select id="shop_name">
                        	<option value="不限">不限</option>
                            <option value="海淀">海淀</option>
                        </select>
                    </div>
                </div>
                <div class="kv-item">
                    <div class="item-lt">店员姓名</div>
                    <div class="item-rt">
                        <div class="employee_name">
                            <input type="text" id="employee_name" />
                        </div>
                    </div>
                </div>
                <div class="kv-item">
                    <div class="item-lt">起始日期：</div>
                    <div class="item-rt">
                       <div class="date">
                            <input type="text" id="start">
                            <i class="iconfont">&#xe784;</i>
                       </div>
                    </div>
                </div>
                <div class="kv-item">
                    <div class="item-lt">结束日期：</div>
                    <div class="item-rt">
                       <div class="date">
                            <input type="text" id="end">
                            <i class="iconfont">&#xe784;</i>
                       </div>
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
    	$("#start").datepicker({
        	"language":"zh-CN",
        	"format": 'yyyy-mm-dd'
    	}).on('changeDate', function(ev){
       		$('#end').datepicker('setStartDate', ev.date);
    	});
    	$("#end").datepicker({
        	"language":"zh-CN",
        	"format": 'yyyy-mm-dd'
    	}).on('changeDate', function(ev){
       		$('#start').datepicker('setEndDate', ev.date);
    	});
    	$(".date .iconfont").click(function(){
        	$(this).prev().trigger("focus");
    	});
    	$("#find").live('click', function(){
    		$("#main").hide();
    		$("#table-zone").show();
    		var s_name = document.getElementById("shop_name").value;
    		var e_name = document.getElementById("employee_name").value;
    		var start_time = document.getElementById("start").value;
    		var end_time = document.getElementById("end").value;
    		if (start_time == "" || end_time == ""){
    			alert("请输入查询时间");
    		}else{
    			var post_json = {
    					"s_name":s_name,
    					"e_name":e_name,
    					"start_time":start_time,
    					"end_time":end_time	
    			};
    			$.ajax({
    				url:"EmployeeServlet?methods=EmployeePerformanceAnalyze",
    				type:"post",
    				dataType:"json",
    				data:{info:JSON.stringify(post_json)},
    				success:function(data){
    					$("#table-header").empty();
    					$("#table-body").empty();
    					var thead_html = "<tr><td>姓名</td><td>销售量</td><td>销售额</td></tr>";
    					var tbody_html = ""; 
    					$.each(data, function(index, result){
    						tbody_html += "<tr><td>" + result.e_name +"</td><td>" + result.sales_volume + "</td><td>" + result.sale +"</td></tr>"
        				});
    					$("#table-header").html(thead_html);
    					$("#table-body").html(tbody_html);
    				}
    			});
    		}
    	});
    	$("#chart-find").live('click', function(){
    		$("#table-zone").hide();
    		$("#main").show;
    		var myChart = echarts.init(document.getElementById('main'));
    		var s_name = document.getElementById("shop_name").value;
    		var e_name = document.getElementById("employee_name").value;
    		var start_time = document.getElementById("start").value;
    		var end_time = document.getElementById("end").value;
    		if (start_time == "" || end_time == ""){
    			alert("请输入查询时间");
    		}else{
    			var post_json = {
    					"s_name":s_name,
    					"e_name":e_name,
    					"start_time":start_time,
    					"end_time":end_time	
    			};
    			$.ajax({
    				url:"EmployeeServlet?methods=EmployeePerformanceAnalyze",
    				type:"post",
    				dataType:"json",
    				data:{info:JSON.stringify(post_json)},
    				success:function(data){ 
    					var nameArray = new Array();
    					var salesVolumeArray = new Array();
    					var saleArray = new Array();
    					$.each(data, function(index, result){
    						nameArray.push(result.e_name);
    						salesVolumeArray.push(result.sales_volume);
    						saleArray.push(result.sale);
        				});
    					var colors = ['#5793f3', '#d14a61', '#675bba'];
    					var option = {
    							title: {
    				                text: "雇员业绩统计"
    				            },
    				            tooltip: {},
    				            legend: {
    				                data:["销售量", "销售额"]
    				            },
    				            toolbox: {
    				            },
    				            xAxis: [
    				            	 {
    				                     type: 'category',
    				                     axisTick: {
    				                         alignWithLabel: true
    				                     },
    				                     data: nameArray
    				            	 }
    				            ],
    				            yAxis:[
    				            	 {
    				                     type: 'value',
    				                     name: '销售量',
    				                     position: 'right',
    				                     axisLine: {
    				                         lineStyle: {
    				                             color: colors[0]
    				                         }
    				                     },
    				                     axisLabel: {
    				                         formatter: '{value} 辆'
    				                     }
    				                 },
    				                 {
    				                     type: 'value',
    				                     name: '销售额',
    				                     position: 'left',
    				                     axisLine: {
    				                         lineStyle: {
    				                             color: colors[1]
    				                         }
    				                     },
    				                     axisLabel: {
    				                         formatter: '{value} 元'
    				                     }
    				                 }
    				            ],
    				            series: [
											{
												name: '销售额',
												type: 'bar',
												yAxisIndex: 1,
												data: saleArray
											},
											{
												name: '销售量',
												type: 'bar',
												yAxisIndex: 0,
												data: salesVolumeArray
												},
    				            ]
    				        };
    				myChart.setOption(option);
    				}
    			});
    		}
    	});
	</script>
</body>

</html>

