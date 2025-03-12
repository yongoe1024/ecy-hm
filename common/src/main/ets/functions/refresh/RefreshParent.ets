import {
  LoadMoreLayoutStatus,
  LoadMoreLayoutStatusModel,
  RefreshController,
  RefreshLayout,
  RefreshLayoutStatusModel,
  RefreshPositionEnum
} from "@abner/refresh"
import { RefreshPageReactor, RefreshPageState } from ".."

/**
 * 分页刷新 嵌套父组件
 */
@Component
export struct RefreshParent {
  // 自身刷新控制器
  parentReactor: RefreshController = new RefreshController()
  //  RefreshListView 刷新控制器
  @Require childReactor: RefreshPageReactor = new RefreshPageReactor()
  @Require @Prop listPosition: RefreshPositionEnum = RefreshPositionEnum.TOP
  // 下拉刷新
  @State enableRefresh: boolean = true
  // 加载更多
  @State enableLoadMore: boolean = true

  // @State @Watch('aa') pageState: RefreshPageState = new RefreshPageState(1, 10)

  // aa(){
  //   console.log(JSON.stringify(this.aa))
  // }

  @Builder
  nullBuilder() {
  }

  aboutToAppear(): void {
    // this.pageState = this.childReactor.pageState
  }

  /**
   * column大头，不许有高度
   */
  @BuilderParam
  itemLayout: () => void = this.nullBuilder

  /**
   * 自定义下拉刷新 备用
   */
  @Builder
  refreshHeader(status: RefreshLayoutStatusModel) {
    LoadingProgress()
  }

  /**
   * 自定义加载更多 备用
   */
  @Builder
  loadMoreFooter(status: LoadMoreLayoutStatusModel) {
    if (status.status !== LoadMoreLayoutStatus.FooterNothing) {
      LoadingProgress().width(80).height(80)
    } else {
      Text('没有更多了')
        .fontColor('#999')
        .fontSize(12)
        .height(64)
    }
  }

  build() {
    RefreshLayout({
      enableRefresh: this.enableRefresh,
      enableLoadMore: this.enableLoadMore,
      itemLayout: this.itemLayout,
      // 不回弹，加载直接显示, 不知道好不好看，先注释
      // slideDisplayLoadData: false,
      controller: this.parentReactor,
      refreshPosition: this.listPosition,
      //是否顶部吸顶 （不知道有没有用）
      isRefreshTopSticky: true,
      // 不能写成箭头函数，有传参
      headerRefreshLayout: this.refreshHeader,
      footerLoadLayout: this.loadMoreFooter,
      onRefresh: () => {
        this.childReactor.fetchData(true)
          .finally(() => {
            this.parentReactor.finishRefresh()
          })
      },
      onLoadMore: () => {
        this.childReactor.fetchData(false)
          .then((page: RefreshPageState) => {
            if (page.hasMore) {
              this.parentReactor.finishLoadMore(false)
            } else {
              this.parentReactor.finishLoadMore(true)
            }
          }).catch(() => {
          this.parentReactor.finishLoadMore(true)
        })
      }
    })
  }
}

