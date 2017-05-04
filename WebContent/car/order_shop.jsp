<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/css/order_shop.css" rel="stylesheet" type="text/css" />
<title>Insert title here</title>
</head>
<body>
	<input type="text" class="identify" id="identify" value="order-info" style="display:none"/>
	<div class="container">
        <div id="inner-hd">
            <div class="crumbs">
				<i class="crumbs-arrow"></i>
				<a href="javascript:;" class="crumbs-label">各店销售情况</a>
			</div>
		</div>
		<div id="inner-bd">
          <div class="tab-wraper">
            <ul class="tab">
              <li name="order-info" class="current"><a href="javascript:;">各店销售情况</a></li>
              <li name="order-chart"><a href="javascript:;">统计图表</a></li>
           	</ul>
           </div> 
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
                         	<div class="button" id="order_find">选择</div>
                      		</div>
                  </div>
              	</div>
          	</div>
          	<div class="order-info">
            	<table>
            	<thead id="table_header"></thead>
            	<tbody id="table_container"></tbody>
            	</table>
        	</div>   
         	<div class="order-chart">
         		<div id="main" style="width: 1000px;height:400px;"></div>
        	</div>
    </div>
     <div id="inner-ft">
            
        </div>

    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/global.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/core.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.select.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.grid.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/echarts.common.min.js"></script>
    <script type="text/javascript">
    $(".tab > li").click(function(){
        $(".tab > li").removeClass("current");
        $(this).addClass("current");
        $(".order-info,.order-chart").hide();
        $("." + $(".tab >li.current").attr("name")).show();
        $(".identify").val($(".tab >li.current").attr("name"));
        $(".grid").Grid("resize");
    });
    $('select').select();
    $("#order_find").live('click', function(){
    	var identify = document.getElementById("identify").value;
    	if (identify == "order-info"){
    		var s_name = document.getElementById("shop_name").value;
    		var year = document.getElementById("select_date").value;
    		var period = document.getElementById("period").value;
    		var post_json = {
    				"s_name":s_name,
    				"year":year,
    				"period":period
    		}
    		$.ajax({
    			url:"OrderServlet?methods=showOrderByPeriod",
    			type:"post",
    			dataType:"json",
    			data:{info:JSON.stringify(post_json)},
    			success:function(data){
    				$("#table_header").empty();
    				$("#table_container").empty();
    				var header_html = "";
    				var body_html = "";
    				if (period == "season"){
    					var mid_json = new Array();
    					$.each(data, function(index, result){
    						mid_json[result.car_class] = {
    								"1":0,
    								"2":0,
    								"3":0,
    								"4":0
    						}
    					});
    					$.each(data, function(index, result){
    						var calculate_num = mid_json[result.car_class][result.season] + result.statistics_num;
    						mid_json[result.car_class][result.season] = calculate_num;
    					});
    					header_html = "<td>车型</td><td>1</td><td>2</td><td>3</td><td>4</td>"
    					for (var key in mid_json){
    						if (key == "remove"){
    							continue;
    						}
    						body_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["1"] + "</td><td>" + mid_json[key]["2"] + "</td><td>"+ mid_json[key]["3"] + "</td><td>"+ mid_json[key]["4"] + "</td></tr>";
    					}
    				}else if (period == "month"){
    					var mid_json = new Array();
    					$.each(data, function(index, result){
    						mid_json[result.car_class] = {
    								"01":0,
    								"02":0,
    								"03":0,
    								"04":0,
    								"05":0,
    								"06":0,
    								"07":0,
    								"08":0,
    								"09":0,
    								"10":0,
    								"11":0,
    								"12":0
    						}
    					});
    					$.each(data, function(index, result){
    						var calculate_num = mid_json[result.car_class][result.month] + result.statistics_num;
    						mid_json[result.car_class][result.month] = calculate_num;
    					});
    					header_html = "<td>车型</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td>"
    					for (var key in mid_json){
    						if (key == "remove"){
    							continue;
    						}
    						body_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["01"] + "</td><td>" + mid_json[key]["02"] + "</td><td>"
    									+ mid_json[key]["03"] + "</td><td>"+ mid_json[key]["04"] + "</td><td>"+ mid_json[key]["05"] + "</td><td>"
    									+ mid_json[key]["06"] + "</td><td>" + mid_json[key]["07"] + "</td><td>"+ mid_json[key]["08"] + "</td><td>"
    									+ mid_json[key]["09"] + "</td><td>" + mid_json[key]["10"] + "</td><td>" + mid_json[key]["11"] + "</td><td>" + mid_json[key]["12"] + "</td></tr>";
    					}
    				}else if (period == "year"){
    					$.each(data, function(index, result){
    					header_html = "<td>车型</td><td>" + result.year +"</td>";
    					body_html += "<tr><td>" + result.car_class + "</td><td>" + result.statistics_num + "</td><tr>";
    					});
    				}
    				$("#table_header").html(header_html);
    				$("#table_container").html(body_html);
    			}
    		});
    	}else if (identify == "order-chart"){
    		var myChart = echarts.init(document.getElementById('main'));
        	var s_name = document.getElementById("shop_name").value;
        	var year = document.getElementById("select_date").value;
        	var period = document.getElementById("period").value;
        	var post_json = {
        			"s_name":s_name,
        			"year":year,
        			"period":period
        	}
        	$.ajax({
        		url:"OrderServlet?methods=showOrderByPeriod",
        		type:"post",
        		dataType:"json",
        		data:{info:JSON.stringify(post_json)},
        		success:function(data){
        			if (period == "season"){
        				var mid_json = new Array();
        				$.each(data, function(index, result){
        					mid_json[result.car_class] = {
        							"1":0,
        							"2":0,
        							"3":0,
        							"4":0
        					}
        				});
        				$.each(data, function(index, result){
        					var calculate_num = mid_json[result.car_class][result.season] + result.statistics_num;
        					mid_json[result.car_class][result.season] = calculate_num;
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
        							data:[mid_json[key]["1"], mid_json[key]["2"],mid_json[key]["3"],mid_json[key]["4"]]
        					}
        					seriesArray.push(mid);
        				}
        				var option = {
        				            title: {
        				                text: '季度汽车销量统计图'
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
        				                data: ["1","2","3","4"]
        				            },
        				            yAxis: {
        				                type: 'value',
        				            },
        				            series: seriesArray
        				        };
        				myChart.setOption(option);
        				}else if (period == "month"){
        					var mid_json = new Array();
        					$.each(data, function(index, result){
        						mid_json[result.car_class] = {
        								"01":0,
        								"02":0,
        								"03":0,
        								"04":0,
        								"05":0,
        								"06":0,
        								"07":0,
        								"08":0,
        								"09":0,
        								"10":0,
        								"11":0,
        								"12":0
        						}
        					});
        					$.each(data, function(index, result){
        						var calculate_num = mid_json[result.car_class][result.month] + result.statistics_num;
        						mid_json[result.car_class][result.month] = calculate_num;
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
            							data:[mid_json[key]["01"], mid_json[key]["02"],mid_json[key]["03"],mid_json[key]["04"],
            							mid_json[key]["05"], mid_json[key]["06"],mid_json[key]["07"],mid_json[key]["08"],
            							mid_json[key]["09"], mid_json[key]["10"],mid_json[key]["11"],mid_json[key]["12"]]
            					}
            					seriesArray.push(mid);
            				}
            				var option = {
            				            title: {
            				                text: '各月汽车销量统计图'
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
            				                data: ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
            				            },
            				            yAxis: {
            				                type: 'value',
            				            },
            				            series: seriesArray
            				        };
            				myChart.setOption(option);
        				}else if (period == "year"){
    						var classArray = [];
            				var numData = [];
            				var year = 0;
        					$.each(data, function(index, result){
        						year = result.year;
                				classArray.push(result.car_class);
                				numData.push(result.statistics_num);
            				});
        					var yearString = year + "年汽车销量统计图";
        					var option = {
        				            title: {
        				                text: yearString
        				            },
        				            tooltip: {},
        				            legend: {
        				                data:["销量"]
        				            },
        				            toolbox: {
        				            },
        				            xAxis: {
        				                data: classArray
        				            },
        				            yAxis: {
        				            },
        				            series: [{
												name: '销量',
												type: 'bar',
												data: numData
        				            }]
        				        };
        				myChart.setOption(option);
        			}
        		}
        	});
    	}
    });
		//var s_name = document.getElementById("shop_name").value;
		//var year = document.getElementById("select_date").value;
		//var period = document.getElementById("period").value;
		//var post_json = {
				//"s_name":s_name,
				//"year":year,
				//"period":period
		//}
		//$.ajax({
			//url:"OrderServlet?methods=showOrderByPeriod",
			//type:"post",
			//dataType:"json",
			//data:{info:JSON.stringify(post_json)},
			//success:function(data){
				//$("#table_header").empty();
				//$("#table_container").empty();
				//var header_html = "";
				//var body_html = "";
				//if (period == "season"){
					//var mid_json = new Array();
					//$.each(data, function(index, result){
						//mid_json[result.car_class] = {
							//	"1":0,
							//	"2":0,
								//"3":0,
								//"4":0
						//}
					//});
					//$.each(data, function(index, result){
						//var calculate_num = mid_json[result.car_class][result.season] + result.statistics_num;
						//mid_json[result.car_class][result.season] = calculate_num;
					//});
					//header_html = "<td>车型</td><td>1</td><td>2</td><td>3</td><td>4</td>"
					//for (var key in mid_json){
						//if (key == "remove"){
							//continue;
						//}
						//body_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["1"] + "</td><td>" + mid_json[key]["2"] + "</td><td>"+ mid_json[key]["3"] + "</td><td>"+ mid_json[key]["4"] + "</td></tr>";
					//}
				//}else if (period == "month"){
					//var mid_json = new Array();
					//$.each(data, function(index, result){
						//mid_json[result.car_class] = {
								//"01":0,
								//"02":0,
								//"03":0,
								//"04":0,
								//"05":0,
								/*
								"06":0,
								"07":0,
								"08":0,
								"09":0,
								"10":0,
								"11":0,
								"12":0
						}
					});*/
					/*
					$.each(data, function(index, result){
						var calculate_num = mid_json[result.car_class][result.month] + result.statistics_num;
						mid_json[result.car_class][result.month] = calculate_num;
					});
					header_html = "<td>车型</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td>"
					for (var key in mid_json){
						if (key == "remove"){
							continue;
						}
						body_html += "<tr><td>" + key +"</td><td>" + mid_json[key]["01"] + "</td><td>" + mid_json[key]["02"] + "</td><td>"
									+ mid_json[key]["03"] + "</td><td>"+ mid_json[key]["04"] + "</td><td>"+ mid_json[key]["05"] + "</td><td>"
									+ mid_json[key]["06"] + "</td><td>" + mid_json[key]["07"] + "</td><td>"+ mid_json[key]["08"] + "</td><td>"
									+ mid_json[key]["09"] + "</td><td>" + mid_json[key]["10"] + "</td><td>" + mid_json[key]["11"] + "</td><td>" + mid_json[key]["12"] + "</td></tr>";
					}
				}else if (period == "year"){
					$.each(data, function(index, result){
					header_html = "<td>车型</td><td>" + result.year +"</td>";
					body_html += "<tr><td>" + result.car_class + "</td><td>" + result.statistics_num + "</td><tr>";
					});
				}
				$("#table_header").html(header_html);
				$("#table_container").html(body_html);
			}
		});*/
    </script>
</body>
</html>