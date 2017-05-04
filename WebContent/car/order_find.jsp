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
                    <div class="item-lt">车型：</div>
                    <div class="item-rt">
                        <select id="car_type">
                            <option value="不限">不限</option>
                        </select>
                    </div>
                </div>
                <div class="kv-item">
                    <div class="item-lt">系列：</div>
                    <div class="item-rt">
                        <select id="car_class">
                            <option value="不限">不限</option>
                        </select>
                    </div>
                </div>
                <div class="kv-item">
                    <div class="item-lt">具体型号：</div>
                    <div class="item-rt">
                        <select id="car_model">
                            <option value="不限">不限</option>
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
    </div>
    <div class="table-zone">
         <table class="no-data">
            <thead>
              <td style="width:110px;">订单号</td>
              <td style="width:100px;">日期</td>
              <td style="width:160px;">4s店</td>
              <td style="width:auto;">车型</td>
              <td style="width:auto;">系列</td>
              <td style="width:auto;">具体型号</td>
              <td style="width:auto;">数量</td>
              <td style="width:auto;">销售价格</td>
            </thead>
            <tbody  id="result">
            	<c:forEach  items="${requestScope.order}" var="order">
    				<tr>
    					<td>${order.o_id}</td>
  						<td>${order.o_date}</td>
  						<td>${order.s_name}</td>
  						<td>${order.car_type}</td>
  						<td>${order.car_class}</td>
  						<td>${order.car_model}</td>
  						<td>${order.o_num}</td>
  						<td>${order.o_price}</td>
    				</tr>
    			</c:forEach>
            </tbody> 
         </table>
    </div>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/global.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.select.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/core.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/bootstrap-datepicker.zh-CN.min.js"></script>
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
    		var s_name = document.getElementById("shop_name").value;
    		var car_type = document.getElementById("car_type").value;
    		var car_class = document.getElementById("car_class").value;
    		var car_model = document.getElementById("car_model").value;
    		var start_time = document.getElementById("start").value;
    		var end_time = document.getElementById("end").value;
    		var post_json = {
    				"s_name":s_name,
    				"car_type":car_type,
    				"car_class":car_class,
    				"car_model":car_model,
    				"start_time":start_time,
    				"end_time":end_time	
    		}
    		$.ajax({
    			url:"OrderServlet?methods=findOrder",
    			type:"post",
    			dataType:"json",
    			data:{info:JSON.stringify(post_json)},
    			success:function(data){
    				$("#result").empty();
    				var html = "";
    				$.each(data, function(index, result){
    					html += '<tr><td>'+result.o_id+'</td><td>'+result.o_date+'</td><td>'+result.s_name
    							+'</td><td>'+result.car_type+'</td><td>'+result.car_class+'</td><td>'
    							+result.car_model+'</td><td>'+result.o_num+'</td><td>'+result.o_price+'</td></tr>'
    				});
    				$("#result").html(html);
    			}
    		});
    	});
	</script>
</body>

</html>

