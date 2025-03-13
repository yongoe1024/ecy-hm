import {
  LoadMoreFooterAttr,
  LoadMoreLayoutStatusModel,
  RefreshController,
  RefreshHeaderAttr,
  RefreshLayout,
  RefreshLayoutStatusModel,
  RefreshPositionEnum
} from "@abner/refresh"
import { RefreshPageReactor, RefreshPageState } from ".."
import { LoadMoreFooterComponent } from "./LoadMoreFooterComponent"
import { RefreshHeaderComponent } from "./RefreshHeaderComponent"

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
  @State isError: boolean = false
  @State isEmpty: boolean = false

  aboutToAppear(): void {
    this.parentReactor.isAutoRefresh = false
  }

  @Builder
  nullBuilder() {
  }

  @BuilderParam
  itemLayout: () => void = this.nullBuilder

  /**
   * 自定义下拉刷新
   */
  @Builder
  refreshHeader(status: RefreshLayoutStatusModel) {
    RefreshHeaderComponent({ status: status.status })
  }

  /**
   * 自定义加载更多
   */
  @Builder
  loadMoreFooter(status: LoadMoreLayoutStatusModel) {
    LoadMoreFooterComponent({ status: status.status })
  }

  build() {
    RefreshLayout({
      enableRefresh: this.enableRefresh,
      enableLoadMore: this.enableLoadMore && !this.isError &&!this.isEmpty,
      itemLayout: this.itemLayout,
      // 不回弹，加载直接显示, 不知道好不好看，先注释
      // slideDisplayLoadData: false,
      controller: this.parentReactor,
      refreshPosition: this.listPosition,
      //是否顶部吸顶 （不知道有没有用）
      isRefreshTopSticky: true,
      // 不能写成箭头函数，有传参
      // headerRefreshLayout: this.refreshHeader,
      // footerLoadLayout: this.loadMoreFooter,
      // refreshHeaderAttribute: (attribute: RefreshHeaderAttr) => {
      //   attribute.height = 118
      // },
      // loadMoreFooterAttribute: (attribute: LoadMoreFooterAttr) => {
      //   attribute.height = 36
      // },
      onRefresh: () => {
        this.childReactor.fetchData(true)
          .then((page: RefreshPageState) => {
            this.isError = page.isError
            this.isEmpty = page.isEmpty
          })
          .catch((e: RefreshPageState) => {
            this.isError = e.isError
            this.isEmpty = e.isEmpty
          })
          .finally(() => {
            this.parentReactor.finishRefresh()
          })
      },
      onLoadMore: () => {
        this.childReactor.fetchData(false)
          .then((page: RefreshPageState) => {
            this.isError = page.isError
            this.isEmpty = page.isEmpty
            if (page.hasMore) {
              this.parentReactor.finishLoadMore(false)
            } else {
              this.parentReactor.finishLoadMore(true)
            }
          })
          .catch((e: RefreshPageState) => {
            this.isError = e.isError
            this.isEmpty = e.isEmpty
            this.parentReactor.finishLoadMore(true)
          })
      }
    })
      .onAppear(() => {
        this.childReactor.fetchData(true)
          .then((page: RefreshPageState) => {
            this.isError = page.isError
            this.isEmpty = page.isEmpty
            if (page.hasMore) {
              this.parentReactor.finishLoadMore(false)
            } else {
              this.parentReactor.finishLoadMore(true)
            }
          }).catch((e: RefreshPageState) => {
          this.isError = e.isError
          this.isEmpty = e.isEmpty
        })
      })
  }
}

