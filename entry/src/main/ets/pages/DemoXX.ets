import { ListView, RefreshController, RefreshLayout, RefreshPositionEnum } from '@abner/refresh'
import { PageModel, RefreshListView, RefreshPageReactor, RefreshPageState, RefreshParent } from 'common'
import { BusinessError } from '@kit.BasicServicesKit'

/**
 * AUTHOR:AbnerMing
 * DATE:2024/6/20
 * INTRODUCE:任意组件之，使用RefreshLayout做吸顶组件
 * */

@Entry
@Component
struct StickLayoutViewPage {
  private refreshPageReactor: RefreshPageReactor = new RefreshPageReactor(new RefreshPageState(1, 20))
  controller: RefreshController = new RefreshController() //刷新控制器
  @State listPosition: RefreshPositionEnum = RefreshPositionEnum.TOP

  async get(pageState: RefreshPageState): Promise<PageModel> {
    return new Promise(async (resolve, reject) => {
      try {
        let a: string[] = []
        for (let i = 0; i < 20; i++) {
          a.push(i + '')
        }
        reject({ code: 500, message: '请求错误' } as BusinessError)
        // resolve(new PageModel(11111, 20, pageState.current, 11111, a))
      } catch (e) {
        reject({ code: 500, message: '请求错误' } as BusinessError)
      }
    })
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

      Column() {
        Text("头View")
          .fontColor(Color.White)
          .width("100%")
          .height(50)
          .backgroundColor(Color.Pink)
          .textAlign(TextAlign.Center)
        RefreshListView({
          isNest: true,
          onListRefreshPosition: (refreshPosition: RefreshPositionEnum) => {
            this.listPosition = refreshPosition
          },
          reactor: this.refreshPageReactor,
          itemBuilder: this.itemBuilder,
          fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
            return this.get(pageState)
          }
        }).onAppear(() => {
          this.refreshPageReactor.fetchData(true)
        })
          .height('calc(100% - 50vp)')
      }
    }
  }

  /*
  * Author:AbnerMing
  * Describe:这里仅仅是测试，实际应以业务需求为主，可以是任意得组件视图
  */

  @Builder
  itemBuilder(item: ESObject, index: number) {
    Text("测试数据" + index)
      .width("95%")
      .height(50)
      .margin(10)
      .textAlign(TextAlign.Center)
      .border({ width: 1, color: Color.Pink })
  }

  build() {
    Column() {
      // RefreshParent({
      //   childReactor: this.refreshPageReactor,
      //   listPosition: this.listPosition,
      //   itemLayout: () => {
      //     this.itemLayout()
      //   }
      // })
      RefreshListView({
        // isNest: false,
        // onListRefreshPosition: (refreshPosition: RefreshPositionEnum) => {
        //   this.listPosition = refreshPosition
        // },
        reactor: this.refreshPageReactor,
        itemBuilder: this.itemBuilder,
        fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
          return this.get(pageState)
        }
      }).onAppear(() => {
        this.refreshPageReactor.fetchData(true)
      })
    }

  }
}
