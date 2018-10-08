#include "simulationengine.h"

simulationEngine::simulationEngine(QObject *parent) : QObject(parent)
{

}

void simulationEngine::init(unsigned nx, unsigned ny, unsigned initialState, unsigned seed)
{
    generator.seed(seed);
    this->nx = nx;
    this->ny = ny;
    this->N = nx*ny;
    drop();
    switch (initialState) {
        case 0: dropRandom(); break;
        case 1: dropAllUp(); break;
        case 2: dropChessboard(); break;
        case 3: dropLineUpDown(); break;
    }
}

QVariantList simulationEngine::makeStep(
        double H,
        double hx,
        double hy,
        double hz,
        double T,
        double a,
        double ax,
        double ay,
        double az,
        double r)
{
    this->Hc = H;
    this->Hcd.x = hx;
    this->Hcd.y = hy;
    this->Hcd.z = hz;
    this->Ha = a;
    this->Had.x = ax;
    this->Had.y = ay;
    this->Had.z = az;
    this->T = T;
    this->r = r;
    this->eCalc();
    this->mc(1);
    QVariantList res;
    for (int i=0; i<N; ++i){
        QVariantList resDat;
        resDat.reserve(6);
        resDat << parts[i].pos.x;
        resDat << parts[i].pos.y;
        resDat << parts[i].pos.z;
        resDat << parts[i].m.x;
        resDat << parts[i].m.y;
        resDat << parts[i].m.z;
        res << QVariant(resDat);
    }
    return res;
}

double simulationEngine::hamiltonianDipolar(const simulationEngine::Vect &radius, const simulationEngine::Vect &mi, const simulationEngine::Vect &mj)
{
    double r2, r, r5,E;
    r2 = radius.len2();
    r = sqrt(r2); //трудное место, заменить бы
    r5 = r2 * r2 * r; //радиус в пятой
    E = //энергия считается векторным методом, так как она не нужна для каждой оси
            (( (mi.x * mj.x + mi.y * mj.y + mi.z * mj.z) * r2)
             -
             (3 * (mj.x * radius.x + mj.y * radius.y + mj.z * radius.z) * (mi.x * radius.x + mi.y * radius.y + mi.z * radius.z)  )) / r5;
    return E;
}

void simulationEngine::drop()
{
    parts.resize(int(N));
    int num=0;
    for (unsigned i=0;i<nx;++i){
        for (unsigned j=0;j<ny;++j){
            // random direction
            parts[num].m.x = 0;
            parts[num].m.y = 0;
            parts[num].m.z = 1;

            parts[num].pos.x=j;
            parts[num].pos.y=i;

            if (i>0){
                parts[num].neigh[0]=int(nnum(i-1,j));
            } else{
                parts[num].neigh[0]=-1;
            }
            if (i<nx-1){
                parts[num].neigh[1]=int(nnum(i+1,j));
            } else{
                parts[num].neigh[1]=-1;
            }
            if (j>0){
                parts[num].neigh[2]=int(nnum(i,j-1));
            } else{
                parts[num].neigh[2]=-1;
            }
            if (j<ny-1){
                parts[num].neigh[3]=int(nnum(i,j+1));
            } else{
                parts[num].neigh[3]=-1;
            }
            ++num;
        }
    }
}

void simulationEngine::dropRandom()
{
    std::uniform_real_distribution<double> uniform01(0.0, 1.0);
    double theta,phi;
    for (int num=0;num<parts.length();++num){
            // random direction
            theta = 2 * M_PI * uniform01(generator);
            phi = acos(1 - 2 * uniform01(generator));
            parts[num].m.x = sin(phi) * cos(theta);
            parts[num].m.y = sin(phi) * sin(theta);
            parts[num].m.z = cos(phi);
    }
}

void simulationEngine::dropAllUp()
{
    for (int num=0;num<parts.length();++num){
            // random direction
            parts[num].m.x = 0;
            parts[num].m.y = 0;
            parts[num].m.z = 1;
    }
}

void simulationEngine::dropChessboard()
{
    int num=0;
    for (unsigned i=0;i<nx;++i){
        for (unsigned j=0;j<ny;++j){
            // random direction
            parts[num].m.x = 0;
            parts[num].m.y = 0;
            parts[num].m.z = ((i%2)^(j%2))?-1:1;
            ++num;
        }
    }
}

void simulationEngine::dropLineUpDown()
{
    int num=0;
    for (unsigned i=0;i<nx;++i){
        for (unsigned j=0;j<ny;++j){
            // random direction
            parts[num].m.x = 0;
            parts[num].m.y = 0;
            parts[num].m.z = ((i%2))?-1:1;
            ++num;
        }
    }
}

void simulationEngine::eCalc()
{
    E=0;
    int j=0;
    for (unsigned i=0;i<N;++i){
        for (unsigned k=0; k<NEIGH; ++k){
            j=parts[i].neigh[k];
            if (j!=-1 && i!=j){
                E += hamiltonianDipolar(parts[i].pos-parts[j].pos,parts[i].m,parts[j].m);
            }
        }
        E -= 2.*(parts[i].EHa = pow(parts[i].m.scalar(Had),2)*Ha);
        E -= 2.*(parts[i].EHc = parts[i].m.scalar(Hcd)*Hc);
    }
    E*=0.5;
}

void simulationEngine::mc(unsigned long steps)
{
    unsigned assump;
    double de,newEHa,newEHc;
    Vect newM,dm;
    double theta,phi;
    std::uniform_real_distribution<double> uniform01(0.0, 1.0);
    std::uniform_int_distribution<int> uniformN(0,N-1);

    do{
        for (unsigned MCS=0; MCS<N; ++MCS){

            assump=uniformN(generator);
            newM=parts[assump].m;

            theta = 2 * M_PI * uniform01(generator);
            phi = acos(1 - 2 * uniform01(generator));

            newM.x += r * sin(phi) * cos(theta);
            newM.y += r * sin(phi) * sin(theta);
            newM.z += r * cos(phi);
            newM.normalize();
            dm = parts[assump].m - newM;

            de=0;
            for (int k=0; k<NEIGH; ++k){
                int j=parts[assump].neigh[k];
                if (j!=-1)
                    de -= hamiltonianDipolar(parts[assump].pos-parts[j].pos,dm,parts[j].m);
            }
            newEHa=pow(newM.scalar(Had),2)*Ha;
            newEHc=newM.scalar(Hcd)*Hc;
            de += (parts[assump].EHa - newEHa);
            de += (parts[assump].EHc - newEHc);


            if (exp(-de/T)>uniform01(generator)){
                parts[assump].m = newM;
                parts[assump].EHa=newEHa;
                parts[assump].EHc=newEHc;
                E+=de;
            }
        }

        --steps;
    } while (steps>0);
}
