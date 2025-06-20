#include <iostream>

using namespace std;

class bullet
{
    public:
        int x;
        int y;
        int speed_x;
        int speed_y;

        void move_bullet()
        {
            x = x + speed_x;
            y = y + speed_y;
        }
};

int main()
{
    bullet b[20];

    b[0].x = 5;
    b[0].y = 6;
    b[0].speed_x = 3;
    b[0].speed_y = 2;

    b[0].move_bullet();

    cout << "bullet position = " << b[0].x << ", " << b[0].y << endl;

    return 0;
}
