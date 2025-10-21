# Test Dijkstra
​

使用R语言实现Dijkstra算法求最短路径

求点2、3、4、5、6、7到点1的最短距离和路径



1.设置data，存放有向图信息


代码 
```
m <- Inf
num <- 7
data <- matrix(c(
  m, 4, 6, 6, m, m, m,
  m, m, 1, m, 7, m, m,
  m, m, m, m, 6, 4, m,
  m, m, 2, m, m, 5, m,
  m, m, m, m, m, m, 6,
  m, m, m, m, 1, m, 8,
  m, m, m, m, m, m, m
), nrow = num, byrow = TRUE)
```
2.辅助参数设置 




代码 
```
dist <- rep(m,num)
path <- rep(-1,num)
mark <- rep(0,num)
此处参考资料：Dijkstra算法求最短路径_哔哩哔哩_bilibili

3.Min():更新过程中分离出来的便捷函数

代码 

Min <- function(last){
  w = 1
  while (mark[w] != 0){
    w <- w+1
  }
  for (i in 1:last){
      if (mark[i] == 0 && dist[i] < dist[w]){
        w = i
      }
  }
  return(w)
}
```
4.Dijkstra算法主要过程 
4.1.起点初始化

代码 
```
k = 1
dist[k] = 0
path[k] = -1
mark[k] = 1
```
4.2.内外循环  






代码 
```
for(x in 2:num){ # 遍历全部的点
  for (i in 2:num){ # 以点1开始更新联通点，其实因为有if (mark[i] == 0)，所以2:num还是1:num无所谓
    if (mark[i] == 0){
      if (dist[i] > dist[k] + data[k,i]){
        dist[i] = dist[k] + data[k,i]
        path[i] = k
      }
    }
  }
  k = Min(num) # 从联通点中距离最短的点开始继续更新该点的联通点 
  mark[k] = 1 # 比如，点1的联通点中最小点为2，那么下一轮从2开始，同时点2不再更新，点3、4还有更新的机会
}
```
5.可视化 
代码 
```
## 打印终点到终点的最短距离----
cat("Shortest distance to node",num,":", dist[num], "\n")

## 打印每个节点的最短路径和距离----
for (u in 1:num){
  cat(sprintf("Shortest Path to node %d: %d -> %d\n", u, path[u], u))
  cat(sprintf("Minimum Distance to node %d: %d\n", u, dist[u]))
}
```

完整代码
```
# 设置data，存放有向图信息----
## data中每个点所在的行序号为起始点序号，列为终点序号----
### 比如：值4的坐标为(1,2)即点1到点2距离为4；值8的坐标为(6,7)即点6到点7距离为8；INF表示x->y不通----
m <- Inf
num <- 7
data <- matrix(c(
  m, 4, 6, 6, m, m, m,
  m, m, 1, m, 7, m, m,
  m, m, m, m, 6, 4, m,
  m, m, 2, m, m, 5, m,
  m, m, m, m, m, m, 6,
  m, m, m, m, 1, m, 8,
  m, m, m, m, m, m, m
), nrow = num, byrow = TRUE)

# 辅助参数----
## dist:每个点到初始点的距离，设置为INF，之后根据data中距离进行更新，最后可以得到每个点到初始点的最短距离----
## path:初始点到每个点的最短路线中，每个点前面的路径；比如点1->点3的最短路径为点1->点2->点3；那么最后path[3]中存的即是节点2----
## mark:起始值为0，代表还没有进行更新（找到到起始点的最短距离）----
## 后续使用双重for循环，在最初点开始一轮更新后，以每个点为起始点继续更新（以该点为起始更新完后，该点前面的最小距离已经确定，不再参与后续更新，其mark被设置为1），这个过程需要遍历每个点----
dist <- rep(m,num)
path <- rep(-1,num)
mark <- rep(0,num)
### 此处参考资料：https://www.bilibili.com/video/BV11P4y1a7X9/?spm_id_from=333.999.0.0&vd_source=709bfcb2343a93fce7f20d52e9a6c8cf


# 更新过程中分离出来的便捷函数----
## 在全部的节点中寻找mark[i] == 0，即没访问过的点中有最小值的点，返回w，作为下一轮内循环的k，开始更新联通的点----
Min <- function(last){
  w = 1
  while (mark[w] != 0){
    w <- w+1
  }
  for (i in 1:last){
    if (mark[i] == 0 && dist[i] < dist[w]){
      w = i
    }
  }
  return(w)
}

# Dijkstra算法主要过程----
## 初始点为点1，更新其三个参数
k = 1
dist[k] = 0
path[k] = -1
mark[k] = 1
## 内循环：如果dist[i] > dist[k] + data[k,i]成立，说明k点到i点是通的（不是INF），即根据点k更新点i（和点k联通的多个点）
### 比如从点1开始（初始k的距离为0：dist[k] = 0）遍历全部点，更新联通的点2，3，4，结束第一次内循环
## 外循环：第一次内循环结束后，使用函数Min()找和点1联通的点中dist最小的点，标记为mark[k] = 1，结束第一次外循环，第二轮内循环的k为和点1联通的这个最近点
### 因为基于点k更新的联通点的距离是基于dist[k]的，此时被函数Min()找出，标记为mark[k] = 1，不再参加后续更新
### 注意k的顺序不是按序号来的，取决于data，比如点2，3，4和1联通，第二次从2开始更新和2联通的3和5，点3就还可以更新，接着从点3开始更新5和6，但是接着从4开始，只取决于距离
### 接着遍历全部的点，找到目前距离最短的，没有完成更新的点，标记结束后作为下一次更新的起始点
for(x in 2:num){ # 遍历全部的点
  for (i in 2:num){ # 以点1开始更新联通点，其实因为有if (mark[i] == 0)，所以2:num还是1:num无所谓
    if (mark[i] == 0){
      if (dist[i] > dist[k] + data[k,i]){
        dist[i] = dist[k] + data[k,i]
        path[i] = k
      }
    }
  }
  k = Min(num) # 从联通点中距离最短的点开始继续更新该点的联通点 
  mark[k] = 1 # 比如，点1的联通点中最小点为2，那么下一轮从2开始，同时点2不再更新，点3、4还有更新的机会
}

# 可视化----
## 打印终点到终点的最短距离----
cat("Shortest distance to node",num,":", dist[num], "\n")

## 打印每个节点的最短路径和距离----
for (u in 1:num){
  cat(sprintf("Shortest Path to node %d: %d -> %d\n", u, path[u], u))
  cat(sprintf("Minimum Distance to node %d: %d\n", u, dist[u]))
}
​```
