#ifndef MONTECARLOCORE_H
#define MONTECARLOCORE_H

#include <QObject>
#include <QVector>
#include <QThread>
#include <cmath>
#include <random>


#define NEIGH 4

class monteCarloCore : public QObject
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

    typedef QVarLengthArray < QVector < int > > posType;
    typedef QVarLengthArray < QVector < qreal > > magType;
    typedef QVarLengthArray < qreal > energyType;

public:
    explicit monteCarloCore(QObject *parent = nullptr);

    void drop();
    void dropRandom();
    void dropAllUp();
    void dropChessboard();
    void dropLineUpDown();
    void eCalc();
    double getE() const { return E; }

    posType m_poses;
    magType m_mags;
    energyType m_energies;

    unsigned nx, ny, N;
    double Hc, T, Ha, r;
    Vect Had,Hcd;
    std::default_random_engine generator;

signals:
    void mcStepDone(unsigned);
    void mcAllDone();

public slots:
    void mc(unsigned long steps = 1);

private:
    double E;
    QVector<Part> parts;


    double hamiltonianDipolar(const Vect & radius, const Vect &mi, const Vect &mj);
    inline unsigned nnum(unsigned i,unsigned j){return i*nx+j;}

    void fixStep(unsigned long stepnum);
};

#endif // MONTECARLOCORE_H
