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
import { RefreshHeaderComponent } from "./RefreshHeaderComponent";
import { LoadMoreFooterComponent } from "./LoadMoreFooterComponent";

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
  @State  pageState: RefreshPageState = new RefreshPageState(1, 20)

  aboutToAppear(): void {
    this.reactor.fetchDataBlock = this.fetchDataBlock
    this.reactor.pageState = this.pageState
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
      // refreshHeaderAttribute: (attribute: RefreshHeaderAttr) => {
      //   attribute.height = 118
      // },
      // loadMoreFooterAttribute: (attribute: LoadMoreFooterAttr) => {
      //   attribute.height = 36
      // },
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

