package oceanview.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
    PhaseOneTest.class,           // DB & Security
    AccountDAOTest.class,         // Authentication
    BillingServiceTest.class,     // Financial Math
    AccommodationDAOTest.class,   // Room Logic
    ReservationIntegrationTest.class // Transaction Logic
})
public class MasterTestSuite {
    // This class remains empty. It is used only as a holder for the above annotations.
}
