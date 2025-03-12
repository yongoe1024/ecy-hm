import { ListView, RefreshLayout, RefreshPositionEnum } from "@abner/refresh"
import axios from "@ohos/axios"
import { PageModel, RefreshListView, RefreshPageReactor, RefreshPageState } from "common"


@Entry
@Component
struct ListPage {
  private controller: RefreshPageReactor = new RefreshPageReactor()
  @State listPosition: RefreshPositionEnum = RefreshPositionEnum.TOP
  @State listNestedScroll: NestedScrollOptions = {
    scrollForward: NestedScrollMode.PARENT_FIRST,
    scrollBackward: NestedScrollMode.SELF_FIRST
  }
  @State enableScrollInteraction: boolean = true

  @Builder
  itemBuilder(item: ESObject, index: number) {
    Row() {
      Text(index + '')
    }
    .width('80%')
    .height(50)
    .backgroundColor('#f1f1f1')
    .borderWidth(1)
    .borderColor('#000')
    .margin({ top: 10 })
  }

  @Builder
  itemLayout() {
    Column() {
      //可以设置任意的组件视图
      Text("头View")
        .fontColor(Color.White)
        .width("100%")
        .height("30%")
        .backgroundColor(Color.Pink)
        .textAlign(TextAlign.Center)

      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          this.tabLayout()
        }.tabBar("Tab1")

        TabContent() {
          this.tabLayout()
        }.tabBar("Tab2")
      }.height('100%')
    }
  }


  async get(pageState: RefreshPageState): Promise<PageModel> {
    return new Promise(async (resolve, reject) => {
      let res: ESObject =
        await axios.get(`https://tst-audi2c.faw-vw.com/cnapi/v2/feed?current=${pageState.current}&size=${pageState.size}`)
      let data: ESObject = res.data.data
      console.log(data.total + '' + data.size + '' + data.current + '' + data.pages+'')
      if(pageState.current==3){
        resolve(new PageModel(data.total, data.size, data.current, data.pages, data.records))
      }else{
        resolve(new PageModel(data.total, data.size, 1, 1, data.records))
      }
    })
  }



  @Builder
  tabLayout() {
    // RefreshListView({
    //   enableRefresh:false,
    //   enableLoadMore:true,
    //   // 双向绑定
    //   listPosition:this.listPosition,
    //   // 启用滚动交互
    //   enableScrollInteraction:this.enableScrollInteraction,
    //   listNestedScroll:this.listNestedScroll,
    //
    //   reactor: this.controller,
    //   itemBuilder: this.itemBuilder,
    //   fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
    //     return this.get(pageState)
    //   }
    // }).onAppear(() => {
    //   this.controller.fetchData(true)
    // }).height('100%')

  }

  build() {
    Column() {
      // RefreshLayout({
      //   enableLoadMore:false,
      //   itemLayout: () => {
      //     this.itemLayout()
      //   },
      //   //是否顶部吸顶
      //   isRefreshTopSticky: true,
      //   controller: this.controller.refreshController,
      //   //定位位置
      //   refreshPosition: this.listPosition,
      //   enableScrollInteraction: (isInteraction) => {
      //     // 启用滚动交互 一直是true
      //     this.enableScrollInteraction = isInteraction
      //   },
      //
      //   onStickyNestedScroll: (nestedScroll: NestedScrollOptions) => {
      //     // 粘性嵌套滚动
      //     this.listNestedScroll = nestedScroll
      //   },
      //   onRefresh: () => {
      //     this.controller.fetchData(true)
      //   },
      //   onLoadMore: () => {
      //     this.controller.fetchData(false)
      //   }
      // })
    }
    .height('100%')
    .width('100%')
  }
}