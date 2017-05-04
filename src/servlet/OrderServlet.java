package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.fasterxml.jackson.databind.ObjectMapper;

import dao.OrderDao;
import entity.Order;
import entity.OrderFindCondition;
import entity.StatisticsOrder;


/**
 * Servlet implementation class OrderServlet
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public OrderServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		String methods = request.getParameter("methods");
		if (methods != null && methods.equals("showAllOrder")){
			//显示所有订单
			OrderDao dao = new OrderDao();
			List<Order> result = dao.showAllOrder();
			request.setAttribute("order", result);
			request.getRequestDispatcher("car/order_find.jsp").forward(request, response);
		}else if (methods != null && methods.equals("findOrder")){
			//根据条件检索订单信息
			String findConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			OrderFindCondition orderFindCondition = mapper.readValue(findConditionString, OrderFindCondition.class);
			OrderDao dao = new OrderDao();
			List<Order> result = dao.findOrderByCondition(orderFindCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}else if (methods != null && methods.equals("showShopOrder")){
			//点击后渲染4s店销售情况页面
			request.getRequestDispatcher("car/order_shop.jsp").forward(request, response);
		}else if (methods != null && methods.equals("showOrderByPeriod")){
			String findConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			OrderFindCondition orderFindCondition = mapper.readValue(findConditionString, OrderFindCondition.class);
			OrderDao dao = new OrderDao();
			List<StatisticsOrder> result = dao.showOrderByPeriod(orderFindCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}
	}
}
