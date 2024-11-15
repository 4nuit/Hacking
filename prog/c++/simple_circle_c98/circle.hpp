#ifndef CIRCLE_HPP_
#define CIRCLE_HPP_

class Circle{
    private:
        double x, y;
    protected:
        int r;
    public:
        Circle(double x, double y, int r);
        //Circle(const Circle*);
        Circle(const Circle&);
        virtual ~Circle();
        double getX();
        double getY();
        double area();
        int getR();
        int setR(int r);
    };

#endif
