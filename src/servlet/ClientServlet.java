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
import dao.OrderDao;
import entity.CarFashionAnalyze;
import entity.CarFashionAnalyzeCondition;
import entity.Order;
import entity.OrderFindCondition;

/**
 * Servlet implementation class ClientServlet
 */
@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClientServlet() {
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
		if (methods != null && methods.equals("showFashionPage")){
			//点击各车型冷热程度后渲染页面
			request.getRequestDispatcher("client/car_fashion.jsp").forward(request, response);
		}else if (methods != null && methods.equals("CarFashionAnalyze")){
			String analyzeConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			CarFashionAnalyzeCondition analyzeCondition = mapper.readValue(analyzeConditionString, CarFashionAnalyzeCondition.class);
			ClientDao dao = new ClientDao();
			List<CarFashionAnalyze> result = dao.findCarFashion(analyzeCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}else if (methods != null && methods.equals("showPricePage")){
			//点击价格分析后渲染页面
			request.getRequestDispatcher("client/car_price.jsp").forward(request, response);
		}else if (methods != null && methods.equals("CarPriceAnalyze")){
			String analyzeConditionString = request.getParameter("info");
			ObjectMapper mapper = new ObjectMapper();
			CarFashionAnalyzeCondition analyzeCondition = mapper.readValue(analyzeConditionString, CarFashionAnalyzeCondition.class);
			ClientDao dao = new ClientDao();
			List<CarFashionAnalyze> result = dao.findCarPrice(analyzeCondition);
			String jsonlist = mapper.writeValueAsString(result);
			System.out.print(jsonlist);
			response.getWriter().println(jsonlist);
		}
	}

}
