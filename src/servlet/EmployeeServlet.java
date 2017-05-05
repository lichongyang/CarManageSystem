package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import dao.ClientDao;
import dao.EmployeeDao;
import dao.OrderDao;
import entity.EmployeePerformance;
import entity.FindCondition;
import entity.ShopPerformance;
import entity.StatisticsClientSource;
import entity.StatisticsOrder;

/**
 * Servlet implementation class EmployeeServlet
 */
@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EmployeeServlet() {
        super();
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
		if (methods != null && methods.equals("showEmployeePerformancePage")){
			//点击店员分析后渲染页面
			request.getRequestDispatcher("employee/employee_performance.jsp").forward(request, response);
		}else if (methods != null && methods.equals("EmployeePerformanceAnalyze")){
			String findConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			FindCondition findCondition = mapper.readValue(findConditionString, FindCondition.class);
			EmployeeDao dao = new EmployeeDao();
			List<EmployeePerformance> result = dao.showEmployeePerformance(findCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}else if(methods != null && methods.equals("showShopPerformancePage")){
			//点击绩效分析4s店后渲染页面
			request.getRequestDispatcher("employee/shop_performance.jsp").forward(request, response);
		}else if(methods != null && methods.equals("ShopPerformanceAnalyze")){
			String findConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			FindCondition findCondition = mapper.readValue(findConditionString, FindCondition.class);
			EmployeeDao dao = new EmployeeDao();
			ShopPerformance result = dao.findShopPerformance(findCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}
	}

}
