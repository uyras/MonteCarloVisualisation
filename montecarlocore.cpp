#include "montecarlocore.h"

monteCarloCore::monteCarloCore(QObject *parent) : QObject(parent)
{

}

void monteCarloCore::mc(unsigned long steps)
{
    const unsigned long totalSteps = steps;
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
        fixStep(totalSteps-steps);
        if(this->thread()->isInterruptionRequested()){
            break;
        }

        --steps;
    } while (steps>0);
    mcAllDone();
}


double monteCarloCore::hamiltonianDipolar(const monteCarloCore::Vect &radius, const monteCarloCore::Vect &mi, const monteCarloCore::Vect &mj)
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

void monteCarloCore::drop()
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

void monteCarloCore::dropRandom()
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

void monteCarloCore::dropAllUp()
{
    for (int num=0;num<parts.length();++num){
            // random direction
            parts[num].m.x = 0;
            parts[num].m.y = 0;
            parts[num].m.z = 1;
    }
}

void monteCarloCore::dropChessboard()
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

void monteCarloCore::dropLineUpDown()
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

void monteCarloCore::eCalc()
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

void monteCarloCore::fixStep(unsigned long stepnum)
{
    QVector < int > poses(int(N * 3));
    QVector < qreal > mags(int(N * 3));
    int i = 0;
    for (auto part : parts){
        poses[i] = int(part.pos.x);
        poses[i+1] = int(part.pos.y);
        poses[i+2] = int(part.pos.z);
        mags[i] = qreal(part.m.x);
        mags[i+1] = qreal(part.m.y);
        mags[i+2] = qreal(part.m.z);
        i+=3;
    }
    m_poses.append(poses);
    m_mags.append(mags);
    m_energies.append(E/N);
    mcStepDone(stepnum);
}
