import { EmptyPage, ErrorPage, LoadingPage } from ".."
import { FetchDataBlock, ItemBuilderBlock, RefreshPageState } from "./RefreshModel"
import { RefreshPageReactor } from "./RefreshPageReactor"
import {
  ListView,
  LoadMoreLayoutStatus,
  LoadMoreLayoutStatusModel,
  RefreshHeaderAttr,
  RefreshLayoutStatusModel,
  RefreshPositionEnum
} from '@abner/refresh';

/**
 * 分页刷新组件
 */
@Component
export struct RefreshListView {
  @Builder
  initBuilder() {
  }

  // 列表项
  @BuilderParam itemBuilder: ItemBuilderBlock = this.initBuilder
  // 头部组件
  @BuilderParam headerBuilder: () => void = this.initBuilder
  // 底部组件
  @BuilderParam footerBuilder: () => void = this.initBuilder
  // 空组件
  @BuilderParam emptyBuilder: () => void = this.emptyLayout
  // 错误组件
  @BuilderParam errorBuilder: () => void = this.errorLayout
  // 加载组件
  @BuilderParam loadingBuilder: () => void = this.loadingLayout
  // 下拉刷新
  @State enableRefresh: boolean = true
  // 加载更多
  @State enableLoadMore: boolean = true
  // 请求数据必填
  fetchDataBlock: FetchDataBlock = () => Promise.reject()
  /**
   * 分页逻辑控制中心
   */
  reactor: RefreshPageReactor = new RefreshPageReactor()
  @State @Watch('ss') pageState: RefreshPageState = new RefreshPageState(1, 10)
  /*  嵌套滚动专用   */
  @State isNest: boolean = false
  // 必传
  onListRefreshPosition: (position: RefreshPositionEnum) => void = () => {
  }
  @State listNestedScroll: NestedScrollOptions | undefined = undefined
  @State prohibitRefresh: boolean | undefined = undefined
  @State isRefreshSticky: boolean | undefined = undefined
  @State slideDisplayLoadData: boolean = true

  /*   end    */

  aboutToAppear(): void {
    this.reactor.fetchDataBlock = this.fetchDataBlock
    this.reactor.pageState = this.pageState
    //   如果嵌套
    if (this.isNest) {
      this.slideDisplayLoadData = false
      this.listNestedScroll = {
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      }
      this.prohibitRefresh = true
      this.isRefreshSticky = true
    }
  }

  @Builder
  emptyLayout() {
    EmptyPage()
  }

  @Builder
  loadingLayout() {
    LoadingPage()
  }

  @Builder
  errorLayout() {
    ErrorPage({
      reset: () => {
        this.reactor.fetchData(true)
      }
    })
  }

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
    ListView({
      // 滚动位置，嵌套组件使用
      onListRefreshPosition: this.onListRefreshPosition,
      // 滑动事件优先级
      listNestedScroll: this.listNestedScroll,
      // 嵌套必备，禁止自身刷新
      prohibitRefresh: this.prohibitRefresh,
      // 嵌套必备，防止父元素下拉刷新意外出现
      isRefreshSticky: this.isRefreshSticky,
      /*   以上是嵌套滚动   */
      // 不回弹，加载直接显示, 不知道好不好看，先注释
      // slideDisplayLoadData: true,
      enableRefresh: this.enableRefresh && !this.pageState.isError,
      enableLoadMore: this.enableLoadMore && !this.pageState.isError,
      lazyDataSource: this.reactor.dataSource,
      itemLayout: this.itemBuilder, //条目布局
      controller: this.reactor.refreshController, //控制器，负责关闭下拉和上拉
      lazyCachedCount: 3,
      showEmptyLayout: this.pageState.isEmpty, // 是否显示空
      showLoadingLayout: this.pageState.isLoading, // 是否显示加载
      showErrorLayout: this.pageState.isError, //是否显示加载
      // headerRefreshLayout: this.refreshHeader,
      // footerLoadLayout: this.loadMoreFooter,
      itemHeaderLayout: () => {
        this.headerBuilder()
      },
      itemFooterLayout: () => {
        this.footerBuilder()
      },
      errorLayout: () => {
        this.errorBuilder()
      },
      loadingLayout: () => {
        this.loadingBuilder()
      },
      emptyLayout: () => {
        // 空布局
        this.emptyBuilder()
      },
      onRefresh: () => {
        //下拉刷新
        this.reactor.fetchData(true)
      },
      onLoadMore: () => {
        //上拉加载
        this.reactor.fetchData(false)
      }
    })
  }
}

