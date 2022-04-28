import unittest

from src.lift import Lift


class TestLift(unittest.TestCase):
    def test_get_current_floor(self):
        lift = Lift()
        expected = 0

        actual = lift.get_current_floor()

        self.assertEqual(actual, expected)

    def test_go_to_floor(self):
        lift = Lift()
        expected = 1

        lift.go_to_floor(1)
        actual = lift.get_current_floor()

        self.assertEqual(actual, expected)


if __name__ == '__main__':
    unittest.main()
