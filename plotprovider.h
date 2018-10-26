#ifndef PLOTPROVIDER_H
#define PLOTPROVIDER_H

#define TABLEITEMS 15


#include <QObject>
#include <QAbstractTableModel>
#include <QVarLengthArray>
#include <array>


/*struct dataRow { //this field structure is underlying in datarow type
 *  double i;  //0
    double mx; //1
    double my; //2
    double mz; //3
    double m;  //4
    double e;  //5
    double t;  //6
    double ax; //7
    double ay; //8
    double az; //9
    double a;  //10
    double hx; //11
    double hy; //12
    double hz; //13
    double h;  //14
};*/
typedef std::array<double, TABLEITEMS> datarow;
const QStringList dataRowKeys = {"i",
                           "mx","my","mz","m",
                           "e","t",
                           "ax","ay","az","a",
                           "hx","hy","hz","h"
                          };

class plotProvider : public QAbstractTableModel
{

    Q_OBJECT


public:
    explicit plotProvider();

    int rowCount(const QModelIndex &index) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &index) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE;

    void beginAddRow(int count);
    void addRow(datarow data);
    void endAddRow();
    void updateMinMax(const datarow& data);

    Q_PROPERTY(QVariantMap minmax MEMBER m_minmax NOTIFY minMaxChanged)

signals:
    void minMaxChanged();

private:
    QVarLengthArray < datarow > m_data;
    QVariantMap m_minmax;
    bool needUpdateMinMax;
    QVarLengthArray < QString > m_minmaxKeys; //for quick storing keys of array
};

#endif // PLOTPROVIDER_H
