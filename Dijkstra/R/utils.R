#' @export
# 将边列表转换为邻接矩阵的函数----
edgeList_to_adjMatrix <- function(edges, n = NULL) {
  if (is.null(n)) {
    n <- max(edges$from, edges$to)
  }
  adjMatrix <- matrix(Inf, nrow = n, ncol = n)
  for (i in 1:nrow(edges)) {
    adjMatrix[edges$from[i], edges$to[i]] <- edges$weight[i]
  }
  return(adjMatrix)
}