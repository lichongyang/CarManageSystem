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
                    <div class="item-lt">分析因素：</div>
                    <div class="item-rt">
                        <select id="analyze_condition">
                            <option value="family">家庭人口数</option>
                            <option value="career">职业</option>
                            <option value="age">年龄</option>
                        </select>
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
    		var analyze_condition = document.getElementById("analyze_condition").value;
    		var start_time = document.getElementById("start").value;
    		var end_time = document.getElementById("end").value;
    		if (analyze_condition == "" || start_time == "" || end_time == ""){
    			alert("请填入相应信息");
    		}else{
    			var post_json = {
    					"s_name":s_name,
    					"analyze_condition":analyze_condition,
    					"start_time":start_time,
    					"end_time":end_time	
    			};
    			$.ajax({
    				url:"ClientServlet?methods=CarPriceAnalyze",
    				type:"post",
    				dataType:"json",
    				data:{info:JSON.stringify(post_json)},
    				success:function(data){
    					$("#table-header").empty();
    					$("#table-body").empty();
    					var thead_html = "";
    					var tbody_html = "";
    					if (analyze_condition == "family"){
    						thead_html += "<tr><td>价格区间</td><td>1人</td><td>2人</td><td>3人</td><td>大于等于4人</td>";
    						var mid_json = new Array();
    						$.each(data, function(index, result){
        						mid_json[result.price_level] = {
        								"1":0,
        								"2":0,
        								"3":0,
        								"大于等于4":0
        						};
            				});
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.price_level][result.family_level] + result.statistics_num;
        						mid_json[result.price_level][result.family_level] = calculate_num;
        					});
    						for (var key in mid_json){
        						if (key == "remove"){
        							continue;
        						}
        						tbody_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["1"] + "</td><td>" + mid_json[key]["2"] + "</td><td>"+ mid_json[key]["3"] + "</td><td>"+ mid_json[key]["大于等于4"] + "</td></tr>";
    						}
    					}else if (analyze_condition == "career"){
    						thead_html += "<tr><td>价格区间</td>"
    						var mid_json = new Array();
    						var type_mid_array = new Array();  //用于车辆类别数组去重，即先存至字典再取出
    						var type_array = new Array();      //统计查询到的车辆类别数组
    						$.each(data, function(index, result){
        						mid_json[result.career] = new Array();
        						type_mid_array[result.price_level] = 0;
            				});
    						for (var key in type_mid_array){
    							if (key == "remove")
    								continue;
    							type_array.push(key);
    						}
    						for (var key in mid_json){
    							if (key == "remove")
    								continue;
    							$.each(data, function(index, result){
            						mid_json[key][result.price_level] = 0;
                				});
    						}
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.career][result.price_level] + result.statistics_num;
        						mid_json[result.career][result.price_level] = calculate_num;
        					});
    						for (var key in mid_json){
    							if (key == "remove")
    								continue;
    							thead_html += "<td>" + key + "</td>"
    						}
    						thead_html += "</tr>";
    						for (var i = 0; i < type_array.length; i++){
    							tbody_html += "<tr><td>" + type_array[i] + "</td>";
    							for (var key in mid_json){
    								if (key == "remove")
    									continue;
    								tbody_html += "<td>"+mid_json[key][type_array[i]] + "</td>";
    							}
    							tbody_html += "</tr>";
    						}
    					}else if (analyze_condition == "age"){
    						thead_html += "<tr><td>类别</td><td>小于20</td><td>20至30</td><td>30至40</td><td>40至50</td><td>50至60</td><td>大于60</td></tr>";
    						var mid_json = new Array();
    						$.each(data, function(index, result){
        						mid_json[result.price_level] = {
        								"小于20":0,
        								"20至30":0,
        								"30至40":0,
        								"40至50":0,
        								"50至60":0,
        								"大于60":0
        						};
            				});
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.price_level][result.age_level] + result.statistics_num;
        						mid_json[result.price_level][result.age_level] = calculate_num;
        					});
    						for (var key in mid_json){
        						if (key == "remove"){
        							continue;
        						}
        						tbody_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["小于20"] + "</td><td>" + mid_json[key]["20至30"] + "</td><td>"+ mid_json[key]["30至40"] + "</td><td>"+ mid_json[key]["40至50"] + "</td><td>"+ mid_json[key]["50至60"] + "</td><td>"+ mid_json[key]["大于60"]+ "</td></tr>";
    						}
    					}
    					$("#table-header").html(thead_html);
    					$("#table-body").html(tbody_html);
					}
    			});
    		}
    	});
    	$("#chart-find").live('click', function(){
    		$("#main").show();
    		$("#table-zone").hide();
    		var myChart = echarts.init(document.getElementById('main'));
    		var s_name = document.getElementById("shop_name").value;
    		var analyze_condition = document.getElementById("analyze_condition").value;
    		var start_time = document.getElementById("start").value;
    		var end_time = document.getElementById("end").value;
    		if (analyze_condition == "" || start_time == "" || end_time == ""){
    			alert("请填入相应信息");
    		}else{
    			var post_json = {
    					"s_name":s_name,
    					"analyze_condition":analyze_condition,
    					"start_time":start_time,
    					"end_time":end_time	
    			};
    			$.ajax({
    				url:"ClientServlet?methods=CarPriceAnalyze",
    				type:"post",
    				dataType:"json",
    				data:{info:JSON.stringify(post_json)},
    				success:function(data){
    					if (analyze_condition == "family"){
    						var mid_json = new Array();
    						$.each(data, function(index, result){
        						mid_json[result.price_level] = {
        								"1":0,
        								"2":0,
        								"3":0,
        								"大于等于4":0
        						};
            				});
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.price_level][result.family_level] + result.statistics_num;
        						mid_json[result.price_level][result.family_level] = calculate_num;
        					});
    						var classArray = [];
            				var seriesArray = [];
            				for (var key in mid_json){
            					if (key == "remove")
            						continue;
            					var mid = new Array();
            					classArray.push(key);
            					mid = {
            							type:'line',
            							name: key,
            							data:[mid_json[key]["1"], mid_json[key]["2"],mid_json[key]["3"],mid_json[key]["大于等于4"]]
            					};
            					seriesArray.push(mid);
            				}
            				var option = {
        				            title: {
        				                text: '家庭因素影响下汽车销量分布情况'
        				            },
        				            tooltip: {},
        				            legend: {
        				                data:classArray
        				            },
        				            toolbox: {
        				                show: true,
        				                feature: {
        				                    dataZoom: {
        				                        yAxisIndex: 'none'
        				                    },
        				                    dataView: {readOnly: false},
        				                    magicType: {type: ['line', 'bar']},
        				                    restore: {},
        				                    saveAsImage: {}
        				                }
        				            },
        				            xAxis: {
        				            	type: 'category',
        				                boundaryGap: false,
        				                data: ["1人","2人","3人","大于等于4人"]
        				            },
        				            yAxis: {
        				                type: 'value',
        				            },
        				            series: seriesArray
        				        };
        					myChart.setOption(option);
    					}else if (analyze_condition == "career"){
    						var mid_json = new Array();
    						var type_mid_array = new Array();  //用于车辆类别数组去重，即先存至字典再取出
    						var type_array = new Array();      //统计查询到的车辆类别数组
    						var xArray = [];               //横轴，各职业
            				var seriesArray = [];
    						$.each(data, function(index, result){
        						mid_json[result.career] = new Array();
        						type_mid_array[result.price_level] = 0;
            				});
    						for (var key in type_mid_array){
    							if (key == "remove")
    								continue;
    							type_array.push(key);
    						}
    						for (var key in mid_json){
    							if (key == "remove")
    								continue;
    							$.each(data, function(index, result){
            						mid_json[key][result.price_level] = 0;
                				});
    							xArray.push(key);
    						}
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.career][result.price_level] + result.statistics_num;
        						mid_json[result.career][result.price_level] = calculate_num;
        					});
    						for (var i = 0; i < type_array.length; i++){
    							var mid_array = new Array();  //用于统计每个系列下每个职业的购买分数
    							var mid = new Array();   //用于生成option中的data部分
    							for (var j = 0; j < xArray.length; j++){
    								mid_array.push(mid_json[xArray[j]][type_array[i]]);
    							}
    							mid = {
            							type:'line',
            							name: type_array[i],
            							data: mid_array
            					};
    							seriesArray.push(mid);
    						} 
    						var option = {
        				            title: {
        				                text: '职业因素影响下汽车销量分布情况'
        				            },
        				            tooltip: {},
        				            legend: {
        				                data:type_array
        				            },
        				            toolbox: {
        				                show: true,
        				                feature: {
        				                    dataZoom: {
        				                        yAxisIndex: 'none'
        				                    },
        				                    dataView: {readOnly: false},
        				                    magicType: {type: ['line', 'bar']},
        				                    restore: {},
        				                    saveAsImage: {}
        				                }
        				            },
        				            xAxis: {
        				            	type: 'category',
        				                boundaryGap: false,
        				                data: xArray
        				            },
        				            yAxis: {
        				                type: 'value',
        				            },
        				            series: seriesArray
        				        };
        					myChart.setOption(option);
    					}else if (analyze_condition == "age"){
    						var mid_json = new Array();
    						$.each(data, function(index, result){
        						mid_json[result.price_level] = {
        								"小于20":0,
        								"20至30":0,
        								"30至40":0,
        								"40至50":0,
        								"50至60":0,
        								"大于60":0
        						};
            				});
    						$.each(data, function(index, result){
        						var calculate_num = mid_json[result.price_level][result.age_level] + result.statistics_num;
        						mid_json[result.price_level][result.age_level] = calculate_num;
        					});
    						var classArray = [];
            				var seriesArray = [];
            				for (var key in mid_json){
            					if (key == "remove")
            						continue;
            					var mid = new Array();
            					classArray.push(key);
            					mid = {
            							type:'line',
            							name: key,
            							data:[mid_json[key]["小于20"], mid_json[key]["20至30"],mid_json[key]["30至40"],mid_json[key]["40至50"],mid_json[key]["50至60"],mid_json[key]["大于60"]]
            					};
            					seriesArray.push(mid);
            				}
            				var option = {
        				            title: {
        				                text: '年龄因素影响下汽车销量分布情况'
        				            },
        				            tooltip: {},
        				            legend: {
        				                data:classArray
        				            },
        				            toolbox: {
        				                show: true,
        				                feature: {
        				                    dataZoom: {
        				                        yAxisIndex: 'none'
        				                    },
        				                    dataView: {readOnly: false},
        				                    magicType: {type: ['line', 'bar']},
        				                    restore: {},
        				                    saveAsImage: {}
        				                }
        				            },
        				            xAxis: {
        				            	type: 'category',
        				                boundaryGap: false,
        				                data: ["小于20","20至30","30至40","40至50","50至60","大于60"]
        				            },
        				            yAxis: {
        				                type: 'value',
        				            },
        				            series: seriesArray
        				        };
        					myChart.setOption(option);
    					}
    				}
    			});
    		}
    	});
	</script>
</body>

</html>

