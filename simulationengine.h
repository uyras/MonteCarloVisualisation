#ifndef SIMULATIONENGINE_H
#define SIMULATIONENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVector>
#include <cmath>
#include <random>


#define NEIGH 4

class simulationEngine : public QObject
{
    Q_OBJECT

    struct Vect{
        Vect(){}
        Vect(double x,double y,double z): x(x),y(y),z(z){}
        double x=0;
        double y=0;
        double z=0;

        inline double scalar (const Vect &b) const {return x * b.x + y * b.y + z * b.z;}
        inline void normalize(){double l = sqrt(x*x+y*y+z*z); x/=l; y/=l; z/=l;}
        inline double len2() const {return x*x+y*y+z*z;}
        inline double len() const {return sqrt(len2());}

        void operator+=(const Vect & b){
            this->x+=b.x;
            this->y+=b.y;
            this->z+=b.z;
        }

        inline Vect operator-(const Vect & b) const{
            return Vect(this->x-b.x,this->y-b.y,this->z-b.z);
        }
    };

    typedef struct{
        Vect pos;
        Vect m;
        int neigh[NEIGH];
        double EHa; //Энергия магнитного момента по полю анизотропии
        double EHc; //Энергия магнитного момента по внешнему полю
    } Part;

public:
    explicit simulationEngine(QObject *parent = nullptr);

    Q_INVOKABLE void init(unsigned nx, unsigned ny, unsigned initialState, unsigned seed);

    Q_INVOKABLE QVariantList makeStep(double H, double hx, double hy, double hz, double T, double a, double ax, double ay, double az, double r = 0.1);

signals:

public slots:

private:
    unsigned nx, ny, N;
    double E;
    double Hc, T, Ha, r;
    Vect Had,Hcd;
    std::default_random_engine generator;
    QVector<Part> parts;

    double hamiltonianDipolar(const Vect & radius, const Vect &mi, const Vect &mj);
    inline unsigned nnum(unsigned i,unsigned j){return i*nx+j;}
    void drop();
    void dropRandom();
    void dropAllUp();
    void dropChessboard();
    void dropLineUpDown();
    void eCalc();
    void mc(unsigned long steps = 1);
};

#endif // SIMULATIONENGINE_H
