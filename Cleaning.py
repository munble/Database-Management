# -*- coding: UTF-8 -*-

import numpy as np
import pandas as pd
import csv
import xlrd,xlwt
import json

data = pd.read_csv('animal_shelter_data.csv')
print data

# data.ix[1,'Color'] = 'Tricolor'


#赋值
def Col(row):
    if 'Tricolor' in row['Color']:
        return 3
    elif '/' in row['Color']:
        return 2
    else:
        return 1

data['num'] = data.apply(Col,axis=1)


#拆分

data[['col1','col2']] = data['Color'].apply(lambda x: pd.Series([i for i in x.split("/")]))


#删除
def delete(a):
    if a['col1'] == a['col2']:
        return None
    else:
        return a['col2']

data['col2'] = data.apply(delete,axis=1)

#交换位置

color1 = data['col1']
color2 = data['col2']

print color1[14]
print color2[14]+'\n'


#可将删除与调换同时处理 加入cmp==0的情况
for indexs in color1.index:
    if cmp(color1[indexs],color2[indexs]) == 1:
        flag = color1[indexs]
        color1[indexs] = color2[indexs]
        color2[indexs] = flag
    else:
        continue

print color1[14]
print color2[14]



#将修改好的Series写回DataFrame并将文件输出

data['col1'] = color1
data['col2'] = color2
print data

data.to_csv('colorFinal.csv')




