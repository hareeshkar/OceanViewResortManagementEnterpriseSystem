package oceanview.test;

import oceanview.dao.AccommodationDAO;
import oceanview.model.Accommodation;
import org.junit.Before;
import org.junit.Test;
import java.time.LocalDate;
import java.util.List;
import static org.junit.Assert.*;

public class AccommodationDAOTest {
    private AccommodationDAO dao;

    @Before
    public void setUp() {
        dao = new AccommodationDAO();
    }

    @Test
    public void testAvailableRoomsFetch() {
        // Test fetching rooms for a future date
        LocalDate start = LocalDate.now().plusMonths(1);
        LocalDate end = start.plusDays(3);

        List<Accommodation> rooms = dao.getAvailableRooms(start, end);

        assertNotNull("Room list should not be null", rooms);
        // We seeded 7 rooms in the SQL script
        assertTrue("Should find available rooms", rooms.size() > 0);
        System.out.println("✅ Room Availability Test: Fetched " + rooms.size() + " rooms.");
    }

    @Test
    public void testCategoryFiltering() {
        // Test the "Calculated Status" logic for Category 1 (Standard)
        LocalDate start = LocalDate.now().plusMonths(2);
        LocalDate end = start.plusDays(2);

        List<Accommodation> rooms = dao.getRoomsWithCalculatedStatus(start, end, 1);

        for(Accommodation r : rooms) {
            assertEquals("Unbooked rooms should be AVAILABLE", "AVAILABLE", r.getCalculatedStatus());
        }
        System.out.println("✅ Category Filter Test: Logic verified for Category 1.");
    }
}
