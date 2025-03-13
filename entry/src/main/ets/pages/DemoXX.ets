import { ListView, RefreshController, RefreshLayout, RefreshPositionEnum } from '@abner/refresh'
import { PageModel, RefreshListView, RefreshPageReactor, RefreshPageState, RefreshParent } from 'common'
import { BusinessError } from '@kit.BasicServicesKit'

/**
 * AUTHOR:AbnerMing
 * DATE:2024/6/20
 * INTRODUCE:任意组件之，使用RefreshLayout做吸顶组件
 * */

@Component
export struct DemoXX {
  refreshPageReactor: RefreshPageReactor = new RefreshPageReactor()
  controller: RefreshController = new RefreshController() //刷新控制器
  @State listPosition: RefreshPositionEnum = RefreshPositionEnum.TOP
  parentReactor: RefreshController = new RefreshController()

  async get(pageState: RefreshPageState): Promise<PageModel> {
    return new Promise(async (resolve, reject) => {
      try {
        let a: string[] = []
        for (let i = 0; i < 20; i++) {
          a.push(i + '')
        }
        // resolve(new PageModel(0, 1, 1, 1, []))
        if(pageState.current==3){
          reject({ code:500, message: ''} as BusinessError)
        }else{
          resolve(new PageModel(11111, 20, pageState.current, 11111, a))
        }
        // reject({ code:500, message: ''} as BusinessError)
        // 错误返回，此处code是返回的 code ，message没啥用
        // reject({ code: 500, message: '请求错误' } as BusinessError)
        // 正确返回，返回 BasePagingModel，后端缺字段无法对应，会导致错误
        // resolve(new PageModel(11111, 20, pageState.current, 11111, a))
      } catch (e) {
        // todo 此处异常看看axios
        reject({ code: e.code, message: e.message } as BusinessError)
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
          // 必须设置 是否为嵌套
          isNest: true,
          // // 必须设置
          onListRefreshPosition: (refreshPosition: RefreshPositionEnum) => {
            this.listPosition = refreshPosition
          },
          reactor: this.refreshPageReactor,
          itemBuilder: this.itemBuilder,
          fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
            return this.get(pageState)
          }
        })
          .height('calc(100% - 50vp)')
      }
    }
  }

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
      // 嵌套吸顶 Demo
      // 警告，一页必须超过一屏的高度，否则出bug
      RefreshParent({
        parentReactor:this.parentReactor,
        childReactor: this.refreshPageReactor,
        listPosition: this.listPosition,
        itemLayout: () => {
          this.itemLayout()
        }
      })
      // 普通list
      // RefreshListView({
      //   reactor: this.refreshPageReactor,
      //   itemBuilder: this.itemBuilder,
      //   fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
      //     return this.get(pageState)
      //   }
      // }).onAppear(() => {
      //   this.refreshPageReactor.fetchData(true)
      // })
    }

  }
}
