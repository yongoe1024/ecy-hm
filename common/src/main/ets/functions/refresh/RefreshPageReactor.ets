import { RefreshController, RefreshDataSource } from "@abner/refresh";
import { FetchDataBlock, ItemBuilderBlock, PageModel, RefreshPageState } from "./RefreshModel";
import { BusinessError } from "@kit.BasicServicesKit";

/**
 * 分页控制器
 */
export class RefreshPageReactor {
  //分页状态 RefreshListView 穿过来的响应式
  pageState: RefreshPageState = new RefreshPageState(1, 20)
  //分页刷新控制器
  refreshController: RefreshController = new RefreshController()
  //数据懒加载操作对象，执行数据CRUD
  dataSource: RefreshDataSource = new RefreshDataSource()
  // 请求数据
  fetchDataBlock: FetchDataBlock = () => Promise.reject()

  constructor( ) {
    // 手动刷新
    this.refreshController.isAutoRefresh = false
  }

  /**
   * 开始刷新
   */
  private refreshStart() {
    if (this.dataSource.totalCount() == 0) {
      this.pageState.isLoading = true
    } else {
      this.pageState.isLoading = false
    }
    this.pageState.current = 1
    this.pageState.hasMore = true
    this.pageState.isError = false
    this.pageState.isEmpty = false
  }

  /**
   * 刷新结束，更新数据
   */
  private refreshEnd(data: PageModel | undefined) {
    // 结束加载
    this.pageState.isLoading = false
    if (data == undefined) {
      this.pageState.hasMore = false
      this.pageState.isEmpty = false
      this.pageState.isError = true
    } else {
      if (data && Array.isArray(data.list)) {
        this.dataSource.initData(data.list)
        // 是否有数据
        this.pageState.isEmpty = data.total == 0
        this.pageState.isError = false
        // 不为空 && 是否有更多
        if (!this.pageState.isEmpty && data.pages > data.current) {
          this.pageState.hasMore = true
        } else {
          this.pageState.hasMore = false
        }
      } else {
        this.pageState.hasMore = false
        this.pageState.isEmpty = false
        this.pageState.isError = true
      }
    }
  }

  /**
   * 上拉加载
   */
  private loadMoreStart() {
    this.pageState.current++
    this.pageState.hasMore = true
    this.pageState.isError = false
    this.pageState.isLoading = false // 就第一次加载
    this.pageState.isEmpty = false
  }

  /**
   * 上拉加载结束
   */
  private loadMoreEnd(data: PageModel | undefined) {
    this.pageState.isLoading = false
    this.pageState.isEmpty = false
    this.pageState.isError = false

    if (data == undefined) {
      this.pageState.hasMore = false
    } else {
      if (data && Array.isArray(data.list) && data.list.length > 0) {
        this.pageState.hasMore = data.pages > data.current
        this.dataSource.pushDataArray(data.list)
      } else {
        this.pageState.hasMore = false
      }
    }
  }

  public async fetchData(isRefresh: boolean): Promise<RefreshPageState> {
    return new Promise<RefreshPageState>(async (resolve, reject) => {
      if (isRefresh) {
        // 开始加载
        this.refreshStart()
        this.fetchDataBlock(this.pageState, isRefresh)
          .then((result: PageModel) => {
            this.refreshEnd(result)
            resolve(this.pageState)
          }).catch((e: BusinessError) => {
          this.refreshEnd(undefined)
          // 将错误信息带回
          this.handleError(e)
          reject(this.pageState)
        }).finally(() => {
          // 确保关闭下拉刷新
          this.refreshController.finishRefresh();
        })
      } else {
        this.loadMoreStart()
        this.fetchDataBlock(this.pageState, isRefresh)
          .then((result: PageModel) => {
            this.loadMoreEnd(result)
            resolve(this.pageState)
          }).catch((e: BusinessError) => {
          this.loadMoreEnd(undefined)
          // 将错误信息带回
          this.handleError(e)
          reject(this.pageState)
        }).finally(() => {
          // 确保关闭上拉加载
          if (this.pageState.hasMore === false) {
            //没有更多数据数据
            this.refreshController.finishLoadMore(true);
          } else {
            //还有更多数据
            this.refreshController.finishLoadMore(false);
          }
        })
      }
    })
  }

  private handleError(e: BusinessError) {
    if (typeof e?.code === 'number') {
      this.pageState.errorCode = e.code
    }
    if (typeof e?.message === 'string') {
      this.pageState.errorMessage = e.message
    }
  }
}