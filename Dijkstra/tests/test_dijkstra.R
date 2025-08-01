# testthat测试框架要求每个test_that()块内必须包含显式断言函数（如expect_equal()、expect_true()等）
test_that("Dijkstra正确计算最短路径", {
  local({
    source("R/utils.R")
    source("R/dijkstra.R")
    load('tests/test.Rdata')
    source("data/config.R")
    adjMatrix <- edgeList_to_adjMatrix(edges, n = num)
    
    # 抑制输出
    sink(tempfile())
    result <- Dijkstra(m, num, adjMatrix)
    sink()
    expect_equal(result, 16)
  })
})