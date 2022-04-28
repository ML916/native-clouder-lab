import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class LiftTest {

    private Lift lift;

    @BeforeEach
    public void init() {
        lift = new Lift();
    }

    @Test
    public void initialFloor(){
        assertEquals(0, lift.getCurrentFloor());
    }

    @Test
    public void testGoUp(){
        lift.goToFloor(1);
        assertEquals(1, lift.getCurrentFloor());
        assertEquals("Going up", lift.getCurrentDirection());
    }

    @Test
    public void testGoDown(){
        lift.goToFloor(-1);
        assertEquals(-1, lift.getCurrentFloor());
        assertEquals("Going down", lift.getCurrentDirection());
    }

    @Test
    public void testGoToFloor10(){
        lift.goToFloor(10);
        assertEquals(10, lift.getCurrentFloor());
        assertEquals("Going up", lift.getCurrentDirection());
    }

    @Test
    public void testCanNotGoToFloor(){
        lift.goToFloor(999);
        assertEquals(0, lift.getCurrentFloor());
        assertEquals("Standing still", lift.getCurrentDirection());
    }

    @Test void testStandingStill(){
        assertEquals("Standing still", lift.getCurrentDirection());
    }
}
