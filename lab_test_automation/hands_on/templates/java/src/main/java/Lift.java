public class Lift {
    private int currentFloor, maxFloor = 10, minFloor = -2;
    private String direction;

    public Lift(){
        currentFloor = 0;
        direction = "Standing still";
    }

    public int getCurrentFloor(){
        return this.currentFloor;
    }

    public String getCurrentDirection(){
        return this.direction;
    }

    private boolean setCurrentFloor(int targetFloor){
        if (targetFloor <= maxFloor && targetFloor >= minFloor) {
            if (targetFloor > currentFloor) {
                setCurrentDirection("Going up");
            } else {
                setCurrentDirection("Going down");
            }

            this.currentFloor = targetFloor;
            return true;
        }
        return false;
    }

    private void setCurrentDirection (String direction){
        this.direction = direction;
    }

    public void goToFloor(int targetFloor) {
        setCurrentFloor(targetFloor);
    }
}
