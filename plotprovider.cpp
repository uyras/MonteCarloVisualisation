#include "plotprovider.h"

plotProvider::plotProvider():
    needUpdateMinMax(false)
{
    m_minmaxKeys.resize(dataRowKeys.length()*2);
    for (int i = 0; i < dataRowKeys.length(); ++i){
        m_minmaxKeys[i*2+0] = dataRowKeys[i]+"Min";
        m_minmaxKeys[i*2+1] = dataRowKeys[i]+"Max";
    }
    datarow tmp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    updateMinMax(tmp);
}

int plotProvider::rowCount(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return m_data.length();
}

int plotProvider::columnCount(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return TABLEITEMS;
}

QVariant plotProvider::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    QVariant var;
    var.setValue(m_data[index.row()][ulong(index.column())]);
    return var;
}

void plotProvider::beginAddRow(int count)
{
    this->beginInsertRows(QModelIndex(), m_data.length(), m_data.length() + count - 1);
}

void plotProvider::addRow(datarow data)
{
    updateMinMax(data);
    m_data.append(data);
}

void plotProvider::endAddRow()
{
    this->endInsertRows();
    if (needUpdateMinMax){
        minMaxChanged();
        needUpdateMinMax = false;
    }
}

void plotProvider::updateMinMax(const datarow &data)
{
    if (m_data.length() == 0){
        for (int i = 1; i < dataRowKeys.length(); ++i){
            m_minmax[m_minmaxKeys[i*2+0]] = data[ulong(i)];
            m_minmax[m_minmaxKeys[i*2+1]] = data[ulong(i)];
        }
        needUpdateMinMax = true;
    } else {
        for (int i = 1; i < dataRowKeys.length(); ++i){
            if (m_minmax[m_minmaxKeys[i*2+0]] > data[ulong(i)]){ // minimal value
                m_minmax[m_minmaxKeys[i*2+0]] = data[ulong(i)];
                needUpdateMinMax = true;
            }
            if (m_minmax[m_minmaxKeys[i*2+1]] < data[ulong(i)]){ // maximal value
                m_minmax[m_minmaxKeys[i*2+1]] = data[ulong(i)];
                needUpdateMinMax = true;
            }
        }
    }
}
