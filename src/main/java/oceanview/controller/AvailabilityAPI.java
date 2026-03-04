package oceanview.controller;

import oceanview.dao.AccommodationDAO;
import oceanview.model.Accommodation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.List;

/**
 * Enterprise REST API for Dynamic Room Availability.
 */
@WebServlet(name = "AvailabilityAPI", urlPatterns = {"/api/availability"})
public class AvailabilityAPI extends HttpServlet {

    private AccommodationDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new AccommodationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security & Content Type Headers
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        String arrivalStr = request.getParameter("arrival");
        String departureStr = request.getParameter("departure");
        String categoryIdStr = request.getParameter("categoryId");

        // 🛡️ SERVER-SIDE GUARD: API Parameter Validation
        if (arrivalStr == null || departureStr == null || categoryIdStr == null || categoryIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("[]");
            return;
        }

        try {
            LocalDate arrival = LocalDate.parse(arrivalStr);
            LocalDate departure = LocalDate.parse(departureStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            // Fetch rooms from DAO
            List<Accommodation> rooms = roomDAO.getRoomsWithCalculatedStatus(arrival, departure, categoryId);

            // Manual JSON Construction (No forbidden frameworks)
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < rooms.size(); i++) {
                Accommodation r = rooms.get(i);
                json.append("{")
                    .append("\"roomPk\":").append(r.getRoomPk()).append(",")
                    .append("\"roomNumber\":\"").append(r.getRoomNumber()).append("\",")
                    .append("\"status\":\"").append(r.getCalculatedStatus()).append("\",")
                    .append("\"baseRateLkr\":\"").append(r.getBaseRateLkr().toString()).append("\"")
                    .append("}");
                if (i < rooms.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
}
